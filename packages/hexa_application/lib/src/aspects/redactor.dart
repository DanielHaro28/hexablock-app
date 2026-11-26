/// Hides passwords, tokens and e-mails before anything is logged
/// (SEC-WEB-06).
///
/// - A value whose key names a secret becomes [mask]. The key is compared
///   in lower case and without `_`, `-` or spaces, and a part of it is
///   enough: `pass` covers `password` and `passphrase`, `auth` covers
///   `Authorization`, `apikey` covers `api_key`. It may hide more than
///   needed; it never hides less.
/// - In any other text, and in the keys of a map, an e-mail address, a JWT,
///   the token after `Bearer` and the value after a secret field name (as
///   in `password: x` or `token=x`, the way a record or an object prints
///   itself) become [mask].
/// - Maps and lists are redacted inside; any other object is logged as its
///   redacted text, since its `toString` may hold a secret.
/// - Numbers, flags and `null` stay as they are.
final class Redactor {
  /// A redactor.
  const Redactor();

  /// What a secret becomes.
  static const mask = '***';

  static const _secretKeys = [
    'pass',
    'pwd',
    'token',
    'secret',
    'auth',
    'jwt',
    'bearer',
    'cookie',
    'session',
    'credential',
    'apikey',
    'refresh',
    'mail',
  ];

  static final _keySeparators = RegExp(r'[_\-\s]');
  static final _jwt = RegExp(r'eyJ[\w-]+\.[\w-]+\.[\w-]*');
  static final _bearer = RegExp(
    r'\b(Bearer)\s+[^\s,;)\]}]+',
    caseSensitive: false,
  );
  static final _email = RegExp(r'[\w.+-]+@[\w-]+(?:\.[\w-]+)+');
  static final _secretField = RegExp(
    r'''\b(\w*(?:pass|pwd|token|secret|auth|jwt|cookie|credential|api_?key|refresh)\w*)(\s*[:=]\s*)("[^"]*"|'[^']*'|[^\s,;)\]}]+)''',
    caseSensitive: false,
  );

  /// [data] with its secrets replaced by [mask]; [data] is not changed.
  Map<String, Object?> redact(Map<String, Object?> data) => {
    for (final MapEntry(:key, :value) in data.entries)
      redactText(key): _isSecret(key) ? mask : _value(value),
  };

  /// [text] with its e-mails, tokens and secret fields replaced by [mask].
  String redactText(String text) => text
      .replaceAll(_jwt, mask)
      .replaceAllMapped(_bearer, (match) => '${match[1]} $mask')
      .replaceAll(_email, mask)
      .replaceAllMapped(_secretField, (match) => '${match[1]}${match[2]}$mask');

  Object? _value(Object? value) => switch (value) {
    null || num() || bool() => value,
    String() => redactText(value),
    Map<String, Object?>() => redact(value),
    Map() => redact({
      for (final MapEntry(:key, :value) in value.entries) '$key': value,
    }),
    Iterable() => [for (final item in value) _value(item)],
    _ => redactText('$value'),
  };

  static bool _isSecret(String key) {
    final normalized = key.toLowerCase().replaceAll(_keySeparators, '');
    return _secretKeys.any(normalized.contains);
  }
}
