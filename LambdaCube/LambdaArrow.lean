/-
  LambdaCube/LambdaArrow.lean

  System λ→ (Simply Typed Lambda Calculus).
  The base vertex of the Lambda Cube.

  Lecture references:
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)",
    Slide 4: Definition of Pre-Typed λ-Terms
    Slide 7: Derivation - Rules
  - Lecture 07: "Properties of the Simply Typed Lambda Calculus (2.2)"
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertex λ→)
    Slide 3: Table of Dependencies (λ→ : (*, *), terms depending on terms)
    Slide 4 & 5 (a)/(b): Formation rule for λ→:
      Γ ⊢ A : *    Γ, x : A ⊢ B : *
      ---------------------------------
              Γ ⊢ A → B : *
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaArrow

/--
  Rule set for System λ→:
  Allowed sort pair: `(*, *)` (terms depending on terms).

  Lecture Reference:
  - Lecture 12, Slide 3 & 5: λ→ : (*, *)
-/
def rules : RuleSet := fun s₁ s₂ =>
  s₁ = Univ.star ∧ s₂ = Univ.star

/--
  Typing judgment specialized for System λ→: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

/--
  In λ→, the only dependency is terms depending on terms:
  Functions accept term arguments and yield term results.
  Example: Identity function on type α, `λ x : α. x : α → α`.
  Lecture Reference:
  - Lecture 06, Slide 4 & 8: (λx : α. x) : α → α
-/
def idTerm {n : Nat} (A : Term n) : Term n :=
  Term.lam A (Term.var ⟨0, Nat.succ_pos n⟩)

end LambdaCube.LambdaArrow
