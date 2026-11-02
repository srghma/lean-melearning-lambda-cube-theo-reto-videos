/-
  LambdaCube/Common/Substitution.lean

  Renaming, lifting, substitution, and β-reduction / conversion for well-scoped terms.

  Lecture references:
  - Lecture 02: "Introduction to the Untyped λ-Calculus (1.1)", Slide 8 "Substitution"
  - Lecture 03: "β-Reduction in the Untyped λ-Calculus (1.2)", Slide 3 "One-Step β-Reduction",
    Slide 4 "Many-Step β-Reduction", Slide 6 "β-Conversion"
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)", Slide 4 & 7
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)", Slide 6 "Beta-Reduction"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 6 "Beta-Reduction on Constructors",
    Slide 16 "Conversion Rule"
  - Lecture 11: "The Extension λP (Lambda P) (5)", Slide 8 "(appl) Rule: B[x := N]"
  - Lecture 12: "The Lambda Cube and λC (6)", Slide 6 "Derivation Rules: (appl) and (conv)"
-/

import LambdaCube.Common.Syntax

namespace LambdaCube

/--
  Renaming / variable re-indexing: Given an index mapping `ρ : Fin m → Fin n`,
  maps free variables in `Term m` to variables in `Term n`.
-/
def rename {m n : Nat} (ρ : Fin m → Fin n) : Term m → Term n
  | Term.var i => Term.var (ρ i)
  | Term.sort s => Term.sort s
  | Term.pi A B =>
    let ρ_ext : Fin (m + 1) → Fin (n + 1) := fun i =>
      match i with
      | ⟨0, _⟩ => ⟨0, Nat.succ_pos n⟩
      | ⟨k + 1, hk⟩ =>
        have hkm : k < m := Nat.lt_of_succ_lt_succ hk
        let res := ρ ⟨k, hkm⟩
        ⟨res.val + 1, Nat.succ_lt_succ res.isLt⟩
    Term.pi (rename ρ A) (rename ρ_ext B)
  | Term.lam A b =>
    let ρ_ext : Fin (m + 1) → Fin (n + 1) := fun i =>
      match i with
      | ⟨0, _⟩ => ⟨0, Nat.succ_pos n⟩
      | ⟨k + 1, hk⟩ =>
        have hkm : k < m := Nat.lt_of_succ_lt_succ hk
        let res := ρ ⟨k, hkm⟩
        ⟨res.val + 1, Nat.succ_lt_succ res.isLt⟩
    Term.lam (rename ρ A) (rename ρ_ext b)
  | Term.app M N => Term.app (rename ρ M) (rename ρ N)

/--
  Weaken / lift variables by 1: maps variables `i` to `i + 1`.
  Used when entering a binder or extending context.
-/
def lift {n : Nat} (t : Term n) : Term (n + 1) :=
  rename (fun i => ⟨i.val + 1, Nat.succ_lt_succ i.isLt⟩) t

/--
  Parallel substitution / instantiation:
  Given a valuation `σ : Fin m → Term n`, replaces each free variable in `Term m` by a term in `Term n`.
-/
def substVar {m n : Nat} (σ : Fin m → Term n) : Term m → Term n
  | Term.var i => σ i
  | Term.sort s => Term.sort s
  | Term.pi A B =>
    let σ_ext : Fin (m + 1) → Term (n + 1) := fun i =>
      match i with
      | ⟨0, _⟩ => Term.var ⟨0, Nat.succ_pos n⟩
      | ⟨k + 1, hk⟩ =>
        have hkm : k < m := Nat.lt_of_succ_lt_succ hk
        lift (σ ⟨k, hkm⟩)
    Term.pi (substVar σ A) (substVar σ_ext B)
  | Term.lam A b =>
    let σ_ext : Fin (m + 1) → Term (n + 1) := fun i =>
      match i with
      | ⟨0, _⟩ => Term.var ⟨0, Nat.succ_pos n⟩
      | ⟨k + 1, hk⟩ =>
        have hkm : k < m := Nat.lt_of_succ_lt_succ hk
        lift (σ ⟨k, hkm⟩)
    Term.lam (substVar σ A) (substVar σ_ext b)
  | Term.app M N => Term.app (substVar σ M) (substVar σ N)

/--
  Single substitution: replaces variable 0 in `t : Term (n + 1)` with `s : Term n`,
  and decrements remaining variables by 1.
  This corresponds directly to `t[0 := s]`.

  Lecture Reference:
  - Lecture 02, Slide 8: Substitution M[x := N]
  - Lecture 12, Slide 6: Rule (appl) uses B[x := N]
