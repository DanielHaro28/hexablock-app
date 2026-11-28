import 'package:hexa_engine/hexa_engine.dart';

import '../either.dart';
import '../errors.dart';
import '../ports/logger.dart';
import 'aspect.dart';
import 'command_describer.dart';
import 'redactor.dart';

/// Logs when a use case starts, when it ends, how long it took and how it
/// ended (Decorator, RNF-10, ARQ-03 §5.1).
///
/// - `<name> started` (debug), then `<name> finished` (info) with `ms`, or
///   `<name> failed` (warning) with `ms`, the kind of failure and, for a
///   conflict or a rule, its code. Codes are not user data.
/// - Only when [verbose] (development builds) it adds what [describe] says
///   about the command and the result, redacted by [Redactor] (SEC-WEB-06).
///   A release build logs no user data (SEC-MOB-05).
///
/// It sits outside `MetricsAspect` and `ExceptionAspect`, so it always gets
/// an [Either] and needs no `try`, and the time it takes to describe and
/// redact is not measured as the use case's (D-173); inside the retries, so
/// each attempt is logged. Its `ms` starts once the command is described.
final class LoggingAspect<TCommand, TResult> extends Aspect<TCommand, TResult> {
  /// Logs [inner] as [name] in [_logger], timed with [_clock]; in
  /// development ([verbose]) with what [describe] says.
  LoggingAspect(
    super.inner,
    this._logger,
    this._clock, {
    required this.name,
    CommandDescriber<TCommand, TResult>? describe,
    this.verbose = false,
  }) : _describe = describe ?? SilentDescriber<TCommand, TResult>();

  /// The name of the use case in the log, for example `ApplyMove`. It is
  /// given, not taken from the type, because a release build obfuscates
  /// type names.
  final String name;

  /// Whether the details of the command and the result are logged.
  final bool verbose;

  final ILogger _logger;
  final IMonotonicClock _clock;
  final CommandDescriber<TCommand, TResult> _describe;

  static const _redactor = Redactor();

  @override
  Type get kind => LoggingAspect;

  @override
  Future<Either<AppFailure, TResult>> execute(TCommand command) async {
    _logger.log(
      LogEntry.debug(
        '$name started',
        _details(() => _describe.command(command)),
      ),
    );
    final start = _clock.nowMillis();
    final result = await inner.execute(command);
    final ms = _clock.nowMillis() - start;
    switch (result) {
      case Right(:final value):
        _logger.log(
          LogEntry.info('$name finished', {
            'ms': ms,
            ..._details(() => _describe.result(value)),
          }),
        );
      case Left(:final value):
        _logger.log(
          LogEntry.warning('$name failed', {
            'ms': ms,
            ..._failure(value),
            ..._details(() => _failureDetails(value)),
          }),
        );
    }
    return result;
  }

  /// What [describe] says, redacted, only when [verbose]. A description that
  /// throws is logged as its error type: the describer runs outside
  /// `ExceptionAspect`, and a broken `toString` must not reach the screen.
  Map<String, Object?> _details(Map<String, Object?> Function() describe) {
    if (!verbose) return const {};
    try {
      return _redactor.redact(describe());
    } catch (error) {
      return {'describeError': '${error.runtimeType}'};
    }
  }

  /// What a failure is, without user data, so it is logged in release too.
  static Map<String, Object?> _failure(AppFailure failure) => switch (failure) {
    NetworkFailure() => {'failure': 'network'},
    SessionFailure(:final expired) => {
      'failure': 'session',
      'expired': expired,
    },
    ConflictFailure(:final code) => {'failure': 'conflict', 'code': code},
    ValidationFailure() => {'failure': 'validation'},
    PersistenceFailure() => {'failure': 'persistence'},
    RuleFailure(:final code) => {'failure': 'rule', 'code': code},
    UnexpectedFailure() => {'failure': 'unexpected'},
  };

  /// The fields of a validation failure, as `pointer: code` texts, so the
  /// redactor does not mistake a pointer such as `/email` for a secret.
  static Map<String, Object?> _failureDetails(AppFailure failure) =>
      switch (failure) {
        ValidationFailure(:final fields) => {
          'fields': [
            for (final MapEntry(:key, :value) in fields.entries) '$key: $value',
          ],
        },
        _ => const {},
      };
}
