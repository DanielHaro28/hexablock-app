/// The only way the domain reads time: a monotonic clock, a port that the
/// platform implements (D-33, ARQ-02 §7).
///
/// The domain never calls `DateTime.now()`: a wall clock can jump (the
/// player changes the time, the zone changes), and active time and Hexa
/// Fit's stars depend on it (RN-COM-52, RN-HF-62). The application layer's
/// `IClock` extends this port with the wall-clock date, so one platform
/// class serves both; the tests use `FakeClock`.
abstract interface class IMonotonicClock {
  /// Milliseconds from an arbitrary origin. Only differences between two
  /// readings mean something, and a later reading is never smaller.
  int nowMillis();
}
