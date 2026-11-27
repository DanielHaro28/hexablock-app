import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// The engine's fake family passes the same contract as every real
/// factory, with and without levels, so the level-based tests of the
/// contract run before the first real level-based factory exists (D-125).
void main() {
  group('D-116, FakeVariantFamily', () {
    checkVariantFamilyContract(
      FakeVariantFamily.new,
      NewGameOptions(seed: 7),
      usesChance: false,
      levelBased: false,
    );
  });

  group('D-125, FakeVariantFamily by levels', () {
    checkVariantFamilyContract(
      () => FakeVariantFamily(levels: const {'level-001': 3, 'level-002': 4}),
      NewGameOptions(seed: 7, levelId: 'level-002'),
      usesChance: false,
      levelBased: true,
    );
  });

  group('D-125', () {
    test('should_throw_when_a_level_based_contract_has_no_level', () {
      // Arrange
      final options = NewGameOptions(seed: 7);

      // Act
      void register() => checkVariantFamilyContract(
        () => FakeVariantFamily(levels: const {'level-001': 3}),
        options,
        usesChance: false,
        levelBased: true,
      );

      // Assert
      expect(register, throwsArgumentError);
    });

    test('should_use_the_width_of_the_level_when_the_game_is_new', () {
      // Arrange
      final family = FakeVariantFamily(levels: const {'level-002': 4});

      // Act
      final session = family.createSession(
        NewGameOptions(seed: 7, levelId: 'level-002'),
      );
      addTearDown(session.engine.close);

      // Assert
      expect(session.engine.state.board.cells, hasLength(4));
    });
  });
}
