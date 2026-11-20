"""Every row of a Markdown table must have as many cells as its header (D-72).

Usage: python3 -I check_tables.py <repo root> [<repo root> ...]

Pipes inside inline code or escaped as \\| do not count as cell separators.
Exits with 1 if a row has the wrong number of cells.
"""
import pathlib
import re
import sys


def cells(line):
    line = re.sub(r"`[^`]*`", "``", line.replace("\\|", ""))
    return line.strip().strip("|").count("|") + 1


def main(roots):
    errors = []
    for root in roots:
        for f in pathlib.Path(root).rglob("*.md"):
            if ".git" in f.parts:
                continue
            lines = f.read_text(encoding="utf-8").splitlines()
            in_code = False
            width = None
            for n, line in enumerate(lines, 1):
                if line.lstrip().startswith("```"):
                    in_code = not in_code
                    continue
                if in_code or not line.lstrip().startswith("|"):
                    width = None
                    continue
                if width is None:
                    width = cells(line)
                elif cells(line) != width:
                    errors.append(f"{f}:{n}: {cells(line)} cells, header has {width}")
    for e in errors:
        print(e)
    if errors:
        return 1
    print("OK: all tables have consistent rows")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
