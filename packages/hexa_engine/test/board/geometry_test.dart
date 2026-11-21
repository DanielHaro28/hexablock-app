import 'package:hexa_engine/hexa_engine.dart';
import 'package:test/test.dart';

/// Axes, directions and rotations are compared by value, so one rebuilt from
/// saved data (not `const`) still matches the topology's own instance.
void main() {
  /// Built at runtime, so the instances below are never canonicalized.
  String runtimeId(String id) => String.fromCharCodes(id.codeUnits);

  group('RN-COM-12', () {
    test('should_be_equal_when_two_axes_have_the_same_id', () {
      // Arrange
      final a = Axis(runtimeId('r'));
      final b = Axis(runtimeId('r'));

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('should_not_be_equal_when_two_axes_have_different_ids', () {
      // Arrange
      const a = Axis('q');
      const b = Axis('r');

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });
  });

  group('RN-COM-13', () {
    test(
      'should_be_equal_when_two_directions_have_the_same_axis_and_sense',
      () {
        // Arrange
        final a = Direction(
          runtimeId('E'),
          axis: const Axis('r'),
          forward: true,
        );
        final b = Direction(
          runtimeId('E'),
          axis: const Axis('r'),
          forward: true,
        );

        // Act
        final equal = a == b;

        // Assert
        expect(equal, isTrue);
        expect(a.hashCode, b.hashCode);
      },
    );

    test('should_not_be_equal_when_two_directions_have_opposite_senses', () {
      // Arrange
      const a = Direction('E', axis: Axis('r'), forward: true);
      const b = Direction('E', axis: Axis('r'), forward: false);

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });
  });

  group('RN-COM-14', () {
    test('should_be_equal_when_two_rotations_have_the_same_id', () {
      // Arrange
      final a = Rotation(runtimeId('cw60'));
      final b = Rotation(runtimeId('cw60'));

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('should_not_be_equal_when_two_rotations_have_different_ids', () {
      // Arrange
      const a = Rotation('x');
      const b = Rotation('y');

      // Act
      final equal = a == b;

      // Assert
      expect(equal, isFalse);
    });
  });
}
