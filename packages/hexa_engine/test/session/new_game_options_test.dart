import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

void main() {
  group('D-124', () {
    test('should_keep_the_seed_when_it_is_the_smallest_32_bit_value', () {
      // Arrange
      const seed = 0;

      // Act
      final options = NewGameOptions(seed: seed);

      // Assert
      expect(options.seed, seed);
    });

    test('should_keep_the_seed_when_it_is_the_largest_32_bit_value', () {
      // Arrange
      const seed = Xorshift32.maxSeed;

      // Act
      final options = NewGameOptions(seed: seed);

      // Assert
      expect(options.seed, seed);
    });

    test('should_throw_when_the_seed_is_negative', () {
      // Arrange
      const seed = -1;

      // Act
      NewGameOptions build() => NewGameOptions(seed: seed);

      // Assert
      expect(
        build,
        throwsA(isA<ArgumentError>().having((e) => e.name, 'name', 'seed')),
      );
    });

    test('should_throw_when_the_seed_does_not_fit_in_32_bits', () {
      // Arrange
      const seed = Xorshift32.maxSeed + 1;

      // Act
      NewGameOptions build() => NewGameOptions(seed: seed);

      // Assert
      expect(
        build,
        throwsA(isA<ArgumentError>().having((e) => e.name, 'name', 'seed')),
      );
    });

    test('should_be_equal_when_the_seeds_are_equal', () {
      // Arrange
      final options = NewGameOptions(seed: 42);

      // Act
      final same = NewGameOptions(seed: 42);

      // Assert
      expect(same, options);
      expect(same.hashCode, options.hashCode);
    });

    test('should_differ_when_the_seeds_differ', () {
      // Arrange
      final options = NewGameOptions(seed: 42);

      // Act
      final other = NewGameOptions(seed: 43);

      // Assert
      expect(other, isNot(options));
    });
  });
}
