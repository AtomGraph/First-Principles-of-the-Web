/-
  First Principles of the Web — Appendix B, Lemma B.1 (Representation).
  Self-contained mechanization: Lean 4 core only (no Mathlib).

  A `StateModel` is a carrier `M` with a merge `⊕` and a least element `∅`
  satisfying the transposed merge laws that are algebraic identities:

    B-2a  totality      : ⊕ is a total function            (automatic by typing)
    B-2b  order-freedom : ⊕ is associative and commutative
    B-2c  idempotence   : a ⊕ a = a
    (∅ identity         : ∅ ⊕ a = a)   — the party with nothing to say

  These make `(M, ⊕, ∅)` a bounded join-semilattice, and induce the order
  `a ≤ b := a ⊕ b = b`. Everything provable from the semilattice alone is a
  THEOREM below (partial order, bottom, monotonicity, ⊇-half of the hom,
  ∅ carries no atoms).

  The remaining content of B-2d (atomicity, "no emergence") is genuinely
  axiomatic — not derivable from the semilattice laws — and is ISOLATED as
  the two named predicates `NoEmergence` and `Atomistic`, taken as explicit
  hypotheses of the representation theorem. This makes visible exactly which
  half of B-2d is load-bearing (cf. Appendix B.4, independence of the laws):
  the ⊇ inclusion of the homomorphism is derived; only the ⊆ inclusion needs
  an axiom.

  Result: `representation_embedding` — under the atomicity axioms the atom map
  `atomsBelow` is an injective, ∅-preserving, ⊕→∪ homomorphism into predicates
  over the atoms. This is the embedding (operational) half of Lemma B.1, which
  the book itself flags as "the version that carries the operational content,
  since messages are finite." Surjectivity onto finite atom-sets, and B-2e's
  jump to the full powerset, are the remaining half — noted at the end.
-/

universe u

/-- A state model: a bounded join-semilattice `(M, ⊕, ∅)`. -/
structure StateModel where
  M : Type u
  merge : M → M → M
  empty : M
  merge_comm  : ∀ a b, merge a b = merge b a
  merge_assoc : ∀ a b c, merge (merge a b) c = merge a (merge b c)
  merge_idem  : ∀ a, merge a a = a
  empty_merge : ∀ a, merge empty a = a

namespace StateModel

variable (S : StateModel)

/-- The induced order: `a ≤ b` iff merging `a` into `b` changes nothing. -/
def le (a b : S.M) : Prop := S.merge a b = b

/-- `∅` is a right identity too (comm + left identity). -/
theorem merge_empty (a : S.M) : S.merge a S.empty = a := by
  rw [S.merge_comm, S.empty_merge]

/-- Reflexivity — from idempotence. -/
theorem le_refl (a : S.M) : S.le a a := S.merge_idem a

