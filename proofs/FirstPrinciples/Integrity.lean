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
import FirstPrinciples.Accumulation
import FirstPrinciples.Independence
import FirstPrinciples.Evolution
import FirstPrinciples.Homomorphism
import FirstPrinciples.Genericity
import FirstPrinciples.Meeting
import FirstPrinciples.Canon
import FirstPrinciples.Writes
import FirstPrinciples.Quads

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

/--
info: 'FirstPrinciples.Accumulation.representation_full' depends on axioms: [propext, Quot.sound]
-/
#guard_msgs in
#print axioms Accumulation.representation_full

/--
info: 'FirstPrinciples.Accumulation.uniqueness_iso' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Accumulation.uniqueness_iso

/-- info: 'FirstPrinciples.Independence.rep_forces_laws' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Independence.rep_forces_laws

/--
info: 'FirstPrinciples.Independence.order_freedom_no_representation' depends on axioms: [propext, Quot.sound]
-/
#guard_msgs in
#print axioms Independence.order_freedom_no_representation

/--
info: 'FirstPrinciples.Independence.idempotence_no_representation' depends on axioms: [propext, Quot.sound]
-/
#guard_msgs in
#print axioms Independence.idempotence_no_representation

/--
info: 'FirstPrinciples.Independence.accumulation_independent' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Independence.accumulation_independent

/--
info: 'FirstPrinciples.Independence.finsets_no_accumulation' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Independence.finsets_no_accumulation

/-- info: 'FirstPrinciples.Evolution.timelines_independent' does not depend on any axioms -/
#guard_msgs in
#print axioms Evolution.timelines_independent

/--
info: 'FirstPrinciples.Homomorphism.homomorphism' depends on axioms: [propext, Quot.sound]
-/
#guard_msgs in
#print axioms Homomorphism.homomorphism

/-- info: 'FirstPrinciples.Homomorphism.seval_monotone' does not depend on any axioms -/
#guard_msgs in
#print axioms Homomorphism.seval_monotone

/-- info: 'FirstPrinciples.Homomorphism.toTriple_range' does not depend on any axioms -/
#guard_msgs in
#print axioms Homomorphism.toTriple_range

/--
info: 'FirstPrinciples.Genericity.transposition' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Genericity.transposition

/--
info: 'FirstPrinciples.Genericity.treats_no_name_specially' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Genericity.treats_no_name_specially

/-- info: 'FirstPrinciples.Genericity.generic_comp' does not depend on any axioms -/
#guard_msgs in
#print axioms Genericity.generic_comp

/-- info: 'FirstPrinciples.Canon.canon_exists' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Canon.canon_exists

/-- info: 'FirstPrinciples.Writes.bound_pattern_functional' does not depend on any axioms -/
#guard_msgs in
#print axioms Writes.bound_pattern_functional

/-- info: 'FirstPrinciples.Writes.find_then_denote' does not depend on any axioms -/
#guard_msgs in
#print axioms Writes.find_then_denote

/-- info: 'FirstPrinciples.Writes.five_moves' does not depend on any axioms -/
#guard_msgs in
#print axioms Writes.five_moves

/-- info: 'FirstPrinciples.Writes.nothing_else_to_vary' does not depend on any axioms -/
#guard_msgs in
#print axioms Writes.nothing_else_to_vary

/-- info: 'FirstPrinciples.Quads.attribution_erased' does not depend on any axioms -/
#guard_msgs in
#print axioms Quads.attribution_erased

/-- info: 'FirstPrinciples.Quads.attrOf_merge' does not depend on any axioms -/
#guard_msgs in
#print axioms Quads.attrOf_merge

/--
info: 'FirstPrinciples.Quads.bill_for_anonymity' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Quads.bill_for_anonymity

/-- info: 'FirstPrinciples.Arity.arity_above_three_decomposes' does not depend on any axioms -/
#guard_msgs in
#print axioms Arity.arity_above_three_decomposes

/-- info: 'FirstPrinciples.Arity.encN_faithful' does not depend on any axioms -/
#guard_msgs in
#print axioms Arity.encN_faithful

/--
info: 'FirstPrinciples.Uniqueness.uniqueness_from_reading' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Uniqueness.uniqueness_from_reading

/-- info: 'FirstPrinciples.Uniqueness.no_pair_reading' does not depend on any axioms -/
#guard_msgs in
#print axioms Uniqueness.no_pair_reading

/-- info: 'FirstPrinciples.Meeting.ground_match_iff' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Meeting.ground_match_iff

/-- info: 'FirstPrinciples.Meeting.window_select_algebraic' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Meeting.window_select_algebraic

/--
info: 'FirstPrinciples.Meeting.halves_meet' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms Meeting.halves_meet
