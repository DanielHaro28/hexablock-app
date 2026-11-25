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
import 'package:hexablock_app/frameworks/ui/hexa_lines/lines_game_screen.dart';
import 'package:hexablock_app/frameworks/ui/hexablock_app.dart';

typedef _Cubit =
    GameCubit<HexCoord, PieceColor, PlacePiece<HexCoord>, LinesState<HexCoord>>;

/// The score and the record of a Hexa Lines game on screen (HL-06).
void main() {
  const topology = HexTopology();
  const key = SavedGameKey(ProfileId.guest, GameKey('hexa-lines', 'hex'));
  const red = PieceColor('red');
  final shape = ShapeSpec(HexTopology.hexagon, const [4]);
  final earlier = DateTime.utc(2026, 11, 20);

  LinesPiece<HexCoord> pieceOf(List<(int, int)> cells) => LinesPiece(
    Shape.fromCells([for (final (q, r) in cells) HexCoord(q, r)]),
    red,
  );

  final mono = pieceOf([(0, 0)]);
  final domino = pieceOf([(0, 0), (1, 0)]);
  final line3 = pieceOf([(0, 0), (1, 0), (2, 0)]);

  /// An empty board with a mono, a domino and a line of 3 in the tray.
  LinesState<HexCoord> firstTurn() => LinesState(
    board: Board<HexCoord, PieceColor>.of(topology, shape),
    tray: [mono, domino, line3],
    random: Xorshift32(7),
    seed: 7,
  );

  /// The board of E-HL-4 with only (0, 0) left where a piece fits: playing
  /// the mono there ends the game.
  LinesState<HexCoord> lastTurn() {
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
    return LinesState(
      board: Board<HexCoord, PieceColor>.of(topology, shape).withCells({
        for (final cell in topology.cellsOf(shape))
          if (!empty.contains(cell)) cell: red,
      }),
      tray: [mono, domino, line3],
      random: Xorshift32(7),
      seed: 7,
    );
  }

  /// Shows the game of [state] as the Hexa Lines module does, with its
  /// record in [progress], and returns its presenter.
  Future<_Cubit> pumpGame(
    WidgetTester tester,
    LinesState<HexCoord> state,
    FakeProgressRepository progress,
  ) async {
    final saved = FakeSavedGameRepository<LinesState<HexCoord>>();
    final cubit = _Cubit(
      startGame: StubStartGame(
        HexaLinesRules<HexCoord>(
          const LinesScoring(StreakMultiplier(LineBonus(5), maxMultiplier: 3)),
          StubPieceSource(Xorshift32(7), const []),
        ),
        state,
      ),
      options: StartNew(NewGameOptions(seed: 7)),
      applyMoveFor: (session) =>
          ErrorHandlingAspect(ApplyMoveUseCase(session, saved, key)),
      checkMoveFor: (session) => ErrorHandlingAspect(CheckMoveUseCase(session)),
      record: RecordUseCases(
        game: key.game,
        getProgress: ErrorHandlingAspect(
          GetProgressUseCase(progress, FakeProfileRepository()),
        ),
        saveProgress: ErrorHandlingAspect(
          SaveProgressUseCase(progress, FakeProfileRepository(), FakeClock()),
        ),
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

  /// The value shown under the marker labeled [label].
  String markerValue(WidgetTester tester, String label) {
    final marker = find.ancestor(
      of: find.text(label),
      matching: find.byType(Column),
    );
    final texts = tester.widgetList<Text>(
      find.descendant(of: marker.first, matching: find.byType(Text)),
    );
    return texts.map((text) => text.data).whereType<String>().last;
  }

  /// A progress repository whose record is [score].
  FakeProgressRepository recordOf(int score) => FakeProgressRepository({
    (ProfileId.guest, key.game): HighScoreProgress(score, earlier),
  });

  group('RN-HL-70', () {
    testWidgets(
      'should_show_the_score_and_the_record_in_spanish_when_playing',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('es')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);

        // Act
        await pumpGame(tester, firstTurn(), recordOf(1240));

        // Assert
        expect(markerValue(tester, 'PUNTAJE'), '0');
        expect(markerValue(tester, 'RÉCORD'), '1240');
      },
    );

    testWidgets(
      'should_show_the_score_and_the_record_in_english_when_playing',
      (tester) async {
        // Arrange
        tester.platformDispatcher.localesTestValue = const [Locale('en')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);

        // Act
        await pumpGame(tester, firstTurn(), recordOf(1240));

        // Assert
        expect(markerValue(tester, 'SCORE'), '0');
        expect(markerValue(tester, 'BEST'), '1240');
      },
    );

    testWidgets('should_show_a_record_of_0_when_no_game_was_finished', (
      tester,
    ) async {
      // Arrange
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      // Act
      await pumpGame(tester, firstTurn(), FakeProgressRepository());

      // Assert
      expect(markerValue(tester, 'BEST'), '0');
    });
  });

  group('RN-HL-60', () {
    testWidgets('should_add_the_placed_cells_to_the_score_when_a_piece_fits', (
      tester,
    ) async {
      // Arrange
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final cubit = await pumpGame(tester, firstTurn(), recordOf(1240));

      // Act: the domino clears no line, so it scores its 2 cells
      await cubit.submit(const PlacePiece(1, HexCoord(0, 0)));
      await tester.pumpAndSettle();

      // Assert
      expect(markerValue(tester, 'SCORE'), '2');
      expect(markerValue(tester, 'BEST'), '1240');
    });
  });

  group('RN-HL-71', () {
    testWidgets('should_show_the_new_record_when_the_game_ends_above_it', (
      tester,
    ) async {
      // Arrange
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final progress = recordOf(0);
      final cubit = await pumpGame(tester, lastTurn(), progress);

      // Act
      await cubit.submit(const PlacePiece(0, HexCoord(0, 0)));
      await tester.pumpAndSettle();

      // Assert
      final score = markerValue(tester, 'SCORE');
      expect(score, isNot('0'));
      expect(markerValue(tester, 'BEST'), score);
      expect(
        progress.savedAt(ProfileId.guest, key.game),
        isA<HighScoreProgress>().having(
          (record) => '${record.score}',
          'score',
          score,
        ),
      );
    });

    testWidgets('should_keep_the_record_when_the_game_ends_below_it', (
      tester,
    ) async {
      // Arrange
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final cubit = await pumpGame(tester, lastTurn(), recordOf(99999));

      // Act
      await cubit.submit(const PlacePiece(0, HexCoord(0, 0)));
      await tester.pumpAndSettle();

      // Assert
      expect(markerValue(tester, 'BEST'), '99999');
    });
  });
}
