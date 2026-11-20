"""Re-verifies every rule example (E-*) of the docs with the reference simulator."""
import sys, itertools
sys.path.insert(0, sys.argv[1])  # path to tools/reference-sim
from hexsim import *
import trisim

FAILED = []

def ok(name, cond):
    print(("OK  " if cond else "FAIL"), name)
    if not cond:
        FAILED.append(name)

# E-COM-1
x, seq = 12345, []
for _ in range(4):
    x = xorshift32(x); seq.append(x)
ok("E-COM-1 xorshift32", seq == [3336926330, 1697253807, 2816511904, 1955480042])

# Hex radius tables
for R, n, lens in ((2, 19, [3, 4, 5, 4, 3]), (4, 61, [5, 6, 7, 8, 9, 8, 7, 6, 5])):
    b = hexagon(R); L = lines(b)
    ok(f"RN-HEX-05 radio {R}", len(b) == n and all([len(l) for l in L[a]] == lens for a in L))

# E-HEX-1
arc = [(0, 0), (1, 0), (1, 1)]
r1 = normalize([rot_cw(c) for c in arc])
ok("E-HEX-1 un paso", set(r1) == {(0, 0), (0, 1), (-1, 2)})
cur = arc
for _ in range(6): cur = [rot_cw(c) for c in cur]
ok("E-HEX-1 seis pasos", set(cur) == set(arc))

# RN-HL-23 catalog
cat = {
    "mono": ([(0, 0)], 1), "domino": ([(0, 0), (1, 0)], 3), "line3": ([(0, 0), (1, 0), (2, 0)], 3),
    "arc3": ([(0, 0), (1, 0), (1, 1)], 6), "tri3": ([(0, 0), (1, 0), (0, 1)], 2),
    "line4": ([(i, 0) for i in range(4)], 3), "rhomb4": ([(0, 0), (1, 0), (0, 1), (1, 1)], 3),
    "line5": ([(i, 0) for i in range(5)], 3),
}
doc_arc = [[(0,0),(1,0),(1,1)],[(0,0),(0,1),(-1,2)],[(0,0),(-2,1),(-1,1)],[(0,0),(0,1),(1,1)],[(0,0),(-1,1),(-1,2)],[(0,0),(1,0),(-1,1)]]
for k, (s, n) in cat.items():
    ok(f"RN-HL-23 {k} {n} orientaciones", len(orientations(s)) == n)
ok("RN-HL-23 orden arco", [set(o) for o in orientations(cat['arc3'][0])] == [set(o) for o in doc_arc])
doc_rhomb = [[(0,0),(1,0),(0,1),(1,1)],[(0,0),(-1,1),(0,1),(-1,2)],[(0,0),(1,0),(-1,1),(0,1)]]
ok("RN-HL-23 orden rombo", [set(o) for o in orientations(cat['rhomb4'][0])] == [set(o) for o in doc_rhomb])
ok("RN-HL-23 24 piezas", sum(n for _, n in cat.values()) == 24)

def hl_points(cells, full, k):
    bono = sum(5 * len(ln) for _, ln in full)
    return cells + bono * len(full) * min(k + 1, 6) // 2

B4 = hexagon(4)
occ = {c: "X" for c in [(0, -4), (1, -4), (2, -4)]}
res = lines_place(B4, occ, [(0, 0), (1, 0)], (3, -4))
ok("E-HL-1", res and len(res[2]) == 1 and len(res[3]) == 5 and hl_points(2, res[2], 1) == 27)
occ2 = {c: "X" for c in [(q, -4) for q in range(4)] + [(4, r) for r in range(-3, 1)]}
res = lines_place(B4, occ2, [(0, 0)], (4, -4))
ok("E-HL-2", res and len(res[3]) == 9 and not res[0] and hl_points(1, res[2], 1) == 101 and hl_points(1, res[2], 2) == 151)
ok("E-HL-3", lines_place(B4, occ, [(0, 0), (1, 0)], (2, -4)) is None and lines_place(B4, occ, [(0, 0), (1, 0)], (4, -4)) is None)
rows = ["XXXX.", ".XXXXX", "XXX.XXX", "XXXXXX.X", "XX.XXXXXX", ".XXXXXXX", "XXXXXX.", "XXXX.X", "X.XXX"]
occ4 = {}
for i, r in enumerate(range(-4, 5)):
    qs = sorted(c[0] for c in B4 if c[1] == r)
    for q, ch in zip(qs, rows[i]):
        if ch == "X": occ4[(q, r)] = "X"
