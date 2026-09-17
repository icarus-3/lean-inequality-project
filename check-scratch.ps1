[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$elanHome = if ($env:ELAN_HOME) { $env:ELAN_HOME } else { 'D:\Lean\elan' }
$lake = Join-Path $elanHome 'bin\lake.exe'

Push-Location $root
try {
    & $lake env lean 'InequalityProject\Scratch.lean'
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Pop-Location
}
