import '../errors.dart';
import '../use_case.dart';

/// Turns the exceptions of a use case into a [Result] for the screen
/// (Decorator, D-39, D-40).
///
/// An [AppException] becomes its [AppFailure]; anything else is a
/// programming error and becomes an [UnexpectedFailure], so the screen never
/// shows a stack. Retries for network errors (D-41) are added here by the
/// story that brings the first network use case.
final class ErrorHandlingAspect<TIn, TOut>
    implements UseCase<TIn, Result<TOut>> {
  /// Wraps [inner].
  const ErrorHandlingAspect(this._inner);

  final UseCase<TIn, TOut> _inner;

  @override
  Future<Result<TOut>> execute(TIn input) async {
    try {
      return Success(await _inner.execute(input));
    } on AppException catch (error) {
      return Failure(_failureOf(error));
    } catch (_) {
      // A programming error: the logging aspect inside records it (D-41).
      return const Failure(UnexpectedFailure());
    }
  }

  static AppFailure _failureOf(AppException error) => switch (error) {
    NetworkException() => const NetworkFailure(),
    SessionExpiredException() => const SessionFailure(expired: true),
    ConflictException(:final code) => ConflictFailure(code),
    ValidationException(:final fields) => ValidationFailure(fields),
    PersistenceException() => const PersistenceFailure(),
    RuleException(:final code) => RuleFailure(code),
  };
}
