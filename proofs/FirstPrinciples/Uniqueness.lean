/-
  First Principles of the Web — Theorem 5.4 / B.3 (Uniqueness), the assembly.
  Self-contained: Lean 4 core only (no Mathlib).

  B.3 composes two proved facts:
    * B.1 (representation): a state model has an injective, ⊕→∪ homomorphism
      ρ : M → 𝒫(A) into sets of its atoms A            (StateModel.lean)
    * B.2 (arity): the atoms are triples, A ≅ I × I × (I∪V)   (Arity.lean)
  "Compose the isomorphisms": transport ρ along the atom≅triple bijection to get
  an injective ⊕→∪ homomorphism M → 𝒫(triples). That is uniqueness up to a
  reading-preserving isomorphism.

  `uniqueness_compose` is the abstract assembly (bijection transport preserves an
  injective union-homomorphism). `uniqueness` instantiates it on a real
  `StateModel` using B.1's representation (`atomRep`), taking the atom≅triple
  bijection as the explicit B.2 input — the same way the book's B.3 takes B.2's
  conclusion as an input to the assembly.
-/

import FirstPrinciples.Delta
import FirstPrinciples.StateModel

universe u

namespace FirstPrinciples
namespace Uniqueness

/-- A bijection between two types. -/
structure Bij (α : Type u) (β : Type u) where
  toFun : α → β
  invFun : β → α
  left_inv : ∀ a, invFun (toFun a) = a
  right_inv : ∀ b, toFun (invFun b) = b

