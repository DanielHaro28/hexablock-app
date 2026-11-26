import 'package:hexa_engine/hexa_engine.dart';

import '../command_service.dart';
import '../ports/logger.dart';
import '../ports/metrics.dart';
import 'command_describer.dart';
import 'exception_aspect.dart';
import 'logging_aspect.dart';
import 'metrics_aspect.dart';

/// Wraps a use case with its aspects, always in the same order (D-41,
/// D-161): the `Decorate` method of chapter 10 of Seemann and van Deursen.
///
/// The composition root calls [wrap] once per use case and chooses which
/// aspects it gets; the order is not a choice. From the outside in:
///
/// metrics → logging → exceptions → use case
///
/// - Exceptions are innermost, so every other aspect gets an `Either`.
/// - Logging is right outside them, so each attempt is logged.
/// - Metrics measure one attempt.
///
/// The retry and session aspects come with the first stories that need
/// them, outside metrics: session → retries → metrics (D-161). Each aspect
/// appears at most once (`Aspect`), so a service that is already wrapped
/// cannot be wrapped again.
final class AspectChain {
  /// A chain that logs in [_logger], measures in [_metrics] with [_clock]
  /// and, when [verbose] (development builds), logs the details of each
  /// command and result (SEC-MOB-05).
  AspectChain(
    this._logger,
    this._metrics,
    this._clock, {
    required this.verbose,
  });

  /// The time of one frame at 60 fps: the budget of a move and of its
  /// preview (RNF-31).
  static const frameBudget = Duration(milliseconds: 16);

  /// Whether the details of the commands and results are logged.
  final bool verbose;

  final ILogger _logger;
  final IMetrics _metrics;
  final IMonotonicClock _clock;

  /// [service] wrapped with its aspects, as [name] in the log.
  ///
  /// - It always gets `ExceptionAspect`.
  /// - It is [logged] unless told otherwise, with what [describe] says in
  ///   development.
  /// - It is measured if [measured] or if it has a [budget], which also
  ///   warns when a run goes over it.
  ///
  /// Throws an [ArgumentError] if [service] already has one of these
  /// aspects.
  ICommandService<TCommand, TResult> wrap<TCommand, TResult>(
    ICommandService<TCommand, TResult> service, {
    required String name,
    bool logged = true,
    bool measured = false,
    Duration? budget,
    CommandDescriber<TCommand, TResult>? describe,
  }) {
    assert(logged || describe == null, 'describe is only used when logged');
    ICommandService<TCommand, TResult> wrapped = ExceptionAspect(
      service,
      _logger,
      name: name,
    );
    if (logged) {
      wrapped = LoggingAspect(
        wrapped,
        _logger,
        _clock,
        name: name,
        describe: describe,
        verbose: verbose,
      );
    }
    if (measured || budget != null) {
      wrapped = MetricsAspect(
        wrapped,
        _metrics,
        _clock,
        _logger,
        name: name,
        budget: budget,
      );
    }
    return wrapped;
  }
}
