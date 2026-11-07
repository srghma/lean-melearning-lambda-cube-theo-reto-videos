/-
Copyright (c) 2026 Serhii Khoma. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhii Khoma
-/
module

public import Mathlib.Logic.Relation

/-!
  Toy grammar for System λ→ (Simply Typed Lambda Calculus).
  Axis supported: (*, *) — terms depending on terms.
-/

@[expose] public section

namespace LambdaCube.LambdaArrow

inductive Ty : Type where
  | base : Ty
  | arrow : Ty → Ty → Ty
  deriving Repr, DecidableEq

infixr:70 " ⇒ₜ " => Ty.arrow

abbrev Ctx := List Ty

/-- Typed de Bruijn variable: proof that variable with type `τ` is at a position in `Γ`.
    Defined in `Type` so it can be eliminated into `Term` during substitution. -/
inductive Var : Ctx → Ty → Type where
  | head {Γ τ} : Var (τ :: Γ) τ
  | tail {Γ τ S} (v : Var Γ τ) : Var (S :: Γ) τ
  deriving DecidableEq

inductive Term : Ctx → Ty → Type where
  | var {Γ τ} (v : Var Γ τ) : Term Γ τ
  | abs {Γ S τ} (body : Term (S :: Γ) τ) : Term Γ (S ⇒ₜ τ)
  | app {Γ S τ} (f : Term Γ (S ⇒ₜ τ)) (arg : Term Γ S) : Term Γ τ

prefix:71 "ƛ " => Term.abs
infixl:70 " ⬝ " => Term.app

/-! ### De Bruijn index macro -/

open Lean in
/-- Helper that generates `Var` constructors for de Bruijn index `k`. -/
meta def mkVarProof : Nat → MacroM Lean.Term
  | 0     => `(Var.head)
  | k + 1 => do
    let inner ← mkVarProof k
    `(Var.tail $inner)

