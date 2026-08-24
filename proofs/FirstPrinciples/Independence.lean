/-
  First Principles of the Web — B.4 (independence of the conditions), continued.
  Self-contained: Lean 4 core only (no Mathlib).

  B.4's proof pattern: for each condition, a model satisfying the others in
  which the characterization fails. StateModel.lean carries the B-2d case
  (`atomistic_independent`, the `(ℕ, max)` witness). This file adds:

    * the ENGINE — `rep_forces_laws`: union's own algebra pulls back through
      any injective ⊕→∪ representation, so a represented model is already
      commutative, associative, and idempotent. Each countermodel therefore
      needs only "this law fails" to conclude "no representation exists."
    * B-2b (order-freedom) — `lww`, last-arrival-wins: total, associative,
      idempotent, left identity, NOT commutative. (The book's deployed witness
      is event logs under deduplicated append; this is the minimal model making
      the same point: without order-freedom, arrival order is meaning, and no
      set-of-facts reading survives.)
    * B-2c (idempotence) — `(ℕ, +, 0)`, counting arrivals: the book's multisets
      over a one-fact universe. Commutative, associative, identity, and
      `1 + 1 ≠ 1`.
    * B-2e (accumulation) — `finsets`, the finite subsets of an infinite `A`
      under union: ALL FOUR laws hold, `NoEmergence` and `Atomistic` hold, the
      finite representation survives — and the full powerset fails: no state
      carries the set of all atoms. `finsets_no_accumulation` closes the loop:
      what `finsets` lacks is exactly `HasAccumulation`, so B-2e is used
      precisely where the book says it is.

  B-2a (totality) has no countermodel here, deliberately: in this formalization
  totality is enforced by typing (`merge : M → M → M`), exactly as the file
  header of StateModel.lean notes. Dropping it makes Lemma B.1's statement
  ill-typed — the book's "Lemma B.1's target is gone" is, in Lean, a statement
  about statements, not a theorem in the logic.
-/

import FirstPrinciples.Delta
import FirstPrinciples.StateModel
import FirstPrinciples.Accumulation

universe u

namespace FirstPrinciples
namespace Independence

/-- **The engine.** Union's algebra pulls back through any injective ⊕→∪
    representation: a represented merge is already commutative, associative,
    and idempotent. So a model failing any one of the three admits no
    representation — the form B.4's countermodels use. -/
