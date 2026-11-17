"""Simulador de referencia para verificar los ejemplos de las reglas de negocio.
Topología hexagonal pointy-top, coordenadas axiales (q, r), s = -q - r.
"""
from collections import deque

DIRS = {  # nombre: (dq, dr)
    "E": (1, 0), "W": (-1, 0),
    "NE": (1, -1), "SW": (-1, 1),
    "NW": (0, -1), "SE": (0, 1),
}
NEIGH = list(DIRS.values())


def s_of(c):
    return -c[0] - c[1]


def hexagon(R):
    return [(q, r) for r in range(-R, R + 1) for q in range(-R, R + 1) if abs(-q - r) <= R]


def reading_order(cells):
    return sorted(cells, key=lambda c: (c[1], c[0]))


def neighbors(c, board):
    return [(c[0] + dq, c[1] + dr) for dq, dr in NEIGH if (c[0] + dq, c[1] + dr) in board]


def lines(board):
    """Devuelve dict eje -> lista de líneas (cada línea = lista de celdas en orden)."""
    cells = set(board)
    res = {"r": [], "q": [], "s": []}
    for key, f, order in (("r", lambda c: c[1], lambda c: c[0]),
                          ("q", lambda c: c[0], lambda c: c[1]),
                          ("s", s_of, lambda c: c[1])):
        groups = {}
        for c in cells:
            groups.setdefault(f(c), []).append(c)
        for k in sorted(groups):
            res[key].append(sorted(groups[k], key=order))
    return res


def rot_cw(c):
    q, r = c
    s = -q - r
    return (-r, -s)


def normalize(shape):
    m = min(shape, key=lambda c: (c[1], c[0]))
    return tuple(sorted(((q - m[0], r - m[1]) for q, r in shape), key=lambda c: (c[1], c[0])))


def orientations(shape):
    out = []
    cur = list(shape)
    for _ in range(6):
        n = normalize(cur)
        if n not in out:
            out.append(n)
        cur = [rot_cw(c) for c in cur]
    return out


def render(board, content, w=2):
    """content: dict celda -> str; vacías '.'; celdas fuera del tablero no se dibujan."""
    rs = sorted({c[1] for c in board})
    qs = sorted({c[0] for c in board})
    R = max(max(abs(x) for x in rs), max(abs(x) for x in qs))
    out = []
    half = w // 2
    for r in rs:
        row_cells = sorted([c for c in board if c[1] == r])
        line = {}
        for c in row_cells:
            col = half * (2 * c[0] + r + 2 * R)
            line[col] = content.get(c, ".")
        maxcol = max(line) + w
        buf = [" "] * (maxcol + w)
        for col, txt in line.items():
            t = txt.rjust(w - 1)[: w]
            for i, ch in enumerate(t):
                buf[col + i] = ch
        out.append("".join(buf).rstrip() + f"    r={r:+d}")
    return "\n".join(out)


# ---------------- Hexa Lines ----------------

def lines_place(board, occ, piece, anchor):
    cells = [(anchor[0] + q, anchor[1] + r) for q, r in piece]
    if any(c not in board or c in occ for c in cells):
        return None
    occ2 = dict(occ)
    for c in cells:
        occ2[c] = "X"
    full = []
    for ax, ls in lines(board).items():
        for ln in ls:
            if all(c in occ2 for c in ln):
                full.append((ax, ln))
    cleared = set()
    for _, ln in full:
        cleared |= set(ln)
    for c in cleared:
        del occ2[c]
    return occ2, cells, full, cleared


def fits_anywhere(board, occ, piece):
    for a in board:
        cells = [(a[0] + q, a[1] + r) for q, r in piece]
        if all(c in board and c not in occ for c in cells):
            return True
    return False


# ---------------- Hexa Sort ----------------

CW = ["NE", "E", "SE", "SW", "W", "NW"]  # sentido horario desde las 12


def clockwise(c, cells):
    out = []
    for d in CW:
        dq, dr = DIRS[d]
        n = (c[0] + dq, c[1] + dr)
        if n in cells:
            out.append(n)
    return out


def top_run(stack):
    if not stack:
        return None, 0
    col = stack[-1]
    n = 0
    for t in reversed(stack):
        if t == col:
            n += 1
        else:
            break
    return col, n


def sort_resolve(board, stacks, placed, clear_at=10, log=True):
    """stacks: dict celda -> lista (abajo -> arriba). Devuelve (stacks, metas, pasos)."""
    st = {c: list(v) for c, v in stacks.items() if v}
    goals = 0
    steps = []
    queue = deque([placed])
    while queue:
        c = queue.popleft()
        if c not in st:
            continue
        color, _ = top_run(st[c])
        ns = [n for n in neighbors(c, board) if n in st and top_run(st[n])[0] == color]
        if not ns:
            continue
        group = [c] + ns
        best = max(top_run(st[g])[1] for g in group)
        tied = [g for g in group if top_run(st[g])[1] == best]
        cw = clockwise(c, ns)
        if c in tied:
            dest = c
        else:
            dest = [n for n in cw if n in tied][0]
        order = ([c] if c != dest else []) + [n for n in cw if n != dest]
        for src in order:
            col, n = top_run(st[src])
            moved = st[src][-n:]
            st[src] = st[src][:-n]
            st[dest].extend(moved)
            steps.append(f"mover {n}x{col} de {src} a {dest}")
            if not st[src]:
                del st[src]
            else:
                queue.append(src)
            col_d, n_d = top_run(st[dest])
            if n_d >= clear_at:
                st[dest] = st[dest][:-n_d]
                goals += 1
                steps.append(f"meta: se eliminan {n_d}x{col_d} en {dest}")
                if not st[dest]:
                    del st[dest]
                # el destino cambió de cima: las fuentes aún no procesadas se reevalúan desde la cola
                for rest in order[order.index(src) + 1:]:
                    queue.append(rest)
                break
        if dest in st:
            queue.append(dest)
    return st, goals, steps


# ---------------- Hexa Merge ----------------

def merge_slide(board, tiles, d):
    dq, dr = DIRS[d]
    tiles2 = {}
    score = 0
    # líneas en el eje de la dirección
    if dr == 0:
        key = lambda c: c[1]
    elif dq == 0:
        key = lambda c: c[0]
    else:
        key = s_of
    groups = {}
    for c in board:
        groups.setdefault(key(c), []).append(c)
    for _, ln in groups.items():
        # ordenar desde el frente (más lejos en la dirección) hacia atrás
        ln = sorted(ln, key=lambda c: -(c[0] * dq + c[1] * dr) if (dq, dr) != (0, 0) else 0)
        vals = [tiles[c] for c in ln if c in tiles]
        out = []
        i = 0
        while i < len(vals):
            if i + 1 < len(vals) and vals[i] == vals[i + 1]:
                out.append(vals[i] * 2)
                score += vals[i] * 2
                i += 2
            else:
                out.append(vals[i])
                i += 1
        for c, v in zip(ln, out):
            tiles2[c] = v
    changed = tiles2 != tiles
    return tiles2, score, changed


def xorshift32(state):
    x = state & 0xFFFFFFFF
    x ^= (x << 13) & 0xFFFFFFFF
    x ^= x >> 17
    x ^= (x << 5) & 0xFFFFFFFF
    return x & 0xFFFFFFFF
