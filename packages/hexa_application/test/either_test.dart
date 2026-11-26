import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

void main() {
  group('D-160', () {
    test('should_be_equal_when_two_rights_hold_equal_values', () {
      // Arrange
      const right = Right<AppFailure, int>(42);

      // Act
      final copy = Right<AppFailure, int>(int.parse('42'));

      // Assert
      expect(copy, right);
      expect(copy.hashCode, right.hashCode);
    });

    test('should_be_equal_when_two_lefts_hold_equal_failures', () {
      // Arrange
      const left = Left<AppFailure, int>(RuleFailure('no-saved-game'));

      // Act
      final copy = Left<AppFailure, int>(
        RuleFailure(['no-saved', 'game'].join('-')),
      );

      // Assert
      expect(copy, left);
      expect(copy.hashCode, left.hashCode);
    });

    test('should_not_be_equal_when_a_left_and_a_right_hold_the_same_value', () {
      // Arrange
      const left = Left<int, int>(1);

      // Act
      const right = Right<int, int>(1);

      // Assert
      expect(left, isNot(right));
    });

    test('should_tell_the_two_sides_apart_when_switched_over', () {
      // Arrange
      const results = <Either<AppFailure, int>>[
        Right(3),
        Left(NetworkFailure()),
      ];

      // Act
      final described = [
        for (final result in results)
          switch (result) {
            Right(:final value) => 'right $value',
            Left(value: NetworkFailure()) => 'left network',
            Left() => 'left other',
          },
      ];

      // Assert
      expect(described, ['right 3', 'left network']);
    });
  });
}
