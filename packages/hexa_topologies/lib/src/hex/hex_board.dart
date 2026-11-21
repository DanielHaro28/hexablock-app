import 'package:hexa_engine/hexa_engine.dart';

import 'hex_coord.dart';

/// The board of hexagonal cells (D-07, TEC-06).
///
/// Only a name: it is the generic `Board` with `HexCoord` as its coordinate,
/// so it has no code of its own and the engine never sees it. The name is
/// kept because it is the one the course statement uses.
typedef HexBoard<TCell extends Object> = Board<HexCoord, TCell>;
