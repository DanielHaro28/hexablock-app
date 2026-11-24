import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

void main() {
  HexaLinesFactory<HexCoord> factory() =>
      HexaLinesFactory(hexTopology, hexConfig);

  LinesState<HexCoord> newGame(int seed) =>
      factory().createSession(NewGameOptions(seed: seed)).engine.state;

  group('D-116', () {
    checkVariantFamilyContract(
      factory,
      NewGameOptions(seed: 42),
      usesChance: true,
    );
  });

  group('RN-HL-10', () {
    test('should_use_the_configured_board_when_the_game_is_new', () {
      // Arrange: radius 2 instead of the default 4 (RNF-11).
      final config = LinesConfig(
        board: ShapeSpec(HexTopology.hexagon, [2]),
        catalog: hexCatalog,
        scoring: hexScoring,
      );

      // Act
      final state = HexaLinesFactory(
        hexTopology,
        config,
      ).createSession(NewGameOptions(seed: 42)).engine.state;

      // Assert
      expect(state.board.cells, hasLength(19));
    });

    test('should_throw_when_the_topology_does_not_know_the_board_shape', () {
      // Arrange
      final config = LinesConfig(
        board: ShapeSpec('rectangle', [3, 3]),
        catalog: hexCatalog,
        scoring: hexScoring,
      );

      // Act
      HexaLinesFactory<HexCoord> build() =>
          HexaLinesFactory(hexTopology, config);

      // Assert
      expect(build, throwsArgumentError);
    });
  });

  group('RN-HL-11', () {
    test('should_start_with_an_empty_board_when_the_game_is_new', () {
      // Act
      final state = newGame(42);

      // Assert
      expect(state.board.cells, hasLength(61));
      expect(state.board.emptyCells, hasLength(61));
    });
  });

  group('RN-HL-20', () {
    test(
      'should_draw_the_tray_in_order_from_the_seed_when_the_game_is_new',
      () {
        // Arrange: the values of RN-HL-24 for seed 42, computed outside the
        // code under test (see lines_piece_source_test.dart).
        final expected = [tablePiece(3, 4), tablePiece(4, 0), tablePiece(4, 0)];

        // Act
        final state = newGame(42);

        // Assert
        expect(state.tray, expected);
        expect(state.random, Xorshift32(1441438134));
      },
    );
  });

  group('RN-COM-41', () {
    test('should_start_the_same_game_when_the_seed_is_the_same', () {
      // Act
      final first = newGame(7);
      final second = newGame(7);

      // Assert
      expect(second, first);
    });
  });

  group('RN-COM-45', () {
    test('should_record_the_seed_when_the_game_is_new', () {
      // Act
      final state = newGame(7);

      // Assert
      expect(state.seed, 7);
    });
  });

  group('RN-HL-80', () {
    test('should_offer_no_undo_and_no_timer_when_the_game_is_new', () {
      // Act
      final session = factory().createSession(NewGameOptions(seed: 7));

      // Assert
      expect(session.undo, isNull);
      expect(session.timer, isNull);
    });
  });

  group('RN-HL-32', () {
    test('should_place_a_piece_through_the_engine_when_the_move_is_valid', () {
      // Arrange
      final session = factory().createSession(NewGameOptions(seed: 7));
      final before = session.engine.state;

      // Act
      final result = session.engine.submit(const PlacePiece(0, HexCoord(0, 0)));

      // Assert
      expect(result, isA<AcceptedMove<HexCoord, LinesState<HexCoord>>>());
      expect(session.engine.state.tray.first, isNull);
      expect(session.engine.state.tray.skip(1), before.tray.skip(1));
    });
  });

  group('RNF-11', () {
    test('should_score_with_the_configured_values_when_lines_clear', () {
      // Arrange: E-HL-1 with 10 points per line cell instead of 5.
      final config = LinesConfig(
        board: hexRadius4,
        catalog: hexCatalog,
        scoring: LinesScoringConfig(
          pointsPerLineCell: 10,
          maxStreakMultiplier: 3,
        ),
      );
      final rules = HexaLinesFactory(hexTopology, config).createRules();
      final state = LinesState(
        board: Board<HexCoord, PieceColor>.of(hexTopology, hexRadius4)
            .withCells({
              for (final q in [0, 1, 2])
                HexCoord(q, -4): const PieceColor('red'),
            }),
        tray: [
          LinesPiece(shapeOf([(0, 0), (1, 0)]), const PieceColor('red')),
          null,
          null,
        ],
        random: Xorshift32(7),
        seed: 7,
      );

      // Act
      final turn = rules.playTurn(state, const PlacePiece(0, HexCoord(3, -4)));

      // Assert: 2 + ⌊50 × 1 × 2 / 2⌋.
      expect(turn.state.score, 52);
    });
  });
}
