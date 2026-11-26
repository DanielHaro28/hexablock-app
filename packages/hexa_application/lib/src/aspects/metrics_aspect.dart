import 'package:hexa_engine/hexa_engine.dart';

import '../either.dart';
import '../errors.dart';
import '../ports/logger.dart';
import '../ports/metrics.dart';
import 'aspect.dart';

/// Measures how long a use case takes and warns when it goes over its
/// [budget] (Decorator, RNF-31, ARQ-03 §5.1).
///
/// Every run is recorded in [IMetrics] as [name], with the monotonic clock
/// of the domain (RN-COM-52). With a [budget], a run that takes longer is
/// also logged as a warning: 16 ms for a move is one frame (RNF-31). It sits
/// inside the retries, so it measures one attempt, not the sum of all.
final class MetricsAspect<TCommand, TResult> extends Aspect<TCommand, TResult> {
  /// Measures [inner] as [name] in [_metrics] with [_clock], warning in
  /// [_logger] when a run goes over [budget].
  MetricsAspect(
    super.inner,
    this._metrics,
    this._clock,
    this._logger, {
    required this.name,
    this.budget,
  });

  /// The name of the use case, as `LoggingAspect` logs it.
  final String name;

  /// How long a run may take before it is a warning; `null` never warns.
  final Duration? budget;

  final IMetrics _metrics;
  final IMonotonicClock _clock;
  final ILogger _logger;

  @override
  Type get kind => MetricsAspect;

  @override
  Future<Either<AppFailure, TResult>> execute(TCommand command) async {
    final start = _clock.nowMillis();
    final result = await inner.execute(command);
    final elapsed = Duration(milliseconds: _clock.nowMillis() - start);
    _metrics.record(name, elapsed);
    if (budget case final budget? when elapsed > budget) {
      _logger.log(
        LogEntry.warning('$name over budget', {
          'ms': elapsed.inMilliseconds,
          'budgetMs': budget.inMilliseconds,
        }),
      );
    }
    return result;
  }
}
