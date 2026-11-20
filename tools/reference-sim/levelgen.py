"""Level generator: an author tool for Step 6 (D-53, option B). It is NOT part of the app.

It proposes candidate levels that follow the approved curves (D-54 for Hexa Fit, D-55 for
Hexa Sort) and the split per topology (D-28). The team picks, plays, adjusts and names them;
only the final JSON files go into the APK (app/assets/levels/). Output is reproducible: the same
master seed always gives the same candidates.

Usage:
  python3 -I tools/reference-sim/levelgen.py app/assets/levels  # writes 15 Fit + 10 Sort files
  python3 -I tools/reference-sim/levelgen.py app/assets/levels --seed N  # another set of candidates

Hexa Fit: the figure is built by gluing pieces together, so a solution is known from the start;
levelkit.fit_solve counts every solution and measures the search effort, and the candidate is
kept only if it fits its tier (number of solutions) and is harder than the previous level.
Hexa Sort: searches seeds that the greedy bot wins (D-55 acceptance rule) close to the median
number of moves of its tier, and harder than the previous level.
"""
import json
import pathlib
import random
import statistics
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from hexsim import NEIGH, hexagon, normalize, orientations  # noqa: E402
from levelkit import fit_solve, sort_play, tray_sequence  # noqa: E402

COLORS = ["red", "orange", "yellow", "green", "teal", "blue", "purple", "pink"]

# ------------------------------------------------------------------ Hexa Fit (D-54)
# (pieces, cells, max solutions); tiers 1-3, 4-7, 8-11, 12-15
FIT_PLAN = [
    (2, 6, 99), (2, 8, 99), (3, 10, 99),
    (3, 11, 40), (3, 13, 30), (4, 14, 20), (4, 16, 12),
    (4, 18, 10), (5, 20, 8), (5, 22, 6), (5, 24, 6),
    (6, 26, 4), (6, 29, 4), (7, 32, 4), (7, 35, 4),
]
FIT_NAMES = [
    ("Primer encaje", "First fit"), ("Dos mitades", "Two halves"), ("Trío", "Trio"),
    ("Panal chico", "Small honeycomb"), ("Escalera", "Staircase"), ("Cuatro esquinas", "Four corners"),
    ("Mosaico", "Mosaic"), ("Colmena", "Beehive"), ("Pétalos", "Petals"), ("Rompecabezas", "Jigsaw"),
    ("Isla", "Island"), ("Constelación", "Constellation"), ("Laberinto", "Maze"),
    ("Gran panal", "Great honeycomb"), ("Obra maestra", "Masterpiece"),
]


