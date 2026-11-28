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

  group('D-170', () {
    // A step that can fail, to chain: halves an even number.
    Either<AppFailure, int> half(int value) =>
        value.isEven ? Right(value ~/ 2) : const Left(RuleFailure('odd'));

    // Another step, to check that the order of the steps is kept.
    Either<AppFailure, int> minusOne(int value) =>
        value > 0 ? Right(value - 1) : const Left(RuleFailure('not-positive'));

    const samples = <Either<AppFailure, int>>[
      Right(8),
      Right(3),
      Left(NetworkFailure()),
    ];

    test('should_give_what_on_right_returns_when_folding_a_right', () {
      // Arrange
      const result = Right<AppFailure, int>(4);

      // Act
      final folded = result.fold(
        (failure) => 'left',
        (value) => 'right $value',
      );

      // Assert
      expect(folded, 'right 4');
    });

    test('should_give_what_on_left_returns_when_folding_a_left', () {
      // Arrange
      const result = Left<AppFailure, int>(RuleFailure('odd'));

      // Act
      final folded = result.fold<Object>((failure) => failure, (value) => 0);

      // Assert
      expect(folded, const RuleFailure('odd'));
    });

    test('should_transform_the_value_once_when_mapping_a_right', () {
      // Arrange
      const result = Right<AppFailure, int>(4);
      var calls = 0;

      // Act
      final mapped = result.map((value) {
        calls++;
        return '$value points';
      });

      // Assert
      expect(mapped, const Right<AppFailure, String>('4 points'));
      expect(calls, 1);
    });

    test('should_keep_the_failure_without_calling_transform_when_mapping_a_'
        'left', () {
      // Arrange
      const result = Left<AppFailure, int>(NetworkFailure());
      var calls = 0;

      // Act
      final mapped = result.map((value) {
        calls++;
        return '$value points';
      });

      // Assert
      expect(mapped, const Left<AppFailure, String>(NetworkFailure()));
      expect(calls, 0);
    });

    test('should_give_what_next_returns_once_when_flat_mapping_a_right', () {
      // Arrange
      const result = Right<AppFailure, int>(3);
      var calls = 0;

      // Act
      final chained = result.flatMap((value) {
        calls++;
        return half(value);
      });

      // Assert
      expect(chained, const Left<AppFailure, int>(RuleFailure('odd')));
      expect(calls, 1);
    });

    test('should_chain_when_the_runtime_failure_type_is_narrower', () {
      // Arrange: a Left built with its own failure type, seen as the
      // Either<AppFailure, int> the use cases return. A method on the class
      // would check `next` against Either<NetworkFailure, int> and throw.
      const Either<AppFailure, int> narrowLeft = Left<NetworkFailure, int>(
        NetworkFailure(),
      );
      const Either<AppFailure, int> narrowRight = Right<NetworkFailure, int>(8);

      // Act
      final chained = [narrowLeft.flatMap(half), narrowRight.flatMap(half)];

      // Assert
      expect(chained, [
        const Left<AppFailure, int>(NetworkFailure()),
        const Right<AppFailure, int>(4),
      ]);
    });

    test('should_keep_the_failure_without_calling_next_when_flat_mapping_a_'
        'left', () {
      // Arrange
      const result = Left<AppFailure, int>(NetworkFailure());
      var calls = 0;

      // Act
      final chained = result.flatMap((value) {
        calls++;
        return half(value);
      });

      // Assert
      expect(chained, const Left<AppFailure, int>(NetworkFailure()));
      expect(calls, 0);
    });

    test('should_change_nothing_when_mapping_the_identity', () {
      // Arrange
      int identity(int value) => value;

      // Act
      final mapped = [for (final sample in samples) sample.map(identity)];

      // Assert
      expect(mapped, samples);
    });

    test(
      'should_be_the_same_when_mapping_twice_or_mapping_the_composition',
      () {
        // Arrange
        int twice(int value) => value * 2;
        String described(int value) => 'value $value';

        // Act
        final inSteps = [
          for (final sample in samples) sample.map(twice).map(described),
        ];
        final composed = [
          for (final sample in samples)
            sample.map((value) => described(twice(value))),
        ];

        // Assert
        expect(inSteps, composed);
      },
    );

    test('should_be_the_step_itself_when_flat_mapping_a_new_right', () {
      // Arrange
      const values = [8, 3, 0];

      // Act
      final chained = [
        for (final value in values) Right<AppFailure, int>(value).flatMap(half),
      ];

      // Assert
      expect(chained, [for (final value in values) half(value)]);
    });

    test('should_change_nothing_when_flat_mapping_into_a_right', () {
      // Arrange
      Either<AppFailure, int> unit(int value) => Right(value);

      // Act
      final chained = [for (final sample in samples) sample.flatMap(unit)];

      // Assert
      expect(chained, samples);
    });

    test(
      'should_be_the_same_however_the_steps_are_grouped_when_flat_mapping',
      () {
        // Arrange
        // 8 goes through both steps, 0 fails at the second, 3 at the first.
        const inputs = <Either<AppFailure, int>>[
          Right(8),
          Right(0),
          Right(3),
          Left(NetworkFailure()),
        ];

        // Act
        final leftGrouped = [
          for (final input in inputs) input.flatMap(half).flatMap(minusOne),
        ];
        final rightGrouped = [
          for (final input in inputs)
            input.flatMap((value) => half(value).flatMap(minusOne)),
        ];

        // Assert
        expect(leftGrouped, rightGrouped);
      },
    );
  });
}
