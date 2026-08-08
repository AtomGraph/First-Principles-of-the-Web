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

## What is mechanized so far

`FirstPrinciples/StateModel.lean` — **Lemma B.1 (Representation), embedding half.**

A `StateModel` bundles the merge laws that are algebraic identities (B-2b
order-freedom, B-2c idempotence, and `∅` as identity), making `(M, ⊕, ∅)` a
bounded join-semilattice with induced order `a ≤ b := a ⊕ b = b`.

| Lean name | Appendix B claim | status |
|---|---|---|
| `le_refl`, `le_trans`, `le_antisymm` | `≤` is a partial order | theorem (semilattice only) |
| `empty_le` | `∅` is least | theorem |
| `le_merge_left/right` | monotonicity `s ≤ s ⊕ t` | theorem |
| `atomsBelow_empty` | `∅` carries no atoms (bottom preserved) | theorem |
| `atomsBelow_merge_of_left/right` | homomorphism, **⊇** inclusion | theorem (no axiom) |
| `NoEmergence` | B-2d, "no emergence" (⊆ inclusion) | isolated axiom |
| `Atomistic` | B-2d, "every state is the join of its atoms" | isolated axiom |
| `atomsBelow_merge` | full homomorphism `atoms(s⊕t) = atoms s ∪ atoms t` | theorem, uses `NoEmergence` |
| `atoms_injective` | atom map is injective | theorem, uses `Atomistic` |
| `representation_embedding` | **B.1 embedding half**, assembled | theorem |

`representation_embedding` `#print axioms` cleanly: it **depends on no axioms at
all** (constructive; not even `propext` or choice).

### What the formalization clarified

Isolating B-2d into two named predicates makes precise a point the prose states
in passing: the homomorphism's **⊇** inclusion is *derivable* from the
semilattice laws (monotonicity), so only the **⊆** inclusion ("no emergence") is
genuine axiomatic content. This matches Appendix B.4's independence result —
`NoEmergence` is exactly the load-bearing half of B-2d for the merge homomorphism.

## Deferred (next commits)

- **B.1, surjectivity half** — every finite set of atoms is realized (finite
  join), and, with **B-2e** (accumulation), the jump to the full powerset.
  Needs finite-join machinery built by hand (or the Mathlib port).
- **B.2 / B.3** — arity-minimality forces `I × I × (I ∪ V)`; uniqueness up to
  reading-preserving isomorphism.
- **B.4** — non-redundancy via the five countermodels.
- **B.5** — the analysis theorem (finite dependence ⇒ three-stage S1 factorization).