/-- Transport a set along a bijection of its base type. -/
def transport {α β : Type u} (e : Bij α β) (s : Set' α) : Set' β :=
  fun b => s (e.invFun b)

/-- Transport preserves union. -/
theorem transport_union {α β : Type u} (e : Bij α β) (s t : Set' α) :
    transport e (Set'.union s t) = Set'.union (transport e s) (transport e t) := by
  apply Set'.ext
  intro _
  exact Iff.rfl

/-- Transport is injective on sets (its inverse is transport along `e.invFun`). -/
theorem transport_injective {α β : Type u} (e : Bij α β) {s t : Set' α}
    (h : transport e s = transport e t) : s = t := by
  apply Set'.ext
  intro a
  have hb : s (e.invFun (e.toFun a)) = t (e.invFun (e.toFun a)) := congrFun h (e.toFun a)
  rw [e.left_inv a] at hb
  rw [hb]

/-- **Assembly (B.3).** Given a representation `ρ` (B.1: injective, ⊕→∪) and a
    bijection `e : A ≅ T` (B.2: atoms are triples), the transported map is again
    an injective ⊕→∪ homomorphism `M → 𝒫(T)`. -/
theorem uniqueness_compose {M A T : Type u}
    (merge : M → M → M)
    (ρ : M → Set' A)
    (ρ_hom : ∀ x y, ρ (merge x y) = Set'.union (ρ x) (ρ y))
    (ρ_inj : ∀ x y, ρ x = ρ y → x = y)
    (e : Bij A T) :
    ∃ σ : M → Set' T,
      (∀ x y, σ (merge x y) = Set'.union (σ x) (σ y))
        ∧ (∀ x y, σ x = σ y → x = y) := by
  refine ⟨fun m => transport e (ρ m), ?_, ?_⟩
  · intro x y
    show transport e (ρ (merge x y))
      = Set'.union (transport e (ρ x)) (transport e (ρ y))
    rw [ρ_hom, transport_union]
  · intro x y h
    have h' : transport e (ρ x) = transport e (ρ y) := h
    exact ρ_inj x y (transport_injective e h')

/-! ### Instantiation on a real `StateModel` — B.3 rests on B.1 -/

/-- B.1's representation, packaged over the atom subtype: a state maps to the set
    of atoms below it. -/
def atomRep (S : StateModel) (s : S.M) : Set' {a : S.M // S.IsAtom a} :=
  fun b => S.atomsBelow s b.val

/-- `atomRep` is a ⊕→∪ homomorphism (from B.1's `atomsBelow_merge`). -/
theorem atomRep_hom (S : StateModel) (hne : S.NoEmergence) (x y : S.M) :
    atomRep S (S.merge x y) = Set'.union (atomRep S x) (atomRep S y) := by
  apply Set'.ext
  intro b
  exact S.atomsBelow_merge hne x y b.val

/-- `atomRep` is injective (from B.1's `atoms_injective`; non-atoms contribute
    nothing, so the atom-indexed set determines the state). -/
theorem atomRep_inj (S : StateModel) (hat : S.Atomistic) (x y : S.M)
    (h : atomRep S x = atomRep S y) : x = y := by
  apply S.atoms_injective hat
  intro a
  by_cases ha : S.IsAtom a
  · have e : S.atomsBelow x a = S.atomsBelow y a := congrFun h ⟨a, ha⟩
    rw [e]
  · constructor
    · intro hx; exact absurd hx.1 ha
    · intro hy; exact absurd hy.1 ha

/-- **Theorem 5.4 (Uniqueness), assembled.** A state model with the atomicity
    axioms (B.1) whose atoms biject with a type `T` (B.2: `T = I×I×(I∪V)`) has an
    injective ⊕→∪ homomorphism into `𝒫(T)` — uniqueness up to a
    reading-preserving isomorphism. -/
theorem uniqueness (S : StateModel) (hne : S.NoEmergence) (hat : S.Atomistic)
    {T : Type u} (e : Bij {a : S.M // S.IsAtom a} T) :
    ∃ σ : S.M → Set' T,
      (∀ x y, σ (S.merge x y) = Set'.union (σ x) (σ y))
        ∧ (∀ x y, σ x = σ y → x = y) :=
  uniqueness_compose S.merge (atomRep S) (atomRep_hom S hne) (atomRep_inj S hat) e

/-! ### The finite bijection — Thm 5.4's "isomorphic", made exact

`uniqueness` gives the embedding. Thm 5.4 says "isomorphic", and in the finite
(the version B.1 flags as the one carrying the operational content) the atom map
is also surjective: every finite set of triples is some state's image. This
transports `atomsBelow_joinList` along the atom≅triple bijection. The full
powerset needs B-2e and stays on the deferred list. -/

/-- **Thm 5.4, finite bijection.** The embedding `σ` of `uniqueness`, plus
    realization: every finite set of triples (any `List T`, as a set) is `σ` of
    some state — the join of the atoms the bijection names. So `σ` is a ⊕→∪
    bijection onto its image, and the image contains every finite set. -/
theorem uniqueness_finite (S : StateModel) (hne : S.NoEmergence) (hat : S.Atomistic)
    {T : Type u} (e : Bij {a : S.M // S.IsAtom a} T) :
    ∃ σ : S.M → Set' T,
      (∀ x y, σ (S.merge x y) = Set'.union (σ x) (σ y))
        ∧ (∀ x y, σ x = σ y → x = y)
        ∧ (∀ l : List T, ∃ m : S.M, σ m = fun t => t ∈ l) := by
  refine ⟨fun m => transport e (atomRep S m),
          fun x y => by
            show transport e (atomRep S (S.merge x y))
              = Set'.union (transport e (atomRep S x)) (transport e (atomRep S y))
            rw [atomRep_hom S hne, transport_union],
          fun x y h => atomRep_inj S hat x y (transport_injective e h),
          ?_⟩
  intro l
  -- The state: the join of the atoms the bijection assigns to `l`'s triples.
  refine ⟨S.joinList (l.map fun t => (e.invFun t).val), ?_⟩
  apply Set'.ext
  intro t
  show S.atomsBelow (S.joinList (l.map fun t => (e.invFun t).val)) (e.invFun t).val
    ↔ t ∈ l
  rw [S.atomsBelow_joinList hne _
        (by rintro a ha
            obtain ⟨u, _, rfl⟩ := List.mem_map.mp ha
            exact (e.invFun u).property)]
  constructor
  · rintro ⟨_, hmem⟩
    obtain ⟨u, hu, hval⟩ := List.mem_map.mp hmem
    have : e.invFun u = e.invFun t := Subtype.ext hval
    have : u = t := by
      have h1 : e.toFun (e.invFun u) = e.toFun (e.invFun t) := congrArg e.toFun this
      rwa [e.right_inv, e.right_inv] at h1
    exact this ▸ hu
  · intro ht
    exact ⟨(e.invFun t).property, List.mem_map.mpr ⟨t, ht, rfl⟩⟩

end Uniqueness
end FirstPrinciples
