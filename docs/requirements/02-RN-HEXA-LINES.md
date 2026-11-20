# 02 — Reglas de negocio: Hexa Lines (`hexa-lines`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/`) |
| Responsable | _(por asignar)_ |
| Fuente principal | Enunciado §1.1 y §1.5 |
| Convenciones | Ver `02-RN-COMUNES.md` §0 (estados ✅/🟡/⚠️, notación, topología) |

## 1. Resumen

Partida **sin fin**. El jugador coloca piezas de una bandeja de 3 en un tablero vacío. Cuando completa una línea en cualquiera de los ejes, la línea se elimina y suma puntos. La partida termina cuando ninguna pieza de la bandeja cabe en el tablero. El objetivo es superar el récord.

| Dimensión (tabla 1.5) | Valor en Hexa Lines |
|---|---|
| Contenido de la celda | Vacía u ocupada por un **color** |
| Forma del tablero | Según la topología; en hexágonos, **radio 4** |
| Topología | La que eligió el jugador al crear la partida (RN-TOP-30, 31). Los ejemplos de este documento usan **hexágonos** |

| Fuente de piezas | **Generador aleatorio** con semilla |
| Tipo de movimiento | **Colocar pieza** |
| Regla de resolución | **Eliminar líneas completas** en todos los ejes |
| Fin de partida | **Ninguna pieza de la bandeja cabe** |
| Modelo de progreso | **Puntaje máximo** |
| Deshacer | **No** |

## 2. Contenido de la celda

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-01 | Cada celda está **vacía** u **ocupada por un color**. El color es el de la pieza que la ocupó y es **solo visual**: no afecta ninguna regla | Enunciado §1.5 | ✅ |

## 3. Forma del tablero

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-10 | El tablero por defecto depende de la topología (`02-RN-TOPOLOGIAS.md`, RN-TOP-10); en hexágonos es de **radio 4** (61 celdas). Es configurable | Enunciado §1.1, RN-COM-04 | ✅ |
| RN-HL-11 | La partida empieza con el tablero **vacío** | Enunciado §1.1 | ✅ |

## 4. Fuente de piezas y bandeja

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-20 | La bandeja ofrece **3 piezas**. Al empezar la partida se generan 3 | Enunciado §1.1 | ✅ |
| RN-HL-21 | Las piezas se pueden colocar **en cualquier orden**. Solo cuando se colocaron **las 3**, se genera una bandeja nueva de 3 | Enunciado §1.1 | ✅ |
| RN-HL-22 | Las piezas tienen de **1 a 5 celdas** y **no se pueden rotar**: cada orientación es una pieza distinta del catálogo | Enunciado §1.1, §1.5 (P-02) | ✅ |
| RN-HL-23 | **Catálogo para hexágonos:** familias con sus orientaciones y su **peso** (probabilidad de salir). Total: 8 familias, 24 piezas. Cada topología tiene su propio catálogo (`02-RN-TOPOLOGIAS.md` §4) | Equipo | ✅ D-08 (11-11) |
| RN-HL-24 | Para generar cada pieza: se elige la **familia** según los pesos (`siguiente() mod 100` sobre los pesos acumulados, en el orden de la tabla) y luego una **orientación** al azar (`siguiente() mod n`, en el orden de la tabla) | Diseño, RN-COM-44 | 🟡 |
| RN-HL-25 | No se garantiza que las piezas generadas quepan: la bandeja sale tal cual del generador | Enunciado §1.1 (fin de partida) | 🟡 |

**Catálogo (RN-HL-23)** — formas normalizadas, orientaciones en el orden en que se obtienen rotando 60° horario (verificado con el simulador):

