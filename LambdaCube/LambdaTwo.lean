/-
  LambdaCube/LambdaTwo.lean

  System λ2 (Second-Order Polymorphic Lambda Calculus / System F).

  Lecture references:
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)",
    Slide 3: Polymorphic Identity Function (Λα:*. λx:α. x)
    Slide 4: How to Type Abstraction of Types - Π-types
    Slide 5: The Calculus λ2 (Types T₂, Terms Λ₂)
    Slide 8: Derivation Rules in λ2
    Slide 9: Formation rule for λ2: (□, *)
    Slide 10: Second Order Abstraction
    Slide 11: Second Order Application
  - Lecture 09: "Computing in λ2 (3.2)"
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: The λ-Cube diagram (vertex λ2)
    Slide 3: Table of Dependencies (λ2 : (*, *), (□, *))
             terms-depending-on-terms + terms-depending-on-types
    Slide 5 (a)/(b): Formation rules for λ2: (*, *) and (□, *)
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context
import LambdaCube.Common.Typing

namespace LambdaCube.LambdaTwo

/--
  Rule set for System λ2:
  Allowed sort pairs:
  - `(*, *)`: terms depending on terms
  - `(□, *)`: terms depending on types (polymorphism)

  Lecture Reference:
  - Lecture 08, Slide 9: Formation (□, *)
  - Lecture 12, Slide 3 & 5: λ2 : (*, *) and (□, *)
-/
def rules : RuleSet := fun s₁ s₂ =>
  (s₁ = Univ.star ∧ s₂ = Univ.star) ∨
  (s₁ = Univ.box ∧ s₂ = Univ.star)

/--
  Typing judgment specialized for System λ2: `Γ ⊢ M : A`.
-/
def TypingJudg {n : Nat} (Γ : Context n) (M A : Term n) : Prop :=
  Typing rules Γ M A

/--
  Polymorphic Identity Function:
  `id = λ (α : *). λ (x : α). x`
  Type: `Π (α : *). α → α`

  Lecture Reference:
  - Lecture 08, Slide 3: Polymorphic Identity Function id = λα:*. λx:α. x : Πα:*. α → α
-/
def polyId {n : Nat} : Term n :=
  -- Outer abstraction: λα:*. ...
  Term.lam (Term.sort Univ.star) (
    -- Inner abstraction: λx:α. x
    -- In scope n + 1, α is variable 0
    Term.lam (Term.var ⟨0, Nat.succ_pos n⟩) (
      -- Body: x is variable 0 in scope n + 2
      Term.var ⟨0, Nat.succ_pos (n + 1)⟩
    )
  )

/--
  Type of polymorphic identity function: `Π (α : *). α → α`.
-/
def polyIdType {n : Nat} : Term n :=
  -- Π (α : *). (α → α)
  -- In scope n + 1, α is variable 0.
  -- α → α is Π (x : α). α. Here α lifted to scope n + 2 is variable 1.
  Term.pi (Term.sort Univ.star) (
    Term.pi (Term.var ⟨0, Nat.succ_pos n⟩) (
      Term.var ⟨1, by omega⟩
    )
  )

end LambdaCube.LambdaTwo
