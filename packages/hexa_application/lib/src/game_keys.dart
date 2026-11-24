/// The keys the app uses to find what belongs to a profile and a game
/// (ARQ-03 §3, D-25, RN-COM-80).
library;

/// A local profile: `guest` or the `sub` of an account (ARQ-04 §2).
final class ProfileId {
  /// The profile [value].
  const ProfileId(this.value);

  /// The guest profile, which always exists (D-05).
  static const guest = ProfileId('guest');

  /// The id as stored.
  final String value;

  @override
  bool operator ==(Object other) => other is ProfileId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ProfileId($value)';
}

/// A variant played with a cell shape: its `gameId` and its topology id.
final class GameKey {
  /// The key of [gameId] played on [topologyId].
  const GameKey(this.gameId, this.topologyId);

  /// The `gameId` of the contract.
  final String gameId;

  /// The id of the topology (`GridTopology.id`).
  final String topologyId;

  @override
  bool operator ==(Object other) =>
      other is GameKey &&
      other.gameId == gameId &&
      other.topologyId == topologyId;

  @override
  int get hashCode => Object.hash(gameId, topologyId);

  @override
  String toString() => 'GameKey($gameId, $topologyId)';
}

/// The saved game of a [profile] in a [game]: there is only one
/// (RN-COM-33, D-37).
final class SavedGameKey {
  /// The key of the game that [profile] saved in [game].
  const SavedGameKey(this.profile, this.game);

  /// Whose game it is.
  final ProfileId profile;

  /// Which variant and cell shape.
  final GameKey game;

  @override
  bool operator ==(Object other) =>
      other is SavedGameKey && other.profile == profile && other.game == game;

  @override
  int get hashCode => Object.hash(profile, game);

  @override
  String toString() => 'SavedGameKey($profile, $game)';
}
