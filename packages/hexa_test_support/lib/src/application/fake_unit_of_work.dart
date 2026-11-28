import 'package:hexa_application/hexa_application.dart';

/// A unit of work in memory for the use case tests (D-56).
///
/// It runs each unit after the previous one ends, as the real one does, and
/// counts them in [runs] and the ones that ended with an error in [failed].
/// It does not roll back: the fake repositories have no transactions, so a
/// test of all-or-nothing belongs to the database. [failed] says which
/// units the database would have rolled back (D-171).
final class FakeUnitOfWork implements IUnitOfWork {
  Future<void> _last = Future<void>.value();

  /// How many units were started.
  int runs = 0;

  /// How many units ended with an error: the ones the database undoes.
  int failed = 0;

  @override
  Future<T> run<T>(Future<T> Function() work) {
    runs++;
    final result = _last.then((_) => work());
    // This listener is registered before the caller's own `await`, so
    // [failed] is already counted when the caller sees the error.
    _last = result.then<void>(
      (_) {},
      onError: (Object _) {
        failed++;
      },
    );
    return result;
  }
}
