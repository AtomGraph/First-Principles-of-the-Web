/-
  First Principles of the Web — Prop 7.5 (Commuting writes), Appendix B.10.
  Self-contained: Lean 4 core only (no Mathlib).

  Union is order-free; a delta is not. Removal and addition do not commute, so
  two writes to the same fact give different states in different orders
  (`same_fact_writes_conflict`). The book's answer has two scopes: within one
  party, HTTP conditional requests put writes in order; between parties, each
  party removes only facts it asserted. Deltas confined to disjoint regions of
  facts commute (`writes_commute`). In a dataspace the regions are the parties'
  graphs — quads whose fourth position lies under one origin (Prop 9.2, B.9) —
  so R2's order-freedom extends from merges to writes.
-/

import FirstPrinciples.Delta

universe u

namespace FirstPrinciples
namespace Concurrency

variable {α : Type u}

/-- Applying a delta: `(S ∖ D⁻) ∪ D⁺` (7.1). -/
def applyDelta (S Dm Dp : Set' α) : Set' α := Set'.union (Set'.diff S Dm) Dp

/-- **Prop 7.5 (Commuting writes).** Two deltas, each confined to its own
    region of facts, commute when the regions are disjoint: no fact is touched
    by both, so the order of application does not matter. -/
theorem writes_commute (R₁ R₂ : Set' α) (hdisj : ∀ a, ¬ (R₁ a ∧ R₂ a))
    (S Dm₁ Dp₁ Dm₂ Dp₂ : Set' α)
    (h₁ : Set'.Subset Dm₁ R₁ ∧ Set'.Subset Dp₁ R₁)
    (h₂ : Set'.Subset Dm₂ R₂ ∧ Set'.Subset Dp₂ R₂) :
    applyDelta (applyDelta S Dm₁ Dp₁) Dm₂ Dp₂
      = applyDelta (applyDelta S Dm₂ Dp₂) Dm₁ Dp₁ := by
  apply Set'.ext
  intro a
  simp only [applyDelta, Set'.union, Set'.diff]
  by_cases hA : R₁ a
  · have hB : ¬ R₂ a := fun h => hdisj a ⟨hA, h⟩
    have n1 : ¬ Dm₂ a := fun h => hB (h₂.1 a h)
    have n2 : ¬ Dp₂ a := fun h => hB (h₂.2 a h)
    simp [n1, n2]
  · have n1 : ¬ Dm₁ a := fun h => hA (h₁.1 a h)
    have n2 : ¬ Dp₁ a := fun h => hA (h₁.2 a h)
    simp [n1, n2]

/-- **Disjointness cannot be dropped.** From the empty state, adding a fact and
    then removing it differs from removing it and then adding it. -/
theorem same_fact_writes_conflict (a : α) :
    applyDelta (applyDelta (fun _ => False) (fun _ => False) (fun x => x = a))
        (fun x => x = a) (fun _ => False)
      ≠ applyDelta (applyDelta (fun _ => False) (fun x => x = a) (fun _ => False))
        (fun _ => False) (fun x => x = a) := by
  intro h
  have := congrFun h a
  simp [applyDelta, Set'.union, Set'.diff] at this

end Concurrency
end FirstPrinciples
