/-
Copyright (c) 2026 Serhii Khoma. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhii Khoma
-/
module

public import Mathlib.Logic.Relation
import Aesop

/-!
  # System λω-weak-weak (First-Order Type Operators)

  Axes supported:
  - (*, *): terms depending on terms (`ƛ` and `⬝`)
  - (□, □) restricted: types depending on types via first-order arities (`∀ₖ` and `⬝ₖ`).
    Higher-order kinds `K₁ ⇒ₖ K₂` are disallowed; kind arrows only take `★`.
    This prevents encoding Church numerals at the type level (no type-level factorial).

  Architecture:
  - Kinds: `★ | ∀ₖ K`
  - Types: intrinsically kinded `Ty Δ K` (`var`, `arrow`, `kabs`, `kapp`)
  - Type β-reduction and equivalence: `⟶βₜ`, `≡βₜ`
  - Terms: intrinsically typed `Term Δ Γ τ` for `τ : Ty Δ ★`, with:
    `Term.conv : τ ≡βₜ τ' → Term Δ Γ τ → Term Δ Γ τ'`
  - Correctness: Church addition computes `m + n`.


  As far as I see it, computation has levels:
    1. no church numerals are possible at all (happens when grammar doesnt have .abs and .app)
    2. church numerals are limited by polynomials (add, mul)
      (happens when grammar doesnt have polymorphism,
      therefore `fun n => exp n n` is not possible
      bc `exp` has type of something like `α -> (a -> a) -> a`)
    3. church numerals are limited by bounded loops/primitive recursion

  And this computation can be e.g. in term-level or type-level

  L-arrow:      term - 2, type - 1
  L-2:          term - 3, type - 1
  l-omega-weak: term - 2, type - 3

  Therefore idea was to create system that is between l-arrow and l-omega-weak

  THIS ONE: term - 2, type - 2

  TODO:
  1. find official name instead of l-omega-weak-weak
  2. find out if this system is sound
-/

@[expose] public section

namespace LambdaCube.LambdaOmegaWeakWeak

/-! ### 1. Kinds and Kind Contexts -/

/-- Kinds: `★` (proper types) and `∀ₖ K` (type constructor expecting a `★`). -/
inductive Kind : Type where
  | star    : Kind
  | forall_ : Kind → Kind
  deriving Repr, DecidableEq

notation "★" => Kind.star
prefix:72 "∀ₖ " => Kind.forall_

/-- Kind context tracking free type/constructor variables. -/
abbrev KindCtx := List Kind

/-- Typed de Bruijn index for a variable of kind `K` in `Δ`. -/
inductive TVar : KindCtx → Kind → Type where
  | head {Δ : KindCtx} {K : Kind} : TVar (K :: Δ) K
  | tail {Δ : KindCtx} {K S : Kind} (v : TVar Δ K) : TVar (S :: Δ) K

/-! ### 2. Types and Type Substitution -/

/-- Types of kind `K` in kind context `Δ`. -/
inductive Ty : KindCtx → Kind → Type where
  | var   {Δ : KindCtx} {K : Kind} (v : TVar Δ K) : Ty Δ K
  | arrow {Δ : KindCtx} (domain codomain : Ty Δ ★) : Ty Δ ★
  | kabs  {Δ : KindCtx} {K : Kind} (body : Ty (★ :: Δ) K) : Ty Δ (∀ₖ K)
  | kapp  {Δ : KindCtx} {K : Kind} (f : Ty Δ (∀ₖ K)) (arg : Ty Δ ★) : Ty Δ K

infixr:70 " ⇒ₜ " => Ty.arrow
prefix:71 "ƛₖ "  => Ty.kabs
infixl:70 " ⬝ₖ " => Ty.kapp

open Lean in
meta def mkTVarProof : Nat → MacroM Lean.Term
  | 0     => `(TVar.head)
  | n + 1 => do
    let inner ← mkTVarProof n
    `(TVar.tail $inner)

