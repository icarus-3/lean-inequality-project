/-
Copyright (c) 2026 InequalityProject contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: InequalityProject contributors
-/

import InequalityProject.Statement

/-!
# Square-root lemmas

Small wrappers for the standard square-root facts used during proof search.
-/

set_option autoImplicit false

namespace InequalityProject.Lemmas

lemma sqrt_nonneg' (x : ℝ) : 0 ≤ Real.sqrt x := by
  exact Real.sqrt_nonneg x

lemma sq_sqrt' {x : ℝ} (hx : 0 ≤ x) : (Real.sqrt x) ^ 2 = x := by
  exact Real.sq_sqrt hx

end InequalityProject.Lemmas
