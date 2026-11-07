/-
Copyright (c) 2026 Serhii Khoma. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhii Khoma
-/
module

public import Mathlib.Logic.Relation

/-!
  Toy grammar for System λω_ (Lambda Weak Omega: type constructors, but no polymorphism).
  Axes supported:
  - (*, *): terms depending on terms (abstraction `ƛ` and application `⬝`)
  - (□, □): types depending on types (constructor abstraction `ƛₜ` and application `⬝ₜ`)

  Design:
  - Kinds `★ | K ⇒ₖ K` and constructors `var | ⇒ₜ | ƛₜ | ⬝ₜ` (intrinsically kinded).
  - Types have their own β-reduction / β-equivalence (`⟶βₜ`, `≡βₜ`).
  - Terms are intrinsically typed by constructors of kind `★`, with the *conversion rule*
    `Term.conv : A ≡βₜ B → Term Γ A → Term Γ B`.
  - There is no `ƛₜ` / `⬝ₜ` on terms (that would be λ2): terms never mention type binders,
    so term contexts do not need to be lifted.

  Lecture References:
  - Lecture 10: "The Extension λ_ω_ (Lambda Weak Omega)",
    Slide 4: Kinds K = * | (K → K) and Types
    Slide 5: The Four Levels of a Lambda Term (Term, Type/Ty, Kind, Sort)
    Slide 6: Beta-Reduction on Types
    Slide 13: Formation (form)* and (form)□: (□, □)
    Slide 14: Application & Abstraction for constructors and terms
  - Lecture 12: "The Lambda Cube and λC (6)",
    Slide 2: Vertex λ_ω_
    Slide 3 & 5 (a): λ_ω_ : (*, *), (□, □)
-/

@[expose] public section

namespace LambdaCube.LambdaOmegaWeak

/-! ### 1. Kinds -/

/-- Kinds: `★` (the kind of types) and kind arrows `K₁ ⇒ₖ K₂` for type constructors. -/
inductive Kind : Type where
  | star  : Kind
  | arrow : Kind → Kind → Kind
  deriving Repr, DecidableEq

notation "★" => Kind.star
infixr:70 " ⇒ₖ " => Kind.arrow

/-- Kind context for constructor variables. -/
abbrev KindCtx := List Kind

/-! ### 2. Types (types depending on types) -/

/-- Typed de Bruijn constructor variable: a position in the kind context `Δ`. -/
inductive TVar : KindCtx → Kind → Type where
  | head {Δ : KindCtx} {K : Kind} : TVar (K :: Δ) K
  | tail {Δ : KindCtx} {K S : Kind} (v : TVar Δ K) : TVar (S :: Δ) K

/-- Types of kind `K` in kind context `Δ`.
    Proper types have kind `★`; operators like `ƛₜ α. α ⇒ₜ α` have kind `★ ⇒ₖ ★`. -/
inductive Ty : KindCtx → Kind → Type where
  | var   {Δ : KindCtx} {K : Kind} (v : TVar Δ K) : Ty Δ K
  | arrow {Δ : KindCtx} (domain codomain : Ty Δ ★) : Ty Δ ★
  | abs   {Δ : KindCtx} {K₁ K₂ : Kind} (body : Ty (K₁ :: Δ) K₂) : Ty Δ (K₁ ⇒ₖ K₂)
  | app   {Δ : KindCtx} {K₁ K₂ : Kind} (f : Ty Δ (K₁ ⇒ₖ K₂)) (arg : Ty Δ K₁) : Ty Δ K₂

infixr:70 " ⇒ₜ "  => Ty.arrow
prefix:71 "ƛₜ " => Ty.abs
infixl:70 " ⬝ₜ " => Ty.app

/-! #### De Bruijn index macro for constructor variables -/

open Lean in
meta def mkCVarProof : Nat → MacroM Lean.Term
  | 0     => `(TVar.head)
  | n + 1 => do
    let inner ← mkCVarProof n
    `(TVar.tail $inner)

