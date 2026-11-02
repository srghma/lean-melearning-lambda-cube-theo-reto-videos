/-
  LambdaCube/LambdaC.lean

  System λC (Calculus of Constructions / λP2_ω_).
  The top vertex of the Lambda Cube containing all four axes of dependency.

  Lecture references:
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 1: Title "The Lambda Cube and λC"
    Slide 2: The λ-Cube diagram (top vertex λC)
    Slide 3: The Dependencies of the Lambda-Systems:
             λP2_ω_ = λC : (*, *), (□, *), (□, □), (*, □)
             - term-depending-on-term (from λ→)
             - term-depending-on-type (from λ2)
             - type-depending-on-type (from λ_ω_)
             - type-depending-on-term (from λP)
    Slide 4: The Formation Rule - Definition of λC (General form rule)
    Slide 6: Derivation Rules for λC:
             (sort)  ∅ ⊢ * : □
             (var)   (Γ ⊢ A : s) / (Γ, x : A ⊢ x : A)
             (weak)  (Γ ⊢ A : B    Γ ⊢ C : s) / (Γ, x : C ⊢ A : B)
             (form)  (Γ ⊢ A : s₁   Γ, x : A ⊢ B : s₂) / (Γ ⊢ Π x : A. B : s₂)
             (appl)  (Γ ⊢ M : Π x : A. B    Γ ⊢ N : A) / (Γ ⊢ M N : B[x := N])
             (abst)  (Γ, x : A ⊢ M : B    Γ ⊢ Π x : A. B : s) / (Γ ⊢ λ x : A. M : Π x : A. B)
             (conv)  (Γ ⊢ A : B    Γ ⊢ B' : s) / (Γ ⊢ A : B') if B =_β B'
    Slide 7-9: Properties for λC (Uniqueness of Types, Subject Reduction,
               Church-Rosser, Strong Normalization, Decidability)
    Slide 10: The Lambda-Cube systems summary
  - Lecture 13: "Propositions as Types (7)"
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaC

/--
  Rule set for System λC (Calculus of Constructions):
  All 4 pairs of sorts are allowed:
  - `(*, *)`: terms depending on terms
  - `(□, *)`: terms depending on types
  - `(□, □)`: types depending on types
  - `(*, □)`: types depending on terms

  Lecture Reference:
  - Lecture 12, Slide 3, 4, 6, 10: λC permits all (s₁, s₂) ∈ {*, □}²
-/
def rules : RuleSet := fun _ _ => True

/--
  Typing judgment specialized for System λC: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

end LambdaCube.LambdaC
