import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

/// Registers the tests that every [GridTopology] must pass, whatever its cell
/// shape (RN-COM-10 to 17, D-90).
///
/// Call it inside a `group` of the topology's own tests, with a board [spec]
/// the topology accepts. The board must have no holes (every default board of
/// RN-TOP-10 to 12 qualifies), because the line checks expect each line to run
/// from border to border without gaps (RN-COM-12).
///
/// It checks what the engine relies on but cannot enforce with types:
/// coordinates compare by value, neighbors come in the same order around every
/// cell of the same type, cells come in reading order, `step`, the `forward`
/// sense of each direction and `lines` agree, `normalize` is idempotent and
/// `place` keeps the shape. What is specific to one shape (the clockwise
/// neighbor order, the board sizes) is tested by that topology's own tests.
void checkTopologyContract<C extends Coord>(
  GridTopology<C> topology,
  ShapeSpec spec,
) {
  Set<C> board() => topology.cellsOf(spec);

  /// One small shape per cell: the cell and its neighbors on the board.
  List<Shape<C>> smallShapes(Set<C> cells) => [
    for (final cell in cells)
      Shape.fromCells([
        cell,
        ...topology.neighbors(cell).where(cells.contains),
      ]),
  ];

  C firstInReadingOrder(Iterable<C> cells) =>
      topology.inReadingOrder(cells).first;

  test('should_find_equal_cells_when_the_board_is_built_twice', () {
    // Arrange
    final first = board();

    // Act
    final second = board();

    // Assert
    expect(second, equals(first));
    for (final cell in first) {
      final copy = second.lookup(cell);
      expect(copy, isNotNull, reason: '$cell needs value equality');
      expect(copy.hashCode, cell.hashCode, reason: '$cell needs a hashCode');
    }
  });

  test('should_list_the_cells_in_reading_order_when_building_a_board', () {
    // Arrange
    final cells = board();

    // Act
    final sorted = topology.inReadingOrder(cells);

    // Assert
    expect(cells.toList(), sorted);
  });

  test('should_compare_as_zero_only_the_same_cell_when_using_reading_order', () {
    // Arrange
    final cells = board();

    for (final a in cells) {
      for (final b in cells) {
        // Act
        final ab = topology.compareReadingOrder(a, b);
        final ba = topology.compareReadingOrder(b, a);

        // Assert
        expect(ab == 0, a == b, reason: 'comparing $a and $b');
        expect(ab.sign, -ba.sign, reason: 'comparing $a and $b');
      }
    }
  });

  test('should_list_distinct_neighbors_other_than_the_cell_when_asking_for_neighbors', () {
    // Arrange
    final cells = board();

    for (final cell in cells) {
      // Act
      final neighbors = topology.neighbors(cell);

      // Assert
      expect(neighbors, isNotEmpty, reason: 'neighbors of $cell');
      expect(neighbors.toSet(), hasLength(neighbors.length));
      expect(neighbors, isNot(contains(cell)));
    }
  });

  test('should_be_mutual_when_two_cells_are_neighbors', () {
    // Arrange
    final cells = board();

    for (final cell in cells) {
      // Act
      final neighbors = topology.neighbors(cell);

      // Assert
      for (final neighbor in neighbors) {
        expect(
          topology.neighbors(neighbor),
          contains(cell),
          reason: '$neighbor is a neighbor of $cell',
        );
      }
    }
  });

  test('should_keep_the_neighbor_order_when_moving_to_a_cell_of_the_same_type', () {
    // Arrange: one reference cell per cell type (RN-COM-17).
    final cells = board();
    final references = <C, C>{};
    for (final cell in cells) {
      references.putIfAbsent(topology.normalizationOrigin(cell), () => cell);
    }

    for (final cell in cells) {
      final reference = references[topology.normalizationOrigin(cell)]!;

      // Act
      final moved = [
        for (final neighbor in topology.neighbors(reference))
          topology.translate(neighbor, reference, cell),
      ];

      // Assert
      expect(topology.neighbors(cell), moved, reason: 'neighbors of $cell');
    }
  });

  test('should_keep_neighbors_together_when_rotating_a_cell', () {
    // Arrange
    final cells = board();

    for (final rotation in topology.basicRotations) {
      for (final cell in cells) {
        // Act
        final turned = topology.rotateCell(cell, rotation);

        // Assert
        for (final neighbor in topology.neighbors(cell)) {
          expect(
            topology.neighbors(turned),
            contains(topology.rotateCell(neighbor, rotation)),
            reason: '$neighbor next to $cell after $rotation',
          );
        }
      }
    }
  });

  test('should_have_one_direction_each_way_when_looking_at_an_axis', () {
    // Arrange
    final directions = topology.directions;

    // Act
    for (final axis in topology.axes) {
      final along = directions.where((d) => d.axis == axis);

      // Assert
      expect(along.where((d) => d.forward), hasLength(1), reason: '$axis');
      expect(along.where((d) => !d.forward), hasLength(1), reason: '$axis');
    }
    expect(
      directions.map((d) => d.axis).toSet(),
      topology.axes.toSet(),
      reason: 'every direction runs along a known axis',
    );
  });

  test('should_cover_every_cell_once_when_listing_the_lines_of_an_axis', () {
    // Arrange
    final cells = board();

    for (final axis in topology.axes) {
      // Act
      final lines = topology.lines(cells, axis).toList();
      final covered = [for (final line in lines) ...line];

      // Assert
      expect(lines, everyElement(isNotEmpty), reason: '$axis');
      expect(covered, hasLength(cells.length), reason: '$axis');
      expect(covered.toSet(), equals(cells), reason: '$axis');
    }
  });

  test('should_step_along_the_line_when_moving_in_a_direction', () {
    // Arrange
    final cells = board();

    for (final axis in topology.axes) {
      final forward = _direction(topology, axis, forward: true);
      final backward = _direction(topology, axis, forward: false);

      // Act
      final lines = topology.lines(cells, axis);

      // Assert
      for (final line in lines) {
        for (var i = 0; i + 1 < line.length; i++) {
          expect(topology.step(line[i], forward), line[i + 1]);
          expect(topology.step(line[i + 1], backward), line[i]);
        }
        expect(cells, isNot(contains(topology.step(line.last, forward))));
        expect(cells, isNot(contains(topology.step(line.first, backward))));
      }
    }
  });

  test('should_return_the_rest_of_the_line_when_casting_a_ray_from_its_end', () {
    // Arrange
    final cells = board();

    for (final axis in topology.axes) {
      final forward = _direction(topology, axis, forward: true);
      final backward = _direction(topology, axis, forward: false);

      for (final line in topology.lines(cells, axis)) {
        // Act
        final ahead = topology.ray(cells, line.first, forward).toList();
        final behind = topology.ray(cells, line.last, backward).toList();

        // Assert
        expect(ahead, line.sublist(1));
        expect(behind, line.reversed.skip(1).toList());
      }
    }
  });

  test('should_return_the_same_shape_when_normalizing_twice', () {
    // Arrange
    final cells = board();
    final shapes = [...smallShapes(cells), Shape.fromCells(cells)];

    for (final shape in shapes) {
      // Act
      final once = topology.normalize(shape);
      final twice = topology.normalize(once);

      // Assert
      expect(twice, once, reason: 'normalizing $shape');
    }
  });

  test('should_put_the_first_cell_on_the_origin_of_its_type_when_normalizing', () {
    // Arrange
    final shapes = smallShapes(board());

    for (final shape in shapes) {
      // Act
      final first = firstInReadingOrder(topology.normalize(shape).cells);

      // Assert
      expect(first, topology.normalizationOrigin(first));
    }
  });

  test('should_keep_the_shape_when_placing_it_on_an_anchor_of_its_type', () {
    // Arrange
    final cells = board();
    final shape = smallShapes(cells).first;
    final type = topology.normalizationOrigin(firstInReadingOrder(shape.cells));

    for (final anchor in cells) {
      // Act
      final placed = topology.place(shape, anchor);

      // Assert (D-92)
      if (topology.normalizationOrigin(anchor) != type) {
        expect(placed, isNull, reason: 'anchor $anchor of another type');
        continue;
      }
      expect(placed, isNotNull, reason: 'anchor $anchor');
      expect(firstInReadingOrder(placed!), anchor);
      expect(
        topology.normalize(Shape.fromCells(placed)),
        topology.normalize(shape),
      );
    }
  });

  test('should_throw_when_given_an_axis_rotation_or_kind_of_another_topology', () {
    // Arrange
    final cells = board();
    const foreignAxis = Axis('not-an-axis');
    const foreignRotation = Rotation('not-a-rotation');
    final foreignSpec = ShapeSpec('not-a-kind', spec.size);

    // Act and assert
    expect(
      () => topology.lines(cells, foreignAxis).toList(),
      throwsArgumentError,
    );
    expect(
      () => topology.rotateCell(cells.first, foreignRotation),
      throwsArgumentError,
    );
    expect(() => topology.cellsOf(foreignSpec), throwsArgumentError);
  });
}

Direction _direction<C extends Coord>(
  GridTopology<C> topology,
  Axis axis, {
  required bool forward,
}) => topology.directions.firstWhere(
  (d) => d.axis == axis && d.forward == forward,
);
