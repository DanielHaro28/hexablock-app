import 'package:hexa_application/hexa_application.dart';
import 'package:test/test.dart';

/// A use case that returns [value] or throws [error].
final class _StubUseCase implements UseCase<int, int> {
  _StubUseCase({this.value = 0, this.error});

  final int value;
  final Object? error;

  @override
  Future<int> execute(int input) async {
    if (error case final error?) throw error;
    return input + value;
  }
}

void main() {
  group('D-39', () {
    test(
      'should_return_success_with_the_value_when_the_use_case_succeeds',
      () async {
        // Arrange
        final aspect = ErrorHandlingAspect(_StubUseCase(value: 1));

        // Act
        final result = await aspect.execute(41);

        // Assert
        expect(result, isA<Success<int>>().having((r) => r.value, 'value', 42));
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
      'rule': (
        const RuleException('no-saved-game'),
        const RuleFailure('no-saved-game'),
      ),
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
      final failures = [for (final (_, failure) in cases.values) failure];

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
        'should_return_the_matching_failure_when_the_error_is_$name',
        () async {
          // Arrange
          final aspect = ErrorHandlingAspect(_StubUseCase(error: error));

          // Act
          final result = await aspect.execute(0);

          // Assert
          expect(
            result,
            isA<Failure<int>>().having((r) => r.error, 'error', failure),
          );
        },
      );
    }
  });
}
