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
| `encN`, `encN_faithful`, `encN_self_contained` | the n-ary decomposition: `R(a₁…aₙ)` ↦ `(e, rel, R)` + `(e, roleᵢ, aᵢ)`, faithfully, every atom still meaning alone | theorem (no axioms) |
| `arity_above_three_decomposes` | **why three is *minimal*, not merely sufficient**: wider atoms encode back into triples, so the conditions bound arity from below and parsimony selects three | theorem (no axioms) |

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

| `Reading`, `Reading.toBij` | the atom≅triple bijection **constructed** from a universal reading that is onto (R1) and one-to-one (faithfulness) — not postulated | def + proofs |
| `uniqueness_from_reading` | **Thm 5.4, welded**: uniqueness from the reading's two properties, no bijection assumed | theorem |
| `no_pair_reading` | the codomain is forced wider than pairs: a self-contained arity-2 reading is never onto (`arity2_insufficient` applied) — B.2 used inside B.3 | theorem (no axioms) |

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

### B-2e and the full powerset — Lemma B.1 complete, Thm 5.4's "isomorphic" exact

`FirstPrinciples/Accumulation.lean`. B-2e as the book states it (`HasAccumulation`:
every directed family has a join whose atoms are the union), and the jump it buys:

| Lean name | claim | status |
|---|---|---|
| `atoms_realized` | every set of atoms is some state's atom-set (finite parts via `joinList`, then the directed join) | theorem |
| `representation_full` | **Lemma B.1, complete**: atom map = injective ⊕→∪ hom onto the FULL powerset | theorem |
| `uniqueness_iso` | **Thm 5.4, exact**: `σ : M → 𝒫(T)` is a ⊕→∪ *bijection* — "isomorphic" with no finiteness restriction | theorem |

### B.4, continued — three more countermodels and the engine

`FirstPrinciples/Independence.lean`.

| Lean name | claim | status |
|---|---|---|
| `rep_forces_laws` | the engine: union's algebra pulls back — any injectively represented merge is already comm/assoc/idem | theorem |
| `order_freedom_independent` + `_no_representation` | **B-2b**: last-arrival-wins is total/assoc/idem/identity, not comm, and admits no representation | theorem |
| `idempotence_independent` + `_no_representation` | **B-2c**: `(ℕ, +, 0)` — multisets over one fact — counts arrivals, no representation | theorem |
| `finsets`, `accumulation_independent` | **B-2e**: finite subsets of infinite `A` — all four laws + both atomicity axioms hold, yet the set of all atoms is realized by no state | theorem |
| `finsets_no_accumulation` | the loop closed: what `finsets` lacks is exactly `HasAccumulation` | theorem |

With `atomistic_independent` (B-2d, StateModel.lean) that is four of five. **B-2a
(totality) deliberately has no countermodel**: totality is enforced by typing
(`merge : M → M → M`), so dropping it makes Lemma B.1's statement ill-typed —
the book's "Lemma B.1's target is gone" is, in Lean, a statement about
statements, not a theorem in the logic. The Lean witness for B-2b is the minimal
non-commutative model (last-arrival-wins), not the book's richer event-log
witness; the proposition proved (a model with the other laws and no
representation) is the book's.

### B.6 (Prop 4.5) — independent evolution

`FirstPrinciples/Evolution.lean`. The dependency triangle, mechanized the only
honest way: each factor IS a function of its displayed arguments, so upstream
invariance under substitution is definitional (`rfl`) — which is B.6's point,
not a shortcut. `present_substitution` / `arrange_substitution` show a
substituted component recomputes the document from the OLD upstream stage
values; `timelines_independent` turns the book's effectiveness witness into the
independent-timeline statement. Near-definitional by design; the fused half
needs no lemma (one component, one row, nothing upstream to hold still).

### B.7 (Prop 8.1) — the homomorphism, against a model of §18

