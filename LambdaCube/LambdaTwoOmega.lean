/-
  LambdaCube/LambdaTwoOmega.lean

  System λ2ω / λω (Higher-Order Polymorphic Lambda Calculus).
  Combining λ2 (polymorphism) and λ_ω_ (type operators).

  Lecture references:
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)",
    Slide 19: The Higher-Order Polymorphic Lambda Calculus λω
    Slide 20: Conclusions
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertex λω)
    Slide 3: Table of Dependencies:
             λω : (*, *), (□, *), (□, □)
             terms-depending-on-terms +
             terms-depending-on-types (polymorphism) +
             types-depending-on-types (type constructors)
    Slide 10: The Lambda-Cube systems summary
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaTwoOmega

/--
  Rule set for System λ2ω (full λω):
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(□, *)`: terms depending on types (polymorphism from λ2)
  - `(□, □)`: types depending on types (constructors from λ_ω_)

  Lecture Reference:
  - Lecture 10, Slide 19: λω combines λ2 and λ_ω_
  - Lecture 12, Slide 3 & 10: λω has (*, *), (□, *), (□, □)
-/
def rules : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.box)

/--
  Typing judgment specialized for System λ2ω: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

end LambdaCube.LambdaTwoOmega
