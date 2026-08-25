/-
  First Principles of the Web — B.8 (Thm 8.2), the genericity core.
  Self-contained: Lean 4 core only (no Mathlib).

  What is mechanized: the definitional spine of B.8's genericity section.

    * `Renaming V₀` — a bijection `ρ : I → I` fixing the reserved vocabulary
      `V₀` pointwise, acting on facts and states by rewriting embedded names;
      literals stay untouched ("renamings never enter V's elements").
    * `Generic` — a transform commutes with every renaming. The output side is
      abstract (`actOut`): the book's transforms land in trees, and the
      tree-side action (rewrite-then-recanonicalize) enters here as the given
      action, not as a modeled `canon`.
    * `transposition` — the free theorem's instrument: `(u u′)` IS a renaming
      whenever `u, u′ ∉ V₀`. The construction is the content; the free-theorem
      consequence (`treats_no_name_specially`) is then its instantiation,
      exactly as in the book: "apply the transposition ρ = (u u′), which fixes
      V₀, and commuting forces the output to change by exactly that action."
    * `GenericRel` — relative genericity: commuting with renamings that also
      fix a declared `W`. The free theorem relativizes verbatim
      (`treats_no_name_outside_W_specially`).
    * `generic_comp` — genericity composes down a pipeline: the synthesis
      theorem's assembled `arrange` inherits it stage by stage.

  What is NOT here, and why (README scope table): `canon`'s existence is Prop
  6.1 (RDFC-1.0 for the unnamed, an external spec); "XSLT is Turing-complete on
  trees" is a cited external fact; both stay outside the formalization. This is
  the partial B.8 the book's own scope map promises — the free-theorem core.
-/

import FirstPrinciples.Delta
import FirstPrinciples.Homomorphism

universe u

namespace FirstPrinciples
namespace Genericity

open Homomorphism (Obj DFact)

variable {I V : Type u}

/-- A renaming: a bijection `ρ : I → I` fixing `F` pointwise. (`F` is `V₀` for
    strict genericity, `V₀ ∪ W` for genericity relative to `W`.) -/