`FirstPrinciples/Homomorphism.lean`. Both sides defined independently — Chapter
5's algebra over `Fact = I×I×(I∪V)` with bindings total on exactly `Var(P)`,
and a Lean model of SPARQL 1.1 Query §18's denotational clauses (BGP as
`μ(BGP) ⊆ G`, Join as compatible merge, Union, Project) over `iri`/`lit` terms.

| Lean name | B.7 claim | status |
|---|---|---|
| `homomorphism` | **Prop 8.1**: φ-image of the derived evaluation = deployed evaluation of the translated term, by induction — four clauses, four checks | theorem |
| `toSols_dmatch` | the base clause: `φ(match(P)(S)) = eval(BGP_{φ(P)}, φ(S))` | theorem |
| `seval_monotone` | the fragment is the monotone core (what OPTIONAL/MINUS give up) | theorem |
| `toTriple_inj`, `toTriple_range` | φ is a bijection between ground states and well-formed ground graphs | theorem |

The book's three boundaries hold by construction: no blank nodes in the term
type; AND/UNION/SELECT under set semantics only; literals are terms with
character-level identity. This is correspondence to *this model* of §18, never
to an engine — the partial the scope table promises.

### B.8 (Thm 8.2) — the genericity core

`FirstPrinciples/Genericity.lean`. Renamings (bijections on `I` fixing `V₀`
pointwise, literals untouched), acting on facts and states; the output side is
an abstract action, so `canon` stays external, as the scope table says.

| Lean name | B.8 claim | status |
|---|---|---|
| `transposition` | `(u u′)` IS a renaming when `u, u′ ∉ V₀` — the free theorem's instrument, constructed | def + proofs |
| `treats_no_name_specially` | **the free theorem**: a generic transform's output moves by exactly the transposition's action | theorem |
| `treats_no_name_outside_W_specially` | the free theorem relativized to a declared `W`, verbatim | theorem |
| `generic_comp` | genericity composes down the pipeline (the synthesis assembly step) | theorem |

`homomorphism` and `seval_monotone` use no choice; `generic_comp` no axioms at
all. "XSLT is Turing-complete on trees" and RDFC-1.0 stay cited external facts.

### The chapter propositions — 6.1, 7.2–7.4, 9.1, 9.2, 19.1

The scope table marks these formalizable; here they are.

`FirstPrinciples/Canon.lean` — **Prop 6.1 (`canon` exists)**, ground core.
Given an injective sort key, `canonL` (insertion sort with dedup) is
structure-free (`canonL_sorted`: order is the key's, and the key means
nothing), lossless (`canonL_mem`), and **deterministic in the strong sense**
(`canonL_canonical`: any two enumerations with the same members — any arrival
order, any duplication — canonicalize identically). Blank-node labeling is
RDFC-1.0, external.

`FirstPrinciples/Writes.lean` — the write side and its corollaries.

| Lean name | claim | status |
|---|---|---|
| `submit`, `bound_pattern_functional`, `bound_pattern_total` | **7.2**: a bound pattern denotes exactly one fact per triple, so submission IS a delta | theorem |
| `find_then_denote` | **7.3**: same pattern, same matching relation, both directions — bindings found by match denote only matched facts | theorem |
| `five_moves` | **7.4**: every passage between configurations decomposes into the five single-input moves; "no sixth move" is the type's arity | theorem |
| `nothing_else_to_vary` | **19.1**: over one engine, applications agreeing on terms and state agree at every request | theorem |

7.2–7.3 reuse `Pattern` and `matchTP` *imported from* Homomorphism.lean — the
one-algebra claim is enforced by reuse, not restated. 7.4 and 19.1 are
near-definitional by design, like B.6.

`FirstPrinciples/Quads.lean` — **Prop 9.2** and **Prop 9.1**.

| Lean name | claim | status |
|---|---|---|
| `attribution_erased` | **9.2, erasure**: two sources publishing one fact publish the *same* triple-state, so no function of it recovers the asserter — impossibility proved, not asserted | theorem |
| `attribution_recovered`, `attrOf_merge`, `quad_merge_is_union` | **9.2, repair**: quads recover attribution, attribution is itself a ⊕→∪ homomorphism, and merge is still union | theorem |
| `bill_for_anonymity` | **9.1**: ground — union and idempotence on the nose; anonymous — idempotence up to equivalence (`blank_idem_up_to_equiv`), never identity (`blank_idem_fails`) | theorem |

