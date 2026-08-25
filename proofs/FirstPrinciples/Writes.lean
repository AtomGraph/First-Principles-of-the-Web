/-
  First Principles of the Web — Props 7.2–7.4 and 19.1, the write side and its
  corollaries. Self-contained: Lean 4 core only (no Mathlib).

  * Prop 7.2 (forms are inverse transforms): a form's fields are a fact
    pattern's variables; submission binds them, "and a bound pattern is a set
    of facts. The marked sets are (7.1)'s delta." Mechanized: `inst` (the facts
    a bound pattern denotes), `submit` (the marked pair as the delta), and the
    claim's content — `bound_pattern_functional` (a bound pattern triple
    denotes at most one fact) and `bound_pattern_total` (well-typed bindings
    denote at least one).

  * Prop 7.3 (one algebra, both directions): the SAME `Pattern` type and the
    SAME matching relation serve find and change — that is enforced by reuse:
    this file imports them from Homomorphism.lean, where they drive `select`.
    `find_then_denote` is the symmetry made exact: bindings retrieved by match
    denote only facts already matched.

  * Prop 7.4 (the five moves): the document has exactly five inputs — request,
    state, and the three factor terms — so every interaction decomposes into
    the five single-input moves. `five_moves` constructs the decomposition.
    Near-definitional BY DESIGN, like B.6: the "no sixth move" claim is the
    type signature of `document`.

  * Prop 19.1 (nothing else to vary): two proper applications over the same
    engine that agree on terms and state are the same application at every
    request. "A corollary the apparatus yields at once" — and here it is one.
-/

import FirstPrinciples.Delta
import FirstPrinciples.Homomorphism
import FirstPrinciples.Evolution

universe u

namespace FirstPrinciples
namespace Writes

open Homomorphism (Obj DFact Binding TP Pattern matchS matchO matchTP tpHasVar dmatch)

variable {Var I V : Type u}

/-! ### Prop 7.2 — forms are inverse transforms -/

/-- The facts a bound pattern denotes. -/
def inst (β : Binding Var I V) (P : Pattern Var I V) : Set' (DFact I V) :=
  fun f => ∃ tp, tp ∈ P ∧ matchTP β tp f

/-- **Prop 7.2 (submit)**: the marked patterns, bound, are (7.1)'s delta —
    `submit : Bindings → (D⁻, D⁺)`, one submission producing both sets. -/
def submit (β : Binding Var I V) (Prem Padd : Pattern Var I V) :
    Set' (DFact I V) × Set' (DFact I V) :=
  (inst β Prem, inst β Padd)

/-- A bound pattern triple denotes at most one fact: every position is pinned
    by the binding or the constant. -/
