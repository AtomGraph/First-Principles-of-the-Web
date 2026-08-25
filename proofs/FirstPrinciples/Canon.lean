/-
  First Principles of the Web — Prop 6.1 (`canon` exists), ground core.
  Self-contained: Lean 4 core only (no Mathlib).

  `canon` needs three properties: deterministic, lossless, structure-free.
  The proof is "sort lexicographically". Here: given an injective sort key on
  facts (the key "built from names" — Chapter 6), sorting with deduplication
  yields a canonical list, and the three properties are theorems:

    * structure-free — the output is strictly key-sorted (`canonL_sorted`):
      block order is determined by the facts alone and can encode no choice;
    * lossless — the output's members are exactly the input's (`canonL_mem`);
    * deterministic — the output depends only on the fact-SET: any two
      enumerations, in any arrival order, with any duplication, canonicalize
      identically (`canonL_canonical`). This is Chapter 6's law "canon's sort
      is an accident of spelling and carries no meaning to preserve", run in
      reverse: because the key means nothing, the output means nothing beyond
      its members.

  SCOPE: ground states — the key is total on named facts. Unnamed entities
  offer no key; the deterministic labeling that manufactures the missing names
  is RDFC-1.0 (2024), an external spec the book cites, outside this
  formalization by the README's scope table.
-/

universe u

namespace FirstPrinciples
namespace Canon

variable {α : Type u} (key : α → Nat)

/-- Insert into a strictly-key-sorted list, deduplicating on key collision
    (with an injective key, collision means the same fact). -/
def insertK (a : α) : List α → List α
  | [] => [a]
  | b :: t =>
    if key a < key b then a :: b :: t
    else if key a = key b then b :: t
    else b :: insertK a t

/-- The canonicalization: fold every fact in. -/
def canonL (l : List α) : List α := l.foldr (insertK key) []

/-- Strictly sorted by key: each head's key is below every later key. -/
inductive KSorted : List α → Prop where
  | nil : KSorted []
  | cons {a : α} {t : List α} :
      (∀ x ∈ t, key a < key x) → KSorted t → KSorted (a :: t)

/-- Membership in an insertion (lossless, one step). -/
theorem mem_insertK (hkey : ∀ a b : α, key a = key b → a = b) (a : α) (l : List α) :
    ∀ x, x ∈ insertK key a l ↔ x = a ∨ x ∈ l := by
  induction l with
  | nil =>
    intro x
    show x ∈ [a] ↔ x = a ∨ x ∈ ([] : List α)
    simp
  | cons b t ih =>
    intro x
    show x ∈ (if key a < key b then a :: b :: t
      else if key a = key b then b :: t
      else b :: insertK key a t) ↔ x = a ∨ x ∈ b :: t
    by_cases h1 : key a < key b
    · rw [if_pos h1]
      simp [List.mem_cons]
    · rw [if_neg h1]
      by_cases h2 : key a = key b
      · rw [if_pos h2]
        have hab : a = b := hkey a b h2
        constructor
        · exact Or.inr
        · rintro (rfl | hx)
          · rw [hab]; exact List.mem_cons_self _ _
          · exact hx
      · rw [if_neg h2]
        rw [List.mem_cons, ih x, List.mem_cons]
        constructor
        · rintro (rfl | rfl | hx)
          · exact Or.inr (Or.inl rfl)
          · exact Or.inl rfl
          · exact Or.inr (Or.inr hx)
        · rintro (rfl | rfl | hx)
          · exact Or.inr (Or.inl rfl)
          · exact Or.inl rfl
          · exact Or.inr (Or.inr hx)

