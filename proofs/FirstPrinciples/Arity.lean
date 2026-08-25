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

import FirstPrinciples.Delta

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

/-! ### The n-ary decomposition — why arities above three add nothing

"An n-ary fact `R(a₁, …, aₙ)` becomes a fresh entity `e` with atoms
`(e, rel, R)` and `(e, roleᵢ, aᵢ)`… every atom still means alone and the n-ary
fact is the *conjunction* of its atoms." That decomposition is what makes three
*minimal* rather than merely sufficient: the conditions bound arity from below,
and any wider atom encodes back into triples, so parsimony selects three. -/

/-- Positional lookup, written here so the development stays core-only. -/
def nth {α : Type u} : List α → Nat → Option α
  | [], _ => none
  | a :: _, 0 => some a
  | _ :: t, n + 1 => nth t n

/-- Lists agreeing at every index are equal. -/
theorem nth_ext {α : Type u} : ∀ (l₁ l₂ : List α), (∀ i, nth l₁ i = nth l₂ i) → l₁ = l₂
  | [], [], _ => rfl
  | [], _ :: _, h => Option.noConfusion (h 0)
  | _ :: _, [], h => Option.noConfusion (h 0)
  | a :: t₁, b :: t₂, h => by
    have hab : a = b := Option.some.inj (h 0)
    subst hab
    rw [nth_ext t₁ t₂ (fun i => h (i + 1))]

/-- An n-ary fact: a relation name and its arguments. -/
def NFact (Name : Type u) : Type u := Name × List Name

/-- The form-level vocabulary the decomposition needs — `rel` and the role
    scheme — "licensed like the reading itself: one form-level convention,
    agreed once". These are the reserved names `V₀` of B.8. -/
structure RoleScheme (Name : Type u) where
  rel : Name
  role : Nat → Name
  role_inj : ∀ i j, role i = role j → i = j
  rel_ne_role : ∀ i, rel ≠ role i

variable {Name : Type u}

/-- The decomposition: one atom naming the relation, one atom per argument,
    all about the fresh entity `e`. -/
def encN (R : RoleScheme Name) (e : Name) (f : NFact Name) :
    Set' (Name × Name × Name) :=
  fun t => t = (e, R.rel, f.1) ∨ ∃ i a, nth f.2 i = some a ∧ t = (e, R.role i, a)

/-- The relation atom reads off the relation. -/
theorem mem_encN_rel (R : RoleScheme Name) (e x : Name) (f : NFact Name) :
    encN R e f (e, R.rel, x) ↔ x = f.1 := by
  constructor
  · rintro (h | ⟨i, a, _, h⟩)
    · exact congrArg (fun t => t.2.2) h
    · exact absurd (congrArg (fun t => t.2.1) h) (R.rel_ne_role i)
  · rintro rfl
    exact Or.inl rfl

/-- A role atom reads off that argument. -/
theorem mem_encN_role (R : RoleScheme Name) (e a : Name) (i : Nat) (f : NFact Name) :
    encN R e f (e, R.role i, a) ↔ nth f.2 i = some a := by
  constructor
  · rintro (h | ⟨j, b, hj, h⟩)
    · exact absurd (congrArg (fun t => t.2.1) h).symm (R.rel_ne_role i)
    · have hij : i = j := R.role_inj i j (congrArg (fun t => t.2.1) h)
      have hab : a = b := congrArg (fun t => t.2.2) h
      rw [hij, hab]
      exact hj
  · intro h
    exact Or.inr ⟨i, a, h, rfl⟩

/-- **The decomposition is faithful**: distinct n-ary facts decompose to
    distinct atom-sets, so nothing is lost going down to arity three. -/
theorem encN_faithful (R : RoleScheme Name) (e : Name) (f f' : NFact Name)
    (h : encN R e f = encN R e f') : f = f' := by
  have hrel : f.1 = f'.1 := by
    have h1 : encN R e f (e, R.rel, f.1) := (mem_encN_rel R e f.1 f).mpr rfl
    exact (mem_encN_rel R e f.1 f').mp (Eq.mp (congrFun h _) h1)
  have hargs : f.2 = f'.2 := by
    refine nth_ext f.2 f'.2 (fun i => ?_)
    cases hi : nth f.2 i with
    | none =>
      cases hi' : nth f'.2 i with
      | none => rfl
      | some a' =>
        have h2 : encN R e f' (e, R.role i, a') := (mem_encN_role R e a' i f').mpr hi'
        have := (mem_encN_role R e a' i f).mp (Eq.mp (congrFun h.symm _) h2)
        rw [hi] at this
        exact Option.noConfusion this
    | some a =>
      have h1 : encN R e f (e, R.role i, a) := (mem_encN_role R e a i f).mpr hi
      have := (mem_encN_role R e a i f').mp (Eq.mp (congrFun h _) h1)
      exact this.symm
  obtain ⟨r₁, as₁⟩ := f
  obtain ⟨r₂, as₂⟩ := f'
  simp only at hrel hargs
  rw [hrel, hargs]

/-- **Every atom of the decomposition means alone.** Its subject is the fresh
    entity, its predicate is reserved vocabulary, and its object is the
    relation name or one of the arguments: no name appears that the n-ary fact
    did not already carry (beyond the freshly minted `e`, which costs nothing).
    "Accumulation, never emergence." -/
theorem encN_self_contained (R : RoleScheme Name) (e : Name) (f : NFact Name) :
    ∀ t, encN R e f t →
      t.1 = e
        ∧ (t.2.1 = R.rel ∨ ∃ i, t.2.1 = R.role i)
        ∧ (t.2.2 = f.1 ∨ ∃ i, nth f.2 i = some t.2.2) := by
  rintro t (rfl | ⟨i, a, hi, rfl⟩)
  · exact ⟨rfl, Or.inl rfl, Or.inl rfl⟩
  · exact ⟨rfl, Or.inr ⟨i, rfl⟩, Or.inr ⟨i, hi⟩⟩

/-- **Arities above three add nothing** (Prop. 5.2's minimality clause). Every
    n-ary fact decomposes into triples faithfully, and every atom of the
    decomposition still means alone. So a `k`-model with `k > 3` encodes into
    the 3-model: the conditions bound arity from below, and what selects three
    is parsimony — stated in Theorem 5.4's hypotheses, never smuggled. -/
theorem arity_above_three_decomposes (R : RoleScheme Name) (e : Name) :
    (∀ f f' : NFact Name, encN R e f = encN R e f' → f = f')
      ∧ (∀ (f : NFact Name) t, encN R e f t →
           t.1 = e ∧ (t.2.1 = R.rel ∨ ∃ i, t.2.1 = R.role i)
             ∧ (t.2.2 = f.1 ∨ ∃ i, nth f.2 i = some t.2.2)) :=
  ⟨encN_faithful R e, encN_self_contained R e⟩

end Arity
end FirstPrinciples
