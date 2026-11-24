import 'package:hexa_engine/hexa_engine.dart';

import 'lines_state.dart';

/// The scoring of Hexa Lines (RN-HL-60): one point per placed cell plus the
/// line bonus it wraps.
///
/// The rules call it once per step with that step's events (D-98): `apply`
/// gets the placed cells and `resolve` the cleared lines. The streak
/// multiplies only the line bonus (RN-HL-63), so the factory wires
/// `LinesScoring(StreakMultiplier(LineBonus()))` and the floor of
/// RN-HL-64 happens once (D-101).
final class LinesScoring<C extends Coord>
    implements IScoringPolicy<LinesState<C>, LinesEvent<C>> {
  /// The scoring with [lineBonus] for the cleared lines.
  const LinesScoring(this._lineBonus);

  final IScoringPolicy<LinesState<C>, LinesEvent<C>> _lineBonus;

  @override
  int pointsFor(LinesState<C> state, Iterable<LinesEvent<C>> events) =>
      events.fold(
        0,
        (sum, event) =>
            sum +
            switch (event) {
              PiecePlaced(:final cells) => cells.length,
              LinesCleared() => 0, // scored by the line bonus
            },
      ) +
      _lineBonus.pointsFor(state, events);
}

/// The line bonus times the combo (RN-HL-61, 62): Σ [pointsPerCell] ×
/// length of each cleared line, times the number of lines.
///
/// The points are whole, so a multiplier with fractions wraps this policy
/// and rounds once (RN-HL-64).
final class LineBonus<C extends Coord>
    implements IScoringPolicy<LinesState<C>, LinesEvent<C>> {
  /// The line bonus with [pointsPerCell] for each cell of a cleared line,
  /// read from the configuration (RNF-11, D-139).
  const LineBonus(this.pointsPerCell);

  /// The points of each cell of a cleared line.
  final int pointsPerCell;

  @override
  int pointsFor(LinesState<C> state, Iterable<LinesEvent<C>> events) =>
      events.fold(
        0,
        (sum, event) =>
            sum +
            switch (event) {
              PiecePlaced() => 0,
              LinesCleared(:final lines) =>
                lines.fold(
                      0,
                      (bonus, line) => bonus + pointsPerCell * line.length,
                    ) *
                    lines.length,
            },
      );
}

/// The streak multiplier (Decorator, RN-HL-63, 64): the points of the
/// wrapped policy × (k + 1) / 2, at most × [maxMultiplier], rounded down
/// once.
///
/// `k` is the streak of the state the step left, so in `resolve` it already
/// counts the current turn. It works in halves to stay in integers:
/// ⌊points × min(k + 1, 2 × [maxMultiplier]) / 2⌋, which is RN-HL-64 with
/// the ×3 of D-09.
final class StreakMultiplier<C extends Coord>
    implements IScoringPolicy<LinesState<C>, LinesEvent<C>> {
  /// The streak multiplier over [inner], up to [maxMultiplier], read from
  /// the configuration (RNF-11, D-139).
  const StreakMultiplier(this._inner, {required this.maxMultiplier});

  /// The largest multiplier, reached at k = 2 × [maxMultiplier] − 1.
  final int maxMultiplier;

  final IScoringPolicy<LinesState<C>, LinesEvent<C>> _inner;

  @override
  int pointsFor(LinesState<C> state, Iterable<LinesEvent<C>> events) {
    final halves = state.streak + 1;
    final capped = halves < 2 * maxMultiplier ? halves : 2 * maxMultiplier;
    return _inner.pointsFor(state, events) * capped ~/ 2;
  }
}
