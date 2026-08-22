/-
  First Principles of the Web — Prop 7.1 (Delta normal form).
  Self-contained: Lean 4 core only (no Mathlib).

  Over a set-of-facts model, every state change factors as a least pair of sets
  — a delta `(D⁻, D⁺)`. "Two sets. That is the entire theory of mutation over a
  fact-set model." Here that is made exact: the canonical delta reconstructs the
  target (`delta_apply`), and it is the least pair that does so (`delta_least`).

  A minimal set layer (`Set' α := α → Prop`) keeps the development free of
  Mathlib; states are sets of facts, so this is set algebra and nothing more.
-/

universe u

namespace FirstPrinciples

/-- Sets as predicates — membership `s a` is application. -/
def Set' (α : Type u) := α → Prop

namespace Set'
variable {α : Type u}

/-- Union. -/
def union (s t : Set' α) : Set' α := fun a => s a ∨ t a
/-- Difference `s \ t`. -/
def diff (s t : Set' α) : Set' α := fun a => s a ∧ ¬ t a
/-- Inclusion. -/
def Subset (s t : Set' α) : Prop := ∀ a, s a → t a

/-- Extensionality: pointwise-equal sets are equal (funext + propext). -/
theorem ext {s t : Set' α} (h : ∀ a, s a ↔ t a) : s = t :=
  funext fun a => propext (h a)

end Set'

variable {α : Type u}

/-- The facts removed going from `S` to `T`. -/
def Dminus (S T : Set' α) : Set' α := Set'.diff S T
/-- The facts added going from `S` to `T`. -/
def Dplus (S T : Set' α) : Set' α := Set'.diff T S

/-- **Applying the canonical delta reconstructs the target:**
    `(S ∖ D⁻) ∪ D⁺ = T`. -/
theorem delta_apply (S T : Set' α) :
    Set'.union (Set'.diff S (Dminus S T)) (Dplus S T) = T := by
  apply Set'.ext
  intro a
  simp only [Set'.union, Set'.diff, Dminus, Dplus]
  by_cases hT : T a <;> by_cases hS : S a <;> simp [hT, hS]

/-- **The canonical delta is the least such pair:** any `(A, B)` with
    `(S ∖ A) ∪ B = T` satisfies `D⁻ ⊆ A` and `D⁺ ⊆ B`. -/
theorem delta_least (S T A B : Set' α)
    (h : Set'.union (Set'.diff S A) B = T) :
    Set'.Subset (Dminus S T) A ∧ Set'.Subset (Dplus S T) B := by
  constructor
  · intro a ha
    have ha' : S a ∧ ¬ T a := ha
    by_cases hA : A a
    · exact hA
    · have hmem : (Set'.union (Set'.diff S A) B) a := Or.inl ⟨ha'.1, hA⟩
      rw [h] at hmem
      exact absurd hmem ha'.2
  · intro a ha
    have ha' : T a ∧ ¬ S a := ha
    have hT : T a := ha'.1
    rw [← h] at hT
    rcases hT with hSA | hB
    · exact absurd hSA.1 ha'.2
    · exact hB

/-- **Prop 7.1 (Delta normal form).** The canonical delta `(D⁻, D⁺)` reconstructs
    the target and is the least pair to do so — so mutation over a fact-set model
    has a unique normal form, computed by subtraction. -/
theorem delta_normal_form (S T : Set' α) :
    Set'.union (Set'.diff S (Dminus S T)) (Dplus S T) = T
      ∧ (∀ A B, Set'.union (Set'.diff S A) B = T →
            Set'.Subset (Dminus S T) A ∧ Set'.Subset (Dplus S T) B) :=
  ⟨delta_apply S T, fun A B h => delta_least S T A B h⟩

end FirstPrinciples
