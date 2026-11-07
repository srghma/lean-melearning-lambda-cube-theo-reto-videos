/-
  LambdaCube/Common/Syntax.lean

  Shared syntactic infrastructure for the 8 systems of the Lambda Cube.
  Provides sorts, de Bruijn variable helpers, and shared classification.

  Lecture reference:
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)", Slide 4 "Definition of Pre-Typed λ-Terms"
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)", Slide 5 "The Calculus λ2"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 4 & 5 "Kinds and Constructors", "The Four Levels of a Lambda Term"
  - Lecture 11: "The Extension λP (Lambda P) (5)", Slide 4 & 10 "Pi-Types", "Derivation Rules"
  - Lecture 12: "The Lambda Cube and λC (6)", Slide 2 "The Lambda Cube",
    Slide 3 "The Dependencies of the Lambda-Systems",
    Slide 4 "The Formation Rule - Definition of λC"
-/

namespace LambdaCube

/-
  Sorts in the Lambda Cube:
  - `star` represents `*` (the sort of all types)
  - `box` represents `□` (the sort of all kinds)

  Sort pairs `(s₁, s₂)` classifying the 4 axes of dependency in the Lambda Cube:
  - `(*, *)`: term depending on term (present in all 8 systems, base: λ→)
  - `(□, *)`: term depending on type (polymorphism, e.g. λ2, λω, λP2, λC)
  - `(□, □)`: type depending on type (type operators, e.g. λ_ω_, λω, λP_ω_, λC)
  - `(*, □)`: type depending on term (dependent types, e.g. λP, λP2, λP_ω_, λC)
-/

/--
  Shared variable index lifting for de Bruijn indices.
  Lifts an index `i : Fin n` across cutoff `c`.
-/
def liftIndex {n : Nat} (cutoff : Nat) (i : Fin n) : Fin (n + 1) :=
  if i.val < cutoff then
    ⟨i.val, Nat.lt_trans i.isLt (Nat.lt_succ_self n)⟩
  else
    ⟨i.val + 1, Nat.succ_lt_succ i.isLt⟩

end LambdaCube
