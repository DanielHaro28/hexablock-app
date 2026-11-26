import 'package:hexa_application/hexa_application.dart';

/// Metrics written to the log (ARQ-03 §4, D-163): each run is a debug line
/// with its duration, so it shows in development and is left out of a
/// release build. A run over its budget is a warning that `MetricsAspect`
/// logs by itself.
final class LogMetrics implements IMetrics {
  /// Metrics written to [_logger].
  const LogMetrics(this._logger);

  final ILogger _logger;

  @override
  void record(String name, Duration elapsed) =>
      _logger.log(LogEntry.debug('$name took', {'ms': elapsed.inMilliseconds}));
}
