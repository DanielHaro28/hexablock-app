/// The seeded random generator of every game: xorshift32 (RN-COM-43, D-14).
///
/// Nothing in the domain uses `Random()` or the clock (RN-COM-40): whatever
/// is random comes from here. The algorithm is G. Marsaglia's xorshift32
/// (shifts 13, 17, 5), written in the domain so that the same seed gives the
/// same sequence on every platform and SDK version (RN-COM-41).
///
/// It is an **immutable value**: drawing returns the value and the generator
/// that comes after it, and never changes this one. So the generator is
/// part of the game state (RN-COM-42): saving it is saving [state], a single
/// integer, and undoing a turn restores it with the rest of the state, so
/// undo never "rolls the dice again".
final class Xorshift32 {
  /// A generator seeded with [seed], an integer that fits in 32 bits
  /// (0 to 4294967295, the range of `seed` in the level contract).
  ///
  /// Xorshift never leaves state 0, so a [seed] of 0 starts from a fixed
  /// nonzero state instead (RN-COM-43), the same one as
  /// `tools/reference-sim` (so seeds 0 and [zeroSeedState] give the same
  /// sequence). A [state] is never 0, so it is also a valid seed:
  /// `Xorshift32(saved.state)` continues the sequence of `saved`.
  ///
  /// Throws an [ArgumentError] if [seed] does not fit in 32 bits.
  Xorshift32(int seed) : state = _initialState(seed);

  const Xorshift32._(this.state);

  /// The state used for a seed of 0: the 32-bit golden ratio, as in
  /// `tools/reference-sim/levelkit.py`.
  static const int zeroSeedState = 0x9E3779B9;

  static const int _mask = 0xFFFFFFFF;

  /// The 32-bit state, never 0. It is all that needs saving.
  final int state;

  static int _initialState(int seed) {
    if (seed < 0 || seed > _mask) {
      throw ArgumentError.value(seed, 'seed', 'must fit in 32 bits');
    }
    return seed == 0 ? zeroSeedState : seed;
  }

  /// The next value, between 1 and 4294967295, and the generator after it.
  (int value, Xorshift32 after) next() {
    var x = state;
    x ^= (x << 13) & _mask;
    x ^= x >> 17;
    x ^= (x << 5) & _mask;
    return (x, Xorshift32._(x));
  }

  /// One of [n] options, from 0 to `n - 1`: `next() mod n` (RN-COM-44).
  ///
  /// Throws an [ArgumentError] if [n] is not positive.
  (int choice, Xorshift32 after) nextInt(int n) {
    if (n <= 0) throw ArgumentError.value(n, 'n', 'must be positive');
    final (value, after) = next();
    return (value % n, after);
  }

  /// Whether something with a probability of [percent] % happens:
  /// `next() mod 100 < percent` (RN-COM-44).
  ///
  /// Throws an [ArgumentError] if [percent] is not between 0 and 100.
  (bool happened, Xorshift32 after) chance(int percent) {
    if (percent < 0 || percent > 100) {
      throw ArgumentError.value(percent, 'percent', 'must be from 0 to 100');
    }
    final (value, after) = next();
    return (value % 100 < percent, after);
  }

  @override
  bool operator ==(Object other) => other is Xorshift32 && other.state == state;

  @override
  int get hashCode => state.hashCode;

  @override
  String toString() => 'Xorshift32($state)';
}
