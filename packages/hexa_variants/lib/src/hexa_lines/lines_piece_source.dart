import 'package:hexa_engine/hexa_engine.dart';

import 'lines_piece.dart';

/// The random pieces of Hexa Lines (RN-HL-24, D-97): the family by weight,
/// then one of its orientations.
///
/// Each piece takes two draws from the game's generator: `next() mod 100`
/// over the cumulative weights, in the order of the catalog, and then
/// `next() mod n` over the family's `n` orientations, in the order the
/// topology gives them (RN-COM-14). The pieces are not checked against the
/// board: a tray comes out as drawn (RN-HL-25).
final class LinesPieceSource<C extends Coord>
    implements IPieceSource<LinesPiece<C>> {
  /// A source for [catalog] on [topology].
  ///
  /// Throws an [ArgumentError] if [catalog] is empty or its weights do not
  /// add up to [totalWeight].
  LinesPieceSource(GridTopology<C> topology, List<LinesFamily<C>> catalog)
    : _families = List.unmodifiable(catalog),
      orientations = List.unmodifiable([
        for (final family in catalog)
          List<LinesPiece<C>>.unmodifiable([
            for (final shape in topology.orientations(family.shape))
              LinesPiece(shape, family.color),
          ]),
      ]) {
    final total = catalog.fold(0, (sum, family) => sum + family.weight);
    if (total != totalWeight) {
      throw ArgumentError.value(
        total,
        'catalog',
        'weights must add up to $totalWeight',
      );
    }
  }

  /// What the weights of a catalog add up to: the roll is `next() mod 100`
  /// (RN-HL-24).
  static const int totalWeight = 100;

  final List<LinesFamily<C>> _families;

  /// The pieces each family can give, family by family in the catalog order
  /// and each in the order of its orientations (RN-HL-23).
  final List<List<LinesPiece<C>>> orientations;

  @override
  (LinesPiece<C> piece, Xorshift32 after) next(Xorshift32 random) {
    final (roll, afterFamily) = random.nextInt(totalWeight);
    final family = _familyAt(roll);
    final pieces = orientations[family];
    final (orientation, after) = afterFamily.nextInt(pieces.length);
    return (pieces[orientation], after);
  }

  /// The index of the family whose cumulative weight covers [roll].
  int _familyAt(int roll) {
    var cumulative = 0;
    for (final (index, family) in _families.indexed) {
      cumulative += family.weight;
      if (roll < cumulative) return index;
    }
    // Unreachable: the weights add up to totalWeight and roll is below it.
    throw StateError('roll $roll beyond the weights');
  }
}
