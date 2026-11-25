import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock_app/frameworks/platform/system_clock.dart';

void main() {
  group('RN-COM-52', () {
    test('should_never_go_back_when_read_twice', () {
      // Arrange
      final clock = SystemClock();

      // Act
      final first = clock.nowMillis();
      final second = clock.nowMillis();

      // Assert
      expect(second, greaterThanOrEqualTo(first));
    });

    test('should_give_the_date_in_utc_when_asked_for_now', () {
      // Arrange
      final clock = SystemClock();

      // Act
      final now = clock.now();

      // Assert
      expect(now.isUtc, isTrue);
    });
  });
}
