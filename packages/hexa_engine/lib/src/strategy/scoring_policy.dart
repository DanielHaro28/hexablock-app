/// How many points a step of a turn is worth: a Strategy that the variant's
/// factory chooses and injects into its rules (D-35, D-98).
///
/// The rules call it inside their steps (each step sees only its own state,
/// so each one scores its own events) and add the result to the score of
/// the state they return. The engine never calls it: it only reads the
/// score of the new state to publish `ScoreChanged`.
///
/// Another policy, or a decorator that wraps one, is a new class connected
/// in the factory, without touching the rules or the engine (ARQ-02 §9.2,
/// §10).
///
/// Type parameters (ARQ-02 §4.3):
/// - `TState` has no constraint: a policy reads what it needs from the
///   variant's own state (for example, a streak).
/// - `TEvent` has no constraint: it is the variant's own event family, so
///   the policy switches over it exhaustively, without casts.
abstract interface class IScoringPolicy<TState, TEvent> {
  /// The points of a step that left [state] and published [events], in
  /// order. An integer ≥ 0 (RN-COM-50); if the formula has fractions, it
  /// rounds down once, at the end (RN-COM-51).
  int pointsFor(TState state, Iterable<TEvent> events);
}
