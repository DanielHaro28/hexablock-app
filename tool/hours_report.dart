// Real hours against the estimate, per Issue (D-128, D-62), for the
// milestone review: `dart run tool/hours_report.dart [M1]` from the repo root.
// It needs `gh` signed in with read access to both repos.
//
// - Estimate: the Issue tables of `docs/plan/PLAN-ENTREGA.md` §5, one section
//   per milestone (`### M1 · …`). The optional argument keeps one section.
// - Real hours: the `- Real hours: <n>` line of every merged PR of the repos
//   that the plan links (D-128), given to each Issue the PR cites with
//   `Closes`, `Fixes` or `Refs` (`#n` or `owner/repo#n`). The PRs of a stacked
//   story add up (D-137).
//
// It prints Markdown: one table per milestone, the totals per person and the
// PRs with hours that cite no Issue of the plan.
import 'dart:convert';
import 'dart:io';

const _plan = 'docs/plan/PLAN-ENTREGA.md';

/// The `- Real hours: <n>` line of the PR template (D-128, D-169).
final _hoursLine = RegExp(
  r'^\s*[-*]?\s*Real hours:\s*([0-9]+(?:[.,][0-9]+)?)\s*h?\s*$',
  multiLine: true,
);
final _issueRef = RegExp(
  r'\b(?:close[sd]?|fix(?:e[sd])?|resolve[sd]?|refs?)\s+((?:[\w.-]+/[\w.-]+)?)#(\d+)',
  caseSensitive: false,
);
final _section = RegExp(r'^###\s+(.+)$');
final _row = RegExp(
  r'^\|\s*\[(?:app|api) #(\d+)\]\(https://github\.com/([\w.-]+/[\w.-]+)/issues/\d+\)'
  r'\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([0-9.]+)\s*\|',
);

/// An Issue of the plan, keyed by `owner/repo#n`.
final class _Issue {
  _Issue(this.key, this.milestone, this.title, this.owner, this.estimate);

  final String key;
  final String milestone;
  final String title;
  final String owner;
  final double estimate;
  double real = 0;
  final List<String> withHours = [];
  final List<String> withoutHours = [];
}

void main(List<String> args) {
  final only = args.isEmpty ? null : args.first;
  final issues = _readPlan(only);
  if (issues.isEmpty) {
    stderr.writeln(
      'No Issues found in $_plan${only == null ? '' : ' for $only'}.',
    );
    exitCode = 1;
    return;
  }

  final unplanned = <String>[];
  final repos = {for (final issue in issues.values) issue.key.split('#').first};
  for (final repo in repos) {
    for (final pr in _mergedPullRequests(repo)) {
      final body = (pr['body'] as String? ?? '').replaceAll('\r', '');
      final match = _hoursLine.firstMatch(body);
      final hours = match == null
          ? null
          : double.parse(match.group(1)!.replaceAll(',', '.'));
      final name = '$repo#${pr['number']}';
      final cited = {
        for (final ref in _issueRef.allMatches(body))
          '${ref.group(1)!.isEmpty ? repo : ref.group(1)!}#${ref.group(2)}',
      }.where(issues.containsKey).toList();
      if (cited.isEmpty) {
        if (hours != null) unplanned.add('${_label(name)} (${_fmt(hours)} h)');
        continue;
      }
      for (final key in cited) {
        final issue = issues[key]!;
        if (hours == null) {
          issue.withoutHours.add(name);
        } else {
          // A PR that cites several Issues splits its hours evenly.
          issue
            ..real += hours / cited.length
            ..withHours.add(name);
        }
      }
    }
  }
  _print(issues.values.toList(), unplanned);
}

Map<String, _Issue> _readPlan(String? only) {
  final issues = <String, _Issue>{};
  String? milestone;
  for (final line in File(_plan).readAsLinesSync()) {
    final section = _section.firstMatch(line);
    if (section != null) {
      milestone = section.group(1);
      continue;
    }
    final row = _row.firstMatch(line);
    if (row == null || milestone == null) continue;
    if (only != null && !milestone.startsWith(only)) continue;
    final key = '${row.group(2)}#${row.group(1)}';
    issues[key] = _Issue(
      key,
      milestone,
      row.group(3)!,
      row.group(4)!,
      double.parse(row.group(5)!),
    );
  }
  return issues;
}

List<Map<String, Object?>> _mergedPullRequests(String repo) {
  final result = Process.runSync('gh', [
    'pr',
    'list',
    '--repo',
    repo,
    '--state',
    'merged',
    '--limit',
    '1000',
    '--json',
    'number,body',
  ], runInShell: Platform.isWindows);
  if (result.exitCode != 0) {
    stderr.writeln('gh failed for $repo: ${result.stderr}');
    exit(1);
  }
  return (jsonDecode(result.stdout as String) as List<Object?>)
      .cast<Map<String, Object?>>();
}

void _print(List<_Issue> issues, List<String> unplanned) {
  final out = StringBuffer();
  final byMilestone = <String, List<_Issue>>{};
  for (final issue in issues) {
    (byMilestone[issue.milestone] ??= []).add(issue);
  }
  for (final MapEntry(key: milestone, value: rows) in byMilestone.entries) {
    out
      ..writeln('## $milestone')
      ..writeln()
      ..writeln('| Issue | Título | Responsable | Estimación | Real | PR |')
      ..writeln('|---|---|---|---|---|---|');
    for (final issue in rows) {
      final real = issue.withHours.isEmpty ? '—' : _fmt(issue.real);
      final prs = [
        ...issue.withHours.map(_label),
        for (final pr in issue.withoutHours) '${_label(pr)} (sin horas)',
      ].join(', ');
      out.writeln(
        '| ${_label(issue.key)} | ${issue.title} | ${issue.owner} | '
        '${_fmt(issue.estimate)} | $real | ${prs.isEmpty ? '—' : prs} |',
      );
    }
    out.writeln();
  }

  // Only the Issues with real hours count, so the comparison is fair.
  final people = <String, (double, double)>{};
  for (final issue in issues.where((issue) => issue.withHours.isNotEmpty)) {
    final (estimate, real) = people[issue.owner] ?? (0, 0);
    people[issue.owner] = (estimate + issue.estimate, real + issue.real);
  }
  out
    ..writeln('## Por persona (solo los Issues con horas reales)')
    ..writeln()
    ..writeln('| Responsable | Estimación | Real | Real / estimación |')
    ..writeln('|---|---|---|---|');
  for (final MapEntry(key: owner, value: (estimate, real)) in people.entries) {
    final ratio = estimate == 0 ? '—' : (real / estimate).toStringAsFixed(2);
    out.writeln('| $owner | ${_fmt(estimate)} | ${_fmt(real)} | $ratio |');
  }
  if (unplanned.isNotEmpty) {
    out
      ..writeln()
      ..writeln(
        'PR con horas que no citan un Issue del plan: ${unplanned.join(', ')}',
      );
  }
  stdout.write(out);
}

String _fmt(double hours) => hours == hours.roundToDouble()
    ? '${hours.round()}'
    : hours.toStringAsFixed(1);

/// `owner/hexablock-app#24` → `app #24`, shorter in the table.
String _label(String key) => key
    .replaceFirst(RegExp(r'^[\w.-]+/hexablock-'), '')
    .replaceFirst('#', ' #');
