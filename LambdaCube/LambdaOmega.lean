/-
  LambdaCube/LambdaOmega.lean

  System λ_ω_ (Lambda Weak Omega / System F_ω without polymorphism)
  and System λω (Higher-Order Polymorphic Lambda Calculus).

  Lecture references:
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)",
    Slide 2: System λ_ω_ = λ→ + types-depending-on-types
    Slide 4: Kinds (*, K₁ → K₂) and constructors
    Slide 5: The Four Levels of a Lambda Term (Term, Type/Constructor, Kind, Sort)
    Slide 6: Beta-Reduction on Constructors
    Slide 7 & 13: Derivation Rules, Formation (form)* and (form)□: (□, □)
    Slide 16: Type Conversion Rule
    Slide 19: The Higher-Order Polymorphic Lambda Calculus λω
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertices λ_ω_ and λω)
    Slide 3: Table of Dependencies:
             λ_ω_ : (*, *), (□, □)
             λω   : (*, *), (□, *), (□, □)
    Slide 5 (a)/(b): Formation rules for λ_ω_: (*, *) and (□, □)
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaOmega

/--
  Rule set for System λ_ω_ (weak omega):
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(□, □)`: types depending on types (type constructors / operators)

  Lecture Reference:
  - Lecture 10, Slide 2, 7 & 13: λ_ω_ : (*, *) and (□, □)
  - Lecture 12, Slide 3 & 5: λ_ω_ : (*, *) and (□, □)
-/
def rulesWeak : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.box)

/--
  Rule set for full System λω (higher-order polymorphic lambda calculus):
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(□, *)`: terms depending on types (polymorphism)
  - `(□, □)`: types depending on types (type operators)

  Lecture Reference:
  - Lecture 10, Slide 19: Higher-Order Polymorphic Lambda Calculus
  - Lecture 12, Slide 3: λω : (*, *), (□, *), (□, □)
-/
def rulesFull : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.box)

/-- Default rules for LambdaOmega file is λ_ω_ as primary vertex. -/
def rules : RuleSet := rulesWeak

/--
  Typing judgment for System λ_ω_: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

/--
  Typing judgment for full System λω: `Γ ⊢ M : A`.
-/
def TypingFullJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rulesFull Γ M A

/--
  Example constructor in λ_ω_:
  Identity type operator `λα:*. α : * → *`.

  Lecture Reference:
  - Lecture 10, Slide 4 & 5: (λβ:* . β) : * → *
-/
def typeIdOp {n : Nat} : Term n :=
  Term.lam (Term.sort Univ.star) (Term.var ⟨0, Nat.succ_pos n⟩)

/--
  Kind `* → *` of the identity type operator.
-/
def typeIdOpKind {n : Nat} : Term n :=
  arrow (Term.sort Univ.star) (Term.sort Univ.star)

end LambdaCube.LambdaOmega
