/-
  First Principles of the Web — where the halves meet.
  Self-contained: Lean 4 core only (no Mathlib).

  B.8's last paragraph: "Together with the analysis theorem (B.5): every
  windowed `read` has the form, its select window-shaped (a union of ground
  matches, inside the derived algebra) and the stack fills the form. This
  section is where the halves meet."

  Analysis.lean gives the shape but hands back an abstract `select`;
  Homomorphism.lean carries terms of the derived algebra to SPARQL. The claim
  that joins them — that a window-shaped select IS a term of the derived
  algebra — was prose. Here it is a theorem:

    * `ground_match_iff` — a ground pattern (no variables) matches exactly when
      its fact is in the state. Membership is a term of the algebra.
    * `window_select_algebraic` — hence the window fragment `S ∩ K` is decided
      by one ground match per window fact: "a union of ground matches".
    * `halves_meet` — the three results in one statement: the factorization
      exists (B.5), its select is ground-algebraic (here), and the algebra is
      carried to the deployed side (B.7).

  Nothing new is assumed. The point is that the two halves, developed
  independently in separate files, compose.
-/

import FirstPrinciples.Analysis
import FirstPrinciples.Homomorphism

universe u

namespace FirstPrinciples
namespace Meeting

open Uniqueness (Bij)
open Homomorphism (DFact Binding Pattern DAlg dmatch deval seval toSols trAlg toGraph
                   homomorphism)

variable {Var I V : Type u}

/-- The ground pattern of a fact: every position a constant, no variables. -/
def gp (f : DFact I V) : Pattern Var I V :=
  [(Sum.inr f.1, Sum.inr f.2.1, Sum.inr f.2.2)]

/-- **A ground match is a membership test.** The pattern binds nothing, so it
    matches exactly when its fact is in the state — one term of the derived
    algebra per fact. -/
theorem ground_match_iff (S : Set' (DFact I V)) (f : DFact I V) :
    (∃ β : Binding Var I V, dmatch (gp f) S β) ↔ S f := by
  constructor
  · rintro ⟨β, _, hm⟩
    obtain ⟨g, hg, e1, e2, e3⟩ := hm _ (List.mem_cons_self _ _)
    have hgf : g = f := by
      obtain ⟨gs, gp', go⟩ := g
      obtain ⟨fs, fp, fo⟩ := f
      simp only at e1 e2 e3
      rw [e1, e2, e3]
    rw [← hgf]
    exact hg
  · intro hf
    refine ⟨fun _ => none, fun v => ⟨?_, ?_⟩, ?_⟩
    · rintro ⟨o, ho⟩
      exact Option.noConfusion ho
    · rintro ⟨tp, htp, hvar⟩
      rcases List.mem_cons.mp htp with rfl | hnil
      · rcases hvar with h | h | h <;> exact Sum.noConfusion h
      · exact absurd hnil (by simp)
    · intro tp htp
      rcases List.mem_cons.mp htp with rfl | hnil
      · exact ⟨f, hf, rfl, rfl, rfl⟩
      · exact absurd hnil (by simp)

/-- **The window select is a union of ground matches.** The fragment `S ∩ K` —
    B.5's `select`, minus the request's own facts — is decided by one ground
    match per window fact, so it lies inside the derived algebra. This is the
    sentence B.8 asserts about B.5's output, proved. -/
theorem window_select_algebraic (K : List (DFact I V)) (S : Set' (DFact I V)) :
    Set'.inter S (Analysis.wset K)
      = fun f => f ∈ K ∧ ∃ β : Binding Var I V, dmatch (gp f) S β := by
  apply Set'.ext
  intro f
  show S f ∧ f ∈ K ↔ f ∈ K ∧ ∃ β : Binding Var I V, dmatch (gp f) S β
  rw [ground_match_iff]
  exact ⟨fun h => ⟨h.2, h.1⟩, fun h => ⟨h.2, h.1⟩⟩

/-- **The halves meet.** For a `read` with a window per request:

    1. it factors into three stages with no side channels (B.5);
    2. each window fragment is a union of ground matches — its `select` is a
       term of the derived algebra (above);
    3. every such term is carried to the deployed evaluation by φ (B.7).

    Analysis supplies the form, synthesis fills it, and the seam holds. -/
theorem halves_meet {Req Doc Tree : Type u} [Nonempty Req]
    (read : Req → Set' (DFact I V) → Doc)
    (K : Req → List (DFact I V)) (hK : ∀ r, Analysis.IsWindow read r (K r))
    (E : Analysis.Encoding Req (DFact I V))
    (hdisj : ∀ r f, f ∈ K r → ¬ E.Res f)
    (c : Bij Doc Tree) :
    (∃ (sel : Req → Set' (DFact I V) → Set' (DFact I V))
       (arr : Set' (DFact I V) → Tree) (pres : Tree → Doc),
        ∀ r S, pres (arr (sel r S)) = read r S)
      ∧ (∀ (r : Req) (S : Set' (DFact I V)),
          Set'.inter S (Analysis.wset (K r))
            = fun f => f ∈ K r ∧ ∃ β : Binding Var I V, dmatch (gp f) S β)
      ∧ (∀ (f : DFact I V) (S : Set' (DFact I V)),
          toSols (deval (DAlg.pat (gp (Var := Var) f)) S)
            = seval (trAlg (DAlg.pat (gp (Var := Var) f))) (toGraph S)) :=
  ⟨Analysis.analysis_shape read K hK E hdisj c,
   fun r S => window_select_algebraic (K r) S,
   fun f S => homomorphism (DAlg.pat (gp (Var := Var) f)) S⟩

end Meeting
end FirstPrinciples
