import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/frameworks/persistence/app_database.dart';
import 'package:hexablock_app/frameworks/persistence/drift_profile_repository.dart';
import 'package:hexablock_app/frameworks/persistence/drift_progress_repository.dart';
import 'package:hexablock_app/frameworks/persistence/drift_unit_of_work.dart';

void main() {
  const linesHex = GameKey('hexa-lines', 'hex');
  final date = DateTime.utc(2026, 11, 25, 12);

  late AppDatabase db;
  late DriftProgressRepository progress;
  late DriftUnitOfWork unitOfWork;

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(),
      clock: FakeClock(startDate: date),
    );
    progress = DriftProgressRepository(db);
    unitOfWork = DriftUnitOfWork(db);
  });

  tearDown(() async => db.close());

  group('D-158', () {
    test('should_keep_nothing_when_the_unit_fails_after_a_write', () async {
      // Arrange
      Future<void> saveThenFail() async {
        await progress.save(
          ProfileId.guest,
          linesHex,
          HighScoreProgress(300, date),
        );
        throw const PersistenceException();
      }

      // Act & Assert
      await expectLater(
        unitOfWork.run(saveThenFail),
        throwsA(isA<PersistenceException>()),
      );
      expect(await progress.load(ProfileId.guest, linesHex), isNull);
    });

    test('should_return_what_the_unit_returns_when_it_succeeds', () async {
      // Act
      final result = await unitOfWork.run(() async {
        await progress.save(
          ProfileId.guest,
          linesHex,
          HighScoreProgress(300, date),
        );
        return 'done';
      });

      // Assert
      expect(result, 'done');
      expect(
        await progress.load(ProfileId.guest, linesHex),
        HighScoreProgress(300, date),
      );
    });

    test(
      'should_keep_the_best_record_when_two_results_are_saved_at_once',
      () async {
        // Arrange: the use case the app builds, over the real database.
        final useCase = SaveProgressUseCase(
          progress,
          DriftProfileRepository(db),
          FakeClock(startDate: date),
          unitOfWork,
        );

        // Act: neither waits for the other.
        await Future.wait([
          useCase.execute(const HighScoreResult(linesHex, 100)),
          useCase.execute(const HighScoreResult(linesHex, 50)),
        ]);

        // Assert
        expect(
          await progress.load(ProfileId.guest, linesHex),
          HighScoreProgress(100, date),
        );
      },
    );
  });
}