theorem rep_forces_laws {M A : Type u} (merge : M → M → M) (φ : M → Set' A)
    (hom : ∀ x y, φ (merge x y) = Set'.union (φ x) (φ y))
    (inj : ∀ x y, φ x = φ y → x = y) :
    (∀ a b, merge a b = merge b a)
      ∧ (∀ a b c, merge (merge a b) c = merge a (merge b c))
      ∧ (∀ a, merge a a = a) := by
  refine ⟨fun a b => inj _ _ ?_, fun a b c => inj _ _ ?_, fun a => inj _ _ ?_⟩
  · rw [hom, hom]
    exact Set'.ext fun _ => ⟨Or.symm, Or.symm⟩
  · rw [hom, hom, hom, hom]
    exact Set'.ext fun _ => or_assoc
  · rw [hom]
    exact Set'.ext fun _ => ⟨fun h => h.elim id id, Or.inl⟩

/-! ### B-2b: order-freedom is independent -/

/-- Last-arrival-wins. -/
def lww : Bool → Bool → Bool := fun _ b => b

/-- **B-2b is independent**: `lww` is total (by typing), associative,
    idempotent, and has a left identity — and is not commutative. -/
theorem order_freedom_independent :
    (∀ a b c, lww (lww a b) c = lww a (lww b c))
      ∧ (∀ a, lww a a = a)
      ∧ (∀ a, lww false a = a)
      ∧ ¬ (∀ a b, lww a b = lww b a) := by
  refine ⟨fun _ _ _ => rfl, fun _ => rfl, fun _ => rfl, fun h => ?_⟩
  exact Bool.noConfusion (h false true)

/-- Without order-freedom the representation fails: `lww` admits no injective
    ⊕→∪ homomorphism into any powerset, because `rep_forces_laws` would make it
    commutative. -/
theorem order_freedom_no_representation :
    ¬ ∃ (A : Type) (φ : Bool → Set' A),
        (∀ x y, φ (lww x y) = Set'.union (φ x) (φ y))
          ∧ (∀ x y, φ x = φ y → x = y) := by
  rintro ⟨A, φ, hom, inj⟩
  exact order_freedom_independent.2.2.2 (rep_forces_laws lww φ hom inj).1

/-! ### B-2c: idempotence is independent -/

/-- **B-2c is independent**: `(ℕ, +, 0)` — the book's multisets, over a
    one-fact universe, counting arrivals — is total, commutative, associative,
    with identity, and `1 + 1 ≠ 1`. -/
theorem idempotence_independent :
    (∀ a b : Nat, a + b = b + a)
      ∧ (∀ a b c : Nat, (a + b) + c = a + (b + c))
      ∧ (∀ a : Nat, 0 + a = a)
      ∧ ¬ (∀ a : Nat, a + a = a) :=
  ⟨Nat.add_comm, Nat.add_assoc, Nat.zero_add,
   fun h => Nat.noConfusion (Nat.succ.inj (h 1))⟩

/-- Without idempotence the representation fails: counting admits no injective
    ⊕→∪ homomorphism, because arrivals would stop counting. -/
theorem idempotence_no_representation :
    ¬ ∃ (A : Type) (φ : Nat → Set' A),
        (∀ x y : Nat, φ (x + y) = Set'.union (φ x) (φ y))
          ∧ (∀ x y : Nat, φ x = φ y → x = y) := by
  rintro ⟨A, φ, hom, inj⟩
  exact idempotence_independent.2.2.2 (rep_forces_laws (· + ·) φ hom inj).2.2

/-! ### B-2e: accumulation is independent -/

/-- Finiteness of a predicate-set: a list carries its members. -/
def IsFinite (s : Set' Nat) : Prop := ∃ l : List Nat, ∀ n, s n ↔ n ∈ l

/-- **The finite-subsets model** — the book's "finite subsets of an infinite
    `A` under union: all four laws hold, and the store has no state for the
    limit of an unbounded accumulation." -/
def finsets : StateModel.{0} where
  M := {s : Set' Nat // IsFinite s}
  merge s t := ⟨Set'.union s.val t.val, by
    obtain ⟨l₁, h₁⟩ := s.property
    obtain ⟨l₂, h₂⟩ := t.property
    refine ⟨l₁ ++ l₂, fun n => ?_⟩
    rw [List.mem_append]
    exact ⟨fun h => h.elim (fun h => Or.inl ((h₁ n).mp h)) (fun h => Or.inr ((h₂ n).mp h)),
           fun h => h.elim (fun h => Or.inl ((h₁ n).mpr h)) (fun h => Or.inr ((h₂ n).mpr h))⟩⟩
  empty := ⟨fun _ => False, ⟨[], fun n => by simp⟩⟩
  merge_comm a b := Subtype.ext (Set'.ext fun _ => ⟨Or.symm, Or.symm⟩)
  merge_assoc a b c := Subtype.ext (Set'.ext fun _ => or_assoc)
  merge_idem a := Subtype.ext (Set'.ext fun _ => ⟨fun h => h.elim id id, Or.inl⟩)
  empty_merge a := Subtype.ext (Set'.ext fun _ => ⟨fun h => h.elim False.elim id, Or.inr⟩)

/-- The one-fact state. -/
def single (n : Nat) : finsets.M := ⟨fun m => m = n, ⟨[n], fun m => by simp⟩⟩

/-- Order in `finsets` is membership inclusion. -/
theorem finsets_le (s t : finsets.M) :
    finsets.le s t ↔ ∀ n, s.val n → t.val n := by
  constructor
  · intro h n hs
    have hval : Set'.union s.val t.val n = t.val n :=
      congrFun (congrArg Subtype.val h) n
    exact Eq.mp hval (Or.inl hs)
  · intro h
    exact Subtype.ext (Set'.ext fun n => ⟨fun hor => hor.elim (h n) id, Or.inr⟩)

/-- The atoms of `finsets` are exactly the one-fact states. -/
theorem finsets_isAtom (s : finsets.M) :
    finsets.IsAtom s ↔ ∃ n, s = single n := by
  classical
  constructor
  · rintro ⟨hne, hmin⟩
    have hex : ∃ n, s.val n := by
      by_cases h : ∃ n, s.val n
      · exact h
      · exact absurd
          (Subtype.ext (Set'.ext fun n =>
            ⟨fun hn => absurd ⟨n, hn⟩ h, False.elim⟩) : s = finsets.empty) hne
    obtain ⟨n, hn⟩ := hex
    have hle : finsets.le (single n) s :=
      (finsets_le _ _).mpr fun m hm => hm ▸ hn
    rcases hmin (single n) hle with h | h
    · exact (Eq.mp (congrFun (congrArg Subtype.val h) n) rfl).elim
    · exact ⟨n, h.symm⟩
  · rintro ⟨n, rfl⟩
    refine ⟨fun h => ?_, fun x hx => ?_⟩
    · exact Eq.mp (congrFun (congrArg Subtype.val h) n) rfl
    · have hsub : ∀ m, x.val m → m = n := (finsets_le _ _).mp hx
      by_cases hxn : x.val n
      · refine Or.inr (Subtype.ext (Set'.ext fun m => ⟨hsub m, fun hm => hm ▸ hxn⟩))
      · refine Or.inl (Subtype.ext (Set'.ext fun m =>
          ⟨fun hm => absurd (hsub m hm ▸ hm) hxn, False.elim⟩))

/-- `finsets` satisfies B-2d's "no emergence". -/
theorem finsets_noEmergence : finsets.NoEmergence := by
  intro s t a hatom hle
  obtain ⟨n, rfl⟩ := (finsets_isAtom a).mp hatom
  have hn : s.val n ∨ t.val n := (finsets_le _ _).mp hle n rfl
  rcases hn with h | h
  · exact Or.inl ((finsets_le _ _).mpr fun m hm => hm ▸ h)
  · exact Or.inr ((finsets_le _ _).mpr fun m hm => hm ▸ h)

/-- A member is exactly an atom below: `s.val n ↔ single n ≤ s`. -/
theorem finsets_mem_iff_atomBelow (s : finsets.M) (n : Nat) :
    s.val n ↔ finsets.atomsBelow s (single n) := by
  constructor
  · intro hn
    exact ⟨(finsets_isAtom _).mpr ⟨n, rfl⟩,
           (finsets_le _ _).mpr fun m hm => hm ▸ hn⟩
  · rintro ⟨_, hle⟩
    exact (finsets_le _ _).mp hle n rfl

/-- `finsets` satisfies B-2d's "atomistic". -/
theorem finsets_atomistic : finsets.Atomistic := by
  intro s t h
  refine Subtype.ext (Set'.ext fun n => ?_)
  rw [finsets_mem_iff_atomBelow s n, finsets_mem_iff_atomBelow t n]
  exact h (single n)

/-- Every member of a list is at most its folded maximum. -/
private theorem mem_le_foldr_max : ∀ (l : List Nat), ∀ x ∈ l, x ≤ l.foldr Nat.max 0 := by
  intro l
  induction l with
  | nil => intro x hx; exact absurd hx (by simp)
  | cons a t ih =>
    intro x hx
    rcases List.mem_cons.mp hx with h | h
    · subst h; exact Nat.le_max_left _ _
    · exact Nat.le_trans (ih x h) (Nat.le_max_right _ _)

/-- **B-2e is independent**: in `finsets`, all four merge laws hold and both
    atomicity axioms hold — yet the set of ALL atoms is realized by no state.
    Every state is finite, so some fresh atom lies outside it. The
    representation lands on the finite-subsets lattice, short of the powerset,
    exactly as the book says. -/
theorem accumulation_independent :
    finsets.NoEmergence ∧ finsets.Atomistic
      ∧ ¬ ∃ m : finsets.M, ∀ a, finsets.atomsBelow m a ↔ finsets.IsAtom a := by
  refine ⟨finsets_noEmergence, finsets_atomistic, ?_⟩
  rintro ⟨m, hm⟩
  obtain ⟨l, hl⟩ := m.property
  have hatom : finsets.IsAtom (single (l.foldr Nat.max 0 + 1)) :=
    (finsets_isAtom _).mpr ⟨_, rfl⟩
  have hmem : m.val (l.foldr Nat.max 0 + 1) :=
    (finsets_mem_iff_atomBelow m _).mpr ((hm _).mpr hatom)
  have hle := mem_le_foldr_max l _ ((hl _).mp hmem)
  exact absurd hle (Nat.not_succ_le_self _)

/-- The loop closed: what `finsets` lacks is exactly B-2e. If it had
    accumulation, `atoms_realized` would realize the set of all atoms, which
    `accumulation_independent` refutes. -/
theorem finsets_no_accumulation : ¬ Accumulation.HasAccumulation finsets :=
  fun hacc => accumulation_independent.2.2
    (Accumulation.atoms_realized finsets finsets_noEmergence hacc
      finsets.IsAtom (fun _ h => h))

end Independence
end FirstPrinciples
