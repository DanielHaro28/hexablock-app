import 'package:hexa_engine/hexa_engine.dart';

/// Reads one cell written as a list of integers in a configuration or level
/// file (`[q, r]` for hexagons) as the coordinate of a topology.
///
/// Every mapper that reads cells takes one, so it stays generic in `C`; the
/// topology's entry provides it (ARQ-02 §3.1).
typedef CoordOf<C extends Coord> = C Function(List<int> cell);