| # | Familia | Celdas | Orientaciones | Peso |
|---|---|---|---|---|
| 1 | Mono | 1 | `(0,0)` | 5 |
| 2 | Dominó | 2 | `(0,0)(1,0)` · `(0,0)(0,1)` · `(0,0)(−1,1)` | 10 |
| 3 | Línea de 3 | 3 | `(0,0)(1,0)(2,0)` · `(0,0)(0,1)(0,2)` · `(0,0)(−1,1)(−2,2)` | 15 |
| 4 | Arco de 3 | 3 | `(0,0)(1,0)(1,1)` · `(0,0)(0,1)(−1,2)` · `(0,0)(−2,1)(−1,1)` · `(0,0)(0,1)(1,1)` · `(0,0)(−1,1)(−1,2)` · `(0,0)(1,0)(−1,1)` | 15 |
| 5 | Triángulo de 3 | 3 | `(0,0)(1,0)(0,1)` · `(0,0)(−1,1)(0,1)` | 15 |
| 6 | Línea de 4 | 4 | `(0,0)(1,0)(2,0)(3,0)` · `(0,0)(0,1)(0,2)(0,3)` · `(0,0)(−1,1)(−2,2)(−3,3)` | 15 |
| 7 | Rombo de 4 | 4 | `(0,0)(1,0)(0,1)(1,1)` · `(0,0)(−1,1)(0,1)(−1,2)` · `(0,0)(1,0)(−1,1)(0,1)` | 15 |
| 8 | Línea de 5 | 5 | `(0,0)(1,0)(2,0)(3,0)(4,0)` · `(0,0)(0,1)(0,2)(0,3)(0,4)` · `(0,0)(−1,1)(−2,2)(−3,3)(−4,4)` | 10 |

> Las piezas se definen por **forma** (no por coordenadas fijas): si la topología cambia, el catálogo se redefine en el anexo de esa topología.

## 5. Movimiento y validación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-30 | El único movimiento es **colocar** una pieza de la bandeja con su origen en una celda **ancla** del tablero | Enunciado §1.1 | ✅ |
| RN-HL-31 | La colocación es **válida** si **todas** las celdas de la pieza quedan **dentro del tablero** y **vacías**. No hay gravedad: la pieza queda exactamente donde se suelta | Enunciado §1.1 | ✅ |
| RN-HL-32 | Una colocación válida ocupa esas celdas con el color de la pieza y la quita de la bandeja. Una inválida no cambia nada (RN-COM-21) | Enunciado §1.1 | ✅ |

## 6. Resolución: eliminar líneas

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-40 | Después de colocar, se buscan todas las **líneas completas** (todas sus celdas ocupadas) en **todos los ejes** | Enunciado §1.1 | ✅ |
| RN-HL-41 | Todas las líneas completas se eliminan **a la vez**: sus celdas quedan vacías | Enunciado §1.1 | ✅ |
| RN-HL-42 | Una celda que pertenece a **varias líneas completas** se vacía **una sola vez**, pero cuenta para **cada** línea en la puntuación | HU HL-03 | ✅ |
| RN-HL-43 | La resolución tiene **un solo paso**: vaciar celdas nunca completa una línea nueva, así que no hay cascada | Consecuencia de RN-HL-41 | ✅ |
| RN-HL-44 | Solo pueden completarse líneas que pasan por alguna celda de la pieza recién colocada (las demás ya estaban incompletas). Esto permite optimizar la búsqueda sin cambiar el resultado | Consecuencia | ✅ |

## 7. Fin de partida

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-50 | Después de resolver y, si la bandeja quedó vacía, de **generar la bandeja nueva**, se comprueba si **alguna** pieza de la bandeja cabe en **alguna** posición del tablero | Enunciado §1.1 | ✅ |
| RN-HL-51 | Si **ninguna** cabe, la partida termina (**fin de partida**). Si al menos una cabe, la partida continúa, aunque las otras no quepan | Enunciado §1.1, HU HL-05 | ✅ |
| RN-HL-52 | Hexa Lines no tiene victoria | Enunciado §1.5 | ✅ |

## 8. Puntuación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-60 | Puntos del turno = **celdas colocadas + ⌊ bono de líneas × L × multiplicador de racha ⌋** | Enunciado §1.1 | ✅ (estructura) |
| RN-HL-61 | **Bono de líneas** = Σ (5 × largo de cada línea eliminada). Las líneas largas son más difíciles y valen más (largo 5 → 25; largo 9 → 45) | Equipo | ✅ D-09 (11-11) |
| RN-HL-62 | **Combo:** L = número de líneas eliminadas en el turno (1 línea ×1, 2 líneas ×2, 3 líneas ×3…) | Equipo | ✅ D-09 (11-11) |
| RN-HL-63 | **Racha:** k = número de turnos **consecutivos** con al menos una línea eliminada, incluido el actual. Multiplicador = (k + 1) / 2, con máximo 3 (k = 1 → ×1; k = 2 → ×1,5; k = 3 → ×2; k ≥ 5 → ×3). Un turno sin líneas reinicia k a 0 | Equipo | ✅ D-09 (11-11) |
| RN-HL-64 | Con enteros: puntos = celdas + ⌊ bono × L × min(k + 1, 6) / 2 ⌋ | Diseño, RN-COM-51 | 🟡 |

