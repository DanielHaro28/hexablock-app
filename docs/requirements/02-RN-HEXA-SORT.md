# 02 — Reglas de negocio: Hexa Sort (`hexa-sort`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/`) |
| Responsable | _(por asignar)_ |
| Fuente principal | Enunciado §1.3 y §1.5 |
| Convenciones | Ver `02-RN-COMUNES.md` §0 (estados ✅/🟡/⚠️, notación, topología) |

> **Es la variante más ambigua del enunciado.** Las reglas de la sección 6 fijan un algoritmo **determinista** (siempre el mismo resultado para la misma situación). Donde el enunciado no lo especifica, el profesor indicó que decide el equipo: ver D-15, D-16 y D-17 en `PENDIENTES.md`.

## 1. Resumen

Juego **por niveles**. Cada celda puede tener una **pila de fichas de colores**. El jugador coloca en una celda vacía la pila que ofrece la bandeja. Las fichas del mismo color que quedan en la cima de pilas vecinas se transfieren **en cascada** hacia la pila con más fichas de ese color. Cuando una pila junta **10 fichas del mismo color** en la cima, se eliminan y se cumple una **meta**. Se gana al cumplir las metas del nivel y se pierde si el tablero se llena.

| Dimensión (tabla 1.5) | Valor en Hexa Sort |
|---|---|
| Contenido de la celda | **Pila de colores** (puede estar vacía) |
| Forma del tablero | Según la topología; en hexágonos, **radio 2** |
| Topología | La que eligió el jugador al crear la partida (RN-TOP-30, 31). Los ejemplos de este documento usan **hexágonos** |

| Fuente de piezas | **Generador aleatorio** con semilla (del nivel) |
| Tipo de movimiento | **Colocar pila** |
| Regla de resolución | **Transferencia en cascada** |
| Fin de partida | **Metas cumplidas** (victoria) / **tablero lleno** (derrota) |
| Modelo de progreso | **Niveles** (sin estrellas) |
| Deshacer | **No** |

## 2. Contenido de la celda

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-01 | Cada celda contiene una **pila**: secuencia ordenada de fichas de colores, **de abajo hacia arriba**. Una pila sin fichas es una celda **vacía** | Enunciado §1.3 | ✅ |
| RN-HS-02 | El **bloque de cima** de una pila es el grupo de fichas **consecutivas del mismo color** en su parte de arriba. Su **color** es el de la cima y su **tamaño**, la cantidad de esas fichas. En `GRRB` el bloque es `B` (1); en `GRR` es `RR` (2) | Glosario | 🟡 |

## 3. Forma del tablero y definición del nivel

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-10 | El tablero por defecto depende de la topología (`02-RN-TOPOLOGIAS.md`, RN-TOP-11); en hexágonos es de **radio 2** (19 celdas). Es configurable | Enunciado §1.3 | ✅ |
| RN-HS-11 y 12 | Formato y validaciones del nivel → **`02-RN-NIVELES.md`** (documento compartido con el backend) | — | — |

## 4. Fuente de pilas y bandeja

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-20 | La bandeja ofrece **una pila a la vez**. Al colocarla, se genera la siguiente | Enunciado §1.3 (P-03) | ✅ |
| RN-HS-21 | **Generación de una pila** (con el generador del nivel), en este orden: (1) altura `h` = `altMin` + `siguiente() mod (altMax − altMin + 1)`; (2) número de bloques `n` = 1 + `siguiente() mod min(bloquesMax, h)`; (3) cada bloque empieza con 1 ficha y las `h − n` restantes se reparten de a una: cada una va al bloque `siguiente() mod n`; (4) el color de cada bloque, **de abajo hacia arriba**: el primero es `paleta[siguiente() mod tamaño]`; cada uno de los siguientes se elige **entre los colores de la paleta menos el del bloque anterior**, en el orden de la paleta, con `siguiente() mod (tamaño − 1)`. Cada pila gasta siempre 2 + (`h` − `n`) + `n` números. Valores sugeridos: `altMin` = 2, `altMax` = 6, `bloquesMax` = 3. Ejemplo: E-HS-GEN | Equipo | ✅ D-11 (11-11); precisión D-60 (20-11) |
| RN-HS-22 | Como `altMax` < 10, una pila recién generada nunca cumple una meta por sí sola | Consecuencia de RN-HS-21 | ✅ |

