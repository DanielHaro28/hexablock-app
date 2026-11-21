// Coverage gate of D-58, run by the CI after `flutter test --coverage` in
// every package with tests: `dart run tool/coverage_gate.dart`.
//
// Minimums: domain (layer 1) 90 %, use cases (layer 2) 80 %, whole repo 70 %.
// Generated files (`*.g.dart`, Drift) do not count.
import 'dart:io';

const _domain = ['hexa_engine', 'hexa_topologies', 'hexa_variants'];
const _application = ['hexa_application'];

/// Folders whose `lib/` counts towards the total. `hexa_test_support` is test
/// code, so it is left out.
const _counted = [..._domain, ..._application, 'app'];

void main() {
  final failures = <String>[];
  final totals = <String, (int, int)>{};
  for (final name in _counted) {
    final dir = name == 'app' ? 'app' : 'packages/$name';
    final report = File('$dir/coverage/lcov.info');
    if (!report.existsSync()) {
      if (_hasImplementation(dir)) {
        failures.add('$dir has code in lib/src/ but no coverage report');
      }
      continue;
    }
    totals[name] = _linesOf(report);
  }

  for (final (label, names, minimum) in [
    ('Domain (layer 1)', _domain, 90),
    ('Use cases (layer 2)', _application, 80),
    ('Total', _counted, 70),
  ]) {
    var found = 0;
    var hit = 0;
    for (final name in names) {
      final (f, h) = totals[name] ?? (0, 0);
      found += f;
      hit += h;
    }
    if (found == 0) {
      stdout.writeln('$label: no executable lines yet');
      continue;
    }
    final percent = 100 * hit / found;
    stdout.writeln(
      '$label: ${percent.toStringAsFixed(1)} % ($hit/$found), '
      'minimum $minimum %',
    );
    if (percent < minimum) {
      failures.add('$label coverage is below $minimum %');
    }
  }

  for (final failure in failures) {
    stderr.writeln('ERROR: $failure (D-58)');
  }
  if (failures.isNotEmpty) exitCode = 1;
}

/// Lines found and lines hit in an LCOV report, skipping generated files.
(int, int) _linesOf(File report) {
  var found = 0;
  var hit = 0;
  var skip = false;
  for (final line in report.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      skip = line.endsWith('.g.dart');
    } else if (line.startsWith('DA:') && !skip) {
      found++;
      if (!line.endsWith(',0')) hit++;
    }
  }
  return (found, hit);
}

/// Whether a package already has implementation files (beyond its library
/// file), so a missing report means its tests were not run.
bool _hasImplementation(String dir) {
  final src = Directory('$dir/lib/src');
  final lib = Directory('$dir/lib');
  if (dir == 'app') {
    return lib.existsSync() &&
        lib.listSync(recursive: true).any((e) => e.path.endsWith('.dart'));
  }
  return src.existsSync() &&
      src.listSync(recursive: true).any((e) => e.path.endsWith('.dart'));
}
