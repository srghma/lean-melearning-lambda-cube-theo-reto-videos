/-
  LambdaCube/LambdaTwoP.lean

  System λP2 (Polymorphic Dependent Types).

  Lecture references:
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertex λP2)
    Slide 3: Table of Dependencies:
             λP2 : (*, *), (□, *), (*, □)
             terms-depending-on-terms +
             terms-depending-on-types (polymorphism) +
             types-depending-on-terms (dependent types)
    Slide 10: Summary table of the Lambda-Cube
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaTwoP

/--
  Rule set for System λP2:
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(□, *)`: terms depending on types (polymorphism)
  - `(*, □)`: types depending on terms (dependent types)

  Lecture Reference:
  - Lecture 12, Slide 3 & 10: λP2 has (*, *), (□, *), and (*, □)
-/
def rules : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.star ∧ s₂ = Univ.box)

/--
  Typing judgment specialized for System λP2: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

end LambdaCube.LambdaTwoP
