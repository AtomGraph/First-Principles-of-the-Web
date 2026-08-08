# Mechanized proofs — Appendix B

Machine-checked companion to Appendix B of *First Principles of the Web*.
**Lean 4 core only — no Mathlib** (deliberate: it keeps the dependency light and
forces every ingredient of the argument to be explicit).

## Build

```sh
cd proofs
lake build
```

Requires only `elan` (installs the pinned `leanprover/lean4:v4.15.0` on first
build). No network dependencies beyond the toolchain.

## What is mechanized

`FirstPrinciples/StateModel.lean`. A `StateModel` bundles the merge laws that are
algebraic identities (B-2b order-freedom, B-2c idempotence, and `∅` as identity),
making `(M, ⊕, ∅)` a bounded join-semilattice with induced order
`a ≤ b := a ⊕ b = b`. The two remaining obligations of B-2d (atomicity) are
isolated as named predicates `NoEmergence` and `Atomistic` and taken as explicit
hypotheses — see "what the formalization clarified" below.

### Lemma B.1 (Representation), finite

| Lean name | Appendix B claim | status |
|---|---|---|
| `le_refl`, `le_trans`, `le_antisymm` | `≤` is a partial order | theorem (semilattice only) |
| `empty_le` | `∅` is least | theorem |
| `le_merge_left/right` | monotonicity `s ≤ s ⊕ t` | theorem |
| `atomsBelow_empty` | `∅` carries no atoms (bottom preserved) | theorem |
| `atomsBelow_merge_of_left/right` | homomorphism, **⊇** inclusion | theorem (no axiom) |
| `NoEmergence` | B-2d, "no emergence" (⊆ inclusion) | isolated axiom |
| `Atomistic` | B-2d, "every state is the join of its atoms" | isolated axiom |
| `atomsBelow_merge` | homomorphism `atoms(s⊕t) = atoms s ∪ atoms t` | theorem, uses `NoEmergence` |
| `atoms_injective` | atom map is injective | theorem, uses `Atomistic` |
| `representation_embedding` | **B.1 embedding half**, assembled | theorem — **no axioms** |
| `atomsBelow_atom` | the only atom below an atom is itself | theorem |
| `joinList`, `atomsBelow_joinList` | every finite atom-set is realized (**surjectivity**) | theorem, uses `NoEmergence` |
| `representation_finite` | **B.1 (finite)**: atom map is a `⊕`→`∪` bijection onto finite atom-sets | theorem |

### B.4 (independence) — one countermodel so far

| Lean name | Appendix B claim | status |
|---|---|---|
| `lmax` = `(ℕ, max, 0)` | a `StateModel` (bounded join-semilattice) | def |
| `lmax_isAtom`, `lmax_atomsBelow` | its only atom is `1`; atoms characterized | theorem |
| `atomistic_independent` | **`Atomistic` is not derivable** from the semilattice laws | theorem |

`representation_embedding` `#print axioms` cleanly (**no axioms at all**);
`representation_finite`/`atomsBelow_joinList` depend only on `propext`;
`atomistic_independent` on the three standard Lean axioms. None on `sorryAx`.

### What the formalization clarified

Isolating B-2d into two named predicates made two things precise that the prose
states only in passing:

1. The homomorphism's **⊇** inclusion is *derivable* from the semilattice laws
   (monotonicity), so only the **⊆** inclusion ("no emergence") is genuine
   axiomatic content — matching Appendix B.4's independence result.
2. `atomistic_independent` proves that `Atomistic` really is a separate axiom
   (the `(ℕ, max)` model satisfies every semilattice law yet fails it), so
   Lemma B.1 *must* assume it. The formalization thus answers "did you just
   assume what you needed?" — yes, necessarily, and here is the witness.

---

## Scope: what can and cannot be mechanized

"Can Lean formalize all the book's propositions?" splits by the **kind** of
statement, not by Lean's power. The book's own trichotomy — spec definition,
derived proposition, checkable observation — plus the one flagged exception maps
almost exactly onto Lean's reach: **the derived propositions are formalizable;
essentially nothing else is**, because the rest are not mathematical claims.

