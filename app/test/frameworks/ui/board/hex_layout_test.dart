import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexablock_app/frameworks/ui/board/hex_layout.dart';

void main() {
  const layout = HexLayout();
  final radius4 = const HexTopology().cellsOf(
    ShapeSpec(HexTopology.hexagon, const [4]),
  );

  group('RN-HEX-01', () {
    test('should_give_back_each_cell_when_reading_its_own_center', () {
      // Arrange
      final cells = radius4;

      // Act
      final read = [
        for (final cell in cells) layout.cellAt(layout.centerOf(cell)),
      ];

      // Assert
      expect(read, cells.toList());
    });

    test('should_draw_the_east_neighbor_to_the_right_on_the_same_row', () {
      // Arrange
      const cell = HexCoord(0, 0);

      // Act
      final east = layout.centerOf(const HexCoord(1, 0));

      // Assert
      expect(east.dy, closeTo(layout.centerOf(cell).dy, 1e-9));
      expect(east.dx, closeTo(math.sqrt(3), 1e-9));
    });

    test('should_draw_the_next_row_lower_when_r_grows', () {
      // Arrange
      const cell = HexCoord(0, 1);

      // Act
      final center = layout.centerOf(cell);

      // Assert
      expect(center.dy, closeTo(1.5, 1e-9));
      expect(center.dx, closeTo(math.sqrt(3) / 2, 1e-9));
    });

    test('should_read_the_cell_when_the_point_is_just_inside_a_corner', () {
      // Arrange
      const cell = HexCoord(2, -1);
      final center = layout.centerOf(cell);
      final corner = layout.cornersOf(cell).first;

      // Act
      final read = layout.cellAt(Offset.lerp(center, corner, 0.95)!);

      // Assert
      expect(read, cell);
    });

    test('should_give_six_corners_one_unit_away_from_the_center', () {
      // Arrange
      const cell = HexCoord(-1, 3);

      // Act
      final corners = layout.cornersOf(cell);

      // Assert
      final center = layout.centerOf(cell);
      expect(corners, hasLength(6));
      for (final corner in corners) {
        expect((corner - center).distance, closeTo(1, 1e-9));
      }
    });
  });
}
