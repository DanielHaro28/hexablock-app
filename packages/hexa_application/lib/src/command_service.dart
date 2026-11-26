import 'either.dart';
import 'errors.dart';

/// The single shape of every use case and every aspect (D-160): one
/// command in, [Either] a failure or a result out.
///
/// It is the `ICommandService<TCommand>` of chapter 10 of *Dependency
/// Injection Principles, Practices, and Patterns* (Seemann and van Deursen),
/// with one change: instead of `void`, [execute] returns what happened, so
/// one abstraction serves both the use cases that change the game and those
/// that only read, and each aspect is written once for all of them. The
/// use cases return values on purpose (D-32: the screen gets the events of
/// a move from [execute]).
///
/// - The command is one object, a class or a record; when nothing is needed
///   it is the empty record `()`.
/// - A use case returns `Right` when it worked and `Left` when one of its
///   rules stops it; it never throws for a rule and never catches. The
///   exceptions of the adapters go through it and `ExceptionAspect` turns
///   them into a `Left` (D-161). A broken invariant is a programming error
///   and may throw: it becomes an `UnexpectedFailure`.
/// - [execute] returns a `Future` even when the work is synchronous:
///   awaiting it costs a microtask, so the screen still gets the result
///   before the next frame (D-32).
abstract interface class ICommandService<TCommand, TResult> {
  /// Runs [command].
  Future<Either<AppFailure, TResult>> execute(TCommand command);
}
