/-
  First Principles of the Web — Prop 9.1 (the bill for anonymity, algebraic
  core) and Prop 9.2 (the erasure argument → quads).
  Self-contained: Lean 4 core only (no Mathlib).

  ## Prop 9.2 — erasure, and the minimal repair

  "Union erases contribution: a set union keeps no record of which side an
  element came from. So within 𝒫(Fact), 'who asserted this atom' is
  unrecoverable by construction." Mechanized as `attribution_erased`: two
  sources publishing the same fact publish the SAME state, so no function of
  the state can tell them apart — the impossibility is proved, not asserted.

  Then the repair: retype the atom as a pair (source, fact). `attrOf` recovers
  the asserters, `attrOf_merge` shows attribution is itself a ⊕→∪ homomorphism
  (so attribution composes the way state does), and `quad_merge_is_union` notes
  merge is still plain union on the retyped atom — "rerun B.1–B.3 over the
  retyped atom", which needs no new argument precisely because the carrier is
  again a powerset.

  ## Prop 9.1 — the bill, algebraically

  A faithful miniature of the doubling phenomenon, not a formalization of RDF
  semantics: a state is a ground set plus a count of existential blocks, and
  standardizing apart on merge ADDS the counts. Then:

    * on ground states merge is set union on the nose, and idempotence holds
      syntactically (`ground_idem`);
    * with existentials idempotence survives up to equivalence
      (`blank_idem_up_to_equiv`) and fails on identity (`blank_idem_fails`) —
      "B-2c survives semantically and fails syntactically", exactly.

  The two computations that restore identity (canonical labeling, redundancy
  elimination — coNP-complete in general) stay cited external results, per the
  README scope table. What is proved here is why the bill exists at all.
-/

import FirstPrinciples.Delta

universe u

namespace FirstPrinciples
namespace Quads

variable {Src F : Type u}

/-! ### Prop 9.2 — union erases contribution -/

/-- Publishing into `𝒫(Fact)`: a source's assertion of a fact is just the fact.
    The source has nowhere to go — that is the point. -/
def publish (f : F) : Set' F := fun g => g = f

/-- **The erasure argument (Prop 9.2).** No function of a triple-state can
    recover who asserted a fact: two distinct sources publishing the same fact
    publish literally the same state, so any attribution would have to return
    both answers. Attribution is unrecoverable *by construction*, which is why
    R4 needs a new position rather than a cleverer query. -/
