import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// A sign-in command with sensitive fields, as a login would get.
typedef _Credentials = ({String email, String password});

/// A service that takes [took] on [clock] and then returns [result].
final class _TimedService implements ICommandService<_Credentials, String> {
  _TimedService(this.clock, this.result, {this.took = Duration.zero});

  final FakeClock clock;
  final Either<AppFailure, String> result;
  final Duration took;

  @override
  Future<Either<AppFailure, String>> execute(_Credentials command) async {
    clock.advance(took);
    return result;
  }
}

/// Describes the whole command and result, so the redaction is what keeps
/// the secrets out.
final class _EverythingDescriber
    implements CommandDescriber<_Credentials, String> {
  const _EverythingDescriber();

  @override
  Map<String, Object?> command(_Credentials command) => {
    'email': command.email,
    'password': command.password,
    'note': 'sent by ${command.email}',
  };

  @override
  Map<String, Object?> result(String result) => {'token': result};
}

/// A describer that takes [took] on [clock] to describe the command, as a
/// description of a whole board can.
final class _SlowDescriber implements CommandDescriber<_Credentials, String> {
  _SlowDescriber(this.clock, this.took);

  final FakeClock clock;
  final Duration took;

  @override
  Map<String, Object?> command(_Credentials command) {
    clock.advance(took);
    return const {};
  }

  @override
  Map<String, Object?> result(String result) => const {};
}

/// A describer whose description throws, as a broken `toString` would.
final class _ThrowingDescriber
    implements CommandDescriber<_Credentials, String> {
  const _ThrowingDescriber();

  @override
  Map<String, Object?> command(_Credentials command) => throw StateError('x');

  @override
  Map<String, Object?> result(String result) => throw StateError('x');
}

