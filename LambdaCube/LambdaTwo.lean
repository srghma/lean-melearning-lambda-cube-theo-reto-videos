/-
Copyright (c) 2026 Serhii Khoma. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhii Khoma
-/
module

public import Mathlib.Logic.Relation
import Aesop

/-!
  Toy grammar for System λ2 (Second-Order Polymorphic Lambda Calculus / System F).
  Axes supported:
  - (*, *): terms depending on terms (abstraction `ƛ` and application `⬝`)
  - (□, *): terms depending on types (polymorphic abstraction `ƛₜ` and type application `⬝ₜ`)

  Lecture References:
  - Lecture 08: "The Extension λ2 (Lambda Two) (3.1)"
    Slide 3: Polymorphic Identity Function (λα:*. λx:α. x)
    Slide 4: ∀-types (∀α:*. σ)
    Slide 5: The Calculus λ2 (Types T₂, Terms ƛₜ₂)
    Slide 8: Derivation Rules
    Slide 9: Formation rule (□, *)
    Slide 10: Second Order Abstraction
    Slide 11: Second Order Application
  - Lecture 09: "Computing in λ2 (3.2)"
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: Vertex λ2
    Slide 3 & 5 (a): λ2 : (*, *), (□, *)
-/

@[expose] public section

namespace LambdaCube.LambdaTwo

/-! ### 1. Types, renaming and substitution of type variables -/

/-- Types with `k` free type variables, indexed by `Fin k`. -/
inductive Ty : Nat → Type where
  | var     {k : Nat} (i : Fin k) : Ty k
  | arrow   {k : Nat} (domain codomain : Ty k) : Ty k
  | forall_ {k : Nat} (body : Ty (k + 1)) : Ty k
  deriving Repr, DecidableEq

/-
Same as:
inductive Kind where | star : Kind
notation "★" => Kind.star
inductive Ty : Nat → Kind → Type where
  | var     {k : Nat} (i : Fin k) : Ty k ★
  | arrow   {k : Nat} (domain codomain : Ty k ★) : Ty k ★
  | forall_ {k : Nat} (body : Ty (k + 1) ★) : Ty k ★
-/

