import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

/// The first [count] values that [generator] produces, in order.
List<int> valuesOf(Xorshift32 generator, int count) {
  final values = <int>[];
  var current = generator;
  for (var i = 0; i < count; i++) {
    final (value, after) = current.next();
    values.add(value);
    current = after;
  }
  return values;
}

void main() {
  // Every expected value below comes from tools/reference-sim (levelkit.Rng).

  group('E-COM-1', () {
    test('should_produce_the_example_sequence_when_the_seed_is_12345', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      final values = valuesOf(generator, 4);

      // Assert
      expect(values, [3336926330, 1697253807, 2816511904, 1955480042]);
    });
  });

  group('RN-COM-43', () {
    test('should_use_a_fixed_nonzero_state_when_the_seed_is_zero', () {
      // Arrange
      final generator = Xorshift32(0);

      // Act
      final values = valuesOf(generator, 3);

      // Assert
      expect(generator.state, 0x9E3779B9);
      expect(values, [1359758873, 3761132862, 2075758394]);
    });

    test('should_accept_the_largest_32_bit_seed_when_building_it', () {
      // Arrange
      final generator = Xorshift32(0xFFFFFFFF);

      // Act
      final values = valuesOf(generator, 2);

      // Assert
      expect(values, [253983, 4228382207]);
    });

    test('should_throw_when_the_seed_does_not_fit_in_32_bits', () {
      // Arrange
      const tooLarge = 0x100000000;
      const negative = -1;

      // Act
      Xorshift32 build(int seed) => Xorshift32(seed);

      // Assert
      expect(() => build(tooLarge), throwsArgumentError);
      expect(() => build(negative), throwsArgumentError);
    });

    test('should_keep_every_value_in_32_bits_when_drawing_many', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      final values = valuesOf(generator, 1000);

      // Assert
      expect(values.every((v) => v > 0 && v <= 0xFFFFFFFF), isTrue);
    });
  });

  group('RN-COM-41', () {
    test('should_produce_the_same_sequence_when_the_seed_is_the_same', () {
      // Arrange
      final first = Xorshift32(987654321);
      final second = Xorshift32(987654321);

      // Act
      final fromFirst = valuesOf(first, 50);
      final fromSecond = valuesOf(second, 50);

      // Assert
      expect(fromFirst, fromSecond);
    });
  });

  group('RN-COM-42', () {
    test('should_not_change_when_a_value_is_drawn_from_it', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      final (first, _) = generator.next();
      final (again, _) = generator.next();

      // Assert
      expect(again, first);
      expect(generator, Xorshift32(12345));
    });

    test('should_continue_the_sequence_when_rebuilt_from_its_state', () {
      // Arrange
      final (_, afterOne) = Xorshift32(12345).next();

      // Act
      final restored = Xorshift32(afterOne.state);

      // Assert
      expect(restored, afterOne);
      expect(valuesOf(restored, 3), [1697253807, 2816511904, 1955480042]);
    });

    test('should_be_equal_only_when_the_state_is_the_same', () {
      // Arrange
      final generator = Xorshift32(12345);
      final (_, after) = generator.next();

      // Act
      final equalToItself = generator == Xorshift32(12345);
      final equalToNext = generator == after;

      // Assert
      expect(equalToItself, isTrue);
      expect(generator.hashCode, Xorshift32(12345).hashCode);
      expect(equalToNext, isFalse);
    });
  });

  group('RN-COM-44', () {
    test('should_return_the_next_value_mod_n_when_choosing_among_n', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      final (choice, after) = generator.nextInt(7);

      // Assert
      expect(choice, 3336926330 % 7);
      expect(after, generator.next().$2);
    });

    test('should_succeed_only_when_the_value_mod_100_is_below_p', () {
      // Arrange: the first value mod 100 is 30.
      final generator = Xorshift32(12345);

      // Act
      final (at31, after) = generator.chance(31);
      final (at30, _) = generator.chance(30);

      // Assert
      expect(at31, isTrue);
      expect(at30, isFalse);
      expect(after, generator.next().$2);
    });

    test('should_never_succeed_when_the_percent_is_0', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      final (happened, _) = generator.chance(0);

      // Assert
      expect(happened, isFalse);
    });

    test('should_always_succeed_when_the_percent_is_100', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      final (happened, _) = generator.chance(100);

      // Assert
      expect(happened, isTrue);
    });

    test('should_throw_when_choosing_among_no_options', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      (int, Xorshift32) choose(int n) => generator.nextInt(n);

      // Assert
      expect(() => choose(0), throwsArgumentError);
      expect(() => choose(-3), throwsArgumentError);
    });

    test('should_throw_when_the_percent_is_outside_0_to_100', () {
      // Arrange
      final generator = Xorshift32(12345);

      // Act
      (bool, Xorshift32) tryChance(int p) => generator.chance(p);

      // Assert
      expect(() => tryChance(-1), throwsArgumentError);
      expect(() => tryChance(101), throwsArgumentError);
    });
  });
}
