import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';
import 'package:hexablock_app/adapters/mappers/lines_config_mapper.dart';

/// Reads `[q, r]` as a hexagonal cell, as the hex topology entry does.
HexCoord _hex(List<int> cell) => switch (cell) {
  [final q, final r] => HexCoord(q, r),
  _ => throw FormatException('expected [q, r]', cell),
};

Map<String, Object?> _asset() =>
    jsonDecode(File('assets/config/hexa-lines.json').readAsStringSync())
        as Map<String, Object?>;

/// The 8 families of RN-HL-23: base shape, weight and color.
const _families = [
  ([(0, 0)], 5, 'red'),
  ([(0, 0), (1, 0)], 10, 'orange'),
  ([(0, 0), (1, 0), (2, 0)], 15, 'yellow'),
  ([(0, 0), (1, 0), (1, 1)], 15, 'green'),
  ([(0, 0), (1, 0), (0, 1)], 15, 'teal'),
  ([(0, 0), (1, 0), (2, 0), (3, 0)], 15, 'blue'),
  ([(0, 0), (1, 0), (0, 1), (1, 1)], 15, 'purple'),
  ([(0, 0), (1, 0), (2, 0), (3, 0), (4, 0)], 10, 'pink'),
];

void main() {
  const mapper = LinesConfigMapper();

  group('RN-HL-10', () {
    test('should_read_a_board_of_radius_4_when_the_topology_is_hex', () {
      // Arrange
      final json = _asset();

      // Act
      final config = mapper.fromJson(json, 'hex', _hex);

      // Assert
      expect(config.board, ShapeSpec(HexTopology.hexagon, const [4]));
      expect(const HexTopology().cellsOf(config.board), hasLength(61));
    });
  });

  group('RN-HL-23', () {
    test('should_read_the_8_families_in_the_order_of_the_table', () {
      // Arrange
      final json = _asset();

      // Act
      final catalog = mapper.fromJson(json, 'hex', _hex).catalog;

      // Assert
      expect(catalog, hasLength(_families.length));
      for (final (index, (cells, weight, color)) in _families.indexed) {
        final family = catalog[index];
        expect(
          family.shape,
          Shape.fromCells([for (final (q, r) in cells) HexCoord(q, r)]),
        );
        expect(family.weight, weight);
        expect(family.color, PieceColor(color));
      }
    });

    test('should_build_a_working_factory_when_given_the_configuration', () {
      // Arrange
      final config = mapper.fromJson(_asset(), 'hex', _hex);

      // Act
      final factory = HexaLinesFactory(const HexTopology(), config);

      // Assert
      final session = factory.createSession(NewGameOptions(seed: 1));
      addTearDown(session.engine.close);
      expect(session.engine.state.tray.nonNulls, hasLength(3));
    });
  });

  group('D-132', () {
    test('should_throw_a_format_exception_when_the_topology_is_missing', () {
      // Arrange
      final json = _asset();

      // Act
      LinesConfig<HexCoord> read() => mapper.fromJson(json, 'square', _hex);

      // Assert
      expect(read, throwsFormatException);
    });

    test('should_throw_a_format_exception_when_a_family_is_malformed', () {
      // Arrange
      final json = {
        'gameId': 'hexa-lines',
        'topologies': {
          'hex': {
            'board': {
              'kind': 'hexagon',
              'size': [4],
            },
            'catalog': [
              {'weight': 'five', 'color': 'red', 'shape': <Object>[]},
            ],
          },
        },
      };

      // Act
      LinesConfig<HexCoord> read() => mapper.fromJson(json, 'hex', _hex);

      // Assert
      expect(read, throwsFormatException);
    });
  });
}
