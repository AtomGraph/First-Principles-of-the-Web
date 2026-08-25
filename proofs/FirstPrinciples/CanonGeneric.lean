/-
  First Principles of the Web — `canon` under renaming (B.8's tree clause).
  Self-contained: Lean 4 core only (no Mathlib).

  B.8 defines the action of a renaming on a canonical tree with one clause
  Chapter 6's law forces: "on a canonical tree the action is
  rewrite-then-recanonicalize, `ρ · canon(S) = canon(ρS)`, because `canon`'s
  sort is an accident of spelling and carries no meaning to preserve. Without
  the clause even the identity transform would fail the equation below, tripped
  by block order alone."

  Genericity.lean took the output-side action abstractly (`actOut`), which was
  honest but left the clause unchecked. Now that Canon.lean exists, the concrete
  `canon` discharges it:

    * `canon_commutes` — rewriting then recanonicalizing is the same as
      recanonicalizing the rewritten canonical form. Proved for ANY relabeling,
      not only renamings, because it follows from `canon`'s determinism: the
      output depends on the fact-set alone.
    * `canon_renaming_commutes` — the same equation with the book's own action,
      `ρ` acting on facts.
    * `canon_needs_recanonicalization` — and the clause is not decoration: a
      concrete relabeling where naive rewriting breaks the sort, so the
      recanonicalization step is load-bearing exactly as the book says.
-/

import FirstPrinciples.Canon
import FirstPrinciples.Genericity

universe u

namespace FirstPrinciples
namespace CanonGeneric

open Canon (canonL canonL_mem canonL_canonical)

/-- **`canon` commutes with relabeling, after recanonicalization.** Because the
    canonical form depends only on the fact-set (`canonL_canonical`), rewriting
    names before or after canonicalizing gives the same answer — provided the
    result is re-sorted. This is B.8's clause, for any relabeling `g`. -/
theorem canon_commutes {α : Type u} (key : α → Nat)
    (hkey : ∀ a b : α, key a = key b → a = b) (g : α → α) (l : List α) :
    canonL key (l.map g) = canonL key ((canonL key l).map g) := by
  refine canonL_canonical key hkey _ _ (fun x => ?_)
  constructor
  · intro hx
    obtain ⟨y, hy, rfl⟩ := List.mem_map.mp hx
    exact List.mem_map.mpr ⟨y, (canonL_mem key hkey l y).mpr hy, rfl⟩
  · intro hx
    obtain ⟨y, hy, rfl⟩ := List.mem_map.mp hx
    exact List.mem_map.mpr ⟨y, (canonL_mem key hkey l y).mp hy, rfl⟩

/-- **B.8's equation, with the book's own action.** For a renaming `ρ` acting on
    facts, `ρ · canon(S) = canon(ρS)` where `ρ ·` is rewrite-then-recanonicalize.
    The clause Genericity.lean assumed abstractly is now proved for `canon`. -/
theorem canon_renaming_commutes {I V : Type u} {F : Set' I}
    (ρ : Genericity.Renaming I F)
    (key : Homomorphism.DFact I V → Nat)
    (hkey : ∀ a b, key a = key b → a = b)
    (l : List (Homomorphism.DFact I V)) :
    canonL key (l.map (Genericity.actFact ρ))
      = canonL key ((canonL key l).map (Genericity.actFact ρ)) :=
  canon_commutes key hkey (Genericity.actFact ρ) l

/-! ### The clause is load-bearing

"Without the clause even the identity transform would fail the equation below,
tripped by block order alone." Here is the trip, concretely: relabel `1 ↦ 3`
and the canonical order changes, so rewriting a canonical form without
re-sorting leaves an uncanonical one. -/

/-- The transposition `1 ↔ 3` on names-as-numbers. -/
def swap13 : Nat → Nat := fun n => if n = 1 then 3 else if n = 3 then 1 else n

/-- **Recanonicalization is required, not decorative.** Rewriting a canonical
    form can leave it unsorted, so `ρ · canon(S) = canon(ρS)` holds only with
    the recanonicalizing action. -/
theorem canon_needs_recanonicalization :
    ∃ (g : Nat → Nat) (l : List Nat),
      canonL id (l.map g) ≠ (canonL id l).map g :=
  ⟨swap13, [1, 2], by decide⟩

end CanonGeneric
end FirstPrinciples
