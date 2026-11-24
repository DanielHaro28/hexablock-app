// Architecture checks of ARQ-01-APP §8 and D-36, run by the CI from the
// repository root: `dart run tool/check_architecture.dart`.
//
// The dependency rule itself is enforced by pub (each package can only import
// what its pubspec declares). This script adds what pub cannot see:
// identifiers in code, forbidden platform APIs, `playTurn` overrides and the
// logger outside the aspects.
import 'dart:convert';
import 'dart:io';

/// Identifiers that only a variant may use (RNF-02, RNF-07).
const _variantIds = [
  'HexaLines',
  'HexaFit',
  'HexaSort',
  'HexaMerge',
  'hexa_variants',
  'hexa-lines',
  'hexa-fit',
  'hexa-sort',
  'hexa-merge',
];

/// Identifiers that only a topology may use (RNF-04).
const _shapeIds = [
  'HexCoord',
  'HexTopology',
  'SquareCoord',
  'TriCoord',
  'CubeCoord',
  'HexBoard',
  'hexa_topologies',
];

/// APIs that layers 1 and 2 cannot use: platform libraries, the system clock
/// and unseeded randomness (ARQ-01-APP §2, RN-COM-43).
final _forbiddenApis = <String, RegExp>{
  'dart:io': RegExp(r'''['"]dart:io['"]'''),
  'dart:ui': RegExp(r'''['"]dart:ui['"]'''),
  'dart:html': RegExp(r'''['"]dart:html['"]'''),
  'dart:ffi': RegExp(r'''['"]dart:ffi['"]'''),
  'package:flutter': RegExp(r'''['"]package:flutter'''),
  'DateTime.now': RegExp(r'(?<![A-Za-z0-9_])DateTime\s*\.\s*now\b'),
  'Random': RegExp(r'(?<![A-Za-z0-9_$])Random\s*[.(]'),
};

/// Packages each layer 1 and 2 package may declare (ARQ-01-APP §3.1).
const _allowedDependencies = <String, Set<String>>{
  'hexa_engine': {},
  'hexa_topologies': {'hexa_engine'},
  'hexa_variants': {'hexa_engine'},
  'hexa_application': {'hexa_engine'},
};

/// Development dependencies allowed in layers 1 and 2: `test`, the shared
/// doubles, and the topologies for the variant tests only.
const _allowedDevDependencies = <String, Set<String>>{
  'hexa_engine': {'test', 'hexa_test_support'},
  'hexa_topologies': {'test', 'hexa_test_support'},
  'hexa_variants': {'test', 'hexa_test_support', 'hexa_topologies'},
  'hexa_application': {'test', 'hexa_test_support'},
};

final _failures = <String>[];

void main() {
  for (final package in _allowedDependencies.keys) {
    _checkPubspec(package);
    for (final file in _dartFiles('packages/$package/lib')) {
      _checkForbiddenApis(file);
    }
  }

  for (final dir in ['packages/hexa_engine/lib', 'packages/hexa_engine/test']) {
    for (final file in _dartFiles(dir)) {
      _checkIdentifiers(file, [..._variantIds, ..._shapeIds], 'RNF-02/RNF-04');
    }
  }
  for (final file in _dartFiles('packages/hexa_application/lib')) {
    _checkIdentifiers(file, [..._variantIds, ..._shapeIds], 'RNF-07');
    _checkLogger(file);
  }
  for (final file in _dartFiles('packages/hexa_variants/lib')) {
    _checkPlayTurn(file);
  }
  _checkArbParity();

  if (_failures.isEmpty) {
    stdout.writeln('OK: architecture rules hold (ARQ-01-APP §8, D-36)');
    return;
  }
  for (final failure in _failures) {
    stderr.writeln('ERROR: $failure');
  }
  exitCode = 1;
}

void _checkIdentifiers(File file, List<String> ids, String rule) {
  final lines = _codeLines(file);
  for (final id in ids) {
    final pattern = id.contains(RegExp('[-_]'))
        ? RegExp('(?<![A-Za-z0-9_-])${RegExp.escape(id)}(?![A-Za-z0-9_-])')
        : RegExp('(?<![A-Za-z0-9])${RegExp.escape(id)}');
    for (final (number, line) in lines.indexed) {
      if (pattern.hasMatch(line)) {
        _fail(file, number, '`$id` cannot appear here ($rule)');
      }
    }
  }
}

void _checkForbiddenApis(File file) {
  for (final (number, line) in _codeLines(file).indexed) {
    for (final MapEntry(key: name, value: pattern) in _forbiddenApis.entries) {
      if (pattern.hasMatch(line)) {
        _fail(file, number, '`$name` is not allowed in layers 1 and 2');
      }
    }
  }
}

/// D-36: `playTurn` is the Template Method; a variant only implements the
/// steps. A name not preceded by `.` is a declaration (or a bare call), and
/// neither belongs in a variant.
void _checkPlayTurn(File file) {
  final declaration = RegExp(r'(?<![.\w])playTurn\s*[(<]');
  for (final (number, line) in _codeLines(file).indexed) {
    if (declaration.hasMatch(line)) {
      _fail(file, number, 'variants must not declare `playTurn` (D-36)');
    }
  }
}

