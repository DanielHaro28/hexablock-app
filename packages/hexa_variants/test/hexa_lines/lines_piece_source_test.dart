import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:test/test.dart';

import 'hex_catalog.dart';

void main() {
  LinesPieceSource<HexCoord> source() =>
      LinesPieceSource(hexTopology, hexCatalog);

  /// The first [count] pieces drawn from [seed].
  List<LinesPiece<HexCoord>> draw(int seed, int count) {
    final pieces = <LinesPiece<HexCoord>>[];
    var random = Xorshift32(seed);
    for (var i = 0; i < count; i++) {
      final (piece, after) = source().next(random);
      pieces.add(piece);
      random = after;
    }
    return pieces;
  }

  /// Orientation [orientation] of family [family] (both from 0) of RN-HL-23.
  LinesPiece<HexCoord> tablePiece(int family, int orientation) => LinesPiece(
    shapeOf(hexOrientationTable[family][orientation]),
    hexCatalog[family].color,
  );

  group('RN-HL-23', () {
    test('should_list_the_orientations_of_the_table_when_built_from_the_'
        'base_shapes', () {
      // Arrange
      final expected = [
        for (final family in hexOrientationTable)
          [for (final cells in family) shapeOf(cells)],
      ];

      // Act
      final orientations = source().orientations;

      // Assert
      expect([
        for (final family in orientations)
          [for (final piece in family) piece.shape],
      ], expected);
    });

    test('should_have_24_pieces_when_the_catalog_is_the_hex_one', () {
      // Arrange
      final catalog = source();

      // Act
      final count = catalog.orientations.fold(0, (sum, f) => sum + f.length);

      // Assert
      expect(count, 24);
    });

    test(
      'should_give_every_orientation_the_color_of_its_family_when_built',
      () {
        // Arrange
        final catalog = source();

        // Act
        final colors = [
          for (final family in catalog.orientations)
            {for (final piece in family) piece.color},
        ];

        // Assert
        expect(colors, [
          for (final family in hexCatalog) {family.color},
        ]);
      },
    );
  });

  group('RN-HL-24', () {
    // Expected values computed outside the code under test, with an
    // independent xorshift32 (seed 42: 11355432 mod 100 = 32 → arc of 3,
    // 2836018348 mod 6 = 4; 476557059 mod 100 = 59 → triangle of 3,
    // 3648046016 mod 2 = 0; 3759983556 mod 100 = 56 → triangle of 3,
    // 1441438134 mod 2 = 0).
    test('should_pick_the_family_by_weight_and_then_the_orientation_when_'
        'drawing', () {
      // Arrange
      const seed = 42;

      // Act
      final pieces = draw(seed, 3);

      // Assert
      expect(pieces, [tablePiece(3, 4), tablePiece(4, 0), tablePiece(4, 0)]);
    });

    test('should_use_two_draws_per_piece_when_drawing', () {
      // Arrange
      final random = Xorshift32(42);

      // Act
      final (_, after) = source().next(random);

      // Assert
      expect(after, Xorshift32(2836018348));
    });

    test('should_pick_the_last_family_when_the_roll_falls_in_its_weight', () {
      // Arrange: seed 0 draws 1359758873 (73), 3761132862, then 2075758394,
      // whose roll 94 falls in the last 10 of the weights (line of 5).
      final (_, afterFirst) = source().next(Xorshift32(0));

      // Act
      final (piece, _) = source().next(afterFirst);

      // Assert: 25405621 mod 3 = 1.
      expect(piece, tablePiece(7, 1));
    });
  });

  group('RN-COM-41', () {
    test('should_draw_the_same_pieces_when_the_seed_is_the_same', () {
      // Arrange
      const seed = 1;

      // Act
      final first = draw(seed, 12);
      final second = draw(seed, 12);

      // Assert
      expect(second, first);
    });

    test('should_draw_other_pieces_when_the_seed_differs', () {
      // Arrange
      final first = draw(1, 12);

      // Act
      final other = draw(2, 12);

      // Assert
      expect(other, isNot(first));
    });
  });

  group('RN-COM-04', () {
    test('should_throw_when_the_weights_do_not_add_up_to_100', () {
      // Arrange
      final catalog = [...hexCatalog]..removeAt(0); // without the mono: 95

      // Act
      LinesPieceSource<HexCoord> build() =>
          LinesPieceSource(hexTopology, catalog);

      // Assert
      expect(build, throwsArgumentError);
    });

    test('should_throw_when_a_weight_is_not_positive', () {
      // Act
      LinesFamily<HexCoord> build() => LinesFamily(
        shape: shapeOf([(0, 0)]),
        weight: 0,
        color: const PieceColor('red'),
      );

      // Assert
      expect(build, throwsArgumentError);
    });
  });

  group('RN-HL-22', () {
    test('should_throw_when_a_piece_has_more_than_5_cells', () {
      // Act
      LinesFamily<HexCoord> build() => LinesFamily(
        shape: shapeOf([(0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0)]),
        weight: 5,
        color: const PieceColor('red'),
      );

      // Assert
      expect(build, throwsArgumentError);
    });
  });
}
