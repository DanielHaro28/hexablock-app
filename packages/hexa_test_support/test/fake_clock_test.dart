import 'package:hexa_engine/hexa_engine.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:test/test.dart';

void main() {
  // FakeClock is the double of the domain's IMonotonicClock port (D-33) and
  // of the application's IClock (ARQ-03 §4): the tests move time by hand, so
  // they never wait for real time.

  group('D-56', () {
    test('should_start_at_zero_when_no_start_is_given', () {
      // Arrange
      final IMonotonicClock clock = FakeClock();

      // Act
      final now = clock.nowMillis();

      // Assert
      expect(now, 0);
    });

    test('should_report_the_same_time_when_it_is_not_advanced', () {
      // Arrange
      final clock = FakeClock(startMillis: 1500);

      // Act
      final first = clock.nowMillis();
      final second = clock.nowMillis();

      // Assert
      expect(first, 1500);
      expect(second, 1500);
    });

    test('should_add_the_duration_in_milliseconds_when_advanced', () {
      // Arrange
      final clock = FakeClock(startMillis: 1000);

      // Act
      clock
        ..advance(const Duration(seconds: 2))
        ..advance(const Duration(milliseconds: 250));

      // Assert
      expect(clock.nowMillis(), 3250);
    });

    test('should_throw_when_advanced_by_a_negative_duration', () {
      // Arrange
      final clock = FakeClock(startMillis: 1000);

      // Act
      void goBack() => clock.advance(const Duration(milliseconds: -1));

      // Assert
      expect(goBack, throwsArgumentError);
      expect(clock.nowMillis(), 1000);
    });

    test('should_move_the_date_with_the_time_when_advanced', () {
      // Arrange
      final clock = FakeClock(
        startMillis: 500,
        startDate: DateTime.utc(2026, 11, 24, 18, 30),
      );

      // Act
      clock.advance(const Duration(minutes: 1));

      // Assert
      expect(clock.now(), DateTime.utc(2026, 11, 24, 18, 31));
      expect(clock.nowMillis(), 60500);
    });
  });
}
