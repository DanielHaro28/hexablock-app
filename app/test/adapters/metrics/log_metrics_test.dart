import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/adapters/metrics/log_metrics.dart';

void main() {
  group('D-163', () {
    test('should_log_the_duration_as_debug_when_a_run_is_recorded', () {
      // Arrange
      final logger = FakeLogger();
      final metrics = LogMetrics(logger);

      // Act
      metrics.record('ApplyMove', const Duration(milliseconds: 7));

      // Assert
      final entry = logger.entries.single;
      expect(entry.level, LogLevel.debug);
      expect(entry.message, 'ApplyMove took');
      expect(entry.data, {'ms': 7});
    });
  });
}
