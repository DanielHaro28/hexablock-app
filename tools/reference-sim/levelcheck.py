"""Checks the bundled levels (app/assets/levels) and writes their catalog for team review.

Usage:  python3 -I tools/reference-sim/levelcheck.py            (from the repo root)
Needs:  jsonschema >= 4.18 (same as docs/contracts/check_contracts.py)

1. Every level validates against docs/contracts/schemas/level.schema.json.
2. Hexa Fit: RN-HF-12 a-g, the reference solution is valid, the number of solutions fits the
   tier (D-54) and the search effort grows from one level to the next.
3. Hexa Sort: RN-HS-12, the greedy bot wins (D-55) and its moves grow from one level to the next;
   levels 1-6 use topology 'any' without stacks and 7-10 use hex with stacks (D-28).
4. Ids, order and file names match (D-47); 15 Fit and 10 Sort levels (enunciado §5.1).
5. Contract examples with the same id are identical to the real level, and the stars in
   E-COM-2 and E-COM-3 are possible with the thresholds of the real levels (RN-HF-62).
6. Writes docs/levels/CATALOGO.md with a drawing of each level (outside assets/, so it is not in the APK).
"""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from hexsim import hexagon, render  # noqa: E402
from levelkit import fit_solve, sort_play  # noqa: E402
from jsonschema import Draft202012Validator  # noqa: E402
from referencing import Registry, Resource  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
LEVELS = ROOT / "app/assets/levels"
CONTRACTS = ROOT / "docs/contracts"
FIT_MAX_SOLUTIONS = [99, 99, 99, 40, 30, 20, 12, 10, 8, 6, 6, 4, 4, 4, 4]
errors = []


def fail(msg):
    errors.append(msg)
    print("FAIL", msg)


def load(p):
    return json.loads(p.read_text(encoding="utf-8"))


schemas = [load(f) for f in (CONTRACTS / "schemas").glob("*.schema.json")]
registry = Registry().with_resources((s["$id"], Resource.from_contents(s)) for s in schemas)
level_schema = next(s for s in schemas if s["$id"].endswith("/level.schema.json"))
validator = Draft202012Validator(level_schema, registry=registry)

fit = [load(f) for f in sorted((LEVELS / "hexa-fit").glob("*.json"))]
sort = [load(f) for f in sorted((LEVELS / "hexa-sort").glob("*.json"))]
if len(fit) != 15 or len(sort) != 10:
    fail(f"expected 15 Fit and 10 Sort levels, found {len(fit)} and {len(sort)}")

for f in sorted(LEVELS.glob("hexa-*/*.json")):
    lvl = load(f)
    for e in validator.iter_errors(lvl):
        fail(f"{f.name}: {e.json_path}: {e.message}")
    if f.stem != lvl["id"]:
        fail(f"{f.name}: file name differs from id {lvl['id']}")

# ---------- Hexa Fit ----------
fit_rows, prev = [], 0
for i, lvl in enumerate(sorted(fit, key=lambda l: l["order"])):
    v = lvl["variant"]
    if lvl["order"] != i + 1 or lvl["id"] != f"fit-hex-{i + 1:03d}":
        fail(f"{lvl['id']}: order/id out of sequence")
    figure = {tuple(c) for c in v["figure"]}
    sizes = [len(p["shape"]) for p in v["pieces"]]
    used = [tuple(c) for cells in v["solution"].values() for c in cells]
    if sum(sizes) != len(figure): fail(f"{lvl['id']}: RN-HF-12 a (areas)")
    if set(used) != figure or len(used) != len(set(used)): fail(f"{lvl['id']}: RN-HF-12 d (solution covers the figure)")
    if v["starThresholds"]["moves"] < len(sizes): fail(f"{lvl['id']}: RN-HF-63 (m >= pieces)")
    if v["starThresholds"] != {"moves": len(sizes) + 1, "timeMs": 20000 * len(sizes)}:
        fail(f"{lvl['id']}: thresholds differ from D-54")
    st = fit_solve(lvl, cap=1000)
    if not st["reference_ok"]: fail(f"{lvl['id']}: RN-HF-12 f (reference solution is not a rotation of the pieces)")
    if st["solutions"] > FIT_MAX_SOLUTIONS[i]: fail(f"{lvl['id']}: {st['solutions']} solutions, tier allows {FIT_MAX_SOLUTIONS[i]}")
    if st["nodes"] <= prev: fail(f"{lvl['id']}: search effort {st['nodes']} does not grow (previous {prev})")
    prev = st["nodes"]
    fit_rows.append((lvl, st))

