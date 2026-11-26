import 'package:flutter_test/flutter_test.dart';
import 'package:hexa_application/hexa_application.dart';
import 'package:hexablock_app/frameworks/platform/platform_logger.dart';

void main() {
  /// A logger that writes into [lines].
  PlatformLogger loggerInto(List<String> lines, {required bool verbose}) =>
      PlatformLogger(verbose: verbose, write: lines.add);

  final error = StateError('player@example.test broke it');
  final stack = StackTrace.fromString('#0 main (file.dart:1)');

  group('D-163', () {
    test('should_write_every_level_with_its_data_when_verbose', () {
      // Arrange
      final lines = <String>[];
      final logger = loggerInto(lines, verbose: true);

      // Act
      logger
        ..log(const LogEntry.debug('ApplyMove started', {'move': 'm'}))
        ..log(const LogEntry.info('ApplyMove finished', {'ms': 3}));

      // Assert
      expect(lines, [
        '[hexablock] DEBUG ApplyMove started {move: m}',
        '[hexablock] INFO ApplyMove finished {ms: 3}',
      ]);
    });

    test('should_write_only_warnings_and_errors_when_not_verbose', () {
      // Arrange
      final lines = <String>[];
      final logger = loggerInto(lines, verbose: false);

      // Act
      logger
        ..log(const LogEntry.debug('Login started'))
        ..log(const LogEntry.info('Login finished', {'ms': 320}))
        ..log(const LogEntry.warning('Login failed', {'failure': 'network'}));

      // Assert
      expect(lines, ['[hexablock] WARNING Login failed {failure: network}']);
    });

    test('should_write_the_redacted_error_and_its_stack_when_verbose', () {
      // Arrange
      final lines = <String>[];
      final logger = loggerInto(lines, verbose: true);

      // Act
      logger.log(
        LogEntry.error(
          'Save unexpected error',
          const {},
          error: error,
          stackTrace: stack,
        ),
      );

      // Assert
      expect(lines.single, contains('StateError'));
      expect(lines.single, contains('${Redactor.mask} broke it'));
      expect(lines.single, contains('#0 main (file.dart:1)'));
    });
  });

  group('SEC-WEB-06', () {
    test('should_redact_the_data_when_writing_in_any_build', () {
      // Arrange
      final lines = <String>[];
      final logger = loggerInto(lines, verbose: false);

      // Act
      logger.log(
        const LogEntry.warning('Login failed', {'password': 'hunter2'}),
      );

      // Assert
      expect(
        lines.single,
        '[hexablock] WARNING Login failed {password: ${Redactor.mask}}',
      );
    });
  });

  group('SEC-MOB-05', () {
    test('should_write_only_the_error_type_and_stack_when_not_verbose', () {
      // Arrange
      final lines = <String>[];
      final logger = loggerInto(lines, verbose: false);

      // Act
      logger.log(
        LogEntry.error(
          'Save unexpected error',
          const {},
          error: error,
          stackTrace: stack,
        ),
      );

      // Assert
      expect(lines.single, isNot(contains('player@example.test')));
      expect(
        lines.single,
        '[hexablock] ERROR Save unexpected error\nStateError\n'
        '#0 main (file.dart:1)',
      );
    });
  });
}
