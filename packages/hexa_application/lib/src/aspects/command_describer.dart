/// What `LoggingAspect` writes about the command and the result of a use
/// case (Strategy, ARQ-03 §5.1).
///
/// It is only asked in development (`verbose`), and what it returns is
/// redacted before it is logged (SEC-WEB-06). The values should be plain:
/// numbers, flags, text, lists and maps.
abstract interface class CommandDescriber<TCommand, TResult> {
  /// The details of [command], logged when the use case starts.
  Map<String, Object?> command(TCommand command);

  /// The details of [result], logged when the use case finishes.
  Map<String, Object?> result(TResult result);
}

/// Describes nothing: the default, so a use case without its own describer
/// logs only its name, its duration and how it ended.
final class SilentDescriber<TCommand, TResult>
    implements CommandDescriber<TCommand, TResult> {
  /// Describes nothing.
  const SilentDescriber();

  @override
  Map<String, Object?> command(TCommand command) => const {};

  @override
  Map<String, Object?> result(TResult result) => const {};
}