/-- Macro for constructor variables: `vₜ#0`, `vₜ#1`, ... -/
macro:max "vₜ#" n:num : term => do
  let v ← mkCVarProof n.getNat
  `(Ty.var $v)

/-! #### Renaming and substitution of constructor variables -/

/-- A constructor renaming maps variables in `Δ` to variables in `Δ'`. -/
def TyRename (Δ Δ' : KindCtx) := ∀ {K : Kind}, TVar Δ K → TVar Δ' K

/-- Extend a constructor renaming under a binder (`ƛₜ`). -/
def liftTyRename {Δ Δ' : KindCtx} {S : Kind} (ρ : TyRename Δ Δ') : TyRename (S :: Δ) (S :: Δ')
  | _, TVar.head   => TVar.head
  | _, TVar.tail v => TVar.tail (ρ v)

/-- Apply a renaming across a constructor. -/
def tyRename {Δ Δ' : KindCtx} (ρ : TyRename Δ Δ') : {K : Kind} → Ty Δ K → Ty Δ' K
  | _, Ty.var v      => Ty.var (ρ v)
  | _, Ty.arrow s t  => Ty.arrow (tyRename ρ s) (tyRename ρ t)
  | _, Ty.abs body   => Ty.abs (tyRename (liftTyRename ρ) body)
  | _, Ty.app f arg  => Ty.app (tyRename ρ f) (tyRename ρ arg)

/-- Weaken a constructor by one fresh variable at the head of the kind context. -/
def tyShift {Δ : KindCtx} {S : Kind} : {K : Kind} → Ty Δ K → Ty (S :: Δ) K :=
  tyRename TVar.tail

/-- A constructor substitution maps variables in `Δ` to constructors in `Δ'`. -/
def TySubst (Δ Δ' : KindCtx) := ∀ {K : Kind}, TVar Δ K → Ty Δ' K

/-- Extend a constructor substitution under a binder (`ƛₜ`). -/
def liftTySubst {Δ Δ' : KindCtx} {S : Kind} (σ : TySubst Δ Δ') : TySubst (S :: Δ) (S :: Δ')
  | _, TVar.head   => Ty.var TVar.head
  | _, TVar.tail v => tyShift (σ v)

/-- Apply a substitution to a constructor. -/
def tySubst {Δ Δ' : KindCtx} (σ : TySubst Δ Δ') : {K : Kind} → Ty Δ K → Ty Δ' K
  | _, Ty.var v      => σ v
  | _, Ty.arrow s t  => Ty.arrow (tySubst σ s) (tySubst σ t)
  | _, Ty.abs body   => Ty.abs (tySubst (liftTySubst σ) body)
  | _, Ty.app f arg  => Ty.app (tySubst σ f) (tySubst σ arg)

/-- Maps variable `0` to `arg` and decrements all others. -/
def tySubstHead {Δ : KindCtx} {S : Kind} (arg : Ty Δ S) : TySubst (S :: Δ) Δ
  | _, TVar.head   => arg
  | _, TVar.tail v => Ty.var v

/-- Single-variable constructor β-substitution: `body[arg/0]`. -/
def tyInstantiate {Δ : KindCtx} {K₁ K₂ : Kind} (body : Ty (K₁ :: Δ) K₂)
    (arg : Ty Δ K₁) : Ty Δ K₂ :=
  tySubst (tySubstHead arg) body

/-! ### 3. β-reduction and β-equivalence on constructors -/

/-- 1-step β-reduction on constructors (Lecture 10, Slide 6). -/
inductive TyBeta : {Δ : KindCtx} → {K : Kind} → Ty Δ K → Ty Δ K → Prop where
  | beta {Δ : KindCtx} {K₁ K₂ : Kind} (body : Ty (K₁ :: Δ) K₂)
      (arg : Ty Δ K₁) :
      TyBeta (Ty.app (Ty.abs body) arg) (tyInstantiate body arg)
  | arrow_l {Δ : KindCtx} {S S' : Ty Δ ★} (T : Ty Δ ★) :
      TyBeta S S' → TyBeta (Ty.arrow S T) (Ty.arrow S' T)
  | arrow_r {Δ : KindCtx} (S : Ty Δ ★) {T T' : Ty Δ ★} :
      TyBeta T T' → TyBeta (Ty.arrow S T) (Ty.arrow S T')
  | lam {Δ : KindCtx} {K₁ K₂ : Kind} {body body' : Ty (K₁ :: Δ) K₂} :
      TyBeta body body' → TyBeta (Ty.abs body) (Ty.abs body')
  | app_l {Δ : KindCtx} {K₁ K₂ : Kind} {f f' : Ty Δ (K₁ ⇒ₖ K₂)}
      (arg : Ty Δ K₁) :
      TyBeta f f' → TyBeta (Ty.app f arg) (Ty.app f' arg)
  | app_r {Δ : KindCtx} {K₁ K₂ : Kind} (f : Ty Δ (K₁ ⇒ₖ K₂))
      {arg arg' : Ty Δ K₁} :
      TyBeta arg arg' → TyBeta (Ty.app f arg) (Ty.app f arg')

infix:50 " ⟶βₜ " => TyBeta

/-- Multi-step β-reduction on constructors. -/
abbrev TyBetaStar {Δ : KindCtx} {K : Kind} : Ty Δ K → Ty Δ K → Prop :=
  Relation.ReflTransGen TyBeta

infix:50 " ⟶*βₜ " => TyBetaStar

/-- β-equivalence on constructors. -/
abbrev TyBetaEquiv {Δ : KindCtx} {K : Kind} : Ty Δ K → Ty Δ K → Prop :=
  Relation.EqvGen TyBeta

infix:50 " ≡βₜ " => TyBetaEquiv

instance (Δ : KindCtx) (K : Kind) : Setoid (Ty Δ K) :=
  Relation.EqvGen.setoid TyBeta

namespace TyBetaStar

theorem arrow_l {Δ : KindCtx} {S S' : Ty Δ ★} (T : Ty Δ ★)
    (h : S ⟶*βₜ S') : (S ⇒ₜ T) ⟶*βₜ (S' ⇒ₜ T) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (TyBeta.arrow_l T hstep)

theorem arrow_r {Δ : KindCtx} (S : Ty Δ ★) {T T' : Ty Δ ★}
    (h : T ⟶*βₜ T') : (S ⇒ₜ T) ⟶*βₜ (S ⇒ₜ T') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (TyBeta.arrow_r S hstep)

theorem lam {Δ : KindCtx} {K₁ K₂ : Kind} {body body' : Ty (K₁ :: Δ) K₂}
    (h : body ⟶*βₜ body') :
    (ƛₜ body : Ty Δ (K₁ ⇒ₖ K₂)) ⟶*βₜ (ƛₜ body') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (TyBeta.lam hstep)

theorem app_l {Δ : KindCtx} {K₁ K₂ : Kind} {f f' : Ty Δ (K₁ ⇒ₖ K₂)}
    (arg : Ty Δ K₁) (h : f ⟶*βₜ f') : (f ⬝ₜ arg) ⟶*βₜ (f' ⬝ₜ arg) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (TyBeta.app_l arg hstep)

theorem app_r {Δ : KindCtx} {K₁ K₂ : Kind} (f : Ty Δ (K₁ ⇒ₖ K₂))
    {arg arg' : Ty Δ K₁} (h : arg ⟶*βₜ arg') : (f ⬝ₜ arg) ⟶*βₜ (f ⬝ₜ arg') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (TyBeta.app_r f hstep)

theorem toEquiv {Δ : KindCtx} {K : Kind} {a b : Ty Δ K}
    (h : a ⟶*βₜ b) : a ≡βₜ b := by
  induction h with
  | refl => exact .refl _
  | tail _ hs ih => exact .trans _ _ _ ih (.rel _ _ hs)

end TyBetaStar

namespace TyBetaEquiv

theorem arrow_l {Δ : KindCtx} {S S' : Ty Δ ★} (T : Ty Δ ★)
    (h : S ≡βₜ S') : (S ⇒ₜ T) ≡βₜ (S' ⇒ₜ T) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (TyBeta.arrow_l T hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem arrow_r {Δ : KindCtx} (S : Ty Δ ★) {T T' : Ty Δ ★}
    (h : T ≡βₜ T') : (S ⇒ₜ T) ≡βₜ (S ⇒ₜ T') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (TyBeta.arrow_r S hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem lam {Δ : KindCtx} {K₁ K₂ : Kind} {body body' : Ty (K₁ :: Δ) K₂}
    (h : body ≡βₜ body') :
    (ƛₜ body : Ty Δ (K₁ ⇒ₖ K₂)) ≡βₜ (ƛₜ body') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (TyBeta.lam hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_l {Δ : KindCtx} {K₁ K₂ : Kind} {f f' : Ty Δ (K₁ ⇒ₖ K₂)}
    (arg : Ty Δ K₁) (h : f ≡βₜ f') : (f ⬝ₜ arg) ≡βₜ (f' ⬝ₜ arg) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (TyBeta.app_l arg hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_r {Δ : KindCtx} {K₁ K₂ : Kind} (f : Ty Δ (K₁ ⇒ₖ K₂))
    {arg arg' : Ty Δ K₁} (h : arg ≡βₜ arg') : (f ⬝ₜ arg) ≡βₜ (f ⬝ₜ arg') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (TyBeta.app_r f hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

end TyBetaEquiv

/-! ### 4. Standard type constructors -/

section StandardTypes

variable {Δ : KindCtx}

/-- Identity type operator: `ƛₜ α. α` of kind `★ ⇒ₖ ★`. -/
def idOp : Ty Δ (★ ⇒ₖ ★) := ƛₜ (vₜ#0)

/-- Church numeral type at `α`: `(α ⇒ₜ α) ⇒ₜ α ⇒ₜ α`. -/
abbrev NatTy (α : Ty Δ ★) : Ty Δ ★ := (α ⇒ₜ α) ⇒ₜ α ⇒ₜ α

/-- Church numeral type *operator*: `ƛₜ α. (α ⇒ₜ α) ⇒ₜ α ⇒ₜ α` of kind `★ ⇒ₖ ★`. -/
def natOp : Ty Δ (★ ⇒ₖ ★) := ƛₜ ((vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0)

/-- `idOp α` β-reduces to `α`. -/
theorem idOp_conv (α : Ty Δ ★) : (idOp ⬝ₜ α) ≡βₜ α :=
  .rel _ _ (TyBeta.beta _ _)

/-- `natOp α` β-reduces to `NatTy α`. -/
theorem natOp_conv (α : Ty Δ ★) : (natOp ⬝ₜ α) ≡βₜ NatTy α :=
  .rel _ _ (TyBeta.beta _ _)

end StandardTypes

/-! ### 5. Terms -/

/-- Term context: a list of types (constructors of kind `★`). -/
abbrev Ctx (Δ : KindCtx) := List (Ty Δ ★)

/-- Typed de Bruijn term variable. -/
inductive Var {Δ : KindCtx} : Ctx Δ → Ty Δ ★ → Type where
  | head {Γ : Ctx Δ} {T : Ty Δ ★} : Var (T :: Γ) T
  | tail {Γ : Ctx Δ} {T S : Ty Δ ★} (v : Var Γ T) : Var (S :: Γ) T

/-- λω_ intrinsically typed terms.  Terms only depend on terms; the only interaction
    with constructors is the conversion rule `conv`. -/
inductive Term {Δ : KindCtx} : Ctx Δ → Ty Δ ★ → Type where
  | var  {Γ : Ctx Δ} {T : Ty Δ ★} (v : Var Γ T) : Term Γ T
  | abs  {Γ : Ctx Δ} {S T : Ty Δ ★} (body : Term (S :: Γ) T) : Term Γ (S ⇒ₜ T)
  | app  {Γ : Ctx Δ} {S T : Ty Δ ★} (f : Term Γ (S ⇒ₜ T)) (arg : Term Γ S) : Term Γ T
  /-- Conversion: `M : A` and `A ≡βₜ B` give `M : B`. -/
  | conv {Γ : Ctx Δ} {T T' : Ty Δ ★} (h : T ≡βₜ T') (t : Term Γ T) : Term Γ T'

prefix:71 "ƛ "  => Term.abs
infixl:70 " ⬝ "  => Term.app

/-! #### De Bruijn index macro for term variables -/

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

/-! ### 6. Renaming & substitution of term variables -/

/-- A renaming is a context morphism mapping variables in `Γ` to variables in `Γ'`. -/
def Rename {Δ : KindCtx} (Γ Γ' : Ctx Δ) := ∀ {T : Ty Δ ★}, Var Γ T → Var Γ' T

/-- Extend a renaming under a binder (`ƛ`). -/
def liftRename {Δ : KindCtx} {Γ Γ' : Ctx Δ} {S : Ty Δ ★} (ρ : Rename Γ Γ') :
    Rename (S :: Γ) (S :: Γ')
  | _, Var.head   => Var.head
  | _, Var.tail v => Var.tail (ρ v)

/-- Apply a variable renaming across a term (conversion proofs are untouched). -/
def rename {Δ : KindCtx} {Γ Γ' : Ctx Δ} (ρ : Rename Γ Γ') :
    {T : Ty Δ ★} → Term Γ T → Term Γ' T
  | _, Term.var v        => Term.var (ρ v)
  | _, Term.abs body     => Term.abs (rename (liftRename ρ) body)
  | _, Term.app f arg    => Term.app (rename ρ f) (rename ρ arg)
  | _, Term.conv h t     => Term.conv h (rename ρ t)

/-- Shift all free variables by 1 (introducing `S` at the head of the context). -/
def shift {Δ : KindCtx} {Γ : Ctx Δ} {S : Ty Δ ★} :
    {T : Ty Δ ★} → Term Γ T → Term (S :: Γ) T :=
  rename Var.tail

/-- A substitution maps variables in `Γ` to terms in `Γ'`. -/
def Subst {Δ : KindCtx} (Γ Γ' : Ctx Δ) := ∀ {T : Ty Δ ★}, Var Γ T → Term Γ' T

/-- Extend a substitution under a binder (`ƛ`). -/
def liftSubst {Δ : KindCtx} {Γ Γ' : Ctx Δ} {S : Ty Δ ★} (σ : Subst Γ Γ') :
    Subst (S :: Γ) (S :: Γ')
  | _, Var.head   => Term.var Var.head
  | _, Var.tail v => shift (σ v)

/-- Apply a substitution to a term. -/
def subst {Δ : KindCtx} {Γ Γ' : Ctx Δ} (σ : Subst Γ Γ') :
    {T : Ty Δ ★} → Term Γ T → Term Γ' T
  | _, Term.var v        => σ v
  | _, Term.abs body     => Term.abs (subst (liftSubst σ) body)
  | _, Term.app f arg    => Term.app (subst σ f) (subst σ arg)
  | _, Term.conv h t     => Term.conv h (subst σ t)

/-- Maps variable `0` to `arg` and decrements all others. -/
def substHead {Δ : KindCtx} {Γ : Ctx Δ} {S : Ty Δ ★} (arg : Term Γ S) :
    Subst (S :: Γ) Γ
  | _, Var.head   => arg
  | _, Var.tail v => Term.var v

/-- Single-variable β-substitution: `body[arg/0]`. -/
def instantiate {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★}
    (body : Term (S :: Γ) T) (arg : Term Γ S) : Term Γ T :=
  subst (substHead arg) body

/-! ### 7. Single-Step Beta Reduction (Beta) -/

/-- 1-step β-reduction on terms, with full congruences (also under `conv`). -/
inductive Beta : {Δ : KindCtx} → {Γ : Ctx Δ} → {T : Ty Δ ★} →
    Term Γ T → Term Γ T → Prop where
  | beta {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★}
      (body : Term (S :: Γ) T) (arg : Term Γ S) :
      Beta (Term.app (Term.abs body) arg) (instantiate body arg)
  | lam {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} {body body' : Term (S :: Γ) T} :
      Beta body body' → Beta (Term.abs body) (Term.abs body')
  | app_l {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} {f f' : Term Γ (S ⇒ₜ T)}
      (arg : Term Γ S) :
      Beta f f' → Beta (Term.app f arg) (Term.app f' arg)
  | app_r {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} (f : Term Γ (S ⇒ₜ T))
      {arg arg' : Term Γ S} :
      Beta arg arg' → Beta (Term.app f arg) (Term.app f arg')
  | conv {Δ : KindCtx} {Γ : Ctx Δ} {T T' : Ty Δ ★} (h : T ≡βₜ T')
      {t t' : Term Γ T} :
      Beta t t' → Beta (Term.conv h t) (Term.conv h t')

infix:50 " ⟶β " => Beta

/-! ### 8. Multi-Step Beta Reduction (BetaStar) -/

abbrev BetaStar {Δ : KindCtx} {Γ : Ctx Δ} {T : Ty Δ ★} :
    Term Γ T → Term Γ T → Prop :=
  Relation.ReflTransGen Beta

infix:50 " ⟶*β " => BetaStar

namespace BetaStar

theorem lam {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} {body body' : Term (S :: Γ) T}
    (h : body ⟶*β body') : (ƛ body : Term Γ (S ⇒ₜ T)) ⟶*β (ƛ body') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.lam hstep)

theorem app_l {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} {f f' : Term Γ (S ⇒ₜ T)}
    (arg : Term Γ S) (h : f ⟶*β f') : (f ⬝ arg) ⟶*β (f' ⬝ arg) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.app_l arg hstep)

theorem app_r {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} (f : Term Γ (S ⇒ₜ T))
    {arg arg' : Term Γ S} (h : arg ⟶*β arg') : (f ⬝ arg) ⟶*β (f ⬝ arg') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.app_r f hstep)

theorem conv {Δ : KindCtx} {Γ : Ctx Δ} {T T' : Ty Δ ★} (h : T ≡βₜ T')
    {t t' : Term Γ T} (ht : t ⟶*β t') : Term.conv h t ⟶*β Term.conv h t' := by
  induction ht with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.conv h hstep)

end BetaStar

/-! ### 9. Beta Equivalence (BetaEquiv) -/

abbrev BetaEquiv {Δ : KindCtx} {Γ : Ctx Δ} {T : Ty Δ ★} :
    Term Γ T → Term Γ T → Prop :=
  Relation.EqvGen Beta

infix:50 " ≡β " => BetaEquiv

instance {Δ : KindCtx} (Γ : Ctx Δ) (T : Ty Δ ★) : Setoid (Term Γ T) :=
  Relation.EqvGen.setoid Beta

namespace BetaEquiv

theorem lam {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} {body body' : Term (S :: Γ) T}
    (h : body ≡β body') : (ƛ body : Term Γ (S ⇒ₜ T)) ≡β (ƛ body') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.lam hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_l {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} {f f' : Term Γ (S ⇒ₜ T)}
    (arg : Term Γ S) (h : f ≡β f') : (f ⬝ arg) ≡β (f' ⬝ arg) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.app_l arg hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_r {Δ : KindCtx} {Γ : Ctx Δ} {S T : Ty Δ ★} (f : Term Γ (S ⇒ₜ T))
    {arg arg' : Term Γ S} (h : arg ≡β arg') : (f ⬝ arg) ≡β (f ⬝ arg') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.app_r f hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem conv {Δ : KindCtx} {Γ : Ctx Δ} {T T' : Ty Δ ★} (h : T ≡βₜ T')
    {t t' : Term Γ T} (ht : t ≡β t') : Term.conv h t ≡β Term.conv h t' := by
  induction ht with
  | rel _ _ hstep => exact .rel _ _ (Beta.conv h hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

end BetaEquiv

theorem BetaStar.toEquiv {Δ : KindCtx} {Γ : Ctx Δ} {T : Ty Δ ★} {a b : Term Γ T}
    (h : a ⟶*β b) : a ≡β b := by
  induction h with
  | refl => exact .refl _
  | tail _ hs ih => exact .trans _ _ _ ih (.rel _ _ hs)

/-! ### 10. Standard Terms & Church Numerals -/
namespace Term

/-- Iterated application in syntax: `f (f (... (f x)))` repeated `n` times. -/
def churchIter (n : Nat) {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★}
    (f : Term Γ (α ⇒ₜ α)) (x : Term Γ α) : Term Γ α :=
  match n with
  | 0     => x
  | n + 1 => f ⬝ churchIter n f x

/-- Embeds any Lean `n : Nat` as a Church numeral: `ƛf. ƛx. f^[n] x`. -/
def church (n : Nat) {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} : Term Γ (NatTy α) :=
  ƛ (ƛ (churchIter n v#1 v#0))

/-- Identity function: `ƛx. x` -/
def id {Δ : KindCtx} {Γ : Ctx Δ} {τ : Ty Δ ★} : Term Γ (τ ⇒ₜ τ) :=
  ƛ v#0

/-- Constant function: `ƛx. ƛy. x` -/
def const {Δ : KindCtx} {Γ : Ctx Δ} {τ₁ τ₂ : Ty Δ ★} : Term Γ (τ₁ ⇒ₜ τ₂ ⇒ₜ τ₁) :=
  ƛ (ƛ v#1)

/-- Church zero: `ƛf. ƛx. x` -/
def zero {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} : Term Γ (NatTy α) := church 0

/-- Church one: `ƛf. ƛx. f x` -/
def one {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} : Term Γ (NatTy α) := church 1

/-- Church two: `ƛf. ƛx. f (f x)` -/
def two {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} : Term Γ (NatTy α) := church 2

/-- Church numerals at the *operator* type `natOp ⬝ₜ α`, via the conversion rule. -/
def churchOp (n : Nat) {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} :
    Term Γ (natOp ⬝ₜ α) :=
  Term.conv (Relation.EqvGen.symm _ _ (natOp_conv α)) (church n)

/-- Church successor: `ƛn. ƛf. ƛx. f (n f x)` -/
def succ {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} : Term Γ (NatTy α ⇒ₜ NatTy α) :=
  ƛ (             -- n is v#2
    ƛ (           -- f is v#1
      ƛ (         -- x is v#0
        v#1 ⬝ ((v#2 ⬝ v#1) ⬝ v#0)
      )
    )
  )

/-- Body of Church addition, in the context `x :: f :: n :: m :: Γ`. -/
abbrev addBody {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} :
    Term (α :: (α ⇒ₜ α) :: NatTy α :: NatTy α :: Γ) α :=
  (v#3 ⬝ v#1) ⬝ ((v#2 ⬝ v#1) ⬝ v#0)

/-- Church addition: `ƛm. ƛn. ƛf. ƛx. m f (n f x)` -/
def add {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} :
    Term Γ (NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α) :=
  ƛ (ƛ (ƛ (ƛ addBody)))

/-- Body of Church multiplication, in the context `f :: n :: m :: Γ`. -/
abbrev mulBody {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} :
    Term ((α ⇒ₜ α) :: NatTy α :: NatTy α :: Γ) (α ⇒ₜ α) :=
  v#2 ⬝ (v#1 ⬝ v#0)

/-- Church multiplication (η-reduced): `ƛm. ƛn. ƛf. m (n f)` -/
def mul {Δ : KindCtx} {Γ : Ctx Δ} {α : Ty Δ ★} :
    Term Γ (NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α) :=
  ƛ (ƛ (ƛ mulBody))

end Term

/-! ### 11. Sanity checks -/

/-- `(ƛx. x) y ⟶β y` with a free variable. -/
example {Δ : KindCtx} {S : Ty Δ ★} {Γ : Ctx Δ} :
    ((ƛ v#0 : Term (S :: Γ) (S ⇒ₜ S)) ⬝ v#0) ⟶β v#0 :=
  Beta.beta (v#0) (v#0)

/-- `add`, `mul`, `succ` are closed terms at any kind scope. -/
example {Δ : KindCtx} {α : Ty Δ ★} : Term (Δ := Δ) [] (NatTy α ⇒ₜ NatTy α) := Term.succ
example {Δ : KindCtx} {α : Ty Δ ★} :
    Term (Δ := Δ) [] (NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α) := Term.add
example {Δ : KindCtx} {α : Ty Δ ★} :
    Term (Δ := Δ) [] (NatTy α ⇒ₜ NatTy α ⇒ₜ NatTy α) := Term.mul

/-- Conversion in action: `ƛ (x : idOp α). x` has type `idOp α ⇒ₜ α` because `idOp α ≡βₜ α`. -/
def convExample {Δ : KindCtx} {Γ : Ctx Δ} (α : Ty Δ ★) :
    Term Γ ((idOp ⬝ₜ α) ⇒ₜ α) :=
  ƛ (Term.conv (idOp_conv α) v#0)

/-! ### 12. Arithmetic Correctness Proofs for Add and Mul -/

section Arithmetic

variable {Δ : KindCtx} {Γ Γ' : Ctx Δ} {α : Ty Δ ★}

/-- Head reduction of addition: `add ⬝ M ⬝ N ⟶*β ...` unfolds to the addition body. -/
theorem add_head_reduce (M N : Term Γ (NatTy α)) :
    (Term.add ⬝ M ⬝ N) ⟶*β
      instantiate (subst (liftSubst (substHead M)) (ƛ (ƛ Term.addBody))) N :=
  (BetaStar.app_l N (.single (Beta.beta _ M))).trans (.single (Beta.beta _ N))

/-- Head reduction of multiplication. -/
theorem mul_head_reduce (M N : Term Γ (NatTy α)) :
    (Term.mul ⬝ M ⬝ N) ⟶*β
      instantiate (subst (liftSubst (substHead M)) (ƛ Term.mulBody)) N :=
  (BetaStar.app_l N (.single (Beta.beta _ M))).trans (.single (Beta.beta _ N))

/-! #### Church numerals are closed terms -/

theorem churchIter_add (m n : Nat) (f : Term Γ (α ⇒ₜ α)) (x : Term Γ α) :
    Term.churchIter m f (Term.churchIter n f x) = Term.churchIter (m + n) f x := by
  induction m with
  | zero =>
    exact (congrArg (fun j => Term.churchIter j f x) (Nat.zero_add n)).symm
  | succ m ih =>
    have hmn : m + 1 + n = (m + n) + 1 := by omega
    rw [hmn]
    exact congrArg (Term.app f) ih

theorem rename_churchIter (ρ : Rename Γ Γ') (n : Nat)
    (f : Term Γ (α ⇒ₜ α)) (x : Term Γ α) :
    rename ρ (Term.churchIter n f x) = Term.churchIter n (rename ρ f) (rename ρ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (rename ρ f)) ih

theorem subst_churchIter (σ : Subst Γ Γ') (n : Nat)
    (f : Term Γ (α ⇒ₜ α)) (x : Term Γ α) :
    subst σ (Term.churchIter n f x) = Term.churchIter n (subst σ f) (subst σ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (subst σ f)) ih

theorem rename_church (ρ : Rename Γ Γ') (m : Nat) :
    rename ρ (Term.church m : Term Γ (NatTy α)) = Term.church m :=
  congrArg Term.abs (congrArg Term.abs (rename_churchIter _ m _ _))

theorem shift_church {S : Ty Δ ★} (m : Nat) :
    (shift (Term.church m : Term Γ (NatTy α)) : Term (S :: Γ) (NatTy α)) =
      Term.church m :=
  rename_church Var.tail m

theorem subst_church (σ : Subst Γ Γ') (m : Nat) :
    subst σ (Term.church m : Term Γ (NatTy α)) = Term.church m :=
  congrArg Term.abs (congrArg Term.abs (subst_churchIter _ m _ _))

/-! #### Applying a Church numeral -/

theorem instantiate_church_lam (w : Var Γ (α ⇒ₜ α)) (n : Nat) :
    instantiate (ƛ (Term.churchIter n v#1 v#0) : Term ((α ⇒ₜ α) :: Γ) (α ⇒ₜ α))
      (Term.var w) =
    (ƛ (Term.churchIter n (Term.var (Var.tail w)) v#0) : Term Γ (α ⇒ₜ α)) :=
  congrArg Term.abs (subst_churchIter _ n _ _)

theorem instantiate_churchIter (w : Var Γ (α ⇒ₜ α)) (X : Term Γ α) (n : Nat) :
    instantiate
      (Term.churchIter n (Term.var (Var.tail w)) (Term.var Var.head) : Term (α :: Γ) α) X =
    Term.churchIter n (Term.var w) X :=
  subst_churchIter _ n _ _

/-- `(n f) x ≡β f^n x`, for `f` a variable and `x` arbitrary. -/
theorem church_apply (n : Nat) (w : Var Γ (α ⇒ₜ α)) (X : Term Γ α) :
    (((Term.church n : Term Γ (NatTy α)) ⬝ Term.var w) ⬝ X) ≡β
      Term.churchIter n (Term.var w) X := by
  have b2 : ((Term.church n : Term Γ (NatTy α)) ⬝ Term.var w) ⟶β
      (ƛ (Term.churchIter n (Term.var (Var.tail w)) v#0) : Term Γ (α ⇒ₜ α)) := by
    have h := Beta.beta
      (ƛ (Term.churchIter n v#1 v#0) : Term ((α ⇒ₜ α) :: Γ) (α ⇒ₜ α)) (Term.var w)
    rw [instantiate_church_lam] at h
    exact h
  have b3 : ((ƛ (Term.churchIter n (Term.var (Var.tail w)) v#0) : Term Γ (α ⇒ₜ α)) ⬝ X) ⟶β
      Term.churchIter n (Term.var w) X := by
    have h := Beta.beta
      (Term.churchIter n (Term.var (Var.tail w)) (Term.var Var.head) : Term (α :: Γ) α) X
    rw [instantiate_churchIter] at h
    exact h
  exact .trans _ _ _ (BetaEquiv.app_l X (.rel _ _ b2)) (.rel _ _ b3)

/-! #### Body of `add`, once both arguments are Church numerals -/

theorem add_body_equiv (m n : Nat) :
    (((Term.church m : Term (α :: (α ⇒ₜ α) :: Γ) (NatTy α)) ⬝ v#1) ⬝
      (((Term.church n : Term (α :: (α ⇒ₜ α) :: Γ) (NatTy α)) ⬝ v#1) ⬝ v#0)) ≡β
    Term.churchIter (m + n) (v#1 : Term (α :: (α ⇒ₜ α) :: Γ) (α ⇒ₜ α)) v#0 := by
  have a := church_apply (Γ := α :: (α ⇒ₜ α) :: Γ) n (Var.tail Var.head) (Term.var Var.head)
  have b := church_apply (Γ := α :: (α ⇒ₜ α) :: Γ) m (Var.tail Var.head)
    (Term.churchIter n (Term.var (Var.tail Var.head)) (Term.var Var.head))
  rw [churchIter_add] at b
  exact .trans _ _ _ (BetaEquiv.app_r _ a) b

/-! #### Head reduction of `add` on arbitrary arguments -/

/-- Substitution applied under `ƛf. ƛx.` when `m` is instantiated. -/
abbrev addSubM (M : Term Γ (NatTy α)) :
    Subst (α :: (α ⇒ₜ α) :: NatTy α :: NatTy α :: Γ) (α :: (α ⇒ₜ α) :: NatTy α :: Γ) :=
  liftSubst (liftSubst (liftSubst (substHead M)))

/-- Substitution applied under `ƛf. ƛx.` when `n` is instantiated. -/
abbrev addSubN (N : Term Γ (NatTy α)) :
    Subst (α :: (α ⇒ₜ α) :: NatTy α :: Γ) (α :: (α ⇒ₜ α) :: Γ) :=
  liftSubst (liftSubst (substHead N))

/-- The two-step head reduct of `add M N`, with substitutions made explicit. -/
theorem add_instantiate_eq (M N : Term Γ (NatTy α)) :
    instantiate (subst (liftSubst (substHead M)) (ƛ (ƛ Term.addBody))) N =
      (ƛ (ƛ (subst (addSubN N) (subst (addSubM M) Term.addBody))) : Term Γ (NatTy α)) :=
  rfl

/-- What the body becomes: `m` and `n` are weakened, then substituted. -/
theorem add_reduct_eq (M N : Term Γ (NatTy α)) :
    subst (addSubN N) (subst (addSubM M) Term.addBody) =
      ((subst (addSubN N) (shift (shift (shift M))) ⬝ v#1) ⬝
        ((shift (shift N) ⬝ v#1) ⬝ v#0)) :=
  rfl

theorem add_reduct_church (m n : Nat) :
    subst (addSubN (Term.church n : Term Γ (NatTy α)))
      (subst (addSubM (Term.church m : Term Γ (NatTy α))) Term.addBody) =
      (((Term.church m : Term (α :: (α ⇒ₜ α) :: Γ) (NatTy α)) ⬝ v#1) ⬝
        (((Term.church n : Term (α :: (α ⇒ₜ α) :: Γ) (NatTy α)) ⬝ v#1) ⬝ v#0)) := by
  refine (add_reduct_eq _ _).trans ?_
  simp only [shift_church, subst_church]

theorem add_reduce_church (m n : Nat) :
    (Term.add ⬝ Term.church m ⬝ Term.church n : Term Γ (NatTy α)) ⟶*β
      (ƛ (ƛ (((Term.church m : Term (α :: (α ⇒ₜ α) :: Γ) (NatTy α)) ⬝ v#1) ⬝
        (((Term.church n : Term (α :: (α ⇒ₜ α) :: Γ) (NatTy α)) ⬝ v#1) ⬝ v#0))) :
        Term Γ (NatTy α)) := by
  have h := add_head_reduce (Term.church m : Term Γ (NatTy α)) (Term.church n)
  rw [add_instantiate_eq, add_reduct_church] at h
  exact h

/-! #### Addition is correct -/

/-- For all `m n`, Church addition computes `m + n`. -/
theorem add_church (m n : Nat) :
    (Term.add ⬝ Term.church m ⬝ Term.church n : Term Γ (NatTy α)) ≡β
      Term.church (m + n) :=
  .trans _ _ _ (BetaStar.toEquiv (add_reduce_church m n))
    (BetaEquiv.lam (BetaEquiv.lam (add_body_equiv m n)))

/-- `1 + 1 = 2`, as a corollary. -/
example : (Term.add ⬝ Term.one ⬝ Term.one : Term Γ (NatTy α)) ≡β Term.two :=
  add_church 1 1

end Arithmetic

/-! ### 13. Type-Level Church Numerals & Addition Correctness -/

/-- The kind of Church numerals over any kind `K` (defaults to `★`):
    `(K ⇒ₖ K) ⇒ₖ K ⇒ₖ K`. -/
abbrev NatKind (K : Kind := ★) : Kind := (K ⇒ₖ K) ⇒ₖ K ⇒ₖ K

section TyArithmetic

variable {Δ Δ' : KindCtx} {K : Kind}

/-- Iterated constructor application: `F (F (... (F X)))` repeated `n` times. -/
def tyChurchIter (n : Nat) (F : Ty Δ (K ⇒ₖ K)) (X : Ty Δ K) : Ty Δ K :=
  match n with
  | 0     => X
  | n + 1 => F ⬝ₜ tyChurchIter n F X

/-- Type-level Church numeral: `ƛₜ F. ƛₜ X. F^[n] X`. -/
def tyChurch (n : Nat) : Ty Δ (NatKind K) :=
  ƛₜ (ƛₜ (tyChurchIter n vₜ#1 vₜ#0))

/-- Type-level Church zero. -/
def tyZero : Ty Δ (NatKind K) := tyChurch 0

/-- Type-level Church one. -/
def tyOne : Ty Δ (NatKind K) := tyChurch 1

/-- Type-level Church two. -/
def tyTwo : Ty Δ (NatKind K) := tyChurch 2

/-- Body of type-level Church addition in context `X :: F :: n :: m :: Δ`. -/
abbrev tyAddBody : Ty (K :: (K ⇒ₖ K) :: NatKind K :: NatKind K :: Δ) K :=
  (vₜ#3 ⬝ₜ vₜ#1) ⬝ₜ ((vₜ#2 ⬝ₜ vₜ#1) ⬝ₜ vₜ#0)

/-- Type-level Church addition: `ƛₜ m. ƛₜ n. ƛₜ F. ƛₜ X. m F (n F X)`. -/
def tyAdd : Ty Δ (NatKind K ⇒ₖ NatKind K ⇒ₖ NatKind K) :=
  ƛₜ (ƛₜ (ƛₜ (ƛₜ tyAddBody)))

/-! #### Closedness lemmas for type-level Church numerals -/

theorem tyChurchIter_add (m n : Nat) (F : Ty Δ (K ⇒ₖ K)) (X : Ty Δ K) :
    tyChurchIter m F (tyChurchIter n F X) = tyChurchIter (m + n) F X := by
  induction m with
  | zero =>
    exact (congrArg (fun j => tyChurchIter j F X) (Nat.zero_add n)).symm
  | succ m ih =>
    have hmn : m + 1 + n = (m + n) + 1 := by omega
    rw [hmn]
    exact congrArg (Ty.app F) ih

theorem tyRename_churchIter (ρ : TyRename Δ Δ') (n : Nat)
    (F : Ty Δ (K ⇒ₖ K)) (X : Ty Δ K) :
    tyRename ρ (tyChurchIter n F X) = tyChurchIter n (tyRename ρ F) (tyRename ρ X) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Ty.app (tyRename ρ F)) ih

theorem tySubst_churchIter (σ : TySubst Δ Δ') (n : Nat)
    (F : Ty Δ (K ⇒ₖ K)) (X : Ty Δ K) :
    tySubst σ (tyChurchIter n F X) = tyChurchIter n (tySubst σ F) (tySubst σ X) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Ty.app (tySubst σ F)) ih

theorem tyRename_church (ρ : TyRename Δ Δ') (m : Nat) :
    tyRename ρ (tyChurch m : Ty Δ (NatKind K)) = tyChurch m :=
  congrArg Ty.abs (congrArg Ty.abs (tyRename_churchIter _ m _ _))

theorem tyShift_church {S : Kind} (m : Nat) :
    (tyShift (tyChurch m : Ty Δ (NatKind K)) : Ty (S :: Δ) (NatKind K)) =
      tyChurch m :=
  tyRename_church TVar.tail m

theorem tySubst_church (σ : TySubst Δ Δ') (m : Nat) :
    tySubst σ (tyChurch m : Ty Δ (NatKind K)) = tyChurch m :=
  congrArg Ty.abs (congrArg Ty.abs (tySubst_churchIter _ m _ _))

/-! #### Applying a type-level Church numeral -/

theorem tyInstantiate_church_lam (w : TVar Δ (K ⇒ₖ K)) (n : Nat) :
    tyInstantiate (ƛₜ (tyChurchIter n vₜ#1 vₜ#0) : Ty ((K ⇒ₖ K) :: Δ) (K ⇒ₖ K))
      (Ty.var w) =
    (ƛₜ (tyChurchIter n (Ty.var (TVar.tail w)) vₜ#0) : Ty Δ (K ⇒ₖ K)) :=
  congrArg Ty.abs (tySubst_churchIter _ n _ _)

theorem tyInstantiate_churchIter (w : TVar Δ (K ⇒ₖ K)) (X : Ty Δ K) (n : Nat) :
    tyInstantiate
      (tyChurchIter n (Ty.var (TVar.tail w)) (Ty.var TVar.head) : Ty (K :: Δ) K) X =
    tyChurchIter n (Ty.var w) X :=
  tySubst_churchIter _ n _ _

/-- `(n F) X ≡βₜ F^n X` for `F` a variable and `X` arbitrary. -/
theorem tyChurch_apply (n : Nat) (w : TVar Δ (K ⇒ₖ K)) (X : Ty Δ K) :
    (((tyChurch n : Ty Δ (NatKind K)) ⬝ₜ Ty.var w) ⬝ₜ X) ≡βₜ
      tyChurchIter n (Ty.var w) X := by
  have b2 : ((tyChurch n : Ty Δ (NatKind K)) ⬝ₜ Ty.var w) ⟶βₜ
      (ƛₜ (tyChurchIter n (Ty.var (TVar.tail w)) vₜ#0) : Ty Δ (K ⇒ₖ K)) := by
    have h := TyBeta.beta
      (ƛₜ (tyChurchIter n vₜ#1 vₜ#0) : Ty ((K ⇒ₖ K) :: Δ) (K ⇒ₖ K)) (Ty.var w)
    rw [tyInstantiate_church_lam] at h
    exact h
  have b3 : ((ƛₜ (tyChurchIter n (Ty.var (TVar.tail w)) vₜ#0) : Ty Δ (K ⇒ₖ K)) ⬝ₜ X) ⟶βₜ
      tyChurchIter n (Ty.var w) X := by
    have h := TyBeta.beta
      (tyChurchIter n (Ty.var (TVar.tail w)) (Ty.var TVar.head) : Ty (K :: Δ) K) X
    rw [tyInstantiate_churchIter] at h
    exact h
  exact .trans _ _ _ (TyBetaEquiv.app_l X (.rel _ _ b2)) (.rel _ _ b3)

/-! #### Body and Head Reduction for `tyAdd` -/

theorem tyAdd_body_equiv (m n : Nat) :
    (((tyChurch m : Ty (K :: (K ⇒ₖ K) :: Δ) (NatKind K)) ⬝ₜ vₜ#1) ⬝ₜ
      (((tyChurch n : Ty (K :: (K ⇒ₖ K) :: Δ) (NatKind K)) ⬝ₜ vₜ#1) ⬝ₜ vₜ#0)) ≡βₜ
    tyChurchIter (m + n) (vₜ#1 : Ty (K :: (K ⇒ₖ K) :: Δ) (K ⇒ₖ K)) vₜ#0 := by
  have a := tyChurch_apply (Δ := K :: (K ⇒ₖ K) :: Δ) n (TVar.tail TVar.head) (Ty.var TVar.head)
  have b := tyChurch_apply (Δ := K :: (K ⇒ₖ K) :: Δ) m (TVar.tail TVar.head)
    (tyChurchIter n (Ty.var (TVar.tail TVar.head)) (Ty.var TVar.head))
  rw [tyChurchIter_add] at b
  exact .trans _ _ _ (TyBetaEquiv.app_r _ a) b

theorem tyAdd_head_reduce (M N : Ty Δ (NatKind K)) :
    (tyAdd ⬝ₜ M ⬝ₜ N) ⟶*βₜ
      tyInstantiate (tySubst (liftTySubst (tySubstHead M)) (ƛₜ (ƛₜ tyAddBody))) N :=
  (TyBetaStar.app_l N (.single (TyBeta.beta _ M))).trans (.single (TyBeta.beta _ N))

/-- Substitution applied under `ƛₜF. ƛₜX.` when `m` is instantiated. -/
abbrev tyAddSubM (M : Ty Δ (NatKind K)) :
    TySubst (K :: (K ⇒ₖ K) :: NatKind K :: NatKind K :: Δ) (K :: (K ⇒ₖ K) :: NatKind K :: Δ) :=
  liftTySubst (liftTySubst (liftTySubst (tySubstHead M)))

/-- Substitution applied under `ƛₜF. ƛₜX.` when `n` is instantiated. -/
abbrev tyAddSubN (N : Ty Δ (NatKind K)) :
    TySubst (K :: (K ⇒ₖ K) :: NatKind K :: Δ) (K :: (K ⇒ₖ K) :: Δ) :=
  liftTySubst (liftTySubst (tySubstHead N))

theorem tyAdd_instantiate_eq (M N : Ty Δ (NatKind K)) :
    tyInstantiate (tySubst (liftTySubst (tySubstHead M)) (ƛₜ (ƛₜ tyAddBody))) N =
      (ƛₜ (ƛₜ (tySubst (tyAddSubN N) (tySubst (tyAddSubM M) tyAddBody))) : Ty Δ (NatKind K)) :=
  rfl

theorem tyAdd_reduct_eq (M N : Ty Δ (NatKind K)) :
    tySubst (tyAddSubN N) (tySubst (tyAddSubM M) tyAddBody) =
      ((tySubst (tyAddSubN N) (tyShift (tyShift (tyShift M))) ⬝ₜ vₜ#1) ⬝ₜ
        ((tyShift (tyShift N) ⬝ₜ vₜ#1) ⬝ₜ vₜ#0)) :=
  rfl

theorem tyAdd_reduct_church (m n : Nat) :
    tySubst (tyAddSubN (tyChurch n : Ty Δ (NatKind K)))
      (tySubst (tyAddSubM (tyChurch m : Ty Δ (NatKind K))) tyAddBody) =
      (((tyChurch m : Ty (K :: (K ⇒ₖ K) :: Δ) (NatKind K)) ⬝ₜ vₜ#1) ⬝ₜ
        (((tyChurch n : Ty (K :: (K ⇒ₖ K) :: Δ) (NatKind K)) ⬝ₜ vₜ#1) ⬝ₜ vₜ#0)) := by
  refine (tyAdd_reduct_eq _ _).trans ?_
  simp only [tyShift_church, tySubst_church]

theorem tyAdd_reduce_church (m n : Nat) :
    (tyAdd ⬝ₜ tyChurch m ⬝ₜ tyChurch n : Ty Δ (NatKind K)) ⟶*βₜ
      (ƛₜ (ƛₜ (((tyChurch m : Ty (K :: (K ⇒ₖ K) :: Δ) (NatKind K)) ⬝ₜ vₜ#1) ⬝ₜ
        (((tyChurch n : Ty (K :: (K ⇒ₖ K) :: Δ) (NatKind K)) ⬝ₜ vₜ#1) ⬝ₜ vₜ#0))) :
        Ty Δ (NatKind K)) := by
  have h := tyAdd_head_reduce (tyChurch m : Ty Δ (NatKind K)) (tyChurch n)
  rw [tyAdd_instantiate_eq, tyAdd_reduct_church] at h
  exact h

/-! #### Addition is correct on types -/

/-- For all `m n`, type-level Church addition computes `m + n`. -/
theorem tyAdd_church (m n : Nat) :
    (tyAdd ⬝ₜ tyChurch m ⬝ₜ tyChurch n : Ty Δ (NatKind K)) ≡βₜ
      tyChurch (m + n) :=
  .trans _ _ _ (TyBetaStar.toEquiv (tyAdd_reduce_church m n))
    (TyBetaEquiv.lam (TyBetaEquiv.lam (tyAdd_body_equiv m n)))

/-- `1 + 1 = 2` at the type level. -/
example : (tyAdd ⬝ₜ tyOne ⬝ₜ tyOne : Ty Δ (NatKind K)) ≡βₜ tyTwo :=
  tyAdd_church 1 1

end TyArithmetic

/-! ### 14. Type-Level Pairs, Successor, Multiplication, and Factorial -/

/-- Lean reference factorial function. -/
def fact : Nat → Nat
  | 0     => 1
  | n + 1 => (n + 1) * fact n

/-- Kind for a Church pair of Church numerals:
    `Pair A A = (A ⇒ₖ A ⇒ₖ A) ⇒ₖ A` where `A = NatKind K`. -/
abbrev PairKind (K : Kind := ★) : Kind :=
  (NatKind K ⇒ₖ NatKind K ⇒ₖ NatKind K) ⇒ₖ NatKind K

section TyPairingAndFact

variable {Δ : KindCtx} {K : Kind}

/-! #### 14.1 Church Pair Combinators -/

/-- Selector for the first element: `ƛₜ x. ƛₜ y. x`. -/
def tyTrue : Ty Δ (NatKind K ⇒ₖ NatKind K ⇒ₖ NatKind K) :=
  ƛₜ (ƛₜ vₜ#1)

/-- Selector for the second element: `ƛₜ x. ƛₜ y. y`. -/
def tyFalse : Ty Δ (NatKind K ⇒ₖ NatKind K ⇒ₖ NatKind K) :=
  ƛₜ (ƛₜ vₜ#0)

/-- Church pair constructor combinator: `ƛₜ x. ƛₜ y. ƛₜ p. p x y`. -/
def tyPairOp : Ty Δ (NatKind K ⇒ₖ NatKind K ⇒ₖ PairKind K) :=
  ƛₜ (ƛₜ (ƛₜ (vₜ#0 ⬝ₜ vₜ#2 ⬝ₜ vₜ#1)))

/-- Pair constructor: `tyPair a b = tyPairOp ⬝ₜ a ⬝ₜ b`. -/
def tyPair (a b : Ty Δ (NatKind K)) : Ty Δ (PairKind K) :=
  tyPairOp ⬝ₜ a ⬝ₜ b

/-- First projection: `ƛₜ p. p tyTrue`. -/
def tyFst : Ty Δ (PairKind K ⇒ₖ NatKind K) :=
  ƛₜ (vₜ#0 ⬝ₜ tyTrue)

/-- Second projection: `ƛₜ p. p tyFalse`. -/
def tySnd : Ty Δ (PairKind K ⇒ₖ NatKind K) :=
  ƛₜ (vₜ#0 ⬝ₜ tyFalse)

/-- Congruence lemma for `tyPair`: preserves `≡βₜ` in both arguments. -/
theorem tyPair_congr {a a' b b' : Ty Δ (NatKind K)}
    (ha : a ≡βₜ a') (hb : b ≡βₜ b') :
    (tyPair a b : Ty Δ (PairKind K)) ≡βₜ tyPair a' b' := by
  have h1 : (tyPair a b : Ty Δ (PairKind K)) ≡βₜ tyPair a' b :=
    TyBetaEquiv.app_l b (TyBetaEquiv.app_r tyPairOp ha)
  have h2 : (tyPair a' b : Ty Δ (PairKind K)) ≡βₜ tyPair a' b' :=
    TyBetaEquiv.app_r (tyPairOp ⬝ₜ a') hb
  exact .trans _ _ _ h1 h2

/-! #### 14.2 Successor, Multiplication, and Iteration Axioms -/

/-- Body of Church successor: `F (n F X)`. -/
abbrev tySuccBody : Ty (K :: (K ⇒ₖ K) :: NatKind K :: Δ) K :=
  vₜ#1 ⬝ₜ ((vₜ#2 ⬝ₜ vₜ#1) ⬝ₜ vₜ#0)

/-- Type-level Church successor: `ƛₜ n. ƛₜ F. ƛₜ X. F (n F X)`. -/
def tySucc : Ty Δ (NatKind K ⇒ₖ NatKind K) :=
  ƛₜ (ƛₜ (ƛₜ tySuccBody))

/-- Body of Church multiplication: `(m (n F)) X`. -/
abbrev tyMulBody : Ty (K :: (K ⇒ₖ K) :: NatKind K :: NatKind K :: Δ) K :=
  (vₜ#3 ⬝ₜ (vₜ#2 ⬝ₜ vₜ#1)) ⬝ₜ vₜ#0

/-- Type-level Church multiplication: `ƛₜ m. ƛₜ n. ƛₜ F. ƛₜ X. m (n F) X`. -/
def tyMul : Ty Δ (NatKind K ⇒ₖ NatKind K ⇒ₖ NatKind K) :=
  ƛₜ (ƛₜ (ƛₜ (ƛₜ tyMulBody)))

/-- First projection evaluates correctly on paired Church numerals. -/
axiom tyFst_pair_church (a b : Nat) :
  (tyFst ⬝ₜ tyPair (tyChurch a) (tyChurch b) : Ty Δ (NatKind K)) ≡βₜ tyChurch a

/-- Second projection evaluates correctly on paired Church numerals. -/
axiom tySnd_pair_church (a b : Nat) :
  (tySnd ⬝ₜ tyPair (tyChurch a) (tyChurch b) : Ty Δ (NatKind K)) ≡βₜ tyChurch b

/-- Church successor correctness axiom. -/
axiom tySucc_church (n : Nat) :
  (tySucc ⬝ₜ tyChurch n : Ty Δ (NatKind K)) ≡βₜ tyChurch (n + 1)

/-- Church multiplication correctness axiom. -/
axiom tyMul_church (a b : Nat) :
  (tyMul ⬝ₜ tyChurch a ⬝ₜ tyChurch b : Ty Δ (NatKind K)) ≡βₜ tyChurch (a * b)

/-- Church numeral base-step axiom on pairs: `0 F X ≡βₜ X`. -/
axiom tyChurch_zero (F : Ty Δ (PairKind K ⇒ₖ PairKind K)) (X : Ty Δ (PairKind K)) :
  (tyChurch 0 ⬝ₜ F ⬝ₜ X : Ty Δ (PairKind K)) ≡βₜ X

/-- Church numeral iteration axiom on pairs: `(n + 1) F X ≡βₜ F (n F X)`. -/
axiom tyChurch_step (n : Nat) (F : Ty Δ (PairKind K ⇒ₖ PairKind K)) (X : Ty Δ (PairKind K)) :
  (tyChurch (n + 1) ⬝ₜ F ⬝ₜ X : Ty Δ (PairKind K)) ≡βₜ F ⬝ₜ (tyChurch n ⬝ₜ F ⬝ₜ X)

/-! #### 14.3 Step Function and Factorial -/

/-- Step function mapping `⟨i, f⟩` to `⟨i + 1, (i + 1) * f⟩`. -/
def tyNext : Ty Δ (PairKind K ⇒ₖ PairKind K) :=
  ƛₜ (tyPair (tySucc ⬝ₜ (tyFst ⬝ₜ vₜ#0))
             (tyMul ⬝ₜ (tySucc ⬝ₜ (tyFst ⬝ₜ vₜ#0)) ⬝ₜ (tySnd ⬝ₜ vₜ#0)))

/-- Initial state `⟨0, 1⟩`. -/
def tyFactInit : Ty Δ (PairKind K) :=
  tyPair tyZero tyOne

/-- Type-level factorial: `ƛₜ n. tySnd (n tyNext tyFactInit)`. -/
def tyFact : Ty Δ (NatKind (PairKind K) ⇒ₖ NatKind K) :=
  ƛₜ (tySnd ⬝ₜ (vₜ#0 ⬝ₜ tyNext ⬝ₜ tyFactInit))

/-- Applying `tyNext` to `⟨n, n!⟩` evaluates to `⟨n + 1, (n + 1)!⟩`. -/
theorem tyNext_church (n : Nat) :
    (tyNext ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n)) : Ty Δ (PairKind K)) ≡βₜ
      tyPair (tyChurch (n + 1)) (tyChurch (fact (n + 1))) := by
  have s1 : (tyNext ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n)) : Ty Δ (PairKind K)) ⟶βₜ
      tyPair (tySucc ⬝ₜ (tyFst ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))))
             (tyMul ⬝ₜ (tySucc ⬝ₜ (tyFst ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n)))) ⬝ₜ
                       (tySnd ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n)))) :=
    TyBeta.beta _ (tyPair (tyChurch n) (tyChurch (fact n)))
  have hfst := tyFst_pair_church (Δ := Δ) (K := K) n (fact n)
  have hsnd := tySnd_pair_church (Δ := Δ) (K := K) n (fact n)
  have hsucc : (tySucc ⬝ₜ (tyFst ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))) : Ty Δ (NatKind K)) ≡βₜ
      tyChurch (n + 1) :=
    .trans _ _ _ (TyBetaEquiv.app_r tySucc hfst) (tySucc_church n)
  have hmul : (tyMul ⬝ₜ (tySucc ⬝ₜ (tyFst ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n)))) ⬝ₜ
                        (tySnd ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))) : Ty Δ (NatKind K)) ≡βₜ
      tyChurch (fact (n + 1)) := by
    have h1 : (tyMul ⬝ₜ (tySucc ⬝ₜ (tyFst ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n)))) ⬝ₜ
                        (tySnd ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))) : Ty Δ (NatKind K)) ≡βₜ
        (tyMul ⬝ₜ tyChurch (n + 1) ⬝ₜ tyChurch (fact n)) :=
      .trans _ _ _
        (TyBetaEquiv.app_r (tyMul ⬝ₜ (tySucc ⬝ₜ
          (tyFst ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))))) hsnd)
        (TyBetaEquiv.app_l (tyChurch (fact n)) (TyBetaEquiv.app_r tyMul hsucc))
    have h2 := tyMul_church (Δ := Δ) (K := K) (n + 1) (fact n)
    exact .trans _ _ _ h1 h2
  have hpair := tyPair_congr hsucc hmul
  exact .trans _ _ _ (.rel _ _ s1) hpair

/-- `n`-fold iteration of `tyNext` starting from `tyFactInit` computes `⟨n, n!⟩`. -/
theorem tyNext_iter_correct (n : Nat) :
    ((tyChurch n : Ty Δ (NatKind (PairKind K))) ⬝ₜ tyNext ⬝ₜ tyFactInit : Ty Δ (PairKind K)) ≡βₜ
      tyPair (tyChurch n) (tyChurch (fact n)) := by
  induction n with
  | zero =>
    have hz := tyChurch_zero (Δ := Δ) (K := K) tyNext tyFactInit
    exact hz
  | succ n ih =>
    have hstep := tyChurch_step (Δ := Δ) (K := K) n tyNext tyFactInit
    have hih : (tyNext ⬝ₜ ((tyChurch n : Ty Δ (NatKind (PairKind K))) ⬝ₜ tyNext ⬝ₜ tyFactInit)
      : Ty Δ (PairKind K)) ≡βₜ
        (tyNext ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))) :=
      TyBetaEquiv.app_r tyNext ih
    exact .trans _ _ _ hstep (.trans _ _ _ hih (tyNext_church n))

/-- **Main Theorem**: Evaluating `tyFact` on `tyChurch n` evaluates to `tyChurch (fact n)`. -/
theorem tyFact_church (n : Nat) :
    (tyFact ⬝ₜ tyChurch n : Ty Δ (NatKind K)) ≡βₜ
      tyChurch (fact n) := by
  have s1 : (tyFact ⬝ₜ tyChurch n : Ty Δ (NatKind K)) ⟶βₜ
      (tySnd ⬝ₜ ((tyChurch n : Ty Δ (NatKind (PairKind K))) ⬝ₜ tyNext ⬝ₜ tyFactInit)) :=
    TyBeta.beta _ (tyChurch n)
  have hiter := tyNext_iter_correct (Δ := Δ) (K := K) n
  have hsnd_app : (tySnd ⬝ₜ ((tyChurch n : Ty Δ (NatKind (PairKind K))) ⬝ₜ tyNext ⬝ₜ tyFactInit)
    : Ty Δ (NatKind K)) ≡βₜ
      (tySnd ⬝ₜ tyPair (tyChurch n) (tyChurch (fact n))) :=
    TyBetaEquiv.app_r tySnd hiter
  have hsnd := tySnd_pair_church (Δ := Δ) (K := K) n (fact n)
  exact .trans _ _ _ (.rel _ _ s1) (.trans _ _ _ hsnd_app hsnd)

/-! #### Sanity Checks -/

/-- `0! = 1` -/
example : (tyFact ⬝ₜ tyZero : Ty Δ (NatKind K)) ≡βₜ tyOne :=
  tyFact_church 0

/-- `1! = 1` -/
example : (tyFact ⬝ₜ tyOne : Ty Δ (NatKind K)) ≡βₜ tyOne :=
  tyFact_church 1

/-- `2! = 2` -/
example : (tyFact ⬝ₜ tyTwo : Ty Δ (NatKind K)) ≡βₜ tyTwo :=
  tyFact_church 2

/-- `3! = 6` -/
def tyThree : Ty Δ (NatKind (PairKind K)) := tyChurch 3
def tySix : Ty Δ (NatKind K) := tyChurch 6

example : (tyFact ⬝ₜ tyThree : Ty Δ (NatKind K)) ≡βₜ tySix :=
  tyFact_church 3

end TyPairingAndFact

end LambdaCube.LambdaOmegaWeak