## 5. Movimiento y validación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-30 | El único movimiento es **colocar la pila de la bandeja en una celda vacía** | Enunciado §1.3 | ✅ |
| RN-HS-31 | Colocar en una celda ocupada es **inválido** y no cambia nada (RN-COM-21) | HU HS-02 | ✅ |

## 6. Resolución: transferencia en cascada

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-40 | Una **transferencia** mueve el **bloque de cima completo** de una pila (origen) a la cima de otra (destino) **cuyo bloque de cima es del mismo color**. Las fichas conservan su orden | Enunciado §1.3 | ✅ D-17 (11-11) |
| RN-HS-41 | La "pila con mayor cantidad de ese color" es la que tiene el **bloque de cima más grande** de ese color (no se cuentan fichas de ese color que estén debajo de otros colores) | Enunciado §1.3 | ✅ D-17 (11-11) |
| RN-HS-42 | **Algoritmo.** Se usa una **cola de celdas por evaluar**, que empieza con la celda recién colocada. Mientras la cola no esté vacía: (1) se saca la primera celda `c`; si está vacía, se pasa a la siguiente; (2) se buscan las **vecinas** de `c` con pila cuyo color de cima es igual al de `c`; si no hay, se pasa a la siguiente; (3) el **grupo** es `c` más esas vecinas; (4) el **destino** es la pila del grupo con el bloque de cima más grande; (5) cada otra pila del grupo (**origen**) transfiere su bloque al destino, en este orden: primero `c` (si es origen) y luego las vecinas en el **orden canónico de vecinas** de `c` (RN-COM-17: en 2D, el horario desde las 12); cada origen que no quedó vacío se **agrega a la cola**; (6) después de **cada** transferencia se revisa la meta (RN-HS-50); (7) al final, el destino se **agrega a la cola** (puede tener otras vecinas del mismo color) | Enunciado §1.3, HU HS-03 | 🟡 |
| RN-HS-43 | **Desempate del destino:** si varias pilas del grupo empatan con el bloque más grande y `c` es una de ellas, el destino es **`c`** (en el primer paso, la pila recién colocada). Si `c` no está entre las empatadas, el destino es la **primera vecina empatada en el orden canónico de vecinas** de `c` (RN-COM-17: en 2D, el horario desde las 12) | Equipo | ✅ D-15 (11-11) |
| RN-HS-44 | **Siempre termina:** cada transferencia une dos bloques en uno, así que el número total de bloques en el tablero baja en cada paso; y eliminar una meta también lo baja. Como ese número no puede bajar indefinidamente, la cascada termina | Enunciado §1.3 | ✅ |
| RN-HS-45 | Cada transferencia y cada meta se notifican **en orden**, para que la animación muestre la cascada paso a paso | HU HS-03, RN-COM-25 | ✅ |

## 7. Metas y fin de partida

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-50 | Si después de una transferencia el bloque de cima del destino tiene **10 o más** fichas, ese **bloque completo se elimina** del tablero (aunque tenga más de 10, por ejemplo 12) y se cumple **1 meta**. Si quedan fichas debajo, la pila sigue en la celda con su nueva cima | Enunciado §1.3, HU HS-04 | ✅ D-16 (11-11) |
| RN-HS-51 | Cuando el destino cumple una meta, su cima cambia: las pilas del grupo que **aún no transfirieron** se agregan a la cola para reevaluarse, y el destino también | Consecuencia de RN-HS-42 | 🟡 |
| RN-HS-52 | **Victoria:** al terminar la resolución, las metas cumplidas alcanzan las metas del nivel | Enunciado §1.3 | ✅ |
| RN-HS-53 | **Derrota:** al terminar la resolución, no hay victoria y **no queda ninguna celda vacía** (el único movimiento posible es colocar en una celda vacía) | Enunciado §1.3 (P-05) | ✅ |
| RN-HS-54 | Si en el mismo turno se alcanzan las metas y el tablero queda lleno, **gana la victoria** (RN-COM-23) | RN-COM-23 | 🟡 |

