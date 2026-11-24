import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

void main() {
  const rules = HexaLinesRules<HexCoord>();
  const red = PieceColor('red');
  const blue = PieceColor('blue');

  final domino = LinesPiece(shapeOf([(0, 0), (1, 0)]), blue);
  final mono = LinesPiece(shapeOf([(0, 0)]), red);

  /// A state on the radius-4 board with [occupied] cells and [tray].
  LinesState<HexCoord> stateWith({
    List<(int, int)> occupied = const [],
    List<LinesPiece<HexCoord>?>? tray,
  }) {
    final board = Board<HexCoord, PieceColor>.of(
      hexTopology,
      hexRadius4,
    ).withCells({for (final (q, r) in occupied) HexCoord(q, r): red});
    return LinesState(
      board: board,
      tray: tray ?? [domino, mono, mono],
      random: Xorshift32(7),
      seed: 7,
    );
  }

  /// The initial state of E-HL-1, used by E-HL-3.
  LinesState<HexCoord> exampleState() =>
      stateWith(occupied: [(0, -4), (1, -4), (2, -4)]);

  group('E-HL-3', () {
    test('should_reject_and_change_nothing_when_a_cell_is_occupied', () {
      // Arrange
      final state = exampleState();
      const move = PlacePiece(0, HexCoord(2, -4));

      // Act
      final turn = rules.playTurn(state, move);

      // Assert
      expect(turn, isA<RejectedTurn<HexCoord, LinesState<HexCoord>>>());
      expect(turn.state, same(state));
    });

    test('should_reject_and_change_nothing_when_a_cell_is_off_the_board', () {
      // Arrange
      final state = exampleState();
      const move = PlacePiece(0, HexCoord(4, -4));

      // Act
      final turn = rules.playTurn(state, move);

      // Assert
      expect(turn, isA<RejectedTurn<HexCoord, LinesState<HexCoord>>>());
      expect(turn.state, same(state));
    });
  });

  group('RN-HL-30', () {
    test('should_reject_when_the_anchor_is_off_the_board', () {
      // Arrange
      final state = stateWith();
      const move = PlacePiece(1, HexCoord(5, 0));

      // Act
      final reason = rules.rejectionOf(state, move);

      // Assert
      expect(reason, const InvalidMove());
    });

    test('should_reject_when_the_tray_slot_is_empty', () {
      // Arrange
      final state = stateWith(tray: [null, mono, mono]);
      const move = PlacePiece(0, HexCoord(0, 0));

      // Act
      final reason = rules.rejectionOf(state, move);

      // Assert
      expect(reason, const InvalidMove());
    });

    test('should_reject_when_the_tray_index_does_not_exist', () {
      // Arrange
      final state = stateWith();
      const move = PlacePiece(3, HexCoord(0, 0));

      // Act
      final reason = rules.rejectionOf(state, move);

      // Assert
      expect(reason, const InvalidMove());
    });
  });

  group('RN-HL-31', () {
    test('should_accept_when_every_cell_is_on_the_board_and_empty', () {
      // Arrange
      final state = exampleState();
      const move = PlacePiece(0, HexCoord(3, -4));

      // Act
      final reason = rules.rejectionOf(state, move);

      // Assert
      expect(reason, isNull);
    });
  });

  group('RN-HL-32', () {
    test('should_fill_the_cells_with_the_piece_color_when_placed', () {
      // Arrange
      final state = stateWith();
      const move = PlacePiece(0, HexCoord(-1, 2));

      // Act
      final turn = rules.playTurn(state, move);

      // Assert
      final board = turn.state.board;
      expect(board.cell(const HexCoord(-1, 2)), blue);
      expect(board.cell(const HexCoord(0, 2)), blue);
      expect(board.emptyCells.length, 61 - 2);
    });

    test('should_empty_only_its_tray_slot_when_placed', () {
      // Arrange
      final state = stateWith();
      const move = PlacePiece(1, HexCoord(0, 0));

      // Act
      final turn = rules.playTurn(state, move);

      // Assert
      expect(turn.state.tray, [domino, null, mono]);
    });

    test('should_publish_the_placed_cells_when_placed', () {
      // Arrange
      final state = stateWith();
      const move = PlacePiece(0, HexCoord(-1, 2));

      // Act
      final turn = rules.playTurn(state, move);

      // Assert
      expect((turn as PlayedTurn).events, [
        PiecePlaced<HexCoord>(0, {const HexCoord(-1, 2), const HexCoord(0, 2)}),
      ]);
    });

    test('should_keep_the_generator_and_the_seed_when_placed', () {
      // Arrange
      final state = stateWith();
      const move = PlacePiece(2, HexCoord(0, 0));

      // Act
      final turn = rules.playTurn(state, move);

      // Assert
      expect(turn.state.random, state.random);
      expect(turn.state.seed, state.seed);
    });
  });

  group('RN-HL-51', () {
    test('should_offer_every_fitting_anchor_of_every_piece_when_listing_'
        'moves', () {
      // Arrange: one empty cell, where only the mono fits.
      final full = [
        for (final cell in hexTopology.cellsOf(hexRadius4))
          if (cell != const HexCoord(0, 0)) (cell.q, cell.r),
      ];
      final state = stateWith(occupied: full, tray: [domino, mono, null]);

      // Act
      final moves = rules.validMoves(state);

      // Assert
      expect(moves, [const PlacePiece(1, HexCoord(0, 0))]);
    });

    test('should_offer_no_move_when_the_tray_is_empty', () {
      // Arrange
      final state = stateWith(tray: [null, null, null]);

      // Act
      final moves = rules.validMoves(state);

      // Assert
      expect(moves, isEmpty);
    });
  });
}
