import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexablock_app/frameworks/ui/board/board_geometry.dart';
import 'package:hexablock_app/frameworks/ui/board/board_view.dart';
import 'package:hexablock_app/frameworks/ui/board/cell_painter.dart';
import 'package:hexablock_app/frameworks/ui/board/hex_layout.dart';

/// Paints nothing: these tests only read the geometry and the taps.
final class _NoPainter implements CellPainter<String> {
  const _NoPainter();

  @override
  void paintCell(Canvas canvas, Path outline, String? content) {}
}

void main() {
  final board = Board<HexCoord, String>.of(
    const HexTopology(),
    ShapeSpec(HexTopology.hexagon, const [4]),
  );
  const size = Size(360, 400);

  Future<void> pump(WidgetTester tester, ValueChanged<HexCoord> onTap) =>
      tester.pumpWidget(
        Center(
          child: SizedBox.fromSize(
            size: size,
            child: BoardView<HexCoord, String>(
              board: board,
              layout: const HexLayout(),
              painter: const _NoPainter(),
              onCellTap: onTap,
            ),
          ),
        ),
      );

  group('ARQ-02 §3.2', () {
    testWidgets('should_report_the_cell_when_the_player_taps_it', (
      tester,
    ) async {
      // Arrange
      final tapped = <HexCoord>[];
      await pump(tester, tapped.add);
      const cell = HexCoord(-2, 3);
      final geometry = BoardGeometry.fit(const HexLayout(), board.cells, size);
      final origin = tester.getTopLeft(
        find.byType(BoardView<HexCoord, String>),
      );

      // Act
      await tester.tapAt(origin + geometry.centerOf(cell));

      // Assert
      expect(tapped, [cell]);
    });

    testWidgets('should_report_nothing_when_the_tap_is_off_the_board', (
      tester,
    ) async {
      // Arrange
      final tapped = <HexCoord>[];
      await pump(tester, tapped.add);
      final origin = tester.getTopLeft(
        find.byType(BoardView<HexCoord, String>),
      );

      // Act
      await tester.tapAt(origin + const Offset(2, 2));

      // Assert
      expect(tapped, isEmpty);
    });
  });
}