## 8. Puntuación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-60 | Puntos del turno = **fichas transferidas** en el turno (1 por ficha) + **100 por meta** cumplida en el turno | Equipo (Enunciado §5.1) | ✅ D-12 (11-11) |
| RN-HS-61 | La pantalla de victoria muestra los movimientos (pilas colocadas), las metas y el puntaje | Enunciado §5.1 | ✅ |

## 9. Progreso

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-70 | Completar un nivel lo marca como **completado** y desbloquea el siguiente (RN-COM-73). Hexa Sort **no** usa estrellas | Enunciado §1.5 | ✅ |
| RN-HS-71 | El **mejor intento** por nivel se compara por **movimientos ↑ → puntaje ↓** (menos pilas colocadas primero; el puntaje desempata), igual que el ranking por nivel (RN-COM-103) | Equipo | ✅ D-04 / D-12 (11-11) |
| RN-HS-72 | La selección de niveles muestra el estado de cada nivel (bloqueado, disponible, completado). Al abrir un nivel se ven las metas a cumplir, el tablero y la pila de la bandeja | HU HS-01 | ✅ |

## 10. Deshacer

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-80 | Hexa Sort **no** permite deshacer | Enunciado §1.5 | ✅ |

## 11. Notificaciones

**Pila colocada** → **transferencia** (origen, destino, color, cantidad) × N → **meta cumplida** (si corresponde) → **pila nueva en la bandeja** → **puntaje actualizado** → **victoria / derrota** (si corresponde). El puntaje va después de los eventos de las reglas porque el motor lo publica una vez por turno, con el total (D-94, D-140).

## 12. Casos borde

| Caso | Resultado |
|---|---|
| La pila colocada no tiene vecinas con su color de cima | No hay transferencias; se genera la pila siguiente |
| Un origen queda vacío tras transferir | La celda queda vacía y vuelve a estar disponible para colocar |
| Un bloque llega a 12 fichas (por ejemplo, 9 + 3) | Se elimina el bloque completo de 12 y cuenta **1** meta (RN-HS-50) |
| Se cumplen las metas a mitad de la cascada | La cascada **termina igual** (determinismo); la victoria se evalúa al final |
| Colocar en la última celda vacía sin transferencias | Tablero lleno → derrota (salvo que ya se hayan alcanzado las metas) |

## 13. Ejemplos (se convierten en pruebas)

Tablero de radio 2. Las pilas se escriben de abajo hacia arriba; `→` indica la celda donde se coloca la pila. Todos los resultados se verificaron con el simulador de referencia.

**E-HS-1 — Transferencia simple hacia la pila más grande.**

| Celda | Antes | Después |
|---|---|---|
| `(0,0)` → colocada | `BR` | `B` |
| `(1,0)` | `GRR` | `GRRRR` |
| `(0,1)` | `R` | _(vacía)_ |

Pasos: el grupo es `(0,0)` (R×1), `(1,0)` (R×2) y `(0,1)` (R×1); el destino es `(1,0)`. (1) 1×R de `(0,0)` a `(1,0)`; (2) 1×R de `(0,1)` a `(1,0)`. Ninguna otra coincidencia → fin.

**E-HS-2 — Empate con la pila colocada: gana la pila colocada (RN-HS-43).**

| Celda | Antes | Después |
|---|---|---|
| `(0,0)` → colocada | `RR` | `RRRR` |
| `(1,0)` | `GRR` | `G` |

Ambas tienen bloque R×2; `(0,0)` es la evaluada → es el destino.

**E-HS-3 — Cascada: una transferencia descubre otra coincidencia.**

| Celda | Antes | Después |
|---|---|---|
| `(0,0)` → colocada | `RR` | `RRR` |
| `(1,0)` | `BBR` | _(vacía)_ |
| `(2,0)` | `GBBB` | `GBBBBB` |

