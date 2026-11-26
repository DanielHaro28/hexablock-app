import 'package:hexa_application/hexa_application.dart';

/// A logger that keeps every entry in memory, in order (D-56).
final class FakeLogger implements ILogger {
  /// The entries logged so far, oldest first.
  final List<LogEntry> entries = [];

  /// The messages logged so far, oldest first.
  List<String> get messages => [for (final entry in entries) entry.message];

  @override
  void log(LogEntry entry) => entries.add(entry);
}
