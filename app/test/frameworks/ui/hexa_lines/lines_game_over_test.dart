import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:hexablock_app/adapters/presentation/game/game_cubit.dart';
import 'package:hexablock_app/frameworks/ui/board/hex_layout.dart';
import 'package:hexablock_app/frameworks/ui/hexa_lines/lines_drag.dart';
import 'package:hexablock_app/frameworks/ui/hexa_lines/lines_game_screen.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';

typedef _Cubit =
    GameCubit<HexCoord, PieceColor, PlacePiece<HexCoord>, LinesState<HexCoord>>;

/// The end of a Hexa Lines game on screen (HL-05, D-141): a notice in place
/// of the tray, until PRG-02 brings the defeat screen.
void main() {
  const topology = HexTopology();
  const key = SavedGameKey(ProfileId.guest, GameKey('hexa-lines', 'hex'));
  const red = PieceColor('red');

  LinesPiece<HexCoord> pieceOf(List<(int, int)> cells) => LinesPiece(
    Shape.fromCells([for (final (q, r) in cells) HexCoord(q, r)]),
    red,
  );

  final mono = pieceOf([(0, 0)]);
  final domino = pieceOf([(0, 0), (1, 0)]);
  final line3 = pieceOf([(0, 0), (1, 0), (2, 0)]);

  /// The board of E-HL-4 with (0, 0) still empty and [tray], whose first
  /// piece is a mono that fills it. By default, neither the domino nor the
  /// line of 3 left fits then.
  LinesState<HexCoord> lastTurn({List<LinesPiece<HexCoord>>? tray}) {
    final empty = {
      const HexCoord(4, -4),
      const HexCoord(-1, -3),
      const HexCoord(1, -2),
      const HexCoord(3, -1),
      const HexCoord(-2, 0),
      const HexCoord(-4, 1),
      const HexCoord(2, 2),
      const HexCoord(0, 3),
      const HexCoord(-3, 4),
      const HexCoord(0, 0),
    };
    final shape = ShapeSpec(HexTopology.hexagon, const [4]);
    return LinesState(
      board: Board<HexCoord, PieceColor>.of(topology, shape).withCells({
        for (final cell in topology.cellsOf(shape))
          if (!empty.contains(cell)) cell: red,
      }),
      tray: tray ?? [mono, domino, line3],
      random: Xorshift32(7),
      seed: 7,
    );
  }

  /// Shows the game of [state] as the Hexa Lines module does, and returns
  /// its presenter.
  Future<_Cubit> pumpGame(
    WidgetTester tester, [
    LinesState<HexCoord>? state,
  ]) async {
    final saved = FakeSavedGameRepository<LinesState<HexCoord>>();
    final cubit = _Cubit(
      startGame: StubStartGame(
        HexaLinesRules<HexCoord>(
          const LinesScoring(StreakMultiplier(LineBonus(5), maxMultiplier: 3)),
          StubPieceSource(Xorshift32(7), const []),
        ),
        state ?? lastTurn(),
      ),
      options: StartNew(NewGameOptions(seed: 7)),
      applyMoveFor: (session) => ExceptionAspect(
        ApplyMoveUseCase(session, saved, key),
        FakeLogger(),
        name: 'test',
      ),
      checkMoveFor: (session) => ExceptionAspect(
        CheckMoveUseCase(session),
        FakeLogger(),
        name: 'test',
      ),
    );
    addTearDown(cubit.close);
    await cubit.start();
    await tester.pumpWidget(
      HexaBlockApp(
        home: BlocProvider.value(
          value: cubit,
          child: const LinesGameScreen<HexCoord>(layout: HexLayout()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  /// Plays the mono on (0, 0), the turn that ends the game.
  Future<void> endGame(WidgetTester tester, _Cubit cubit) async {
    await cubit.submit(const PlacePiece(0, HexCoord(0, 0)));
    await tester.pumpAndSettle();
  }

  Finder pieces() => find.byType(Draggable<LinesDragged<HexCoord>>);

  group('HL-05', () {
    testWidgets(
      'should_show_the_game_over_notice_in_spanish_when_no_piece_fits',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('es')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);
        final cubit = await pumpGame(tester);

        // Act
        await endGame(tester, cubit);

        // Assert
        expect(find.text('Sin movimientos'), findsOneWidget);
      },
    );

    testWidgets(
      'should_show_the_game_over_notice_in_english_when_no_piece_fits',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('en')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);
        final cubit = await pumpGame(tester);

        // Act
        await endGame(tester, cubit);

        // Assert
        expect(find.text('No moves left'), findsOneWidget);
      },
    );

    testWidgets('should_leave_no_piece_to_drag_when_the_game_is_over', (
      tester,
    ) async {
      // Arrange
      final cubit = await pumpGame(tester);

      // Act
      await endGame(tester, cubit);

      // Assert
      expect(pieces(), findsNothing);
    });

    testWidgets('should_keep_the_tray_when_a_piece_left_still_fits', (
      tester,
    ) async {
      // Arrange: after the first mono, the domino does not fit but the
      // other mono does.
      final cubit = await pumpGame(
        tester,
        lastTurn(tray: [mono, domino, mono]),
      );

      // Act
      await endGame(tester, cubit);

      // Assert
      expect(pieces(), findsNWidgets(2));
      expect(find.text('No moves left'), findsNothing);
    });
  });
}
