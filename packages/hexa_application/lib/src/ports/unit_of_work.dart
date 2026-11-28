import '../either.dart';
import '../errors.dart';

/// Runs several repository calls as one unit (ARQ-03 §4, ARQ-04 §3, D-158).
///
/// A use case that reads, decides and then writes (such as consolidating a
/// result with the saved progress) wraps the whole sequence in [run], so
/// another unit cannot write between its read and its write, and a failure
/// leaves nothing half written. The use case never sees the storage: the
/// local database implements it with a transaction.
///
/// Only a thrown error undoes the unit. A `Left` that [run]'s work returns
/// is an ordinary value, so what the work wrote before it is kept: a unit
/// that writes and may then return a `Left` uses
/// [EitherUnitOfWork.runEither] instead (D-171).
abstract interface class IUnitOfWork {
  /// Runs [work] as one unit and returns its result.
  ///
  /// Units run one after another, never interleaved. If [work] throws,
  /// nothing it wrote is kept and whatever it threw is rethrown unchanged,
  /// whatever its type: an adapter may translate only its own storage
  /// errors, never what [work] throws (D-171 relies on it).
  Future<T> run<T>(Future<T> Function() work);
}

/// Runs a unit whose work returns an [Either] (D-171).
///
/// It is written once here, over [IUnitOfWork.run], so no adapter changes.
extension EitherUnitOfWork on IUnitOfWork {
  /// Runs [work] as one unit: a [Left] undoes it, as a thrown error does,
  /// and comes back unchanged; a [Right] keeps what [work] wrote.
  ///
  /// What [work] throws goes through as with [IUnitOfWork.run].
  Future<Either<AppFailure, T>> runEither<T>(
    Future<Either<AppFailure, T>> Function() work,
  ) async {
    try {
      return await run(() async {
        final result = await work();
        if (result case Left()) throw _Rollback<T>(result);
        return result;
      });
    } on _Rollback<T> catch (rollback) {
      return rollback.left;
    }
  }
}

/// What [EitherUnitOfWork.runEither] throws to undo a unit that returned a
/// [Left], and catches again outside it.
///
/// It is not an [Exception] on purpose: the database adapter turns every
/// [Exception] into a [PersistenceException], which would hide the [Left].
final class _Rollback<T> {
  const _Rollback(this.left);

  final Either<AppFailure, T> left;
}
