import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// A service that takes [took] on [clock] and returns [result].
final class _TimedService implements ICommandService<int, int> {
  _TimedService(this.clock, this.took, [this.result = const Right(1)]);

  final FakeClock clock;
  final Duration took;
  final Either<AppFailure, int> result;

  @override
  Future<Either<AppFailure, int>> execute(int command) async {
    clock.advance(took);
    return result;
  }
}

void main() {
  const budget = Duration(milliseconds: 16);

  group('RNF-31', () {
    test('should_record_the_duration_when_the_service_finishes', () async {
      // Arrange
      final clock = FakeClock();
      final metrics = FakeMetrics();
      final aspect = MetricsAspect(
        _TimedService(clock, const Duration(milliseconds: 9)),
        metrics,
        clock,
        FakeLogger(),
        name: 'ApplyMove',
        budget: budget,
      );

      // Act
      await aspect.execute(0);

      // Assert
      expect(metrics.records, [('ApplyMove', const Duration(milliseconds: 9))]);
    });

    test('should_log_nothing_when_the_service_is_within_budget', () async {
      // Arrange
      final clock = FakeClock();
      final logger = FakeLogger();
      final aspect = MetricsAspect(
        _TimedService(clock, budget),
        FakeMetrics(),
        clock,
        logger,
        name: 'ApplyMove',
        budget: budget,
      );

      // Act
      await aspect.execute(0);

      // Assert
      expect(logger.entries, isEmpty);
    });

    test('should_log_a_warning_when_the_service_goes_over_budget', () async {
      // Arrange
      final clock = FakeClock();
      final logger = FakeLogger();
      final aspect = MetricsAspect(
        _TimedService(clock, const Duration(milliseconds: 17)),
        FakeMetrics(),
        clock,
        logger,
        name: 'ApplyMove',
        budget: budget,
      );

      // Act
      await aspect.execute(0);

      // Assert
      expect(logger.messages, ['ApplyMove over budget']);
      expect(logger.entries.single.level, LogLevel.warning);
      expect(logger.entries.single.data, {'ms': 17, 'budgetMs': 16});
    });

    test('should_measure_without_warning_when_there_is_no_budget', () async {
      // Arrange
      final clock = FakeClock();
      final logger = FakeLogger();
      final metrics = FakeMetrics();
      final aspect = MetricsAspect(
        _TimedService(clock, const Duration(seconds: 2)),
        metrics,
        clock,
        logger,
        name: 'StartGame',
      );

      // Act
      await aspect.execute(0);

      // Assert
      expect(metrics.records.single.$2, const Duration(seconds: 2));
      expect(logger.entries, isEmpty);
    });

    test('should_return_what_the_service_returned_when_measuring', () async {
      // Arrange
      final clock = FakeClock();
      final aspect = MetricsAspect(
        _TimedService(clock, Duration.zero, const Left(NetworkFailure())),
        FakeMetrics(),
        clock,
        FakeLogger(),
        name: 'Sync',
      );

      // Act
      final result = await aspect.execute(0);

      // Assert
      expect(result, const Left<AppFailure, int>(NetworkFailure()));
    });
  });
}
