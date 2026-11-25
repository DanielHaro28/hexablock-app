import 'package:hexa_application/hexa_application.dart';

/// The clock of the device (ARQ-03 §4): a [Stopwatch] for the monotonic
/// time and the system date, in UTC, for the date of a result.
final class SystemClock implements IClock {
  /// A clock whose monotonic time starts now.
  SystemClock() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  int nowMillis() => _stopwatch.elapsedMilliseconds;

  @override
  DateTime now() => DateTime.now().toUtc();
}
