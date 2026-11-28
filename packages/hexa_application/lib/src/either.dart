/// What a service returns: either what went wrong ([Left]) or what it
/// produced ([Right]) (D-160).
///
/// Every service and every aspect returns the same type, so an aspect never
/// changes the shape of the service it wraps and the aspects can be chained
/// freely (ARQ-03 §5). The screen switches over it exhaustively:
///
/// ```dart
/// switch (result) {
///   case Right(:final value): ...
///   case Left(value: NetworkFailure()): ...
///   case Left(:final value): ...
/// }
/// ```
///
/// It is also a monad (D-170), with the operations of [EitherOperations].
sealed class Either<L, R> {
  const Either();
}

/// The monad operations of [Either] (D-170): [Right] is the unit, [flatMap]
/// chains a step that can fail and [map] transforms the value, and a [Left]
/// goes through both unchanged. [fold] reduces both sides to one value. The
/// tests check the functor and monad laws.
///
/// They are an extension, not methods of the class, because Dart's generic
/// classes are covariant: a `Left<NetworkFailure, int>` seen as an
/// `Either<AppFailure, int>` would check the `next` of a method against
/// `Either<NetworkFailure, int>` at run time and throw. An extension takes
/// `L` and `R` from the static type, so there is nothing to check.
extension EitherOperations<L, R> on Either<L, R> {
  /// What [onLeft] returns for a [Left], or [onRight] for a [Right].
  T fold<T>(T Function(L failure) onLeft, T Function(R value) onRight) =>
      switch (this) {
        Left(:final value) => onLeft(value),
        Right(:final value) => onRight(value),
      };

  /// A [Right] with [transform] applied to its value; a [Left] stays as it
  /// is and [transform] is not called.
  Either<L, T> map<T>(T Function(R value) transform) => switch (this) {
    Right(:final value) => Right(transform(value)),
    Left(:final value) => Left(value),
  };

  /// What [next] returns for the value of a [Right]; a [Left] stays as it is
  /// and [next] is not called, so the first failure ends the chain.
  Either<L, T> flatMap<T>(Either<L, T> Function(R value) next) =>
      switch (this) {
        Right(:final value) => next(value),
        Left(:final value) => Left(value),
      };
}

/// The failure side: [value] says what went wrong.
final class Left<L, R> extends Either<L, R> {
  /// A failure with [value].
  const Left(this.value);

  /// What went wrong.
  final L value;

  @override
  bool operator ==(Object other) => other is Left<L, R> && other.value == value;

  @override
  int get hashCode => Object.hash(Left, value);

  @override
  String toString() => 'Left($value)';
}

/// The success side: [value] is what the service produced.
final class Right<L, R> extends Either<L, R> {
  /// A success with [value].
  const Right(this.value);

  /// What the service produced.
  final R value;

  @override
  bool operator ==(Object other) =>
      other is Right<L, R> && other.value == value;

  @override
  int get hashCode => Object.hash(Right, value);

  @override
  String toString() => 'Right($value)';
}
