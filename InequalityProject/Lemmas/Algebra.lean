/-
Copyright (c) 2026 InequalityProject contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: InequalityProject contributors
-/

import InequalityProject.Statement

/-!
# Elementary algebra lemmas

Small algebraic facts that are safe to reuse while experimenting.
-/

set_option autoImplicit false

namespace InequalityProject.Lemmas

lemma sq_nonneg_real (x : ℝ) : 0 ≤ x ^ 2 := by
  positivity

end InequalityProject.Lemmas
