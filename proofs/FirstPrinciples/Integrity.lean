/-
  First Principles of the Web — integrity check.

  Machine-enforced axiom audit: each `#guard_msgs` below FAILS THE BUILD if a
  theorem's axiom footprint ever changes — in particular if a `sorry` (which
  would surface as `sorryAx`) or a new axiom slips into any proof. This makes
  the README's claims ("sorry-free; the embedding and the arity core depend on
  no axioms at all; the rest use only Lean's three standard axioms") properties
  the build checks, not assertions the reader trusts.
-/

import FirstPrinciples.StateModel
import FirstPrinciples.Delta
import FirstPrinciples.Federation
import FirstPrinciples.Arity
import FirstPrinciples.Uniqueness
import FirstPrinciples.Analysis

open FirstPrinciples

/-- info: 'StateModel.representation_embedding' does not depend on any axioms -/
#guard_msgs in
#print axioms StateModel.representation_embedding

/-- info: 'StateModel.representation_finite' depends on axioms: [propext] -/
#guard_msgs in
#print axioms StateModel.representation_finite

/--
info: 'StateModel.atomistic_independent' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms StateModel.atomistic_independent

/-- info: 'FirstPrinciples.Arity.arity_minimal_is_three' does not depend on any axioms -/
#guard_msgs in
#print axioms Arity.arity_minimal_is_three

/--
info: 'FirstPrinciples.Uniqueness.uniqueness' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Uniqueness.uniqueness

/--
info: 'FirstPrinciples.Uniqueness.uniqueness_finite' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Uniqueness.uniqueness_finite

/--
info: 'FirstPrinciples.delta_normal_form' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms delta_normal_form

/--
info: 'FirstPrinciples.Federation.federation_closure' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Federation.federation_closure

/--
info: 'FirstPrinciples.Analysis.analysis_shape' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Analysis.analysis_shape

/--
info: 'FirstPrinciples.Analysis.minimal_window_exists' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Analysis.minimal_window_exists
