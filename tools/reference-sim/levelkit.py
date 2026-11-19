"""Level tools for Step 6: Hexa Fit solver and Hexa Sort bot (hexagons).

Usage:
  python3 -I tools/reference-sim/levelkit.py fit  <level.json> [...]
  python3 -I tools/reference-sim/levelkit.py sort <level.json> [...]

Fit: counts every solution (exact cover with the 6 rotations of each piece, RN-HF-30/31),
checks that the reference solution is one of them and reports search effort.
Sort: plays the level with the fixed seed (RN-COM-40/43, RN-HS-21) using a greedy bot and
a beam search, and reports whether it can be won and in how many moves.
"""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from hexsim import hexagon, neighbors, orientations, sort_resolve, top_run, xorshift32

# ---------------------------------------------------------------- Hexa Fit


def fit_solve(level, cap=100000):
    v = level["variant"]
    figure = {tuple(c) for c in v["figure"]}
    pieces = [(p["id"], orientations([tuple(c) for c in p["shape"]])) for p in v["pieces"]]
    order = sorted(figure, key=lambda c: (c[1], c[0]))
    solutions = []
    nodes = 0

    def first_empty(occ):
        for c in order:
            if c not in occ:
                return c
        return None

    def rec(occ, used, placed):
        nonlocal nodes
        nodes += 1
        if len(solutions) >= cap:
            return
        target = first_empty(occ)
        if target is None:
            solutions.append(dict(placed))
            return
        for i, (pid, orients) in enumerate(pieces):
            if i in used:
                continue
            for o in orients:
                # the first cell of the normalized orientation (reading order) covers the target
                base = o[0]
                cells = [(target[0] + q - base[0], target[1] + r - base[1]) for q, r in o]
                if all(c in figure and c not in occ for c in cells):
                    for c in cells:
                        occ[c] = pid
                    placed[pid] = frozenset(cells)
                    rec(occ, used | {i}, placed)
                    del placed[pid]
                    for c in cells:
                        del occ[c]

    rec({}, frozenset(), {})
    ref = {pid: frozenset(map(tuple, cells)) for pid, cells in v["solution"].items()}
    # pieces with the same shape are interchangeable: compare as a multiset of cell sets
    ref_found = any(sorted(map(sorted, s.values())) == sorted(map(sorted, ref.values())) for s in solutions)
    return {"solutions": len(solutions), "nodes": nodes, "reference_ok": ref_found,
            "cells": len(figure), "pieces": len(pieces)}


# ---------------------------------------------------------------- Hexa Sort


class Rng:
    """xorshift32 (RN-COM-43). next() returns the new state."""

    def __init__(self, seed):
        self.state = seed if seed != 0 else 0x9E3779B9

    def next(self):
        self.state = xorshift32(self.state)
        return self.state


def gen_stack(rng, palette, g):
    """RN-HS-21 with the proposed precision: colors after the first block are drawn from
    the palette without the previous color. Blocks are listed bottom to top."""
    h = g["minHeight"] + rng.next() % (g["maxHeight"] - g["minHeight"] + 1)
    n = 1 + rng.next() % min(g["maxBlocks"], h)
    sizes = [1] * n
    for _ in range(h - n):
        sizes[rng.next() % n] += 1
    colors, prev = [], None
    for _ in range(n):
        choices = [c for c in palette if c != prev]
        prev = choices[rng.next() % len(choices)]
        colors.append(prev)
    stack = []
    for size, col in zip(sizes, colors):
        stack += [col] * size
    return stack


def sort_board(level):
    v = level["variant"]
    if "board" in v:
        return [tuple(c) for c in v["board"]]
    return hexagon(2)  # RN-TOP-11 / RN-HS-10


def tray_sequence(level, count):
    v = level["variant"]
    rng = Rng(v["seed"])
    return [gen_stack(rng, v["palette"], v["generation"]) for _ in range(count)]


def sort_step(board, stacks, cell, stack):
    st = dict(stacks)
    st[cell] = list(stack)
    before = sum(len(s) for s in st.values())
    st2, goals, steps = sort_resolve(board, st, cell, log=False)
    moved = sum(int(s.split()[1].split("x")[0]) for s in steps if s.startswith("mover"))
    return st2, goals, moved, before - sum(len(s) for s in st2.values())


def heuristic(stacks, goals_done):
    # prefer goals, then fewer occupied cells, then tall single-color tops
    occupied = len(stacks)
    tops = sum(top_run(s)[1] ** 2 for s in stacks.values())
    return goals_done * 1000 - occupied * 20 + tops


def sort_play(level, beam=1, max_moves=400):
    v = level["variant"]
    board = sort_board(level)
    trays = tray_sequence(level, max_moves)
    start = {tuple(s["cell"]): list(s["stack"]) for s in v.get("initialStacks", [])}
    frontier = [(start, 0, 0, 0)]  # stacks, goals, score, moves
    for move in range(max_moves):
        tray = trays[move]
        children = []
        for stacks, goals, score, moves in frontier:
            for cell in board:
                if cell in stacks:
                    continue
                st2, g, moved, _ = sort_step(board, stacks, cell, tray)
                ng, ns = goals + g, score + moved + 100 * g
                if ng >= v["goals"]:
                    return {"won": True, "moves": moves + 1, "score": ns}
                if len(st2) < len(board):
                    children.append((heuristic(st2, ng), (st2, ng, ns, moves + 1)))
        if not children:
            return {"won": False, "moves": move + 1}
        children.sort(key=lambda x: -x[0])
        frontier = [c for _, c in children[:beam]]
    return {"won": False, "moves": max_moves}


def main(argv):
    kind, files = argv[1], argv[2:]
    for f in files:
        level = json.load(open(f, encoding="utf-8"))
        if kind == "fit":
            print(level["id"], fit_solve(level))
        else:
            g = sort_play(level, beam=1)
            b = sort_play(level, beam=30)
            print(level["id"], {"greedy": g, "beam30": b})


if __name__ == "__main__":
    main(sys.argv)
