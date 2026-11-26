import 'package:hexa_application/hexa_application.dart';

import 'app_database.dart';
import 'drift_error.dart';

/// Runs a unit of work as one Drift transaction (ARQ-04 §3, D-158).
///
/// Drift binds the transaction to the zone of [run], so the repositories
/// called inside it read and write in the same transaction (their own
/// `transaction` becomes a savepoint). Drift runs one transaction at a time,
/// so units never interleave, and a unit that throws is rolled back.
final class DriftUnitOfWork implements IUnitOfWork {
  /// A unit of work over [_db].
  const DriftUnitOfWork(this._db);

  final AppDatabase _db;

  @override
  Future<T> run<T>(Future<T> Function() work) =>
      runDrift(() => _db.transaction(work));
}
