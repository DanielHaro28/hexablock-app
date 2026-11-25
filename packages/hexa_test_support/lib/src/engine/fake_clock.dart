import 'package:hexa_application/hexa_application.dart';

/// A clock that the tests move by hand (D-56): time never passes on its own,
/// so no test waits for real time.
///
/// It is monotonic, like the domain port it fakes: it can only go forward.
/// It is also the application's [IClock]: the date starts at [startDate] and
/// moves with [advance].
final class FakeClock implements IClock {
  /// A clock that reads [startMillis] and [startDate] until it is advanced.
  FakeClock({int startMillis = 0, DateTime? startDate})
    : _startMillis = startMillis,
      _nowMillis = startMillis,
      startDate = startDate ?? DateTime.utc(2026, 11, 24, 18, 30);

  /// The date it reads until it is advanced, in UTC.
  final DateTime startDate;

  final int _startMillis;
  int _nowMillis;

  @override
  int nowMillis() => _nowMillis;

  @override
  DateTime now() =>
      startDate.toUtc().add(Duration(milliseconds: _nowMillis - _startMillis));

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