/-- Insertion preserves strict sortedness. -/
theorem insertK_sorted (hkey : ∀ a b : α, key a = key b → a = b)
    (a : α) (l : List α) (h : KSorted key l) :
    KSorted key (insertK key a l) := by
  induction l with
  | nil => exact KSorted.cons (by intro x hx; exact absurd hx (by simp)) KSorted.nil
  | cons b t ih =>
    cases h with
    | cons hb ht =>
      show KSorted key (if key a < key b then a :: b :: t
        else if key a = key b then b :: t
        else b :: insertK key a t)
      by_cases h1 : key a < key b
      · rw [if_pos h1]
        refine KSorted.cons ?_ (KSorted.cons hb ht)
        intro x hx
        rcases List.mem_cons.mp hx with rfl | hx'
        · exact h1
        · exact Nat.lt_trans h1 (hb x hx')
      · rw [if_neg h1]
        by_cases h2 : key a = key b
        · rw [if_pos h2]
          exact KSorted.cons hb ht
        · rw [if_neg h2]
          have hba : key b < key a :=
            Nat.lt_of_le_of_ne (Nat.le_of_not_lt h1) (fun h => h2 h.symm)
          refine KSorted.cons ?_ (ih ht)
          intro x hx
          rcases (mem_insertK key hkey a t x).mp hx with rfl | hx'
          · exact hba
          · exact hb x hx'

/-- Two strictly-key-sorted lists with the same members are the same list —
    the canonical form is unique. -/
theorem ksorted_ext : ∀ (l₁ l₂ : List α), KSorted key l₁ → KSorted key l₂ →
    (∀ x, x ∈ l₁ ↔ x ∈ l₂) → l₁ = l₂ := by
  intro l₁
  induction l₁ with
  | nil =>
    intro l₂ _ _ hm
    cases l₂ with
    | nil => rfl
    | cons b t₂ => exact absurd ((hm b).mpr (List.mem_cons_self _ _)) (by simp)
  | cons a t ih =>
    intro l₂ h₁ h₂ hm
    cases l₂ with
    | nil => exact absurd ((hm a).mp (List.mem_cons_self _ _)) (by simp)
    | cons b t₂ =>
      cases h₁ with
      | cons ha ht =>
        cases h₂ with
        | cons hb ht₂ =>
          have hab : a = b := by
            rcases List.mem_cons.mp ((hm a).mp (List.mem_cons_self _ _)) with h | h
            · exact h
            · rcases List.mem_cons.mp ((hm b).mpr (List.mem_cons_self _ _)) with h' | h'
              · exact h'.symm
              · exact absurd (Nat.lt_trans (ha b h') (hb a h)) (Nat.lt_irrefl _)
          subst hab
          have htails : ∀ x, x ∈ t ↔ x ∈ t₂ := by
            intro x
            constructor
            · intro hx
              rcases List.mem_cons.mp ((hm x).mp (List.mem_cons_of_mem a hx)) with rfl | h
              · exact absurd (ha x hx) (Nat.lt_irrefl _)
              · exact h
            · intro hx
              rcases List.mem_cons.mp ((hm x).mpr (List.mem_cons_of_mem a hx)) with rfl | h
              · exact absurd (hb x hx) (Nat.lt_irrefl _)
              · exact h
          rw [ih t₂ ht ht₂ htails]

/-- The canonicalization is sorted (structure-free: block order is the key's,
    and the key means nothing). -/
theorem canonL_sorted (hkey : ∀ a b : α, key a = key b → a = b) (l : List α) :
    KSorted key (canonL key l) := by
  induction l with
  | nil => exact KSorted.nil
  | cons a t ih => exact insertK_sorted key hkey a (canonL key t) ih

/-- The canonicalization is lossless: members in, members out. -/
theorem canonL_mem (hkey : ∀ a b : α, key a = key b → a = b) (l : List α) :
    ∀ x, x ∈ canonL key l ↔ x ∈ l := by
  induction l with
  | nil => intro x; exact Iff.rfl
  | cons a t ih =>
    intro x
    show x ∈ insertK key a (canonL key t) ↔ x ∈ a :: t
    rw [mem_insertK key hkey, ih x, List.mem_cons]

/-- **Prop 6.1, deterministic clause.** The canonical form depends only on the
    fact-set: any two enumerations with the same members — any arrival order,
    any duplication — canonicalize identically. -/
theorem canonL_canonical (hkey : ∀ a b : α, key a = key b → a = b)
    (l₁ l₂ : List α) (hm : ∀ x, x ∈ l₁ ↔ x ∈ l₂) :
    canonL key l₁ = canonL key l₂ :=
  ksorted_ext key (canonL key l₁) (canonL key l₂)
    (canonL_sorted key hkey l₁) (canonL_sorted key hkey l₂)
    (fun x => by rw [canonL_mem key hkey, canonL_mem key hkey]; exact hm x)

/-- **Prop 6.1 (`canon` exists), ground core.** Given an injective sort key on
    facts, a `canon` with all three properties exists: structure-free (sorted
    by a meaningless key), lossless (same members), deterministic (a function
    of the fact-set alone). -/
theorem canon_exists (hkey : ∀ a b : α, key a = key b → a = b) :
    (∀ l : List α, KSorted key (canonL key l))
      ∧ (∀ (l : List α) (x : α), x ∈ canonL key l ↔ x ∈ l)
      ∧ (∀ l₁ l₂ : List α, (∀ x, x ∈ l₁ ↔ x ∈ l₂) → canonL key l₁ = canonL key l₂) :=
  ⟨canonL_sorted key hkey, canonL_mem key hkey, canonL_canonical key hkey⟩

end Canon
end FirstPrinciples
