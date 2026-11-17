"""Simulador de referencia: topología de triángulos (Anexo B de 02-RN-TOPOLOGIAS.md).

Celda (x, y): fila y, columna x. ▲ si x + y es par, ▼ si es impar.
Índices de línea: F = y, D = floor((x + y) / 2), A = floor((y - x) / 2); x = D - A.
"""
import math


def up(x, y):
    return (x + y) % 2 == 0


def indices(x, y):
    return y, math.floor((x + y) / 2), math.floor((y - x) / 2)


def neighbors(x, y):
    out = [(x - 1, y), (x + 1, y)]
    out.append((x, y + 1) if up(x, y) else (x, y - 1))
    return out


def rotate(x, y):
    """Giro básico de 60° horario: (F, D, A) -> (D, -A - 1, F)."""
    f, d, a = indices(x, y)
    f2, d2, a2 = d, -a - 1, f
    return d2 - a2, f2


def hexagon(n, span=40):
    """Tablero 'hexágono de lado n': -n <= F, D, A <= n - 1 (6n² celdas)."""
    cells = []
    for y in range(-span, span + 1):
        for x in range(-2 * span, 2 * span + 1):
            f, d, a = indices(x, y)
            if -n <= f <= n - 1 and -n <= d <= n - 1 and -n <= a <= n - 1:
                cells.append((x, y))
    return cells


if __name__ == "__main__":
    for n in (2, 3):
        print("lado", n, "celdas", len(hexagon(n)))
    c, orbit = (0, 0), [(0, 0)]
    for _ in range(6):
        c = rotate(*c)
        orbit.append(c)
    print("órbita de (0,0):", orbit)