void main() {
  const credentials = (email: 'player@example.test', password: 'secret-1');

  LoggingAspect<_Credentials, String> aspectOf(
    FakeLogger logger,
    FakeClock clock,
    Either<AppFailure, String> result, {
    Duration took = Duration.zero,
    bool verbose = false,
  }) => LoggingAspect(
    _TimedService(clock, result, took: took),
    logger,
    clock,
    name: 'Login',
    describe: const _EverythingDescriber(),
    verbose: verbose,
  );

  group('RNF-10', () {
    test('should_log_start_and_finish_when_the_service_succeeds', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(logger, FakeClock(), const Right('token-1'));

      // Act
      await aspect.execute(credentials);

      // Assert
      expect(logger.messages, ['Login started', 'Login finished']);
      expect(logger.entries.map((e) => e.level), [
        LogLevel.debug,
        LogLevel.info,
      ]);
    });

    test('should_log_the_duration_when_the_service_finishes', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(
        logger,
        FakeClock(),
        const Right('token-1'),
        took: const Duration(milliseconds: 42),
      );

      // Act
      await aspect.execute(credentials);

      // Assert
      expect(logger.entries.last.data['ms'], 42);
    });
  });

  group('D-173', () {
    test(
      'should_not_count_the_description_of_the_command_in_the_duration',
      () async {
        // Arrange: describing the command takes 30 ms, the service 2 ms.
        final logger = FakeLogger();
        final clock = FakeClock();
        final aspect = LoggingAspect(
          _TimedService(
            clock,
            const Right('token-1'),
            took: const Duration(milliseconds: 2),
          ),
          logger,
          clock,
          name: 'Login',
          describe: _SlowDescriber(clock, const Duration(milliseconds: 30)),
          verbose: true,
        );

        // Act
        await aspect.execute(credentials);

        // Assert
        expect(logger.entries.last.data['ms'], 2);
      },
    );
  });

  group('RNF-10', () {
    test(
      'should_log_a_warning_with_the_failure_kind_when_the_service_fails',
      () async {
        // Arrange
        final logger = FakeLogger();
        final aspect = aspectOf(
          logger,
          FakeClock(),
          const Left(NetworkFailure()),
          took: const Duration(milliseconds: 5),
        );

        // Act
        await aspect.execute(credentials);

        // Assert
        final failed = logger.entries.last;
        expect(failed.message, 'Login failed');
        expect(failed.level, LogLevel.warning);
        expect(failed.data, {'ms': 5, 'failure': 'network'});
      },
    );

    test('should_log_the_rule_code_when_a_rule_stops_the_service', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(
        logger,
        FakeClock(),
        const Left(RuleFailure('no-saved-game')),
      );

      // Act
      await aspect.execute(credentials);

      // Assert
      expect(logger.entries.last.data, {
        'ms': 0,
        'failure': 'rule',
        'code': 'no-saved-game',
      });
    });

    test('should_return_what_the_service_returned_when_logging', () async {
      // Arrange
      final aspect = aspectOf(
        FakeLogger(),
        FakeClock(),
        const Left(PersistenceFailure()),
      );

      // Act
      final result = await aspect.execute(credentials);

      // Assert
      expect(result, const Left<AppFailure, String>(PersistenceFailure()));
    });
  });

  group('RNF-10', () {
    test('should_log_the_conflict_code_when_the_service_conflicts', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(
        logger,
        FakeClock(),
        const Left(ConflictFailure('email-taken')),
      );

      // Act
      await aspect.execute(credentials);

      // Assert
      expect(logger.entries.last.data, {
        'ms': 0,
        'failure': 'conflict',
        'code': 'email-taken',
      });
    });

    test(
      'should_log_the_fields_as_pointer_and_code_when_validation_fails_verbose',
      () async {
        // Arrange: '/email' is a pointer, not a secret, so it stays.
        final logger = FakeLogger();
        final aspect = aspectOf(
          logger,
          FakeClock(),
          const Left(ValidationFailure({'/email': 'format'})),
          verbose: true,
        );

        // Act
        await aspect.execute(credentials);

        // Assert
        expect(logger.entries.last.data['fields'], ['/email: format']);
      },
    );

    test(
      'should_log_the_describer_error_type_when_the_description_throws',
      () async {
        // Arrange
        final logger = FakeLogger();
        final aspect = LoggingAspect(
          _TimedService(FakeClock(), const Right('token-1')),
          logger,
          FakeClock(),
          name: 'Login',
          describe: const _ThrowingDescriber(),
          verbose: true,
        );

        // Act
        final result = await aspect.execute(credentials);

        // Assert
        expect(result, const Right<AppFailure, String>('token-1'));
        expect(logger.entries.first.data, {'describeError': 'StateError'});
      },
    );
  });

  group('SEC-MOB-05', () {
    test('should_log_no_details_when_not_verbose', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(logger, FakeClock(), const Right('token-1'));

      // Act
      await aspect.execute(credentials);

      // Assert
      expect(logger.entries.first.data, isEmpty);
      expect(logger.entries.last.data, {'ms': 0});
    });

    test('should_log_the_described_details_when_verbose', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(
        logger,
        FakeClock(),
        const Right('token-1'),
        verbose: true,
      );

      // Act
      await aspect.execute(credentials);

      // Assert
      expect(logger.entries.first.data.keys, ['email', 'password', 'note']);
      expect(logger.entries.last.data.keys, ['ms', 'token']);
    });
  });

  group('SEC-WEB-06', () {
    test('should_redact_password_and_token_when_logging_use_case', () async {
      // Arrange
      final logger = FakeLogger();
      final aspect = aspectOf(
        logger,
        FakeClock(),
        const Right('token-1'),
        verbose: true,
      );

      // Act
      await aspect.execute(credentials);

      // Assert
      final logged = '${logger.entries.map((e) => e.data).toList()}';
      expect(logged, isNot(contains('player@example.test')));
      expect(logged, isNot(contains('secret-1')));
      expect(logged, isNot(contains('token-1')));
      expect(logger.entries.first.data['note'], 'sent by ${Redactor.mask}');
    });
  });
}
