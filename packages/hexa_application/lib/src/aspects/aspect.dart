import '../command_service.dart';

/// The base of every aspect: a decorator that wraps a service and has its
/// same type (D-160, ARQ-03 §5).
///
/// Because an aspect is also an [ICommandService], aspects nest like the
/// dolls of chapter 10 and none needs to know what it wraps. Each kind of
/// aspect appears at most once on a service: [Aspect] walks the chain it
/// wraps and throws an [ArgumentError] if it already holds an aspect of its
/// same type, so a service is never logged or measured twice.
abstract base class Aspect<TCommand, TResult>
    implements ICommandService<TCommand, TResult> {
  /// Wraps [inner]; throws an [ArgumentError] if the chain under it already
  /// has an aspect of this type.
  Aspect(this.inner) {
    ICommandService<TCommand, TResult> node = inner;
    while (node is Aspect<TCommand, TResult>) {
      if (node.runtimeType == runtimeType) {
        throw ArgumentError.value(
          inner,
          'inner',
          'already wrapped by a $runtimeType',
        );
      }
      node = node.inner;
    }
  }

  /// The service or aspect this one wraps.
  final ICommandService<TCommand, TResult> inner;
}
