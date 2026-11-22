/// How a turn leaves the game, as the rules evaluate it after resolving
/// (RN-COM-23, D-34).
sealed class GameOutcome {
  const GameOutcome();

  /// Outcomes without fields are equal by kind.
  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The game goes on.
final class Ongoing extends GameOutcome {
  const Ongoing();

  @override
  String toString() => 'Ongoing()';
}

/// The player won.
///
/// [canContinue] lets the player keep playing after the victory
/// (RN-COM-31). The rules decide it, so the engine never knows which variant
/// allows it.
final class Victory extends GameOutcome {
  const Victory({this.canContinue = false});

  /// Whether the player may keep playing after this victory.
  final bool canContinue;

  @override
  bool operator ==(Object other) =>
      other is Victory && other.canContinue == canContinue;

  @override
  int get hashCode => Object.hash(Victory, canContinue);

  @override
  String toString() => 'Victory(canContinue: $canContinue)';
}

/// The player lost: the game is over.
final class Defeat extends GameOutcome {
  const Defeat();

  @override
  String toString() => 'Defeat()';
}