def piece_sizes(rng, pieces, cells):
    """Split `cells` into `pieces` sizes between 1 and 6 (RN-HF-12 b), as even as possible."""
    while True:
        sizes = [cells // pieces] * pieces
        for i in range(cells % pieces):
            sizes[i] += 1
        for _ in range(pieces):  # small random jitter keeps shapes varied
            a, b = rng.randrange(pieces), rng.randrange(pieces)
            if sizes[a] > 2 and sizes[b] < 6:
                sizes[a] -= 1; sizes[b] += 1
        if all(1 <= s <= 6 for s in sizes):
            return sizes


def random_polyhex(rng, size):
    cells = {(0, 0)}
    while len(cells) < size:
        q, r = rng.choice(sorted(cells))
        dq, dr = rng.choice(NEIGH)
        cells.add((q + dq, r + dr))
    return normalize(cells)


def contacts(cells, figure):
    return sum(1 for q, r in cells for dq, dr in NEIGH if (q + dq, r + dr) in figure)


def has_hole(figure):
    qs = [c[0] for c in figure]; rs = [c[1] for c in figure]
    box = {(q, r) for q in range(min(qs) - 1, max(qs) + 2) for r in range(min(rs) - 1, max(rs) + 2)}
    outside = box - figure
    start = (min(qs) - 1, min(rs) - 1)
    seen, todo = {start}, [start]
    while todo:
        q, r = todo.pop()
        for dq, dr in NEIGH:
            n = (q + dq, r + dr)
            if n in outside and n not in seen:
                seen.add(n); todo.append(n)
    return seen != outside


def build_fit(rng, pieces, cells):
    sizes = piece_sizes(rng, pieces, cells)
    figure, placed = set(), []
    for size in sizes:
        shape = random_polyhex(rng, size)
        if not figure:
            cells_ = [tuple(c) for c in rng.choice(orientations(shape))]
        else:
            best, options = -1, []
            for o in orientations(shape):
                for fq, fr in figure:
                    for dq, dr in NEIGH:
                        for base in o:
                            anchor = (fq + dq - base[0], fr + dr - base[1])
                            cand = [(anchor[0] + q, anchor[1] + r) for q, r in o]
                            if any(c in figure for c in cand):
                                continue
                            k = contacts(cand, figure)
                            if k > best:
                                best, options = k, [cand]
                            elif k == best:
                                options.append(cand)
            cells_ = rng.choice(sorted(options))
        figure |= set(cells_)
        placed.append((shape, cells_))
    if has_hole(figure):
        return None
    shapes = [s for s, _ in placed]
    if any(shapes.count(s) > 2 for s in shapes):
        return None
    return figure, placed


def fit_level(index, figure, placed, rng):
    order = index + 1
    pieces, solution = [], {}
    colors = rng.sample(COLORS, len(placed))
    for i, (shape, cells) in enumerate(placed):
        pid = chr(ord("A") + i)
        # tray orientation: any rotation different from the one used in the solution, if possible
        sol_norm = normalize(cells)
        rots = [o for o in orientations(shape) if o != sol_norm] or [sol_norm]
        tray = rng.choice(rots)
        pieces.append({"id": pid, "color": colors[i], "shape": [list(c) for c in tray]})
        solution[pid] = [list(c) for c in sorted(cells, key=lambda c: (c[1], c[0]))]
    # center the figure near the origin
    cq = round(statistics.mean(c[0] for c in figure)); cr = round(statistics.mean(c[1] for c in figure))
    shift = lambda c: [c[0] - cq, c[1] - cr]
    es, en = FIT_NAMES[index]
    return {
        "id": f"fit-hex-{order:03d}", "gameId": "hexa-fit", "topology": "hex",
        "order": order, "version": 1, "name": {"es": es, "en": en},
        "variant": {
            "figure": [shift(c) for c in sorted(figure, key=lambda c: (c[1], c[0]))],
            "pieces": pieces,
            "starThresholds": {"moves": len(placed) + 1, "timeMs": 20000 * len(placed)},
            "solution": {pid: [shift(c) for c in cells] for pid, cells in solution.items()},
        },
    }


def generate_fit(rng, first_level=None):
    levels, prev_nodes = [], 0
    for i, (pieces, cells, max_sol) in enumerate(FIT_PLAN):
        if i == 0 and first_level is not None:
            stats = fit_solve(first_level)
            levels.append((first_level, stats)); prev_nodes = stats["nodes"]; continue
        cands = []
        for _ in range(400):
            built = build_fit(rng, pieces, cells)
            if not built:
                continue
            lvl = fit_level(i, *built, rng)
            st = fit_solve(lvl, cap=max_sol + 1)
            if st["reference_ok"] and st["solutions"] <= max_sol and st["nodes"] > prev_nodes:
                cands.append((st["nodes"], st["solutions"], lvl, st))
            if len(cands) >= 25:
                break
        if not cands:
            raise SystemExit(f"Fit level {i + 1}: no candidate fits the tier")
        cands.sort(key=lambda c: (c[0], c[1]))
        nodes, _, lvl, st = cands[len(cands) // 3]  # a bit above the easiest that still grows
        levels.append((lvl, st)); prev_nodes = nodes
    return levels


# ------------------------------------------------------------------ Hexa Sort (D-55, D-28)
# (goals, colors, initial stacks); levels 1-6 'any' without stacks, 7-10 hex with stacks
SORT_PLAN = [(1, 3, 0), (2, 3, 0), (3, 3, 0), (3, 4, 0), (5, 4, 0), (5, 5, 0),
             (8, 5, 2), (8, 5, 3), (10, 6, 3), (12, 6, 4)]
SORT_NAMES = [
    ("Primer orden", "First sort"), ("Dos torres", "Two towers"), ("Tres en raya", "Three in a row"),
    ("Arcoíris", "Rainbow"), ("Cascada", "Cascade"), ("Torbellino", "Whirlpool"),
    ("Obstáculos", "Obstacles"), ("Encrucijada", "Crossroads"), ("Tormenta", "Storm"), ("Gran final", "Grand finale"),
]
SORT_COLORS = ["red", "green", "blue", "yellow", "purple", "orange"]
GEN = {"minHeight": 2, "maxHeight": 6, "maxBlocks": 3}


def sort_level(index, goals, k, seed, stacks):
    order = index + 1
    topology = "any" if not stacks else "hex"
    es, en = SORT_NAMES[index]
    v = {"goals": goals, "palette": SORT_COLORS[:k], "seed": seed, "generation": dict(GEN)}
    if stacks:
        v["initialStacks"] = stacks
    return {"id": f"sort-{topology}-{order:03d}", "gameId": "hexa-sort", "topology": topology,
            "order": order, "version": 1, "name": {"es": es, "en": en}, "variant": v}


def initial_stacks(rng, count, palette):
    from levelkit import Rng, gen_stack
    board = sorted(hexagon(2))
    for _ in range(200):
        cells = rng.sample(board, count)
        r = Rng(rng.randrange(1, 2 ** 32))
        stacks = [{"cell": list(c), "stack": gen_stack(r, palette, GEN)} for c in cells]
        tops = {tuple(s["cell"]): s["stack"][-1] for s in stacks}
        # no two adjacent initial stacks with the same top color (they would never have settled)
        if all(not ((c[0] + dq, c[1] + dr) in tops and tops[(c[0] + dq, c[1] + dr)] == col)
               for c, col in tops.items() for dq, dr in NEIGH):
            return stacks
    raise SystemExit("could not place initial stacks")


def generate_sort(rng):
    levels, prev = [], 0
    for i, (goals, k, nstacks) in enumerate(SORT_PLAN):
        palette = SORT_COLORS[:k]
        stacks = initial_stacks(rng, nstacks, palette) if nstacks else []
        tried = []
        for _ in range(60):
            seed = rng.randrange(1, 2 ** 32)
            lvl = sort_level(i, goals, k, seed, stacks)
            g = sort_play(lvl, beam=1, max_moves=300)
            if g["won"]:
                tried.append((g["moves"], seed, lvl, g))
        median = statistics.median(t[0] for t in tried)
        ok = [t for t in tried if t[0] > prev] or tried
        moves, seed, lvl, g = min(ok, key=lambda t: (abs(t[0] - median), t[0]))
        b = sort_play(lvl, beam=30, max_moves=300)
        levels.append((lvl, {"greedy": g, "beam30": b, "tier_median": median, "seeds_won": f"{len(tried)}/60"}))
        prev = moves
    return levels


def main(argv):
    out = pathlib.Path(argv[1])
    master = int(argv[argv.index("--seed") + 1]) if "--seed" in argv else 2026
    rng = random.Random(master)
    first = None
    ex = pathlib.Path(__file__).resolve().parents[2] / "docs/contracts/examples/E-HF-NIVEL.fit-hex-001.level.json"
    if ex.exists():
        first = json.loads(ex.read_text(encoding="utf-8"))  # level 1 is the verified example E-HF-NIVEL
    fit = generate_fit(rng, first)
    sort = generate_sort(rng)
    (out / "hexa-fit").mkdir(parents=True, exist_ok=True)
    (out / "hexa-sort").mkdir(parents=True, exist_ok=True)
    report = []
    for lvl, st in fit:
        (out / "hexa-fit" / f"{lvl['id']}.json").write_text(json.dumps(lvl, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        report.append({"id": lvl["id"], **st})
    for lvl, st in sort:
        (out / "hexa-sort" / f"{lvl['id']}.json").write_text(json.dumps(lvl, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        report.append({"id": lvl["id"], **st})
    report_dir = pathlib.Path(__file__).resolve().parents[2] / "docs/levels"  # outside assets/: not in the APK
    report_dir.mkdir(parents=True, exist_ok=True)
    (report_dir / "generation-report.json").write_text(json.dumps({"masterSeed": master, "levels": report}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    for r in report:
        print(r)


if __name__ == "__main__":
    main(sys.argv)
