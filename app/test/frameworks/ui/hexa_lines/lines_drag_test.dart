import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:hexablock_app/adapters/presentation/game/game_cubit.dart';
import 'package:hexablock_app/frameworks/ui/board/board_geometry.dart';
import 'package:hexablock_app/frameworks/ui/board/board_view.dart';
import 'package:hexablock_app/frameworks/ui/board/hex_layout.dart';
import 'package:hexablock_app/frameworks/ui/board/piece_drag.dart';
import 'package:hexablock_app/frameworks/ui/hexa_lines/lines_drag.dart';
import 'package:hexablock_app/frameworks/ui/hexa_lines/lines_game_screen.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';

typedef _Cubit =
    GameCubit<HexCoord, PieceColor, PlacePiece<HexCoord>, LinesState<HexCoord>>;
typedef _Board = BoardView<HexCoord, PieceColor>;

void main() {
  const topology = HexTopology();
  const layout = HexLayout();
  const key = SavedGameKey(ProfileId.guest, GameKey('hexa-lines', 'hex'));
  const red = PieceColor('red');
  const blue = PieceColor('blue');

  Shape<HexCoord> shapeOf(List<(int, int)> cells) =>
      Shape.fromCells([for (final (q, r) in cells) HexCoord(q, r)]);

  final domino = LinesPiece(shapeOf([(0, 0), (1, 0)]), blue);
  final mono = LinesPiece(shapeOf([(0, 0)]), red);
  final tray = [domino, mono, mono];

  /// The radius-4 board with [occupied] cells and a tray of a domino and
  /// two monos.
  LinesState<HexCoord> stateWith(List<(int, int)> occupied) => LinesState(
    board: Board<HexCoord, PieceColor>.of(
      topology,
      ShapeSpec(HexTopology.hexagon, const [4]),
    ).withCells({for (final (q, r) in occupied) HexCoord(q, r): red}),
    tray: tray,
    random: Xorshift32(7),
    seed: 7,
  );

  /// The initial state of E-HL-1, used by E-HL-3.
  LinesState<HexCoord> exampleState() => stateWith([(0, -4), (1, -4), (2, -4)]);

  /// Shows the game of [state] as the Hexa Lines module does.
  Future<void> pumpGame(WidgetTester tester, LinesState<HexCoord> state) async {
    final saved = FakeSavedGameRepository<LinesState<HexCoord>>();
    final cubit = _Cubit(
      startGame: StubStartGame(
        HexaLinesRules<HexCoord>(
          const LinesScoring(StreakMultiplier(LineBonus(5), maxMultiplier: 3)),
          LinesPieceSource(topology, [
            LinesFamily(shape: mono.shape, weight: 100, color: red),
          ]),
        ),
        state,
      ),
      options: StartNew(NewGameOptions(seed: 7)),
      applyMoveFor: (session) =>
          ErrorHandlingAspect(ApplyMoveUseCase(session, saved, key)),
      checkMoveFor: (session) => ErrorHandlingAspect(CheckMoveUseCase(session)),
    );
    addTearDown(cubit.close);
    await cubit.start();
    await tester.pumpWidget(
      HexaBlockApp(
        home: BlocProvider.value(
          value: cubit,
          child: const LinesGameScreen<HexCoord>(layout: layout),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Enough of a move for the drag to start.
  const dragStart = Offset(0, -30);

  _Board boardView(WidgetTester tester) =>
      tester.widget<_Board>(find.byType(_Board));

  Finder pieces() => find.byType(Draggable<LinesDragged<HexCoord>>);

  /// Drags the piece of the tray [slot] until its first cell is over
  /// [anchor], and leaves the pointer down.
  Future<TestGesture> dragOver(
    WidgetTester tester, {
    required int slot,
    required HexCoord anchor,
  }) async {
    final board = find.byType(_Board);
    final geometry = BoardGeometry.fit(
      layout,
      boardView(tester).board.cells,
      tester.getSize(board),
    );
    final drag = PieceDrag(layout, topology, tray[slot].shape, geometry.scale);
    final target =
        tester.getTopLeft(board) +
        geometry.centerOf(anchor) -
        drag.anchorCenter +
        drag.grip;
    final gesture = await tester.startGesture(
      tester.getCenter(pieces().at(slot)),
    );
    await gesture.moveBy(dragStart);
    await tester.pump();
    await gesture.moveTo(target);
    await tester.pump();
    await tester.pump();
    return gesture;
  }

  /// Drags the piece of [slot] over [anchor] and lets it go there.
  Future<void> dropOn(
    WidgetTester tester, {
    required int slot,
    required HexCoord anchor,
  }) async {
    final gesture = await dragOver(tester, slot: slot, anchor: anchor);
    await gesture.up();
    await tester.pumpAndSettle();
  }

  group('HL-02', () {
    testWidgets('should_preview_the_cells_as_valid_when_they_are_free', (
      tester,
    ) async {
      // Arrange
      await pumpGame(tester, exampleState());

      // Act
      final gesture = await dragOver(
        tester,
        slot: 0,
        anchor: const HexCoord(3, -4),
      );

      // Assert
      final preview = boardView(tester).preview;
      expect(preview?.cells, {const HexCoord(3, -4), const HexCoord(4, -4)});
      expect(preview?.content, blue);
      expect(preview?.valid, isTrue);
      await gesture.up();
    });

    testWidgets('should_preview_the_cells_as_invalid_when_one_is_occupied', (
      tester,
    ) async {
      // Arrange
      await pumpGame(tester, exampleState());

      // Act
      final gesture = await dragOver(
        tester,
        slot: 0,
        anchor: const HexCoord(2, -4),
      );

      // Assert
      final preview = boardView(tester).preview;
      expect(preview?.cells, {const HexCoord(2, -4), const HexCoord(3, -4)});
      expect(preview?.valid, isFalse);
      await gesture.up();
    });

    testWidgets('should_preview_only_the_cells_on_the_board_when_one_is_off', (
      tester,
    ) async {
      // Arrange
      await pumpGame(tester, exampleState());

      // Act
      final gesture = await dragOver(
        tester,
        slot: 0,
        anchor: const HexCoord(4, -4),
      );

      // Assert
      final preview = boardView(tester).preview;
      expect(preview?.cells, {const HexCoord(4, -4)});
      expect(preview?.valid, isFalse);
      await gesture.up();
    });

    testWidgets('should_remove_the_preview_when_the_piece_leaves_the_board', (
      tester,
    ) async {
      // Arrange
      await pumpGame(tester, exampleState());
      final gesture = await dragOver(
        tester,
        slot: 0,
        anchor: const HexCoord(0, 0),
      );

      // Act
      await gesture.moveTo(tester.getCenter(pieces().at(2)));
      await tester.pump();

      // Assert
      expect(boardView(tester).preview, isNull);
      await gesture.up();
    });

    testWidgets('should_place_the_piece_and_empty_its_slot_when_dropped', (
      tester,
    ) async {
      // Arrange
      await pumpGame(tester, exampleState());

      // Act
      await dropOn(tester, slot: 0, anchor: const HexCoord(-1, 2));

      // Assert
      final board = boardView(tester).board;
      expect(board.cell(const HexCoord(-1, 2)), blue);
      expect(board.cell(const HexCoord(0, 2)), blue);
      expect(boardView(tester).preview, isNull);
      expect(pieces(), findsNWidgets(2));
    });
  });

  group('E-HL-3', () {
    testWidgets('should_keep_the_board_and_the_piece_when_a_cell_is_occupied', (
      tester,
    ) async {
      // Arrange
      final state = exampleState();
      await pumpGame(tester, state);

      // Act
      await dropOn(tester, slot: 0, anchor: const HexCoord(2, -4));

      // Assert
      expect(boardView(tester).board, state.board);
      expect(boardView(tester).preview, isNull);
      expect(pieces(), findsNWidgets(3));
    });

    testWidgets('should_keep_the_board_and_the_piece_when_a_cell_is_off', (
      tester,
    ) async {
      // Arrange
      final state = exampleState();
      await pumpGame(tester, state);

      // Act
      await dropOn(tester, slot: 0, anchor: const HexCoord(4, -4));

      // Assert
      expect(boardView(tester).board, state.board);
      expect(pieces(), findsNWidgets(3));
    });
  });
}