macro:max "vₜ#" n:num : term => do
  let v ← mkTVarProof n.getNat
  `($(Lean.mkIdent ``Ty.var) $v)

def TRename (Δ Δ' : KindCtx) := ∀ {K : Kind}, TVar Δ K → TVar Δ' K

def liftTRename {Δ Δ' : KindCtx} (ρ : TRename Δ Δ') : TRename (★ :: Δ) (★ :: Δ')
  | _, TVar.head   => TVar.head
  | _, TVar.tail v => TVar.tail (ρ v)

def renTy {Δ Δ' : KindCtx} (ρ : TRename Δ Δ') : {K : Kind} → Ty Δ K → Ty Δ' K
  | _, Ty.var v      => Ty.var (ρ v)
  | _, Ty.arrow s t  => Ty.arrow (renTy ρ s) (renTy ρ t)
  | _, Ty.kabs body  => Ty.kabs (renTy (liftTRename ρ) body)
  | _, Ty.kapp f arg => Ty.kapp (renTy ρ f) (renTy ρ arg)

def shiftTy {Δ : KindCtx} {S : Kind} : {K : Kind} → Ty Δ K → Ty (S :: Δ) K :=
  renTy TVar.tail

def TSubst (Δ Δ' : KindCtx) := ∀ {K : Kind}, TVar Δ K → Ty Δ' K

def liftTSubst {Δ Δ' : KindCtx} (σ : TSubst Δ Δ') : TSubst (★ :: Δ) (★ :: Δ')
  | _, TVar.head   => vₜ#0
  | _, TVar.tail v => shiftTy (σ v)

def substTy {Δ Δ' : KindCtx} (σ : TSubst Δ Δ') : {K : Kind} → Ty Δ K → Ty Δ' K
  | _, Ty.var v      => σ v
  | _, Ty.arrow s t  => Ty.arrow (substTy σ s) (substTy σ t)
  | _, Ty.kabs body  => Ty.kabs (substTy (liftTSubst σ) body)
  | _, Ty.kapp f arg => Ty.kapp (substTy σ f) (substTy σ arg)

def substHeadTy {Δ : KindCtx} (arg : Ty Δ ★) : TSubst (★ :: Δ) Δ
  | _, TVar.head   => arg
  | _, TVar.tail v => Ty.var v

/-- Single type substitution: `body[arg/0]`. -/
def instantiateTy {Δ : KindCtx} {K : Kind} (body : Ty (★ :: Δ) K) (arg : Ty Δ ★) : Ty Δ K :=
  substTy (substHeadTy arg) body

/-! ### 3. Type Beta Reduction and Equivalence -/

inductive BetaTy : {Δ : KindCtx} → {K : Kind} → Ty Δ K → Ty Δ K → Prop where
  | beta {Δ K} (body : Ty (★ :: Δ) K) (arg : Ty Δ ★) :
      BetaTy (Ty.kapp (Ty.kabs body) arg) (instantiateTy body arg)
  | arrow_l {Δ} {s s' : Ty Δ ★} (t : Ty Δ ★) :
      BetaTy s s' → BetaTy (Ty.arrow s t) (Ty.arrow s' t)
  | arrow_r {Δ} (s : Ty Δ ★) {t t' : Ty Δ ★} :
      BetaTy t t' → BetaTy (Ty.arrow s t) (Ty.arrow s t')
  | kabs {Δ K} {body body' : Ty (★ :: Δ) K} :
      BetaTy body body' → BetaTy (Ty.kabs body) (Ty.kabs body')
  | kapp_l {Δ K} {f f' : Ty Δ (∀ₖ K)} (arg : Ty Δ ★) :
      BetaTy f f' → BetaTy (Ty.kapp f arg) (Ty.kapp f' arg)
  | kapp_r {Δ K} (f : Ty Δ (∀ₖ K)) {arg arg' : Ty Δ ★} :
      BetaTy arg arg' → BetaTy (Ty.kapp f arg) (Ty.kapp f arg')

infix:50 " ⟶βₜ " => BetaTy

abbrev BetaTyStar {Δ : KindCtx} {K : Kind} : Ty Δ K → Ty Δ K → Prop :=
  Relation.ReflTransGen BetaTy

infix:50 " ⟶*βₜ " => BetaTyStar

abbrev BetaTyEquiv {Δ : KindCtx} {K : Kind} : Ty Δ K → Ty Δ K → Prop :=
  Relation.EqvGen BetaTy

infix:50 " ≡βₜ " => BetaTyEquiv

namespace BetaTyStar

theorem toEquiv {Δ : KindCtx} {K : Kind} {a b : Ty Δ K} (h : a ⟶*βₜ b) : a ≡βₜ b := by
  induction h with
  | refl => exact .refl _
  | tail _ hs ih => exact .trans _ _ _ ih (.rel _ _ hs)

theorem kapp_l {Δ : KindCtx} {K : Kind} {f f' : Ty Δ (∀ₖ K)} (arg : Ty Δ ★)
    (h : f ⟶*βₜ f') : (f ⬝ₖ arg) ⟶*βₜ (f' ⬝ₖ arg) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (BetaTy.kapp_l arg hstep)

theorem kapp_r {Δ : KindCtx} {K : Kind} (f : Ty Δ (∀ₖ K)) {arg arg' : Ty Δ ★}
    (h : arg ⟶*βₜ arg') : (f ⬝ₖ arg) ⟶*βₜ (f ⬝ₖ arg') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (BetaTy.kapp_r f hstep)

end BetaTyStar

namespace BetaTyEquiv

theorem kapp_l {Δ : KindCtx} {K : Kind} {f f' : Ty Δ (∀ₖ K)} (arg : Ty Δ ★)
    (h : f ≡βₜ f') : (f ⬝ₖ arg) ≡βₜ (f' ⬝ₖ arg) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (BetaTy.kapp_l arg hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem kapp_r {Δ : KindCtx} {K : Kind} (f : Ty Δ (∀ₖ K)) {arg arg' : Ty Δ ★}
    (h : arg ≡βₜ arg') : (f ⬝ₖ arg) ≡βₜ (f ⬝ₖ arg') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (BetaTy.kapp_r f hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem kabs {Δ : KindCtx} {K : Kind} {body body' : Ty (★ :: Δ) K}
    (h : body ≡βₜ body') : (ƛₖ body : Ty Δ (∀ₖ K)) ≡βₜ (ƛₖ body') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (BetaTy.kabs hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

end BetaTyEquiv

/-! ### 4. Term Contexts and Variables -/

abbrev Ctx (Δ : KindCtx) := List (Ty Δ ★)

inductive Var : {Δ : KindCtx} → Ctx Δ → Ty Δ ★ → Type where
  | head {Δ} {Γ : Ctx Δ} {τ : Ty Δ ★} : Var (τ :: Γ) τ
  | tail {Δ} {Γ : Ctx Δ} {τ S : Ty Δ ★} (v : Var Γ τ) : Var (S :: Γ) τ

/-! ### 5. Terms and Conversion -/

/-- Intrinsically typed terms in λω-weak-weak with type conversion. -/
inductive Term : (Δ : KindCtx) → Ctx Δ → Ty Δ ★ → Type where
  | var  {Δ Γ τ} (v : Var Γ τ) : Term Δ Γ τ
  | abs  {Δ Γ S τ} (body : Term Δ (S :: Γ) τ) : Term Δ Γ (S ⇒ₜ τ)
  | app  {Δ Γ S τ} (f : Term Δ Γ (S ⇒ₜ τ)) (arg : Term Δ Γ S) : Term Δ Γ τ
  | conv {Δ Γ τ τ'} (h : τ ≡βₜ τ') (t : Term Δ Γ τ) : Term Δ Γ τ'

prefix:71 "ƛ "  => Term.abs
infixl:70 " ⬝ "  => Term.app

open Lean in
meta def mkVarProof : Nat → MacroM Lean.Term
  | 0     => `(Var.head)
  | n + 1 => do
    let inner ← mkVarProof n
    `(Var.tail $inner)

macro:max "v#" n:num : term => do
  let v ← mkVarProof n.getNat
  `($(Lean.mkIdent ``Term.var) $v)

