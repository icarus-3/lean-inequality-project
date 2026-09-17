/-
Copyright (c) 2026 InequalityProject contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: InequalityProject contributors
-/

import InequalityProject.Statement

/-!
# Basic domain lemmas

Small reusable consequences of the hypotheses in the frozen statement.
-/

set_option autoImplicit false

namespace InequalityProject.Lemmas

lemma pos_of_one_le {x : ℝ} (hx : 1 ≤ x) : 0 < x := by
  linarith

lemma prod_sub_one_nonneg {x y : ℝ} (hx : 1 ≤ x) (hy : 1 ≤ y) :
    0 ≤ x * y - 1 := by
  nlinarith [mul_nonneg (sub_nonneg.mpr hx) (sub_nonneg.mpr hy)]

end InequalityProject.Lemmas
