/-
  LambdaCube/Common/Syntax.lean

  Formalization of the syntax for the Lambda Cube using de Bruijn indices.
  Lecture reference:
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)", Slide 4 "Definition of Pre-Typed λ-Terms"
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)", Slide 5 "The Calculus λ2"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 4 & 5 "Kinds and Constructors", "The Four Levels of a Lambda Term"
  - Lecture 11: "The Extension λP (Lambda P) (5)", Slide 4 & 10 "Pi-Types", "Derivation Rules"
  - Lecture 12: "The Lambda Cube and λC (6)", Slide 4 & 6 "The Formation Rule - Definition of λC", "Derivation Rules"
-/

namespace LambdaCube

/--
  Sorts in the Lambda Cube:
  - `star` represents `*` (the sort of all types)
  - `box` represents `□` (the sort of all kinds)

  Lecture Reference:
  - Lecture 10, Slide 5: "Definition (Sorts): s ∈ {*, □}"
  - Lecture 12, Slide 4 & 6: (sort) rule ∅ ⊢ * : □
-/
inductive Univ : Type
  | star : Univ
  | box  : Univ
  deriving DecidableEq, Repr

/--
  Terms in the Lambda Cube parameterized by variable scope `n : Nat`.
  `Term n` has variables bounded by `Fin n`.
  - `Term 0` represents closed terms (no free variables).
  - `Term n` for `n > 0` represents open or closed terms with at most `n` free variables.
  Using de Bruijn indices: index 0 refers to the innermost bound variable.

  Lecture Reference:
  - Lecture 02, Slide 3: Formal definition of lambda terms (variables, application, abstraction)
  - Lecture 06, Slide 4: Pre-typed lambda terms (x ∈ V, M N, λx:σ. M)
  - Lecture 08, Slide 5: Second order terms and types (Πα:*. σ)
  - Lecture 10, Slide 4 & 5: Kinds (*, K₁ → K₂) and constructors
  - Lecture 12, Slide 4: Unified syntax for λC (Pseudo-terms: s, x, M N, λx:A. M, Πx:A. B)
-/
inductive Term : Nat → Type
  /-- Variable represented by a de Bruijn index `i : Fin n` -/
  | var  {n : Nat} (i : Fin n) : Term n
  /-- Sort constant: `*` or `□` -/
  | sort {n : Nat} (s : Univ) : Term n
  /-- Dependent product type: `Π (x : A), B` (where B can refer to variable 0 in scope `n + 1`) -/
  | pi   {n : Nat} (A : Term n) (B : Term (n + 1)) : Term n
  /-- Lambda abstraction: `λ (x : A), b` (where b can refer to variable 0 in scope `n + 1`) -/
  | lam  {n : Nat} (A : Term n) (b : Term (n + 1)) : Term n
  /-- Application of term `M` to term `N` -/
  | app  {n : Nat} (M N : Term n) : Term n

end LambdaCube
