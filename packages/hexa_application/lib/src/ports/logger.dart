/// How serious a [LogEntry] is, from the least to the most serious: a
/// logger may compare them by `index`.
enum LogLevel {
  /// Detail to follow a run in development, such as a use case starting.
  debug,

  /// Something that went as expected, such as a use case finishing.
  info,

  /// Something went wrong but the app goes on, such as a failure.
  warning,

  /// A programming error: something no one expected.
  error,
}

/// One line of the log: what happened, with its [data] (ARQ-03 §4).
///
/// The aspects build it already redacted (SEC-WEB-06); the platform logger
/// decides where it goes and what reaches a release build (SEC-MOB-05).
final class LogEntry {
  /// An entry of [level] with [message] and [data].
  const LogEntry(
    this.level,
    this.message, [
    this.data = const {},
    this.error,
    this.stackTrace,
  ]);

  /// A [LogLevel.debug] entry.
  const LogEntry.debug(this.message, [this.data = const {}])
    : level = LogLevel.debug,
      error = null,
      stackTrace = null;

  /// A [LogLevel.info] entry.
  const LogEntry.info(this.message, [this.data = const {}])
    : level = LogLevel.info,
      error = null,
      stackTrace = null;

  /// A [LogLevel.warning] entry.
  const LogEntry.warning(this.message, [this.data = const {}])
    : level = LogLevel.warning,
      error = null,
      stackTrace = null;

  /// A [LogLevel.error] entry for [error], thrown at [stackTrace].
  const LogEntry.error(
    this.message,
    this.data, {
    required this.error,
    required this.stackTrace,
  }) : level = LogLevel.error;

  /// How serious it is.
  final LogLevel level;

  /// What happened, for example `ApplyMove finished`.
  final String message;

  /// Its details: plain values, already redacted.
  final Map<String, Object?> data;

  /// The error of a [LogLevel.error] entry. Its text may hold user data, so
  /// a release build writes only its type.
  final Object? error;

  /// Where [error] was thrown.
  final StackTrace? stackTrace;
}

/// Where the aspects write the log (ARQ-03 §4, RNF-10).
///
/// Only the aspects use it: no use case logs by itself, and the CI checks
/// it (`tool/check_architecture.dart`).
abstract interface class ILogger {
  /// Writes [entry].
  void log(LogEntry entry);
}
