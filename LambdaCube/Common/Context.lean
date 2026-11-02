/-
  LambdaCube/Common/Context.lean

  Typing contexts for well-scoped terms with de Bruijn indices.

  Lecture references:
  - Lecture 06: "The Simply Typed Lambda Calculus (2.1)", Slide 5 "Derivation - Notation",
    Slide 6 "Derivation - Some Underlining Definitions: Context Γ"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 7, 9 & 11:
    Contexts Γ and rules (var) and (weak)
  - Lecture 12: "The Lambda Cube and λC (6)", Slide 6:
    Context Γ, x:A and empty context ∅
-/

import LambdaCube.Common.Syntax
import LambdaCube.Common.Substitution

namespace LambdaCube

/--
  A typing context `Context n` assigns a type (which is a `Term n`) to each free variable `i : Fin n`.
  In de Bruijn representation:
  - `empty : Context 0`
  - `extend Γ A : Context (n + 1)` adds a variable of type `A : Term n` at de Bruijn index 0,
    with all existing types in `Γ` lifted by 1 into `Term (n + 1)`.
-/
inductive Context : Nat → Type
  | empty : Context 0
  | extend {n : Nat} (Γ : Context n) (A : Term n) : Context (n + 1)

namespace Context

/--
  Lookup the type assigned to variable `i : Fin n` in context `Γ : Context n`.
  - For index `0` in `extend Γ A`: the type is `lift A`.
  - For index `k + 1` in `extend Γ A`: lookup `k` in `Γ`, then `lift` it into scope `n + 1`.

  Lecture Reference:
  - Lecture 06, Slide 6: Context Γ contains x : σ
  - Lecture 12, Slide 6: Derivation rule (var) Γ, x:A ⊢ x : A
-/
def lookup : {n : Nat} → Context n → Fin n → Term n
  | 0, empty, i => i.elim0
  | _ + 1, extend _ A, ⟨0, _⟩ => lift A
  | _ + 1, extend Γ _, ⟨k + 1, hk⟩ =>
    have hkn : k < _ := Nat.lt_of_succ_lt_succ hk
    lift (lookup Γ ⟨k, hkn⟩)

end Context

end LambdaCube
