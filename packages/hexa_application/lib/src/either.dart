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
sealed class Either<L, R> {
  const Either();
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
