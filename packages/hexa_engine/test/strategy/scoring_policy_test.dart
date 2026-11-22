import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// A decorator over any scoring policy: it doubles the points of the policy
/// it wraps. It stands for the defense's "another scoring policy" (ARQ-02
/// §9.2), and shows that a decorator needs no variant.
final class _Doubled<TState, TEvent> implements IScoringPolicy<TState, TEvent> {
  const _Doubled(this._inner);

  final IScoringPolicy<TState, TEvent> _inner;

  @override
  int pointsFor(TState state, Iterable<TEvent> events) =>
      2 * _inner.pointsFor(state, events);
}

void main() {
  const topology = FakeTopology();
  final state = FakeState(Board.of(topology, ShapeSpec('rectangle', [2, 1])));
  const scoring = FakeScoring({'apply': 1, 'resolve': 10});

  group('RN-COM-51', () {
    test('should_add_the_points_of_each_event_when_scoring_a_step', () {
      // Arrange
      const events = [FakeEvent('resolve'), FakeEvent('resolve')];

      // Act
      final points = scoring.pointsFor(state, events);

      // Assert
      expect(points, 20);
    });

    test('should_score_zero_when_the_step_has_no_events', () {
      // Arrange
      const events = <FakeEvent>[];

      // Act
      final points = scoring.pointsFor(state, events);

      // Assert
      expect(points, 0);
    });

    test('should_score_zero_when_the_events_are_worth_nothing', () {
      // Arrange
      const events = [FakeEvent('afterResolve')];

      // Act
      final points = scoring.pointsFor(state, events);

      // Assert
      expect(points, 0);
    });

    test('should_change_the_points_when_the_policy_is_decorated', () {
      // Arrange
      const IScoringPolicy<FakeState, FakeEvent> doubled = _Doubled(scoring);
      const events = [FakeEvent('apply'), FakeEvent('resolve')];

      // Act
      final points = doubled.pointsFor(state, events);

      // Assert
      expect(points, 22);
    });
  });
}
