import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

void main() {
  const game = GameKey('fake-game', 'fake-shape');
  final t1 = DateTime.utc(2026, 11, 25, 10);
  final t2 = DateTime.utc(2026, 11, 25, 11);

  group('D-45', () {
    test('should_equal_another_attempt_when_all_fields_match', () {
      // Arrange
      final a = LevelAttempt(
        moves: 3,
        achievedAt: t1,
        stars: 3,
        timeMs: 28000,
        score: null,
      );
      final b = LevelAttempt(moves: 3, achievedAt: t1, stars: 3, timeMs: 28000);
      final c = LevelAttempt(moves: 4, achievedAt: t1, stars: 3, timeMs: 28000);

      // Act & Assert
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(a.toString(), contains('moves: 3'));
    });

    test(
      'should_equal_another_levels_progress_when_entries_match_in_any_order',
      () {
        // Arrange
        final attempt1 = LevelAttempt(moves: 3, achievedAt: t1, stars: 3);
        final attempt2 = LevelAttempt(moves: 5, achievedAt: t2, score: 210);
        final a = LevelsProgress({'lvl-001': attempt1, 'lvl-002': attempt2});
        final b = LevelsProgress({'lvl-002': attempt2, 'lvl-001': attempt1});
        final c = LevelsProgress({'lvl-001': attempt1});

        // Act & Assert
        expect(a, b);
        expect(a.hashCode, b.hashCode);
        expect(a, isNot(c));
        expect(a.toString(), contains('lvl-001'));
      },
    );

    test(
      'should_keep_levels_unmodifiable_when_source_map_is_mutated_or_edited',
      () {
        // Arrange
        final source = <String, LevelAttempt>{
          'lvl-001': LevelAttempt(moves: 3, achievedAt: t1),
        };
        final progress = LevelsProgress(source);

        // Act
        source['lvl-002'] = LevelAttempt(moves: 4, achievedAt: t2);

        // Assert
        expect(progress.levels.keys, ['lvl-001']);
        expect(
          () => progress.levels['lvl-003'] = LevelAttempt(
            moves: 1,
            achievedAt: t1,
          ),
          throwsUnsupportedError,
        );
      },
    );

    test('should_equal_another_game_result_when_fields_match', () {
      // Arrange
      const model = _FakeAttemptModel();
      const scoreA = HighScoreResult(game, 100);
      const scoreB = HighScoreResult(game, 100);
      const levelA = LevelCompletedResult(
        game,
        levelId: 'lvl-001',
        moves: 3,
        stars: 3,
        timeMs: 28000,
        model: model,
      );
      const levelB = LevelCompletedResult(
        game,
        levelId: 'lvl-001',
        moves: 3,
        stars: 3,
        timeMs: 28000,
        model: model,
      );

      // Act & Assert
      expect(scoreA, scoreB);
      expect(scoreA.hashCode, scoreB.hashCode);
      expect(levelA, levelB);
      expect(levelA.hashCode, levelB.hashCode);
      expect(scoreA, isNot(levelA));
    });
  });
}

final class _FakeAttemptModel implements IProgressModel<LevelAttempt> {
  const _FakeAttemptModel();

  @override
  int compare(LevelAttempt a, LevelAttempt b) => a.moves.compareTo(b.moves);
}