# ---------- Hexa Sort ----------
sort_rows, prev = [], 0
board = set(hexagon(2))
for i, lvl in enumerate(sorted(sort, key=lambda l: l["order"])):
    v = lvl["variant"]
    expected_topology = "any" if i < 6 else "hex"
    if lvl["topology"] != expected_topology or lvl["id"] != f"sort-{expected_topology}-{i + 1:03d}":
        fail(f"{lvl['id']}: topology or id does not follow D-28")
    stacks = v.get("initialStacks", [])
    if (i < 6) == bool(stacks): fail(f"{lvl['id']}: initial stacks do not follow D-28")
    for s in stacks:
        top = s["stack"][-1]; run = 0
        for c in reversed(s["stack"]):
            if c != top: break
            run += 1
        if tuple(s["cell"]) not in board or not set(s["stack"]) <= set(v["palette"]) or run >= 10:
            fail(f"{lvl['id']}: RN-HS-12 (initial stack {s['cell']})")
    if len(stacks) >= len(board): fail(f"{lvl['id']}: RN-HS-12 (no empty cell)")
    g = sort_play(lvl, beam=1, max_moves=300)
    b = sort_play(lvl, beam=30, max_moves=300)
    if not g["won"]: fail(f"{lvl['id']}: the greedy bot does not win (D-55)")
    elif g["moves"] <= prev: fail(f"{lvl['id']}: greedy moves {g['moves']} do not grow (previous {prev})")
    prev = g.get("moves", prev)
    sort_rows.append((lvl, g, b))

# ---------- contract examples ----------
ex = CONTRACTS / "examples"
by_id = {l["id"]: l for l in fit + sort}
for f in ex.glob("*.level.json"):
    e = load(f)
    if e["id"] in by_id and e != by_id[e["id"]]:
        fail(f"{f.name}: differs from the real level {e['id']}")


def stars(level, moves, time_ms):
    t = level["variant"]["starThresholds"]
    return 1 + (moves <= t["moves"]) + (time_ms <= t["timeMs"])


for f in list(ex.glob("E-COM-2.*.progress.json")) + [ex / "sync.progress-update.json"]:
    for lid, a in load(f)["sections"]["hex"]["levels"].items():
        if stars(by_id[lid], a["moves"], a["timeMs"]) != a["stars"]:
            fail(f"{f.name}: {lid} has {a['stars']} stars, impossible with its thresholds")
lb = load(ex / "E-COM-3.fit-level.leaderboard.json")
for e in lb["entries"]:
    if stars(by_id[lb["levelId"]], e["moves"], e["timeMs"]) != e["stars"]:
        fail(f"E-COM-3 fit: {e['displayName']} has impossible stars")
lb = load(ex / "E-COM-3.sort-level.leaderboard.json")
goals = by_id[lb["levelId"]]["variant"]["goals"]
for e in lb["entries"]:
    if e["score"] < 100 * goals + goals:
        fail(f"E-COM-3 sort: {e['displayName']} has an impossible score for {goals} goals")

# ---------- catalog ----------
out = ["# Catálogo de niveles", "",
       "Generado por `tools/reference-sim/levelcheck.py`; no se edita a mano. **Estado: candidatos** propuestos por el generador (D-53) que el equipo debe jugar, ajustar y aprobar, y que esperan la respuesta del profesor (P-14).", "",
       "## Hexa Fit (15, hexágonos)", "",
       "| # | Id | Nombre | Piezas | Celdas | Soluciones | Esfuerzo (nodos) | `m` | `t` |", "|---|---|---|---|---|---|---|---|---|"]
for lvl, st in fit_rows:
    v = lvl["variant"]
    out.append(f"| {lvl['order']} | `{lvl['id']}` | {lvl['name']['es']} / {lvl['name']['en']} | {st['pieces']} | {st['cells']} | {st['solutions']} | {st['nodes']} | {v['starThresholds']['moves']} | {v['starThresholds']['timeMs'] // 1000} s |")
out += ["", "## Hexa Sort (10)", "",
        "| # | Id | Nombre | Figura | Metas | Colores | Pilas iniciales | Voraz | Haz de 30 |", "|---|---|---|---|---|---|---|---|---|"]
for lvl, g, b in sort_rows:
    v = lvl["variant"]
    out.append(f"| {lvl['order']} | `{lvl['id']}` | {lvl['name']['es']} / {lvl['name']['en']} | {lvl['topology']} | {v['goals']} | {len(v['palette'])} | {len(v.get('initialStacks', []))} | {g['moves']} mov., {g.get('score', '-')} pts | {b['moves']} mov. |")
out += ["", "La columna **Voraz** es lo que logra un jugador que elige siempre la mejor jugada inmediata; **Haz de 30** mira varias jugadas adelante. Las dos ganan todos los niveles. Verificado solo en hexágonos; los niveles `any` se prueban en las otras figuras cuando cada una esté implementada.", "",
        "## Figuras de Hexa Fit", "",
        "Cada letra es la pieza que cubre esa celda en la solución de referencia. El jugador ve la figura vacía y las piezas en la bandeja, cada una en otra orientación.", ""]
for lvl, st in fit_rows:
    content = {tuple(c): pid for pid, cells in lvl["variant"]["solution"].items() for c in cells}
    out += [f"### {lvl['order']}. {lvl['name']['es']} (`{lvl['id']}`)", "", "```", render(set(content), content), "```", ""]
(ROOT / "docs/levels").mkdir(parents=True, exist_ok=True)
(ROOT / "docs/levels/CATALOGO.md").write_text("\n".join(out), encoding="utf-8")

print(f"Fit: {len(fit_rows)} levels, Sort: {len(sort_rows)} levels")
print("OK" if not errors else f"{len(errors)} FAILURES")
sys.exit(1 if errors else 0)
