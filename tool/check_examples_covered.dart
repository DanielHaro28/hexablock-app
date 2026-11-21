// Traceability check of ESTRATEGIA-PRUEBAS §6, run by the CI:
// `dart run tool/check_examples_covered.dart`.
//
// Every rule example (`E-*`) in docs/requirements/02-RN-*.md needs a test
// whose `group` carries its ID. Examples whose story is not built yet are
// listed in tool/examples_pending.txt; the list may only shrink, and it must
// be empty at delivery.
import 'dart:io';

final _exampleId = RegExp(r'(?<![A-Za-z0-9-])E-[A-Z]+-\d+(?![0-9])');
final _groupId = RegExp(r'''group\(\s*['"](E-[A-Z]+-\d+)(?![0-9])''');

void main() {
  final documented = <String>{};
  for (final entity in Directory('docs/requirements').listSync()) {
    final name = entity.uri.pathSegments.last;
    if (entity is File && name.startsWith('02-RN-') && name.endsWith('.md')) {
      documented.addAll(
        _exampleId.allMatches(entity.readAsStringSync()).map((m) => m[0]!),
      );
    }
  }

  final tested = <String>{};
  for (final dir in [
    Directory('app/test'),
    ...Directory('packages').listSync().whereType<Directory>().map(
      (package) => Directory('${package.path}/test'),
    ),
  ]) {
    if (!dir.existsSync()) continue;
    for (final file in dir.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('_test.dart')) continue;
      tested.addAll(
        _groupId.allMatches(file.readAsStringSync()).map((m) => m[1]!),
      );
    }
  }

  final pendingFile = File('tool/examples_pending.txt');
  final pending = pendingFile
      .readAsLinesSync()
      .map((line) => line.split('#').first.trim())
      .where((line) => line.isNotEmpty)
      .toSet();

  final failures = <String>[
    for (final id in documented.difference(tested).difference(pending))
      '$id has no test with its ID in a group, and is not pending',
    for (final id in pending.intersection(tested))
      '$id is tested now: remove it from ${pendingFile.path}',
    for (final id in pending.difference(documented))
      '$id is pending but no rule document defines it',
  ]..sort();

  final covered = documented.intersection(tested).length;
  stdout.writeln(
    'Examples: ${documented.length} documented, $covered tested, '
    '${pending.length} pending',
  );
  for (final failure in failures) {
    stderr.writeln('ERROR: $failure');
  }
  if (failures.isNotEmpty) exitCode = 1;
}
