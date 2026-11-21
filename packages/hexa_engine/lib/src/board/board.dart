import 'coord.dart';
import 'geometry.dart';
import 'grid_topology.dart';
import 'shape_spec.dart';

/// An immutable board: which cells exist and what each one holds (D-07, D-30).
///
/// It is the abstraction side of the Bridge (D-35): the geometry (neighbors,
/// lines, rays) is delegated to its [topology], so the same class serves every
/// variant and every cell shape. A variant's state holds one board and gets a
/// new one from [withCells]; nothing changes the old board, so an earlier
/// state is already the memento for undo (D-31).
///
/// Type constraints (ARQ-02 Â§4.3):
/// - `C extends Coord`: coordinates are keys of the board, so they need value
///   equality.
/// - `TCell extends Object`: no nullable content, so [cell] returning `null`
///   always means "empty cell" (D-30).
///
/// A coordinate that is not on the board is a programming error, not an empty
/// cell: [cell], [withCells], [neighbors] and [ray] throw [ArgumentError] for
/// it. Use [contains] to ask first.
final class Board<C extends Coord, TCell extends Object> {
  /// An empty board with exactly [cells] (for example, a level's figure).
  /// Throws [ArgumentError] if [cells] is empty.
  Board(GridTopology<C> topology, Iterable<C> cells)
    : this._(
        topology,
        Set.unmodifiable(topology.inReadingOrder(cells.toSet())),
        Map.unmodifiable(<C, TCell>{}),
      );

  /// An empty board of the shape [spec] (for example, a hexagon of radius 4,
  /// RN-TOP-10). The topology builds the cells (Factory Method).
  Board.of(GridTopology<C> topology, ShapeSpec spec)
    : this(topology, topology.cellsOf(spec));

  Board._(this.topology, this.cells, this._contents) {
    if (cells.isEmpty) {
      throw ArgumentError.value(cells, 'cells', 'a board needs a cell');
    }
  }

  /// The geometry of the grid.
  final GridTopology<C> topology;

  /// Every cell of the board, in reading order (RN-COM-16).
  final Set<C> cells;

  /// Occupied cells only, in reading order.
  final Map<C, TCell> _contents;

  /// Whether [coord] is a cell of this board.
  bool contains(C coord) => cells.contains(coord);

  /// What [coord] holds, or `null` if it is empty.
  TCell? cell(C coord) {
    _checkOnBoard(coord);
    return _contents[coord];
  }

  /// A new board with [changes] applied: a value fills the cell, `null`
  /// empties it. This board does not change.
  Board<C, TCell> withCells(Map<C, TCell?> changes) {
    for (final coord in changes.keys) {
      _checkOnBoard(coord);
    }
    final contents = <C, TCell>{
      for (final coord in cells)
        if (changes.containsKey(coord) ? changes[coord] : _contents[coord]
            case final content?)
          coord: content,
    };
    return Board._(topology, cells, Map.unmodifiable(contents));
  }

  /// The occupied cells and their contents, in reading order.
  Map<C, TCell> get contents => _contents;

  /// The empty cells, in reading order.
  Iterable<C> get emptyCells =>
      cells.where((coord) => !_contents.containsKey(coord));

  /// Whether every cell is occupied (for example, a fully covered figure).
  bool get isFull => _contents.length == cells.length;

  /// The neighbors of [coord] that are on the board, in the topology's order
  /// (RN-COM-11, RN-COM-17).
  List<C> neighbors(C coord) {
    _checkOnBoard(coord);
    return [
      for (final neighbor in topology.neighbors(coord))
        if (contains(neighbor)) neighbor,
    ];
  }

  /// Every line of the board, axis after axis in the topology's order
  /// (RN-COM-12).
  Iterable<List<C>> lines() => [
    for (final axis in topology.axes) ...linesAlong(axis),
  ];

  /// The lines of the board along [axis] (RN-COM-12).
  Iterable<List<C>> linesAlong(Axis axis) => topology.lines(cells, axis);

  /// The cells after [from] along [direction] up to the border (RN-COM-13).
  /// Lazy, but [from] is checked right away.
  Iterable<C> ray(C from, Direction direction) {
    _checkOnBoard(from);
    return topology.ray(cells, from, direction);
  }

  void _checkOnBoard(C coord) {
    if (!contains(coord)) {
      throw ArgumentError.value(coord, 'coord', 'not a cell of this board');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Board<C, TCell> &&
      other.topology == topology &&
      other.cells.length == cells.length &&
      other.cells.containsAll(cells) &&
      other._contents.length == _contents.length &&
      _contents.entries.every((e) => other._contents[e.key] == e.value);

  @override
  int get hashCode => Object.hash(
    topology,
    Object.hashAllUnordered(cells),
    Object.hashAllUnordered(
      _contents.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );

  @override
  String toString() =>
      'Board(${topology.id}, ${cells.length} cells, '
      '$_contents)';
}
