# 02 — Reglas de negocio: topologías

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/02-RN-TOPOLOGIAS.md`) |
| Relacionados | `02-RN-COMUNES.md` (formato y notación), `02-RN-HEXA-*.md` |

**Por qué existe este documento:** el profesor avisó que la forma de las celdas puede cambiar antes de la entrega: triángulos, cuadrados o incluso **cubos en 3D**. Por eso la topología es un **punto de extensión** del motor. Las reglas de las variantes solo usan los conceptos de la sección 1. Lo propio de cada forma de celda está en un anexo, y cambiar de topología no modifica el motor ni las reglas de las variantes.

---

## 1. Conceptos que toda topología debe definir

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-10 | Toda variante usa la topología **solo** a través de estas operaciones: celdas de una **forma de tablero**; **vecinas** de una celda, en su **orden canónico**; **ejes** y **líneas** ordenadas; **direcciones** y **rayos**; **giros básicos** y **normalización** de una forma; **orden canónico de celdas** | Diseño (aviso del profesor 11-11) | ✅ |
| RN-COM-11 | Dos celdas son **vecinas** si comparten una cara: un **lado** en 2D, una **cara** en 3D | Glosario | ✅ |
| RN-COM-12 | Una **línea** es la secuencia de todas las celdas del tablero alineadas en un mismo **eje**, de un borde al otro, en un orden fijo. En un tablero con forma arbitraria (Hexa Fit) una línea puede tener huecos; Hexa Fit no usa líneas | Enunciado §1.1 | ✅ |
| RN-COM-13 | Una **dirección** es un eje más un sentido. El **rayo** desde una celda en una dirección es la secuencia de celdas que siguen a esa celda en su línea, en ese sentido, hasta el borde | Glosario | ✅ |
| RN-COM-14 | Cada topología define sus **giros básicos**. En 2D hay **uno**: un paso en sentido horario (60° en hexágonos y triángulos, 90° en cuadrados). En 3D hay **tres**: 90° sobre cada eje. Rotar una forma = aplicar un giro básico y normalizar. Las **orientaciones** de una forma son todas las distintas que se obtienen combinando giros básicos (hasta 6 en hexágonos y triángulos, 4 en cuadrados, 24 en cubos) | Enunciado §1.2, aviso del profesor | ✅ |
| RN-COM-15 | **Normalizar** una forma es trasladarla para que su primera celda en orden canónico quede en el **origen de su tipo** (en triángulos hay dos tipos de celda, ▲ y ▼; ver Anexo B). Dos formas son la misma orientación si sus versiones normalizadas son iguales | Diseño | 🟡 |
| RN-COM-16 | **Orden canónico de celdas** (u "orden de lectura"): en 2D, por fila (de arriba hacia abajo) y luego por columna (de izquierda a derecha); en 3D, por capa (de abajo hacia arriba), luego fila y luego columna. Es el desempate entre celdas cuando una regla no dice otra cosa | Diseño (determinismo) | 🟡 |
| RN-COM-17 | **Orden canónico de vecinas:** en 2D es el **orden horario** alrededor de la celda, empezando por la primera vecina a partir de las 12 en punto. En 3D no existe un reloj, así que el orden es una **lista fija** definida en el anexo de la topología | Equipo | ✅ D-15 (11-11) |
| RN-COM-18 | **Solo rejillas regulares:** todas las celdas iguales y líneas rectas en cada eje. Se soportan **triángulos, cuadrados y hexágonos** (las tres únicas figuras regulares que cubren el plano) y **cubos** en 3D. Otras figuras (pentágonos, mezclas) quedan fuera de alcance porque en ellas no existen líneas ni direcciones, y Hexa Lines y Hexa Merge pierden sentido | Equipo | ✅ D-18 (11-11) |
| RN-COM-19 | La **topología** de una partida la elige el **jugador** entre las disponibles (RN-TOP-30 a 33); la **forma del tablero** de cada variante y topología sale de la configuración (§3). Agregar una topología requiere: su anexo en este documento, su implementación en el dominio, su dibujo en la presentación, su catálogo de piezas (Lines), sus tableros por defecto y, para Hexa Fit, sus niveles. **No** requiere cambiar el motor ni las reglas de las variantes | Enunciado §3.1, decisión del equipo (D-25) | ✅ D-25 (11-11) |

## 2. Alcance de cada topología

| ID | Topología | Dominio (reglas + pruebas) | Presentación (jugable en la app) | Estado |
|---|---|---|---|---|
| RN-TOP-01 | **Hexágonos** | **Must** | **Must** | ✅ D-18 (11-11) |
| RN-TOP-02 | **Cuadrados** | **Should** | **Should** (dibujo 2D) | ✅ D-18 (11-11) |
| RN-TOP-03 | **Triángulos** | **Should** | **Should** (dibujo 2D) | ✅ D-18 (11-11) |
| RN-TOP-04 | **Cubos (3D)** | **Should** (las 4 variantes resuelven tableros 3D en pruebas) | **Could** (vista isométrica o 3D) | ✅ D-18 (11-11) |

> **Motivo del nivel de los cubos:** las reglas se adaptan con los conceptos de la sección 1, pero dibujar, arrastrar y tocar en 3D es caro y arriesgado para el plazo. Si el jurado pide 3D, el dominio ya lo resuelve (con pruebas como demostración) y lo que falta es una implementación nueva de la capa de presentación, que por Clean Architecture está aislada.

## 2b. Elección de la figura por el jugador

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-TOP-30 | En **Ajustes** existe la opción **"Figura de las celdas"**. Solo muestra las topologías **disponibles**: las que tienen dominio y presentación implementados (hexágonos siempre; cuadrados, triángulos y cubos cuando estén listos). Valor por defecto: **hexágonos**. La elección se guarda entre sesiones | Equipo | ✅ D-25 (11-11) |
| RN-TOP-31 | La figura se **fija al crear la partida** y queda guardada en su estado. **No se puede cambiar durante la partida**: mientras haya una partida en curso o en pausa, la opción aparece bloqueada con un aviso. Cambiarla desde el inicio afecta solo a la **próxima** partida. Una partida guardada se reanuda siempre con su propia figura | Equipo | ✅ D-25 (11-11) |
| RN-TOP-32 | La figura elegida es **una sola para todo el juego** (las 4 variantes) | Equipo | ⚠️ D-26 (propuesta) |
| RN-TOP-33 | El **progreso, el récord y el ranking** se separan **por figura** (clave: perfil, `gameId` y topología), porque los tableros y la dificultad no son comparables | Equipo | ⚠️ D-27 (propuesta) |
| RN-TOP-34 | **Niveles por figura.** Un nivel de Hexa Fit pertenece a una topología (su figura está hecha de esas celdas). Un nivel de Hexa Sort **sin pilas iniciales** sirve para **cualquier** topología (usa el tablero por defecto, §3). Si una variante por niveles no tiene niveles para la figura elegida, su tarjeta dice **"No disponible con esta figura"**. Los mínimos del enunciado (15 de Fit y 10 de Sort) se cumplen con **hexágonos**; para las otras figuras basta con niveles de muestra | Equipo | ⚠️ D-28 (propuesta) |

> **Relación con D-07 (opción A):** como la coordenada es un parámetro genérico, una partida creada con `HexCoord` no puede pasar a otra figura; el bloqueo de RN-TOP-31 lo garantiza también el compilador.

## 3. Tableros por defecto

| ID | Variante | Hexágonos | Cuadrados | Triángulos | Cubos |
|---|---|---|---|---|---|
| RN-TOP-10 | Hexa Lines | Radio 4 (61 celdas) | 8 × 8 (64) | Hexágono de lado 3 (54) | 4 × 4 × 4 (64) |
| RN-TOP-11 | Hexa Sort | Radio 2 (19) | 4 × 5 (20) | Hexágono de lado 2 (24) | 3 × 3 × 3 (27) |
| RN-TOP-12 | Hexa Merge | Radio 2 (19) | 4 × 4 (16, como el 2048 clásico) | Hexágono de lado 2 (24) | 3 × 3 × 3 (27) |
| RN-TOP-13 | Hexa Fit | Figura del nivel | Figura del nivel | Figura del nivel | Figura del nivel |

Estado: 🟡 (los de hexágonos son ✅ por el enunciado). Se ajustan jugando; son configuración.

## 4. Catálogo de piezas de Hexa Lines por topología

| ID | Topología | Catálogo | Estado |
|---|---|---|---|
| RN-TOP-20 | Hexágonos | `02-RN-HEXA-LINES.md`, RN-HL-23 (8 familias, 24 piezas) | ✅ D-08 |
| RN-TOP-21 | Cuadrados | Propuesta: mono, dominó, línea de 3, L de 3, línea de 4, cuadrado 2 × 2, L de 4, T de 4, línea de 5 (sin rotación: cada orientación es una pieza) | ⚠️ D-20 |
| RN-TOP-22 | Triángulos | Se define al implementar la topología | ⚠️ D-20 |
| RN-TOP-23 | Cubos | Se define al implementar la topología | ⚠️ D-20 |

---

## Anexo A — Hexágonos

| ID | Regla | Estado |
|---|---|---|
| RN-HEX-01 | Celdas hexagonales con **vértice hacia arriba** (*pointy-top*), en **coordenadas axiales** `(q, r)`, con `s = −q − r` | 🟡 |
| RN-HEX-02 | **Direcciones** (`dq, dr`): E `(+1, 0)`, O `(−1, 0)`, NE `(+1, −1)`, SO `(−1, +1)`, NO `(0, −1)`, SE `(0, +1)` | ✅ |
| RN-HEX-03 | **Vecinas:** las 6 celdas que se obtienen sumando cada dirección (las que estén dentro del tablero) | ✅ |
| RN-HEX-04 | **Ejes y líneas:** eje **r** = filas horizontales (`r` constante, recorridas E–O); eje **q** = `q` constante (recorridas NO–SE); eje **s** = `s` constante (recorridas NE–SO) | ✅ |
| RN-HEX-05 | **Tablero hexagonal de radio R:** todas las celdas con `max(|q|, |r|, |s|) ≤ R`. Tiene `3R(R+1) + 1` celdas y `2R + 1` líneas por eje, de largos R+1, R+2, …, 2R+1, …, R+1 | ✅ |
| RN-HEX-06 | **Giro básico (60° horario):** `(q, r, s) → (−r, −s, −q)`. Seis giros devuelven la forma original | ✅ |
| RN-HEX-07 | **Distancia** entre dos celdas: `(|Δq| + |Δr| + |Δs|) / 2` | ✅ |
| RN-HEX-08 | **Orden de vecinas** (horario desde las 12): NE (≈ 1 en punto), E (3), SE (5), SO (7), O (9), NO (11) | ✅ |

| Radio | Celdas | Líneas por eje | Largos de las líneas | Total de líneas |
|---|---|---|---|---|
| 2 (Sort, Merge) | 19 | 5 | 3, 4, 5, 4, 3 | 15 |
| 4 (Lines) | 61 | 9 | 5, 6, 7, 8, 9, 8, 7, 6, 5 | 27 |

**E-HEX-1 (rotación).** La forma "arco de 3" `{(0,0), (1,0), (1,1)}` rotada un paso da `{(0,0), (0,1), (−1,2)}` (ya normalizada). Rotada seis veces vuelve a `{(0,0), (1,0), (1,1)}`.

## Anexo B — Triángulos

| ID | Regla | Estado |
|---|---|---|
| RN-TRI-01 | Celdas en **filas** `y` (de arriba hacia abajo) y **columnas** `x`. La celda `(x, y)` es **▲** (apunta hacia arriba) si `x + y` es par y **▼** si es impar | 🟡 |
| RN-TRI-02 | **Índices de línea** de una celda: **F** = `y` (fila), **D** = `⌊(x + y) / 2⌋` (diagonal ↗), **A** = `⌊(y − x) / 2⌋` (diagonal ↖). Se cumple siempre que `x = D − A` y `y = F`, y que `F − D − A` vale 0 en ▲ y 1 en ▼ | ✅ (verificado) |
| RN-TRI-03 | **Vecinas** (3): una ▲ tiene a la izquierda `(x − 1, y)`, a la derecha `(x + 1, y)` y abajo `(x, y + 1)`. Una ▼ tiene izquierda, derecha y arriba `(x, y − 1)` | ✅ (verificado) |
| RN-TRI-04 | **Ejes y líneas** (3): todas las celdas con el mismo **F** (fila, recorrida E–O), el mismo **D** (recorrida NE–SO) o el mismo **A** (recorrida NO–SE). Cada línea alterna ▲ y ▼ | ✅ (verificado) |
| RN-TRI-05 | **Direcciones** (6): E y O sobre F; NE y SO sobre D; NO y SE sobre A | ✅ |
| RN-TRI-06 | **Giro básico (60° horario alrededor de un vértice):** en índices, `(F, D, A) → (D, −A − 1, F)`; luego `x = D − A`, `y = F`. Convierte ▲ en ▼ y viceversa. Seis giros devuelven la forma original | ✅ (verificado) |
| RN-TRI-07 | **Normalización:** solo se traslada con desplazamientos `(dx, dy)` donde `dx + dy` es **par** (para no cambiar ▲ por ▼). La primera celda en orden canónico se lleva a `(0, 0)` si es ▲, o a `(1, 0)` si es ▼ | 🟡 |
| RN-TRI-08 | **Orden de vecinas** (horario desde las 12): en ▲, derecha (≈ 2 en punto), abajo (6), izquierda (10). En ▼, arriba (12), derecha (4), izquierda (8) | ✅ |
| RN-TRI-09 | **Tablero "hexágono de lado n":** las celdas con `−n ≤ F ≤ n − 1`, `−n ≤ D ≤ n − 1` y `−n ≤ A ≤ n − 1`. Tiene `6n²` celdas (mitad ▲, mitad ▼), `2n` líneas por eje, y no cambia al girarlo | ✅ (verificado) |

| Lado | Celdas | Líneas por eje | Largos de las líneas |
|---|---|---|---|
| 2 (Sort, Merge) | 24 | 4 | 5, 7, 7, 5 |
| 3 (Lines) | 54 | 6 | 7, 9, 11, 11, 9, 7 |

**E-TRI-1 (tablero de lado 2).**

```
 ▲▼▲▼▲     y=-2
