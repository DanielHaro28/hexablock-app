import 'package:drift/drift.dart';
import 'package:hexa_application/hexa_application.dart';

import 'app_database.dart';
import 'drift_error.dart';

/// Persists variant progress in SQLite via Drift (ARQ-04 §2, RN-COM-80,
/// RNF-35).
final class DriftProgressRepository implements IProgressRepository {
  /// Creates a progress repository backed by [_db].
  const DriftProgressRepository(this._db);

  final AppDatabase _db;

  @override
  Future<VariantProgress?> load(ProfileId profile, GameKey game) => runDrift(
    () async {
      final record = await (_db.select(
        _db.records,
      )..where((row) => _matchesRecord(row, profile, game))).getSingleOrNull();
      if (record != null) {
        return HighScoreProgress(
          record.score,
          DateTime.fromMillisecondsSinceEpoch(record.achievedAt, isUtc: true),
        );
      }

      final levelRows = await (_db.select(
        _db.levelResults,
      )..where((row) => _matchesLevelGame(row, profile, game))).get();
      if (levelRows.isEmpty) return null;

      return LevelsProgress({
        for (final row in levelRows)
          row.levelId: LevelAttempt(
            moves: row.moves,
            stars: row.stars,
            timeMs: row.timeMs,
            score: row.score,
            achievedAt: DateTime.fromMillisecondsSinceEpoch(
              row.achievedAt,
              isUtc: true,
            ),
          ),
      });
    },
  );

  @override
  Future<void> save(
    ProfileId profile,
    GameKey game,
    VariantProgress progress,
  ) => runDrift(
    () => _db.transaction(() async {
      switch (progress) {
        case HighScoreProgress(:final score, :final achievedAt):
          final existing =
              await (_db.select(_db.records)
                    ..where((row) => _matchesRecord(row, profile, game)))
                  .getSingleOrNull();
          await _db
              .into(_db.records)
              .insertOnConflictUpdate(
                RecordsCompanion.insert(
                  profileId: profile.value,
                  gameId: game.gameId,
                  topology: game.topologyId,
                  score: score,
                  achievedAt: achievedAt.toUtc().millisecondsSinceEpoch,
                  pending: const Value(true),
                  revision: Value((existing?.revision ?? 0) + 1),
                ),
              );
        case LevelsProgress(:final levels):
          final existingRows = await (_db.select(
            _db.levelResults,
          )..where((row) => _matchesLevelGame(row, profile, game))).get();
          final existingById = {
            for (final row in existingRows) row.levelId: row,
          };
          for (final entry in levels.entries) {
            final attempt = entry.value;
            final previous = existingById[entry.key];
            if (previous != null && _sameAttempt(previous, attempt)) {
              continue;
            }
            await _db
                .into(_db.levelResults)
                .insertOnConflictUpdate(
                  LevelResultsCompanion.insert(
                    profileId: profile.value,
                    gameId: game.gameId,
                    topology: game.topologyId,
                    levelId: entry.key,
                    stars: Value(attempt.stars),
                    timeMs: Value(attempt.timeMs),
                    moves: attempt.moves,
                    score: Value(attempt.score),
                    achievedAt: attempt.achievedAt
                        .toUtc()
                        .millisecondsSinceEpoch,
                    pending: const Value(true),
                    revision: Value((previous?.revision ?? 0) + 1),
                  ),
                );
          }
      }
    }),
  );

  static Expression<bool> _matchesRecord(
    Records row,
    ProfileId profile,
    GameKey game,
  ) =>
      row.profileId.equals(profile.value) &
      row.gameId.equals(game.gameId) &
      row.topology.equals(game.topologyId);

  static Expression<bool> _matchesLevelGame(
    LevelResults row,
    ProfileId profile,
    GameKey game,
  ) =>
      row.profileId.equals(profile.value) &
      row.gameId.equals(game.gameId) &
      row.topology.equals(game.topologyId);

  static bool _sameAttempt(LevelResultRow row, LevelAttempt attempt) =>
      row.moves == attempt.moves &&
      row.stars == attempt.stars &&
      row.timeMs == attempt.timeMs &&
      row.score == attempt.score &&
      row.achievedAt == attempt.achievedAt.toUtc().millisecondsSinceEpoch;
}
