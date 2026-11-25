import 'package:hexa_engine/hexa_engine.dart';

/// The clock of the application layer (ARQ-03 §4): the monotonic clock of
/// the domain plus the wall-clock date, so one platform class serves both.
///
/// Only the date of a result uses [now] (the `achievedAt` of a record);
/// time is always measured with `nowMillis`, which never jumps (RN-COM-52).
abstract interface class IClock implements IMonotonicClock {
  /// The current date and time, in UTC.
  DateTime now();
}
