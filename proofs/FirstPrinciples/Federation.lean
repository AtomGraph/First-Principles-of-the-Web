/-
  First Principles of the Web — B.9 (Federation closure).
  Self-contained: Lean 4 core only (no Mathlib).

  The union of two dataspace states is again dataspace-shaped: one graph per
  document, every document under exactly one origin. The engine is RFC 6454:
  the origin is computed from the URI, so distinct origins are DISJOINT regions
  of the name space — two dataspaces' graph names never collide, and the union
  claims each name once. Federation is the union law; it needs no machinery.
-/

universe u

namespace FirstPrinciples
namespace Federation

variable {Name O Graph : Type u}

-- RFC 6454: the origin is a function of the name.
variable (origin : Name → O)

/-- The region of names under origin `o` (RFC 6454's `I∣o`). -/
def region (o : O) : Name → Prop := fun n => origin n = o

/-- **Distinct origins have disjoint regions:** `o ≠ o' ⟹ I∣o ∩ I∣o' = ∅`. -/
theorem regions_disjoint {o o' : O} (h : o ≠ o') (n : Name) :
    ¬ (region origin o n ∧ region origin o' n) := by
  rintro ⟨h1, h2⟩
  have e1 : origin n = o := h1
  have e2 : origin n = o' := h2
  exact h (e1.symm.trans e2)

/-- A graph-family: `g n = some G` means it serves graph `G` at document `n`;
    `g n = none` means it does not. -/
abbrev Family (Name Graph : Type u) := Name → Option Graph

/-- **No name is served by both origin-disjoint families** — so their union
    carries one graph per document, no collision. -/
theorem no_double_claim
    {o o' : O} (h : o ≠ o')
    (g₁ g₂ : Family Name Graph)
    (h₁ : ∀ n, g₁ n ≠ none → origin n = o)
    (h₂ : ∀ n, g₂ n ≠ none → origin n = o')
    (n : Name) :
    g₁ n = none ∨ g₂ n = none := by
  by_cases hc1 : g₁ n = none
  · exact Or.inl hc1
  · refine Or.inr ?_
    by_cases hc2 : g₂ n = none
    · exact hc2
    · have e1 : origin n = o := h₁ n hc1
      have e2 : origin n = o' := h₂ n hc2
      exact absurd (e1.symm.trans e2) h

/--
  **B.9 (Federation closure).** The union of two origin-disjoint graph-families
  is again well-formed:

  * no document name is served by both (one graph per document);
  * every name keeps its single origin (origin is a function).

  So federation inherits the union law with no extra machinery.
-/
theorem federation_closure
    {o o' : O} (h : o ≠ o')
    (g₁ g₂ : Family Name Graph)
    (h₁ : ∀ n, g₁ n ≠ none → origin n = o)
    (h₂ : ∀ n, g₂ n ≠ none → origin n = o') :
    (∀ n, g₁ n = none ∨ g₂ n = none)
      ∧ (∀ n o₁ o₂, origin n = o₁ → origin n = o₂ → o₁ = o₂) :=
  ⟨fun n => no_double_claim origin h g₁ g₂ h₁ h₂ n,
   fun _ _ _ ha hb => ha.symm.trans hb⟩

end Federation
end FirstPrinciples
