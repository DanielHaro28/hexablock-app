import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:hexablock_app/config/dependencies.dart';
import 'package:hexablock_app/config/hexa_lines_module.dart';
import 'package:hexablock_app/frameworks/ui/board/board_view.dart';
import 'package:hexablock_app/frameworks/ui/board/shape_view.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';

void main() {
  late GetIt getIt;

  setUp(() async {
    getIt = GetIt.asNewInstance();
    await registerDependencies(getIt, rootBundle, newSeed: () => 1);
  });

  tearDown(() => getIt.reset());

  /// Opens Hexa Lines the way main does and waits until it is ready.
  Future<void> openHexaLines(WidgetTester tester) async {
    await tester.pumpWidget(
      HexaBlockApp(home: openGame(getIt, HexaLinesModule.id)),
    );
    await tester.pumpAndSettle();
  }

  group('TEC-11', () {
    testWidgets('should_show_an_empty_board_of_61_cells_when_lines_opens', (
      tester,
    ) async {
      // Arrange
      final board = find.byType(BoardView<HexCoord, PieceColor>);

      // Act
      await openHexaLines(tester);

      // Assert
      final view = tester.widget<BoardView<HexCoord, PieceColor>>(board);
      expect(view.board.cells, hasLength(61));
      expect(view.board.emptyCells, hasLength(61));
    });

    testWidgets('should_show_a_tray_of_3_pieces_when_lines_opens', (
      tester,
    ) async {
      // Arrange
      final pieces = find.byType(ShapeView<HexCoord, PieceColor>);

      // Act
      await openHexaLines(tester);

      // Assert
      expect(pieces, findsNWidgets(3));
    });

    testWidgets(
      'should_show_the_texts_in_spanish_when_the_device_is_in_spanish',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('es')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);

        // Act
        await openHexaLines(tester);

        // Assert
        expect(find.text('Hexa Lines'), findsOneWidget);
        expect(find.text('PUNTAJE'), findsOneWidget);
      },
    );

    testWidgets(
      'should_show_the_texts_in_english_when_the_device_is_in_english',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('en')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);

        // Act
        await openHexaLines(tester);

        // Assert
        expect(find.text('SCORE'), findsOneWidget);
      },
    );
  });
}
