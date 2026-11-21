import 'package:hexa_engine/src/probe.dart';
import 'package:test/test.dart';

void main() {
  group('E-HEX-1', () {
    test('should_add_one_when_covered_is_called', () {
      // Arrange
      const x = 1;

      // Act
      final result = covered(x);

      // Assert
      expect(result, 2);
    });

    test('should_double_the_previous_when_uncovered_is_called', () {
      // Arrange
      const x = 3;

      // Act
      final result = uncovered(x);

      // Assert
      expect(result, 4);
    });
  });
}
