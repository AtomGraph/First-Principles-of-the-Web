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

The build itself enforces the integrity claims: `FirstPrinciples/Integrity.lean`
pins every key theorem's axiom footprint with `#guard_msgs` around
`#print axioms`, so a `sorry` (surfacing as `sorryAx`) or a new axiom anywhere
fails the build. CI (`.github/workflows/proofs.yml`) runs `lake build` on every
change under `proofs/`.

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

### Prop 7.1 (Delta normal form) — the write side

`FirstPrinciples/Delta.lean`. Over a set-of-facts model, every state change
factors as a *least* pair of sets — a delta. A minimal set layer
(`Set' α := α → Prop`) keeps it Mathlib-free.

| Lean name | Prop 7.1 claim | status |
|---|---|---|
| `delta_apply` | `(S ∖ D⁻) ∪ D⁺ = T` — the canonical delta reconstructs the target | theorem |
| `delta_least` | any `(A,B)` with `(S ∖ A) ∪ B = T` has `D⁻ ⊆ A`, `D⁺ ⊆ B` | theorem |
| `delta_normal_form` | **Prop 7.1**: the delta is the unique least normal form | theorem |

"Two sets. That is the entire theory of mutation over a fact-set model." — now
exact: mutation's normal form is computed by subtraction.

### B.9 (Federation closure)

`FirstPrinciples/Federation.lean`. RFC 6454 makes the origin a function of the
name, so distinct origins are disjoint name regions.

| Lean name | B.9 claim | status |
|---|---|---|
| `regions_disjoint` | distinct origins ⇒ disjoint regions (`I∣o ∩ I∣o' = ∅`) | theorem (no axioms) |
| `no_double_claim` | no document name is served by both origin-disjoint families | theorem |
| `federation_closure` | **B.9**: the union is again well-formed — one graph per document, one origin per name | theorem |

Federation is the union law; it needs no machinery beyond disjointness.

### Prop 5.2 (Arity) — the crux

`FirstPrinciples/Arity.lean`. A fact names three things — `(predicate, subject,
object)`. B-0 (self-interpreting atom) + B-3 (names verbatim) say an atom's fact
may use only the atom's own names.

| Lean name | Prop 5.2 claim | status |
|---|---|---|
| `arity1_insufficient` | a 1-name atom can't express a fact of 2 distinct names | theorem (no axioms) |
| `arity2_insufficient` | a 2-name atom can't express a fact of 3 distinct names (pigeonhole) | theorem (no axioms) |
| `enc3`, `arity3_sufficient` | arity 3 is self-contained **and** expresses every fact | theorem (no axioms) |
| `arity_minimal_is_three` | **Prop 5.2 (core)**: three is the minimal arity | theorem (no axioms) |

**Honesty note (this is the book's flagged danger zone).** This mechanizes the
mathematical core *given self-containment*, which is an **explicit hypothesis on
display** (`hsc`), exactly as B-0/B-3 are conditions in the book — nothing is
smuggled. It does **not** re-derive *why* self-containment is the right condition:
that is the gadget-closure blocking the Löwenheim–Quine dyadic reduction, which
the book grounds in the Transposition Thesis's fourth row (a deployed web
invariant, argued not proved). The arity bound is the *consequence* of the
condition, not a proof of the condition.

### Theorem 5.4 / B.3 (Uniqueness) — the spine closes

`FirstPrinciples/Uniqueness.lean`. B.3 is the assembly: "compose the
isomorphisms." Transport B.1's representation `M ≅ 𝒫(A)` along B.2's atom≅triple
bijection to land in `𝒫(triples)`.

| Lean name | B.3 claim | status |
|---|---|---|
| `Bij`, `transport`, `transport_union`, `transport_injective` | a base-type bijection lifts to a union-preserving bijection of sets | theorem |
| `uniqueness_compose` | representation (B.1) + atom bijection (B.2) ⟹ injective ⊕→∪ hom `M → 𝒫(T)` | theorem |
| `atomRep`, `atomRep_hom`, `atomRep_inj` | B.1's representation, packaged over the atom subtype | theorem |
| `uniqueness` | **Thm 5.4**: a state model with the atomicity axioms whose atoms biject with `T` embeds reading-preservingly into `𝒫(T)` | theorem |
| `uniqueness_finite` | **Thm 5.4, finite bijection**: the embedding, plus every finite set of triples realized (`atomsBelow_joinList` transported) — "isomorphic" made exact in the finite | theorem |

`uniqueness` **genuinely rests on B.1** — it is `uniqueness_compose` fed with
`atomRep` (from `StateModel.atomsBelow_merge` / `atoms_injective`). The
atom≅triple bijection is the explicit **B.2 input**, exactly as the book's B.3
takes B.2's conclusion as an input to the assembly. So the spine
**B.1 → B.2 → B.3** is now machine-checked end to end.

### B.5 (Prop 4.4) — the analysis theorem, shape half

`FirstPrinciples/Analysis.lean`. Finite dependence: every request has a finite
*window* `K r` with `read r S = read r (S ∩ K r)`. The factorization then holds
by construction: `select` ships the window's facts plus the request encoded as
facts under a reserved authority; `arrange` and `present` are functions of
their argument alone — S1 with no side channels, enforced by the types.

| Lean name | B.5 claim | status |
|---|---|---|
| `IsWindow`, `FiniteDependence` | Prop. 4.4's hypothesis, formalized | def |
| `Encoding` | request-as-facts under a reserved authority (B-1), injective | def |
| `analysis_shape` | **Prop. 4.4 / B.5 (shape)**: `present (arrange (select r S)) = read r S` | theorem |
| `minimal_window_exists` | a minimal window sits inside any window (windows are finite) | theorem |

Honesty: this is the **shape half** — S1 and the three-stage form. S2–S4 are
claims about languages and addresses; no analysis argument can conjure those,
and the book assigns them to the synthesis theorem (B.8). `canon` at type `Doc`
is Chapter 6's bijection, taken as an input (`c : Bij Doc Tree`), exactly as
the book overloads it "deliberately and in the open." `dec` uses classical
choice: the factorization is an existence claim, not a program.

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
| Arity (5.2) / B.2 | ✅ **done** (core) — `arity_minimal_is_three`, self-containment on display as `hsc` |
| Uniqueness (5.4) / B.3 | ✅ **done** — `uniqueness` + `uniqueness_finite` (the finite bijection), the assembly of B.1 and B.2 (atom≅triple bijection as the B.2 input) |
| Independence of the laws / B.4 | ✅ formalizable — one of five countermodels done (`atomistic_independent`) |
| Analysis theorem (4.4) / B.5 | ✅ **done** (shape half) — `analysis_shape` + `minimal_window_exists`; S2–S4 are the synthesis' side (B.8) |
| Independent evolution (4.5) / B.6 | ✅ formalizable (dependency-triangle argument) |
| Delta normal form (7.1) | ✅ **done** — `delta_normal_form` (pure set algebra) |
| Forms / one-algebra / five moves (7.2–7.4) | ✅ formalizable (mechanical) |
| Erasure → quads (9.2) | ✅ formalizable |
| Federation closure / B.9 | ✅ **done** — `federation_closure` |
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
- **B.6** — independent evolution (dependency triangle).
- **B.7 / B.8** — partial only, against a Lean model of the SPARQL denotational
  fragment (see scope table).
