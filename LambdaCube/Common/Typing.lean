/-
  LambdaCube/Common/Typing.lean

  General Pure Type System (PTS) typing judgment for the Lambda Cube.

  Lecture references:
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)", Slide 7 "Derivation - Rules"
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)", Slide 8 "Derivation Rules"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 7 "Derivation Rules"
  - Lecture 11: "The Extension λP (Lambda P) (5)", Slide 6 & 10 "Derivation Rules (Complete Lambda P)"
  - Lecture 12: "The Lambda Cube and λC (6)", Slide 4 "The Formation Rule - Definition of λC",
    Slide 5 (a) & (b) "Formation Rules: Concrete / Unified Pi",
    Slide 6 "Derivation Rules" (sort, var, weak, form, appl, abst, conv)
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution
import LambdaCube.Common.Context

namespace LambdaCube

/--
  A specification of allowed formation rules `(s₁, s₂)` for a system in the Lambda Cube.
  Any system in the cube is determined by a subset of `{(*, *), (□, *), (□, □), (*, □)}`.

  Lecture Reference:
  - Lecture 12, Slide 3: Table of Dependencies of the Lambda-Systems
  - Lecture 12, Slide 4 & 5: Formation Rule: (s₁, s₂)
-/
def RuleSet := Univ → Univ → Prop

/--
  The Pure Type System typing judgment `Γ ⊢ M : A` parameterized by a `RuleSet R`.

  Derivation rules directly formalize Slide 6 of Lecture 12 (and corresponding slides in earlier lectures):
  1. (sort) Axiom:
     ∅ ⊢ * : □
     (Lecture 12, Slide 6; Lecture 10, Slide 8)
  2. (var) Variable rule:
     (Γ ⊢ A : s) / (Γ, x : A ⊢ x : A)
     (Lecture 12, Slide 6; Lecture 10, Slide 9)
  3. (weak) Weakening rule:
     (Γ ⊢ M : A    Γ ⊢ C : s) / (Γ, x : C ⊢ lift M : lift A)
     (Lecture 12, Slide 6; Lecture 10, Slide 11)
  4. (form) Formation rule:
     (Γ ⊢ A : s₁    Γ, x : A ⊢ B : s₂) / (Γ ⊢ Π x : A. B : s₂)  if (s₁, s₂) ∈ R
     (Lecture 12, Slide 4, 5, 6; Lecture 11, Slide 7)
  5. (appl) Application rule:
     (Γ ⊢ M : Π x : A. B    Γ ⊢ N : A) / (Γ ⊢ M N : B[0 := N])
     (Lecture 12, Slide 6; Lecture 11, Slide 8; Lecture 08, Slide 8)
  6. (abst) Abstraction rule:
     (Γ, x : A ⊢ M : B    Γ ⊢ Π x : A. B : s) / (Γ ⊢ λ x : A. M : Π x : A. B)
     (Lecture 12, Slide 6; Lecture 11, Slide 9; Lecture 08, Slide 8)
  7. (conv) Conversion rule:
     (Γ ⊢ M : A    Γ ⊢ B : s) / (Γ ⊢ M : B)  if A =_β B
     (Lecture 12, Slide 6; Lecture 10, Slide 16)
-/
inductive Typing (R : RuleSet) : {n : Nat} → Context n → Term n → Term n → Prop
  /--
    (sort) rule:
    ∅ ⊢ * : □
    Lecture 12, Slide 6; Lecture 10, Slide 8
  -/
  | sort :
      Typing R Context.empty (Term.sort Univ.star) (Term.sort Univ.box)

  /--
    (var) rule:
    If Γ ⊢ A : s, then Γ, x : A ⊢ x : A (represented as variable index 0 with type `lift A`)
    Lecture 12, Slide 6; Lecture 10, Slide 9
  -/
  | var {n : Nat} {Γ : Context n} {A : Term n} {s : Univ} :
      Typing R Γ A (Term.sort s) →
      Typing R (Context.extend Γ A) (Term.var ⟨0, Nat.succ_pos n⟩) (lift A)

  /--
    (weak) rule:
    If Γ ⊢ M : A and Γ ⊢ C : s, then Γ, x : C ⊢ lift M : lift A
    Lecture 12, Slide 6; Lecture 10, Slide 11
  -/
  | weak {n : Nat} {Γ : Context n} {M A C : Term n} {s : Univ} :
      Typing R Γ M A →
      Typing R Γ C (Term.sort s) →
      Typing R (Context.extend Γ C) (lift M) (lift A)

  /--
    (form) rule:
    If Γ ⊢ A : s₁ and Γ, x : A ⊢ B : s₂ with (s₁, s₂) ∈ R, then Γ ⊢ Π x : A. B : s₂
    Lecture 12, Slide 4, 5, 6; Lecture 11, Slide 7
  -/
  | form {n : Nat} {Γ : Context n} {A : Term n} {B : Term (n + 1)} {s₁ s₂ : Univ} :
      R s₁ s₂ →
      Typing R Γ A (Term.sort s₁) →
      Typing R (Context.extend Γ A) B (Term.sort s₂) →
      Typing R Γ (Term.pi A B) (Term.sort s₂)

  /--
    (appl) rule:
    If Γ ⊢ M : Π x : A. B and Γ ⊢ N : A, then Γ ⊢ M N : B[0 := N]
    Lecture 12, Slide 6; Lecture 11, Slide 8; Lecture 08, Slide 8
  -/
  | appl {n : Nat} {Γ : Context n} {M N A : Term n} {B : Term (n + 1)} :
      Typing R Γ M (Term.pi A B) →
      Typing R Γ N A →
      Typing R Γ (Term.app M N) (subst N B)

  /--
    (abst) rule:
    If Γ, x : A ⊢ M : B and Γ ⊢ Π x : A. B : s, then Γ ⊢ λ x : A. M : Π x : A. B
    Lecture 12, Slide 6; Lecture 11, Slide 9; Lecture 08, Slide 8
  -/
  | abst {n : Nat} {Γ : Context n} {A : Term n} {M B : Term (n + 1)} {s : Univ} :
      Typing R (Context.extend Γ A) M B →
      Typing R Γ (Term.pi A B) (Term.sort s) →
      Typing R Γ (Term.lam A M) (Term.pi A B)

  /--
    (conv) rule:
    If Γ ⊢ M : A and Γ ⊢ B : s, and A =_β B, then Γ ⊢ M : B
    Lecture 12, Slide 6; Lecture 10, Slide 16
  -/
  | conv {n : Nat} {Γ : Context n} {M A B : Term n} {s : Univ} :
      Typing R Γ M A →
      Typing R Γ B (Term.sort s) →
      BetaEq A B →
      Typing R Γ M B

end LambdaCube
