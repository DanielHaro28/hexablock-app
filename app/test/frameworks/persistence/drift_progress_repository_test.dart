import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/frameworks/persistence/app_database.dart';
import 'package:hexablock_app/frameworks/persistence/drift_profile_repository.dart';
import 'package:hexablock_app/frameworks/persistence/drift_progress_repository.dart';

void main() {
  const linesHex = GameKey('hexa-lines', 'hex');
  const linesSquare = GameKey('hexa-lines', 'square');
  const mergeHex = GameKey('hexa-merge', 'hex');
  const fitHex = GameKey('hexa-fit', 'hex');
  const sortHex = GameKey('hexa-sort', 'hex');
  final date = DateTime.utc(2026, 11, 25, 12, 30, 15, 250);
  final later = DateTime.utc(2026, 11, 25, 13, 0);

  late AppDatabase db;
  late DriftProfileRepository profiles;
  late DriftProgressRepository repository;

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(),
      clock: FakeClock(startDate: date),
    );
    profiles = DriftProfileRepository(db);
    repository = DriftProgressRepository(db);
  });

  tearDown(() async => db.close());

  group('RN-COM-80', () {
    test('should_return_null_when_nothing_was_saved', () async {
      // Arrange & Act
      final loaded = await repository.load(ProfileId.guest, linesHex);

      // Assert
      expect(loaded, isNull);
    });

    test(
      'should_save_and_load_high_score_with_utc_timestamp_when_record_exists',
      () async {
        // Arrange
        final record = HighScoreProgress(1240, date);

        // Act
        await repository.save(ProfileId.guest, linesHex, record);
        final loaded = await repository.load(ProfileId.guest, linesHex);

        // Assert
        expect(
          loaded,
          isA<HighScoreProgress>().having(
            (p) => p.achievedAt.isUtc,
            'isUtc',
            isTrue,
          ),
        );
        expect(loaded, record);
      },
    );

    test(
      'should_save_and_load_levels_progress_with_optional_metrics',
      () async {
        // Arrange
        final fitLevels = LevelsProgress({
          'fit-hex-001': LevelAttempt(
            moves: 3,
            stars: 3,
            timeMs: 28000,
            achievedAt: date,
          ),
          'fit-hex-002': LevelAttempt(
            moves: 6,
            stars: 2,
            timeMs: 45000,
            achievedAt: later,
          ),
        });
        final sortLevels = LevelsProgress({
          'sort-hex-001': LevelAttempt(moves: 10, score: 224, achievedAt: date),
        });

        // Act
        await repository.save(ProfileId.guest, fitHex, fitLevels);
        await repository.save(ProfileId.guest, sortHex, sortLevels);

        // Assert
        expect(await repository.load(ProfileId.guest, fitHex), fitLevels);
        expect(await repository.load(ProfileId.guest, sortHex), sortLevels);
      },
    );

    test('should_isolate_progress_by_profile_variant_and_topology', () async {
      // Arrange
      final account = Profile(
        id: const ProfileId('user-7'),
        kind: ProfileKind.account,
        displayName: 'Beto',
        createdAt: date,
      );
      await profiles.activate(account);
      final guestLines = HighScoreProgress(100, date);
      final guestSquare = HighScoreProgress(200, date);
      final guestMerge = HighScoreProgress(300, date);
      final accountLines = HighScoreProgress(900, date);

      // Act
      await repository.save(ProfileId.guest, linesHex, guestLines);
      await repository.save(ProfileId.guest, linesSquare, guestSquare);
      await repository.save(ProfileId.guest, mergeHex, guestMerge);
      await repository.save(account.id, linesHex, accountLines);

      // Assert
      expect(await repository.load(ProfileId.guest, linesHex), guestLines);
      expect(await repository.load(ProfileId.guest, linesSquare), guestSquare);
      expect(await repository.load(ProfileId.guest, mergeHex), guestMerge);
      expect(await repository.load(account.id, linesHex), accountLines);
    });

    test(
      'should_persist_progress_after_closing_and_reopening_database_offline',
      () async {
        // Arrange
        final tempDir = Directory.systemTemp.createTempSync('prg03_drift_');
        addTearDown(() => tempDir.deleteSync(recursive: true));
        final dbFile = File('${tempDir.path}/hexablock.sqlite');
        final record = HighScoreProgress(1500, date);
        final levels = LevelsProgress({
          'fit-hex-001': LevelAttempt(
            moves: 3,
            stars: 3,
            timeMs: 38000,
            achievedAt: date,
          ),
        });
        await db.close();
        final previousWarning =
            driftRuntimeOptions.dontWarnAboutMultipleDatabases;
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
        addTearDown(
          () => driftRuntimeOptions.dontWarnAboutMultipleDatabases =
              previousWarning,
        );

        final firstDb = AppDatabase(NativeDatabase(dbFile));
        final firstRepo = DriftProgressRepository(firstDb);
        await firstRepo.save(ProfileId.guest, linesHex, record);
        await firstRepo.save(ProfileId.guest, fitHex, levels);
        await firstDb.close();

        // Act
        final reopenedDb = AppDatabase(NativeDatabase(dbFile));
        addTearDown(reopenedDb.close);
        final reopenedRepo = DriftProgressRepository(reopenedDb);
        final loadedRecord = await reopenedRepo.load(ProfileId.guest, linesHex);
        final loadedLevels = await reopenedRepo.load(ProfileId.guest, fitHex);

        // Assert
        expect(loadedRecord, record);
        expect(loadedLevels, levels);
      },
    );
  });

  group('D-49', () {
    test(
      'should_mark_record_pending_and_increment_revision_on_each_update',
      () async {
        // Arrange
        await repository.save(
          ProfileId.guest,
          linesHex,
          HighScoreProgress(100, date),
        );
        final firstRow = await db.select(db.records).getSingle();

        // Act
        await repository.save(
          ProfileId.guest,
          linesHex,
          HighScoreProgress(250, later),
        );
        final secondRow = await db.select(db.records).getSingle();

        // Assert
        expect(firstRow.pending, isTrue);
        expect(firstRow.revision, 1);
        expect(secondRow.pending, isTrue);
        expect(secondRow.revision, 2);
        expect(secondRow.score, 250);
      },
    );

    test(
      'should_increment_revision_only_for_changed_levels_when_saving_levels',
      () async {
        // Arrange
        final firstAttempt = LevelAttempt(
          moves: 4,
          stars: 2,
          timeMs: 30000,
          achievedAt: date,
        );
        await repository.save(
          ProfileId.guest,
          fitHex,
          LevelsProgress({'fit-hex-001': firstAttempt}),
        );
        await (db.update(db.levelResults)
              ..where((row) => row.levelId.equals('fit-hex-001')))
            .write(const LevelResultsCompanion(pending: Value(false)));

        // Act: level 1 stays identical, level 2 is newly added.
        await repository.save(
          ProfileId.guest,
          fitHex,
          LevelsProgress({
            'fit-hex-001': firstAttempt,
            'fit-hex-002': LevelAttempt(
              moves: 3,
              stars: 3,
              timeMs: 25000,
              achievedAt: later,
            ),
          }),
        );
        final rows = await db.select(db.levelResults).get();
        final row1 = rows.singleWhere((r) => r.levelId == 'fit-hex-001');
        final row2 = rows.singleWhere((r) => r.levelId == 'fit-hex-002');

        // Assert
        expect(row1.pending, isFalse);
        expect(row1.revision, 1);
        expect(row2.pending, isTrue);
        expect(row2.revision, 1);
      },
    );
  });

  group('RNF-35', () {
    test(
      'should_cascade_delete_progress_when_owning_profile_is_deleted',
      () async {
        // Arrange
        final account = Profile(
          id: const ProfileId('user-temp'),
          kind: ProfileKind.account,
          displayName: 'Caro',
          createdAt: date,
        );
        await profiles.activate(account);
        await repository.save(
          account.id,
          linesHex,
          HighScoreProgress(100, date),
        );
        await repository.save(
          account.id,
          fitHex,
          LevelsProgress({
            'fit-hex-001': LevelAttempt(moves: 3, stars: 3, achievedAt: date),
          }),
        );

        // Act
        await (db.delete(
          db.profiles,
        )..where((row) => row.id.equals(account.id.value))).go();

        // Assert
        expect(await db.select(db.records).get(), isEmpty);
        expect(await db.select(db.levelResults).get(), isEmpty);
      },
    );

    test(
      'should_throw_persistence_exception_when_saving_for_missing_profile',
      () async {
        // Arrange
        await repository.save(
          ProfileId.guest,
          linesHex,
          HighScoreProgress(50, date),
        );

        // Act & Assert
        await expectLater(
          repository.save(
            const ProfileId('missing'),
            linesHex,
            HighScoreProgress(999, date),
          ),
          throwsA(isA<PersistenceException>()),
        );
        expect(
          await repository.load(ProfileId.guest, linesHex),
          HighScoreProgress(50, date),
        );
      },
    );

    test(
      'should_roll_back_whole_transaction_when_a_level_write_fails',
      () async {
        // Arrange: reject level 'fit-hex-bad' via trigger so the 2nd insert
        // fails inside the transaction after the 1st insert succeeds.
        await db.customStatement('''
          CREATE TRIGGER reject_bad_level
          BEFORE INSERT ON level_results
          WHEN NEW.level_id = 'fit-hex-bad'
          BEGIN
            SELECT RAISE(ABORT, 'simulated failure');
          END;
        ''');

        // Act & Assert
        await expectLater(
          repository.save(
            ProfileId.guest,
            fitHex,
            LevelsProgress({
              'fit-hex-001': LevelAttempt(moves: 3, stars: 3, achievedAt: date),
              'fit-hex-bad': LevelAttempt(
                moves: 4,
                stars: 2,
                achievedAt: later,
              ),
            }),
          ),
          throwsA(isA<PersistenceException>()),
        );
        expect(await repository.load(ProfileId.guest, fitHex), isNull);
      },
    );
  });
}
