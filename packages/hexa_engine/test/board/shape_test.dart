import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  group('Shape (Composite, D-35)', () {
    test('should_contain_its_cell_when_shape_is_a_single_cell', () {
      // Arrange
      const shape = CellShape(FakeCoord(2, 3));

      // Act
      final cells = shape.cells;

      // Assert
      expect(cells, {const FakeCoord(2, 3)});
    });

    test('should_contain_the_cells_of_every_part_when_shape_is_composite', () {
      // Arrange
      final region = Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(1, 0)]);
      final shape = CompositeShape([region, const CellShape(FakeCoord(0, 1))]);

      // Act
      final cells = shape.cells;

      // Assert
      expect(cells, {
        const FakeCoord(0, 0),
        const FakeCoord(1, 0),
        const FakeCoord(0, 1),
      });
    });

    test('should_transform_every_part_when_composite_is_mapped', () {
      // Arrange
      final shape = CompositeShape([
        Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(1, 0)]),
        const CellShape(FakeCoord(0, 1)),
      ]);

      // Act
      final moved = shape.map((c) => FakeCoord(c.x + 10, c.y));

      // Assert
      expect(moved, isA<CompositeShape<FakeCoord>>());
      expect((moved as CompositeShape<FakeCoord>).parts, hasLength(2));
      expect(moved.cells, {
        const FakeCoord(10, 0),
        const FakeCoord(11, 0),
        const FakeCoord(10, 1),
      });
    });

    test(
      'should_be_equal_when_shapes_have_the_same_cells_built_differently',
      () {
        // Arrange
        final byParts = CompositeShape([
          Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(1, 0)]),
          const CellShape(FakeCoord(0, 1)),
        ]);
        final byCells = Shape.fromCells(const [
          FakeCoord(0, 1),
          FakeCoord(1, 0),
          FakeCoord(0, 0),
        ]);

        // Act
        final equal = byParts == byCells;

        // Assert
        expect(equal, isTrue);
        expect(byParts.hashCode, byCells.hashCode);
      },
    );

    test('should_not_be_equal_when_shapes_have_different_cells', () {
      // Arrange
      final a = Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(1, 0)]);
      final b = Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(0, 1)]);

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });

    test('should_list_its_cells_when_described', () {
      // Arrange
      final shape = Shape.fromCells(const [FakeCoord(0, 0), FakeCoord(1, 0)]);

      // Act
      final description = shape.toString();

      // Assert: what a failing expectation prints
      expect(description, 'Shape{(0, 0), (1, 0)}');
    });

    test('should_throw_when_composite_has_no_parts', () {
      // Arrange
      const parts = <Shape<FakeCoord>>[];

      // Act
      CompositeShape<FakeCoord> create() => CompositeShape(parts);

      // Assert
      expect(create, throwsArgumentError);
    });

    test('should_keep_its_cells_when_the_parts_list_changes_later', () {
      // Arrange
      final parts = <Shape<FakeCoord>>[const CellShape(FakeCoord(0, 0))];
      final shape = CompositeShape(parts);

      // Act
      parts.add(const CellShape(FakeCoord(5, 5)));

      // Assert
      expect(shape.cells, {const FakeCoord(0, 0)});
    });
  });

  group('ShapeSpec (D-90)', () {
    test('should_be_equal_when_kind_and_size_match', () {
      // Arrange
      final a = ShapeSpec('rectangle', const [3, 2]);
      final b = ShapeSpec('rectangle', [3, 2]);

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('should_not_be_equal_when_size_differs', () {
      // Arrange
      final a = ShapeSpec('rectangle', const [3, 2]);
      final b = ShapeSpec('rectangle', const [2, 3]);

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });

    test('should_keep_its_size_when_the_source_list_changes_later', () {
      // Arrange
      final size = [3, 2];
      final spec = ShapeSpec('rectangle', size);

      // Act
      size[0] = 99;

      // Assert
      expect(spec.size, [3, 2]);
    });
  });
}