theorem bound_pattern_functional (β : Binding Var I V) (tp : TP Var I V) :
    ∀ f f', matchTP β tp f → matchTP β tp f' → f = f' := by
  rintro ⟨s, p, o⟩ ⟨s', p', o'⟩ ⟨h1, h2, h3⟩ ⟨h1', h2', h3'⟩
  have hs : s = s' := by
    cases htp : tp.1 with
    | inl v =>
      rw [htp] at h1 h1'
      exact Sum.inl.inj (Option.some.inj ((h1.symm.trans h1')))
    | inr c =>
      rw [htp] at h1 h1'
      exact h1.symm.trans h1'
  have hp : p = p' := by
    cases htp : tp.2.1 with
    | inl v =>
      rw [htp] at h2 h2'
      exact Sum.inl.inj (Option.some.inj ((h2.symm.trans h2')))
    | inr c =>
      rw [htp] at h2 h2'
      exact h2.symm.trans h2'
  have ho : o = o' := by
    cases htp : tp.2.2 with
    | inl v =>
      rw [htp] at h3 h3'
      exact Option.some.inj (h3.symm.trans h3')
    | inr c =>
      rw [htp] at h3 h3'
      exact h3.symm.trans h3'
  rw [hs, hp, ho]

/-- A bound pattern triple denotes at least one fact, when the binding is
    well-typed on its variables (names in name positions). With
    `bound_pattern_functional`: a bound pattern IS a set of facts. -/
theorem bound_pattern_total (β : Binding Var I V) (tp : TP Var I V)
    (h1 : ∀ v, tp.1 = Sum.inl v → ∃ i, β v = some (Sum.inl i))
    (h2 : ∀ v, tp.2.1 = Sum.inl v → ∃ i, β v = some (Sum.inl i))
    (h3 : ∀ v, tp.2.2 = Sum.inl v → ∃ o, β v = some o) :
    ∃ f, matchTP β tp f := by
  have hs : ∃ s, matchS β tp.1 s := by
    cases htp : tp.1 with
    | inl v =>
      obtain ⟨i, hi⟩ := h1 v htp
      exact ⟨i, by show β v = some (Sum.inl i); exact hi⟩
    | inr c => exact ⟨c, rfl⟩
  have hp : ∃ p, matchS β tp.2.1 p := by
    cases htp : tp.2.1 with
    | inl v =>
      obtain ⟨i, hi⟩ := h2 v htp
      exact ⟨i, by show β v = some (Sum.inl i); exact hi⟩
    | inr c => exact ⟨c, rfl⟩
  have ho : ∃ o, matchO β tp.2.2 o := by
    cases htp : tp.2.2 with
    | inl v =>
      obtain ⟨o, hbo⟩ := h3 v htp
      exact ⟨o, by show β v = some o; exact hbo⟩
    | inr c => exact ⟨c, rfl⟩
  obtain ⟨s, hss⟩ := hs
  obtain ⟨p, hpp⟩ := hp
  obtain ⟨o, hoo⟩ := ho
  exact ⟨(s, p, o), hss, hpp, hoo⟩

/-! ### Prop 7.3 — one algebra, both directions -/

/-- **Prop 7.3, the symmetry made exact.** The same pattern, with the bindings
    `dmatch` retrieved, denotes only facts of the matched state: find then
    change closes over the algebra — `pattern + state → bindings` and
    `pattern + bindings → facts` are the same matching relation run in the two
    directions. -/
theorem find_then_denote (P : Pattern Var I V) (S : Set' (DFact I V))
    (β : Binding Var I V) (hβ : dmatch P S β) :
    ∀ f, inst β P f → S f := by
  rintro f ⟨tp, htp, hm⟩
  obtain ⟨f', hf', hm'⟩ := hβ.2 tp htp
  rw [bound_pattern_functional β tp f f' hm hm']
  exact hf'

/-! ### Prop 7.4 — the five moves; Prop 19.1 — nothing else to vary -/

open Evolution (document)

variable {R St Q X Sm Doc V₁ V₂ : Type u}

/-- An application configuration: the document's five inputs — the three
    factor terms, the request, the state. There is no sixth field, which is
    Prop 7.4's "there is no sixth move because there is no sixth input". -/
structure Cfg (Q X Sm R St : Type u) where
  q : Q
  x : X
  s : Sm
  r : R
  S : St

/-- One move: at most one input changes — navigate (`r`), write (`S`),
    restyle (`s`), rearrange (`x`), reselect (`q`). -/
def OneMove (c c' : Cfg Q X Sm R St) : Prop :=
  (∃ r', c' = { c with r := r' }) ∨ (∃ S', c' = { c with S := S' })
    ∨ (∃ s', c' = { c with s := s' }) ∨ (∃ x', c' = { c with x := x' })
    ∨ (∃ q', c' = { c with q := q' })

/-- **Prop 7.4 (interactivity, decomposed).** Every passage between two
    configurations — every interaction — is a composite of the five moves:
    interpolate one input at a time. -/
theorem five_moves (c c' : Cfg Q X Sm R St) :
    ∃ c₁ c₂ c₃ c₄,
      OneMove c c₁ ∧ OneMove c₁ c₂ ∧ OneMove c₂ c₃
        ∧ OneMove c₃ c₄ ∧ OneMove c₄ c' := by
  refine ⟨{ c with r := c'.r },
          { c with r := c'.r, S := c'.S },
          { c with r := c'.r, S := c'.S, s := c'.s },
          { c with r := c'.r, S := c'.S, s := c'.s, x := c'.x },
          Or.inl ⟨c'.r, rfl⟩,
          Or.inr (Or.inl ⟨c'.S, rfl⟩),
          Or.inr (Or.inr (Or.inl ⟨c'.s, rfl⟩)),
          Or.inr (Or.inr (Or.inr (Or.inl ⟨c'.x, rfl⟩))),
          Or.inr (Or.inr (Or.inr (Or.inr ⟨c'.q, rfl⟩)))⟩

/-- The document of a configuration, over a fixed engine `(Jq, Jx, Js)`. -/
def docOf (Jq : Q → R → St → V₁) (Jx : X → V₁ → V₂) (Js : Sm → V₂ → Doc)
    (c : Cfg Q X Sm R St) : Doc :=
  document Jq Jx Js c.q c.x c.s c.r c.S

/-- **Prop 19.1 (nothing else to vary).** Over one engine, two applications
    that agree on their terms and their state produce the same document at
    every request: an application IS its terms and its state, and the engine is
    generic. A corollary the apparatus yields at once — and here, one. -/
theorem nothing_else_to_vary
    (Jq : Q → R → St → V₁) (Jx : X → V₁ → V₂) (Js : Sm → V₂ → Doc)
    (c c' : Cfg Q X Sm R St)
    (hq : c.q = c'.q) (hx : c.x = c'.x) (hs : c.s = c'.s) (hS : c.S = c'.S) :
    ∀ r : R, docOf Jq Jx Js { c with r := r } = docOf Jq Jx Js { c' with r := r } := by
  intro r
  show document Jq Jx Js c.q c.x c.s r c.S = document Jq Jx Js c'.q c'.x c'.s r c'.S
  rw [hq, hx, hs, hS]

end Writes
end FirstPrinciples
