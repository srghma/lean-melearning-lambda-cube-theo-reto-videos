/-
  Shared substitution and index adjustment operations for de Bruijn indexed terms and types.

  Lecture references:
  - Lecture 02: "Introduction to the Untyped λ-Calculus (1.1)", Slide 8 "Substitution"
  - Lecture 03: "β-Reduction in the Untyped λ-Calculus (1.2)", Slide 3 "One-Step β-Reduction"
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)", Slide 6 "Beta-Reduction"
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)", Slide 6 "Beta-Reduction on Constructors"
-/

import LambdaCube.Common.Syntax

namespace LambdaCube

/--
  Result of substituting an index at `depth`:
  - `hit`: index matched `depth` (substitute the incoming argument)
  - `below i`: index `< depth` (remains unchanged)
  - `above i`: index `> depth` (decrements by 1)
-/
inductive SubstitutedIndex (n : Nat) where
  | hit   : SubstitutedIndex n
  | below : Fin n → SubstitutedIndex n
  | above : Fin n → SubstitutedIndex n

/--
  Compute substitution behavior where depth is safely bounded within the context `Fin (n + 1)`.
-/
def substIndex {n : Nat} (depth : Fin (n + 1)) (i : Fin (n + 1)) : SubstitutedIndex n :=
  if _h_eq : i.val = depth.val then
    SubstitutedIndex.hit
  else if h_lt : i.val < depth.val then
    have h_n : i.val < n := by
      have : depth.val ≤ n := Nat.le_of_lt_succ depth.isLt
      omega
    SubstitutedIndex.below ⟨i.val, h_n⟩
  else
    have _h_gt : depth.val < i.val := by omega
    have h_lt_n : i.val - 1 < n := by
      have : i.val < n + 1 := i.isLt
      omega
    SubstitutedIndex.above ⟨i.val - 1, h_lt_n⟩

-- /--
--   Compute the substitution behavior for a de Bruijn variable `i : Fin (n + 1)`
--   when substituting at `depth : Nat`.
-- -/
-- def substIndex {n : Nat} (depth : Nat) (i : Fin (n + 1)) : SubstitutedIndex n :=
--   if h : depth < n + 1 then
--     substIndexSafe ⟨depth, h⟩ i
--   else if h_lt : i.val < n then
--     SubstitutedIndex.below ⟨i.val, h_lt⟩
--   else
--     -- When depth >= n + 1 and not (i.val < n), since i.val < n + 1 we have i.val = n < depth
--     SubstitutedIndex.hit

end LambdaCube
