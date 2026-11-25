import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

/// Receiving a new tray (HL-04): RN-HL-21, RN-HL-50 and where the new tray
/// goes among the rules' events (RN-HL §11), with the rules as the factory
/// wires them. The engine adds its own events (`ScoreChanged`, D-94) after
/// these, which the engine's tests cover.
void main() {
  final rules = HexaLinesFactory(hexTopology, hexConfig).createRules();
  final source = LinesPieceSource(hexTopology, hexCatalog);
  const red = PieceColor('red');
  const blue = PieceColor('blue');

  final mono = LinesPiece(shapeOf([(0, 0)]), blue);

  /// A state on the radius-4 board with [occupied] cells, [tray] and the
  /// generator [random].
  LinesState<HexCoord> stateWith({
    required List<LinesPiece<HexCoord>?> tray,
    List<(int, int)> occupied = const [],
    Xorshift32? random,
  }) => LinesState(
    board: Board<HexCoord, PieceColor>.of(
      hexTopology,
      hexRadius4,
    ).withCells({for (final (q, r) in occupied) HexCoord(q, r): red}),
    tray: tray,
    random: random ?? Xorshift32(7),
    seed: 7,
  );

  /// The turn of [move] on [state]; fails the test if it is rejected.
  PlayedTurn<HexCoord, LinesState<HexCoord>> play(
    LinesState<HexCoord> state,
    PlacePiece<HexCoord> move,
  ) => switch (rules.playTurn(state, move)) {
    PlayedTurn<HexCoord, LinesState<HexCoord>>() && final played => played,
    RejectedTurn(:final reason) => fail('$move was rejected: $reason'),
  };

  group('RN-HL-21', () {
    test('should_draw_3_new_pieces_when_the_third_piece_is_placed', () {
      // Arrange
      final state = stateWith(tray: [null, mono, null]);
      final (expected, after) = drawTray(
        source,
        state.random,
        LinesState.traySize,
      );

      // Act
      final turn = play(state, const PlacePiece(1, HexCoord(0, 0)));

      // Assert
      expect(turn.state.tray, expected);
      expect(turn.state.random, after);
      expect(turn.events.last, TrayRefilled<HexCoord>(expected));
    });

    test('should_draw_nothing_when_two_pieces_are_left', () {
      // Arrange
      final state = stateWith(tray: [mono, mono, mono]);

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(0, 0)));

      // Assert
      expect(turn.state.tray, [null, mono, mono]);
      expect(turn.state.random, state.random);
      expect(turn.events.whereType<TrayRefilled<HexCoord>>(), isEmpty);
    });

    test('should_draw_nothing_when_one_piece_is_left', () {
      // Arrange
      final state = stateWith(tray: [mono, null, mono]);

      // Act
      final turn = play(state, const PlacePiece(2, HexCoord(0, 0)));

      // Assert
      expect(turn.state.tray, [mono, null, null]);
      expect(turn.state.random, state.random);
      expect(turn.events.whereType<TrayRefilled<HexCoord>>(), isEmpty);
    });

    test('should_give_the_same_trays_when_the_seed_and_moves_are_the_same', () {
      // Arrange
      LinesState<HexCoord> playOut() {
        var state = stateWith(tray: [mono, mono, mono], random: Xorshift32(42));
        for (final move in const [
          PlacePiece(0, HexCoord(0, 0)),
          PlacePiece(1, HexCoord(1, 0)),
          PlacePiece(2, HexCoord(2, 0)),
        ]) {
          state = play(state, move).state;
        }
        return state;
      }

      // Act
      final first = playOut();
      final second = playOut();

      // Assert
      expect(first.tray, everyElement(isNotNull));
      expect(first.tray, second.tray);
      expect(first.random, second.random);
    });
  });

  group('RN-HL-50', () {
    test('should_go_on_when_the_last_piece_empties_the_tray', () {
      // Arrange: the end is checked on the new tray, which fits on an
      // almost empty board.
      final state = stateWith(tray: [mono, null, null]);

      // Act
      final turn = play(state, const PlacePiece(0, HexCoord(0, 0)));

      // Assert
      expect(turn.outcome, const Ongoing());
    });
  });

  group('RN-HL §11', () {
    test(
      'should_give_the_new_tray_after_the_cleared_lines_among_the_rules_events',
      () {
        // Arrange: the row r = −4 lacks only (4, −4).
        final state = stateWith(
          tray: [mono, null, null],
          occupied: [(0, -4), (1, -4), (2, -4), (3, -4)],
        );

        // Act
        final turn = play(state, const PlacePiece(0, HexCoord(4, -4)));

        // Assert
        expect(turn.events.map((event) => event.runtimeType), [
          PiecePlaced<HexCoord>,
          LinesCleared<HexCoord>,
          TrayRefilled<HexCoord>,
        ]);
      },
    );
  });
}
