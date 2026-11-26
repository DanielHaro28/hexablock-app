import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// A service that adds [value] to its command, returns [failure] or throws
/// [error].
final class _StubService implements ICommandService<int, int> {
  _StubService({this.value = 0, this.failure, this.error});

  final int value;
  final AppFailure? failure;
  final Object? error;

  @override
  Future<Either<AppFailure, int>> execute(int command) async {
    if (error case final error?) throw error;
    if (failure case final failure?) return Left(failure);
    return Right(command + value);
  }
}

void main() {
  group('D-161', () {
    test(
      'should_return_the_right_unchanged_when_the_service_succeeds',
      () async {
        // Arrange
        final aspect = ExceptionAspect(
          _StubService(value: 1),
          FakeLogger(),
          name: 'test',
        );

        // Act
        final result = await aspect.execute(41);

        // Assert
        expect(result, const Right<AppFailure, int>(42));
      },
    );

    test(
      'should_return_the_left_unchanged_when_the_service_returns_a_failure',
      () async {
        // Arrange
        final aspect = ExceptionAspect(
          _StubService(failure: const RuleFailure('no-saved-game')),
          FakeLogger(),
          name: 'test',
        );

        // Act
        final result = await aspect.execute(0);

        // Assert
        expect(
          result,
          const Left<AppFailure, int>(RuleFailure('no-saved-game')),
        );
      },
    );

    test(
      'should_log_the_error_type_and_stack_when_the_error_is_unexpected',
      () async {
        // Arrange
        final logger = FakeLogger();
        final error = StateError('bug');
        final aspect = ExceptionAspect(
          _StubService(error: error),
          logger,
          name: 'SaveProgress',
        );

        // Act
        await aspect.execute(0);

        // Assert
        final entry = logger.entries.single;
        expect(entry.level, LogLevel.error);
        expect(entry.message, 'SaveProgress unexpected error');
        expect(entry.data, {'error': 'StateError'});
        expect(entry.error, same(error));
        expect(entry.stackTrace, isNotNull);
      },
    );

    test(
      'should_log_nothing_when_the_service_throws_an_app_exception',
      () async {
        // Arrange: the logging aspect, outside, logs the Left.
        final logger = FakeLogger();
        final aspect = ExceptionAspect(
          _StubService(error: const PersistenceException()),
          logger,
          name: 'SaveProgress',
        );

        // Act
        await aspect.execute(0);

        // Assert
        expect(logger.entries, isEmpty);
      },
    );

    final cases = <String, (Object, AppFailure)>{
      'network': (const NetworkException(), const NetworkFailure()),
      'session_expired': (
        const SessionExpiredException(),
        const SessionFailure(expired: true),
      ),
      'conflict': (
        const ConflictException('email-taken'),
        const ConflictFailure('email-taken'),
      ),
      'validation': (
        const ValidationException({'/email': 'format'}),
        const ValidationFailure({'/email': 'format'}),
      ),
      'persistence': (const PersistenceException(), const PersistenceFailure()),
      'unexpected': (StateError('bug'), const UnexpectedFailure()),
    };
    test('should_give_equal_failures_the_same_hash_when_compared', () {
      // Arrange
      AppFailure copyOf(AppFailure failure) => switch (failure) {
        NetworkFailure() => const NetworkFailure(),
        SessionFailure(:final expired) => SessionFailure(expired: expired),
        ConflictFailure(:final code) => ConflictFailure(code),
        ValidationFailure(:final fields) => ValidationFailure({...fields}),
        PersistenceFailure() => const PersistenceFailure(),
        RuleFailure(:final code) => RuleFailure(code),
        UnexpectedFailure() => const UnexpectedFailure(),
      };
      final failures = [
        for (final (_, failure) in cases.values) failure,
        const RuleFailure('no-saved-game'),
      ];

      // Act
      final copies = [for (final failure in failures) copyOf(failure)];

      // Assert
      for (final (index, failure) in failures.indexed) {
        expect(copies[index], failure);
        expect(copies[index].hashCode, failure.hashCode);
      }
    });

    for (final MapEntry(key: name, value: (error, failure)) in cases.entries) {
      test(
        'should_return_the_matching_left_when_the_service_throws_$name',
        () async {
          // Arrange
          final aspect = ExceptionAspect(
            _StubService(error: error),
            FakeLogger(),
            name: 'test',
          );

          // Act
          final result = await aspect.execute(0);

          // Assert
          expect(result, Left<AppFailure, int>(failure));
        },
      );
    }
  });
}
