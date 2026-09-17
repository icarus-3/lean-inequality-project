# Current Goal

Prove `InequalityProject.target` in `InequalityProject/Solution.lean`.

# Current Status

The benchmark specification and environment hashes are frozen. The formal
solution still contains its intentional `sorry` placeholder. Development
verification passes; strict verification is expected to fail until the proof
is complete.

# Verified Lemmas

| ID | Statement | File | Lean verified | Used by |
|---|---|---|---|---|
| B1 | `1 ≤ x` implies `0 < x` | `InequalityProject/Lemmas/Basic.lean` | yes | available to `Solution` |
| B2 | `1 ≤ x`, `1 ≤ y` imply `0 ≤ x * y - 1` | `InequalityProject/Lemmas/Basic.lean` | yes | available to `Solution` |
| S1 | nonnegativity of `Real.sqrt x` | `InequalityProject/Lemmas/Sqrt.lean` | yes | available to `Solution` |
| S2 | `(Real.sqrt x)^2 = x` for `0 ≤ x` | `InequalityProject/Lemmas/Sqrt.lean` | yes | available to `Solution` |
| A1 | `0 ≤ x^2` over `ℝ` | `InequalityProject/Lemmas/Algebra.lean` | yes | available to `Solution` |

# Useful Transformations

- From `1 ≤ x`, derive positivity before clearing denominators.
- From `1 ≤ x` and `1 ≤ y`, derive `0 ≤ x * y - 1` before using square-root lemmas.
- Keep square-root identities conditional on explicit nonnegativity hypotheses.
- Prefer small lemmas that compile independently over large tactic blocks.

# Failed Approaches

Record each materially distinct route briefly:

- Attempt:
- Why it failed:
- Counterexample found (if any):
- Lean error category:
- Worth retrying:

# Current Bottleneck

No core proof route has been established yet. Do not claim progress on the
target from numerical evidence alone.

# Next Experiments

1. Test one small candidate lemma at a time in `Scratch.lean`.
2. Move only independently verified, reusable facts into `Lemmas/Candidates.lean`.
3. Record failed routes here before changing the decomposition strategy.

# Equality / Boundary Cases

Not yet investigated formally.

# Numerical Observations

Numerical experiments may suggest conjectures, but they are not proofs.

# Last Verification

- `lake build`: passed
- `lake env lean InequalityProject/Solution.lean`: compiles with intentional `sorry`
- `lake env lean InequalityProject/Scratch.lean`: passed
- `.\verify.ps1 -Development`: passed
- `.\verify.ps1`: expected failure because of `sorry` / `sorryAx`
