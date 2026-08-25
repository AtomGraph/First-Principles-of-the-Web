/-
  First Principles of the Web — B.2's trap: the Löwenheim–Quine escape, closed.
  Self-contained: Lean 4 core only (no Mathlib).

  B.2 states the trap in the open: "the insufficiency of pairs is
  operation-relative, and stated without qualification it is false. Löwenheim
  (1915) and Quine (1954) proved that under unrestricted set-theoretic pairing,
  every relation of every arity reduces to dyads… What blocks the push here is
  B-0 and B-2d: the pairing reduction manufactures atoms that no fixed
  universal reading interprets alone, pairs that mean only via their
  neighbors."

  The Peircean literature calls the analogous restriction gerrymandered
  (Skidmore 1971; Koshkin 2022) — drawn where it must be for triads to win.
  The book's answer is that the restriction is the Transposition Thesis's
  fourth row, a deployed web invariant adopted for reasons that predate any
  question about arity. A formalization that only proved "pairs lose" would be
  a strawman and would deserve the accusation. So this file proves BOTH halves:

    * `chain_injective` — the pairing reduction WORKS. The gadget's atom-set
      determines the fact: read the whole arrangement and nothing is lost.
      Quine is not refuted; he is located.
    * `no_atom_says` — and it says nothing atom by atom: no pair-atom's reading
      is a fact of three distinct names (pigeonhole, `arity2_insufficient`).
    * `no_dyadic_state` — so under B-2d, which says a state says exactly what
      its atoms say, no state of pair-atoms asserts such a fact, however many
      fresh cells it mints.

  The escape needs meaning to live in arrangement. That is exactly what the
  web's fourth rule forbids, and the restriction is therefore not drawn to make
  triads win: it was drawn by aggregators consuming content outside its
  original arrangement, long before anyone asked about arity.
-/

import FirstPrinciples.Arity
import FirstPrinciples.Delta

universe u

namespace FirstPrinciples
namespace Gadget

open Arity (Fact factMem)

variable {Name : Type u}

/-- A **dyadic scheme**: atoms are pairs, B-0 gives each atom a fixed universal
    reading as a fact, and B-3 makes that reading self-contained — the fact's
    names are the atom's own names. -/
structure DyadicScheme (Name : Type u) where
  rd : Name × Name → Fact Name
  self_contained : ∀ p y, factMem (rd p) y → y = p.1 ∨ y = p.2

/-- **No pair-atom says a three-name fact.** Two slots, three distinct names:
    `arity2_insufficient`, applied to the scheme's reading. -/
theorem no_atom_says (D : DyadicScheme Name) {A B C : Name}
    (hAB : A ≠ B) (hAC : A ≠ C) (hBC : B ≠ C) (p : Name × Name) :
    D.rd p ≠ (A, B, C) :=
  Arity.arity2_insufficient D.rd D.self_contained hAB hAC hBC p