empties = [c for c in B4 if c not in occ4]
full_line = any(all(c in occ4 for c in ln) for ls in lines(B4).values() for ln in ls)
adj = any(n in empties for c in empties for n in neighbors(c, B4))
fits = lambda shapes: any(fits_anywhere(B4, occ4, o) for s in shapes for o in orientations(s))
ok("E-HL-4 tablero", len(occ4) == 52 and len(empties) == 9 and not full_line and not adj)
ok("E-HL-4 fin", not any(fits_anywhere(B4, occ4, o) for s in (cat['domino'][0], cat['line3'][0], cat['tri3'][0]) for o in orientations(s)))
ok("E-HL-4 mono cabe", fits_anywhere(B4, occ4, [(0, 0)]))

# E-HF-NIVEL: count solutions
F = {(2, -1), (0, 0), (1, 0), (2, 0), (0, 1), (1, 1)}
A = orientations([(0, 0), (1, 0), (1, 1)]); Bt = orientations([(0, 0), (1, 0), (0, 1)])
sols = set()
for oa in A:
    for a in F:
        ca = {(a[0] + q, a[1] + r) for q, r in oa}
        if not ca <= F: continue
        for ob in Bt:
            for b in F:
                cb = {(b[0] + q, b[1] + r) for q, r in ob}
                if cb <= F and not (ca & cb) and (ca | cb) == F:
                    sols.add((frozenset(ca), frozenset(cb)))
ok("E-HF-NIVEL 2 soluciones", len(sols) == 2)
ok("E-HF-NIVEL solución ref", (frozenset({(2, -1), (2, 0), (1, 1)}), frozenset({(0, 0), (1, 0), (0, 1)})) in sols)
# E-HF-1 step 1: after A at (0,0) unrotated, B doesn't fit
rest = F - {(0, 0), (1, 0), (1, 1)}
ok("E-HF-1 paso 1", not any({(b[0]+q, b[1]+r) for q, r in ob} <= rest for ob in Bt for b in rest))
rotA = normalize([rot_cw(c) for c in [(0, 0), (1, 0), (1, 1)]])
ok("E-HF-1 paso 4", {(2 + q, -1 + r) for q, r in rotA} == {(2, -1), (2, 0), (1, 1)})
# stars: 3 moves, m=2, t=60, 45s
ok("E-HF-1 estrellas", 1 + (3 <= 3) + (45 <= 40) == 2 and 1 + (3 <= 3) + (40 <= 40) == 3)
# E-HF-2
Acells = {(2, -1), (2, 0), (1, 1)}
okb = lambda anchor: (lambda cb: cb <= F and not cb & Acells)({(anchor[0]+q, anchor[1]+r) for q, r in [(0,0),(1,0),(0,1)]})
ok("E-HF-2", not okb((1, 0)) and not okb((-1, 0)))
# E-HF-4 and E-COM-2/3 ordering (Fit): stars desc, time asc, moves asc
fitkey = lambda a: (-a[0], a[1], a[2])
ok("E-HF-4", min([(2, 50, 2), (2, 45, 3)], key=fitkey) == (2, 45, 3))
ok("E-COM-2 nivel 2", min([(3, 35, 2), (3, 28, 3)], key=fitkey) == (3, 28, 3))
ok("E-COM-2 nivel 1", min([(2, 30, 4), (3, 38, 3)], key=fitkey) == (3, 38, 3))
fitrank = sorted([("Ana", 3, 50, 4), ("Beto", 3, 50, 3), ("Caro", 2, 30, 6)], key=lambda a: fitkey(a[1:]))
# stars must match the thresholds of the real level (RN-HF-62): 1 + (moves <= m) + (time <= t)
stars = lambda m, t, mv, s: 1 + (mv <= m) + (s <= t)
ok("E-HF-4 estrellas coherentes", all(stars(3, 40, mv, s) == st for st, s, mv in [(2, 50, 2), (2, 45, 3)]))
ok("E-COM-2 estrellas coherentes", all(stars(3, 40, mv, s) == st for st, s, mv in [(3, 35, 2), (3, 28, 3), (2, 30, 4), (3, 38, 3)])
   and stars(4, 60, 15, 180) == 1 and stars(4, 60, 8, 60) == 2)
