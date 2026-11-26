import 'package:hexa_application/hexa_application.dart';

/// Metrics that keep every measure in memory, in order (D-56).
final class FakeMetrics implements IMetrics {
  /// The measures recorded so far, oldest first.
  final List<(String, Duration)> records = [];

  @override
  void record(String name, Duration elapsed) => records.add((name, elapsed));
}
