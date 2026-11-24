import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexablock_app/frameworks/ui/board/board_geometry.dart';
import 'package:hexablock_app/frameworks/ui/board/hex_layout.dart';

void main() {
  final radius4 = const HexTopology().cellsOf(
    ShapeSpec(HexTopology.hexagon, const [4]),
  );
  const size = Size(360, 400);

  group('ARQ-A-06', () {
    test('should_fit_every_cell_inside_the_size', () {
      // Arrange
      final geometry = BoardGeometry.fit(const HexLayout(), radius4, size);

      // Act
      final bounds = geometry.bounds;

      // Assert
      final area = Offset.zero & size;
      expect(area.inflate(1e-6).contains(bounds.topLeft), isTrue);
      expect(area.inflate(1e-6).contains(bounds.bottomRight), isTrue);
      expect(
        bounds.width == size.width || bounds.height == size.height,
        isTrue,
        reason: 'the board fills one side',
      );
    });

    test('should_center_the_board_in_the_size', () {
      // Arrange
      final geometry = BoardGeometry.fit(const HexLayout(), radius4, size);

      // Act
      final center = geometry.centerOf(const HexCoord(0, 0));

      // Assert
      expect(center.dx, closeTo(size.width / 2, 1e-6));
      expect(center.dy, closeTo(size.height / 2, 1e-6));
    });
  });

  group('ARQ-02 §3.2', () {
    test('should_return_the_cell_under_a_point_of_the_screen', () {
      // Arrange
      final geometry = BoardGeometry.fit(const HexLayout(), radius4, size);
      const cell = HexCoord(3, -2);

      // Act
      final read = geometry.cellAt(geometry.centerOf(cell));

      // Assert
      expect(read, cell);
    });

    test('should_return_null_when_the_point_is_off_the_board', () {
      // Arrange
      final geometry = BoardGeometry.fit(const HexLayout(), radius4, size);

      // Act
      final read = geometry.cellAt(const Offset(2, 2));

      // Assert
      expect(read, isNull);
    });
  });
}
