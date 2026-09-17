/-
Copyright (c) 2026 InequalityProject contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: InequalityProject contributors
-/

import InequalityProject.Lemmas.Basic

/-!
# Verified candidate lemmas

Facts in this file are exploratory. They compile, but should be promoted to a
stable Lemmas file only after their intended use is clear.
-/

set_option autoImplicit false

namespace InequalityProject.Lemmas

lemma candidate_prod_sub_one_nonneg {x y : ℝ} (hx : 1 ≤ x) (hy : 1 ≤ y) :
    0 ≤ x * y - 1 := by
  exact prod_sub_one_nonneg hx hy

end InequalityProject.Lemmas
