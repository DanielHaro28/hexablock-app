"""No tracked file may be larger than 1 MB, except the ones listed here (D-73).

Usage: python3 -I check_binaries.py <repo root> [<repo root> ...]

Exits with 1 if a tracked file is larger than the limit and is not allowed.
"""
import pathlib
import subprocess
import sys

LIMIT = 1024 * 1024
# Already in the history before D-73; removing it would not shrink the repo.
ALLOWED = {"docs/design/HexaBlock-Suite-Diseno-v1.pdf"}


def main(roots):
    errors = []
    for root in roots:
        files = subprocess.run(
            ["git", "-C", root, "ls-files", "-z"], capture_output=True, check=True
        ).stdout.decode().split("\0")
        for rel in filter(None, files):
            size = (pathlib.Path(root) / rel).stat().st_size
            if size > LIMIT and rel not in ALLOWED:
                errors.append(f"{root}/{rel}: {size / LIMIT:.1f} MB (limit 1 MB, D-73)")
    for e in errors:
        print(e)
    if errors:
        return 1
    print("OK: no tracked file over 1 MB")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
