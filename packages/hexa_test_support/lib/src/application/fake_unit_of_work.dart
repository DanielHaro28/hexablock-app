import 'package:hexa_application/hexa_application.dart';

/// A unit of work in memory for the use case tests (D-56).
///
/// It runs each unit after the previous one ends, as the real one does, and
/// counts them in [runs]. It does not roll back: the fake repositories have
/// no transactions, so a test of all-or-nothing belongs to the database.
final class FakeUnitOfWork implements IUnitOfWork {
  Future<void> _last = Future<void>.value();

  /// How many units were started.
  int runs = 0;

  @override
  Future<T> run<T>(Future<T> Function() work) {
    runs++;
    final result = _last.then((_) => work());
    _last = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }
}