ok("E-COM-3 Fit estrellas coherentes", all(stars(4, 60, mv, s) == st for _, st, s, mv in [("Ana", 3, 50, 4), ("Beto", 3, 50, 3), ("Caro", 2, 30, 6)]))
ok("E-COM-3 Fit", [a[0] for a in fitrank] == ["Beto", "Ana", "Caro"])

# Hexa Sort
B2 = hexagon(2)
def sort_case(name, before, placed, after, goals=None):
    st, g, steps = sort_resolve(B2, {c: list(v) for c, v in before.items()}, placed)
    got = {c: "".join(v) for c, v in st.items()}
    exp = {c: v for c, v in after.items() if v}
    ok(name, got == exp and (goals is None or g == goals))
    return steps, g
sort_case("E-HS-1", {(0,0):"BR", (1,0):"GRR", (0,1):"R"}, (0,0), {(0,0):"B", (1,0):"GRRRR"})
sort_case("E-HS-2", {(0,0):"RR", (1,0):"GRR"}, (0,0), {(0,0):"RRRR", (1,0):"G"})
sort_case("E-HS-3", {(0,0):"RR", (1,0):"BBR", (2,0):"GBBB"}, (0,0), {(0,0):"RRR", (2,0):"GBBBBB"})
steps, g = sort_case("E-HS-4", {(0,0):"BRRR", (1,0):"GRRRRRR", (0,1):"R"}, (0,0), {(0,0):"B", (1,0):"G"}, 1)
moved = sum(int(s.split()[1].split("x")[0]) for s in steps if s.startswith("mover"))
ok("E-HS-4 puntos 104", moved + 100 * g == 104)
sort_case("E-HS-5", {(0,0):"BRR", (1,0):"GRRRRRRRR", (0,1):"R"}, (0,0), {(0,0):"B", (1,0):"G", (0,1):"R"}, 1)
sort_case("E-HS-8", {(0,0):"R", (-1,0):"GRR", (1,0):"BRR"}, (0,0), {(-1,0):"G", (1,0):"BRRRRR"})
sortkey = lambda a: (a[1], -a[2])
rank = sorted([("Ana", 12, 240), ("Beto", 12, 265), ("Caro", 10, 224)], key=sortkey)
ok("E-COM-3 Sort puntajes posibles (2 metas)", all(s >= 202 for _, _, s in rank))
ok("E-COM-3 Sort", [a[0] for a in rank] == ["Caro", "Beto", "Ana"])

# Hexa Merge
def tiles_from_rows(rows):
    t = {}
    for i, r in enumerate(range(-2, 3)):
        qs = sorted(c[0] for c in B2 if c[1] == r)
        for q, v in zip(qs, rows[i]):
            if v: t[(q, r)] = v
    return t
before = tiles_from_rows([[0,0,0],[0,0,0,0],[2,0,2,4,4],[0,0,0,0],[0,0,0]])
t2, sc, ch = merge_slide(B2, before, "E")
ok("E-HM-1", t2 == {(1, 0): 4, (2, 0): 8} and sc == 12)
for row, exp, pts in (([0,2,2,2,0],[0,0,0,2,4],4), ([2,2,2,2,0],[0,0,0,4,4],8), ([0,4,2,2,0],[0,0,0,4,4],4)):
    t = {(q, 0): v for q, v in zip(range(-2, 3), row) if v}
    t2, sc, _ = merge_slide(B2, t, "E")
    ok(f"E-HM-2 {row}", t2 == {(q, 0): v for q, v in zip(range(-2, 3), exp) if v} and sc == pts)
