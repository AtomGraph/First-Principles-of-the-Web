/-
  First Principles of the Web — coordination-free convergence.
  Self-contained: Lean 4 core only (no Mathlib).

  Chapter 5 argues the merge laws from "no coordinator", and notes that
  distributed-systems research derived the same laws from replication pressure:
  "Two fields with different motives reached the same algebra." The book cites
  that convergence result; this file proves it for the derived model, so the
  corroboration becomes a check.

  `converges` is **strong eventual consistency**: two parties that have
  received the same updates hold the same state — whatever order the updates
  arrived in, and however often any of them was redelivered. Nothing is assumed
  beyond B-2a–c (the laws that make `(M, ⊕, ∅)` a bounded join-semilattice):
  totality is the typing, order-freedom gives permutation, idempotence gives
  duplication. That is the algebraic content of "composing may never require a
  compatibility check, because checking is coordinating."

  Note what the statement does NOT need: no delivery guarantees, no causal
  order, no version vectors, no consensus. Two lists with the same members —
  nothing more.
-/

import FirstPrinciples.StateModel

universe u

namespace FirstPrinciples
namespace Convergence

variable (S : StateModel)

/-- A merge of two states below `x` is itself below `x` (the join is least). -/
theorem merge_le {a b x : S.M} (ha : S.le a x) (hb : S.le b x) :
    S.le (S.merge a b) x := by
  show S.merge (S.merge a b) x = x
  calc S.merge (S.merge a b) x
      = S.merge a (S.merge b x) := S.merge_assoc a b x
    _ = S.merge a x := by rw [show S.merge b x = x from hb]
    _ = x := ha

/-- Every update in a delivery list is below the merged state. -/
theorem mem_le_joinList : ∀ (l : List S.M) (a : S.M), a ∈ l → S.le a (S.joinList l) := by
  intro l
  induction l with
  | nil => intro a ha; exact absurd ha (by simp)
  | cons b t ih =>
    intro a ha
    have hstep : S.joinList (b :: t) = S.merge b (S.joinList t) := rfl
    rw [hstep]
    rcases List.mem_cons.mp ha with rfl | hmem
    · exact S.le_merge_left a (S.joinList t)
    · exact S.le_trans (ih a hmem) (S.le_merge_right b (S.joinList t))

/-- Receiving a sub-collection yields a smaller state. -/
theorem joinList_le_of_subset : ∀ (l l' : List S.M), (∀ a, a ∈ l → a ∈ l') →
    S.le (S.joinList l) (S.joinList l') := by
  intro l
  induction l with
  | nil => intro l' _; exact S.empty_le (S.joinList l')
  | cons a t ih =>
    intro l' hsub
    have hstep : S.joinList (a :: t) = S.merge a (S.joinList t) := rfl
    rw [hstep]
    exact merge_le S
      (mem_le_joinList S l' a (hsub a (List.mem_cons_self a t)))
      (ih l' (fun x hx => hsub x (List.mem_cons_of_mem a hx)))

/-- **Strong eventual consistency.** Two replicas that have received the same
    updates hold the same state — in any order, with any duplication. Coordination-free
    convergence is a theorem of the merge laws alone: no delivery guarantees,
    no causal order, no version vectors, no consensus. This is the property the
    CRDT literature derives from replication pressure, here derived from the
    web's own transposed rules. -/
theorem converges (l l' : List S.M) (h : ∀ a, a ∈ l ↔ a ∈ l') :
    S.joinList l = S.joinList l' :=
  S.le_antisymm
    (joinList_le_of_subset S l l' (fun a ha => (h a).mp ha))
    (joinList_le_of_subset S l' l (fun a ha => (h a).mpr ha))

/-- Convergence, spelled out as the three properties a replica needs: order
    does not matter, redelivery does not matter, and a party that has heard
    everything is above every party that has heard some of it. -/
theorem replica_laws (l l' : List S.M) :
    ((∀ a, a ∈ l ↔ a ∈ l') → S.joinList l = S.joinList l')
      ∧ (∀ a, a ∈ l → S.le a (S.joinList l))
      ∧ ((∀ a, a ∈ l → a ∈ l') → S.le (S.joinList l) (S.joinList l')) :=
  ⟨converges S l l', mem_le_joinList S l, joinList_le_of_subset S l l'⟩

end Convergence
end FirstPrinciples
