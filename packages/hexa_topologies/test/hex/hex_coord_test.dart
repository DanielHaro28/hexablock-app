import 'package:hexa_topologies/hexa_topologies.dart';
import 'package:test/test.dart';

void main() {
  group('RN-HEX-01', () {
    test('should_derive_s_as_minus_q_minus_r_when_building_a_coordinate', () {
      // Arrange
      const coord = HexCoord(2, -3);

      // Act
      final s = coord.s;

      // Assert
      expect(s, 1);
    });

    test('should_be_equal_when_two_coordinates_have_the_same_q_and_r', () {
      // Arrange
      final a = HexCoord(1, int.parse('-2'));
      const b = HexCoord(1, -2);

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('should_differ_when_q_and_r_are_swapped', () {
      // Arrange
      const a = HexCoord(1, -2);
      const b = HexCoord(-2, 1);

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });

    test('should_show_q_and_r_when_printing_a_coordinate', () {
      // Arrange
      const coord = HexCoord(-1, 2);

      // Act
      final text = coord.toString();

      // Assert
      expect(text, '(-1, 2)');
    });
  });

  group('RN-HEX-07', () {
    test('should_be_zero_when_measuring_from_a_cell_to_itself', () {
      // Arrange
      const cell = HexCoord(3, -1);

      // Act
      final distance = cell.distanceTo(cell);

      // Assert
      expect(distance, 0);
    });

    test('should_be_one_when_measuring_to_a_neighbor', () {
      // Arrange
      const cell = HexCoord(0, 0);
      const neighbors = [
        HexCoord(1, -1),
        HexCoord(1, 0),
        HexCoord(0, 1),
        HexCoord(-1, 1),
        HexCoord(-1, 0),
        HexCoord(0, -1),
      ];

      // Act
      final distances = [for (final n in neighbors) cell.distanceTo(n)];

      // Assert
      expect(distances, everyElement(1));
    });

    test('should_be_half_the_sum_of_the_three_gaps_when_cells_are_far_apart', () {
      // Arrange: Δq = 2, Δr = −1, Δs = −1.
      const from = HexCoord(0, 0);
      const to = HexCoord(2, -1);

      // Act
      final distance = from.distanceTo(to);

      // Assert
      expect(distance, 2);
    });

    test('should_be_the_diameter_when_measuring_opposite_corners_of_radius_2', () {
      // Arrange
      const from = HexCoord(-2, 2);
      const to = HexCoord(2, -2);

      // Act
      final there = from.distanceTo(to);
      final back = to.distanceTo(from);

      // Assert
      expect(there, 4);
      expect(back, there);
    });
  });
}
