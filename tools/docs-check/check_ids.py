"""Every ID cited in the docs must be defined somewhere (D-72).

Usage: python3 -I check_ids.py <repo root> [<repo root> ...]

An ID is defined by a table row that starts with it ("| RN-HS-21 |",
"| ☐ D-03 |", "| RN-HS-60 a 64 |"), by a heading ("### NAV-01 · ..."),
by a bold example label ("**E-HS-GEN**") or, for tasks, by a row of the
Issue tables in docs/plan/PLAN-ENTREGA.md ("| [app #77](...) | R-03 · ...")
or of the table in PENDIENTES.md §3 that says where each task went
("| G-03, G-05 a G-07 | ... |").
Pass both repos so that IDs defined in one and cited in the other resolve.
Exits with 1 if an ID is cited but not defined.
"""
import collections
import json
import pathlib
import re
import sys

# The prefix of each variant's rules and stories (RN-HL-*, HL-*) comes from the
# registry of variants of the team's tools, so a fifth variant only adds itself
# there (D-130).
VARIANTS = json.loads(
    (pathlib.Path(__file__).resolve().parent.parent / "variants.json").read_text(encoding="utf-8")
)["variants"]
PREFIXES = "|".join(re.escape(v["prefix"]) for v in VARIANTS)
ID = (
    r"(?:RN-(?:COM|TOP|HEX|TRI|SQR|CUB|" + PREFIXES + r")-\d+|RF-\d+|RNF-\d+"
    r"|(?:NAV|" + PREFIXES + r"|PRG|API|LVL|TEC)-\d+|E-[A-Z]+-(?:\d+|NIVEL|GEN)"
    r"|SEC-(?:API|WEB|MOB|AGT)-\d+|ARQ-[SAB]-\d+|DIS-\d+|IA-\d+|[DGAWFRPT]-\d+)"
)
# Not preceded by a letter, digit or hyphen, so "IA-05" is not read as "A-05"
# and "RN-HS-21" is not read as "S-21".
CITE = re.compile(r"(?<![A-Za-z0-9-])" + ID + r"(?![0-9])")
ROW = re.compile(r"\|\s*(?:☐ |☑ )?(" + ID + r")\s*\|")
RANGE_ROW = re.compile(r"\|\s*(RN-[A-Z]+-\d+) (?:a|y) (\d+)\s*\|")
HEADING = re.compile(r"#{2,4}\s+(" + ID + r")\b")
EXAMPLE = re.compile(r"\*\*(?:Ejemplo |Nivel de ejemplo )?(E-[A-Z]+-(?:\d+|NIVEL|GEN))")
ID_LIST_CELL = re.compile(r"\|\s*((?:" + ID + r")(?:(?:, | a | y )(?:" + ID + r"))*)\s*\|")
ISSUE_ROW = re.compile(r"\|\s*\[(?:app|api) #\d+\]\([^)]*\)\s*\|\s*(" + ID + r") ·")


# Folders that are not the project's documents: git data and the npm
# packages of a local install, whose READMEs cite things like "R-7".
SKIPPED = {".git", "node_modules"}


def main(roots):
    files = [
        f
        for r in roots
        for f in pathlib.Path(r).rglob("*.md")
        if not SKIPPED.intersection(f.parts)
    ]
    defs = collections.defaultdict(set)
    cites = collections.defaultdict(set)
    for f in files:
        text = f.read_text(encoding="utf-8")
        for line in text.splitlines():
            for rx in (ROW, HEADING, ISSUE_ROW):
                m = rx.match(line.strip()) if rx is not ROW else rx.match(line)
                if m:
                    defs[m.group(1)].add(f.name)
            m = ID_LIST_CELL.match(line)
            if m and f.name == "PENDIENTES.md":
                for part in re.split(r", | y ", m.group(1)):
                    if " a " in part:
                        a, b = part.split(" a ")
                        prefix, first = a.rsplit("-", 1)
                        last = b.rsplit("-", 1)[1]
                        for n in range(int(first), int(last) + 1):
                            defs[f"{prefix}-{n:0{len(first)}d}"].add(f.name)
                    else:
                        defs[part].add(f.name)
            m = RANGE_ROW.match(line)
            if m:
                prefix, first = m.group(1).rsplit("-", 1)
                for n in range(int(first), int(m.group(2)) + 1):
                    defs[f"{prefix}-{n}"].add(f.name)
            for m in EXAMPLE.finditer(line):
                defs[m.group(1)].add(f.name)
        for m in CITE.finditer(text):
            cites[m.group(0)].add(f.name)
    undefined = sorted(k for k in cites if k not in defs)
    if undefined:
        print("Cited but not defined:")
        for k in undefined:
            print(f"  {k} <- {sorted(cites[k])[:4]}")
        return 1
    print(f"OK: {len(cites)} IDs cited, all defined")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