9.1 is a faithful *miniature* of the doubling phenomenon (ground facts plus a
count of existential blocks, added on merge), not a formalization of RDF
semantics; canonical labeling and coNP-complete redundancy elimination stay
cited.

### Where the halves meet

`FirstPrinciples/Meeting.lean`. B.8 closes: "every windowed `read` has the
form, its select window-shaped (a union of ground matches, inside the derived
algebra) and the stack fills the form." Analysis hands back an abstract
`select`; B.7 carries algebra terms to SPARQL; the sentence joining them was
prose. Now:

| Lean name | claim | status |
|---|---|---|
| `ground_match_iff` | a ground pattern matches exactly when its fact is in the state — membership is a term of the algebra | theorem |
| `window_select_algebraic` | hence `S ∩ K` is a union of ground matches: B.5's select lies **inside** the derived algebra | theorem |
| `halves_meet` | the three results as one statement: the form (B.5), its select algebraic (here), the algebra carried to the deployed side (B.7) | theorem |

Nothing new is assumed; the content is that two halves developed in separate
files compose.

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
| Union law (5.1) / B.1 | ✅ **done**, complete — embedding, finite (`representation_finite`), and full powerset under B-2e (`representation_full`) |
| Arity (5.2) / B.2 | ✅ **done** (core) — `arity_minimal_is_three`, self-containment on display as `hsc` |
| Uniqueness (5.4) / B.3 | ✅ **done**, exact — `uniqueness` (embedding), `uniqueness_finite` (finite bijection), `uniqueness_iso` (full ⊕→∪ bijection under B-2e) |
| Independence of the laws / B.4 | ✅ **done** — four of five countermodels (B-2b/c/d/e) + `rep_forces_laws`; B-2a is enforced by typing (see above) |
| Analysis theorem (4.4) / B.5 | ✅ **done** (shape half) — `analysis_shape` + `minimal_window_exists`; S2–S4 are the synthesis' side (B.8) |
| Independent evolution (4.5) / B.6 | ✅ **done** — the triangle is definitional by design (`Evolution.lean`) |
| Delta normal form (7.1) | ✅ **done** — `delta_normal_form` (pure set algebra) |
| Forms / one-algebra / five moves (7.2–7.4) | ✅ **done** — `submit`/`bound_pattern_*`, `find_then_denote`, `five_moves` (Writes.lean) |
| Erasure → quads (9.2) | ✅ **done** — `attribution_erased` + the quad repair (Quads.lean) |
| Federation closure / B.9 | ✅ **done** — `federation_closure` |
| Nothing else to vary (19.1) | ✅ **done** — `nothing_else_to_vary` (a corollary, and it stays one) |
| Homomorphism (8.1) / B.7 | ✅ **done** (partial as scoped) — `homomorphism` against the §18 model in Homomorphism.lean; correspondence to *that model*, not to Saxon |
| Synthesis + genericity (8.2) / B.8 | ✅ **done** (core as scoped) — free theorem + relativization + composition in Genericity.lean; XSLT-completeness stays a cited external fact |
| `canon` exists (6.1) | ✅ **done** for ground states — `canon_exists` (Canon.lean); ❌ blank-node RDFC-1.0 (enormous external spec) |
| Bill for anonymity (9.1) | ✅ **done** (algebraic core) — `bill_for_anonymity` (Quads.lean); ❌ coNP-completeness is a cited complexity result |
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

## Deferred

Nothing on the formalizable list. What remains outside it is outside by kind,
not by effort — see the scope table: the Transposition Thesis, the R-conditions
as axioms, the audits, and the external specs (RDFC-1.0, XSLT-completeness,
coNP-completeness) stay cited, never re-proved.
