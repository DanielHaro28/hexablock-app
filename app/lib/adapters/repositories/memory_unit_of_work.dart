import 'package:hexa_application/hexa_application.dart';

/// Runs the units of work one after another until PRG-03 brings the Drift
/// transaction (D-158).
///
/// The memory repositories have nothing to roll back, so it only keeps two
/// units from interleaving between a read and a write.
final class MemoryUnitOfWork implements IUnitOfWork {
  Future<void> _last = Future<void>.value();

  @override
  Future<T> run<T>(Future<T> Function() work) {
    final result = _last.then((_) => work());
    _last = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }
}
