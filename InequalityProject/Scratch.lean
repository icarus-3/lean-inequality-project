/-
Copyright (c) 2026 InequalityProject contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: InequalityProject contributors
-/

import InequalityProject.Statement
import Mathlib

/-!
# Scratch space

This module is deliberately separate from the formal solution and is reserved
for temporary experiments, intermediate lemmas, and proof-search diagnostics.
-/

set_option autoImplicit false

namespace InequalityProject

example
    (a b : ℝ)
    (ha : 1 ≤ a)
    (hb : 1 ≤ b) :
    0 ≤ a * b - 1 := by
  nlinarith [mul_nonneg (sub_nonneg.mpr ha) (sub_nonneg.mpr hb)]

end InequalityProject
