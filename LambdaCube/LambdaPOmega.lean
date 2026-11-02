/-
  LambdaCube/LambdaPOmega.lean

  System λP_ω_ (Dependent Types with Type Operators).
  Combining λP (dependent types) and λ_ω_ (type constructors).

  Lecture references:
  - Lecture 11: "The Extension λP (Lambda P) (5)"
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertex λP_ω_)
    Slide 3: Table of Dependencies:
             λP_ω_ : (*, *), (□, □), (*, □)
             terms-depending-on-terms +
             types-depending-on-types +
             types-depending-on-terms
    Slide 10: The Lambda-Cube systems summary
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaPOmega

/--
  Rule set for System λP_ω_:
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(□, □)`: types depending on types (type constructors)
  - `(*, □)`: types depending on terms (dependent types)

  Lecture Reference:
  - Lecture 12, Slide 3 & 10: λP_ω_ has (*, *), (□, □), (*, □)
-/
def rules : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.box) ∨
  (s₁ = Univ.star ∧ s₂ = Univ.box)

/--
  Typing judgment specialized for System λP_ω_: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

end LambdaCube.LambdaPOmega
