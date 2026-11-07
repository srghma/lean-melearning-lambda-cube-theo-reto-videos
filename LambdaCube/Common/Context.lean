/-
  Shared context utilities for Lambda Cube systems.

  Lecture references:
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)", Slide 5 "Derivation - Notation",
    Slide 6 "Derivation - Some Underlining Definitions: Context Γ"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 7, 9 & 11
  - Lecture 12: "The Lambda Cube and λC (6)", Slide 6
-/

import LambdaCube.Common.Syntax

namespace LambdaCube

/--
  Intrinsically typed de Bruijn variable proof: variable index into a context list `Γ`.
  Ensures variables refer to valid bindings in `Γ`.
-/
inductive HasVar {α : Type} : List α → α → Type where
  | here {Γ : List α} {T : α} : HasVar (T :: Γ) T
  | there {Γ : List α} {T U : α} (v : HasVar Γ T) : HasVar (U :: Γ) T

end LambdaCube
