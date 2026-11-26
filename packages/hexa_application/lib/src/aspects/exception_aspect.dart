import '../either.dart';
import '../errors.dart';
import '../ports/logger.dart';
import 'aspect.dart';

/// Turns what a service throws into a [Left] (Decorator, D-161).
///
/// The adapters throw a typed [AppException] and the use cases let it
/// through; this aspect, the innermost one, gives its [AppFailure] instead.
/// Anything else is a programming error: it is logged here, with its type
/// and its stack, and becomes an [UnexpectedFailure], so the screen never
/// shows a stack. This is the only place that logs an exception: an
/// [AppException] is not logged here, because the aspects around it log
/// the [Left]. What the service returns, [Right] or [Left], goes out
/// unchanged. Being innermost, the aspects around it only ever see an
/// [Either] and none needs a `try`.
final class ExceptionAspect<TCommand, TResult>
    extends Aspect<TCommand, TResult> {
  /// Wraps [inner], logging its unexpected errors as [name] in [_logger].
  ExceptionAspect(super.inner, this._logger, {required this.name});

  /// The name of the use case, as `LoggingAspect` logs it.
  final String name;

  final ILogger _logger;

  @override
  Type get kind => ExceptionAspect;

  @override
  Future<Either<AppFailure, TResult>> execute(TCommand command) async {
    try {
      return await inner.execute(command);
    } on AppException catch (error) {
      return Left(_failureOf(error));
    } catch (error, stackTrace) {
      _logger.log(
        LogEntry.error(
          '$name unexpected error',
          {'error': '${error.runtimeType}'},
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return const Left(UnexpectedFailure());
    }
  }

  static AppFailure _failureOf(AppException error) => switch (error) {
    NetworkException() => const NetworkFailure(),
    SessionExpiredException() => const SessionFailure(expired: true),
    ConflictException(:final code) => ConflictFailure(code),
    ValidationException(:final fields) => ValidationFailure(fields),
    PersistenceException() => const PersistenceFailure(),
  };
}