-/
def subst {n : Nat} (s : Term n) (t : Term (n + 1)) : Term n :=
  let σ : Fin (n + 1) → Term n := fun i =>
    match i with
    | ⟨0, _⟩ => s
    | ⟨k + 1, hk⟩ =>
      have hkn : k < n := Nat.lt_of_succ_lt_succ hk
      Term.var ⟨k, hkn⟩
  substVar σ t

/--
  Arrow notation helper (constructs non-dependent Π-type `A → B`).
  `B` in scope `n` is lifted to scope `n + 1` so that variable 0 is not used in `B`.

  Lecture Reference:
  - Lecture 06, Slide 3 (b): Arrow types A → B
  - Lecture 12, Slide 5 (a) & (b): A → B is Πx:A. B when x ∉ fv(B)
-/
def arrow {n : Nat} (A B : Term n) : Term n :=
  Term.pi A (lift B)

/--
  One-step β-reduction relation `M →_β N`.

  Lecture Reference:
  - Lecture 03, Slide 3: (λx. M) N →_β M[x := N], plus compatibility rules
  - Lecture 08, Slide 6: β-reduction for type application and terms
  - Lecture 10, Slide 6: β-reduction on constructors
  - Lecture 12, Slide 6: β-reduction in λC
-/
inductive Step : {n : Nat} → Term n → Term n → Prop
  /-- The fundamental β-reduction rule: `(λ A. b) N →_β b[0 := N]` -/
  | beta {n : Nat} (A : Term n) (b : Term (n + 1)) (N : Term n) :
      Step (Term.app (Term.lam A b) N) (subst N b)
  /-- Compatibility: left operand of application -/
  | app_left {n : Nat} {M M' : Term n} (N : Term n) :
      Step M M' → Step (Term.app M N) (Term.app M' N)
  /-- Compatibility: right operand of application -/
  | app_right {n : Nat} (M : Term n) {N N' : Term n} :
      Step N N' → Step (Term.app M N) (Term.app M N')
  /-- Compatibility: domain type of lambda abstraction -/
  | lam_domain {n : Nat} {A A' : Term n} (b : Term (n + 1)) :
      Step A A' → Step (Term.lam A b) (Term.lam A' b)
  /-- Compatibility: body of lambda abstraction -/
  | lam_body {n : Nat} (A : Term n) {b b' : Term (n + 1)} :
      Step b b' → Step (Term.lam A b) (Term.lam A b')
  /-- Compatibility: domain type of Pi product -/
  | pi_domain {n : Nat} {A A' : Term n} (B : Term (n + 1)) :
      Step A A' → Step (Term.pi A B) (Term.pi A' B)
  /-- Compatibility: codomain of Pi product -/
  | pi_codomain {n : Nat} (A : Term n) {B B' : Term (n + 1)} :
      Step B B' → Step (Term.pi A B) (Term.pi A B')

/--
  Multi-step β-reduction `M →_β* N`: reflexive-transitive closure of `Step`.

  Lecture Reference:
  - Lecture 03, Slide 4: "Many-Step β-Reduction: Reflexive transitive closure of →_β"
  - Lecture 12, Slide 8: "A →_β* A'"
-/
inductive Reduces : {n : Nat} → Term n → Term n → Prop
  | refl {n : Nat} (M : Term n) : Reduces M M
  | step {n : Nat} {M N P : Term n} : Step M N → Reduces N P → Reduces M P

/--
  β-conversion / equivalence `M =_β N`: reflexive, symmetric, and transitive closure of `Step`.

  Lecture Reference:
  - Lecture 03, Slide 6: "Two-Way Computation: β-Conversion"
  - Lecture 10, Slide 16: "Conversion Rule: A =_β B"
  - Lecture 12, Slide 6: "(conv) rule if B =_β B'"
-/
inductive BetaEq : {n : Nat} → Term n → Term n → Prop
  | of_step {n : Nat} {M N : Term n} : Step M N → BetaEq M N
  | refl {n : Nat} (M : Term n) : BetaEq M M
  | symm {n : Nat} {M N : Term n} : BetaEq M N → BetaEq N M
  | trans {n : Nat} {M N P : Term n} : BetaEq M N → BetaEq N P → BetaEq M P

end LambdaCube
