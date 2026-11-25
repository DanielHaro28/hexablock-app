import 'package:hexa_application/hexa_application.dart';

/// Runs a Drift database [action] and maps technical storage errors into
/// [PersistenceException] (D-39).
Future<T> runDrift<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on AppException {
    rethrow;
  } on Exception {
    throw const PersistenceException();
  }
}
