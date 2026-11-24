"""Print the next free ID with a given prefix (IA, D, RN-HL...) across repos.

IDs are never reused (CLAUDE.md, rule 6), and each member adds entries on their
own branch, so the highest ID on `main` is rarely the highest one in use. This
script looks at every local and remote-tracking branch of each repo, plus the
uncommitted and untracked files of the working tree, and prints the next number
after the highest one it finds. It does not fetch: run `git fetch` first so the
remote-tracking branches are current.

Only Markdown files outside `.claude/` count: that is where IDs are defined.
Code, test data and agent configuration (a skill's example, an eval case with
`IA-06`) must not move the numbering.

Usage, from the folder that holds both clones:

    python3 -I hexablock-app/tools/docs-check/next_id.py IA hexablock-app hexablock-api

It prints the ID (for example `IA-56`) on stdout, and on stderr where it found
the highest one.
"""

import re
import subprocess
import sys

PREFIX = re.compile(r"[A-Z]+(?:-[A-Z]+)*")


def git(repo, *args):
    return subprocess.run(
        ["git", "-C", repo, *args],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )


def refs(repo):
    out = git(repo, "for-each-ref", "--format=%(refname)", "refs/heads", "refs/remotes")
    return [ref for ref in out.stdout.split() if not ref.endswith("/HEAD")]


def grep(repo, prefix, ref=None):
    """Lines that mention `prefix-<digits>` in `ref`, or in the working tree."""
    args = ["grep", "-I", "-h", "-E", "-e", f"{prefix}-[0-9]"]
    args += [ref] if ref else ["--untracked"]
    out = git(repo, *args, "--", "*.md", ":!.claude/")
    if out.returncode not in (0, 1):  # 1 means no match
        raise RuntimeError(out.stderr.strip())
    return out.stdout.splitlines()


def numbers(line, pattern):
    """Every number of the prefix in a line, including the end of a range."""
    for match in pattern.finditer(line):
        yield match.group(1)
        if match.group(2):
            yield match.group(2)


def main(argv):
    if len(argv) < 3 or not PREFIX.fullmatch(argv[1]):
        print(__doc__.strip().splitlines()[0], file=sys.stderr)
        print("usage: next_id.py PREFIX REPO [REPO...]  (PREFIX like IA, D or RN-HL)", file=sys.stderr)
        return 2
    prefix, repos = argv[1], argv[2:]
    # Not preceded by a letter, digit or hyphen, so that `D` does not match
    # `RN-HD-40` or `E-D-60`. A range (`D-110..115`, `D-120–123`) counts its end.
    pattern = re.compile(
        rf"(?<![A-Za-z0-9-]){re.escape(prefix)}-(\d+)(?:\s*(?:\.\.|–)\s*(\d+))?"
    )

    best, best_digits, where = 0, "", "nowhere"
    for repo in repos:
        if git(repo, "rev-parse", "--git-dir").returncode != 0:
            print(f"error: {repo} is not a git repository", file=sys.stderr)
            return 1
        for ref in [None, *refs(repo)]:
            for line in grep(repo, prefix, ref):
                for digits in numbers(line, pattern):
                    if int(digits) > best:
                        best, best_digits = int(digits), digits
                        where = f"{repo} {ref or 'working tree'}"

    width = len(best_digits) if best_digits else 2
    print(f"{prefix}-{str(best + 1).zfill(width)}")
    if best:
        print(f"highest: {prefix}-{best_digits} in {where}", file=sys.stderr)
    else:
        print(f"no {prefix}-* found", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
