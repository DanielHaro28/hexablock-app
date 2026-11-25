import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hexa_application/hexa_application.dart';
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
    await registerDependencies(
      getIt,
      rootBundle,
      newSeed: () => 1,
      databaseExecutor: NativeDatabase.memory(),
    );
  });

  tearDown(() async => getIt.reset());

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
        expect(find.text('RÉCORD'), findsOneWidget);
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
        expect(find.text('BEST'), findsOneWidget);
      },
    );
  });

  group('D-142', () {
    testWidgets(
      'should_show_the_record_of_the_app_repository_when_lines_opens',
      (tester) async {
        // Arrange: one repository for the whole app, so a record saved by
        // an earlier game is the one the next game shows.
        await getIt<IProgressRepository>().save(
          ProfileId.guest,
          const GameKey(HexaLinesModule.id, defaultTopology),
          HighScoreProgress(1240, DateTime.utc(2026, 11, 24)),
        );

        // Act
        await openHexaLines(tester);

        // Assert
        expect(find.text('1240'), findsOneWidget);
      },
    );
  });

  group('PRG-03', () {
    testWidgets('should_keep_saved_record_when_app_reopens_offline', (
      tester,
    ) async {
      // Arrange: save a record on a file-backed database, then reset the
      // container to simulate closing the app completely.
      final previousWarning =
          driftRuntimeOptions.dontWarnAboutMultipleDatabases;
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      addTearDown(
        () => driftRuntimeOptions.dontWarnAboutMultipleDatabases =
            previousWarning,
      );
      final tempDir = Directory.systemTemp.createTempSync('prg03_widget_');
      addTearDown(() => tempDir.deleteSync(recursive: true));
      final dbFile = File('${tempDir.path}/hexablock.sqlite');
      final reopenedSession = GetIt.asNewInstance();

      await tester.runAsync(() async {
        await getIt.reset();
        final firstSession = GetIt.asNewInstance();
        await registerDependencies(
          firstSession,
          rootBundle,
          newSeed: () => 1,
          databaseExecutor: NativeDatabase(dbFile),
        );
        await firstSession<IProgressRepository>().save(
          ProfileId.guest,
          const GameKey(HexaLinesModule.id, defaultTopology),
          HighScoreProgress(1880, DateTime.utc(2026, 11, 25)),
        );
        await firstSession.reset();

        await registerDependencies(
          reopenedSession,
          rootBundle,
          newSeed: () => 1,
          databaseExecutor: NativeDatabase(dbFile),
        );
      });
      addTearDown(reopenedSession.reset);

      // Act
      await tester.pumpWidget(
        HexaBlockApp(home: openGame(reopenedSession, HexaLinesModule.id)),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('1880'), findsOneWidget);
    });
  });
}
