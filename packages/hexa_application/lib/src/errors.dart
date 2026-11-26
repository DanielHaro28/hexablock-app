/// The errors of the app (D-39, D-161, ARQ-03 §2).
///
/// The adapters translate technical errors into typed [AppException]s and
/// throw them; the use cases let them through without catching. A use case
/// stopped by one of its own rules returns a `Left` with its [AppFailure]
/// instead of throwing. `ExceptionAspect` turns every exception into a
/// `Left`, so the screen switches exhaustively over an [AppFailure]. A
/// rejected move is not an error: it is a `RejectedMove` inside a `Right`
/// (RN-COM-21).
library;

/// An error an adapter throws on purpose.
sealed class AppException implements Exception {
  const AppException();
}

/// No network, or the request timed out.
final class NetworkException extends AppException {
  /// A network error; [timeout] says whether the request timed out.
  const NetworkException({this.timeout = false});

  /// Whether the request timed out.
  final bool timeout;
}

/// The API answered 401: the session expired.
final class SessionExpiredException extends AppException {
  /// The session expired.
  const SessionExpiredException();
}

/// The API answered 409 with [code] (for example `email-taken`).
final class ConflictException extends AppException {
  /// A conflict with [code].
  const ConflictException(this.code);

  /// The `code` of the Problem Details answer.
  final String code;
}

/// The API answered 400 with an error per field.
final class ValidationException extends AppException {
  /// A validation error with the [fields] that failed and their code.
  const ValidationException(this.fields);

  /// The code of each field that failed, by its JSON pointer.
  final Map<String, String> fields;
}

/// The local database failed.
final class PersistenceException extends AppException {
  /// A local database error.
  const PersistenceException();
}

/// What the screen is told went wrong; its text comes from the ARB files.
sealed class AppFailure {
  const AppFailure();
}

/// No connection, after the retries.
final class NetworkFailure extends AppFailure {
  /// No connection.
  const NetworkFailure();

  @override
  bool operator ==(Object other) => other is NetworkFailure;

  @override
  int get hashCode => (NetworkFailure).hashCode;
}

/// The player must log in: the session [expired] or there was none.
final class SessionFailure extends AppFailure {
  /// A session failure; [expired] tells the two cases apart.
  const SessionFailure({required this.expired});

  /// Whether there was a session and it expired.
  final bool expired;

  @override
  bool operator ==(Object other) =>
      other is SessionFailure && other.expired == expired;

  @override
  int get hashCode => expired.hashCode;
}

/// A conflict with [code], shown next to the form field.
final class ConflictFailure extends AppFailure {
  /// A conflict with [code].
  const ConflictFailure(this.code);

  /// The conflict code.
  final String code;

  @override
  bool operator ==(Object other) =>
      other is ConflictFailure && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// The [fields] that failed validation.
final class ValidationFailure extends AppFailure {
  /// A validation failure of [fields].
  const ValidationFailure(this.fields);

  /// The code of each field that failed, by its JSON pointer.
  final Map<String, String> fields;

  @override
  bool operator ==(Object other) =>
      other is ValidationFailure &&
      other.fields.length == fields.length &&
      fields.entries.every((e) => other.fields[e.key] == e.value);

  @override
  int get hashCode => Object.hashAllUnordered(
    fields.entries.map((e) => Object.hash(e.key, e.value)),
  );
}

/// Something could not be saved; the game goes on (RNF-35).
final class PersistenceFailure extends AppFailure {
  /// A local database failure.
  const PersistenceFailure();

  @override
  bool operator ==(Object other) => other is PersistenceFailure;

  @override
  int get hashCode => (PersistenceFailure).hashCode;
}

/// A rule with [code] stopped the use case.
final class RuleFailure extends AppFailure {
  /// A rule failure with [code].
  const RuleFailure(this.code);

  /// Which rule.
  final String code;

  @override
  bool operator ==(Object other) => other is RuleFailure && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// A programming error: the screen shows a generic text, never a stack.
final class UnexpectedFailure extends AppFailure {
  /// An unexpected failure.
  const UnexpectedFailure();

  @override
  bool operator ==(Object other) => other is UnexpectedFailure;

  @override
  int get hashCode => (UnexpectedFailure).hashCode;
}
