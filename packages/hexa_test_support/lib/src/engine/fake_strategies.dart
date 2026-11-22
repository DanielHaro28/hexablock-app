import 'package:hexa_engine/hexa_engine.dart';

import 'fake_cell.dart';
import 'fake_rules.dart';

/// A piece source for the engine tests (D-56): it draws one of [labels]
/// with the generator it is given, `next() mod labels.length` (RN-COM-44).
///
/// Like every source, it keeps no generator of its own (D-97).
final class FakePieceSource implements IPieceSource<FakeCell> {
  const FakePieceSource(this.labels);

  /// The labels it chooses from; never empty.
  final List<String> labels;

  @override
  (FakeCell piece, Xorshift32 after) next(Xorshift32 random) {
    final (index, after) = random.nextInt(labels.length);
    return (FakeCell(labels[index]), after);
  }
}

/// A scoring policy for the engine tests (D-56): each [FakeEvent] is worth
/// the points of its label in [pointsPerLabel], or 0 if it is not there.
final class FakeScoring implements IScoringPolicy<FakeState, FakeEvent> {
  const FakeScoring(this.pointsPerLabel);

  /// The points of an event, by its label.
  final Map<String, int> pointsPerLabel;

  @override
  int pointsFor(FakeState state, Iterable<FakeEvent> events) =>
      events.fold(0, (sum, event) => sum + (pointsPerLabel[event.label] ?? 0));
}

/// An attempt for the engine tests (D-56): the points and the moves it took.
final class FakeAttempt {
  const FakeAttempt({required this.points, required this.moves});

  /// The points of the attempt.
  final int points;

  /// The moves it took.
  final int moves;

  @override
  bool operator ==(Object other) =>
      other is FakeAttempt && other.points == points && other.moves == moves;

  @override
  int get hashCode => Object.hash(points, moves);

  @override
  String toString() => 'FakeAttempt(points: $points, moves: $moves)';
}

/// A progress model for the engine tests (D-56): more points is better and,
/// with the same points, fewer moves. Two keys, like the real criteria
/// (RN-HF-71, RN-COM-103).
final class FakeProgressModel implements IProgressModel<FakeAttempt> {
  const FakeProgressModel();

  @override
  int compare(FakeAttempt a, FakeAttempt b) {
    final byPoints = b.points.compareTo(a.points);
    return byPoints != 0 ? byPoints : a.moves.compareTo(b.moves);
  }
}
