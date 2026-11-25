import 'package:hexa_engine/hexa_engine.dart';

/// A piece source that hands out given [pieces] in order (D-56): a test
/// chooses exactly the tray the rules will draw, with no search for a seed.
///
/// It stays a real source: each piece belongs to one state of the generator,
/// the chain that starts at `from`, so the same generator always gives the
/// same piece (RN-COM-41) and undoing a draw draws it again. Like every
/// source, it keeps no generator of its own (D-97).
final class StubPieceSource<TPiece> implements IPieceSource<TPiece> {
  /// Hands out [pieces] in order to the generators that follow [from]:
  /// [from] gives the first one, the generator after it the second, and so
  /// on.
  StubPieceSource(Xorshift32 from, List<TPiece> pieces)
    : _draws = _chain(from, pieces);

  final Map<Xorshift32, (TPiece, Xorshift32)> _draws;

  static Map<Xorshift32, (TPiece, Xorshift32)> _chain<TPiece>(
    Xorshift32 from,
    List<TPiece> pieces,
  ) {
    final draws = <Xorshift32, (TPiece, Xorshift32)>{};
    var current = from;
    for (final piece in pieces) {
      final (_, after) = current.next();
      draws[current] = (piece, after);
      current = after;
    }
    return draws;
  }

  /// The piece of [random] and the generator after it.
  ///
  /// Throws a [StateError] if [random] is not in the chain: the test drew
  /// more pieces than it gave, or from another generator.
  @override
  (TPiece piece, Xorshift32 after) next(Xorshift32 random) =>
      _draws[random] ??
      (throw StateError('StubPieceSource: no piece for $random'));
}
