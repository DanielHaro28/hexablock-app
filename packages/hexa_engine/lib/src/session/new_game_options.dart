/// What a new game needs to start, whatever the variant (D-124): the
/// argument of `VariantFamily.createSession`.
///
/// It is a type of the engine, not of the use cases, because
/// `VariantFamily` lives here (layer 1) and cannot depend on layer 2. The
/// `StartOptions` of `StartGameUseCase` (ARQ-03 §3) carries one of these
/// besides whether to continue or start anew; continuing does not need it,
/// because a saved game already has its generator (D-116).
///
/// A field that only some variants read (for example, the level of Hexa Fit
/// and Hexa Sort) is added here when that variant needs it, so no factory
/// changes its signature.
final class NewGameOptions {
  /// Options for a game that starts from [seed].
  ///
  /// The domain never picks a seed on its own (RN-COM-40): when the player
  /// gives none, the use case draws a new one and the state records it, so
  /// the game can be replayed (RN-COM-45).
  ///
  /// Throws an [ArgumentError] if [seed] does not fit in 32 bits (0 to
  /// 4294967295, the range of `Xorshift32` and of the level contract), so a
  /// bad seed fails where it is chosen and not inside a factory.
  NewGameOptions({required this.seed}) {
    if (seed < 0 || seed > _maxSeed) {
      throw ArgumentError.value(seed, 'seed', 'must fit in 32 bits');
    }
  }

  static const int _maxSeed = 0xFFFFFFFF;

  /// The seed of the game's generator (RN-COM-41 to 43).
  final int seed;

  @override
  bool operator ==(Object other) =>
      other is NewGameOptions && other.seed == seed;

  @override
  int get hashCode => seed.hashCode;

  @override
  String toString() => 'NewGameOptions(seed: $seed)';
}