Pasos: (1) 1×R de `(1,0)` a `(0,0)` (destino: R×2 > R×1); `(1,0)` queda `BB` y se agrega a la cola. (2) Se evalúa `(1,0)`: su vecina `(2,0)` tiene cima B (B×3 > B×2) → 2×B de `(1,0)` a `(2,0)`.

**E-HS-4 — Meta.**

| Celda | Antes | Después |
|---|---|---|
| `(0,0)` → colocada | `BRRR` | `B` |
| `(1,0)` | `GRRRRRR` | `G` |
| `(0,1)` | `R` | _(vacía)_ |

Pasos: destino `(1,0)` (R×6). (1) 3×R de `(0,0)` → R×9. (2) 1×R de `(0,1)` → R×10 → **se eliminan las 10 R** → `(1,0)` queda `G`. **Metas: 1.** Puntos: 4 fichas transferidas + 100 = **104**.

**E-HS-5 — Meta antes de procesar todos los orígenes.**

| Celda | Antes | Después |
|---|---|---|
| `(0,0)` → colocada | `BRR` | `B` |
| `(1,0)` | `GRRRRRRRR` | `G` |
| `(0,1)` | `R` | `R` |

Pasos: destino `(1,0)` (R×8). (1) 2×R de `(0,0)` → R×10 → **meta**, `(1,0)` queda `G`. `(0,1)` todavía no transfirió: se agrega a la cola (RN-HS-51). Al evaluarla, ninguna vecina tiene cima R → queda `R`. **Metas: 1.**

**E-HS-8 — Empate entre vecinas: gana la primera en orden horario.**

| Celda | Antes | Después |
|---|---|---|
| `(0,0)` → colocada | `R` | _(vacía)_ |
| `(−1,0)` (al O) | `GRR` | `G` |
| `(1,0)` (al E) | `BRR` | `BRRRRR` |

Las dos vecinas tienen R×2 y la colocada R×1, así que gana una vecina. En orden horario desde las 12 (NE, E, SE, SO, O, NO), el E aparece antes que el O → destino `(1,0)`. Orígenes: primero `(0,0)` (1×R) y luego `(−1,0)` (2×R). _(Con orden de lectura habría ganado el O: este ejemplo prueba que se usa el orden horario.)_

**E-HS-6 — Celda ocupada.** Intentar colocar la pila de la bandeja en `(1,0)` con cualquier pila → inválido, nada cambia, la bandeja ofrece la misma pila.

**E-HS-7 — Victoria y derrota.**
- Nivel con 1 meta: el turno de E-HS-4 termina con 1 meta → **victoria**.
- Nivel con 3 metas, 18 celdas ocupadas y la pila de la bandeja sin coincidencias con las vecinas de la única celda vacía: colocarla llena el tablero sin metas nuevas → **derrota**.

**E-HS-GEN — Generación de una pila (RN-HS-21, D-60).** Semilla 3, paleta `[red, green, blue]`, `altMin` = 2, `altMax` = 6, `bloquesMax` = 3. Los seis primeros números del generador son 811107, 201886211, 3025432647, 1909268553, 1833517003 y 482289907.
- Altura: 2 + 811107 mod 5 = 2 + 2 = **4**.
- Bloques: 1 + 201886211 mod 3 = 1 + 2 = **3**.
- Reparto de la 1 ficha que sobra: 3025432647 mod 3 = 0 → al bloque 0. Tamaños **[2, 1, 1]**.
- Colores: 1909268553 mod 3 = 0 → `red`; entre `[green, blue]`, 1833517003 mod 2 = 1 → `blue`; entre `[red, green]`, 482289907 mod 2 = 1 → `green`.
- Pila, de abajo hacia arriba: **red, red, blue, green**. Se gastaron 6 números (2 + 1 + 3).
- _Si se sorteara de nuevo al repetir el color (la opción descartada en D-60), el tercer bloque saldría `green` dos veces, gastaría 5 números de color en vez de 3 y todas las pilas siguientes cambiarían._