/-- Macro for de Bruijn variables: `v#0`, `v#1`, `v#2`, ... -/
macro:max "v#" n:num : term => do
  let v ← mkVarProof n.getNat
  `(Term.var $v)

/-! ### 1. Weakening & Substitution -/

/-- A renaming is a context morphism mapping variables in `Γ` to variables in `Δ`. -/
def Rename (Γ Δ : Ctx) := ∀ {τ : Ty}, Var Γ τ → Var Δ τ

/-- Extend a renaming under a binder (`ƛ`). -/
def liftRename {Γ Δ : Ctx} {S : Ty} (ρ : Rename Γ Δ) : Rename (S :: Γ) (S :: Δ)
  | _, Var.head   => Var.head
  | _, Var.tail v => Var.tail (ρ v)

/-- Apply a variable renaming across a term. -/
def rename {Γ Δ : Ctx} (ρ : Rename Γ Δ) : {τ : Ty} → Term Γ τ → Term Δ τ
  | _, Term.var v     => Term.var (ρ v)
  | _, Term.abs body  => Term.abs (rename (liftRename ρ) body)
  | _, Term.app f arg => Term.app (rename ρ f) (rename ρ arg)

/-- Shift/weaken all free variables in a term by 1 (introducing `S` at head of context). -/
def shift {Γ : Ctx} {S : Ty} : {τ : Ty} → Term Γ τ → Term (S :: Γ) τ :=
  rename Var.tail

/-- A substitution maps variables in `Γ` to terms in `Δ`. -/
def Subst (Γ Δ : Ctx) := ∀ {τ : Ty}, Var Γ τ → Term Δ τ

/-- Extend a substitution under a binder (`ƛ`). -/
def liftSubst {Γ Δ : Ctx} {S : Ty} (σ : Subst Γ Δ) : Subst (S :: Γ) (S :: Δ)
  | _, Var.head   => Term.var Var.head
  | _, Var.tail v => shift (σ v)

/-- Apply a substitution to a term. -/
def subst {Γ Δ : Ctx} (σ : Subst Γ Δ) : {τ : Ty} → Term Γ τ → Term Δ τ
  | _, Term.var v     => σ v
  | _, Term.abs body  => Term.abs (subst (liftSubst σ) body)
  | _, Term.app f arg => Term.app (subst σ f) (subst σ arg)

/-- Maps variable `0` to `arg` and decrements all other free variables by 1. -/
def substHead {Γ : Ctx} {S : Ty} (arg : Term Γ S) : Subst (S :: Γ) Γ
  | _, Var.head   => arg
  | _, Var.tail v => Term.var v

/-- Single-variable β-substitution: `body[arg/0]`. -/
def instantiate {Γ : Ctx} {S τ : Ty} (body : Term (S :: Γ) τ) (arg : Term Γ S) : Term Γ τ :=
  subst (substHead arg) body

/-! ### 2. Single-Step Beta Reduction (Beta) -/

/-- 1-step β-reduction relation with full congruences. -/
inductive Beta : {Γ : Ctx} → {τ : Ty} → Term Γ τ → Term Γ τ → Prop where
  | beta {Γ S τ} (body : Term (S :: Γ) τ) (arg : Term Γ S) :
      Beta (Term.app (Term.abs body) arg) (instantiate body arg)
  | lam {Γ S τ} {body body' : Term (S :: Γ) τ} :
      Beta body body' → Beta (Term.abs body) (Term.abs body')
  | app_l {Γ S τ} {f f' : Term Γ (S ⇒ₜ τ)} (arg : Term Γ S) :
      Beta f f' → Beta (Term.app f arg) (Term.app f' arg)
  | app_r {Γ S τ} (f : Term Γ (S ⇒ₜ τ)) {arg arg' : Term Γ S} :
      Beta arg arg' → Beta (Term.app f arg) (Term.app f arg')

infix:50 " ⟶β " => Beta

/-! ### 3. Multi-Step Beta Reduction (BetaStar) -/

/-- Reflexive-Transitive closure using Mathlib's `ReflTransGen`. -/
def BetaStar {Γ : Ctx} {τ : Ty} : Term Γ τ → Term Γ τ → Prop :=
  Relation.ReflTransGen Beta

infix:50 " ⟶*β " => BetaStar

namespace BetaStar

theorem refl {Γ : Ctx} {τ : Ty} (t : Term Γ τ) : t ⟶*β t :=
  Relation.ReflTransGen.refl

theorem step {Γ : Ctx} {τ : Ty} {t u : Term Γ τ} (h : t ⟶β u) : t ⟶*β u :=
  Relation.ReflTransGen.single h

theorem trans {Γ : Ctx} {τ : Ty} {t u v : Term Γ τ} (h1 : t ⟶*β u) (h2 : u ⟶*β v) : t ⟶*β v :=
  Relation.ReflTransGen.trans h1 h2

end BetaStar

/-! ### 4. Beta Equivalence (BetaEquiv) -/

/-- Equivalence closure using Mathlib's `EqvGen`. -/
def BetaEquiv {Γ : Ctx} {τ : Ty} : Term Γ τ → Term Γ τ → Prop :=
  Relation.EqvGen Beta

infix:50 " ≡β " => BetaEquiv

instance (Γ : Ctx) (τ : Ty) : Setoid (Term Γ τ) where
  r := BetaEquiv
  iseqv := Relation.EqvGen.is_equivalence _

namespace BetaEquiv

theorem of_step {Γ : Ctx} {τ : Ty} {t u : Term Γ τ} (h : t ⟶β u) : t ≡β u :=
  Relation.EqvGen.rel _ _ h

theorem of_star {Γ : Ctx} {τ : Ty} {t u : Term Γ τ} (h : t ⟶*β u) : t ≡β u := by
  induction h with
  | refl => exact Relation.EqvGen.refl _
  | tail _ hstep ih => exact Relation.EqvGen.trans _ _ _ ih (of_step hstep)

end BetaEquiv

/-! ### 5. Standard Terms & Church Numerals -/
namespace Term

-- Shortcut for Church Numeral Type: (α ⇒ₜ α) ⇒ₜ α ⇒ₜ α
abbrev NatTy (α : Ty) : Ty := (α ⇒ₜ α) ⇒ₜ α ⇒ₜ α

/-! ### 6. Church Numeral Family for arbitrary `Nat` -/

/-- Iterated application in syntax: `f (f (... (f x)))` repeated `n` times. -/
def churchIter (n : Nat) {α : Ty} {Γ : Ctx} (f : Term Γ (α ⇒ₜ α)) (x : Term Γ α) : Term Γ α :=
  match n with
  | 0     => x
  | n + 1 => f ⬝ churchIter n f x

/-- Embeds any Lean `n : Nat` as a Church numeral in syntax: `ƛf. ƛx. f^[n] x`. -/
def church (n : Nat) {α : Ty} {Γ : Ctx} : Term Γ (NatTy α) :=
  ƛ (ƛ (churchIter n (Term.var (Var.tail Var.head)) (Term.var Var.head)))

-- 1. Identity Function: ƛx. x
-- Type: τ ⇒ₜ τ
def id {τ : Ty} {Γ : Ctx} : Term Γ (τ ⇒ₜ τ) :=
  ƛ v#0

-- 2. Constant Function: ƛx. ƛy. x
-- Type: τ1 ⇒ₜ τ2 ⇒ₜ τ1
def const {τ1 τ2 : Ty} {Γ : Ctx} : Term Γ (τ1 ⇒ₜ τ2 ⇒ₜ τ1) :=
  ƛ (ƛ v#1)

-- 3. Church Numerals
-- Zero: ƛf. ƛx. x
def zero {α : Ty} {Γ : Ctx} : Term Γ (NatTy α) := ƛ (ƛ v#0)

-- One: ƛf. ƛx. f x
def one {α : Ty} {Γ : Ctx} : Term Γ (NatTy α) := ƛ (ƛ (v#1 ⬝ v#0))

-- Two: ƛf. ƛx. f (f x)
def two {α : Ty} {Γ : Ctx} : Term Γ (NatTy α) := ƛ (ƛ (v#1 ⬝ (v#1 ⬝ v#0)))

-- Sanity check: matches your existing definitions definitionally!
example {α : Ty} {Γ : Ctx} : (church 0 : Term Γ (NatTy α)) = Term.zero := rfl
example {α : Ty} {Γ : Ctx} : (church 1 : Term Γ (NatTy α)) = Term.one  := rfl
example {α : Ty} {Γ : Ctx} : (church 2 : Term Γ (NatTy α)) = Term.two  := rfl

-- 4. Church Successor: ƛn. ƛf. ƛx. f (n f x)
def succ {α : Ty} {Γ : Ctx} : Term Γ (NatTy α ⇒ₜ NatTy α) :=
  ƛ (             -- n is v#2 (NatTy α)
    ƛ (           -- f is v#1 (α ⇒ₜ α)
      ƛ (         -- x is v#0 (α)
        v#1 ⬝ ((v#2 ⬝ v#1) ⬝ v#0)
      )
    )
  )

-- 5. Church Addition: ƛm. ƛn. ƛf. ƛx. m f (n f x)
-- Type: NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α
def add {α : Ty} {Γ : Ctx} : Term Γ (NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α) :=
  ƛ (                 -- m is v#3 : NatTy α
    ƛ (               -- n is v#2 : NatTy α
      ƛ (             -- f is v#1 : α ⇒ₜ α
        ƛ (           -- x is v#0 : α
          (v#3 ⬝ v#1) ⬝ ((v#2 ⬝ v#1) ⬝ v#0)
        )
      )
    )
  )

-- 6. Church Multiplication: `ƛm. ƛn. ƛf. ƛx. m (n f) x`
-- but we use η-reduced variant `ƛm. ƛn. ƛf. m (n f)`
-- Type: NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α
def mul {α : Ty} {Γ : Ctx} : Term Γ (NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α) :=
  ƛ (                 -- m is v#2 : NatTy α
    ƛ (               -- n is v#1 : NatTy α
      ƛ (             -- f is v#0 : α ⇒ₜ α
          (v#2 ⬝ (v#1 ⬝ v#0))
        )
      )
    )

-- 5. Terms with Free Variables

-- A term with 2 free variables: (v#1 ⬝ v#0)
-- Context has 2 types: Γ = [α, α ⇒ₜ β]
--   - v#0 has type α       (head of context)
--   - v#1 has type α ⇒ₜ β   (tail)
def freeTerm {α β : Ty} : Term [α, α ⇒ₜ β] β :=
  v#1 ⬝ v#0

-- A term with 1 free variable: ƛy. (y ⬝ v#1)
-- Top context has 1 type: Γ = [α] (free var x0)
-- Inside ƛ, context becomes: (α ⇒ₜ β) :: [α]
--   - v#0 is bound variable y of type α ⇒ₜ β
--   - v#1 is free variable x0 of type α
def boundAndFree {α β : Ty} : Term [α] ((α ⇒ₜ β) ⇒ₜ β) :=
  ƛ (v#0 ⬝ v#1)

end Term

/-! ### 7. Denotational Semantics (Evaluation) -/

namespace TermCorrectness

/-- Denotation of types: `base` maps to `baseTy`, and `σ ⇒ₜ τ` maps to Lean functions. -/
@[simp] def Ty.denote (baseTy : Type) : Ty → Type
  | .base => baseTy
  | .arrow σ τ => denote baseTy σ → denote baseTy τ

/-- An environment maps each free variable in context `Γ` to a value of its denoted type. -/
def Env (baseTy : Type) (Γ : Ctx) : Type :=
  ∀ {τ : Ty}, Var Γ τ → Ty.denote baseTy τ

/-- Extend an environment with a new bound variable at the head. -/
def Env.cons {baseTy : Type} {Γ : Ctx} {S : Ty} (val : Ty.denote baseTy S) (env : Env baseTy Γ) :
    Env baseTy (S :: Γ)
  | _, Var.head   => val
  | _, Var.tail v => env v

/-- Evaluates an STLC term into Lean's mathematical function space. -/
def eval {baseTy : Type} {Γ : Ctx} {τ : Ty}
    (t : Term Γ τ) (env : Env baseTy Γ) : Ty.denote baseTy τ :=
  match t with
  | Term.var v     => env v
  | Term.abs body  => fun x => eval body (env.cons x)
  | Term.app f arg => (eval f env) (eval arg env)

/-! ### 8. Correctness Proof: `Term.add` behaves like `+ Nat` -/

/-- Mathematical iteration in Lean: applies `f`, `n` times to `x`. -/
def iter : Nat → (β → β) → β → β
  | 0,     _, x => x
  | n + 1, f, x => f (iter n f x)

/-- Key algebraic lemma: iterating `n` times, then `m` times
    is iterating `(m + n)` times. -/
theorem iter_add (m n : Nat) (f : β → β) (x : β) :
    iter m f (iter n f x) = iter (m + n) f x := by
  induction m with
  | zero => rw [Nat.zero_add, iter]
  | succ m ih => rw [Nat.succ_add, iter, iter, ih]

/-- Key algebraic lemma for multiplication: iterating `n` times, repeated `m` times,
    is iterating `(m * n)` times. -/
theorem iter_mul (m n : Nat) (f : β → β) (x : β) :
    iter m (iter n f) x = iter (m * n) f x := by
  induction m with
  | zero => rw [Nat.zero_mul, iter, iter]
  | succ m ih =>
    change iter n f (iter m (iter n f) x) = _
    rw [ih, iter_add, Nat.add_comm, ← Nat.succ_mul]

theorem eval_churchIter {baseTy : Type} {Γ : Ctx} {α : Ty} (n : Nat)
    (f : Term Γ (α ⇒ₜ α)) (x : Term Γ α) (env : Env baseTy Γ) :
    eval (Term.churchIter n f x) env = iter n (eval f env) (eval x env) := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [Term.churchIter, eval, iter, ih]

/-- A Church numeral `church n` evaluates precisely to `iter n`. -/
theorem eval_church {baseTy : Type} {Γ : Ctx} {α : Ty} (n : Nat) (env : Env baseTy Γ) :
    eval (Term.church n (α := α) (Γ := Γ)) env = fun f x => iter n f x := by
  funext f x
  simp only [Term.church, eval]
  exact eval_churchIter n
    (Term.var (Var.tail Var.head)) (Term.var Var.head)
    (Env.cons x (Env.cons f env))

/-- `Term.add` evaluates to Church addition `fun m n f x => m f (n f x)`. -/
theorem eval_add {baseTy : Type} {Γ : Ctx} {α : Ty} (env : Env baseTy Γ) :
    eval (Term.add (α := α) (Γ := Γ)) env =
      fun m n f x => m f (n f x) := by
  funext m n f x
  rfl

/-- `Term.mul` evaluates to Church multiplication `fun m n f => m (n f)`. -/
theorem eval_mul {baseTy : Type} {Γ : Ctx} {α : Ty} (env : Env baseTy Γ) :
    eval (Term.mul (α := α) (Γ := Γ)) env =
      fun m n f => m (n f) := by
  funext m n f
  rfl

/-- **Main Addition Theorem**:
Applying `Term.add` to Church numerals `m` and `n` produces
the Church numeral for `m + n` (Lean's native `Nat.add`). -/
theorem add_correct {baseTy : Type} {Γ : Ctx} {α : Ty} (m n : Nat) (env : Env baseTy Γ) :
    eval (Term.add ⬝ Term.church m ⬝ Term.church n (α := α) (Γ := Γ)) env =
      eval (Term.church (m + n) (α := α) (Γ := Γ)) env := by
  funext f x
  simp only [eval, eval_add, eval_church]
  exact iter_add m n f x

/-- **Main Multiplication Theorem**:
Applying `Term.mul` to Church numerals `m` and `n` produces
the Church numeral for `m * n` (Lean's native `Nat.mul`). -/
theorem mul_correct {baseTy : Type} {Γ : Ctx} {α : Ty} (m n : Nat) (env : Env baseTy Γ) :
    eval (Term.mul ⬝ Term.church m ⬝ Term.church n (α := α) (Γ := Γ)) env =
      eval (Term.church (m * n) (α := α) (Γ := Γ)) env := by
  funext f x
  simp only [eval, eval_mul, eval_church]
  exact iter_mul m n f x

end TermCorrectness

end LambdaCube.LambdaArrow

-- TODO: Prove that NO Term Can Compute 2ⁿ (Schwichtenberg. L2 allows only polynomials)




-- inductive SeqTerm : Ctx → Ty → Type where
--   /-- Axiom / Identity:
--       ------------- (Ax)
--         Γ, A ⊢ A
--   -/
--   | ax {Γ τ} (v : Var Γ τ) : SeqTerm Γ τ
--
--   /-- Right Implication (⇒_R):
--         Γ, A ⊢ B
--       ------------- (⇒_R)
--        Γ ⊢ A ⇒ₜ B
--   -/
--   | right_arrow {Γ S τ} (body : SeqTerm (S :: Γ) τ) : SeqTerm Γ (S ⇒ₜ τ)
--
--   /-- Left Implication (⇒_L):
--       Given a function variable `f : S ⇒ₜ τ` in Γ,
--       provide an argument `S`, and continue with `τ` added to the context.
--         Γ ⊢ S     Γ, τ ⊢ C
--       ---------------------- (⇒_L)
--          Γ, (S ⇒ₜ τ) ⊢ C
--   -/
--   | left_arrow {Γ S τ C}
--       (f : Var Γ (S ⇒ₜ τ))
--       (arg : SeqTerm Γ S)
--       (cont : SeqTerm (τ :: Γ) C) : SeqTerm Γ C
--
--   /-- Cut Rule:
--       Proves a lemma `S` and substitutes it into `cont`.
--         Γ ⊢ S     Γ, S ⊢ C
--       ---------------------- (Cut)
--                Γ ⊢ C
--   -/
--   | cut {Γ S C}
--       (lemma : SeqTerm Γ S)
--       (cont : SeqTerm (S :: Γ) C) : SeqTerm Γ C
--
--
-- /-- Embedding Natural Deduction into Sequent Calculus -/
-- def toSequent : {Γ : Ctx} → {τ : Ty} → Term Γ τ → SeqTerm Γ τ
--   | _, _, Term.var v     => SeqTerm.ax v
--   | _, _, Term.abs body  => SeqTerm.right_arrow (toSequent body)
--   | _, _, Term.app f arg =>
--       -- Cut the function f into a Left-implication on the top of the context
--       SeqTerm.cut (toSequent f) (
--         SeqTerm.left_arrow Var.head
--           (shiftSeq (toSequent arg))
--           (SeqTerm.ax Var.head)
--       )
--
-- mutual
--   -- Commands: A term meeting an evaluation context (Cut)
--   inductive Command : Ctx → Type where
--     | cut {Γ τ} (t : Term Γ τ) (e : CoTerm Γ τ) : Command Γ
--
--   -- Terms: Right rules (producers)
--   inductive Term : Ctx → Ty → Type where
--     | ax {Γ τ} (v : Var Γ τ) : Term Γ τ
--     | abs {Γ S τ} (c : Command (S :: Γ)) : Term Γ (S ⇒ₜ τ)
--
--   -- CoTerms / Evaluation contexts: Left rules (consumers)
--   inductive CoTerm : Ctx → Ty → Type where
--     | top {Γ τ} : CoTerm (τ :: Γ) τ
--     | arg {Γ S τ} (arg : Term Γ S) (k : CoTerm Γ τ) : CoTerm Γ (S ⇒ₜ τ)
-- end
