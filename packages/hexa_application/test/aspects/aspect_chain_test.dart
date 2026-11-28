import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// A service that returns its command.
final class _EchoService implements ICommandService<int, int> {
  const _EchoService();

  @override
  Future<Either<AppFailure, int>> execute(int command) async => Right(command);
}

/// A service that takes [took] on [clock] and returns its command.
final class _SlowService implements ICommandService<int, int> {
  _SlowService(this.clock, this.took);

  final FakeClock clock;
  final Duration took;

  @override
  Future<Either<AppFailure, int>> execute(int command) async {
    clock.advance(took);
    return Right(command);
  }
}

/// Describes the command as its value.
final class _ValueDescriber implements CommandDescriber<int, int> {
  const _ValueDescriber();

  @override
  Map<String, Object?> command(int command) => {'value': command};

  @override
  Map<String, Object?> result(int result) => {'value': result};
}

/// Describes the command and the result as their value, taking [took] on
/// [clock] each time, as a description of a whole board can.
final class _SlowDescriber implements CommandDescriber<int, int> {
  _SlowDescriber(this.clock, this.took);

  final FakeClock clock;
  final Duration took;

  @override
  Map<String, Object?> command(int command) {
    clock.advance(took);
    return {'value': command};
  }

  @override
  Map<String, Object?> result(int result) {
    clock.advance(took);
    return {'value': result};
  }
}

/// The kinds of the aspects around a service, outermost first.
List<Type> _kindsOf(ICommandService<Object?, Object?> service) => [
  for (Object? node = service; node is Aspect; node = node.inner) node.kind,
];

void main() {
  const echo = _EchoService();

  AspectChain chainOf({FakeLogger? logger, FakeMetrics? metrics}) =>
      AspectChain(
        logger ?? FakeLogger(),
        metrics ?? FakeMetrics(),
        FakeClock(),
        verbose: false,
      );

  group('D-161', () {
    test('should_nest_logging_metrics_and_exceptions_when_all_are_chosen', () {
      // Arrange
      final chain = chainOf();

      // Act
      final wrapped = chain.wrap(echo, name: 'Echo', measured: true);

      // Assert
      expect(_kindsOf(wrapped), [
        LoggingAspect,
        MetricsAspect,
        ExceptionAspect,
      ]);
    });

    test('should_measure_when_a_budget_is_given', () {
      // Arrange
      final chain = chainOf();

      // Act
      final wrapped = chain.wrap(
        echo,
        name: 'Echo',
        budget: AspectChain.frameBudget,
      );

      // Assert
      expect(_kindsOf(wrapped), [
        LoggingAspect,
        MetricsAspect,
        ExceptionAspect,
      ]);
    });

    test('should_only_log_and_catch_when_nothing_else_is_chosen', () {
      // Arrange
      final chain = chainOf();

      // Act
      final wrapped = chain.wrap(echo, name: 'Echo');

      // Assert
      expect(_kindsOf(wrapped), [LoggingAspect, ExceptionAspect]);
    });

    test('should_skip_logging_when_the_service_is_not_logged', () {
      // Arrange
      final chain = chainOf();

      // Act
      final wrapped = chain.wrap(
        echo,
        name: 'Echo',
        logged: false,
        budget: AspectChain.frameBudget,
      );

      // Assert
      expect(_kindsOf(wrapped), [MetricsAspect, ExceptionAspect]);
    });

    test('should_throw_when_the_service_is_already_wrapped', () {
      // Arrange
      final chain = chainOf();
      final wrapped = chain.wrap(echo, name: 'Echo');

      // Act
      ICommandService<int, int> again() => chain.wrap(wrapped, name: 'Echo');

      // Assert
      expect(again, throwsArgumentError);
    });
  });

  group('D-173', () {
    test(
      'should_not_count_the_description_of_the_log_when_measuring',
      () async {
        // Arrange: describing the command and the result takes 20 ms in all,
        // the use case 1 ms.
        final logger = FakeLogger();
        final metrics = FakeMetrics();
        final clock = FakeClock();
        final wrapped = AspectChain(logger, metrics, clock, verbose: true).wrap(
          _SlowService(clock, const Duration(milliseconds: 1)),
          name: 'ApplyMove',
          budget: AspectChain.frameBudget,
          describe: _SlowDescriber(clock, const Duration(milliseconds: 10)),
        );

        // Act
        await wrapped.execute(1);

        // Assert
        expect(metrics.records.single.$2, const Duration(milliseconds: 1));
        expect(logger.messages, isNot(contains('ApplyMove over budget')));
      },
    );
  });

  group('RNF-31', () {
    test('should_warn_over_the_budget_when_the_chain_measures', () async {
      // Arrange
      final logger = FakeLogger();
      final clock = FakeClock();
      final wrapped = AspectChain(logger, FakeMetrics(), clock, verbose: false)
          .wrap(
            _SlowService(clock, const Duration(milliseconds: 17)),
            name: 'ApplyMove',
            budget: AspectChain.frameBudget,
          );

      // Act
      await wrapped.execute(1);

      // Assert
      expect(logger.messages, contains('ApplyMove over budget'));
    });
  });

  group('SEC-MOB-05', () {
    for (final verbose in [true, false]) {
      test(
        'should_${verbose ? '' : 'not_'}log_the_description_when_${verbose ? '' : 'not_'}verbose',
        () async {
          // Arrange
          final logger = FakeLogger();
          final wrapped = AspectChain(
            logger,
            FakeMetrics(),
            FakeClock(),
            verbose: verbose,
          ).wrap(echo, name: 'Echo', describe: const _ValueDescriber());

          // Act
          await wrapped.execute(7);

          // Assert
          expect(logger.entries.first.data, verbose ? {'value': 7} : isEmpty);
        },
      );
    }
  });

  group('RNF-10', () {
    test(
      'should_log_a_generic_game_use_case_when_wrapped_without_changes',
      () async {
        // Arrange
        final logger = FakeLogger();
        final metrics = FakeMetrics();
        final session = FakeVariantFamily().createSession(
          NewGameOptions(seed: 1),
        );
        addTearDown(session.engine.close);
        const key = SavedGameKey(
          ProfileId.guest,
          GameKey('fake-game', 'fake-shape'),
        );
        final applyMove = chainOf(logger: logger, metrics: metrics).wrap(
          ApplyMoveUseCase(session, FakeSavedGameRepository<FakeState>(), key),
          name: 'ApplyMove',
          budget: AspectChain.frameBudget,
        );

        // Act
        final result = await applyMove.execute(const FakeMove(FakeCoord(0, 0)));

        // Assert
        expect(
          result,
          isA<Right<AppFailure, MoveResult<FakeCoord, FakeState>>>(),
        );
        expect(logger.messages, ['ApplyMove started', 'ApplyMove finished']);
        expect(metrics.records.single.$1, 'ApplyMove');
      },
    );
  });
}