## 9. Progreso

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-70 | Durante la partida se muestran el **puntaje actual** y el **récord** | HU HL-06 | ✅ |
| RN-HL-71 | Al terminar la partida (derrota, nueva partida o **salir**), si el puntaje supera el récord del perfil, el récord se actualiza y se guarda (RN-COM-80), igual que en Hexa Merge (RN-HM-70) | Enunciado §5.1; precisión D-66 (DIS-08) | ✅ |

## 10. Deshacer

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HL-80 | Hexa Lines **no** permite deshacer | Enunciado §1.5 | ✅ |

## 11. Notificaciones

Para la interfaz, el sonido y la analítica (RN-COM-25), en este orden: **pieza colocada** → **líneas eliminadas** (cuáles, combo y racha) → **puntaje actualizado** → **bandeja nueva** (si corresponde) → **fin de partida** (si corresponde).

## 12. Casos borde

| Caso | Resultado |
|---|---|
| Colocar una pieza que completa una línea y a la vez llena el tablero | Primero se eliminan las líneas (RN-HL-41) y luego se evalúa el fin de partida (RN-HL-50) |
| La última pieza de la bandeja no cabe, pero aún quedan otras de la bandeja por colocar | No aplica: la bandeja nueva solo se genera cuando se colocaron las 3. Se evalúa con las que quedan |
| La bandeja nueva no tiene ninguna pieza que quepa | Fin de partida inmediato tras generarla |
| Tablero vacío al eliminar líneas | Válido; la partida continúa |

## 13. Ejemplos (se convierten en pruebas)

Tablero de radio 4. `X` = ocupada antes del movimiento, `N` = celdas de la pieza recién colocada.

**E-HL-1 — Una línea.** Ocupadas `(0,−4)`, `(1,−4)`, `(2,−4)`. Se coloca un dominó `(0,0)(1,0)` con ancla `(3,−4)`.

```
    X X X N N    r=-4
   . . . . . .    r=-3
  . . . . . . .    r=-2
 (resto vacío)
```

La fila `r = −4` (eje r, largo 5) queda completa → se vacían sus 5 celdas. Con k = 1: puntos = 2 + ⌊25 × 1 × 2 / 2⌋ = **27**.

**E-HL-2 — Dos líneas que se cruzan.** Ocupadas `(0,−4)…(3,−4)` y `(4,−3)…(4,0)`. Se coloca un mono con ancla `(4,−4)`.

```
    X X X X N    r=-4
   . . . . . X    r=-3
  . . . . . . X    r=-2
 . . . . . . . X    r=-1
. . . . . . . . X    r=+0
 (resto vacío)
```

Se completan la fila `r = −4` (largo 5) y la línea `q = 4` (largo 5). La celda `(4,−4)` está en las dos: se vacía una vez → **9 celdas vaciadas**, tablero vacío. Bono = 25 + 25 = 50; L = 2.
- Con k = 1: puntos = 1 + ⌊50 × 2 × 2 / 2⌋ = **101**.
- Si el turno anterior también eliminó líneas (k = 2): puntos = 1 + ⌊50 × 2 × 3 / 2⌋ = **151**.

**E-HL-3 — Colocaciones inválidas.** Con el estado inicial de E-HL-1:
- Dominó `(0,0)(1,0)` con ancla `(2,−4)`: la celda `(2,−4)` está ocupada → inválido, nada cambia.
- Dominó `(0,0)(1,0)` con ancla `(4,−4)`: la celda `(5,−4)` está fuera del tablero → inválido, nada cambia.

**E-HL-4 — Fin de partida.** Tablero con 52 celdas ocupadas y 9 vacías, ninguna línea completa y ninguna pareja de celdas vacías vecina:

```
    X X X X .    r=-4
   . X X X X X    r=-3
  X X X . X X X    r=-2
 X X X X X X . X    r=-1
X X . X X X X X X    r=+0
 . X X X X X X X    r=+1
  X X X X X X .    r=+2
   X X X X . X    r=+3
    X . X X X    r=+4
```

- Bandeja = {dominó, línea de 3, triángulo de 3} → ninguna cabe en ninguna posición → **fin de partida**.
- Bandeja = {dominó, línea de 3, mono} → el mono cabe → **la partida continúa**.