/-! ### 6. Term Renaming and Substitution -/

def Rename {Δ : KindCtx} (Γ ΔΓ : Ctx Δ) := ∀ {τ : Ty Δ ★}, Var Γ τ → Var ΔΓ τ

def liftRename {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} {S : Ty Δ ★} (ρ : Rename Γ ΔΓ)
  : Rename (S :: Γ) (S :: ΔΓ)
  | _, Var.head   => Var.head
  | _, Var.tail v => Var.tail (ρ v)

def rename {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} (ρ : Rename Γ ΔΓ) : {τ : Ty Δ ★} → Term Δ Γ τ → Term Δ ΔΓ τ
  | _, Term.var v     => Term.var (ρ v)
  | _, Term.abs body  => Term.abs (rename (liftRename ρ) body)
  | _, Term.app f arg => Term.app (rename ρ f) (rename ρ arg)
  | _, Term.conv h t  => Term.conv h (rename ρ t)

def shift {Δ : KindCtx} {Γ : Ctx Δ} {S : Ty Δ ★} : {τ : Ty Δ ★} → Term Δ Γ τ → Term Δ (S :: Γ) τ :=
  rename Var.tail

def Subst {Δ : KindCtx} (Γ ΔΓ : Ctx Δ) := ∀ {τ : Ty Δ ★}, Var Γ τ → Term Δ ΔΓ τ

def liftSubst {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} {S : Ty Δ ★} (σ : Subst Γ ΔΓ) : Subst (S :: Γ) (S :: ΔΓ)
  | _, Var.head   => v#0
  | _, Var.tail v => shift (σ v)

def subst {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} (σ : Subst Γ ΔΓ) : {τ : Ty Δ ★} → Term Δ Γ τ → Term Δ ΔΓ τ
  | _, Term.var v     => σ v
  | _, Term.abs body  => Term.abs (subst (liftSubst σ) body)
  | _, Term.app f arg => Term.app (subst σ f) (subst σ arg)
  | _, Term.conv h t  => Term.conv h (subst σ t)

def substHead {Δ : KindCtx} {Γ : Ctx Δ} {S : Ty Δ ★} (arg : Term Δ Γ S) : Subst (S :: Γ) Γ
  | _, Var.head   => arg
  | _, Var.tail v => Term.var v

def instantiate {Δ : KindCtx} {Γ : Ctx Δ} {S τ : Ty Δ ★} (body : Term Δ (S :: Γ) τ)
    (arg : Term Δ Γ S) : Term Δ Γ τ :=
  subst (substHead arg) body

/-! ### 7. Term Beta Reduction -/

inductive Beta : {Δ : KindCtx} → {Γ : Ctx Δ} → {τ : Ty Δ ★} → Term Δ Γ τ → Term Δ Γ τ → Prop where
  | beta {Δ Γ S τ} (body : Term Δ (S :: Γ) τ) (arg : Term Δ Γ S) :
      Beta (Term.app (Term.abs body) arg) (instantiate body arg)
  | lam {Δ Γ S τ} {body body' : Term Δ (S :: Γ) τ} :
      Beta body body' → Beta (Term.abs body) (Term.abs body')
  | app_l {Δ Γ S τ} {f f' : Term Δ Γ (S ⇒ₜ τ)} (arg : Term Δ Γ S) :
      Beta f f' → Beta (Term.app f arg) (Term.app f' arg)
  | app_r {Δ Γ S τ} (f : Term Δ Γ (S ⇒ₜ τ)) {arg arg' : Term Δ Γ S} :
      Beta arg arg' → Beta (Term.app f arg) (Term.app f arg')
  -- Conversion reduction rules
  | conv {Δ Γ τ τ'} (h : τ ≡βₜ τ') {t t' : Term Δ Γ τ} :
      Beta t t' → Beta (Term.conv h t) (Term.conv h t')
  | conv_trans {Δ Γ τ₁ τ₂ τ₃} (h₁ : τ₁ ≡βₜ τ₂) (h₂ : τ₂ ≡βₜ τ₃) (t : Term Δ Γ τ₁) :
      Beta (Term.conv h₂ (Term.conv h₁ t)) (Term.conv (.trans _ _ _ h₁ h₂) t)
  | conv_refl {Δ Γ τ} (h : τ ≡βₜ τ) (t : Term Δ Γ τ) :
      Beta (Term.conv h t) t

infix:50 " ⟶β " => Beta

abbrev BetaStar {Δ : KindCtx} {Γ : Ctx Δ} {τ : Ty Δ ★} : Term Δ Γ τ → Term Δ Γ τ → Prop :=
  Relation.ReflTransGen Beta

infix:50 " ⟶*β " => BetaStar

namespace BetaStar

