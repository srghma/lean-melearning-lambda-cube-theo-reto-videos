/-
  LambdaCube/LambdaP.lean

  System λP (Dependent Types / Logical Framework LF).

  Lecture references:
  - Lecture 11: "The Extension λP (Lambda P) (5)",
    Slide 2: The Missing Piece (Types depending on Terms)
    Slide 3: Types depending on terms (vectors, predicates)
    Slide 4: Pi-types (again) (Πx:A. B)
    Slide 5: Practical example
    Slide 7: Formation rule for λP: (*, □)
    Slide 8: Application rule
    Slide 9: Abstraction rule
    Slide 10: Derivation Rules (Complete λP)
    Slide 11: Conclusions (Dependent types, λP = λ→ + types-depending-on-terms)
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertex λP)
    Slide 3: Table of Dependencies (λP : (*, *), (*, □))
    Slide 5 (a)/(b): Formation rules for λP: (*, *) and (*, □)
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaP

/--
  Rule set for System λP:
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(*, □)`: types depending on terms (dependent types / type families)

  Lecture Reference:
  - Lecture 11, Slide 7 & 10: λP : (*, *) and (*, □)
  - Lecture 12, Slide 3 & 5: λP : (*, *) and (*, □)
-/
def rules : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.star ∧ s₂ = Univ.box)

/--
  Typing judgment specialized for System λP: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

/--
  A dependent type family kind: `A → *` (i.e. `Π (x : A). *`), representing a family of types indexed by term `A`.
  Lecture Reference:
  - Lecture 11, Slide 3: Type families indexed by terms (e.g. Vec : Nat → *)
-/
def typeFamilyKind {n : Nat} (A : Term n) : Term n :=
  Term.pi A (Term.sort Univ.star)

end LambdaCube.LambdaP
