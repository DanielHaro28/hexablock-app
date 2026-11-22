import 'package:hexa_engine/hexa_engine.dart';

/// A clock that the tests move by hand (D-56): time never passes on its own,
/// so no test waits for real time.
///
/// It is monotonic, like the port it fakes: it can only go forward.
final class FakeClock implements IMonotonicClock {
  /// A clock that reads [startMillis] until it is advanced.
  FakeClock({int startMillis = 0}) : _nowMillis = startMillis;

  int _nowMillis;

  @override
  int nowMillis() => _nowMillis;

  /// Moves the clock forward by [duration].
  ///
  /// Throws an [ArgumentError] if [duration] is negative: a monotonic clock
  /// never goes back.
  void advance(Duration duration) {
    if (duration.isNegative) {
      throw ArgumentError.value(duration, 'duration', 'must not be negative');
    }
    _nowMillis += duration.inMilliseconds;
  }
}