structure Renaming (I : Type u) (F : Set' I) where
  toFun : I → I
  invFun : I → I
  left_inv : ∀ i, invFun (toFun i) = i
  right_inv : ∀ i, toFun (invFun i) = i
  fixes : ∀ i, F i → toFun i = i

/-- The inverse fixes the reserved set too. -/
theorem Renaming.inv_fixes {F : Set' I} (ρ : Renaming I F) (i : I) (h : F i) :
    ρ.invFun i = i := by
  have hfix : ρ.toFun i = i := ρ.fixes i h
  calc ρ.invFun i = ρ.invFun (ρ.toFun i) := by rw [hfix]
    _ = i := ρ.left_inv i

/-- A renaming that fixes more may be read as one that fixes less: every
    `(V₀ ∪ W)`-renaming is a `V₀`-renaming. (Used to compare strict and
    relative genericity.) -/
def Renaming.weaken {F G : Set' I} (h : ∀ i, G i → F i) (ρ : Renaming I F) :
    Renaming I G :=
  { ρ with fixes := fun i hi => ρ.fixes i (h i hi) }

/-! ### The action on facts and states -/

/-- Names are rewritten; literals are untouched. -/
def actObj {F : Set' I} (ρ : Renaming I F) : Obj I V → Obj I V
  | Sum.inl i => Sum.inl (ρ.toFun i)
  | Sum.inr v => Sum.inr v

/-- All three positions rewrite (subject and predicate are names; the object
    rewrites only if it is one). -/
def actFact {F : Set' I} (ρ : Renaming I F) (f : DFact I V) : DFact I V :=
  (ρ.toFun f.1, ρ.toFun f.2.1, actObj ρ f.2.2)

/-- States rewrite fact-wise: the image. -/
def actState {F : Set' I} (ρ : Renaming I F) (S : Set' (DFact I V)) :
    Set' (DFact I V) :=
  fun f => ∃ f₀, S f₀ ∧ actFact ρ f₀ = f

/-! ### Genericity, strict and relative -/

variable {Out : Type u}

/-- **Generic** (B.8): `T` commutes with every renaming fixing `V₀`. `actOut`
    is the output side's action, given abstractly — for the book's trees it is
    rewrite-then-recanonicalize, and that clause lives with the action, not
    with `T`. -/
def Generic (V₀ : Set' I)
    (actOut : Renaming I V₀ → Out → Out)
    (T : Set' (DFact I V) → Out) : Prop :=
  ∀ (ρ : Renaming I V₀) (S : Set' (DFact I V)), T (actState ρ S) = actOut ρ (T S)

/-- **Generic relative to `W`** (B.8's relativization): `T` commutes with every
    renaming fixing `V₀ ∪ W` pointwise. Strict genericity is `W = ∅`. -/
def GenericRel (V₀ W : Set' I)
    (actOut : Renaming I (Set'.union V₀ W) → Out → Out)
    (T : Set' (DFact I V) → Out) : Prop :=
  ∀ (ρ : Renaming I (Set'.union V₀ W)) (S : Set' (DFact I V)),
    T (actState ρ S) = actOut ρ (T S)

/-! ### The transposition, and the free theorem -/

open Classical in
/-- The swap `(u u′)` as a function. -/
noncomputable def swapFun (u u' : I) : I → I :=
  fun i => if i = u then u' else if i = u' then u else i

theorem swapFun_left (u u' : I) : swapFun u u' u = u' := by
  unfold swapFun
  rw [if_pos rfl]

theorem swapFun_invol (u u' : I) : ∀ i, swapFun u u' (swapFun u u' i) = i := by
  intro i
  by_cases h1 : i = u
  · subst h1
    rw [swapFun_left]
    unfold swapFun
    by_cases h2 : u' = i
    · rw [if_pos h2]; exact h2
    · rw [if_neg h2, if_pos rfl]
  · by_cases h2 : i = u'
    · rw [show swapFun u u' i = u from by unfold swapFun; rw [if_neg h1, if_pos h2]]
      rw [swapFun_left]
      exact h2.symm
    · rw [show swapFun u u' i = i from by unfold swapFun; rw [if_neg h1, if_neg h2]]
      unfold swapFun
      rw [if_neg h1, if_neg h2]

/-- **The transposition is a renaming**: `(u u′)` is a bijection on `I`, and it
    fixes `F` pointwise whenever `u, u′ ∉ F`. This is the free theorem's
    instrument, constructed rather than assumed. -/
noncomputable def transposition {F : Set' I} (u u' : I)
    (hu : ¬ F u) (hu' : ¬ F u') : Renaming I F where
  toFun := swapFun u u'
  invFun := swapFun u u'
  left_inv := swapFun_invol u u'
  right_inv := swapFun_invol u u'
  fixes := fun i hi => by
    unfold swapFun
    rw [if_neg (fun (h : i = u) => hu (h ▸ hi)), if_neg (fun (h : i = u') => hu' (h ▸ hi))]

/-- **The free theorem** ("cannot hardcode identifiers", made exact). A generic
    `T` treats no name outside `V₀` specially: replacing `u` by a fresh `u′`
    in the state changes the output by exactly the action of `(u u′)` — because
    the transposition fixes `V₀`, so commuting applies to it. -/
theorem treats_no_name_specially {V₀ : Set' I}
    {actOut : Renaming I V₀ → Out → Out} {T : Set' (DFact I V) → Out}
    (hT : Generic V₀ actOut T)
    (u u' : I) (hu : ¬ V₀ u) (hu' : ¬ V₀ u') (S : Set' (DFact I V)) :
    T (actState (transposition u u' hu hu') S)
      = actOut (transposition u u' hu hu') (T S) :=
  hT (transposition u u' hu hu') S

/-- **The free theorem, relativized verbatim** (B.8): a transform generic
    relative to `W` treats no name outside `V₀ ∪ W` specially. -/
theorem treats_no_name_outside_W_specially {V₀ W : Set' I}
    {actOut : Renaming I (Set'.union V₀ W) → Out → Out}
    {T : Set' (DFact I V) → Out}
    (hT : GenericRel V₀ W actOut T)
    (u u' : I) (hu : ¬ Set'.union V₀ W u) (hu' : ¬ Set'.union V₀ W u')
    (S : Set' (DFact I V)) :
    T (actState (transposition u u' hu hu') S)
      = actOut (transposition u u' hu hu') (T S) :=
  hT (transposition u u' hu hu') S

/-! ### The synthesis theorem's "only those" clause

B.8: "the stack realizes the factorization, and realizes only proper ones: a
non-generic `arrange` fails the definition just given, which is the 'excluding
smuggling' caveat of Chapter 8, now a clause rather than a caution." Here is the
clause.

A caution about the test, which the formalization makes visible: the free
theorem's transposition test is **necessary, not sufficient**. Transpositions
are renamings, so a generic transform passes every one of them; but they do not
exhaust the renamings of an infinite name space, so passing them all is not by
itself genericity. `Generic` quantifies over every renaming, and that is the
condition the synthesis theorem needs. -/

/-- `T` **treats `u` specially**: some state and some fresh `u′` where the
    output fails to move by exactly the transposition's action. This is B.8's
    definition, with "does not change the output by exactly the action of
    `(u u′)`" written out. -/
def TreatsSpecially (V₀ : Set' I)
    (actOut : Renaming I V₀ → Out → Out)
    (T : Set' (DFact I V) → Out) (u : I) : Prop :=
  ∃ (u' : I) (hu : ¬ V₀ u) (hu' : ¬ V₀ u') (S : Set' (DFact I V)),
    T (actState (transposition u u' hu hu') S)
      ≠ actOut (transposition u u' hu hu') (T S)

/-- **"…and only those."** A transform that treats any name outside the
    reserved vocabulary specially is not generic, so the stack does not realize
    it. Chapter 8's "excluding smuggling" caveat is a clause of the theorem, not
    a caution beside it. -/
theorem not_generic_of_treatsSpecially {V₀ : Set' I}
    {actOut : Renaming I V₀ → Out → Out} {T : Set' (DFact I V) → Out} {u : I}
    (h : TreatsSpecially V₀ actOut T u) : ¬ Generic V₀ actOut T := by
  intro hgen
  obtain ⟨u', hu, hu', S, hne⟩ := h
  exact hne (hgen (transposition u u' hu hu') S)

/-! ### Genericity composes down the pipeline -/

variable {Out₂ : Type u}

/-- **Composition** (the synthesis theorem's assembly step): if `T` is generic
    and `U` commutes with the output action, the composite is generic — the
    assembled pipeline inherits genericity stage by stage, so writing each
    stage generically is enough. -/
theorem generic_comp {V₀ : Set' I}
    {actOut : Renaming I V₀ → Out → Out}
    {actOut₂ : Renaming I V₀ → Out₂ → Out₂}
    {T : Set' (DFact I V) → Out} {U : Out → Out₂}
    (hT : Generic V₀ actOut T)
    (hU : ∀ (ρ : Renaming I V₀) (o : Out), U (actOut ρ o) = actOut₂ ρ (U o)) :
    Generic V₀ actOut₂ (fun S => U (T S)) := by
  intro ρ S
  show U (T (actState ρ S)) = actOut₂ ρ (U (T S))
  rw [hT ρ S, hU ρ (T S)]

end Genericity
end FirstPrinciples
