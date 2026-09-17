# Proof-search strategy

This is a workflow guide, not a proof of the benchmark.

## Stage 0: health check

Confirm the frozen statement and environment hashes, then run:

```powershell
.\verify.ps1 -Development
```

If this fails for any reason other than the intentional `sorry`, repair the
workspace before doing mathematics.

## Stage 1: domain facts

Build and verify the basic positivity facts implied by `a, b, c, d ≥ 1`.
Establish the nonnegativity conditions needed by square-root lemmas and by
division or denominator-clearing steps.

## Stage 2: numerical exploration

Use numerical experiments only to explore likely equality cases, boundary
behavior, pairwise decompositions, constants, or counterexamples. Do not copy
numerical conclusions into `Solution.lean` as facts.

## Stage 3: small candidate lemmas

Turn one useful observation into a small Lean statement. Test it in
`Scratch.lean`; move a verified but experimental result to
`Lemmas/Candidates.lean`; move a stable reusable result to the appropriate
stable Lemmas file.

## Stage 4: Lean-friendly rewriting

Gradually transform expressions containing square roots and divisions. Use
explicit nonnegativity hypotheses, square-root identities, positive
denominators, `field_simp`, `ring_nf`, and order tactics where appropriate.

## Stage 5: polynomial reduction

When justified, compress the remaining goal into polynomial or semialgebraic
constraints. Test each reduction as a separate lemma instead of hiding it in
one large proof script.

## Stage 6: composition

Import only verified facts into `Solution.lean`, replace the placeholder in
small increments, and run the development verifier frequently. Run the strict
verifier only when checking a serious completion candidate.

Do not follow the stages mechanically. A shorter verified route may justify
jumping ahead; repeated failures should be summarized in `PROGRESS.md` before
changing strategy.
