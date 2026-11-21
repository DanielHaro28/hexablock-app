import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:test/test.dart';

void main() {
  const topology = HexTopology();

  /// Default board of Hexa Sort and Hexa Merge (RN-TOP-11, 12).
  final radius2 = ShapeSpec(HexTopology.hexagon, [2]);

  /// Default board of Hexa Lines (RN-TOP-10).
  final radius4 = ShapeSpec(HexTopology.hexagon, [4]);

  List<int> lengths(Iterable<List<HexCoord>> lines) => [
    for (final line in lines) line.length,
  ];

  group('RN-HEX-02', () {
    test('should_add_the_direction_offset_when_stepping_from_a_cell', () {
      // Arrange
      const from = HexCoord(1, 1);
      final expected = {
        HexTopology.east: const HexCoord(2, 1),
        HexTopology.west: const HexCoord(0, 1),
        HexTopology.northEast: const HexCoord(2, 0),
        HexTopology.southWest: const HexCoord(0, 2),
        HexTopology.northWest: const HexCoord(1, 0),
        HexTopology.southEast: const HexCoord(1, 2),
      };

      // Act
      final reached = {
        for (final direction in expected.keys)
          direction: topology.step(from, direction),
      };

      // Assert
      expect(reached, expected);
    });

    test('should_run_east_southeast_and_southwest_when_going_forward', () {
      // Arrange
      final forward = topology.directions.where((d) => d.forward);

      // Act
      final byAxis = {for (final d in forward) d.axis: d};

      // Assert
      expect(byAxis, {
        HexTopology.axisR: HexTopology.east,
        HexTopology.axisQ: HexTopology.southEast,
        HexTopology.axisS: HexTopology.southWest,
      });
    });

    test('should_throw_when_stepping_in_a_direction_of_another_topology', () {
      // Arrange
      const foreign = Direction('N', axis: Axis('columns'), forward: false);

      // Act
      HexCoord act() => topology.step(const HexCoord(0, 0), foreign);

      // Assert
      expect(act, throwsArgumentError);
    });
  });

  group('RN-HEX-03', () {
    test('should_list_six_neighbors_when_the_cell_is_inside_the_board', () {
      // Arrange
      final board = Board<HexCoord, FakeCell>.of(topology, radius2);

      // Act
      final neighbors = board.neighbors(const HexCoord(0, 0));

      // Assert
      expect(neighbors, hasLength(6));
    });

    test('should_list_four_neighbors_when_the_cell_is_on_an_edge', () {
      // Arrange
      final board = Board<HexCoord, FakeCell>.of(topology, radius2);

      // Act
      final neighbors = board.neighbors(const HexCoord(1, -2));

      // Assert
      expect(neighbors, const [
        HexCoord(2, -2),
        HexCoord(1, -1),
        HexCoord(0, -1),
        HexCoord(0, -2),
      ]);
    });

    test('should_list_three_neighbors_when_the_cell_is_a_corner', () {
      // Arrange
      final board = Board<HexCoord, FakeCell>.of(topology, radius2);

      // Act
      final neighbors = board.neighbors(const HexCoord(2, -2));

      // Assert
      expect(neighbors, const [
        HexCoord(2, -1),
        HexCoord(1, -1),
        HexCoord(1, -2),
      ]);
    });
  });

  group('RN-HEX-04', () {
    test('should_list_the_axes_r_q_and_s_in_that_order_when_asked', () {
      // Act
      final axes = topology.axes;

      // Assert
      expect(axes, const [
        HexTopology.axisR,
        HexTopology.axisQ,
        HexTopology.axisS,
      ]);
    });

    test('should_read_rows_west_to_east_when_listing_lines_of_axis_r', () {
      // Arrange
      final cells = topology.cellsOf(radius2);

      // Act
      final first = topology.lines(cells, HexTopology.axisR).first;

      // Assert
      expect(first, const [HexCoord(0, -2), HexCoord(1, -2), HexCoord(2, -2)]);
    });

    test('should_read_northwest_to_southeast_when_listing_lines_of_axis_q', () {
      // Arrange
      final cells = topology.cellsOf(radius2);

      // Act
      final first = topology.lines(cells, HexTopology.axisQ).first;

      // Assert
      expect(first, const [HexCoord(-2, 0), HexCoord(-2, 1), HexCoord(-2, 2)]);
    });

    test('should_read_northeast_to_southwest_when_listing_lines_of_axis_s', () {
      // Arrange
      final cells = topology.cellsOf(radius2);

      // Act
      final first = topology.lines(cells, HexTopology.axisS).first;

      // Assert
      expect(first, const [HexCoord(2, 0), HexCoord(1, 1), HexCoord(0, 2)]);
    });

    test('should_keep_one_coordinate_constant_when_listing_a_line', () {
      // Arrange
      final cells = topology.cellsOf(radius2);
      final keys = {
        HexTopology.axisR: (HexCoord c) => c.r,
        HexTopology.axisQ: (HexCoord c) => c.q,
        HexTopology.axisS: (HexCoord c) => c.s,
      };

      for (final MapEntry(key: axis, value: key) in keys.entries) {
        // Act
        final lines = topology.lines(cells, axis);

        // Assert
        for (final line in lines) {
          expect(line.map(key).toSet(), hasLength(1), reason: '$axis $line');
        }
      }
    });
  });

  group('RN-HEX-05', () {
    test('should_have_3R_times_R_plus_1_plus_1_cells_when_the_radius_is_R', () {
      // Arrange
      const radii = [0, 1, 2, 3, 4];

      // Act
      final counts = [
        for (final r in radii)
          topology.cellsOf(ShapeSpec(HexTopology.hexagon, [r])).length,
      ];

      // Assert
      expect(counts, const [1, 7, 19, 37, 61]);
    });

    test(
      'should_keep_every_cell_within_the_radius_when_building_a_hexagon',
      () {
        // Act
        final cells = topology.cellsOf(radius4);

        // Assert
        for (final c in cells) {
          expect([c.q.abs(), c.r.abs(), c.s.abs()], everyElement(lessThan(5)));
        }
      },
    );

    test(
      'should_have_lines_of_3_4_5_4_3_on_every_axis_when_the_radius_is_2',
      () {
        // Arrange
        final cells = topology.cellsOf(radius2);

        for (final axis in topology.axes) {
          // Act
          final lines = topology.lines(cells, axis);

          // Assert
          expect(lengths(lines), const [3, 4, 5, 4, 3], reason: '$axis');
        }
      },
    );

    test(
      'should_have_lines_of_5_to_9_and_back_on_every_axis_when_the_radius_is_4',
      () {
        // Arrange
        final cells = topology.cellsOf(radius4);

        for (final axis in topology.axes) {
          // Act
          final lines = topology.lines(cells, axis);

          // Assert
          expect(lengths(lines), const [
            5,
            6,
            7,
            8,
            9,
            8,
            7,
            6,
            5,
          ], reason: '$axis');
        }
      },
    );

    test('should_have_15_and_27_lines_when_the_radius_is_2_and_4', () {
      // Arrange
      final small = Board<HexCoord, FakeCell>.of(topology, radius2);
      final large = Board<HexCoord, FakeCell>.of(topology, radius4);

      // Act
      final counts = [small.lines().length, large.lines().length];

      // Assert
      expect(counts, const [15, 27]);
    });

    test('should_throw_when_the_shape_is_not_a_hexagon_with_one_radius', () {
      // Arrange
      final invalid = [
        ShapeSpec('rectangle', [2]),
        ShapeSpec(HexTopology.hexagon, []),
        ShapeSpec(HexTopology.hexagon, [2, 2]),
        ShapeSpec(HexTopology.hexagon, [-1]),
      ];

      for (final spec in invalid) {
        // Act
        Set<HexCoord> act() => topology.cellsOf(spec);

        // Assert
        expect(act, throwsArgumentError, reason: '$spec');
      }
    });
  });

  group('RN-HEX-06', () {
    test(
      'should_map_q_r_s_to_minus_r_minus_s_minus_q_when_rotating_a_cell',
      () {
        // Arrange
        const cell = HexCoord(1, 1);

        // Act
        final turned = topology.rotateCell(cell, HexTopology.clockwise);

        // Assert
        expect(turned, const HexCoord(-1, 2));
      },
    );

    test('should_turn_east_into_southeast_when_rotating_clockwise', () {
      // Arrange
      final east = topology.step(const HexCoord(0, 0), HexTopology.east);

      // Act
      final turned = topology.rotateCell(east, HexTopology.clockwise);

      // Assert
      expect(
        turned,
        topology.step(const HexCoord(0, 0), HexTopology.southEast),
      );
    });

    test('should_return_the_cell_when_rotating_six_times', () {
      // Arrange
      const start = HexCoord(3, -1);
      var cell = start;

      // Act
      for (var i = 0; i < 6; i++) {
        cell = topology.rotateCell(cell, HexTopology.clockwise);
      }

      // Assert
      expect(cell, start);
    });

    test('should_have_one_basic_rotation_when_the_grid_is_2d', () {
      // Act
      final rotations = topology.basicRotations;

      // Assert
      expect(rotations, const [HexTopology.clockwise]);
    });
  });

  group('RN-HEX-08', () {
    test('should_go_clockwise_from_northeast_when_listing_neighbors', () {
      // Arrange
      const cell = HexCoord(0, 0);

      // Act
      final neighbors = topology.neighbors(cell);

      // Assert: NE, E, SE, SW, W, NW.
      expect(neighbors, const [
        HexCoord(1, -1),
        HexCoord(1, 0),
        HexCoord(0, 1),
        HexCoord(-1, 1),
        HexCoord(-1, 0),
        HexCoord(0, -1),
      ]);
    });

    test('should_list_directions_in_the_neighbor_order_when_asked', () {
      // Act
      final directions = topology.directions;

      // Assert
      expect(directions, const [
        HexTopology.northEast,
        HexTopology.east,
        HexTopology.southEast,
        HexTopology.southWest,
        HexTopology.west,
        HexTopology.northWest,
      ]);
    });
  });

  group('RN-COM-16', () {
    test('should_sort_by_r_then_q_when_putting_cells_in_reading_order', () {
      // Arrange
      const cells = [HexCoord(0, 1), HexCoord(1, 0), HexCoord(2, -1)];

      // Act
      final sorted = topology.inReadingOrder(cells);

      // Assert
      expect(sorted, const [HexCoord(2, -1), HexCoord(1, 0), HexCoord(0, 1)]);
    });
  });

  group('RN-COM-15', () {
    test('should_use_the_origin_when_normalizing_any_cell', () {
      // Arrange
      const first = HexCoord(-3, 2);

      // Act
      final origin = topology.normalizationOrigin(first);

      // Assert
      expect(origin, const HexCoord(0, 0));
    });

    test(
      'should_move_by_the_vector_from_one_cell_to_another_when_translating',
      () {
        // Arrange
        const cell = HexCoord(1, 1);

        // Act
        final moved = topology.translate(
          cell,
          const HexCoord(0, 0),
          const HexCoord(-2, 3),
        );

        // Assert
        expect(moved, const HexCoord(-1, 4));
      },
    );
  });

  group('E-HEX-1', () {
    final arc = Shape.fromCells(const [
      HexCoord(0, 0),
      HexCoord(1, 0),
      HexCoord(1, 1),
    ]);

    test('should_give_the_arc_0_0_0_1_minus1_2_when_rotating_it_once', () {
      // Act
      final turned = topology.rotate(arc, HexTopology.clockwise);

      // Assert
      expect(turned.cells, {
        const HexCoord(0, 0),
        const HexCoord(0, 1),
        const HexCoord(-1, 2),
      });
    });

    test('should_return_the_arc_when_rotating_it_six_times', () {
      // Arrange
      var shape = arc;

      // Act
      for (var i = 0; i < 6; i++) {
        shape = topology.rotate(shape, HexTopology.clockwise);
      }

      // Assert
      expect(shape, arc);
    });

    test('should_find_six_orientations_when_the_arc_has_no_symmetry', () {
      // Act
      final orientations = topology.orientations(arc);

      // Assert
      expect(orientations, hasLength(6));
    });
  });

  group('D-29', () {
    test(
      'should_build_a_hex_board_when_visiting_a_topology_stored_as_any_coord',
      () {
        // Arrange
        const GridTopology<Coord> stored = HexTopology();

        // Act
        final board = stored.accept(_BoardBuilder(radius2));

        // Assert
        expect(board, isA<HexBoard<FakeCell>>());
        expect(board.cells, hasLength(19));
      },
    );
  });

  group('contract (RN-COM-10 to 17), radius 2', () {
    checkTopologyContract(topology, radius2);
  });

  group('contract (RN-COM-10 to 17), radius 4', () {
    checkTopologyContract(topology, radius4);
  });
}

/// Builds an empty board with the real coordinate type of the visited
/// topology, as the composition root does (D-29).
final class _BoardBuilder implements TopologyVisitor<Board<Coord, FakeCell>> {
  _BoardBuilder(this.spec);

  final ShapeSpec spec;

  @override
  Board<Coord, FakeCell> visit<C extends Coord>(GridTopology<C> topology) =>
      Board<C, FakeCell>.of(topology, spec);
}
