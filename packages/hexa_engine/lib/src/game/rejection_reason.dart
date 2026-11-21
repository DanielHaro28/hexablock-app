/// Why a move was rejected (D-95).
///
/// The hierarchy is open, like `GameEvent` (D-32): the engine defines the
/// generic reasons and each variant may add its own sealed family (for
/// example, "the piece does not fit") without changing the engine
/// (RNF-03). It carries no text: the presentation layer turns each reason
/// into a translated message (RNF-50).
///
/// Reasons without fields are equal by kind; a reason with fields overrides
/// `==` and `hashCode`.
abstract base class RejectionReason {
  const RejectionReason();

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The generic reason of the rules: the move is not valid (RN-COM-21).
///
/// Rules that need no reason of their own return `const InvalidMove()`.
final class InvalidMove extends RejectionReason {
  const InvalidMove();

  @override
  String toString() => 'InvalidMove()';
}
