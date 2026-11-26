import 'package:flutter/foundation.dart';
import 'package:hexa_application/hexa_application.dart';

/// Writes one log line.
typedef LogWriter = void Function(String line);

/// The log of the device (ARQ-03 §4, D-163): each entry becomes a line in
/// the platform console, which development tools show (VS Code, DevTools,
/// `flutter logs`) and Android keeps in logcat.
///
/// - When [verbose] (development builds) it writes every entry, with the
///   type and the redacted text of its error.
/// - Otherwise (release builds) it writes only warnings and errors, and of
///   an error only its type and its stack: the text of an error may hold
///   user data (SEC-MOB-05). The aspects already leave the details of the
///   commands out of a release build.
/// - In any build the data goes through the [Redactor] once more, so a
///   secret that reached an entry is still hidden (SEC-WEB-06).
final class PlatformLogger implements ILogger {
  /// A logger that writes with [write] (by default `debugPrint`, which also
  /// prints in release builds).
  PlatformLogger({required this.verbose, LogWriter? write})
    : _write = write ?? _debugPrint;

  /// Whether every entry is written, with the text of its error.
  final bool verbose;

  final LogWriter _write;

  static const _redactor = Redactor();

  static void _debugPrint(String line) => debugPrint(line);

  @override
  void log(LogEntry entry) {
    // LogLevel is declared from the least to the most serious.
    if (!verbose && entry.level.index < LogLevel.warning.index) return;
    final line = StringBuffer(
      '[hexablock] ${entry.level.name.toUpperCase()} ${entry.message}',
    );
    if (entry.data.isNotEmpty) {
      line.write(' ${_redactor.redact(entry.data)}');
    }
    if (entry.error case final error?) {
      line.write('\n${error.runtimeType}');
      if (verbose) line.write(': ${_redactor.redactText('$error')}');
    }
    if (entry.stackTrace case final stackTrace?) {
      line.write('\n${'$stackTrace'.trimRight()}');
    }
    _write('$line');
  }
}
