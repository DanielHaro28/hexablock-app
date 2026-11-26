import '../command_service.dart';

/// The base of every aspect: a decorator that wraps a service and has its
/// same type (D-160, ARQ-03 §5).
///
/// Because an aspect is also an [ICommandService], aspects nest like the
/// dolls of chapter 10 and none needs to know what it wraps. Each kind of
/// aspect appears at most once on a service: [Aspect] walks the chain it
/// wraps and throws an [ArgumentError] if it already holds an aspect of the
/// same [kind], so a service is never logged or measured twice. The walk
/// stops at the first service that is not an [Aspect].
abstract base class Aspect<TCommand, TResult>
    implements ICommandService<TCommand, TResult> {
  /// Wraps [inner]; throws an [ArgumentError] if the chain under it already
  /// has an aspect of this [kind].
  Aspect(this.inner) {
    Object? node = inner;
    while (node is Aspect) {
      if (node.kind == kind) {
        throw ArgumentError.value(inner, 'inner', 'already wrapped by $kind');
      }
      node = node.inner;
    }
  }

  /// The service or aspect this one wraps.
  final ICommandService<TCommand, TResult> inner;

  /// Which aspect this is, without its type arguments: each aspect returns
  /// its own class name, for example `ExceptionAspect`.
  ///
  /// It is not the `runtimeType`, which also holds the type arguments: with
  /// Dart's covariance an `<int, num>` aspect can wrap an `<int, int>` chain,
  /// and the two runtime types would differ.
  Type get kind;
}
