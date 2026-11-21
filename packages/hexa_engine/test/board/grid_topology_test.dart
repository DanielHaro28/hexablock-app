import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

/// The operations tested here are written once in `GridTopology` and shared
/// by every cell shape; `FakeTopology` only provides the per-shape primitives.
void main() {
  const topology = FakeTopology();

  /// The "L of 3" used across the rotation tests.
  final ell = Shape.fromCells(const [
    FakeCoord(0, 0),
    FakeCoord(0, 1),
    FakeCoord(1, 1),
  ]);

  group('RN-COM-16', () {
    test(
      'should_sort_by_row_then_column_when_putting_cells_in_reading_order',
      () {
        // Arrange
        const cells = [FakeCoord(1, 1), FakeCoord(0, 1), FakeCoord(2, 0)];

        // Act
        final sorted = topology.inReadingOrder(cells);

        // Assert
        expect(sorted, const [
          FakeCoord(2, 0),
          FakeCoord(0, 1),
          FakeCoord(1, 1),
        ]);
      },
    );
  });

  group('RN-COM-15', () {
    test('should_move_the_first_cell_in_reading_order_to_the_origin_when_normalizing', () {
      // Arrange
      final shape = Shape.fromCells(const [
        FakeCoord(4, 3),
        FakeCoord(3, 4),
        FakeCoord(4, 4),
      ]);

      // Act
      final normalized = topology.normalize(shape);

      // Assert
      expect(normalized.cells, {
        const FakeCoord(0, 0),
        const FakeCoord(-1, 1),
        const FakeCoord(0, 1),
      });
    });

    test('should_return_an_equal_shape_when_shape_is_already_normalized', () {
      // Arrange
      final shape = ell;

      // Act
      final normalized = topology.normalize(shape);

      // Assert
      expect(normalized, shape);
    });

    test('should_keep_the_parts_when_normalizing_a_composite_shape', () {
      // Arrange
      final shape = CompositeShape([
        const CellShape(FakeCoord(5, 5)),
        Shape.fromCells(const [FakeCoord(6, 5), FakeCoord(6, 6)]),
      ]);

      // Act
      final normalized = topology.normalize(shape);

      // Assert
      expect((normalized as CompositeShape<FakeCoord>).parts, hasLength(2));
    });
  });

  group('RN-COM-14', () {
    test('should_rotate_every_cell_and_normalize_when_rotating_a_shape', () {
      // Arrange
      const turn = FakeTopology.quarterTurn;

      // Act
      final rotated = topology.rotate(ell, turn);

      // Assert: (x, y) → (−y, x) gives {(0,0), (−1,0), (−1,1)}, then the first
      // cell in reading order, (−1, 0), moves to the origin.
      expect(rotated.cells, {
        const FakeCoord(0, 0),
        const FakeCoord(1, 0),
        const FakeCoord(0, 1),
      });
    });

    test('should_return_the_original_shape_when_rotating_a_full_turn', () {
      // Arrange
      const turn = FakeTopology.quarterTurn;

      // Act
      var shape = ell;
      for (var i = 0; i < 4; i++) {
        shape = topology.rotate(shape, turn);
      }

      // Assert
      expect(shape, ell);
    });

    test('should_find_four_orientations_when_shape_is_an_ell', () {
      // Arrange
      final shape = ell;

      // Act
      final orientations = topology.orientations(shape);

      // Assert
      expect(orientations, hasLength(4));
      expect(orientations.toSet(), hasLength(4));
    });

    test('should_find_two_orientations_when_shape_is_a_straight_line', () {
      // Arrange
      final line = Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(1, 0)]);

      // Act
      final orientations = topology.orientations(line);

      // Assert
      expect(orientations, hasLength(2));
    });

    test('should_find_one_orientation_when_every_rotation_looks_the_same', () {
      // Arrange
      final block = Shape.fromCells(const [
        FakeCoord(0, 0),
        FakeCoord(1, 0),
        FakeCoord(0, 1),
        FakeCoord(1, 1),
      ]);

      // Act
      final orientations = topology.orientations(block);

      // Assert
      expect(orientations, [block]);
    });

    test(
      'should_start_with_the_normalized_shape_when_listing_orientations',
      () {
        // Arrange
        final shifted = Shape.fromCells(const [
          FakeCoord(7, 7),
          FakeCoord(7, 8),
          FakeCoord(8, 8),
        ]);

        // Act
        final orientations = topology.orientations(shifted);

        // Assert
        expect(orientations.first, ell);
      },
    );
  });

  group('RN-COM-13', () {
    final cells = topology.cellsOf(ShapeSpec('rectangle', const [4, 1]));

    test('should_follow_the_direction_until_the_border_when_casting_a_ray', () {
      // Arrange
      const from = FakeCoord(1, 0);

      // Act
      final ray = topology.ray(cells, from, FakeTopology.east);

      // Assert
      expect(ray, const [FakeCoord(2, 0), FakeCoord(3, 0)]);
    });

    test('should_be_empty_when_the_ray_starts_at_the_border', () {
      // Arrange
      const from = FakeCoord(0, 0);

      // Act
      final ray = topology.ray(cells, from, FakeTopology.west);

      // Assert
      expect(ray, isEmpty);
    });
  });

  group('D-29', () {
    test('should_recover_the_coordinate_type_when_the_topology_is_stored_as_any_topology', () {
      // Arrange
      const GridTopology<Coord> stored = FakeTopology();

      // Act
      final type = stored.accept(const _CoordTypeVisitor());

      // Assert
      expect(type, FakeCoord);
    });

    test('should_build_a_typed_board_when_visiting_a_stored_topology', () {
      // Arrange
      const GridTopology<Coord> stored = FakeTopology();
      final spec = ShapeSpec('rectangle', const [2, 2]);

      // Act
      final board = stored.accept(_EmptyBoardVisitor(spec));

      // Assert
      expect(board, isA<Board<FakeCoord, FakeCell>>());
      expect(board.cells, hasLength(4));
    });
  });
}

/// Returns the real coordinate type of the visited topology.
final class _CoordTypeVisitor implements TopologyVisitor<Type> {
  const _CoordTypeVisitor();

  @override
  Type visit<C extends Coord>(GridTopology<C> topology) => C;
}

/// Builds an empty board with the real coordinate type, as the composition
/// root does when it opens a game for the shape chosen in Settings.
final class _EmptyBoardVisitor
    implements TopologyVisitor<Board<Coord, FakeCell>> {
  const _EmptyBoardVisitor(this.spec);

  final ShapeSpec spec;

  @override
  Board<Coord, FakeCell> visit<C extends Coord>(GridTopology<C> topology) =>
      Board<C, FakeCell>.of(topology, spec);
}
