/-
  First Principles of the Web — B-2e (accumulation) and the full powerset.
  Self-contained: Lean 4 core only (no Mathlib).

  B.1 so far: under the atomicity axioms the atom map embeds, and every FINITE
  atom-set is realized (`representation_finite`). The book's Lemma B.1 claims
  the full powerset, and prices the jump exactly: "B-2e is exactly what the full
  powerset costs, and it is now on the bill rather than in a remark."

  This file puts B-2e on the Lean bill too. `HasAccumulation` states it as the
  book does: every directed family of states has a join whose atoms are the
  union of the family's atom sets. From it:

    * `atoms_realized` — EVERY set of atoms is some state's atom-set: realize
      each finite part (`joinList`), then take the directed join of the finite
      realizations. This is B.1's surjectivity argument, verbatim.
    * `representation_full` — Lemma B.1 complete: the atom map is an injective
      ⊕→∪ homomorphism onto the full powerset of atoms.
    * `uniqueness_iso` — Thm 5.4 with "isomorphic" exact: transported along the
      atom≅triple bijection, `σ : M → 𝒫(T)` is a ⊕→∪ BIJECTION. Nothing short
      of the powerset, nothing beyond it.

  Independence.lean shows the axiom is not free: the finite-subsets model
  satisfies B-2a–d yet has no accumulation, and its representation stops at the
  finite sets — so B-2e is used exactly where the book says it is.
-/

import FirstPrinciples.Delta
import FirstPrinciples.StateModel
import FirstPrinciples.Uniqueness

universe u

namespace FirstPrinciples
namespace Accumulation

open Uniqueness (Bij transport transport_union transport_injective
                 atomRep atomRep_hom atomRep_inj)

/-- **B-2e (accumulation)**, as the book states it: every directed family of
    states has a join, "with `atoms` of the join the union of the family's atom
    sets." `m` is an upper bound and the atoms clause is B-2e's second clause
    verbatim; leastness is not needed below and is omitted. -/
def HasAccumulation (S : StateModel.{u}) : Prop :=
  ∀ {I : Type u} (fam : I → S.M),
    (∀ i j, ∃ k, S.le (fam i) (fam k) ∧ S.le (fam j) (fam k)) →
    ∃ m : S.M, (∀ i, S.le (fam i) m)
      ∧ (∀ a, S.atomsBelow m a ↔ ∃ i, S.atomsBelow (fam i) a)

/-- The join of an appended list is the merge of the joins. -/
theorem joinList_append (S : StateModel.{u}) (l₁ l₂ : List S.M) :
    S.joinList (l₁ ++ l₂) = S.merge (S.joinList l₁) (S.joinList l₂) := by
  induction l₁ with
  | nil =>
    show S.joinList l₂ = S.merge S.empty (S.joinList l₂)
    rw [S.empty_merge]
  | cons a t ih =>
    show S.merge a (S.joinList (t ++ l₂))
      = S.merge (S.merge a (S.joinList t)) (S.joinList l₂)
    rw [ih, S.merge_assoc]

