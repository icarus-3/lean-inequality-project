# Instructions for the proof-search agent

## Goal

Prove `InequalityProject.target` in `InequalityProject/Solution.lean`.
Success means that the Lean kernel accepts the proof and the strict verifier
passes. “The proof looks mathematically convincing” is not success.

## Frozen files: do not modify

Never modify any of these files:

- `InequalityProject/Statement.lean`
- `lean-toolchain`
- `lakefile.toml`
- `lake-manifest.json`
- `D:\Lean\benchmark-baselines\inequality-project.json`

Do not weaken or rewrite `verify.ps1` to make a candidate pass. Do not change
the theorem statement, replace it with a different theorem, or hide an axiom
behind an auxiliary module.

## Files you may modify

- `InequalityProject/Solution.lean`
- `InequalityProject/Scratch.lean`
- `InequalityProject/Lemmas/Candidates.lean`
- `PROGRESS.md`
- concise proof-search notes under `logs/`

Stable reusable facts belong in `Lemmas/Basic.lean`, `Lemmas/Sqrt.lean`, or
`Lemmas/Algebra.lean`; modify those only when the fact has been independently
checked and is genuinely reusable.

## Feedback loop

Use short cycles:

1. State one small conjecture.
2. Write a small `lemma` or `example`.
3. Run Lean immediately.
4. Read the exact error.
5. Repair or discard the idea.
6. Move a verified reusable fact to `Lemmas/` and record it in `PROGRESS.md`.

Do not generate hundreds of lines of speculative proof before compiling.
Prefer explicit hypotheses and small intermediate statements.

Lean is the only judge. Python, SymPy, random sampling, and numerical tests
are allowed only to find counterexamples, test conjectures, guess constants,
or explore equality cases. Every final mathematical fact must be proved again
in Lean.

## Suggested directions

Explore, but do not assume, the following:

- positivity from `a, b, c, d ≥ 1`
- `ab - 1 ≥ 0` and related domain facts
- `Real.sqrt_nonneg` and `Real.sq_sqrt`
- introducing variables for square roots
- clearing positive denominators
- reducing pieces to polynomial or semialgebraic inequalities
- `field_simp`, `ring`, `ring_nf`, `positivity`, `linarith`, `nlinarith`,
  `norm_num`, and `gcongr`
- AM-GM, Cauchy, tangent bounds, and convexity as possible structures

Switch direction when a route repeatedly fails. Do not merely rephrase the
same failed tactic script.

## Memory and failure management

Keep `PROGRESS.md` short and current. Record the current bottleneck, verified
lemmas with file locations, failed routes and their actual failure reasons,
the latest verifier result, and the next concrete experiments. After a
context reset, read it before starting new work.

## Development commands

From `D:\Lean\inequality-project`:

```powershell
lake env lean InequalityProject/Scratch.lean
lake env lean InequalityProject/Lemmas/Basic.lean
lake env lean InequalityProject/Lemmas/Sqrt.lean
lake env lean InequalityProject/Lemmas/Algebra.lean
lake env lean InequalityProject/Lemmas/Candidates.lean
.\check-solution.ps1
.\verify.ps1 -Development
```

Use `Scratch.lean` for disposable experiments. `Candidates.lean` is for
verified but not yet stable candidate facts. `Scratch.lean` is intentionally
excluded from the final proof dependency checks.

## What counts as solved

Announce `SOLVED` only when all of these hold:

1. `Solution.lean` contains no `sorry` or `admit`.
2. `lake build` succeeds.
3. `Solution.lean` compiles directly.
4. `.\verify.ps1` returns success.
5. After the agent stops, the user runs this external final judge from
   outside the project directory:

   ```powershell
   D:\Lean\benchmark-baselines\verify-inequality-project.ps1
   ```

   It must print `EXTERNAL VERIFICATION PASS`.
6. `#print axioms InequalityProject.solution` contains no `sorryAx` and no
   project-defined non-standard axiom.

The standard Lean axioms `propext`, `Classical.choice`, and `Quot.sound` are
allowed. Do not introduce custom axioms, unproved constants, unsafe bypasses,
or theorem weakening.
