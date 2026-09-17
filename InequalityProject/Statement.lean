import Mathlib

/-!
# The fixed mathematical statement for the proof-search benchmark.

This file is the specification and should not be changed while searching for
a proof in `Solution.lean`.
-/

set_option autoImplicit false

namespace InequalityProject

def target : Prop :=
  ∀ a b c d : ℝ,
    1 ≤ a →
    1 ≤ b →
    1 ≤ c →
    1 ≤ d →
    (
        Real.sqrt (a * b - 1) / a
      + Real.sqrt (b * c - 1) / b
      + Real.sqrt (c * d - 1) / c
      + Real.sqrt (d * a - 1) / d
      + (a * b - 2)^2 / (21 * a^2 * b^2)
      + (b * c - 2)^2 / (21 * b^2 * c^2)
      + (c * d - 2)^2 / (21 * c^2 * d^2)
      + (d * a - 2)^2 / (21 * d^2 * a^2)
    )
    ≤
      Real.sqrt (a * c)
      + Real.sqrt (b * d)

end InequalityProject
