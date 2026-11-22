import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const IProgressModel<FakeAttempt> model = FakeProgressModel();

  group('D-99', () {
    test('should_prefer_more_points_when_the_points_differ', () {
      // Arrange
      const better = FakeAttempt(points: 30, moves: 9);
      const worse = FakeAttempt(points: 20, moves: 1);

      // Act
      final order = model.compare(better, worse);

      // Assert
      expect(order, isNegative);
      expect(model.compare(worse, better), isPositive);
    });

    test('should_prefer_fewer_moves_when_the_points_are_equal', () {
      // Arrange
      const better = FakeAttempt(points: 30, moves: 3);
      const worse = FakeAttempt(points: 30, moves: 4);

      // Act
      final order = model.compare(better, worse);

      // Assert
      expect(order, isNegative);
    });

    test('should_compare_as_equal_when_the_attempts_tie', () {
      // Arrange
      const first = FakeAttempt(points: 30, moves: 3);
      const second = FakeAttempt(points: 30, moves: 3);

      // Act
      final order = model.compare(first, second);

      // Assert
      expect(order, 0);
    });

    test('should_order_the_attempts_best_first_when_sorting_with_it', () {
      // Arrange
      final attempts = [
        const FakeAttempt(points: 20, moves: 2),
        const FakeAttempt(points: 30, moves: 5),
        const FakeAttempt(points: 30, moves: 4),
      ];

      // Act
      attempts.sort(model.compare);

      // Assert: the best attempt is taken whole, never mixed with another.
      expect(attempts, const [
        FakeAttempt(points: 30, moves: 4),
        FakeAttempt(points: 30, moves: 5),
        FakeAttempt(points: 20, moves: 2),
      ]);
    });
  });
}