▲▼▲▼▲▼▲    y=-1
▼▲▼▲▼▲▼    y=+0
 ▼▲▼▲▼     y=+1
```

**E-TRI-2 (giro).** Girando la celda ▲ `(0, 0)` un paso cada vez se obtiene: `(−1, 0)` → `(−1, −1)` → `(0, −1)` → `(1, −1)` → `(1, 0)` → `(0, 0)` (seis giros, vuelve al inicio, alternando ▼ y ▲). Girar mantiene las vecindades: dos celdas vecinas siguen siendo vecinas.

## Anexo C — Cuadrados

| ID | Regla | Estado |
|---|---|---|
| RN-SQR-01 | Celdas en coordenadas `(x, y)`: `x` crece hacia la derecha e `y` hacia abajo | 🟡 |
| RN-SQR-02 | **Direcciones** (4): N `(0, −1)`, E `(+1, 0)`, S `(0, +1)`, O `(−1, 0)` | ✅ |
| RN-SQR-03 | **Vecinas** (4): las que comparten un lado (no las diagonales) | 🟡 |
| RN-SQR-04 | **Ejes y líneas** (2): filas (`y` constante, recorridas E–O) y columnas (`x` constante, recorridas N–S) | ✅ |
| RN-SQR-05 | **Giro básico (90° horario):** `(x, y) → (−y, x)`. Cuatro giros devuelven la forma original | ✅ |
| RN-SQR-06 | **Orden de vecinas** (horario desde las 12): N, E, S, O | ✅ |
| RN-SQR-07 | **Tablero rectangular** de `ancho × alto` | ✅ |

**E-SQR-1 (giro).** La "L de 3" `{(0,0), (0,1), (1,1)}` girada un paso da `{(0,0), (−1,0), (−1,1)}`, que normalizada es `{(0,0), (1,0), (0,1)}`. Los giros siguientes dan `{(0,0), (1,0), (1,1)}`, `{(0,0), (−1,1), (0,1)}` y, al cuarto, la original.

## Anexo D — Cubos (3D)

| ID | Regla | Estado |
|---|---|---|
| RN-CUB-01 | Celdas en coordenadas `(x, y, z)`: `x` hacia el este, `y` hacia el sur, `z` hacia arriba (capas) | 🟡 |
| RN-CUB-02 | **Direcciones** (6): E/O `(±1, 0, 0)`, S/N `(0, ±1, 0)`, Arriba/Abajo `(0, 0, ±1)` | ✅ |
| RN-CUB-03 | **Vecinas** (6): las que comparten una cara | ✅ |
| RN-CUB-04 | **Ejes y líneas** (3): `x`, `y` y `z` | ✅ |
| RN-CUB-05 | **Giros básicos** (3, de 90°): sobre `z` (horario visto desde arriba) `(x, y, z) → (−y, x, z)`; sobre `x`: `(x, y, z) → (x, −z, y)`; sobre `y`: `(x, y, z) → (z, y, −x)`. Combinados producen las **24** orientaciones del cubo. En Hexa Fit, el movimiento "rotar" indica **sobre qué eje** | ✅ (verificado) |
| RN-CUB-06 | **Orden de vecinas** (lista fija): N, E, S, O (horario dentro de la capa), luego Arriba, Abajo | 🟡 |
| RN-CUB-07 | **Tablero en caja** de `ancho × alto × profundidad` | ✅ |

**E-CUB-1 (orientaciones).** Combinando los tres giros básicos se obtienen exactamente **24** orientaciones distintas del cubo; cualquier combinación de 4 giros iguales sobre el mismo eje devuelve la original.