/-- Transitivity — from associativity. -/
theorem le_trans {a b c : S.M} (hab : S.le a b) (hbc : S.le b c) : S.le a c := by
  have hab' : S.merge a b = b := hab
  have hbc' : S.merge b c = c := hbc
  show S.merge a c = c
  calc S.merge a c
      = S.merge a (S.merge b c) := by rw [hbc']
    _ = S.merge (S.merge a b) c := (S.merge_assoc a b c).symm
    _ = S.merge b c := by rw [hab']
    _ = c := hbc'

/-- Antisymmetry — from commutativity. -/
theorem le_antisymm {a b : S.M} (hab : S.le a b) (hba : S.le b a) : a = b := by
  have hab' : S.merge a b = b := hab
  have hba' : S.merge b a = a := hba
  have hcomm : S.merge a b = S.merge b a := S.merge_comm a b
  rw [hab', hba'] at hcomm
  exact hcomm.symm

/-- `∅` is the least element. -/
theorem empty_le (a : S.M) : S.le S.empty a := S.empty_merge a

/-- Monotonicity: `s ≤ s ⊕ t`. -/
theorem le_merge_left (s t : S.M) : S.le s (S.merge s t) := by
  show S.merge s (S.merge s t) = S.merge s t
  calc S.merge s (S.merge s t)
      = S.merge (S.merge s s) t := (S.merge_assoc s s t).symm
    _ = S.merge s t := by rw [S.merge_idem]

/-- Monotonicity: `t ≤ s ⊕ t`. -/
theorem le_merge_right (s t : S.M) : S.le t (S.merge s t) := by
  have h := S.le_merge_left t s
  have h' : S.merge t (S.merge t s) = S.merge t s := h
  show S.merge t (S.merge s t) = S.merge s t
  rw [S.merge_comm s t]
  exact h'

/-- An atom: a minimal state strictly above `∅`. -/
def IsAtom (a : S.M) : Prop :=
  a ≠ S.empty ∧ ∀ x, S.le x a → x = S.empty ∨ x = a

/-- The atoms below a state `s` (a predicate over `M`). -/
def atomsBelow (s a : S.M) : Prop := S.IsAtom a ∧ S.le a s

/-- `∅` carries no atoms — so the atom map sends `∅` to the empty predicate. -/
theorem atomsBelow_empty (a : S.M) : ¬ S.atomsBelow S.empty a := by
  rintro ⟨hatom, hle⟩
  have h1 : S.merge a S.empty = S.empty := hle
  have h2 : S.merge a S.empty = a := S.merge_empty a
  have hae : a = S.empty := by rw [← h2, h1]
  exact hatom.1 hae

/-- Homomorphism, ⊇ from the left — DERIVED (no axiom): an atom below `s` is
    below `s ⊕ t`. -/
theorem atomsBelow_merge_of_left {s t a : S.M} (h : S.atomsBelow s a) :
    S.atomsBelow (S.merge s t) a := by
  obtain ⟨hatom, hle⟩ := h
  exact ⟨hatom, S.le_trans hle (S.le_merge_left s t)⟩

/-- Homomorphism, ⊇ from the right — DERIVED (no axiom). -/
theorem atomsBelow_merge_of_right {s t a : S.M} (h : S.atomsBelow t a) :
    S.atomsBelow (S.merge s t) a := by
  obtain ⟨hatom, hle⟩ := h
  exact ⟨hatom, S.le_trans hle (S.le_merge_right s t)⟩

/-- B-2d "no emergence": composition creates no atoms. The ⊆ half of the
    homomorphism, and the genuine axiomatic content beyond the semilattice. -/
def NoEmergence : Prop :=
  ∀ s t a, S.IsAtom a → S.le a (S.merge s t) → S.le a s ∨ S.le a t

/-- B-2d "atomistic": a state is determined by the atoms below it. This is
    clause 1 ("every state is the join of its atoms") in the form the
    injectivity argument consumes; the join-based derivation is left to the
    Mathlib development. -/
def Atomistic : Prop :=
  ∀ s t, (∀ a, S.atomsBelow s a ↔ S.atomsBelow t a) → s = t

/-- The homomorphism in full: `atomsBelow (s ⊕ t) = atomsBelow s ∪ atomsBelow t`.
    The ⊇ inclusion is derived; the ⊆ inclusion uses `NoEmergence`. -/
theorem atomsBelow_merge (hne : S.NoEmergence) (s t a : S.M) :
    S.atomsBelow (S.merge s t) a ↔ S.atomsBelow s a ∨ S.atomsBelow t a := by
  constructor
  · rintro ⟨hatom, hle⟩
    rcases hne s t a hatom hle with h1 | h1
    · exact Or.inl ⟨hatom, h1⟩
    · exact Or.inr ⟨hatom, h1⟩
  · rintro (h | h)
    · exact S.atomsBelow_merge_of_left h
    · exact S.atomsBelow_merge_of_right h

/-- Injectivity of the atom map — the representation embedding is injective. -/
theorem atoms_injective (hat : S.Atomistic) {s t : S.M}
    (h : ∀ a, S.atomsBelow s a ↔ S.atomsBelow t a) : s = t :=
  hat s t h

/--
  **Lemma B.1 (embedding half).** Under the atomicity axioms `NoEmergence`
  and `Atomistic`, the atom map `atomsBelow` embeds the state model into
  `(M → Prop, ∪)`:

  * it preserves the bottom — `∅` maps to the empty predicate;
  * it carries `⊕` to `∪`;
  * it is injective.

  Hence `⊕` is set union on the image, which is (5.1). The remaining half —
  surjectivity onto finite atom-sets, and, with B-2e, onto the full powerset —
  is left to the Mathlib development.
-/
theorem representation_embedding (hne : S.NoEmergence) (hat : S.Atomistic) :
    (∀ a, ¬ S.atomsBelow S.empty a)
      ∧ (∀ s t a, S.atomsBelow (S.merge s t) a
            ↔ S.atomsBelow s a ∨ S.atomsBelow t a)
      ∧ (∀ s t, (∀ a, S.atomsBelow s a ↔ S.atomsBelow t a) → s = t) :=
  ⟨S.atomsBelow_empty, S.atomsBelow_merge hne, hat⟩

end StateModel
