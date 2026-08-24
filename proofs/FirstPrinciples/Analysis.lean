/-
  First Principles of the Web — B.5 (Prop 4.4, the analysis theorem), shape half.
  Self-contained: Lean 4 core only (no Mathlib).

  Finite dependence says: every request `r` has a finite *window* `K r` of facts
  such that `read r S = read r (S ∩ K r)` for all states — the response cannot
  see past its window. B.5's construction then factors `read` into three stages:

    select r S = (S ∩ K r) ∪ enc r      -- the window's facts plus the request's
    arrange D  = canon (read (dec D))   -- a function of its argument ALONE
    present    = canon⁻¹                -- renders the canonical tree, sees no data

  The one wrinkle handled in the open (as in the book): `arrange` is forbidden by
  S1 from seeing `r`, so the request itself rides along as facts, minted under a
  reserved authority disjoint from every window. That disjointness is what makes
  `dec` well-defined — the reserved part of `D` recovers `r` (by injectivity of
  `enc`), the rest recovers `S ∩ K r`.

  SCOPE / honesty. This is the SHAPE half — S1 and the three-stage form, with no
  side channels: `arrange` and `present` are functions of their argument alone,
  which the types enforce. S2–S4 are claims about languages and addresses; no
  analysis argument can conjure those, and the book assigns them to the synthesis
  theorem (B.8). `canon` at type `Doc` is Chapter 6's bijection, taken here as an
  input `c : Bij Doc Tree`, exactly as the book overloads it "deliberately and in
  the open." `dec` is noncomputable (classical choice picks the request the
  reserved facts encode); the factorization is an existence claim, not a program.

  Also proved: the book's minimal-window remark — inside any window sits a window
  none of whose proper sub-windows is a window ("a minimal fragment exists,
  because windows are finite").
-/

import FirstPrinciples.Delta
import FirstPrinciples.Uniqueness

universe u

namespace FirstPrinciples
namespace Analysis

open Uniqueness (Bij)

variable {Req Fact Doc Tree : Type u}

/-- The facts of a finite window, as a set. -/
def wset (K : List Fact) : Set' Fact := fun f => f ∈ K

/-- `K` is a window for `r`: the response depends on the state only inside `K`.
    Finiteness is by construction — a window is a list. -/
def IsWindow (read : Req → Set' Fact → Doc) (r : Req) (K : List Fact) : Prop :=
  ∀ S : Set' Fact, read r S = read r (Set'.inter S (wset K))

/-- **Finite dependence** (Prop. 4.4's hypothesis): every request has a window. -/
def FiniteDependence (read : Req → Set' Fact → Doc) : Prop :=
  ∀ r, ∃ K : List Fact, IsWindow read r K

/-- The request-as-facts encoding: `enc` writes a request as facts minted under a
    reserved authority `Res`, injectively. (B-1: a request is a finite named
    structure, so it encodes as facts; the reserved authority costs nothing.) -/
structure Encoding (Req Fact : Type u) where
  Res : Fact → Prop
  enc : Req → Set' Fact
  enc_res : ∀ r f, enc r f → Res f
  enc_inj : ∀ r r', enc r = enc r' → r = r'

/-- A window's set depends only on its members. -/
theorem isWindow_congr (read : Req → Set' Fact → Doc) (r : Req) {K K' : List Fact}
    (h : ∀ f, f ∈ K ↔ f ∈ K') (hK : IsWindow read r K) : IsWindow read r K' := by
  intro S
  have hset : wset K' = wset K := Set'.ext fun f => (h f).symm
  rw [hset]
  exact hK S

/-- **The analysis theorem (Prop. 4.4 / B.5), shape half.** A `read` with a
    window for every request factors into three stages,

      `present (arrange (select r S)) = read r S`,

    where `arrange` and `present` are functions of their argument alone — S1
    holds by construction rather than by discipline. Inputs: the windows `K`
    (finite dependence), the request encoding `E` with every window disjoint
    from the reserved authority, and `canon` at type `Doc` (`c : Bij Doc Tree`,
    Chapter 6's bijection). -/
theorem analysis_shape [Nonempty Req]
    (read : Req → Set' Fact → Doc)
    (K : Req → List Fact) (hK : ∀ r, IsWindow read r (K r))
    (E : Encoding Req Fact)
    (hdisj : ∀ r f, f ∈ K r → ¬ E.Res f)
    (c : Bij Doc Tree) :
    ∃ (sel : Req → Set' Fact → Set' Fact) (arr : Set' Fact → Tree) (pres : Tree → Doc),
      ∀ r S, pres (arr (sel r S)) = read r S := by
  classical
  -- select: the window's facts plus the request's.
  let sel : Req → Set' Fact → Set' Fact :=
    fun r S => Set'.union (Set'.inter S (wset (K r))) (E.enc r)
  -- dec, request half: the reserved part of D is `enc r`; injectivity recovers r.
  let decR : Set' Fact → Req :=
    fun D => if h : ∃ r, E.enc r = Set'.inter D E.Res then Classical.choose h
             else Classical.choice inferInstance
  -- dec, state half: the unreserved part of D is the window's facts.
  let decS : Set' Fact → Set' Fact := fun D => Set'.diff D E.Res
  refine ⟨sel, fun D => c.toFun (read (decR D) (decS D)), c.invFun, ?_⟩
  intro r S
  -- The reserved part of `sel r S` is exactly `enc r`.
  have hres : Set'.inter (sel r S) E.Res = E.enc r := by
    apply Set'.ext
    intro f
    constructor
    · rintro ⟨hD, hRes⟩
      rcases hD with ⟨_, hKf⟩ | henc
      · exact absurd hRes (hdisj r f hKf)
      · exact henc
    · intro henc
      exact ⟨Or.inr henc, E.enc_res r f henc⟩
  -- So `decR` recovers `r`.
  have hr : decR (sel r S) = r := by
    have hex : ∃ r', E.enc r' = Set'.inter (sel r S) E.Res := ⟨r, hres.symm⟩
    show (if h : ∃ r', E.enc r' = Set'.inter (sel r S) E.Res then Classical.choose h
          else Classical.choice inferInstance) = r
    rw [dif_pos hex]
    exact E.enc_inj _ r ((Classical.choose_spec hex).trans hres)
  -- And `decS` recovers the window's facts.
  have hs : decS (sel r S) = Set'.inter S (wset (K r)) := by
    apply Set'.ext
    intro f
    constructor
    · rintro ⟨hD, hnres⟩
      rcases hD with hSK | henc
      · exact hSK
      · exact absurd (E.enc_res r f henc) hnres
    · rintro ⟨hS, hKf⟩
      exact ⟨Or.inl ⟨hS, hKf⟩, hdisj r f hKf⟩
  -- Compose: present (arrange (select r S)) = read r (S ∩ K r) = read r S.
  show c.invFun (c.toFun (read (decR (sel r S)) (decS (sel r S)))) = read r S
  rw [c.left_inv, hr, hs]
  exact (hK r S).symm

/-! ### The minimal window

"For each `r`, fix one window that is as small as possible: a window no proper
subset of which is still a window. Such a minimal window exists inside any
window, because windows are finite." — proved by strong induction on the
window's length: a non-minimal window contains a member-strictly-smaller
window, and lengths cannot descend forever. -/

/-- A filtered list is strictly shorter when some member fails the predicate. -/
private theorem length_filter_lt {α : Type u} (p : α → Bool) :
    ∀ (l : List α), (∃ x, x ∈ l ∧ p x = false) → (l.filter p).length < l.length := by
  intro l
  induction l with
  | nil => rintro ⟨x, hx, _⟩; exact absurd hx (by simp)
  | cons a rest ih =>
    rintro ⟨x, hx, hpx⟩
    have hle : (rest.filter p).length ≤ rest.length := List.length_filter_le p rest
    rcases List.mem_cons.mp hx with h | h
    · subst h
      have hstep : (x :: rest).filter p = rest.filter p := by
        simp [List.filter_cons, hpx]
      rw [hstep]
      exact Nat.lt_succ_of_le hle
    · have hlt : (rest.filter p).length < rest.length := ih ⟨x, h, hpx⟩
      by_cases hpa : p a = true
      · have hstep : (a :: rest).filter p = a :: rest.filter p := by
          simp [List.filter_cons, hpa]
        rw [hstep]
        exact Nat.succ_lt_succ hlt
      · have hstep : (a :: rest).filter p = rest.filter p := by
          simp [List.filter_cons, hpa]
        rw [hstep]
        exact Nat.lt_trans hlt (Nat.lt_succ_self _)

/-- **Minimal windows exist** (B.5's chosen fragment). Inside any window for `r`
    sits a window `K'` such that every sub-window of `K'` already has all of
    `K'`'s members — no proper sub-window is a window. -/
theorem minimal_window_exists (read : Req → Set' Fact → Doc) (r : Req) :
    ∀ (K : List Fact), IsWindow read r K →
      ∃ K' : List Fact, (∀ f, f ∈ K' → f ∈ K) ∧ IsWindow read r K'
        ∧ ∀ K'' : List Fact, (∀ f, f ∈ K'' → f ∈ K') → IsWindow read r K'' →
            (∀ f, f ∈ K' → f ∈ K'') := by
  classical
  -- Strong induction on the window's length.
  suffices h : ∀ (n : Nat) (K : List Fact), K.length ≤ n → IsWindow read r K →
      ∃ K' : List Fact, (∀ f, f ∈ K' → f ∈ K) ∧ IsWindow read r K'
        ∧ ∀ K'' : List Fact, (∀ f, f ∈ K'' → f ∈ K') → IsWindow read r K'' →
            (∀ f, f ∈ K' → f ∈ K'') by
    intro K hK
    exact h K.length K (Nat.le_refl _) hK
  intro n
  induction n with
  | zero =>
    intro K hlen hK
    -- The empty window is minimal outright.
    refine ⟨K, fun f hf => hf, hK, fun K'' _ _ f hf => ?_⟩
    cases K with
    | nil => exact absurd hf (by simp)
    | cons a l => exact absurd hlen (Nat.not_succ_le_zero _)
  | succ n ih =>
    intro K hlen hK
    by_cases hmin : ∀ K'' : List Fact, (∀ f, f ∈ K'' → f ∈ K) → IsWindow read r K'' →
        (∀ f, f ∈ K → f ∈ K'')
    · exact ⟨K, fun f hf => hf, hK, hmin⟩
    · -- Not minimal: some sub-window misses a member. Filter K down to it and recurse.
      have hW : ∃ W : List Fact, (∀ f, f ∈ W → f ∈ K) ∧ IsWindow read r W
          ∧ ∃ g, g ∈ K ∧ ¬ g ∈ W :=
        Classical.byContradiction fun hno =>
          hmin fun K'' hsub hwin f hf =>
            Classical.byContradiction fun hfK =>
              hno ⟨K'', hsub, hwin, f, hf, hfK⟩
      obtain ⟨W, hWsub, hWwin, g, hgK, hgW⟩ := hW
      let p : Fact → Bool := fun f => decide (f ∈ W)
      have hmem : ∀ f, f ∈ K.filter p ↔ f ∈ W := by
        intro f
        constructor
        · intro hf
          exact of_decide_eq_true (List.mem_filter.mp hf).2
        · intro hf
          exact List.mem_filter.mpr ⟨hWsub f hf, decide_eq_true hf⟩
      have hfwin : IsWindow read r (K.filter p) :=
        isWindow_congr read r (fun f => (hmem f).symm) hWwin
      have hlt : (K.filter p).length < K.length :=
        length_filter_lt p K ⟨g, hgK, decide_eq_false hgW⟩
      obtain ⟨K', h1, h2, h3⟩ :=
        ih (K.filter p) (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le hlt hlen)) hfwin
      exact ⟨K', fun f hf => (List.mem_filter.mp (h1 f hf)).1, h2, h3⟩

end Analysis
end FirstPrinciples
