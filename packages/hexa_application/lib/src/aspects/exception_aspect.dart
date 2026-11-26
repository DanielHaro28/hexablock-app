import '../either.dart';
import '../errors.dart';
import 'aspect.dart';

/// Turns what a service throws into a [Left] (Decorator, D-161).
///
/// The adapters throw a typed [AppException] and the use cases let it
/// through; this aspect, the innermost one, gives its [AppFailure] instead.
/// Anything else is a programming error and becomes an [UnexpectedFailure],
/// so the screen never shows a stack. What the service returns, [Right] or
/// [Left], goes out unchanged. Being innermost, the aspects around it only
/// ever see an [Either] and none needs a `try`.
final class ExceptionAspect<TCommand, TResult>
    extends Aspect<TCommand, TResult> {
  /// Wraps [inner].
  ExceptionAspect(super.inner);

  @override
  Future<Either<AppFailure, TResult>> execute(TCommand command) async {
    try {
      return await inner.execute(command);
    } on AppException catch (error) {
      return Left(_failureOf(error));
    } catch (_) {
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
