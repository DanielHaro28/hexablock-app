/// The shape of a board as plain data (D-90): a `kind` and its `size`.
///
/// It comes from configuration (`assets/config/<gameId>.json`, RN-TOP-10 to
/// 12) and is turned into cells by `GridTopology.cellsOf` (Factory Method).
/// Each topology accepts its own kinds and rejects the rest, for example:
///
/// | Topology  | Spec                          | Board                   |
/// |-----------|-------------------------------|-------------------------|
/// | hexagons  | `ShapeSpec('hexagon', [4])`   | radius 4, 61 cells      |
/// | squares   | `ShapeSpec('rectangle', [8, 8])` | 8 × 8                |
/// | triangles | `ShapeSpec('hexagon', [3])`   | hexagon of side 3       |
/// | cubes     | `ShapeSpec('box', [4, 4, 4])` | 4 × 4 × 4               |
///
/// Being data, the engine needs no class per board shape, and a new board size
/// in the defense is a configuration change only (EXTENSIBILITY.md).
final class ShapeSpec {
  /// Copies [size], so later changes to the caller's list do not leak in.
  ShapeSpec(this.kind, List<int> size) : size = List.unmodifiable(size);

  /// What kind of board, in the vocabulary of the topology.
  final String kind;

  /// Its dimensions; how many and what they mean depends on [kind].
  final List<int> size;

  @override
  bool operator ==(Object other) =>
      other is ShapeSpec &&
      other.kind == kind &&
      other.size.length == size.length &&
      Iterable<int>.generate(size.length)
          .every((i) => other.size[i] == size[i]);

  @override
  int get hashCode => Object.hash(kind, Object.hashAll(size));

  @override
  String toString() => 'ShapeSpec($kind, $size)';
}
