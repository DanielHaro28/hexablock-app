/// Where `MetricsAspect` records how long each use case took (ARQ-03 §4,
/// RNF-31).
///
/// Only the aspects use it, like `ILogger` (RNF-10).
abstract interface class IMetrics {
  /// Records that the use case [name] took [elapsed].
  void record(String name, Duration elapsed);
}
