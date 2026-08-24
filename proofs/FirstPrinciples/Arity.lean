/-
  First Principles of the Web — Prop 5.2 (Arity), core.
  Self-contained: Lean 4 core only (no Mathlib).

  A fact names three things: a relation and the two entities it relates —
  (predicate, subject, object). B-0 (self-interpreting atom) + B-3 (names
  verbatim) say an atom's fact may use only the atom's OWN names. From that one
  condition:

    * arity 1 and arity 2 cannot express a fact of three distinct names
      (pigeonhole: three distinct names cannot fit in fewer than three slots);
    * arity 3 expresses every fact (put the predicate in the middle position);

  so three is the minimal arity — "the first arity at which a fact names its own
  relation."

  SCOPE / honesty. This mechanizes the mathematical CORE *given* self-containment.
  It does NOT re-derive WHY self-containment is the right condition — that is the
  gadget-closure that blocks the Löwenheim–Quine dyadic reduction, which the book
  grounds in the Transposition Thesis's fourth row (a deployed web invariant,
  argued not proved). Self-containment is an explicit hypothesis here, exactly as
  B-0/B-3 are conditions in the book. Nothing is smuggled: the condition is on
  display, and the arity bound is its consequence.
-/

universe u

namespace FirstPrinciples
namespace Arity

/-- A fact: `(predicate, subject, object)` — "the relation `p` holds of `s`, `o`". -/
def Fact (Name : Type u) : Type u := Name × Name × Name

/-- The three names occurring in a fact. -/
def factMem {Name : Type u} (f : Fact Name) (x : Name) : Prop :=
  x = f.1 ∨ x = f.2.1 ∨ x = f.2.2

variable {Name : Type u}

/-- **Arity 1 is insufficient.** A single-name atom, whose fact uses only that
    name, cannot express a fact with two distinct names. -/
theorem arity1_insufficient
    (r : Name → Fact Name)
    (hsc : ∀ x y, factMem (r x) y → y = x)
    {A B C : Name} (hAB : A ≠ B) (x : Name) :
    r x ≠ (A, B, C) := by
  intro hp
  have hA : A = x := hsc x A (by rw [hp]; exact Or.inl rfl)
  have hB : B = x := hsc x B (by rw [hp]; exact Or.inr (Or.inl rfl))
  exact hAB (hA.trans hB.symm)

/-- **Arity 2 is insufficient.** A pair-atom, whose fact uses only its two names,
    cannot express a fact of three distinct names (three names, two slots). -/
theorem arity2_insufficient
    (r : Name × Name → Fact Name)
    (hsc : ∀ p y, factMem (r p) y → y = p.1 ∨ y = p.2)
    {A B C : Name} (hAB : A ≠ B) (hAC : A ≠ C) (hBC : B ≠ C) (p : Name × Name) :
    r p ≠ (A, B, C) := by
  intro hp
  have hA : A = p.1 ∨ A = p.2 := hsc p A (by rw [hp]; exact Or.inl rfl)
  have hB : B = p.1 ∨ B = p.2 := hsc p B (by rw [hp]; exact Or.inr (Or.inl rfl))
  have hC : C = p.1 ∨ C = p.2 := hsc p C (by rw [hp]; exact Or.inr (Or.inr rfl))
  rcases hA with hA | hA <;> rcases hB with hB | hB <;> rcases hC with hC | hC <;>
    first
      | exact hAB (hA.trans hB.symm)
      | exact hAC (hA.trans hC.symm)
      | exact hBC (hB.trans hC.symm)

/-- The arity-3 encoding: atom `(s, p, o)` denotes the fact `(p, s, o)` — the
    predicate sits in the middle, so the fact names its own relation. -/
def enc3 (t : Name × Name × Name) : Fact Name := (t.2.1, t.1, t.2.2)

/-- **Arity 3 is sufficient.** `enc3` is self-contained (its fact uses only the
    atom's own names) and surjective (every fact is expressed). -/
theorem arity3_sufficient :
    (∀ f : Fact Name, ∃ t, enc3 t = f)
      ∧ (∀ (t : Name × Name × Name) y, factMem (enc3 t) y →
           y = t.1 ∨ y = t.2.1 ∨ y = t.2.2) := by
  refine ⟨?_, ?_⟩
  · intro f
    exact ⟨(f.2.1, f.1, f.2.2), rfl⟩
  · intro t y hy
    rcases hy with h | h | h
    · exact Or.inr (Or.inl h)
    · exact Or.inl h
    · exact Or.inr (Or.inr h)

/-- **Prop 5.2 (Arity), core.** Given self-containment (an atom's fact uses only
    the atom's own names — B-0 + B-3): arities 1 and 2 cannot express a fact of
    three distinct names, and arity 3 expresses every fact. Three is minimal. -/
theorem arity_minimal_is_three
    {A B C : Name} (hAB : A ≠ B) (hAC : A ≠ C) (hBC : B ≠ C) :
    (∀ (r : Name → Fact Name), (∀ x y, factMem (r x) y → y = x) →
        ∀ x, r x ≠ (A, B, C))
      ∧ (∀ (r : Name × Name → Fact Name),
          (∀ p y, factMem (r p) y → y = p.1 ∨ y = p.2) →
          ∀ p, r p ≠ (A, B, C))
      ∧ (∀ f : Fact Name, ∃ t, enc3 t = f) :=
  ⟨fun r hsc x => arity1_insufficient r hsc hAB x,
   fun r hsc p => arity2_insufficient r hsc hAB hAC hBC p,
   (arity3_sufficient (Name := Name)).1⟩

end Arity
end FirstPrinciples
