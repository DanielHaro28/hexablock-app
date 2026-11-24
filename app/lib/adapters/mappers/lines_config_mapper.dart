import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_variants/hexa_variants.dart';

import 'coord_of.dart';

/// Reads the configuration of Hexa Lines for one topology from
/// `assets/config/hexa-lines.json` (D-132, RN-COM-04, RNF-11).
///
/// The file has one entry per topology id, with the board shape (RN-HL-10)
/// and the catalog families in the order of the table (RN-HL-23). Each
/// family has only its base shape; the topology gives the orientations
/// (RN-COM-14). A file that does not have this shape fails with a
/// [FormatException], so a bad configuration fails when the game opens and
/// not in the middle of it.
final class LinesConfigMapper {
  /// The mapper.
  const LinesConfigMapper();

  /// The configuration for [topologyId] in [json], with cells read by
  /// [coordOf].
  LinesConfig<C> fromJson<C extends Coord>(
    Map<String, Object?> json,
    String topologyId,
    CoordOf<C> coordOf,
  ) {
    final entry = switch (json['topologies']) {
      final Map<String, Object?> topologies => switch (topologies[topologyId]) {
        final Map<String, Object?> entry => entry,
        _ => throw FormatException('no Hexa Lines entry for $topologyId'),
      },
      _ => throw const FormatException('no topologies in the configuration'),
    };
    return switch (entry) {
      {
        'board': {'kind': final String kind, 'size': final List<Object?> size},
        'catalog': final List<Object?> catalog,
      } =>
        LinesConfig(
          board: ShapeSpec(kind, _ints(size)),
          catalog: [for (final family in catalog) _family(family, coordOf)],
        ),
      _ => throw FormatException('malformed entry for $topologyId', entry),
    };
  }

  LinesFamily<C> _family<C extends Coord>(Object? json, CoordOf<C> coordOf) =>
      switch (json) {
        {
          'weight': final int weight,
          'color': final String color,
          'shape': final List<Object?> cells,
        }
            when cells.isNotEmpty =>
          LinesFamily(
            shape: Shape.fromCells([
              for (final cell in cells) coordOf(_ints(cell)),
            ]),
            weight: weight,
            color: PieceColor(color),
          ),
        _ => throw FormatException('malformed family', json),
      };

  List<int> _ints(Object? json) {
    if (json is! List<Object?>) {
      throw FormatException('expected a list of integers', json);
    }
    final ints = json.whereType<int>().toList();
    if (ints.length != json.length) {
      throw FormatException('expected a list of integers', json);
    }
    return ints;
  }
}