/// RNF-10: only the aspects log. `ILogger` is declared among the ports and
/// used by the aspects; a use case that mentions it is logging by itself.
void _checkLogger(File file) {
  final path = _slash(file.path);
  if (path.contains('/lib/src/aspects/') || path.contains('/lib/src/ports/')) {
    return;
  }
  final logger = RegExp(r'(?<![A-Za-z0-9_])ILogger(?![A-Za-z0-9_])');
  for (final (number, line) in _codeLines(file).indexed) {
    if (logger.hasMatch(line)) {
      _fail(file, number, 'only the aspects may use `ILogger` (RNF-10)');
    }
  }
}

/// Every layer 1 and 2 pubspec only declares the packages it may import.
void _checkPubspec(String package) {
  final pubspec = File('packages/$package/pubspec.yaml');
  final sections = _topLevelKeys(pubspec.readAsLinesSync());
  for (final (section, allowed) in [
    ('dependencies', _allowedDependencies[package]!),
    ('dev_dependencies', _allowedDevDependencies[package]!),
  ]) {
    for (final dependency in sections[section] ?? const <String>[]) {
      if (!allowed.contains(dependency)) {
        _failures.add(
          '${pubspec.path}: `$dependency` is not allowed in $section '
          '(ARQ-01-APP §3.1)',
        );
      }
    }
  }
}

/// RNF-50: every ARB file of a folder has the same keys.
void _checkArbParity() {
  final app = Directory('app');
  if (!app.existsSync()) return;
  final byFolder = <String, Map<String, Set<String>>>{};
  for (final entity in app.listSync(recursive: true)) {
    final path = _slash(entity.path);
    if (entity is! File || !path.endsWith('.arb') || path.contains('/build/')) {
      continue;
    }
    // Only the top-level messages count: the `@key` metadata gen-l10n reads
    // has nested keys (`description`) that are not messages.
    final keys = switch (jsonDecode(entity.readAsStringSync())) {
      final Map<String, Object?> arb =>
        arb.keys.where((key) => !key.startsWith('@')).toSet(),
      _ => <String>{},
    };
    byFolder.putIfAbsent(entity.parent.path, () => {})[path] = keys;
  }
  for (final files in byFolder.values) {
    final all = files.values.expand((keys) => keys).toSet();
    for (final MapEntry(key: path, value: keys) in files.entries) {
      final missing = all.difference(keys);
      if (missing.isNotEmpty) {
        _failures.add('$path: missing keys ${missing.join(', ')} (RNF-50)');
      }
    }
  }
}

/// Keys of each top-level section of a pubspec (two-space indentation).
Map<String, List<String>> _topLevelKeys(List<String> lines) {
  final sections = <String, List<String>>{};
  String? current;
  for (final line in lines) {
    if (line.trim().isEmpty || line.trimLeft().startsWith('#')) continue;
    final top = RegExp(r'^([A-Za-z_]+):').firstMatch(line);
    if (top != null) {
      current = top.group(1);
      continue;
    }
    final child = RegExp(r'^  ([A-Za-z0-9_]+):').firstMatch(line);
    if (current != null && child != null) {
      sections.putIfAbsent(current, () => []).add(child.group(1)!);
    }
  }
  return sections;
}

Iterable<File> _dartFiles(String path) sync* {
  final dir = Directory(path);
  if (!dir.existsSync()) return;
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}

/// The lines of a Dart file with comments blanked out and line numbers kept.
/// String contents are kept: an identifier in a string literal still counts.
List<String> _codeLines(File file) {
  final source = file.readAsStringSync();
  final out = StringBuffer();
  var i = 0;
  String? quote;
  var raw = false;
  while (i < source.length) {
    if (quote != null) {
      if (source.startsWith(quote, i)) {
        out.write(quote);
        i += quote.length;
        quote = null;
      } else if (!raw && source[i] == r'\' && i + 1 < source.length) {
        out.write(source.substring(i, i + 2));
        i += 2;
      } else {
        out.write(source[i]);
        i++;
      }
    } else if (source.startsWith('//', i)) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
    } else if (source.startsWith('/*', i)) {
      final end = source.indexOf('*/', i + 2);
      final comment = source.substring(i, end == -1 ? source.length : end + 2);
      out.write('\n' * '\n'.allMatches(comment).length);
      i += comment.length;
    } else if (source.startsWith("'''", i) || source.startsWith('"""', i)) {
      raw = _isRawPrefix(source, i);
      quote = source.substring(i, i + 3);
      out.write(quote);
      i += 3;
    } else if (source[i] == "'" || source[i] == '"') {
      raw = _isRawPrefix(source, i);
      quote = source[i];
      out.write(quote);
      i++;
    } else {
      out.write(source[i]);
      i++;
    }
  }
  return out.toString().split('\n');
}

/// Whether the string literal starting at [index] is raw (`r'...'`), where a
/// backslash is not an escape.
bool _isRawPrefix(String source, int index) =>
    index > 0 &&
    source[index - 1] == 'r' &&
    (index < 2 || !RegExp('[A-Za-z0-9_\$]').hasMatch(source[index - 2]));

void _fail(File file, int index, String message) {
  _failures.add('${_slash(file.path)}:${index + 1}: $message');
}

String _slash(String path) => path.replaceAll(r'\', '/');