infixr:70 " ⇒ₜ " => Ty.arrow
prefix:72 "∀ₜ " => Ty.forall_
macro:max "vₜ#" n:num : term => `(Ty.var ⟨$n, by omega⟩)

/-- Extend a renaming of type variables under a type binder. -/
def extFin {k k' : Nat} (ρ : Fin k → Fin k') : Fin (k + 1) → Fin (k' + 1) :=
  Fin.cases (motive := fun _ => Fin (k' + 1)) 0 (fun i => (ρ i).succ)

/-- Rename the free type variables of a type (structurally recursive). -/
def renTy : {k k' : Nat} → (Fin k → Fin k') → Ty k → Ty k'
  | _, _, ρ, .var i        => .var (ρ i)
  | _, _, ρ, .arrow s t    => .arrow (renTy ρ s) (renTy ρ t)
  | _, _, ρ, .forall_ body => .forall_ (renTy (extFin ρ) body)

/-- Weaken a type by one fresh (outermost) type variable. -/
def liftTy {k : Nat} (t : Ty k) : Ty (k + 1) := renTy Fin.succ t

/-- Extend a type substitution under a type binder. -/
def extSub {k k' : Nat} (σ : Fin k → Ty k') : Fin (k + 1) → Ty (k' + 1) :=
  Fin.cases (motive := fun _ => Ty (k' + 1)) (.var 0) (fun i => liftTy (σ i))

/-- Simultaneous substitution of type variables (structurally recursive). -/
def substTy : {k k' : Nat} → (Fin k → Ty k') → Ty k → Ty k'
  | _, _, σ, .var i        => σ i
  | _, _, σ, .arrow s t    => .arrow (substTy σ s) (substTy σ t)
  | _, _, σ, .forall_ body => .forall_ (substTy (extSub σ) body)

/-- Substitution sending variable `0` to `A` and decrementing the others. -/
def singleSub {k : Nat} (A : Ty k) : Fin (k + 1) → Ty k :=
  Fin.cases (motive := fun _ => Ty k) A Ty.var

theorem singleSub_zero {k : Nat} (A : Ty k) : singleSub A 0 = A := by
  simp [singleSub]

theorem singleSub_succ {k : Nat} (A : Ty k) (j : Fin k) : singleSub A j.succ = Ty.var j := by
  simp [singleSub]

theorem extSub_zero {k k' : Nat} (σ : Fin k → Ty k') : extSub σ 0 = Ty.var 0 := by
  simp [extSub]

theorem extSub_succ {k k' : Nat} (σ : Fin k → Ty k') (j : Fin k) :
    extSub σ j.succ = liftTy (σ j) := by
  simp [extSub]

theorem extSub_var {k : Nat} : extSub (fun i : Fin k => (Ty.var i : Ty k)) = fun i => Ty.var i := by
  funext i
  cases i using Fin.cases with
  | zero => simp [extSub]
  | succ j => simp [extSub, liftTy, renTy]

/-- Single-variable type substitution at top level: `body[A/0]`. -/
abbrev instantiateTy {k : Nat} (body : Ty (k + 1)) (A : Ty k) : Ty k :=
  substTy (singleSub A) body

/-! ### 2. Substitution lemmas for types -/

theorem renTy_renTy {k : Nat} (t : Ty k) : ∀ {k' k'' : Nat} (ρ : Fin k → Fin k')
    (ρ' : Fin k' → Fin k''), renTy ρ' (renTy ρ t) = renTy (fun i => ρ' (ρ i)) t := by
  induction t with
  | var i => intros; rfl
  | arrow s t ihs iht => intros; simp only [renTy, ihs, iht]
  | forall_ b ih =>
    intro k' k'' ρ ρ'
    have h : (fun i => extFin ρ' (extFin ρ i)) = extFin (fun i => ρ' (ρ i)) := by
      funext i; cases i using Fin.cases <;> simp [extFin]
    simp only [renTy, ih, h]

theorem substTy_renTy {k : Nat} (t : Ty k) : ∀ {k' k'' : Nat} (ρ : Fin k → Fin k')
    (σ : Fin k' → Ty k''), substTy σ (renTy ρ t) = substTy (fun i => σ (ρ i)) t := by
  induction t with
  | var i => intros; rfl
  | arrow s t ihs iht => intros; simp only [renTy, substTy, ihs, iht]
  | forall_ b ih =>
    intro k' k'' ρ σ
    have h : (fun i => extSub σ (extFin ρ i)) = extSub (fun i => σ (ρ i)) := by
      funext i; cases i using Fin.cases <;> simp [extFin, extSub]
    simp only [renTy, substTy, ih, h]

theorem renTy_liftTy {k k' : Nat} (ρ : Fin k → Fin k') (t : Ty k) :
    renTy (extFin ρ) (liftTy t) = liftTy (renTy ρ t) := by
  unfold liftTy
  rw [renTy_renTy, renTy_renTy]
  congr 1

theorem renTy_substTy {k : Nat} (t : Ty k) : ∀ {k' k'' : Nat} (σ : Fin k → Ty k')
    (ρ : Fin k' → Fin k''), renTy ρ (substTy σ t) = substTy (fun i => renTy ρ (σ i)) t := by
  induction t with
  | var i => intros; rfl
  | arrow s t ihs iht => intros; simp only [substTy, renTy, ihs, iht]
  | forall_ b ih =>
    intro k' k'' σ ρ
    have h : (fun i => renTy (extFin ρ) (extSub σ i)) = extSub (fun i => renTy ρ (σ i)) := by
      funext i
      cases i using Fin.cases with
      | zero => simp [extSub, extFin, renTy]
      | succ j => rw [extSub_succ, extSub_succ, renTy_liftTy]
    simp only [renTy, substTy, ih, h]

theorem substTy_liftTy {k k' : Nat} (σ : Fin k → Ty k') (t : Ty k) :
    substTy (extSub σ) (liftTy t) = liftTy (substTy σ t) := by
  unfold liftTy
  rw [substTy_renTy, renTy_substTy]
  congr 1

theorem substTy_substTy {k : Nat} (t : Ty k) : ∀ {k' k'' : Nat} (σ : Fin k → Ty k')
    (τ : Fin k' → Ty k''), substTy τ (substTy σ t) = substTy (fun i => substTy τ (σ i)) t := by
  induction t with
  | var i => intros; rfl
  | arrow s t ihs iht => intros; simp only [substTy, ihs, iht]
  | forall_ b ih =>
    intro k' k'' σ τ
    have h : (fun i => substTy (extSub τ) (extSub σ i)) = extSub (fun i => substTy τ (σ i)) := by
      funext i
      cases i using Fin.cases with
      | zero => simp [extSub, substTy]
      | succ j => simp only [extSub_succ, substTy_liftTy]
    simp only [substTy, ih, h]

theorem renTy_eq_substTy {k : Nat} (t : Ty k) : ∀ {k' : Nat} (ρ : Fin k → Fin k'),
    renTy ρ t = substTy (fun i => Ty.var (ρ i)) t := by
  induction t with
  | var i => intros; rfl
  | arrow s t ihs iht => intros; simp only [renTy, substTy, ihs, iht]
  | forall_ b ih =>
    intro k' ρ
    have h : (fun i => Ty.var (extFin ρ i)) = extSub (fun i => Ty.var (ρ i)) := by
      funext i
      cases i using Fin.cases with
      | zero => simp [extSub, extFin]
      | succ j => simp [extSub, extFin, liftTy, renTy]
    simp only [renTy, substTy, ih, h]

theorem substTy_var {k : Nat} (t : Ty k) : substTy (fun i => Ty.var i) t = t := by
  induction t with
  | var i => rfl
  | arrow s t ihs iht => simp only [substTy, ihs, iht]
  | forall_ b ih =>
    simp only [substTy, extSub_var, ih]

theorem substTy_succ {k : Nat} (t : Ty k) :
    substTy (fun i => Ty.var i.succ) t = liftTy t := by
  unfold liftTy
  rw [renTy_eq_substTy]

theorem substTy_single_liftTy {k : Nat} (A : Ty k) (t : Ty k) :
    substTy (singleSub A) (liftTy t) = t := by
  unfold liftTy
  rw [substTy_renTy]
  have h : (fun i : Fin k => singleSub A i.succ) = fun i => Ty.var i := by
    funext i; simp [singleSub]
  rw [h, substTy_var]

theorem substTy_instantiateTy {k k' : Nat} (σ : Fin k → Ty k') (τ : Ty (k + 1)) (A : Ty k) :
    substTy σ (instantiateTy τ A) = instantiateTy (substTy (extSub σ) τ) (substTy σ A) := by
  simp only [instantiateTy]
  rw [substTy_substTy, substTy_substTy]
  congr 1
  funext i
  cases i using Fin.cases with
  | zero => rw [singleSub_zero, extSub_zero]; simp [singleSub_zero, substTy]
  | succ j => rw [singleSub_succ, extSub_succ, substTy_single_liftTy]; rfl

/-! ### 3. Term contexts & variables -/

/-- Context of term assumptions carrying types with `k` free type variables. -/
abbrev Ctx (k : Nat) := List (Ty k)

/-- Lifts every type in the context when introducing a new type variable. -/
def liftCtx (k : Nat) (Γ : Ctx k) : Ctx (k + 1) :=
  Γ.map liftTy

/-- Typed de Bruijn variable proof in context `Γ`. -/
inductive Var : {k : Nat} → Ctx k → Ty k → Type where
  | head {k} {Γ : Ctx k} {τ : Ty k} : Var (τ :: Γ) τ
  | tail {k} {Γ : Ctx k} {τ S : Ty k} (v : Var Γ τ) : Var (S :: Γ) τ

/-- Transport a variable along any map on types. -/
def mapVar {k k' : Nat} (f : Ty k → Ty k') :
    {Γ : Ctx k} → {τ : Ty k} → Var Γ τ → Var (Γ.map f) (f τ)
  | _, _, Var.head   => Var.head
  | _, _, Var.tail v => Var.tail (mapVar f v)

/-- Transport a variable under type lifting. -/
def liftCtxVar {k : Nat} {Γ : Ctx k} {τ : Ty k} (v : Var Γ τ) : Var (liftCtx k Γ) (liftTy τ) :=
  mapVar liftTy v

/-! ### 4. Terms -/

/-- System F intrinsically typed terms. -/
inductive Term : (k : Nat) → Ctx k → Ty k → Type where
  | var  {k Γ τ} (v : Var Γ τ) : Term k Γ τ
  | abs  {k Γ S τ} (body : Term k (S :: Γ) τ) : Term k Γ (S ⇒ₜ τ)
  | app  {k Γ S τ} (f : Term k Γ (S ⇒ₜ τ)) (arg : Term k Γ S) : Term k Γ τ
  | tabs {k Γ τ} (body : Term (k + 1) (liftCtx k Γ) τ) : Term k Γ (∀ₜ τ)
  | tapp {k Γ τ} (f : Term k Γ (∀ₜ τ)) (argTy : Ty k) : Term k Γ (instantiateTy τ argTy)

prefix:71 "ƛ "  => Term.abs
infixl:70 " ⬝ "  => Term.app
prefix:71 "ƛₜ "  => Term.tabs
infixl:70 " ⬝ₜ " => Term.tapp

/-! ### De Bruijn index macro -/

open Lean in
meta def mkVarProof : Nat → MacroM Lean.Term
  | 0     => `(Var.head)
  | n + 1 => do
    let inner ← mkVarProof n
    `(Var.tail $inner)

/-- Macro for de Bruijn variables: `v#0`, `v#1`, `v#2`, ... -/
macro:max "v#" n:num : term => do
  let v ← mkVarProof n.getNat
  `(Term.var $v)

/-- Transport a term along equalities of its context and its type. -/
def castTerm {k : Nat} {Γ Γ' : Ctx k} {τ τ' : Ty k} (hΓ : Γ = Γ') (hτ : τ = τ')
    (t : Term k Γ τ) : Term k Γ' τ' := by
  subst hΓ; subst hτ; exact t

/-! ### 5. Substituting types inside terms -/

theorem map_liftCtx_substTy {k k' : Nat} (σ : Fin k → Ty k') (Γ : Ctx k) :
    (liftCtx k Γ).map (substTy (extSub σ)) = liftCtx k' (Γ.map (substTy σ)) := by
  induction Γ with
  | nil => rfl
  | cons S Γ ih => simp only [liftCtx, List.map_cons, substTy_liftTy] at ih ⊢; rw [ih]

theorem map_liftCtx_single {k : Nat} (A : Ty k) (Γ : Ctx k) :
    (liftCtx k Γ).map (substTy (singleSub A)) = Γ := by
  induction Γ with
  | nil => rfl
  | cons S Γ ih =>
    simp only [liftCtx, List.map_cons, substTy_single_liftTy] at ih ⊢; rw [ih]

theorem map_substTy_succ {k : Nat} (Γ : Ctx k) :
    Γ.map (substTy (fun i => Ty.var i.succ)) = liftCtx k Γ := by
  induction Γ with
  | nil => rfl
  | cons S Γ ih =>
    simp only [liftCtx, List.map_cons, substTy_succ] at ih ⊢; rw [ih]

/-- Apply a type substitution `σ` throughout a term. -/
def tySubstTerm : {k k' : Nat} → (σ : Fin k → Ty k') → {Γ : Ctx k} → {τ : Ty k} →
    Term k Γ τ → Term k' (Γ.map (substTy σ)) (substTy σ τ)
  | _, _, σ, _, _, Term.var v        => Term.var (mapVar (substTy σ) v)
  | _, _, σ, _, _, Term.abs body     => Term.abs (tySubstTerm σ body)
  | _, _, σ, _, _, Term.app f arg    => Term.app (tySubstTerm σ f) (tySubstTerm σ arg)
  | _, _, σ, _, _, Term.tabs body    =>
    Term.tabs (castTerm (map_liftCtx_substTy σ _) rfl (tySubstTerm (extSub σ) body))
  | _, _, σ, _, _, @Term.tapp _ _ τ f A =>
    castTerm rfl (substTy_instantiateTy σ τ A).symm
      (Term.tapp (τ := substTy (extSub σ) τ) (tySubstTerm σ f) (substTy σ A))

/-- Lifts type variables in a term when moving under a type binder. -/
def liftTermTy {k : Nat} {Γ : Ctx k} {τ : Ty k} (t : Term k Γ τ) :
    Term (k + 1) (liftCtx k Γ) (liftTy τ) :=
  castTerm (map_substTy_succ Γ) (substTy_succ τ) (tySubstTerm (fun i => Ty.var i.succ) t)

/-- Type-level substitution into a term: `body[A/0]`. -/
def instantiateTermTy {k : Nat} {Γ : Ctx k} {τ : Ty (k + 1)} (A : Ty k)
    (body : Term (k + 1) (liftCtx k Γ) τ) : Term k Γ (instantiateTy τ A) :=
  castTerm (map_liftCtx_single A Γ) rfl (tySubstTerm (singleSub A) body)

/-! ### 6. Renaming & substitution of term variables -/

/-- Term renaming morphism. -/
def Rename {k : Nat} (Γ Δ : Ctx k) := ∀ {τ : Ty k}, Var Γ τ → Var Δ τ

def liftRename {k : Nat} {Γ Δ : Ctx k} {S : Ty k} (ρ : Rename Γ Δ) : Rename (S :: Γ) (S :: Δ)
  | _, Var.head   => Var.head
  | _, Var.tail v => Var.tail (ρ v)

/-- Lifts a term renaming across a type-lifted context. -/
def liftCtxRename {k : Nat} : {Γ Δ : Ctx k} → Rename Γ Δ → Rename (liftCtx k Γ) (liftCtx k Δ)
  | [],      _, _, _, v => by cases v
  | _ :: _,  _, ρ, _, Var.head =>
    liftCtxVar (ρ Var.head)
  | _ :: _,  _, ρ, _, Var.tail v' =>
    liftCtxRename (fun vt => ρ (Var.tail vt)) v'

/-- Apply variable renaming across a term. -/
def rename {k : Nat} {Γ Δ : Ctx k} (ρ : Rename Γ Δ) : {τ : Ty k} → Term k Γ τ → Term k Δ τ
  | _, Term.var v        => Term.var (ρ v)
  | _, Term.abs body     => Term.abs (rename (liftRename ρ) body)
  | _, Term.app f arg    => Term.app (rename ρ f) (rename ρ arg)
  | _, Term.tabs body    => Term.tabs (rename (liftCtxRename ρ) body)
  | _, Term.tapp f argTy => Term.tapp (rename ρ f) argTy

/-- Shifts all free term variables by 1. -/
def shift {k : Nat} {Γ : Ctx k} {S : Ty k} : {τ : Ty k} → Term k Γ τ → Term k (S :: Γ) τ :=
  rename Var.tail

/-- A substitution maps term variables in `Γ` to terms in `Δ`. -/
def Subst {k : Nat} (Γ Δ : Ctx k) := ∀ {τ : Ty k}, Var Γ τ → Term k Δ τ

/-- Extend a substitution under a term binder (`ƛ`). -/
def liftSubst {k : Nat} {Γ Δ : Ctx k} {S : Ty k} (σ : Subst Γ Δ) : Subst (S :: Γ) (S :: Δ)
  | _, Var.head   => Term.var Var.head
  | _, Var.tail v => shift (σ v)

/-- Lifts a term substitution across a type-lifted context (i.e. under a `ƛₜ`). -/
def liftCtxSubst {k : Nat} : {Γ Δ : Ctx k} → Subst Γ Δ → Subst (liftCtx k Γ) (liftCtx k Δ)
  | [],      _, _, _, v => by cases v
  | _ :: _,  _, σ, _, Var.head =>
    liftTermTy (σ Var.head)
  | _ :: _,  _, σ, _, Var.tail v' =>
    liftCtxSubst (fun vt => σ (Var.tail vt)) v'

/-- Apply a term substitution to a term. -/
def subst {k : Nat} {Γ Δ : Ctx k} (σ : Subst Γ Δ) : {τ : Ty k} → Term k Γ τ → Term k Δ τ
  | _, Term.var v        => σ v
  | _, Term.abs body     => Term.abs (subst (liftSubst σ) body)
  | _, Term.app f arg    => Term.app (subst σ f) (subst σ arg)
  | _, Term.tabs body    => Term.tabs (subst (liftCtxSubst σ) body)
  | _, Term.tapp f argTy => Term.tapp (subst σ f) argTy

/-- Maps variable `0` to `arg` and decrements all others. -/
def substHead {k : Nat} {Γ : Ctx k} {S : Ty k} (arg : Term k Γ S) : Subst (S :: Γ) Γ
  | _, Var.head   => arg
  | _, Var.tail v => Term.var v

/-- Single-variable term β-substitution: `body[arg/0]`. -/
def instantiate {k : Nat} {Γ : Ctx k} {S τ : Ty k} (body : Term k (S :: Γ) τ)
    (arg : Term k Γ S) : Term k Γ τ :=
  subst (substHead arg) body

/-! ### 7. Single-Step Beta Reduction (Beta) -/

/-- 1-step β-reduction relation for System F. -/
inductive Beta : {k : Nat} → {Γ : Ctx k} → {τ : Ty k} → Term k Γ τ → Term k Γ τ → Prop where
  -- Term β-reduction: (ƛ body) ⬝ arg ⟶β body[arg/0]
  | beta {k Γ S τ} (body : Term k (S :: Γ) τ) (arg : Term k Γ S) :
      Beta (Term.app (Term.abs body) arg) (instantiate body arg)
  -- Type β-reduction: (ƛₜ body) ⬝ₜ A ⟶β body[A/0]
  | betaTy {k Γ τ} (body : Term (k + 1) (liftCtx k Γ) τ) (argTy : Ty k) :
      Beta (Term.tapp (Term.tabs body) argTy) (instantiateTermTy argTy body)
  -- Congruence rules
  | lam {k Γ S τ} {body body' : Term k (S :: Γ) τ} :
      Beta body body' → Beta (Term.abs body) (Term.abs body')
  | app_l {k Γ S τ} {f f' : Term k Γ (S ⇒ₜ τ)} (arg : Term k Γ S) :
      Beta f f' → Beta (Term.app f arg) (Term.app f' arg)
  | app_r {k Γ S τ} (f : Term k Γ (S ⇒ₜ τ)) {arg arg' : Term k Γ S} :
      Beta arg arg' → Beta (Term.app f arg) (Term.app f arg')
  | tabs {k Γ τ} {body body' : Term (k + 1) (liftCtx k Γ) τ} :
      Beta body body' → Beta (Term.tabs body) (Term.tabs body')
  | tapp {k Γ τ} {f f' : Term k Γ (∀ₜ τ)} (argTy : Ty k) :
      Beta f f' → Beta (Term.tapp f argTy) (Term.tapp f' argTy)

infix:50 " ⟶β " => Beta

/-! ### 8. Multi-Step Beta Reduction (BetaStar) -/

abbrev BetaStar {k : Nat} {Γ : Ctx k} {τ : Ty k} : Term k Γ τ → Term k Γ τ → Prop :=
  Relation.ReflTransGen Beta

infix:50 " ⟶*β " => BetaStar

namespace BetaStar

theorem lam {k Γ S τ} {body body' : Term k (S :: Γ) τ} (h : body ⟶*β body') :
    (ƛ body : Term k Γ (S ⇒ₜ τ)) ⟶*β (ƛ body') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.lam hstep)

theorem app_l {k Γ S τ} {f f' : Term k Γ (S ⇒ₜ τ)} (arg : Term k Γ S) (h : f ⟶*β f') :
    (f ⬝ arg) ⟶*β (f' ⬝ arg) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.app_l arg hstep)

theorem app_r {k Γ S τ} (f : Term k Γ (S ⇒ₜ τ)) {arg arg' : Term k Γ S} (h : arg ⟶*β arg') :
    (f ⬝ arg) ⟶*β (f ⬝ arg') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.app_r f hstep)

theorem tabs {k Γ τ} {body body' : Term (k + 1) (liftCtx k Γ) τ} (h : body ⟶*β body') :
    (ƛₜ body : Term k Γ (∀ₜ τ)) ⟶*β (ƛₜ body') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.tabs hstep)

theorem tapp {k Γ τ} {f f' : Term k Γ (∀ₜ τ)} (argTy : Ty k) (h : f ⟶*β f') :
    (f ⬝ₜ argTy) ⟶*β (f' ⬝ₜ argTy) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.tapp argTy hstep)

end BetaStar

/-! ### 9. Beta Equivalence (BetaEquiv) -/

abbrev BetaEquiv {k : Nat} {Γ : Ctx k} {τ : Ty k} : Term k Γ τ → Term k Γ τ → Prop :=
  Relation.EqvGen Beta

infix:50 " ≡β " => BetaEquiv

instance (k : Nat) (Γ : Ctx k) (τ : Ty k) : Setoid (Term k Γ τ) :=
  Relation.EqvGen.setoid Beta

namespace BetaEquiv

theorem lam {k Γ S τ} {body body' : Term k (S :: Γ) τ} (h : body ≡β body') :
    (ƛ body : Term k Γ (S ⇒ₜ τ)) ≡β (ƛ body') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.lam hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_l {k Γ S τ} {f f' : Term k Γ (S ⇒ₜ τ)} (arg : Term k Γ S) (h : f ≡β f') :
    (f ⬝ arg) ≡β (f' ⬝ arg) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.app_l arg hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_r {k Γ S τ} (f : Term k Γ (S ⇒ₜ τ)) {arg arg' : Term k Γ S} (h : arg ≡β arg') :
    (f ⬝ arg) ≡β (f ⬝ arg') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.app_r f hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem tabs {k Γ τ} {body body' : Term (k + 1) (liftCtx k Γ) τ} (h : body ≡β body') :
    (ƛₜ body : Term k Γ (∀ₜ τ)) ≡β (ƛₜ body') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.tabs hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem tapp {k Γ τ} {f f' : Term k Γ (∀ₜ τ)} (argTy : Ty k) (h : f ≡β f') :
    (f ⬝ₜ argTy) ≡β (f' ⬝ₜ argTy) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.tapp argTy hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

end BetaEquiv

/-! ### 10. Standard System F Terms -/
namespace Term

/-- Polymorphic Identity Type: `∀ α. α ⇒ₜ α` -/
abbrev PolyIdTy {k : Nat} : Ty k := ∀ₜ (vₜ#0 ⇒ₜ vₜ#0)

/-- Polymorphic Identity Function: `ƛₜ α. ƛ (x : α). x` -/
def polyId {k : Nat} {Γ : Ctx k} : Term k Γ PolyIdTy :=
  ƛₜ (ƛ v#0)

/-- Church Boolean Type: `∀ α. α ⇒ₜ α ⇒ₜ α` -/
abbrev BoolTy {k : Nat} : Ty k := ∀ₜ (vₜ#0 ⇒ₜ vₜ#0 ⇒ₜ vₜ#0)

/-- `true = ƛₜ α. ƛ x. ƛ y. x` -/
def tru {k : Nat} {Γ : Ctx k} : Term k Γ BoolTy :=
  ƛₜ (ƛ (ƛ v#1))

/-- `false = ƛₜ α. ƛ x. ƛ y. y` -/
def fls {k : Nat} {Γ : Ctx k} : Term k Γ BoolTy :=
  ƛₜ (ƛ (ƛ v#0))

/-- Church Numeral Type in System F: `∀ α. (α ⇒ₜ α) ⇒ₜ α ⇒ₜ α` -/
abbrev NatTy {k : Nat} : Ty k :=
  ∀ₜ ((vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0)

/-- Iterated application in syntax: `f (f (... (f x)))` repeated `n` times. -/
def churchIter (n : Nat) {k : Nat} {Γ : Ctx k} {α : Ty k}
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) : Term k Γ α :=
  match n with
  | 0     => x
  | n + 1 => f ⬝ churchIter n f x

/-- Embeds any Lean `n : Nat` as a polymorphic Church numeral in System F:
    `ƛₜ α. ƛ (f : α ⇒ₜ α). ƛ (x : α). f^[n] x` -/
def church (n : Nat) {k : Nat} {Γ : Ctx k} : Term k Γ NatTy :=
  ƛₜ (ƛ (ƛ (churchIter n v#1 v#0)))

@[simp] theorem churchIter_zero {k : Nat} {Γ : Ctx k} {α : Ty k}
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) : churchIter 0 f x = x := rfl

@[simp] theorem churchIter_succ (n : Nat) {k : Nat} {Γ : Ctx k} {α : Ty k}
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) :
    churchIter (n + 1) f x = f ⬝ churchIter n f x := rfl

@[simp] theorem churchIter_one {k : Nat} {Γ : Ctx k} {α : Ty k}
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) :
    churchIter 1 f x = f ⬝ x := rfl

/-- Church zero: `ƛₜ α. ƛ f. ƛ x. x` -/
def zero {k : Nat} {Γ : Ctx k} : Term k Γ NatTy := church 0

/-- Church one: `ƛₜ α. ƛ f. ƛ x. f x` -/
def one {k : Nat} {Γ : Ctx k} : Term k Γ NatTy := church 1

/-- Church two: `ƛₜ α. ƛ f. ƛ x. f (f x)` -/
def two {k : Nat} {Γ : Ctx k} : Term k Γ NatTy := church 2

/-- Church three: `ƛₜ α. ƛ f. ƛ x. f (f (f x))` -/
def three {k : Nat} {Γ : Ctx k} : Term k Γ NatTy := church 3

/-- Church four: `ƛₜ α. ƛ f. ƛ x. f (f (f (f x)))` -/
def four {k : Nat} {Γ : Ctx k} : Term k Γ NatTy := church 4

/-- Church addition: `ƛ m. ƛ n. ƛₜ α. ƛ f. ƛ x. m [α] f (n [α] f x)` -/
def add {k : Nat} {Γ : Ctx k} : Term k Γ (NatTy ⇒ₜ NatTy ⇒ₜ NatTy) :=
  ƛ (
    ƛ (
      ƛₜ (
        ƛ (
          ƛ (
            ((v#3 ⬝ₜ vₜ#0) ⬝ v#1) ⬝ (((v#2 ⬝ₜ vₜ#0) ⬝ v#1) ⬝ v#0)
          )
        )
      )
    )
  )

/-- Church multiplication: `ƛ m. ƛ n. ƛₜ α. ƛ f. ƛ x. m [α] (n [α] f) x` but `x` is η-reduced out -/
def mul {k : Nat} {Γ : Ctx k} : Term k Γ (NatTy ⇒ₜ NatTy ⇒ₜ NatTy) :=
  ƛ (
    ƛ (
      ƛₜ (
        ƛ (
          (v#2 ⬝ₜ vₜ#0) ⬝ ((v#1 ⬝ₜ vₜ#0) ⬝ v#0)
        )
      )
    )
  )

/-- Church successor: `ƛ (n : NatTy). ƛₜ α. ƛ (f : α ⇒ₜ α). ƛ (x : α). f (n [α] f x)` -/
def succ {k : Nat} {Γ : Ctx k} : Term k Γ (NatTy ⇒ₜ NatTy) :=
  ƛ (
    ƛₜ (
      ƛ (
        ƛ (
          v#1 ⬝ (((v#2 ⬝ₜ vₜ#0) ⬝ v#1) ⬝ v#0)
        )
      )
    )
  )

end Term

/-! ### 11. Sanity checks -/

/-- `polyId [A]` β-reduces (type application of a polymorphic abstraction). -/
example {k : Nat} {Γ : Ctx k} (A : Ty k) :
    (Term.polyId (Γ := Γ) ⬝ₜ A) ⟶β instantiateTermTy A (ƛ v#0) :=
  Beta.betaTy _ A

/-- `(ƛ x. x) y ⟶β y` with a free variable. -/
example {k : Nat} {S : Ty k} {Γ : Ctx k} :
    ((ƛ v#0 : Term k (S :: Γ) (S ⇒ₜ S)) ⬝ v#0) ⟶β v#0 :=
  Beta.beta (v#0) (v#0)

/-- `succ` is a closed System F term at any scope. -/
example {k : Nat} : Term k [] (Term.NatTy ⇒ₜ Term.NatTy) := Term.succ

/-! ### 12. Arithmetic Correctness Proofs for Add and Mul -/

/-- Head reduction of addition: `add ⬝ m ⬝ n ⟶*β ...` unfolds to the addition body. -/
theorem add_head_reduce {k : Nat} {Γ : Ctx k} (m n : Term k Γ Term.NatTy) :
    (Term.add ⬝ m ⬝ n) ⟶*β
      instantiate (subst (liftSubst (substHead m))
        (ƛₜ (ƛ (ƛ (((v#3 ⬝ₜ vₜ#0) ⬝ v#1) ⬝ (((v#2 ⬝ₜ vₜ#0) ⬝ v#1) ⬝ v#0)))))) n :=
  (BetaStar.app_l n (.single (Beta.beta _ m))).trans (.single (Beta.beta _ n))

/-- Head reduction of multiplication: `mul ⬝ m ⬝ n ⟶*β ...` unfolds to the multiplication body. -/
theorem mul_head_reduce {k : Nat} {Γ : Ctx k} (m n : Term k Γ Term.NatTy) :
    (Term.mul ⬝ m ⬝ n) ⟶*β
      instantiate (subst (liftSubst (substHead m))
        (ƛₜ (ƛ ((v#2 ⬝ₜ vₜ#0) ⬝ ((v#1 ⬝ₜ vₜ#0) ⬝ v#0))))) n :=
  (BetaStar.app_l n (.single (Beta.beta _ m))).trans (.single (Beta.beta _ n))

/-! ### 12'. Church numerals are closed terms -/

theorem churchIter_add {k : Nat} {Γ : Ctx k} {α : Ty k} (m n : Nat)
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) :
    Term.churchIter m f (Term.churchIter n f x) = Term.churchIter (m + n) f x := by
  induction m with
  | zero =>
    exact (congrArg (fun j => Term.churchIter j f x) (Nat.zero_add n)).symm
  | succ m ih =>
    have hmn : m + 1 + n = (m + n) + 1 := by omega
    rw [hmn]
    exact congrArg (Term.app f) ih

theorem rename_churchIter {k : Nat} {Γ Δ : Ctx k} {α : Ty k} (ρ : Rename Γ Δ) (n : Nat)
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) :
    rename ρ (Term.churchIter n f x) = Term.churchIter n (rename ρ f) (rename ρ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (rename ρ f)) ih

theorem subst_churchIter {k : Nat} {Γ Δ : Ctx k} {α : Ty k} (σ : Subst Γ Δ) (n : Nat)
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) :
    subst σ (Term.churchIter n f x) = Term.churchIter n (subst σ f) (subst σ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (subst σ f)) ih

theorem tySubst_churchIter {k k' : Nat} (σ : Fin k → Ty k') {Γ : Ctx k} {α : Ty k} (n : Nat)
    (f : Term k Γ (α ⇒ₜ α)) (x : Term k Γ α) :
    tySubstTerm σ (Term.churchIter n f x) =
      Term.churchIter n (tySubstTerm σ f) (tySubstTerm σ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (tySubstTerm σ f)) ih

theorem castTerm_churchBody {k : Nat} {Δ Δ' : Ctx k} {α : Ty k} (h : Δ = Δ') (n : Nat) :
    castTerm h rfl (ƛ (ƛ (Term.churchIter n v#1 v#0)) : Term k Δ ((α ⇒ₜ α) ⇒ₜ α ⇒ₜ α)) =
      (ƛ (ƛ (Term.churchIter n v#1 v#0)) : Term k Δ' ((α ⇒ₜ α) ⇒ₜ α ⇒ₜ α)) := by
  subst h; rfl

theorem castTerm_church {k : Nat} {Δ Δ' : Ctx k} (h : Δ = Δ') (m : Nat) :
    castTerm h rfl (Term.church m : Term k Δ Term.NatTy) =
      (Term.church m : Term k Δ' Term.NatTy) := by
  subst h; rfl

theorem rename_church {k : Nat} {Γ Δ : Ctx k} (ρ : Rename Γ Δ) (m : Nat) :
    rename ρ (Term.church m : Term k Γ Term.NatTy) = Term.church m :=
  congrArg Term.tabs (congrArg Term.abs (congrArg Term.abs (rename_churchIter _ m _ _)))

theorem shift_church {k : Nat} {Γ : Ctx k} {S : Ty k} (m : Nat) :
    (shift (Term.church m : Term k Γ Term.NatTy) : Term k (S :: Γ) Term.NatTy) =
      Term.church m :=
  rename_church Var.tail m

theorem subst_church {k : Nat} {Γ Δ : Ctx k} (σ : Subst Γ Δ) (m : Nat) :
    subst σ (Term.church m : Term k Γ Term.NatTy) = Term.church m :=
  congrArg Term.tabs (congrArg Term.abs (congrArg Term.abs (subst_churchIter _ m _ _)))

theorem tySubst_churchBody {k k' : Nat} (σ : Fin k → Ty k') {Γ : Ctx k} {α : Ty k} (n : Nat) :
    tySubstTerm σ (ƛ (ƛ (Term.churchIter n v#1 v#0)) : Term k Γ ((α ⇒ₜ α) ⇒ₜ α ⇒ₜ α)) =
      (ƛ (ƛ (Term.churchIter n v#1 v#0)) :
        Term k' (Γ.map (substTy σ))
          ((substTy σ α ⇒ₜ substTy σ α) ⇒ₜ substTy σ α ⇒ₜ substTy σ α)) :=
  congrArg Term.abs (congrArg Term.abs (tySubst_churchIter σ n _ _))

theorem tySubstTerm_church {k k' : Nat} (σ : Fin k → Ty k') {Γ : Ctx k} (m : Nat) :
    tySubstTerm σ (Term.church m : Term k Γ Term.NatTy) =
      (Term.church m : Term k' (Γ.map (substTy σ)) (substTy σ Term.NatTy)) :=
  congrArg Term.tabs
    ((congrArg (castTerm (map_liftCtx_substTy σ Γ) rfl) (tySubst_churchBody (extSub σ) m)).trans
      (castTerm_churchBody _ m))

theorem liftTermTy_church {k : Nat} {Γ : Ctx k} (m : Nat) :
    liftTermTy (Term.church m : Term k Γ Term.NatTy) =
      (Term.church m : Term (k + 1) (liftCtx k Γ) (liftTy Term.NatTy)) :=
  (congrArg (castTerm (map_substTy_succ Γ) rfl)
      (tySubstTerm_church (fun i => Ty.var i.succ) m)).trans
    (castTerm_church (map_substTy_succ Γ) m)

/-- Lifting a variable is just lifting its context proof. -/
theorem liftTermTy_var {k : Nat} {Γ : Ctx k} {τ : Ty k} (v : Var Γ τ) :
    liftTermTy (Term.var v : Term k Γ τ) = Term.var (liftCtxVar v) := by
  have gen : ∀ (f g : Ty k → Ty (k + 1)) (_ : f = g) (h1 : Γ.map f = Γ.map g)
      (h2 : f τ = g τ),
      castTerm h1 h2 (Term.var (mapVar f v)) = Term.var (mapVar g v) := by
    intro f g hfg
    subst hfg
    intro h1 h2
    rfl
  exact gen _ _ (funext substTy_succ) _ _

theorem singleSub_arrow {k : Nat} (A : Ty k) :
    substTy (singleSub A) (vₜ#0 ⇒ₜ vₜ#0) = A ⇒ₜ A := by
  simp only [substTy, singleSub, Fin.zero_eta, Fin.cases_zero]

/-- Type application of a Church numeral at any type `A`. -/
theorem instantiateTermTy_churchBody {k : Nat} {Γ : Ctx k} (A : Ty k) (n : Nat) :
    instantiateTermTy A
      (ƛ (ƛ (Term.churchIter n v#1 v#0)) :
        Term (k + 1) (liftCtx k Γ) ((vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0)) =
    (ƛ (ƛ (Term.churchIter n v#1 v#0)) :
      Term k Γ
        (instantiateTy ((vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0) A)) := by
  simp only [instantiateTermTy]
  rw [tySubst_churchBody]
  simp_all only [Fin.zero_eta]
  grind [= Ctx.eq_def, = instantiateTy.eq_def, = castTerm.eq_def, = substTy.eq_def,
    = singleSub.eq_def, = liftCtx.eq_def, = Term.churchIter.eq_def]

/-! ### 12''. Applying a Church numeral -/

theorem instantiate_church_lam {k : Nat} {Γ : Ctx k} (A : Ty k) (w : Var Γ (A ⇒ₜ A)) (n : Nat) :
    instantiate (ƛ (Term.churchIter n v#1 v#0) : Term k ((A ⇒ₜ A) :: Γ) (A ⇒ₜ A))
      (Term.var w) =
    (ƛ (Term.churchIter n (Term.var (Var.tail w)) v#0) : Term k Γ (A ⇒ₜ A)) :=
  congrArg Term.abs (subst_churchIter _ n _ _)

theorem instantiate_churchIter {k : Nat} {Γ : Ctx k} {A : Ty k} (w : Var Γ (A ⇒ₜ A))
    (X : Term k Γ A) (n : Nat) :
    instantiate
      (Term.churchIter n (Term.var (Var.tail w)) (Term.var Var.head) : Term k (A :: Γ) A) X =
    Term.churchIter n (Term.var w) X :=
  subst_churchIter _ n _ _

/-- `(n [A]) f x ≡β f^n x`, for `f` a variable and `x` arbitrary. -/
theorem church_apply {k : Nat} {Γ : Ctx k} (n : Nat) (A : Ty k) (w : Var Γ (A ⇒ₜ A))
    (X : Term k Γ A) :
    ((((Term.church n : Term k Γ Term.NatTy) ⬝ₜ A) ⬝ Term.var w) ⬝ X) ≡β
      Term.churchIter n (Term.var w) X := by
  have b1 : (Term.church n : Term k Γ Term.NatTy) ⬝ₜ A ⟶β
      (ƛ (ƛ (Term.churchIter n v#1 v#0)) : Term k Γ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)) := by
    have h := Beta.betaTy (Γ := Γ) (τ := (vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0)
      (ƛ (ƛ (Term.churchIter n v#1 v#0))) A
    rw [instantiateTermTy_churchBody] at h
    exact h
  have b2 : ((ƛ (ƛ (Term.churchIter n v#1 v#0)) : Term k Γ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)) ⬝ Term.var w) ⟶β
      (ƛ (Term.churchIter n (Term.var (Var.tail w)) v#0) : Term k Γ (A ⇒ₜ A)) := by
    have h := Beta.beta
      (ƛ (Term.churchIter n v#1 v#0) : Term k ((A ⇒ₜ A) :: Γ) (A ⇒ₜ A)) (Term.var w)
    rw [instantiate_church_lam] at h
    exact h
  have b3 : ((ƛ (Term.churchIter n (Term.var (Var.tail w)) v#0) : Term k Γ (A ⇒ₜ A)) ⬝ X) ⟶β
      Term.churchIter n (Term.var w) X := by
    have h := Beta.beta
      (Term.churchIter n (Term.var (Var.tail w)) (Term.var Var.head) : Term k (A :: Γ) A) X
    rw [instantiate_churchIter] at h
    exact h
  exact .trans _ _ _
    (BetaEquiv.app_l X (BetaEquiv.app_l (Term.var w) (.rel _ _ b1)))
    (.trans _ _ _ (BetaEquiv.app_l X (.rel _ _ b2)) (.rel _ _ b3))

/-- Body of `add`, once both arguments are Church numerals. -/
theorem add_body_equiv {k : Nat} {Γ : Ctx k} (A : Ty k) (m n : Nat) :
    (((((Term.church m : Term k (A :: (A ⇒ₜ A) :: Γ) Term.NatTy) ⬝ₜ A) ⬝ v#1) ⬝
      ((((Term.church n : Term k (A :: (A ⇒ₜ A) :: Γ) Term.NatTy) ⬝ₜ A) ⬝ v#1) ⬝ v#0))) ≡β
    Term.churchIter (m + n) (v#1 : Term k (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A)) v#0 := by
  have a := church_apply (Γ := A :: (A ⇒ₜ A) :: Γ) n A (Var.tail Var.head) (Term.var Var.head)
  have b := church_apply (Γ := A :: (A ⇒ₜ A) :: Γ) m A (Var.tail Var.head)
    (Term.churchIter n (Term.var (Var.tail Var.head)) (Term.var Var.head))
  simp_all only [Fin.zero_eta]
  have h := churchIter_add m n
    (v#1 : Term k (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A))
    (v#0 : Term k (A :: (A ⇒ₜ A) :: Γ) A)
  exact .trans _ _ _ (BetaEquiv.app_r _ a) (by
    grind only [Term.app.injEq, Var.tail.hcongr_5, Term.var.injEq, substTy, singleSub_zero]
    )

/-! ### 12'''. Head reduction of `add` on arbitrary arguments -/

/-- The substitution applied under `ƛₜ ƛ ƛ` when `n` is instantiated. -/
abbrev addSub {k : Nat} {Γ : Ctx k} (N : Term k Γ Term.NatTy) :
    Subst (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k (Term.NatTy :: Γ))
          (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k Γ) :=
  liftSubst (liftSubst (liftCtxSubst (substHead N)))

/-- What `m` becomes after both substitutions. -/
def addP {k : Nat} {Γ : Ctx k} (M N : Term k Γ Term.NatTy) :
    Term (k + 1) (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k Γ) (liftTy Term.NatTy) :=
  subst (addSub N) (shift (shift (liftTermTy (shift M))))

/-- What `n` becomes after both substitutions. -/
def addQ {k : Nat} {Γ : Ctx k} (N : Term k Γ Term.NatTy) :
    Term (k + 1) (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k Γ) (liftTy Term.NatTy) :=
  subst (addSub N)
    (shift (shift (liftTermTy (Term.var Var.head : Term k (Term.NatTy :: Γ) Term.NatTy))))

theorem addQ_eq {k : Nat} {Γ : Ctx k} (N : Term k Γ Term.NatTy) :
    addQ N = (shift (shift (liftTermTy N)) :
      Term (k + 1) (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k Γ) (liftTy Term.NatTy)) := by
  unfold addQ
  rw [liftTermTy_var]
  rfl

theorem addP_church {k : Nat} {Γ : Ctx k} (m n : Nat) :
    addP (Term.church m : Term k Γ Term.NatTy) (Term.church n) =
      (Term.church m :
        Term (k + 1) (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k Γ) (liftTy Term.NatTy)) := by
  have h1 : (shift (Term.church m : Term k Γ Term.NatTy) :
      Term k (Term.NatTy :: Γ) Term.NatTy) = Term.church m := shift_church m
  have h2 : liftTermTy (shift (Term.church m : Term k Γ Term.NatTy) :
      Term k (Term.NatTy :: Γ) Term.NatTy) =
      (Term.church m : Term (k + 1) (liftCtx k (Term.NatTy :: Γ)) (liftTy Term.NatTy)) :=
    (congrArg liftTermTy h1).trans (liftTermTy_church m)
  unfold addP
  refine Eq.trans (congrArg (subst (addSub (Term.church n))) ?_) (subst_church _ m)
  exact (congrArg shift (congrArg shift h2)).trans
    ((congrArg shift (shift_church m)).trans (shift_church m))

theorem addQ_church {k : Nat} {Γ : Ctx k} (n : Nat) :
    addQ (Term.church n : Term k Γ Term.NatTy) =
      (Term.church n :
        Term (k + 1) (vₜ#0 :: (vₜ#0 ⇒ₜ vₜ#0) :: liftCtx k Γ) (liftTy Term.NatTy)) :=
  (addQ_eq _).trans
    ((congrArg shift (congrArg shift (liftTermTy_church n))).trans
      ((congrArg shift (shift_church n)).trans (shift_church n)))

theorem add_reduce {k : Nat} {Γ : Ctx k} (M N : Term k Γ Term.NatTy) :
    (Term.add ⬝ M ⬝ N) ⟶*β
      (ƛₜ (ƛ (ƛ (((addP M N ⬝ₜ vₜ#0) ⬝ v#1) ⬝ (((addQ N ⬝ₜ vₜ#0) ⬝ v#1) ⬝ v#0)))) :
        Term k Γ Term.NatTy) := by
  refine (add_head_reduce M N).trans ?_
  exact Relation.ReflTransGen.refl

theorem add_reduce_church {k : Nat} {Γ : Ctx k} (m n : Nat) :
    (Term.add ⬝ Term.church m ⬝ Term.church n : Term k Γ Term.NatTy) ⟶*β
      (ƛₜ (ƛ (ƛ ((((Term.church m) ⬝ₜ vₜ#0) ⬝ v#1) ⬝
        ((((Term.church n) ⬝ₜ vₜ#0) ⬝ v#1) ⬝ v#0)))) : Term k Γ Term.NatTy) := by
  have h := add_reduce (Term.church m : Term k Γ Term.NatTy) (Term.church n)
  rw [addP_church, addQ_church] at h
  exact h

theorem BetaStar.toEquiv {k : Nat} {Γ : Ctx k} {τ : Ty k} {a b : Term k Γ τ}
    (h : a ⟶*β b) : a ≡β b := by
  induction h with
  | refl => exact .refl _
  | tail _ hs ih => exact .trans _ _ _ ih (.rel _ _ hs)

/-! ### 12''''. Addition is correct -/

/-- For all `m n`, Church addition computes `m + n`. -/
theorem add_church {k : Nat} {Γ : Ctx k} (m n : Nat) :
    (Term.add ⬝ Term.church m ⬝ Term.church n : Term k Γ Term.NatTy) ≡β
      Term.church (m + n) :=
  .trans _ _ _ (BetaStar.toEquiv (add_reduce_church m n))
    (BetaEquiv.tabs (BetaEquiv.lam (BetaEquiv.lam (add_body_equiv (vₜ#0) m n))))

end LambdaCube.LambdaTwo
