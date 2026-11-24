/// Test data: the Hexa Lines catalog for hexagons (RN-HL-23) and its default
/// board (RN-HL-10), written the way the configuration will give them.
///
/// Each family has only its base shape (the first orientation of the
/// table); the source derives the rest with the topology. The colors are
/// test data: RN-HL-01 makes them visual only and the rules do not fix them.
library;

import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:hexa_variants/hexa_variants.dart';

/// The topology of every example of 02-RN-HEXA-LINES.
const hexTopology = HexTopology();

/// The board of RN-HL-10 for hexagons: radius 4, 61 cells.
final hexRadius4 = ShapeSpec(HexTopology.hexagon, [4]);

Shape<HexCoord> shapeOf(List<(int, int)> cells) =>
    Shape.fromCells([for (final (q, r) in cells) HexCoord(q, r)]);

LinesFamily<HexCoord> _family(
  List<(int, int)> base,
  int weight,
  String color,
) =>
    LinesFamily(shape: shapeOf(base), weight: weight, color: PieceColor(color));

/// The 8 families of RN-HL-23, in the order of the table.
final hexCatalog = [
  _family([(0, 0)], 5, 'red'), // 1 mono
  _family([(0, 0), (1, 0)], 10, 'orange'), // 2 domino
  _family([(0, 0), (1, 0), (2, 0)], 15, 'yellow'), // 3 line of 3
  _family([(0, 0), (1, 0), (1, 1)], 15, 'green'), // 4 arc of 3
  _family([(0, 0), (1, 0), (0, 1)], 15, 'teal'), // 5 triangle of 3
  _family([(0, 0), (1, 0), (2, 0), (3, 0)], 15, 'blue'), // 6 line of 4
  _family([(0, 0), (1, 0), (0, 1), (1, 1)], 15, 'purple'), // 7 rhombus of 4
  _family([(0, 0), (1, 0), (2, 0), (3, 0), (4, 0)], 10, 'pink'), // 8 line of 5
];

/// The configuration of Hexa Lines on hexagons.
final hexConfig = LinesConfig(board: hexRadius4, catalog: hexCatalog);

/// Every orientation of RN-HL-23, family by family, as the table lists them.
final hexOrientationTable = <List<List<(int, int)>>>[
  [
    [(0, 0)],
  ],
  [
    [(0, 0), (1, 0)],
    [(0, 0), (0, 1)],
    [(0, 0), (-1, 1)],
  ],
  [
    [(0, 0), (1, 0), (2, 0)],
    [(0, 0), (0, 1), (0, 2)],
    [(0, 0), (-1, 1), (-2, 2)],
  ],
  [
    [(0, 0), (1, 0), (1, 1)],
    [(0, 0), (0, 1), (-1, 2)],
    [(0, 0), (-2, 1), (-1, 1)],
    [(0, 0), (0, 1), (1, 1)],
    [(0, 0), (-1, 1), (-1, 2)],
    [(0, 0), (1, 0), (-1, 1)],
  ],
  [
    [(0, 0), (1, 0), (0, 1)],
    [(0, 0), (-1, 1), (0, 1)],
  ],
  [
    [(0, 0), (1, 0), (2, 0), (3, 0)],
    [(0, 0), (0, 1), (0, 2), (0, 3)],
    [(0, 0), (-1, 1), (-2, 2), (-3, 3)],
  ],
  [
    [(0, 0), (1, 0), (0, 1), (1, 1)],
    [(0, 0), (-1, 1), (0, 1), (-1, 2)],
    [(0, 0), (1, 0), (-1, 1), (0, 1)],
  ],
  [
    [(0, 0), (1, 0), (2, 0), (3, 0), (4, 0)],
    [(0, 0), (0, 1), (0, 2), (0, 3), (0, 4)],
    [(0, 0), (-1, 1), (-2, 2), (-3, 3), (-4, 4)],
  ],
];

/// Orientation [orientation] of family [family] (both from 0) of RN-HL-23,
/// with the family's color.
LinesPiece<HexCoord> tablePiece(int family, int orientation) => LinesPiece(
  shapeOf(hexOrientationTable[family][orientation]),
  hexCatalog[family].color,
);
