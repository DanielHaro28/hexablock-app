import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

/// Ending the game when nothing fits (HL-05): RN-HL-50 to 52, E-HL-4 and the
/// edge cases of section 12. The end is the default `evaluate` of the
/// engine, checked after the lines are cleared and the new tray is drawn.
void main() {
  const red = PieceColor('red');
  const scoring = LinesScoring<HexCoord>(
    StreakMultiplier(LineBonus(5), maxMultiplier: 3),
  );

  final mono = tablePiece(0, 0);
  final domino = tablePiece(1, 0);
  final line3 = tablePiece(2, 0);
  final triangle = tablePiece(4, 0);

  /// The 9 empty cells of E-HL-4: no two are neighbours and no line is
  /// complete.
  final exampleEmpty = {
    const HexCoord(4, -4),
    const HexCoord(-1, -3),
    const HexCoord(1, -2),
    const HexCoord(3, -1),
    const HexCoord(-2, 0),
    const HexCoord(-4, 1),
    const HexCoord(2, 2),
    const HexCoord(0, 3),
    const HexCoord(-3, 4),
  };

  /// Where the turn puts a mono so that the board becomes that of E-HL-4.
  const lastCell = HexCoord(0, 0);

  /// The rules whose new tray is [newTray], drawn from the generator of
  /// [stateWith].
  HexaLinesRules<HexCoord> rulesDrawing(List<LinesPiece<HexCoord>> newTray) =>
      HexaLinesRules(scoring, StubPieceSource(Xorshift32(7), newTray));

  /// A state on the radius-4 board with every cell occupied but [empty].
  LinesState<HexCoord> stateWith({
    required Set<HexCoord> empty,
    required List<LinesPiece<HexCoord>?> tray,
  }) => LinesState(
    board: Board<HexCoord, PieceColor>.of(hexTopology, hexRadius4).withCells({
      for (final cell in hexTopology.cellsOf(hexRadius4))
        if (!empty.contains(cell)) cell: red,
    }),
    tray: tray,
    random: Xorshift32(7),
    seed: 7,
  );

  /// The board of E-HL-4 with [lastCell] still empty, before the turn.
  LinesState<HexCoord> beforeExample(List<LinesPiece<HexCoord>?> tray) =>
      stateWith(empty: {...exampleEmpty, lastCell}, tray: tray);

  /// The turn of [move] on [state]; fails the test if it is rejected.
  PlayedTurn<HexCoord, LinesState<HexCoord>> play(
    HexaLinesRules<HexCoord> rules,
    LinesState<HexCoord> state,
    PlacePiece<HexCoord> move,
  ) => switch (rules.playTurn(state, move)) {
    PlayedTurn<HexCoord, LinesState<HexCoord>>() && final played => played,
    RejectedTurn(:final reason) => fail('$move was rejected: $reason'),
  };

  group('E-HL-4', () {
    test('should_end_the_game_when_no_piece_of_the_tray_fits', () {
      // Arrange: the last piece leaves the board of E-HL-4 and draws the
      // tray {domino, line of 3, triangle of 3}.
      final rules = rulesDrawing([domino, line3, triangle]);
      final state = beforeExample([mono, null, null]);

      // Act
      final turn = play(rules, state, const PlacePiece(0, lastCell));

      // Assert
      expect(turn.state.board.emptyCells.toSet(), exampleEmpty);
      expect(turn.state.tray, [domino, line3, triangle]);
      expect(turn.outcome, const Defeat());
    });

    test('should_go_on_when_the_mono_of_the_tray_fits', () {
      // Arrange: the same board with the tray {domino, line of 3, mono}.
      final rules = rulesDrawing([domino, line3, mono]);
      final state = beforeExample([mono, null, null]);

      // Act
      final turn = play(rules, state, const PlacePiece(0, lastCell));

      // Assert
      expect(turn.state.board.emptyCells.toSet(), exampleEmpty);
      expect(turn.state.tray, [domino, line3, mono]);
      expect(turn.outcome, const Ongoing());
    });
  });

  group('RN-HL-51', () {
    test('should_end_the_game_when_none_of_the_pieces_left_fits', () {
      // Arrange: two pieces are left, so no tray is drawn (section 12).
      final rules = rulesDrawing(const []);
      final state = beforeExample([mono, domino, line3]);

      // Act
      final turn = play(rules, state, const PlacePiece(0, lastCell));

      // Assert
      expect(turn.state.tray, [null, domino, line3]);
      expect(turn.outcome, const Defeat());
    });

    test(
      'should_go_on_when_one_piece_left_fits_although_the_other_does_not',
      () {
        // Arrange
        final rules = rulesDrawing(const []);
        final state = beforeExample([mono, domino, mono]);

        // Act
        final turn = play(rules, state, const PlacePiece(0, lastCell));

        // Assert
        expect(turn.state.tray, [null, domino, mono]);
        expect(turn.outcome, const Ongoing());
      },
    );
  });

  group('RN-HL-50', () {
    test('should_clear_the_lines_before_checking_the_end_when_the_piece_fills_the_board', () {
      // Arrange: only (0, 0) is empty, so the mono fills the board and
      // completes every line; the domino left fits once they are cleared.
      final rules = rulesDrawing(const []);
      final state = stateWith(empty: {lastCell}, tray: [mono, domino, null]);

      // Act
      final turn = play(rules, state, const PlacePiece(0, lastCell));

      // Assert
      expect(turn.state.board.emptyCells, hasLength(61));
      expect(turn.outcome, const Ongoing());
    });
  });

  group('RN-HL-52', () {
    test('should_go_on_without_a_victory_when_the_board_is_left_empty', () {
      // Arrange: E-HL-2, whose mono clears the whole board.
      final rules = rulesDrawing(const []);
      final occupied = {
        for (var q = 0; q <= 3; q++) HexCoord(q, -4),
        for (var r = -3; r <= 0; r++) HexCoord(4, r),
      };
      final state = stateWith(
        empty: {
          for (final cell in hexTopology.cellsOf(hexRadius4))
            if (!occupied.contains(cell)) cell,
        },
        tray: [mono, mono, null],
      );

      // Act
      final turn = play(rules, state, const PlacePiece(0, HexCoord(4, -4)));

      // Assert
      expect(turn.state.board.emptyCells, hasLength(61));
      expect(turn.outcome, const Ongoing());
    });
  });

  group('RN-HL §11', () {
    test(
      'should_publish_the_end_of_the_game_last_when_the_engine_plays_the_turn',
      () {
        // Arrange
        final engine = GameEngine(
          rulesDrawing([domino, line3, triangle]),
          beforeExample([mono, null, null]),
        );
        addTearDown(engine.close);

        // Act
        final result = engine.submit(const PlacePiece(0, lastCell));

        // Assert
        expect(
          result.events.last,
          PhaseChanged<HexCoord>(const ResolvingPhase(), const GameOverPhase()),
        );
        expect(engine.phase, const GameOverPhase());
      },
    );

    test('should_reject_any_move_when_the_game_is_over', () {
      // Arrange
      final engine = GameEngine(
        rulesDrawing([domino, line3, triangle]),
        beforeExample([mono, null, null]),
      );
      addTearDown(engine.close);
      engine.submit(const PlacePiece(0, lastCell));

      // Act
      final result = engine.submit(const PlacePiece(0, HexCoord(4, -4)));

      // Assert
      expect(
        result,
        isA<RejectedMove<HexCoord, LinesState<HexCoord>>>().having(
          (rejected) => rejected.reason,
          'reason',
          isA<NotAcceptingMoves>(),
        ),
      );
    });
  });
}
