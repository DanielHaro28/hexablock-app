import 'package:hexa_engine/hexa_engine.dart';

/// A plain 2D coordinate for the engine tests (D-56).
///
/// It belongs to no real cell shape on purpose: the engine tests prove that
/// `Board` and `GridTopology` work with any `Coord` (RNF-01, RNF-04).
final class FakeCoord extends Coord {
  const FakeCoord(this.x, this.y);

  /// Column, growing to the right.
  final int x;

  /// Row, growing downwards.
  final int y;

  @override
  bool operator ==(Object other) =>
      other is FakeCoord && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}
