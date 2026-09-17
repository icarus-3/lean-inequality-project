[CmdletBinding()]
param(
    [switch] $Development
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$elanHome = if ($env:ELAN_HOME) { $env:ELAN_HOME } else { 'D:\Lean\elan' }
$lake = Join-Path $elanHome 'bin\lake.exe'
$baseline = 'D:\Lean\benchmark-baselines\inequality-project.json'

if (-not (Test-Path -LiteralPath $lake)) {
    throw "lake was not found at $lake. Check ELAN_HOME."
}

Push-Location $root
$probe = Join-Path $root '.verify-axioms.lean'

try {
    Write-Host '== benchmark integrity =='
    if (-not (Test-Path -LiteralPath $baseline)) {
        throw "Frozen benchmark baseline was not found at $baseline"
    }

    $baselineData = Get-Content -LiteralPath $baseline -Raw -Encoding utf8 | ConvertFrom-Json
    foreach ($entry in $baselineData.files.psobject.Properties) {
        $relativePath = $entry.Name
        $expectedHash = ([string]$entry.Value).ToLowerInvariant()
        $filePath = Join-Path $root ($relativePath -replace '/', '\')

        if (-not (Test-Path -LiteralPath $filePath)) {
            throw "Benchmark integrity failed: missing $relativePath"
        }

        $actualHash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actualHash -ne $expectedHash) {
            $message = "Benchmark integrity changed: $relativePath`nExpected: $expectedHash`nActual:   $actualHash"
            if ($Development) {
                Write-Warning $message
            } else {
                throw $message
            }
        } else {
            Write-Host "OK $relativePath ($actualHash)"
        }
    }

    Write-Host '== lake build =='
    & $lake build
    if ($LASTEXITCODE -ne 0) { throw "lake build failed with exit code $LASTEXITCODE" }

    Write-Host '== compile Solution.lean directly =='
    & $lake env lean 'InequalityProject\Solution.lean'
    if ($LASTEXITCODE -ne 0) { throw "Solution.lean failed to compile" }

    $solutionText = Get-Content -LiteralPath 'InequalityProject\Solution.lean' -Raw -Encoding utf8
    if ($solutionText -match '(?i)\bsorry\b') {
        if ($Development) {
            Write-Host 'Development mode: sorry is present, as expected for the placeholder.'
        } else {
            throw 'Final verification failed: Solution.lean contains sorry.'
        }
    }
    if ($solutionText -match '(?i)\badmit\b') {
        throw 'Verification failed: Solution.lean contains admit.'
    }

    $productionFiles = @('InequalityProject.lean')
    $productionFiles += @(Get-ChildItem -LiteralPath 'InequalityProject' -Filter '*.lean' -File -Recurse |
        Where-Object { $_.Name -ne 'Scratch.lean' } |
        Select-Object -ExpandProperty FullName)
    $forbiddenProofTokens = Select-String -Path $productionFiles -Pattern '(?i)\b(sorry|admit)\b'
    if ($forbiddenProofTokens -and -not $Development) {
        throw "Final verification failed: forbidden proof token found:`n$forbiddenProofTokens"
    }

    $axiomDeclarations = Select-String -Path $productionFiles -Pattern '(?im)^\s*axiom\b'
    if ($axiomDeclarations) {
        throw "Verification failed: custom axiom declaration found:`n$axiomDeclarations"
    }

    @(
        'import InequalityProject.Solution'
        '#print axioms InequalityProject.solution'
    ) | ForEach-Object { $_ } | Out-String | ForEach-Object {
        [IO.File]::WriteAllText(
            $probe,
            $_,
            [Text.UTF8Encoding]::new($false)
        )
    }

    Write-Host '== #print axioms solution =='
    $axiomOutput = (& $lake env lean $probe 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0) { throw "axiom probe failed:`n$axiomOutput" }
    Write-Host $axiomOutput
    if ($axiomOutput -match 'sorryAx') {
        if ($Development) {
            Write-Host 'Development mode: sorryAx is present, as expected for the placeholder.'
        } else {
            throw 'Final verification failed: solution depends on sorryAx.'
        }
    }

    $axiomLine = $axiomOutput -split "`r?`n" |
        Where-Object { $_ -match 'depends on axioms:' } |
        Select-Object -First 1
    if ($axiomLine) {
        $axiomNames = (($axiomLine -replace '^.*depends on axioms:\s*\[', '') -replace '\].*$', '') -split ',' |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ }
        $allowedAxioms = @('propext', 'Classical.choice', 'Quot.sound')
        if ($Development) { $allowedAxioms += 'sorryAx' }
        $unexpectedAxioms = @($axiomNames | Where-Object { $_ -notin $allowedAxioms })
        if ($unexpectedAxioms.Count -gt 0) {
            throw "Verification failed: solution depends on non-standard axiom(s): $($unexpectedAxioms -join ', ')"
        }
    }

    Write-Host 'Verification completed successfully.'
    if ($Development) {
        Write-Host 'This was development verification; use .\verify.ps1 for the strict final check.'
    }
}
finally {
    if (Test-Path -LiteralPath $probe) {
        Remove-Item -LiteralPath $probe -Force
    }
    Pop-Location
}
