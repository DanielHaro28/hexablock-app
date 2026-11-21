import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  const topology = FakeTopology();
  const red = FakeCell('red');
  const blue = FakeCell('blue');

  /// A 3 × 2 board:
  ///   (0,0) (1,0) (2,0)
  ///   (0,1) (1,1) (2,1)
  Board<FakeCoord, FakeCell> board3x2() =>
      Board.of(topology, ShapeSpec('rectangle', const [3, 2]));

  group('RN-COM-10', () {
    test('should_create_every_cell_empty_when_built_from_a_shape_spec', () {
      // Arrange
      final spec = ShapeSpec('rectangle', const [3, 2]);

      // Act
      final board = Board<FakeCoord, FakeCell>.of(topology, spec);

      // Assert
      expect(board.cells, hasLength(6));
      expect(board.emptyCells, hasLength(6));
    });

    test(
      'should_keep_the_cells_in_reading_order_when_built_from_unordered_cells',
      () {
        // Arrange
        const cells = [FakeCoord(1, 1), FakeCoord(0, 0), FakeCoord(0, 1)];

        // Act
        final board = Board<FakeCoord, FakeCell>(topology, cells);

        // Assert
        expect(board.cells, const [
          FakeCoord(0, 0),
          FakeCoord(0, 1),
          FakeCoord(1, 1),
        ]);
      },
    );

    test('should_throw_when_built_without_cells', () {
      // Arrange
      const cells = <FakeCoord>[];

      // Act
      Board<FakeCoord, FakeCell> create() => Board(topology, cells);

      // Assert
      expect(create, throwsArgumentError);
    });

    test('should_return_null_when_the_cell_is_empty', () {
      // Arrange
      final board = board3x2();

      // Act
      final content = board.cell(const FakeCoord(1, 1));

      // Assert
      expect(content, isNull);
    });

    test('should_throw_when_reading_a_cell_outside_the_board', () {
      // Arrange
      final board = board3x2();

      // Act
      FakeCell? read() => board.cell(const FakeCoord(5, 0));

      // Assert
      expect(read, throwsArgumentError);
    });

    test('should_report_whether_a_coordinate_belongs_to_the_board', () {
      // Arrange
      final board = board3x2();

      // Act
      final inside = board.contains(const FakeCoord(2, 1));
      final outside = board.contains(const FakeCoord(3, 1));

      // Assert
      expect(inside, isTrue);
      expect(outside, isFalse);
    });

    test('should_return_the_content_when_the_cell_was_filled', () {
      // Arrange
      final board = board3x2();

      // Act
      final filled = board.withCells({const FakeCoord(1, 0): red});

      // Assert
      expect(filled.cell(const FakeCoord(1, 0)), red);
    });

    test('should_leave_the_original_board_unchanged_when_cells_change', () {
      // Arrange
      final board = board3x2();

      // Act
      board.withCells({const FakeCoord(1, 0): red});

      // Assert
      expect(board.cell(const FakeCoord(1, 0)), isNull);
    });

    test('should_empty_the_cell_when_the_change_is_null', () {
      // Arrange
      final board = board3x2().withCells({const FakeCoord(1, 0): red});

      // Act
      final cleared = board.withCells({const FakeCoord(1, 0): null});

      // Assert
      expect(cleared.cell(const FakeCoord(1, 0)), isNull);
    });

    test('should_throw_when_changing_a_cell_outside_the_board', () {
      // Arrange
      final board = board3x2();

      // Act
      Board<FakeCoord, FakeCell> change() =>
          board.withCells({const FakeCoord(-1, 0): red});

      // Assert
      expect(change, throwsArgumentError);
    });

    test(
      'should_list_occupied_cells_in_reading_order_when_asked_for_contents',
      () {
        // Arrange
        final board = board3x2().withCells({
          const FakeCoord(0, 1): blue,
          const FakeCoord(2, 0): red,
        });

        // Act
        final contents = board.contents;

        // Assert
        expect(contents.keys, const [FakeCoord(2, 0), FakeCoord(0, 1)]);
        expect(contents.values, const [red, blue]);
      },
    );

    test('should_list_only_empty_cells_when_asked_for_empty_cells', () {
      // Arrange
      final board = board3x2().withCells({
        const FakeCoord(0, 0): red,
        const FakeCoord(1, 1): blue,
      });

      // Act
      final empty = board.emptyCells;

      // Assert
      expect(empty, const [
        FakeCoord(1, 0),
        FakeCoord(2, 0),
        FakeCoord(0, 1),
        FakeCoord(2, 1),
      ]);
    });

    test('should_be_full_when_every_cell_is_occupied', () {
      // Arrange
      final board = Board<FakeCoord, FakeCell>(topology, const [
        FakeCoord(0, 0),
        FakeCoord(1, 0),
      ]);

      // Act
      final full = board.withCells({
        const FakeCoord(0, 0): red,
        const FakeCoord(1, 0): blue,
      });

      // Assert
      expect(board.isFull, isFalse);
      expect(full.isFull, isTrue);
    });

    test('should_be_equal_when_boards_have_the_same_cells_and_contents', () {
      // Arrange
      final a = board3x2().withCells({const FakeCoord(0, 0): red});
      final b = board3x2().withCells({const FakeCoord(0, 0): red});

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('should_show_the_topology_and_contents_when_described', () {
      // Arrange
      final board = board3x2().withCells({const FakeCoord(1, 0): red});

      // Act
      final description = board.toString();

      // Assert: what a failing expectation prints
      expect(description, 'Board(fake, 6 cells, {(1, 0): FakeCell(red)})');
    });

    test('should_not_be_equal_when_contents_differ', () {
      // Arrange
      final a = board3x2().withCells({const FakeCoord(0, 0): red});
      final b = board3x2().withCells({const FakeCoord(0, 0): blue});

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });
  });

  group('RN-COM-11', () {
    test(
      'should_drop_neighbors_outside_the_board_when_the_cell_is_on_the_border',
      () {
        // Arrange
        final board = board3x2();

        // Act
        final neighbors = board.neighbors(const FakeCoord(0, 0));

        // Assert
        expect(neighbors, const [FakeCoord(1, 0), FakeCoord(0, 1)]);
      },
    );

    test(
      'should_throw_when_asking_for_neighbors_of_a_cell_outside_the_board',
      () {
        // Arrange
        final board = board3x2();

        // Act
        List<FakeCoord> neighbors() => board.neighbors(const FakeCoord(9, 9));

        // Assert
        expect(neighbors, throwsArgumentError);
      },
    );
  });

  group('RN-COM-17', () {
    test(
      'should_list_neighbors_in_the_topology_order_when_the_cell_is_inside',
      () {
        // Arrange
        final board = Board<FakeCoord, FakeCell>.of(
          topology,
          ShapeSpec('rectangle', const [3, 3]),
        );

        // Act
        final neighbors = board.neighbors(const FakeCoord(1, 1));

        // Assert: north, east, south, west (clockwise from 12 o'clock)
        expect(neighbors, const [
          FakeCoord(1, 0),
          FakeCoord(2, 1),
          FakeCoord(1, 2),
          FakeCoord(0, 1),
        ]);
      },
    );
  });

  group('RN-COM-12', () {
    test('should_return_the_lines_of_every_axis_when_asked_for_all_lines', () {
      // Arrange
      final board = board3x2();

      // Act
      final lines = board.lines();

      // Assert: 2 rows of 3, then 3 columns of 2
      expect(lines, const [
        [FakeCoord(0, 0), FakeCoord(1, 0), FakeCoord(2, 0)],
        [FakeCoord(0, 1), FakeCoord(1, 1), FakeCoord(2, 1)],
        [FakeCoord(0, 0), FakeCoord(0, 1)],
        [FakeCoord(1, 0), FakeCoord(1, 1)],
        [FakeCoord(2, 0), FakeCoord(2, 1)],
      ]);
    });

    test(
      'should_return_only_the_lines_of_that_axis_when_asked_for_one_axis',
      () {
        // Arrange
        final board = board3x2();

        // Act
        final lines = board.linesAlong(FakeTopology.columns);

        // Assert
        expect(lines, hasLength(3));
      },
    );
  });

  group('RN-COM-13', () {
    test('should_stop_the_ray_at_the_border_when_cast_from_a_board_cell', () {
      // Arrange
      final board = board3x2();

      // Act
      final ray = board.ray(const FakeCoord(0, 1), FakeTopology.east);

      // Assert
      expect(ray, const [FakeCoord(1, 1), FakeCoord(2, 1)]);
    });

    test('should_throw_when_the_ray_starts_outside_the_board', () {
      // Arrange
      final board = board3x2();

      // Act
      Iterable<FakeCoord> ray() =>
          board.ray(const FakeCoord(7, 0), FakeTopology.west);

      // Assert
      expect(ray, throwsArgumentError);
    });
  });
}
