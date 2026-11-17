"""Python model of the proposed UndoHistory + GamePhase (ARQ-02 §5, §8),
checked against RN-COM-60..63, E-HF-3 and E-HM-7. States are immutable values."""

class History:
    def __init__(self, engine, limit=None, redo=False):
        self.e, self.limit, self.allows_redo = engine, limit, redo
        self.done, self.undone = [], []
        engine.listeners.append(self.record)
    def can_undo(self): return bool(self.done) and self.e.phase in ("playing",)
    def can_redo(self): return self.allows_redo and bool(self.undone) and self.e.phase in ("playing",)
    def undo(self):
        if not self.can_undo(): return False
        c = self.done.pop(); self.e.state = c[1]
        if self.allows_redo: self.undone.append(c)
        return True
    def redo(self):
        if not self.can_redo(): return False
        c = self.undone.pop(); self.e.state = c[2]; self.done.append(c); return True
    def record(self, c):
        self.undone.clear(); self.done.append(c)
        if self.limit is not None and len(self.done) > self.limit: self.done.pop(0)

class Engine:
    def __init__(self, state, play):
        self.state, self.play, self.phase, self.listeners = state, play, "playing", []
    def submit(self, move):
        if self.phase != "playing": return False
        self.phase = "resolving"
        new, outcome = self.play(self.state, move)
        if new is None: self.phase = "playing"; return False
        before, self.state = self.state, new
        for l in self.listeners: l((move, before, new))
        self.phase = {"ongoing": "playing", "victory": "victory", "defeat": "gameover"}[outcome]
        return True
    def continue_(self):  # VictoryPhase(canContinue)
        if self.phase == "victory": self.phase = "playing"

ok = lambda n, c: print(("OK  " if c else "FAIL"), n)

# E-HF-3 (Fit: unlimited + redo; rotate is in history)
fit = Engine((), lambda s, m: (s + (m,), "ongoing"))
h = History(fit, limit=None, redo=True)
fit.submit("place A"); fit.submit("place B"); h.undo()
ok("E-HF-3 B vuelve", fit.state == ("place A",) and h.can_redo())
fit.submit("rotate B")
ok("E-HF-3 rehacer descartado", not h.can_redo())
h.undo(); h.undo()
ok("RN-HF-80 sin límite hasta el inicio", fit.state == () and not h.can_undo())
h.redo(); h.redo()
ok("RN-HF-80 rehacer en orden", fit.state == ("place A", "rotate B"))

# E-HM-7 (Merge: limit 1, no redo; RNG is part of the state)
def merge_play(s, m):
    board, score, rng = s
    rng2 = (rng * 1103515245 + 12345) % 2**32  # stand-in generator
    return ((board + (m, rng2 % 19), score + 4, rng2), "ongoing")
mg = Engine(((), 12, 777), merge_play)
hm = History(mg, limit=1, redo=False)
start = mg.state
mg.submit("W"); first = mg.state
hm.undo()
ok("E-HM-7 vuelve todo (generador incluido)", mg.state == start and not hm.can_undo() and not hm.can_redo())
mg.submit("W")
ok("E-HM-7 misma ficha nueva", mg.state == first)
mg.submit("E"); mg.submit("NE"); hm.undo();
ok("RN-HM-80 solo el último", not hm.can_undo())

# RN-COM-63: no undo after defeat; Merge keeps undo after continuing past victory; Fit not after victory
lose = Engine(0, lambda s, m: (s + 1, "defeat"))
hl = History(lose, limit=1)
lose.submit("x")
ok("RN-COM-63 sin deshacer tras derrota", not hl.can_undo())
win = Engine(0, lambda s, m: (s + 1, "victory"))
hw = History(win, limit=1)
win.submit("x")
ok("RN-COM-63 Fit: sin deshacer en victoria", not hw.can_undo())
win.continue_()
ok("RN-COM-63 Merge: deshacer al seguir jugando", hw.can_undo())

# RN-COM-21 / RN-COM-24
inv = Engine(0, lambda s, m: (None, "ongoing"))
hi = History(inv, limit=1)
ok("RN-COM-21 inválido no entra al historial", not inv.submit("bad") and not hi.can_undo() and inv.phase == "playing")
p = Engine(0, lambda s, m: (s + 1, "ongoing")); p.phase = "paused"
ok("RN-COM-24 en pausa no acepta movimientos", not p.submit("x"))
