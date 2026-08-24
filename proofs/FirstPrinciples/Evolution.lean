/-
  First Principles of the Web — B.6 (Prop 4.5, independent evolution).
  Self-contained: Lean 4 core only (no Mathlib).

  The dependency triangle: v₁ depends on {S, q}; v₂ on {S, q, x}; v₃ on
  {S, q, x, s}. The book's proof is "by S1 each factor is a function of its
  displayed arguments only" — and this formalization makes each factor a
  function, so the triangle is enforced by the type checker and the
  substitution lemmas below are DEFINITIONAL (`rfl`). That is not a weakness of
  the mechanization; it is B.6's point, the same point B.5 makes for `arrange`:
  under the factorization, upstream invariance holds by construction, not by
  discipline.

  What each lemma says: substituting a component recomputes the document from
  the OLD upstream stage values — they are untouched. Effectiveness (each
  timeline can actually move the document) is witnessed, not proved, in the
  book; here it appears as the hypothesis of `timelines_independent`.

  The fused half needs no lemma: one component, one row — substituting it is
  substituting everything, and there is no upstream value to hold still.
-/

universe u

namespace FirstPrinciples
namespace Evolution

variable {R St Q X Sm V₁ V₂ Doc : Type u}
variable (Jq : Q → R → St → V₁) (Jx : X → V₁ → V₂) (Js : Sm → V₂ → Doc)

/-- Stage value 1: the selection, a function of `{S, q}` (and the request). -/
def v₁ (q : Q) (r : R) (S : St) : V₁ := Jq q r S

/-- Stage value 2: the arrangement, a function of `{S, q, x}`. -/
def v₂ (q : Q) (x : X) (r : R) (S : St) : V₂ := Jx x (v₁ Jq q r S)

/-- The document: all four components. -/
def document (q : Q) (x : X) (s : Sm) (r : R) (S : St) : Doc :=
  Js s (v₂ Jq Jx q x r S)

/-- Substituting the presentation component recomputes the document from the
    OLD `v₂`: both upstream stage values are untouched. Definitional. -/
theorem present_substitution (q : Q) (x : X) (s' : Sm) (r : R) (S : St) :
    document Jq Jx Js q x s' r S = Js s' (v₂ Jq Jx q x r S) := rfl

/-- Substituting the arrange component recomputes the document from the OLD
    `v₁`: the selection is untouched. Definitional. -/
theorem arrange_substitution (q : Q) (x' : X) (s : Sm) (r : R) (S : St) :
    document Jq Jx Js q x' s r S = Js s (Jx x' (v₁ Jq q r S)) := rfl

/-- The presentation timeline, independent: given effectiveness (the
    substituted `s'` renders the same `v₂` differently — the book's witness),
    the document moves while `v₁` and `v₂` hold still. -/
theorem timelines_independent (q : Q) (x : X) (s s' : Sm) (r : R) (S : St)
    (heff : Js s (v₂ Jq Jx q x r S) ≠ Js s' (v₂ Jq Jx q x r S)) :
    document Jq Jx Js q x s r S ≠ document Jq Jx Js q x s' r S := heff

end Evolution
end FirstPrinciples