/-- **B-2d, as the clause that does the blocking.** A state says exactly what
    its atoms say: a fact holds of a state only if some atom of that state says
    it. ("If a combination of states could mean more than its facts together,
    the surplus would live in an arrangement.") -/
def SaysOnlyViaAtoms (D : DyadicScheme Name)
    (says : Set' (Name × Name) → Fact Name → Prop) : Prop :=
  ∀ S φ, says S φ → ∃ p, S p ∧ D.rd p = φ

/-- **The escape is closed by B-2d, not by preference.** Under atomicity, no
    state of pair-atoms asserts a fact of three distinct names — no matter how
    many fresh cells the encoding mints, and no matter how it arranges them. -/
theorem no_dyadic_state (D : DyadicScheme Name)
    (says : Set' (Name × Name) → Fact Name → Prop)
    (hB2d : SaysOnlyViaAtoms D says) {A B C : Name}
    (hAB : A ≠ B) (hAC : A ≠ C) (hBC : B ≠ C) (S : Set' (Name × Name)) :
    ¬ says S (A, B, C) := by
  intro h
  obtain ⟨p, _, hp⟩ := hB2d S _ h
  exact no_atom_says D hAB hAC hBC p hp

/-! ### The other half: the reduction really does work, as arrangement

Quine's construction, in atom form: mint fresh cells and chain them, one cell
per position, the order carried by the chain. Nothing about it is wrong — as
long as you are allowed to read the whole chain. -/

/-- The pairing reduction of a fact, with three fresh cells. -/
def chain (c₁ c₂ c₃ : Name) (f : Fact Name) : Set' (Name × Name) :=
  fun q => q = (c₁, f.1) ∨ q = (c₁, c₂) ∨ q = (c₂, f.2.1)
    ∨ q = (c₂, c₃) ∨ q = (c₃, f.2.2)

/-- Cells are fresh for `f`: no name of the fact is one of the cells. -/
def Fresh (c₁ c₂ c₃ : Name) (f : Fact Name) : Prop :=
  ∀ y, factMem f y → y ≠ c₁ ∧ y ≠ c₂ ∧ y ≠ c₃

/-- **The reduction is faithful as arrangement.** With distinct fresh cells,
    the gadget's atom-set determines the fact: reading the whole chain loses
    nothing. This is the half that makes Löwenheim–Quine a theorem rather than
    an error — and the half a strawman formalization would omit. -/
theorem chain_injective {c₁ c₂ c₃ : Name} (h12 : c₁ ≠ c₂) (h13 : c₁ ≠ c₃)
    (h23 : c₂ ≠ c₃) {f f' : Fact Name}
    (hf : Fresh c₁ c₂ c₃ f) (hf' : Fresh c₁ c₂ c₃ f')
    (h : chain c₁ c₂ c₃ f = chain c₁ c₂ c₃ f') : f = f' := by
  have mem_f : ∀ q, chain c₁ c₂ c₃ f q → chain c₁ c₂ c₃ f' q :=
    fun q hq => Eq.mp (congrFun h q) hq
  -- position 1
  have e1 : f.1 = f'.1 := by
    have h1 : chain c₁ c₂ c₃ f (c₁, f.1) := Or.inl rfl
    rcases mem_f _ h1 with e | e | e | e | e
    · exact congrArg Prod.snd e
    · exact absurd (congrArg Prod.snd e) (hf f.1 (Or.inl rfl)).2.1
    · exact absurd (congrArg Prod.fst e) h12
    · exact absurd (congrArg Prod.fst e) h12
    · exact absurd (congrArg Prod.fst e) h13
  -- position 2
  have e2 : f.2.1 = f'.2.1 := by
    have h1 : chain c₁ c₂ c₃ f (c₂, f.2.1) := Or.inr (Or.inr (Or.inl rfl))
    rcases mem_f _ h1 with e | e | e | e | e
    · exact absurd (congrArg Prod.fst e) (fun hc => h12 hc.symm)
    · exact absurd (congrArg Prod.fst e) (fun hc => h12 hc.symm)
    · have h' := congrArg Prod.snd e; exact h'
    · have h' := congrArg Prod.snd e
      exact absurd h' (hf f.2.1 (Or.inr (Or.inl rfl))).2.2
    · exact absurd (congrArg Prod.fst e) h23
  -- position 3
  have e3 : f.2.2 = f'.2.2 := by
    have h1 : chain c₁ c₂ c₃ f (c₃, f.2.2) := Or.inr (Or.inr (Or.inr (Or.inr rfl)))
    rcases mem_f _ h1 with e | e | e | e | e
    · exact absurd (congrArg Prod.fst e) (fun hc => h13 hc.symm)
    · exact absurd (congrArg Prod.fst e) (fun hc => h13 hc.symm)
    · exact absurd (congrArg Prod.fst e) (fun hc => h23 hc.symm)
    · exact absurd (congrArg Prod.fst e) (fun hc => h23 hc.symm)
    · have h' := congrArg Prod.snd e; exact h'
  obtain ⟨a, b, c⟩ := f
  obtain ⟨a', b', c'⟩ := f'
  simp only at e1 e2 e3
  rw [e1, e2, e3]

/-- **The trap, and its exit, in one statement.** For a fact of three distinct
    names: the pairing reduction determines it *as arrangement* (first clause),
    and no atom of the reduction says it (second clause). So the reduction
    survives exactly where meaning may live in arrangement, and dies where the
    web's fourth rule forbids that. The restriction is not gerrymandered: it is
    the invariant aggregators have enforced on the document web all along. -/
theorem gadget_escape_closed (D : DyadicScheme Name) {c₁ c₂ c₃ : Name}
    (h12 : c₁ ≠ c₂) (h13 : c₁ ≠ c₃) (h23 : c₂ ≠ c₃)
    {A B C : Name} (hAB : A ≠ B) (hAC : A ≠ C) (hBC : B ≠ C) :
    (∀ f f' : Fact Name, Fresh c₁ c₂ c₃ f → Fresh c₁ c₂ c₃ f' →
        chain c₁ c₂ c₃ f = chain c₁ c₂ c₃ f' → f = f')
      ∧ (∀ p : Name × Name, D.rd p ≠ (A, B, C)) :=
  ⟨fun _ _ hf hf' h => chain_injective h12 h13 h23 hf hf' h,
   no_atom_says D hAB hAC hBC⟩

end Gadget
end FirstPrinciples
