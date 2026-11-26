import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexa_test_support/hexa_test_support.dart';
import 'package:hexablock_app/frameworks/platform/error_handlers.dart';

void main() {
  group('D-163', () {
    test('should_log_a_flutter_error_when_one_is_reported', () {
      // Arrange
      final logger = FakeLogger();
      final original = FlutterError.onError;
      FlutterError.onError = (_) {}; // the previous handler, silent here
      final error = StateError('layout');
      final stack = StackTrace.current;

      // Act
      try {
        installErrorHandlers(
          logger,
          PlatformDispatcher.instance,
          verbose: true,
        );
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'rendering',
          ),
        );
      } finally {
        FlutterError.onError = original;
        PlatformDispatcher.instance.onError = null;
      }

      // Assert
      final entry = logger.entries.single;
      expect(entry.level, LogLevel.error);
      expect(entry.message, 'Flutter error');
      expect(entry.data, {'error': 'StateError', 'library': 'rendering'});
      expect(entry.error, same(error));
      expect(entry.stackTrace, same(stack));
    });

    for (final checksHandled in [false, true]) {
      final name = checksHandled
          ? 'should_mark_an_uncaught_error_handled_when_it_reaches_the_platform'
          : 'should_log_an_uncaught_error_when_it_reaches_the_platform';
      test(name, () {
        // Arrange
        final logger = FakeLogger();
        final original = FlutterError.onError;
        final error = ArgumentError('bad');
        final stack = StackTrace.current;
        late final bool handled;

        // Act
        try {
          installErrorHandlers(
            logger,
            PlatformDispatcher.instance,
            verbose: true,
          );
          handled = PlatformDispatcher.instance.onError!(error, stack);
        } finally {
          FlutterError.onError = original;
          PlatformDispatcher.instance.onError = null;
        }

        // Assert
        if (checksHandled) {
          expect(handled, isTrue);
        } else {
          expect(logger.entries.single.message, 'Uncaught error');
          expect(logger.entries.single.data, {'error': 'ArgumentError'});
        }
      });
    }
  });

  group('SEC-MOB-05', () {
    // Flutter's default handler prints the error's text, which may hold user
    // data, even in release builds, so only a development build calls it.
    for (final verbose in [true, false]) {
      final when = verbose ? 'verbose' : 'not_verbose';
      final call = verbose ? 'call' : 'not_call';
      test('should_${call}_the_previous_handler_when_$when', () {
        // Arrange
        final original = FlutterError.onError;
        var previousCalls = 0;
        FlutterError.onError = (_) => previousCalls++;

        // Act
        try {
          installErrorHandlers(
            FakeLogger(),
            PlatformDispatcher.instance,
            verbose: verbose,
          );
          FlutterError.reportError(
            FlutterErrorDetails(exception: StateError('x')),
          );
        } finally {
          FlutterError.onError = original;
          PlatformDispatcher.instance.onError = null;
        }

        // Assert
        expect(previousCalls, verbose ? 1 : 0);
      });
    }
  });
}
