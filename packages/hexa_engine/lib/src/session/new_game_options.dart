import '../random/xorshift32.dart';

/// What a new game needs to start, whatever the variant (D-124): the
/// argument of `VariantFamily.createSession`.
///
/// It is a type of the engine, not of the use cases, because
/// `VariantFamily` lives here (layer 1) and cannot depend on layer 2. The
/// `StartOptions` of `StartGameUseCase` (ARQ-03 §3) carries one of these
/// besides whether to continue or start anew; continuing does not need it,
/// because a saved game already has its generator (D-116) and its level
/// (D-165).
///
/// A new field is added here, not as a parameter of `createSession`, so no
/// factory changes its signature (D-124). That is how [levelId] came in
/// (D-125): the factories of variants not played by levels ignore it.
final class NewGameOptions {
  /// Options for a game that starts from [seed] and, in a variant played by
  /// levels, on the level [levelId].
  ///
  /// The domain never picks a seed on its own (RN-COM-40): when the player
  /// gives none, the use case draws a new one and the state records it, so
  /// the game can be replayed (RN-COM-45).
  ///
  /// Throws an [ArgumentError] if [seed] is not between 0 and
  /// [Xorshift32.maxSeed], so a bad seed fails where it is chosen and not
  /// inside a factory.
  NewGameOptions({required this.seed, this.levelId}) {
    if (seed < 0 || seed > Xorshift32.maxSeed) {
      throw ArgumentError.value(seed, 'seed', 'must fit in 32 bits');
    }
  }

  /// The seed of the game's generator (RN-COM-41 to 43).
  final int seed;

  /// The id of the chosen level, as the contract writes it (D-104), or
  /// `null` in a variant not played by levels.
  ///
  /// The engine only carries it: a level-based factory looks it up in the
  /// level catalog of its cell shape and throws an [ArgumentError] when it
  /// is `null` or not in the catalog (D-125). That is why it is not checked
  /// here: whether an id exists depends on the catalog.
  final String? levelId;

  @override
  bool operator ==(Object other) =>
      other is NewGameOptions && other.seed == seed && other.levelId == levelId;

  @override
  int get hashCode => Object.hash(seed, levelId);

  @override
  String toString() => 'NewGameOptions(seed: $seed, levelId: $levelId)';
}
