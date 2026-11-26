import 'package:flutter/foundation.dart';
import 'package:hexa_application/hexa_application.dart';

/// Sends the errors that happen outside a use case to [logger] (D-163).
///
/// The aspects only see what a use case does. An error while building or
/// painting a widget reaches `FlutterError.onError`, and one in a callback,
/// a stream or a timer that nothing caught reaches the [dispatcher]. Both
/// are logged as errors, with their type and stack.
///
/// When [verbose] (development builds), the Flutter error then goes on to
/// the handler that was there before, so it still shows as usual. A release
/// build does not call it: Flutter's default handler prints the text of the
/// error, which may hold user data, even in release (SEC-MOB-05).
void installErrorHandlers(
  ILogger logger,
  PlatformDispatcher dispatcher, {
  required bool verbose,
}) {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    logger.log(
      LogEntry.error(
        'Flutter error',
        {
          'error': '${details.exception.runtimeType}',
          'library': details.library ?? 'unknown',
        },
        error: details.exception,
        stackTrace: details.stack,
      ),
    );
    if (verbose) previous?.call(details);
  };
  dispatcher.onError = (error, stackTrace) {
    logger.log(
      LogEntry.error(
        'Uncaught error',
        {'error': '${error.runtimeType}'},
        error: error,
        stackTrace: stackTrace,
      ),
    );
    return true;
  };
}