/-- **Every atom-set is realized** (B.1's surjectivity, full). Given any set `X`
    of atoms: the finite lists drawn from `X` realize its finite parts
    (`atomsBelow_joinList`), they form a directed family under append, and
    B-2e's join realizes `X` itself. -/
theorem atoms_realized (S : StateModel.{u}) (hne : S.NoEmergence)
    (hacc : HasAccumulation S)
    (X : Set' S.M) (hX : ∀ a, X a → S.IsAtom a) :
    ∃ m : S.M, ∀ a, S.atomsBelow m a ↔ X a := by
  have hmap : ∀ (l : List {x : S.M // S.IsAtom x ∧ X x}),
      ∀ b ∈ l.map Subtype.val, S.IsAtom b := by
    rintro l b hb
    obtain ⟨u, _, rfl⟩ := List.mem_map.mp hb
    exact u.property.1
  obtain ⟨m, _, hatoms⟩ :=
    hacc (I := List {x : S.M // S.IsAtom x ∧ X x})
      (fun l => S.joinList (l.map Subtype.val))
      (by
        intro i j
        refine ⟨i ++ j, ?_, ?_⟩
        · show S.le (S.joinList (i.map Subtype.val))
            (S.joinList ((i ++ j).map Subtype.val))
          rw [List.map_append, joinList_append]
          exact S.le_merge_left _ _
        · show S.le (S.joinList (j.map Subtype.val))
            (S.joinList ((i ++ j).map Subtype.val))
          rw [List.map_append, joinList_append]
          exact S.le_merge_right _ _)
  refine ⟨m, fun a => ?_⟩
  rw [hatoms a]
  constructor
  · rintro ⟨l, hl⟩
    have hmem := (S.atomsBelow_joinList hne (l.map Subtype.val) (hmap l) a).mp hl
    obtain ⟨u, _, rfl⟩ := List.mem_map.mp hmem.2
    exact u.property.2
  · intro hXa
    refine ⟨[⟨a, hX a hXa, hXa⟩],
      (S.atomsBelow_joinList hne _ (hmap _) a).mpr ⟨hX a hXa, ?_⟩⟩
    simp

/-- **Lemma B.1, complete.** Under the atomicity axioms and B-2e, the atom map
    is an injective ⊕→∪ homomorphism and every set of atoms is realized: the
    model is `(𝒫(A), ∪)`, the full powerset. -/
theorem representation_full (S : StateModel.{u}) (hne : S.NoEmergence)
    (hat : S.Atomistic) (hacc : HasAccumulation S) :
    (∀ s t, (∀ a, S.atomsBelow s a ↔ S.atomsBelow t a) → s = t)
      ∧ (∀ s t a, S.atomsBelow (S.merge s t) a
           ↔ S.atomsBelow s a ∨ S.atomsBelow t a)
      ∧ (∀ X : Set' S.M, (∀ a, X a → S.IsAtom a) →
           ∃ m, ∀ a, S.atomsBelow m a ↔ X a) :=
  ⟨hat, S.atomsBelow_merge hne, atoms_realized S hne hacc⟩

/-- **Theorem 5.4, "isomorphic" exact.** With B-2e, the transported atom map
    `σ : M → 𝒫(T)` is a ⊕→∪ **bijection**: injective, and every set of triples
    — finite or not — is some state's image. This is the full isomorphism the
    theorem states; `uniqueness_finite` is its B-2e-free operational shadow. -/
theorem uniqueness_iso (S : StateModel.{u}) (hne : S.NoEmergence)
    (hat : S.Atomistic) (hacc : HasAccumulation S)
    {T : Type u} (e : Bij {a : S.M // S.IsAtom a} T) :
    ∃ σ : S.M → Set' T,
      (∀ x y, σ (S.merge x y) = Set'.union (σ x) (σ y))
        ∧ (∀ x y, σ x = σ y → x = y)
        ∧ (∀ X : Set' T, ∃ m : S.M, σ m = X) := by
  refine ⟨fun m => transport e (atomRep S m),
          fun x y => by
            show transport e (atomRep S (S.merge x y))
              = Set'.union (transport e (atomRep S x)) (transport e (atomRep S y))
            rw [atomRep_hom S hne, transport_union],
          fun x y h => atomRep_inj S hat x y (transport_injective e h),
          ?_⟩
  intro X
  obtain ⟨m, hm⟩ := atoms_realized S hne hacc
    (fun a => ∃ h : S.IsAtom a, X (e.toFun ⟨a, h⟩))
    (fun _ h => h.1)
  refine ⟨m, Set'.ext fun t => ?_⟩
  show S.atomsBelow m (e.invFun t).val ↔ X t
  rw [hm]
  constructor
  · rintro ⟨h, hXt⟩
    have hrw : (⟨(e.invFun t).val, h⟩ : {a : S.M // S.IsAtom a}) = e.invFun t := rfl
    rw [hrw, e.right_inv] at hXt
    exact hXt
  · intro hXt
    refine ⟨(e.invFun t).property, ?_⟩
    have hrw : (⟨(e.invFun t).val, (e.invFun t).property⟩ : {a : S.M // S.IsAtom a})
        = e.invFun t := rfl
    rw [hrw, e.right_inv]
    exact hXt

end Accumulation
end FirstPrinciples
