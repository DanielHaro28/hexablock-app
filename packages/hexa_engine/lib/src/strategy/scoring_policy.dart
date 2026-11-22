/// How many points a step of a turn is worth: a Strategy that the variant's
/// factory chooses and injects into its rules (D-35, D-98).
///
/// The rules call it inside their steps (each step sees only its own state,
/// so each one scores its own events) and add the result to the score of
/// the state they return. The engine never calls it: it only reads the
/// score of the new state to publish `ScoreChanged`.
///
/// Another policy, or a decorator that wraps one, is a new class connected
/// in the variant's concrete factory, without touching the rules or the
/// engine (ARQ-02 §9.2, §10; D-100).
///
/// Type parameters (ARQ-02 §4.3):
/// - `TState` has no constraint, as in `Step`: bounding it by `GameState`
///   would force the policy to carry `C` and `TCell` without using them.
/// - `TEvent` has no constraint: it is the variant's own event family, so
///   the policy switches over it exhaustively, without casts.
abstract interface class IScoringPolicy<TState, TEvent> {
  /// The points of a step that left [state] and published [events], in
  /// order. An integer ≥ 0 (RN-COM-50). If the formula has fractions, it
  /// rounds down once, after applying them (RN-COM-51). So a fractional
  /// multiplier wraps only the policy of the step whose events it
  /// multiplies, never one used by several steps (D-101).
  int pointsFor(TState state, Iterable<TEvent> events);
}