theorem attribution_erased (a b : Src) (f : F)
    (attr : Set' F → F → Src)
    (hcorrect : ∀ (s : Src) (g : F), attr (publish g) g = s) :
    a = b := by
  have ha : attr (publish f) f = a := hcorrect a f
  have hb : attr (publish f) f = b := hcorrect b f
  exact ha.symm.trans hb

/-! ### The repair: quads -/

/-- The retyped atom: a pair (source, fact) — `I × Fact`. -/
abbrev Quad (Src F : Type u) := Src × F

/-- The asserters of a fact in a quad-state. -/
def attrOf (S : Set' (Quad Src F)) (f : F) : Set' Src := fun a => S (a, f)

/-- **Attribution is recovered**: in `𝒫(I × Fact)`, distinct sources asserting
    the same fact are distinguishable — the state records both, separately. -/
theorem attribution_recovered (a b : Src) (f : F) :
    attrOf (fun q => q = (a, f) ∨ q = (b, f)) f = fun s => s = a ∨ s = b := by
  apply Set'.ext
  intro s
  constructor
  · rintro (h | h)
    · exact Or.inl (congrArg Prod.fst h)
    · exact Or.inr (congrArg Prod.fst h)
  · rintro (rfl | rfl)
    · exact Or.inl rfl
    · exact Or.inr rfl

/-- **Attribution composes**: the asserters of a fact in a merge are the union
    of the asserters on each side. So attribution is itself a ⊕→∪ homomorphism
    — it composes the way state does, which is what keeps R4 compatible with
    R2 rather than in tension with it. -/
theorem attrOf_merge (S T : Set' (Quad Src F)) (f : F) :
    attrOf (Set'.union S T) f = Set'.union (attrOf S f) (attrOf T f) := rfl

/-- **Merge is still union** on the retyped atom: the carrier is again a
    powerset, so B.1–B.3 rerun verbatim — the fourth position costs a position,
    never a law. -/
theorem quad_merge_is_union (S T : Set' (Quad Src F)) :
    Set'.union S T = fun q => S q ∨ T q := rfl

/-- Nothing is lost either: the plain fact-state is `attrOf`'s reduct, so the
    quad model refines the triple model rather than replacing it. -/
theorem quad_projects_to_facts (S : Set' (Quad Src F)) (f : F) :
    (∃ a, attrOf S f a) ↔ ∃ a, S (a, f) := Iff.rfl

/-! ### Prop 9.1 — the bill for anonymity -/

/-- A state with existentials: ground facts, plus a count of anonymous blocks.
    Merging standardizes apart, so the counts ADD — "s ⊕ s carries two copies
    of each existential". -/
structure EState (F : Type u) where
  ground : Set' F
  blanks : Nat

/-- Merge: union the ground part, add the existential copies. -/
def emerge (s t : EState F) : EState F :=
  ⟨Set'.union s.ground t.ground, s.blanks + t.blanks⟩

/-- Entailment-equivalence: same ground facts, and the same existential content
    — any positive number of copies of an existential asserts what one copy
    asserts, which is exactly why equivalence survives doubling. -/
def Equiv (s t : EState F) : Prop :=
  s.ground = t.ground ∧ (s.blanks = 0 ↔ t.blanks = 0)

/-- **Over ground facts, merge is plain set union.** -/
theorem ground_merge_is_union (s t : EState F) (hs : s.blanks = 0) (ht : t.blanks = 0) :
    emerge s t = ⟨Set'.union s.ground t.ground, 0⟩ := by
  show EState.mk (Set'.union s.ground t.ground) (s.blanks + t.blanks) = _
  rw [hs, ht]

/-- **On ground states idempotence holds on the nose** (B-2c, syntactically). -/
theorem ground_idem (s : EState F) (hs : s.blanks = 0) : emerge s s = s := by
  obtain ⟨g, n⟩ := s
  show EState.mk (Set'.union g g) (n + n) = ⟨g, n⟩
  have hn : n = 0 := hs
  rw [hn]
  have hg : Set'.union g g = g := Set'.ext fun _ => ⟨fun h => h.elim id id, Or.inl⟩
  rw [hg]

/-- **With blank nodes, idempotence survives up to equivalence.** -/
theorem blank_idem_up_to_equiv (s : EState F) : Equiv (emerge s s) s := by
  refine ⟨Set'.ext fun _ => ⟨fun h => h.elim id id, Or.inl⟩, ?_⟩
  show s.blanks + s.blanks = 0 ↔ s.blanks = 0
  omega

/-- **…and only up to equivalence: identity fails.** A state with one
    existential merged with itself carries two — it asserts nothing new, yet it
    is not the same set of atoms. That gap is the bill. -/
theorem blank_idem_fails (g : Set' F) :
    emerge ⟨g, 1⟩ ⟨g, 1⟩ ≠ ⟨g, 1⟩ := by
  intro h
  have : (1 : Nat) + 1 = 1 := congrArg EState.blanks h
  omega

/-- **Prop 9.1 (the bill), algebraic core.** Ground: union and idempotence on
    the nose. Anonymous: idempotence up to equivalence, never identity. -/
theorem bill_for_anonymity :
    (∀ s : EState F, s.blanks = 0 → emerge s s = s)
      ∧ (∀ s : EState F, Equiv (emerge s s) s)
      ∧ (∀ g : Set' F, emerge ⟨g, 1⟩ ⟨g, 1⟩ ≠ ⟨g, 1⟩) :=
  ⟨ground_idem, blank_idem_up_to_equiv, blank_idem_fails⟩

end Quads
end FirstPrinciples
