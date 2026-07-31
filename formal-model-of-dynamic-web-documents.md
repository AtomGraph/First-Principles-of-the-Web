# Formal Model of Dynamic Web Documents

> **Provenance note (2026-07-24).** Preserved as source material for *First Principles of the Web* (`first-principles-of-the-web.md`). The nested tuples became Chapter 3's strips (Transformation → Arrangement, Projection → Selection, Dataset → State); the time parameter became Prop. 4.5 (independent evolution) in Chapter 4. The time-indexing of Projection was retired there: user-driven selection change travels in the request, not in the factor — see the Ch 4 discussion of navigation belonging to `r`.

This document summarizes a clean, minimal, and time-aware formalism for describing how web documents are generated, evolve, and respond to changes.

## 1. Core Definitions

We formalize a web document using three nested tuples:

1. **Document(t) = (Style(t), Content(t))**
2. **Content(t) = (Transformation(t), Data(t))**
3. **Data(t) = (Projection(t), Dataset(t))**

Here:

* **Dataset(t)** is the raw underlying information at time *t* (e.g., database contents).
* **Projection(t)** selects some portion of the Dataset(t) (e.g., a query or filter).
* **Data(t)** bundles both the selection logic and the dataset it operates on.
* **Transformation(t)** maps Data(t) into a structured representation (e.g., DOM structure or template output).
* **Content(t)** bundles the structure-building logic and the resulting data.
* **Style(t)** applies aesthetic rules that define the visual appearance of Content(t).
* **Document(t)** is the final, styled output.

This structure preserves a clear separation of concerns: **Dataset → Projection → Transformation → Style**.

## 2. Time Parameter (t)

Each component is allowed to depend on time to capture both user-driven and data-driven changes.

### What changes over time?

* **Dataset(t)** often changes frequently (e.g., new records, updates).
* **Projection(t)** may change when user-selected filters or search terms update.
* **Transformation(t)** may change when the user switches layouts (list/grid) or when the developer redeploys new template logic.
* **Style(t)** may change when switching themes or updating visual design.

### Why introduce time?

Time-dependence allows us to describe:

* dynamic applications (client-side interaction)
* real-time or periodically updated datasets
* user-controlled view changes
* redeployed application logic or style updates

Under this view, a web document is not a single immutable object but a **sequence of states**:

**Document(0), Document(1), Document(2), ...**

Each step reflects changes in any of the model's components.

## 3. Interpretation Pipeline

The model can be visualized as a pipeline:

1. **Dataset(t)** — raw data
2. **Projection(t)** — selects relevant subset → **Data(t)**
3. **Transformation(t)** — structures Data(t) → **Content(t)**
4. **Style(t)** — visually decorates Content(t) → **Document(t)**

Only the relevant component needs to change to produce a new document state.

## 4. Advantages of this Model

* **Minimal**: Only four conceptual layers (Dataset, Projection, Transformation, Style).
* **Modular**: Each part can evolve independently.
* **Realistic**: Matches how modern webapps behave (dynamic data, user interaction, redeploys).
* **General**: Covers static sites, dynamic SPAs, server-rendered pages, and knowledge graph applications.

## 5. Summary Statement

A web document is the combination of:

* **what data exists**,
* **how it is selected**,
* **how it is structured**, and
* **how it is styled**.

Each of these can vary over time, giving rise to an evolving document. This simple but powerful formalism captures both the static architecture of web pages and the dynamic behavior of modern interactive applications.