theorem lam {Δ Γ S τ} {body body' : Term Δ (S :: Γ) τ} (h : body ⟶*β body') :
    (ƛ body : Term Δ Γ (S ⇒ₜ τ)) ⟶*β (ƛ body') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.lam hstep)

theorem app_l {Δ Γ S τ} {f f' : Term Δ Γ (S ⇒ₜ τ)} (arg : Term Δ Γ S) (h : f ⟶*β f') :
    (f ⬝ arg) ⟶*β (f' ⬝ arg) := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.app_l arg hstep)

theorem app_r {Δ Γ S τ} (f : Term Δ Γ (S ⇒ₜ τ)) {arg arg' : Term Δ Γ S} (h : arg ⟶*β arg') :
    (f ⬝ arg) ⟶*β (f ⬝ arg') := by
  induction h with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.app_r f hstep)

theorem conv {Δ Γ τ τ'} (h : τ ≡βₜ τ') {t t' : Term Δ Γ τ} (hred : t ⟶*β t') :
    Term.conv h t ⟶*β Term.conv h t' := by
  induction hred with
  | refl => rfl
  | tail _ hstep ih => exact ih.tail (Beta.conv h hstep)

end BetaStar

abbrev BetaEquiv {Δ : KindCtx} {Γ : Ctx Δ} {τ : Ty Δ ★} : Term Δ Γ τ → Term Δ Γ τ → Prop :=
  Relation.EqvGen Beta

infix:50 " ≡β " => BetaEquiv

theorem BetaStar.toEquiv {Δ : KindCtx} {Γ : Ctx Δ} {τ : Ty Δ ★} {a b : Term Δ Γ τ}
    (h : a ⟶*β b) : a ≡β b := by
  induction h with
  | refl => exact .refl _
  | tail _ hs ih => exact .trans _ _ _ ih (.rel _ _ hs)

namespace BetaEquiv

theorem lam {Δ Γ S τ} {body body' : Term Δ (S :: Γ) τ} (h : body ≡β body') :
    (ƛ body : Term Δ Γ (S ⇒ₜ τ)) ≡β (ƛ body') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.lam hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_l {Δ Γ S τ} {f f' : Term Δ Γ (S ⇒ₜ τ)} (arg : Term Δ Γ S) (h : f ≡β f') :
    (f ⬝ arg) ≡β (f' ⬝ arg) := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.app_l arg hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem app_r {Δ Γ S τ} (f : Term Δ Γ (S ⇒ₜ τ)) {arg arg' : Term Δ Γ S} (h : arg ≡β arg') :
    (f ⬝ arg) ≡β (f ⬝ arg') := by
  induction h with
  | rel _ _ hstep => exact .rel _ _ (Beta.app_r f hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

theorem conv {Δ Γ τ τ'} (h : τ ≡βₜ τ') {t t' : Term Δ Γ τ} (heq : t ≡β t') :
    Term.conv h t ≡β Term.conv h t' := by
  induction heq with
  | rel _ _ hstep => exact .rel _ _ (Beta.conv h hstep)
  | refl => exact .refl _
  | symm _ _ _ ih => exact .symm _ _ ih
  | trans _ _ _ _ _ ih1 ih2 => exact .trans _ _ _ ih1 ih2

end BetaEquiv

/-! ### 8. Cancellation of Inverse Conversions -/

theorem conv_cancel {Δ : KindCtx} {Γ : Ctx Δ} {τ τ' : Ty Δ ★}
    (h : τ ≡βₜ τ') (t : Term Δ Γ τ') :
    Term.conv h (Term.conv h.symm t) ⟶*β t :=
  (Relation.ReflTransGen.single (Beta.conv_trans h.symm h t)).trans
    (Relation.ReflTransGen.single (Beta.conv_refl (.trans _ _ _ h.symm h) t))

theorem conv_cancel_equiv {Δ : KindCtx} {Γ : Ctx Δ} {τ τ' : Ty Δ ★}
    (h : τ ≡βₜ τ') (t : Term Δ Γ τ') :
    Term.conv h (Term.conv h.symm t) ≡β t :=
  BetaStar.toEquiv (conv_cancel h t)

/-! ### 9. The Church Nat Type Constructor & Church Numerals -/

/-- Church Nat type operator of kind `∀ₖ ★`: `ƛₖ α. (α ⇒ₜ α) ⇒ₜ α ⇒ₜ α` -/
def NatOp {Δ : KindCtx} : Ty Δ (∀ₖ ★) :=
  ƛₖ ((vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0)

/-- Application of the Church Nat operator to any proper type `A : Ty Δ ★`. -/
def NatTy {Δ : KindCtx} (A : Ty Δ ★) : Ty Δ ★ :=
  NatOp ⬝ₖ A

/-- Computation at the type level: `NatOp ⬝ₖ A ⟶βₜ (A ⇒ₜ A) ⇒ₜ A ⇒ₜ A` -/
theorem NatTy_reduce {Δ : KindCtx} (A : Ty Δ ★) :
    NatTy A ⟶βₜ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A) := by
  change NatOp ⬝ₖ A ⟶βₜ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)
  exact BetaTy.beta ((vₜ#0 ⇒ₜ vₜ#0) ⇒ₜ vₜ#0 ⇒ₜ vₜ#0) A

theorem NatTy_equiv {Δ : KindCtx} (A : Ty Δ ★) :
    NatTy A ≡βₜ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A) :=
  Relation.EqvGen.rel _ _ (NatTy_reduce A)

/-- Church iteration `f^n x` -/
def churchIter (n : Nat) {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★}
    (f : Term Δ Γ (A ⇒ₜ A)) (x : Term Δ Γ A) : Term Δ Γ A :=
  match n with
  | 0     => x
  | n + 1 => f ⬝ churchIter n f x

/-- Raw Church numeral at type `(A ⇒ₜ A) ⇒ₜ A ⇒ₜ A`. -/
def churchCore (n : Nat) {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★) :
    Term Δ Γ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A) :=
  ƛ (ƛ (churchIter n v#1 v#0))

/-- Church numeral typed at `NatTy A`, using type conversion `conv`. -/
def church (n : Nat) {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★) :
    Term Δ Γ (NatTy A) :=
  Term.conv (NatTy_equiv A).symm (churchCore n A)

/-- Church addition on `NatTy A`. -/
def add {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★) :
    Term Δ Γ (NatTy A ⇒ₜ NatTy A ⇒ₜ NatTy A) :=
  ƛ (
    ƛ (
      Term.conv (NatTy_equiv A).symm (
        ƛ (
          ƛ (
            ((Term.conv (NatTy_equiv A) v#3 ⬝ v#1) ⬝
              ((Term.conv (NatTy_equiv A) v#2 ⬝ v#1) ⬝ v#0))
          )
        )
      )
    )
  )

/-! ### 10. Numerals are Closed under Renaming and Substitution -/

theorem churchIter_add {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (m n : Nat)
    (f : Term Δ Γ (A ⇒ₜ A)) (x : Term Δ Γ A) :
    churchIter m f (churchIter n f x) = churchIter (m + n) f x := by
  induction m with
  | zero =>
    exact (congrArg (fun j => churchIter j f x) (Nat.zero_add n)).symm
  | succ m ih =>
    have hmn : m + 1 + n = (m + n) + 1 := by omega
    rw [hmn]
    exact congrArg (Term.app f) ih

theorem rename_churchIter {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} {A : Ty Δ ★} (ρ : Rename Γ ΔΓ) (n : Nat)
    (f : Term Δ Γ (A ⇒ₜ A)) (x : Term Δ Γ A) :
    rename ρ (churchIter n f x) = churchIter n (rename ρ f) (rename ρ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (rename ρ f)) ih

theorem subst_churchIter {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} {A : Ty Δ ★} (σ : Subst Γ ΔΓ) (n : Nat)
    (f : Term Δ Γ (A ⇒ₜ A)) (x : Term Δ Γ A) :
    subst σ (churchIter n f x) = churchIter n (subst σ f) (subst σ x) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Term.app (subst σ f)) ih

theorem rename_churchCore {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} (A : Ty Δ ★) (ρ : Rename Γ ΔΓ) (m : Nat) :
    rename ρ (churchCore m A : Term Δ Γ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)) = churchCore m A :=
  congrArg Term.abs (congrArg Term.abs (rename_churchIter _ m _ _))

theorem subst_churchCore {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} (A : Ty Δ ★) (σ : Subst Γ ΔΓ) (m : Nat) :
    subst σ (churchCore m A : Term Δ Γ ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)) = churchCore m A :=
  congrArg Term.abs (congrArg Term.abs (subst_churchIter _ m _ _))

theorem rename_church {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} (A : Ty Δ ★) (ρ : Rename Γ ΔΓ) (m : Nat) :
    rename ρ (church m A : Term Δ Γ (NatTy A)) = church m A :=
  congrArg (Term.conv _) (rename_churchCore A ρ m)

theorem subst_church {Δ : KindCtx} {Γ ΔΓ : Ctx Δ} (A : Ty Δ ★) (σ : Subst Γ ΔΓ) (m : Nat) :
    subst σ (church m A : Term Δ Γ (NatTy A)) = church m A :=
  congrArg (Term.conv _) (subst_churchCore A σ m)

theorem shift_church {Δ : KindCtx} {Γ : Ctx Δ} {S : Ty Δ ★} (A : Ty Δ ★) (m : Nat) :
    (shift (church m A : Term Δ Γ (NatTy A)) : Term Δ (S :: Γ) (NatTy A)) =
      church m A :=
  rename_church A Var.tail m

/-! ### 11. Application of Church Numerals -/

theorem instantiate_church_lam {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★)
    (w : Var Γ (A ⇒ₜ A)) (n : Nat) :
    instantiate (ƛ (churchIter n v#1 v#0) : Term Δ ((A ⇒ₜ A) :: Γ) (A ⇒ₜ A))
      (Term.var w) =
    (ƛ (churchIter n (Term.var (Var.tail w)) v#0) : Term Δ Γ (A ⇒ₜ A)) :=
  congrArg Term.abs (subst_churchIter _ n _ _)

theorem instantiate_churchIter {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★}
    (w : Var Γ (A ⇒ₜ A)) (X : Term Δ Γ A) (n : Nat) :
    instantiate
      (churchIter n (Term.var (Var.tail w)) v#0 : Term Δ (A :: Γ) A) X =
    churchIter n (Term.var w) X :=
  subst_churchIter _ n _ _

theorem churchCore_apply {Δ : KindCtx} {Γ : Ctx Δ} (n : Nat) (A : Ty Δ ★)
    (w : Var Γ (A ⇒ₜ A)) (X : Term Δ Γ A) :
    ((churchCore n A ⬝ Term.var w) ⬝ X) ≡β churchIter n (Term.var w) X := by
  have b1 : ((churchCore n A ⬝ Term.var w) : Term Δ Γ (A ⇒ₜ A)) ⟶β
      (ƛ (churchIter n (Term.var (Var.tail w)) v#0)) := by
    have h := Beta.beta (ƛ (churchIter n v#1 v#0)) (Term.var w)
    rw [instantiate_church_lam] at h
    exact h
  have b2 : ((ƛ (churchIter n (Term.var (Var.tail w)) v#0) : Term Δ Γ (A ⇒ₜ A)) ⬝ X) ⟶β
      churchIter n (Term.var w) X := by
    have h := Beta.beta
      (churchIter n (Term.var (Var.tail w)) v#0) X
    rw [instantiate_churchIter] at h
    exact h
  exact Relation.EqvGen.trans _ _ _
    (BetaEquiv.app_l X (Relation.EqvGen.rel _ _ b1))
    (Relation.EqvGen.rel _ _ b2)

/-! ### 12. Correctness of Addition -/

theorem add_head_reduce {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★)
    (M N : Term Δ Γ (NatTy A)) :
    (add A ⬝ M ⬝ N) ⟶*β
      instantiate
        (subst (liftSubst (substHead M))
          (Term.conv (NatTy_equiv A).symm
            (ƛ (ƛ (((Term.conv (NatTy_equiv A) v#3 ⬝ v#1) ⬝
                    ((Term.conv (NatTy_equiv A) v#2 ⬝ v#1) ⬝ v#0)))))))
        N :=
  (BetaStar.app_l N (.single (Beta.beta _ M))).trans (.single (Beta.beta _ N))

/-- The substitution applied under `ƛ ƛ` when `N` is instantiated. -/
abbrev addSub {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (N : Term Δ Γ (NatTy A)) :
    Subst (A :: (A ⇒ₜ A) :: NatTy A :: Γ) (A :: (A ⇒ₜ A) :: Γ) :=
  liftSubst (liftSubst (substHead N))

/-- What `M` becomes after both substitutions. -/
def addP {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (M N : Term Δ Γ (NatTy A)) :
    Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A) :=
  subst (addSub N) (shift (shift (shift M)))

/-- What `N` becomes after both substitutions. -/
def addQ {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (N : Term Δ Γ (NatTy A)) :
    Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A) :=
  subst (addSub N) (shift (shift v#0))

theorem addQ_eq {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (N : Term Δ Γ (NatTy A)) :
    addQ N = (shift (shift N) : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) := rfl

theorem addP_church {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (m n : Nat) :
    addP (church m A : Term Δ Γ (NatTy A)) (church n A) =
      (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) := by
  unfold addP
  rw [shift_church, shift_church, shift_church, subst_church]

theorem addQ_church {Δ : KindCtx} {Γ : Ctx Δ} {A : Ty Δ ★} (n : Nat) :
    addQ (church n A : Term Δ Γ (NatTy A)) =
      (church n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) := by
  rw [addQ_eq, shift_church, shift_church]

theorem add_reduce {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★)
    (M N : Term Δ Γ (NatTy A)) :
    (add A ⬝ M ⬝ N) ⟶*β
      Term.conv (NatTy_equiv A).symm (
        ƛ (ƛ (((Term.conv (NatTy_equiv A) (addP M N) ⬝ v#1) ⬝
              ((Term.conv (NatTy_equiv A) (addQ N) ⬝ v#1) ⬝ v#0))))) := by
  refine (add_head_reduce A M N).trans ?_
  exact Relation.ReflTransGen.refl

theorem add_reduce_church {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★) (m n : Nat) :
    (add A ⬝ church m A ⬝ church n A) ⟶*β
      Term.conv (NatTy_equiv A).symm (
        ƛ (ƛ (((Term.conv (NatTy_equiv A)
                  (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝ v#1) ⬝
              ((Term.conv (NatTy_equiv A)
                  (church n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝ v#1) ⬝ v#0))))) := by
  have h := add_reduce (Γ := Γ) A (church m A) (church n A)
  rw [addP_church, addQ_church] at h
  exact h

theorem add_body_equiv {Δ : KindCtx} {Γ : Ctx Δ} (A : Ty Δ ★) (m n : Nat) :
    (((Term.conv (NatTy_equiv A)
          (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝
        (v#1 : Term Δ (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A))) ⬝
      ((Term.conv (NatTy_equiv A)
          (church n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝
        (v#1 : Term Δ (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A))) ⬝
       (v#0 : Term Δ (A :: (A ⇒ₜ A) :: Γ) A)))) ≡β
    churchIter (m + n) (v#1 : Term Δ (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A)) v#0 := by
  have c_m : Term.conv (NatTy_equiv A)
      (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ≡β
      (churchCore m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)) :=
    conv_cancel_equiv (Γ := A :: (A ⇒ₜ A) :: Γ) (NatTy_equiv A) (churchCore m A)
  have c_n : Term.conv (NatTy_equiv A)
      (church n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ≡β
      (churchCore n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) ((A ⇒ₜ A) ⇒ₜ A ⇒ₜ A)) :=
    conv_cancel_equiv (Γ := A :: (A ⇒ₜ A) :: Γ) (NatTy_equiv A) (churchCore n A)
  -- Reduce application of numeral n
  have app_n :
    ((Term.conv (NatTy_equiv A)
        (church n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝
        (v#1 : Term Δ (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A))) ⬝ v#0) ≡β
    churchIter n v#1 v#0 := by
    refine .trans _ _ _ (BetaEquiv.app_l v#0 (BetaEquiv.app_l v#1 c_n)) ?_
    exact churchCore_apply n A (Var.tail Var.head) v#0
  -- Reduce application of numeral m
  have app_m :
    ((Term.conv (NatTy_equiv A)
        (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝
        (v#1 : Term Δ (A :: (A ⇒ₜ A) :: Γ) (A ⇒ₜ A))) ⬝
      (churchIter n v#1 v#0)) ≡β
    churchIter m v#1 (churchIter n v#1 v#0) := by
    refine .trans _ _ _ (BetaEquiv.app_l (churchIter n v#1 v#0) (BetaEquiv.app_l v#1 c_m)) ?_
    exact churchCore_apply m A (Var.tail Var.head)
      (churchIter n (Term.var (Var.tail Var.head)) v#0)
  -- Combine steps
  have step1 :
    (((Term.conv (NatTy_equiv A)
          (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝ v#1) ⬝
      ((Term.conv (NatTy_equiv A)
          (church n A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝ v#1) ⬝ v#0))) ≡β
    ((Term.conv (NatTy_equiv A)
        (church m A : Term Δ (A :: (A ⇒ₜ A) :: Γ) (NatTy A)) ⬝ v#1) ⬝
      (churchIter n v#1 v#0)) :=
    BetaEquiv.app_r _ app_n
  refine .trans _ _ _ step1 (.trans _ _ _ app_m ?_)
  rw [churchIter_add m n]
  exact .refl _

/-- Church addition correctness in λω-weak-weak: `add ⬝ m ⬝ n ≡β church (m + n)`. -/
theorem add_church {Δ : KindCtx} (Γ : Ctx Δ) (A : Ty Δ ★) (m n : Nat) :
    ((add A : Term Δ Γ _) ⬝ church m A ⬝ church n A) ≡β church (m + n) A := by
  have hred := BetaStar.toEquiv (add_reduce_church (Γ := Γ) A m n)
  have hbody := BetaEquiv.lam (BetaEquiv.lam (add_body_equiv (Γ := Γ) A m n))
  exact .trans _ _ _ hred (BetaEquiv.conv (NatTy_equiv A).symm hbody)

/-! ### 13. Type-Level Church Numerals & Addition Correctness -/

/-- Iterated application of a type constructor: `W (W (... (W X)))` repeated `n` times. -/
def tyChurchIter (n : Nat) {Δ : KindCtx} (F : Ty Δ (∀ₖ ★)) (X : Ty Δ ★) : Ty Δ ★ :=
  match n with
  | 0     => X
  | n + 1 => F ⬝ₖ tyChurchIter n F X

/-- Type-level Church numeral generator at kind `∀ₖ ★`: `ƛₖ X. W^n X`. -/
def tyChurch (n : Nat) {Δ : KindCtx} (W : TVar Δ (∀ₖ ★)) : Ty Δ (∀ₖ ★) :=
  ƛₖ (tyChurchIter n (Ty.var (TVar.tail W)) vₜ#0)

/-- Type-level Church addition: composes two type constructors of kind `∀ₖ ★`. -/
def tyAdd {Δ : KindCtx} (M N : Ty Δ (∀ₖ ★)) : Ty Δ (∀ₖ ★) :=
  ƛₖ (shiftTy M ⬝ₖ (shiftTy N ⬝ₖ vₜ#0))

theorem tyChurchIter_add {Δ : KindCtx} (m n : Nat)
    (F : Ty Δ (∀ₖ ★)) (X : Ty Δ ★) :
    tyChurchIter m F (tyChurchIter n F X) = tyChurchIter (m + n) F X := by
  induction m with
  | zero =>
    exact (congrArg (fun j => tyChurchIter j F X) (Nat.zero_add n)).symm
  | succ m ih =>
    have hmn : m + 1 + n = (m + n) + 1 := by omega
    rw [hmn]
    exact congrArg (Ty.kapp F) ih

theorem subst_tyChurchIter {Δ Δ' : KindCtx} (σ : TSubst Δ Δ') (n : Nat)
    (F : Ty Δ (∀ₖ ★)) (X : Ty Δ ★) :
    substTy σ (tyChurchIter n F X) = tyChurchIter n (substTy σ F) (substTy σ X) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Ty.kapp (substTy σ F)) ih

theorem instantiateTy_churchIter {Δ : KindCtx}
    (W : TVar Δ (∀ₖ ★)) (X : Ty Δ ★) (n : Nat) :
    instantiateTy
      (tyChurchIter n (Ty.var (TVar.tail W)) vₜ#0 : Ty (★ :: Δ) ★) X =
    tyChurchIter n (Ty.var W) X :=
  subst_tyChurchIter (substHeadTy X) n _ _

/-- Applying a type-level Church numeral `tyChurch n W` to `X` reduces to `W^n X`. -/
theorem tyChurch_apply {Δ : KindCtx} (n : Nat)
    (W : TVar Δ (∀ₖ ★)) (X : Ty Δ ★) :
    (tyChurch n W ⬝ₖ X) ≡βₜ tyChurchIter n (Ty.var W) X := by
  have h := BetaTy.beta
    (tyChurchIter n (Ty.var (TVar.tail W)) vₜ#0) X
  rw [instantiateTy_churchIter] at h
  exact Relation.EqvGen.rel _ _ h

theorem renTy_tyChurchIter {Δ Δ' : KindCtx} (ρ : TRename Δ Δ') (n : Nat)
    (F : Ty Δ (∀ₖ ★)) (X : Ty Δ ★) :
    renTy ρ (tyChurchIter n F X) = tyChurchIter n (renTy ρ F) (renTy ρ X) := by
  induction n with
  | zero => rfl
  | succ n ih => exact congrArg (Ty.kapp (renTy ρ F)) ih

theorem renTy_tyChurch {Δ Δ' : KindCtx} (ρ : TRename Δ Δ') (n : Nat)
    (W : TVar Δ (∀ₖ ★)) :
    renTy ρ (tyChurch n W) = tyChurch n (ρ W) := by
  dsimp [tyChurch]
  grind only [renTy, renTy_tyChurchIter, Ty.var.injEq, liftTRename]

theorem shiftTy_tyChurch {Δ : KindCtx} {S : Kind} (n : Nat)
    (W : TVar Δ (∀ₖ ★)) :
    (shiftTy (tyChurch n W) : Ty (S :: Δ) (∀ₖ ★)) =
      tyChurch n (TVar.tail W) :=
  renTy_tyChurch TVar.tail n W

theorem substTy_tyChurch {Δ Δ' : KindCtx} (σ : TSubst Δ Δ') (n : Nat)
    (W : TVar Δ (∀ₖ ★)) (W' : TVar Δ' (∀ₖ ★)) (hW : σ W = Ty.var W') :
    substTy σ (tyChurch n W) = tyChurch n W' := by
  dsimp [tyChurch, substTy]
  congr 1
  rw [subst_tyChurchIter]
  dsimp [substTy, liftTSubst, shiftTy, renTy]
  simp_all only
  rfl

theorem tyAdd_reduce_church {Δ : KindCtx} (m n : Nat)
    (W : TVar Δ (∀ₖ ★)) (X : Ty Δ ★) :
    (tyAdd (tyChurch m W) (tyChurch n W) ⬝ₖ X) ⟶βₜ
      (tyChurch m W ⬝ₖ (tyChurch n W ⬝ₖ X)) := by
  have h := BetaTy.beta
    (shiftTy (tyChurch m W) ⬝ₖ (shiftTy (tyChurch n W) ⬝ₖ Ty.var TVar.head)) X
  have hRHS : instantiateTy
      (shiftTy (tyChurch m W) ⬝ₖ (shiftTy (tyChurch n W) ⬝ₖ Ty.var TVar.head)) X =
      (tyChurch m W ⬝ₖ (tyChurch n W ⬝ₖ X)) := by
    dsimp [instantiateTy, substTy, substHeadTy]
    rw [shiftTy_tyChurch, shiftTy_tyChurch]
    rw [substTy_tyChurch (substHeadTy X) m (TVar.tail W) W rfl]
    rw [substTy_tyChurch (substHeadTy X) n (TVar.tail W) W rfl]
    simp_all only
  rw [hRHS] at h
  exact h

/-- **Type-Level Church Addition Correctness**:
Applying `tyAdd` to type-level Church numerals `m` and `n`
computes the Church numeral for `m + n`. -/
theorem tyAdd_church {Δ : KindCtx} (m n : Nat)
    (W : TVar Δ (∀ₖ ★)) (X : Ty Δ ★) :
    (tyAdd (tyChurch m W) (tyChurch n W) ⬝ₖ X) ≡βₜ
      (tyChurch (m + n) W ⬝ₖ X) := by
  have h1 : (tyAdd (tyChurch m W) (tyChurch n W) ⬝ₖ X) ≡βₜ
      (tyChurch m W ⬝ₖ (tyChurch n W ⬝ₖ X)) :=
    Relation.EqvGen.rel _ _ (tyAdd_reduce_church m n W X)
  have h2 : (tyChurch m W ⬝ₖ (tyChurch n W ⬝ₖ X)) ≡βₜ
      (tyChurch m W ⬝ₖ tyChurchIter n (Ty.var W) X) :=
    BetaTyEquiv.kapp_r (tyChurch m W) (tyChurch_apply n W X)
  have h3 : (tyChurch m W ⬝ₖ tyChurchIter n (Ty.var W) X) ≡βₜ
      tyChurchIter m (Ty.var W) (tyChurchIter n (Ty.var W) X) :=
    tyChurch_apply m W (tyChurchIter n (Ty.var W) X)
  have h4 : tyChurchIter m (Ty.var W) (tyChurchIter n (Ty.var W) X) =
      tyChurchIter (m + n) (Ty.var W) X :=
    tyChurchIter_add m n (Ty.var W) X
  have h5 : (tyChurch (m + n) W ⬝ₖ X) ≡βₜ
      tyChurchIter (m + n) (Ty.var W) X :=
    tyChurch_apply (m + n) W X
  have step12 := Relation.EqvGen.trans _ _ _ h1 h2
  have step13 := Relation.EqvGen.trans _ _ _ step12 h3
  rw [h4] at step13
  exact Relation.EqvGen.trans _ _ _ step13 (Relation.EqvGen.symm _ _ h5)

/-- `1 + 1 = 2` at the type level. -/
example {Δ : KindCtx} (W : TVar Δ (∀ₖ ★)) (X : Ty Δ ★) :
    (tyAdd (tyChurch 1 W) (tyChurch 1 W) ⬝ₖ X) ≡βₜ
      (tyChurch 2 W ⬝ₖ X) :=
  tyAdd_church 1 1 W X

end LambdaCube.LambdaOmegaWeakWeak

--------------------------

-- how to allow higher ordered kinds without making it full blown LambdaOmegaWeak?

/- Kind of order `n`.
    Order 0: ★
    Order 1: ★ ⇒ₖ ★
    Order 2: (★ ⇒ₖ ★) ⇒ₖ ★ ⇒ₖ ★ (Church Nat)
    Order 3: Nat ⇒ₖ Nat ⇒ₖ Nat (Church Add/Mul) -/
-- inductive Kind : Nat → Type where
--   | star  : Kind 0
--   | arrow {n m : Nat} : Kind n → Kind m → Kind (max (n + 1) m)
--
-- notation "★" => Kind.star
-- infixr:70 " ⇒ₖ " => Kind.arrow
--
-- /-- Restrict the system to kinds of order at most `maxOrder`. -/
-- abbrev BoundedKind (maxOrder : Nat) := { n : Nat // n ≤ maxOrder }
--
-- inductive Ty (N : Nat) : List (Σ n, Kind n) → (Σ n, Kind n) → Type where
--   | var   {Δ K} (v : TVar Δ K) : Ty N Δ K
--   | arrow {Δ} (s t : Ty N Δ ⟨0, ★⟩) : Ty N Δ ⟨0, ★⟩
--   | abs   {Δ n m} {K₁ : Kind n} {K₂ : Kind m}
--           (h : max (n + 1) m ≤ N)    -- <--- The bound is checked here!
--           (body : Ty N (⟨n, K₁⟩ :: Δ) ⟨m, K₂⟩) : Ty N Δ ⟨max (n + 1) m, K₁ ⇒ₖ K₂⟩
--   | app   {Δ n m} {K₁ : Kind n} {K₂ : Kind m}
--           (f : Ty N Δ ⟨max (n + 1) m, K₁ ⇒ₖ K₂⟩) (arg : Ty N Δ ⟨n, K₁⟩) : Ty N Δ ⟨m, K₂⟩
--
-- | Concept          | Required Kind               | Kind Order | Arithmetic Meaning |
-- |---               |---                          |---|---|
-- | Ground type      | ★                           | 0 | Data atom |
-- | Unit step        | ★ ⇒ ★                       | 1 | Successor step (+1) |
-- | Standard Numeral | (★ ⇒ ★) ⇒ ★ ⇒ ★             | 2 | Numbers ℕ |
-- | Polynomials      | Nat ⇒ Nat ⇒ Nat             | 3 | +,× (No memory, chained/nested runs) |
-- | Exponentiation   | (Nat ⇒ Nat) ⇒ Nat ⇒ Nat     | 4 | mⁿ (Iterating multiplication with constant m) |
-- | Pair of Numerals | (Nat ⇒ Nat ⇒ Nat) ⇒ Nat     | 4 | State tuple ⟨k, k!⟩ |
-- | Pair Step        | Pair ⇒ Pair                 | 5 | ⟨k, a⟩ ↦ ⟨k+1, a × (k+1)⟩ |
-- | Factorial        | (Pair ⇒ Pair) ⇒ Pair ⇒ Pair | 6 | n! (Stateful Primitive Recursion) |
