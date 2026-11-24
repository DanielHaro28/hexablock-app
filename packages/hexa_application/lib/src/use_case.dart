/// The single shape of every use case (D-38): one input, one output.
///
/// Since every use case is a `UseCase`, an aspect is written once and wraps
/// any of them (ARQ-03 §5). The input is one object, a class or a record;
/// when nothing is needed it is the empty record `()`. [execute] returns a
/// `Future` even when the work is synchronous: awaiting it costs a microtask,
/// so the screen still gets the result before the next frame (D-32).
abstract interface class UseCase<TIn, TOut> {
  /// Runs the use case on [input].
  Future<TOut> execute(TIn input);
}