| Result | Lean verdict |
|---|---|
| Union law (5.1) / B.1 | ✅ **done** (embedding + finite); full powerset (B-2e) remains |
| Arity (5.2) / B.2 | ✅ formalizable — the *hardest*; faithfulness of B-0 ("self-interpreting atom") carries the weight |
| Uniqueness (5.4) / B.3 | ✅ formalizable (assembles B.1 + B.2) |
| Independence of the laws / B.4 | ✅ formalizable — one of five countermodels done (`atomistic_independent`) |
| Analysis theorem (4.4) / B.5 | ✅ core (finite dependence ⇒ 3-stage S1 factorization); S2–S4 are the definitional "lift" |
| Independent evolution (4.5) / B.6 | ✅ formalizable (dependency-triangle argument) |
| Delta normal form (7.1) | ✅ trivial (pure set algebra) |
| Forms / one-algebra / five moves (7.2–7.4) | ✅ formalizable (mechanical) |
| Erasure → quads (9.2) | ✅ formalizable |
| Federation closure / B.9 | ✅ formalizable (set-theoretic) |
| Nothing else to vary (19.1) | ✅ trivial corollary |
| Homomorphism (8.1) / B.7 | ⚠️ **partial** — needs a Lean model of SPARQL §18's denotational defs; proves correspondence to *that model*, not to Saxon |
| Synthesis + genericity (8.2) / B.8 | ⚠️ **partial** — genericity/free-theorem core formalizable; "XSLT is Turing-complete on trees" stays a cited external fact |
| `canon` exists (6.1) | ✅ ground states; ❌ blank-node RDFC-1.0 (enormous external spec) |
| Bill for anonymity (9.1) | ✅ algebraic core; ❌ coNP-completeness is a cited complexity result |
| **Transposition Thesis** | ❌ **never** — the bridge from the world to the axioms; can only be *assumed* |
| **R1–R4 requirements** | ❌ become axioms/hypotheses, not theorems |
| **All of Part IV (the audit)** | ❌ empirical — a Lean toy model of a competitor proves things about the *model*, relocating the model-vs-world gap, not closing it |
| Props 1.2–1.3; Table 8.1 "this *is* RDF" | ❌ empirical / a modeling identification, not a theorem |

**The load-bearing point.** Mechanizing the book does **not** prove its thesis;
it proves the **conditional skeleton** — *if the requirements hold (as axioms),
the stack is forced and unique*. That is exactly what `StateModel` encodes: the
merge laws go in as axioms, and Lean checks everything downstream. What Lean can
**never** do is discharge those axioms, because their justification is the
**Transposition Thesis**, and that is unprovable **in the way the Church–Turing
thesis is unprovable**: it equates an informal target ("the web enforces these
invariants") with a formal object (the merge laws), and adequacy of a
formalization to an informal subject cannot be proved from inside the formalism —
the proof would need a formal statement of the informal subject, which is the
very thing at issue. It is corroborated (independently, the CRDT/CALM literature
derives the same laws) and consequence-tested (its downstream predictions held),
never proved.

So the maximal sensible project is **a complete, machine-checked Appendix B** —
which upgrades rigor from **A– to "A, modulo one openly-declared axiom"**, and
not one notch further. Formalizing Parts I / III-reveal / IV / V-economics / VI
would be a category error, not a bigger proof.

## Deferred (next commits)

- **B.1, full powerset** — the jump from finite atom-sets to `𝒫(A)` via **B-2e**
  (accumulation / directed joins).
- **B.4, remaining countermodels** — drop B-2a (schema-indexed union), B-2b
  (event logs), B-2c (multisets), B-2e (finite subsets); `atomistic_independent`
  is the B-2d case.
- **B.2 / B.3** — arity-minimality forces `I × I × (I ∪ V)`; uniqueness up to
  reading-preserving isomorphism. (Highest-value next target: the book's
  most-attacked result.)
- **B.5** — the analysis theorem (finite dependence ⇒ three-stage S1 factorization).
- **B.6 / B.9** — independent evolution; federation closure.
- **B.7 / B.8** — partial only, against a Lean model of the SPARQL denotational
  fragment (see scope table).
