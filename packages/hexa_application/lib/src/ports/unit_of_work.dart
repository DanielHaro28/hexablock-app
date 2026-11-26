/// Runs several repository calls as one unit (ARQ-03 §4, ARQ-04 §3, D-158).
///
/// A use case that reads, decides and then writes (such as consolidating a
/// result with the saved progress) wraps the whole sequence in [run], so
/// another unit cannot write between its read and its write, and a failure
/// leaves nothing half written. The use case never sees the storage: the
/// local database implements it with a transaction.
abstract interface class IUnitOfWork {
  /// Runs [work] as one unit and returns its result.
  ///
  /// Units run one after another, never interleaved. If [work] throws,
  /// nothing it wrote is kept and the error reaches the caller.
  Future<T> run<T>(Future<T> Function() work);
}
