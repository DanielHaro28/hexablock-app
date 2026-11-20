"""The shared documents and the contract must be identical in both repos (D-23, D-72).

Usage: python3 -I check_shared.py <hexablock-app root> <hexablock-api root>

Exits with 1 if a shared file differs or is missing in one of the repos.
"""
import pathlib
import sys

SHARED = [
    "docs/adr/ADR-001-tech-stack.md",
    "docs/architecture/ARQ-00-SISTEMA.md",
    "docs/security/SECURITY-BASELINE.md",
    "docs/requirements/01-GLOSARIO.md",
    "docs/requirements/02-RN-NIVELES.md",
    "docs/requirements/02-RN-CUENTA-PROGRESO-RANKING.md",
    "docs/ai/APPROVED-TOOLS.md",
]
CONTRACT_DIR = "docs/contracts"


def main(app, api):
    app, api = pathlib.Path(app), pathlib.Path(api)
    files = list(SHARED)
    for root in (app, api):
        base = root / CONTRACT_DIR
        files += [str(p.relative_to(root)) for p in base.rglob("*") if p.is_file()]
    errors = []
    for rel in sorted(set(files)):
        a, b = app / rel, api / rel
        if not a.exists() or not b.exists():
            errors.append(f"missing in {'hexablock-app' if not a.exists() else 'hexablock-api'}: {rel}")
        elif a.read_bytes() != b.read_bytes():
            errors.append(f"differs: {rel}")
    for e in errors:
        print(e)
    if errors:
        return 1
    print(f"OK: {len(set(files))} shared files identical")
    return 0


if __name__ == "__main__":
    sys.exit(main(*sys.argv[1:3]))
