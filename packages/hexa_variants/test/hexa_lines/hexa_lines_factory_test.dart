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
    checkVariantFamilyContract(factory, NewGameOptions(seed: 42));
  });

  group('RN-HL-10', () {
    test('should_use_the_configured_board_when_the_game_is_new', () {
      // Act
      final state = newGame(42);

      // Assert
      expect(state.board.cells, hexTopology.cellsOf(hexRadius4));
      expect(state.board.cells, hasLength(61));
    });
  });

  group('RN-HL-11', () {
    test('should_start_with_an_empty_board_when_the_game_is_new', () {
      // Act
      final state = newGame(42);

      // Assert
      expect(state.board.emptyCells, hasLength(61));
    });
  });

  group('RN-HL-20', () {
    test(
      'should_fill_the_3_tray_slots_from_the_catalog_when_the_game_is_new',
      () {
        // Arrange
        final catalog = LinesPieceSource(
          hexTopology,
          hexCatalog,
        ).orientations.expand((family) => family).toSet();

        // Act
        final tray = newGame(42).tray;

        // Assert
        expect(tray, hasLength(3));
        expect(tray.every(catalog.contains), isTrue);
      },
    );

    test(
      'should_draw_the_tray_in_order_from_the_seed_when_the_game_is_new',
      () {
        // Arrange
        var random = Xorshift32(42);
        final source = LinesPieceSource(hexTopology, hexCatalog);
        final expected = <LinesPiece<HexCoord>>[];
        for (var i = 0; i < 3; i++) {
          final (piece, after) = source.next(random);
          expected.add(piece);
          random = after;
        }

        // Act
        final state = newGame(42);

        // Assert
        expect(state.tray, expected);
        expect(state.random, random);
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
}