before = tiles_from_rows([[0,0,4],[0,0,0,0],[0,0,2,0,0],[0,2,0,0],[8,0,0]])
t2, sc, _ = merge_slide(B2, before, "NE")
ok("E-HM-3", t2 == {(2,-2): 4, (1,-1): 4, (0,0): 8} and sc == 4)
t = {(2, 0): 2, (1, 1): 4, (2, -1): 8}
ok("E-HM-4", not merge_slide(B2, t, "E")[2] and merge_slide(B2, t, "W")[2])
full = {c: [2, 4, 8][(c[0] - c[1]) % 3] for c in B2}
ok("E-HM-5", not any(merge_slide(B2, full, d)[2] for d in DIRS))
ro = reading_order(B2)
ok("E-HM-6 celda 1", 3336926330 % 19 == 11 and ro[11] == (2, 0) and 1697253807 % 100 == 7)
ro2 = [c for c in ro if c != (2, 0)]
ok("E-HM-6 celda 2", 2816511904 % 18 == 10 and ro2[10] == (1, 0) and 1955480042 % 100 == 42)

# Triangles
for n, cells, lens in ((2, 24, [5, 7, 7, 5]), (3, 54, [7, 9, 11, 11, 9, 7])):
    b = trisim.hexagon(n)
    byF = {}
    for c in b: byF.setdefault(trisim.indices(*c)[0], []).append(c)
    byD = {}
    for c in b: byD.setdefault(trisim.indices(*c)[1], []).append(c)
    ok(f"RN-TRI-09 lado {n}", len(b) == cells and [len(byF[k]) for k in sorted(byF)] == lens and [len(byD[k]) for k in sorted(byD)] == lens)
orbit, c = [], (0, 0)
for _ in range(6):
    c = trisim.rotate(*c); orbit.append(c)
ok("E-TRI-2", orbit == [(-1, 0), (-1, -1), (0, -1), (1, -1), (1, 0), (0, 0)])
b = set(trisim.hexagon(2))
rot_preserves = all((trisim.rotate(*n) in trisim.neighbors(*trisim.rotate(*c))) for c in b for n in trisim.neighbors(*c))
ok("E-TRI-2 vecindad", rot_preserves)
rowsT = {}
for x, y in trisim.hexagon(2): rowsT.setdefault(y, []).append(x)
pic = ["".join("▲" if trisim.up(x, y) else "▼" for x in sorted(rowsT[y])) for y in sorted(rowsT)]
ok("E-TRI-1 dibujo", pic == ["▲▼▲▼▲", "▲▼▲▼▲▼▲", "▼▲▼▲▼▲▼", "▼▲▼▲▼"])

# Squares
sq = lambda c: (-c[1], c[0])
def nsq(s):
    m = min(s, key=lambda c: (c[1], c[0])); return {(x - m[0], y - m[1]) for x, y in s}
L3 = [(0, 0), (0, 1), (1, 1)]
seqs, cur = [], L3
for _ in range(4):
    cur = [sq(c) for c in cur]; seqs.append(nsq(cur))
ok("E-SQR-1", seqs == [{(0,0),(1,0),(0,1)}, {(0,0),(1,0),(1,1)}, {(0,0),(-1,1),(0,1)}, nsq(L3)])
ok("E-SQR-1 crudo", {sq(c) for c in L3} == {(0, 0), (-1, 0), (-1, 1)})
ok("RN-SQR-05 horario", sq((1, 0)) == (0, 1))

# Cubes
rz = lambda c: (-c[1], c[0], c[2]); rx = lambda c: (c[0], -c[2], c[1]); ry = lambda c: (c[2], c[1], -c[0])
pts = ((1, 2, 3),)
seen, frontier = {pts}, [pts]
while frontier:
    nxt = []
    for p in frontier:
        for f in (rz, rx, ry):
            q = tuple(f(c) for c in p)
            if q not in seen: seen.add(q); nxt.append(q)
    frontier = nxt
ok("E-CUB-1 24", len(seen) == 24)
ok("E-CUB-1 4 giros", all(f(f(f(f((1, 2, 3))))) == (1, 2, 3) for f in (rz, rx, ry)))

if FAILED:
    print(f"{len(FAILED)} example(s) failed")
    sys.exit(1)
print("all examples OK")
