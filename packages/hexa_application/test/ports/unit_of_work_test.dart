import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  group('D-171', () {
    test('should_end_the_unit_normally_when_work_returns_a_right', () async {
      // Arrange
      final unitOfWork = FakeUnitOfWork();

      // Act
      final result = await unitOfWork.runEither(
        () async => const Right<AppFailure, int>(7),
      );

      // Assert
      expect(result, const Right<AppFailure, int>(7));
      expect(unitOfWork.failed, 0);
    });

    test(
      'should_fail_the_unit_and_return_the_same_left_when_work_returns_a_left',
      () async {
        // Arrange
        final unitOfWork = FakeUnitOfWork();

        // Act
        final result = await unitOfWork.runEither(
          () async => const Left<AppFailure, int>(RuleFailure('worse')),
        );

        // Assert: a failed unit is the one the database rolls back.
        expect(result, const Left<AppFailure, int>(RuleFailure('worse')));
        expect(unitOfWork.failed, 1);
      },
    );

    test('should_let_the_exception_through_when_work_throws', () async {
      // Arrange
      final unitOfWork = FakeUnitOfWork();

      // Act
      final result = unitOfWork.runEither<int>(
        () async => throw const PersistenceException(),
      );

      // Assert
      await expectLater(result, throwsA(isA<PersistenceException>()));
      expect(unitOfWork.failed, 1);
    });

    test(
      'should_return_the_left_when_its_runtime_failure_type_is_narrower',
      () async {
        // Arrange: a Left built with its own failure type, as in D-170.
        final unitOfWork = FakeUnitOfWork();
        Future<Either<AppFailure, int>> refuse() async =>
            const Left<RuleFailure, int>(RuleFailure('worse'));

        // Act
        final result = await unitOfWork.runEither(refuse);

        // Assert
        expect(result, const Left<RuleFailure, int>(RuleFailure('worse')));
        expect(unitOfWork.failed, 1);
      },
    );
  });
}
