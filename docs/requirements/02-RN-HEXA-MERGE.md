# 02 — Reglas de negocio: Hexa Merge (`hexa-merge`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/`) |
| Responsable | _(por asignar)_ |
| Fuente principal | Enunciado §1.4 y §1.5 |
| Convenciones | Ver `02-RN-COMUNES.md` §0 (estados ✅/🟡/⚠️, notación, topología) |

## 1. Resumen

Partida **sin fin**, estilo 2048. El jugador desliza el tablero en una de las direcciones de la topología (6 en hexágonos). Todas las fichas avanzan hasta el borde o hasta otra ficha, y dos fichas iguales que chocan se fusionan en una de valor doble. Tras cada movimiento válido aparece una ficha nueva (2 o 4). Se gana al aparecer la ficha objetivo (2048 por defecto) y se puede seguir jugando. Se pierde cuando ningún deslizamiento cambia el tablero.

| Dimensión (tabla 1.5) | Valor en Hexa Merge |
|---|---|
| Contenido de la celda | Vacía o un **entero** (potencia de 2) |
| Forma del tablero | Según la topología; en hexágonos, **radio 2** |
| Topología | La que eligió el jugador al crear la partida (RN-TOP-30, 31). Los ejemplos de este documento usan **hexágonos** |

| Fuente de piezas | **Generador aleatorio** con semilla (fichas 2 / 4) |
| Tipo de movimiento | **Deslizar en una dirección** |
| Regla de resolución | **Fusión por choque** |
| Fin de partida | **Ficha objetivo** (victoria) / **sin movimientos** (derrota) |
| Modelo de progreso | **Puntaje máximo** |
| Deshacer | **Sí, 1 movimiento** |

## 2. Contenido de la celda

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-01 | Cada celda está **vacía** o contiene una **ficha** con un valor potencia de 2 (2, 4, 8, …) | Enunciado §1.4 | ✅ |

## 3. Forma del tablero e inicio

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-10 | El tablero por defecto depende de la topología (`02-RN-TOPOLOGIAS.md`, RN-TOP-12); en hexágonos es de **radio 2** (19 celdas). Es configurable | Enunciado §1.4 | ✅ |
| RN-HM-11 | La partida empieza con **2 fichas** generadas con la regla de ficha nueva (RN-HM-21) | HU HM-01 | 🟡 |

## 4. Fuente: ficha nueva

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-20 | Después de cada **movimiento válido** aparece **una** ficha nueva en una celda vacía al azar | Enunciado §1.4 | ✅ |
| RN-HM-21 | **Celda:** la de índice `siguiente() mod (celdas vacías)`, contando las celdas vacías en orden de lectura. **Valor:** 4 si `siguiente() mod 100 < 10`; si no, 2 (90 % de 2, 10 % de 4) | Equipo | ✅ D-13 (11-11) |
| RN-HM-22 | La generación usa el generador inyectable con semilla (RN-COM-40) para que el juego se pueda probar de forma determinista | Enunciado §1.4 | ✅ |

## 5. Movimiento y validación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-30 | El movimiento es **deslizar** en una de las **direcciones** de la topología (6 en hexágonos: E, O, NE, NO, SE, SO) | Enunciado §1.4 | ✅ |
| RN-HM-31 | Un deslizamiento es **válido** solo si **cambia el tablero** (alguna ficha se mueve o se fusiona). Si no lo cambia, no cuenta como movimiento, no suma puntos y **no aparece ficha nueva** | Enunciado §1.4, HU HM-01 | ✅ |

## 6. Resolución: deslizar y fusionar

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-40 | Cada **línea** del eje de la dirección se procesa por separado. Dentro de una línea, las fichas se recorren desde el **frente** (la celda más avanzada en la dirección) hacia atrás, ignorando las celdas vacías | Enunciado §1.4 | ✅ |
| RN-HM-41 | Recorriendo esa secuencia: si las **dos primeras fichas pendientes** tienen el mismo valor, se fusionan en una de valor doble y se avanza dos posiciones; si no, la primera queda igual y se avanza una. Las fichas resultantes se colocan **pegadas al frente**, en ese orden | Enunciado §1.4, HU HM-02 | ✅ |
| RN-HM-42 | Cada ficha participa **como máximo en una fusión por movimiento**: una ficha recién fusionada no vuelve a fusionarse en el mismo deslizamiento. Con tres iguales en línea, se fusionan primero las **más cercanas al frente** | HU HM-02 | ✅ |
| RN-HM-43 | Orden del turno: deslizar y fusionar → ficha nueva → evaluar victoria → evaluar derrota | Diseño, RN-COM-20 | 🟡 |

## 7. Fin de partida

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-50 | **Victoria:** aparece una ficha con valor **igual o mayor** a la ficha objetivo (**2048** por defecto, configurable) | Enunciado §1.4 | ✅ |
| RN-HM-51 | Tras la victoria, el jugador elige **seguir jugando** o **nueva partida**. Si sigue, la partida continúa sin volver a anunciar la victoria y conserva su puntaje. Si deshace la jugada ganadora y vuelve a llegar a la ficha objetivo, la victoria se anuncia otra vez (RN-HM-83, D-115) | Enunciado §5.1 (P-06), D-115 | ✅ |
| RN-HM-52 | **Derrota:** ninguna de las direcciones cambia el tablero | Enunciado §1.4 | ✅ |
| RN-HM-53 | En la topología hexagonal, RN-HM-52 equivale a: **no hay celdas vacías y ninguna ficha tiene una vecina de igual valor** (todas las vecinas están en algún eje). Se puede usar como optimización | Consecuencia | ✅ |

## 8. Puntuación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-60 | Cada fusión suma al puntaje **el valor de la ficha producida** (2 + 2 → suma 4) | Enunciado §1.4 | ✅ |
| RN-HM-61 | Las fichas nuevas no suman puntos | Enunciado §1.4 | ✅ |

## 9. Progreso

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-70 | Se muestran el **puntaje actual** y el **récord**. Al terminar la partida (derrota, nueva partida o salir), si el puntaje supera el récord, el récord se actualiza y se guarda | Enunciado §5.1, HU HM-05 | ✅ |

## 10. Deshacer

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HM-80 | Se puede deshacer **solo el último** movimiento válido: vuelven el tablero, el puntaje, la ficha nueva (desaparece) y el **estado del generador** (RN-COM-42) | Enunciado §1.5, HU HM-04 | ✅ |
| RN-HM-81 | Después de deshacer, el botón queda **deshabilitado** hasta el próximo movimiento válido. Al inicio de la partida también está deshabilitado | HU HM-04 | ✅ |
| RN-HM-82 | Como se restaura el generador, repetir el mismo movimiento después de deshacer produce **la misma ficha nueva** en la misma celda (deshacer no sirve para "volver a tirar los dados") | Diseño | 🟡 |
| RN-HM-83 | No se puede deshacer después de la derrota (RN-COM-63). Sí se puede mientras se sigue jugando tras la victoria, **incluida la jugada ganadora**: deshacerla vuelve al estado anterior a la victoria | RN-COM-63, D-115 | 🟡 |

## 11. Notificaciones

**Deslizamiento** (dirección) → **fusiones** (celda, valor) × N → **ficha nueva** (celda, valor) → **puntaje actualizado** → **victoria** (solo la primera vez) / **derrota**. El puntaje va después de los eventos de las reglas porque lo publica el motor con el total del turno (D-94, D-140).

## 12. Casos borde

| Caso | Resultado |
|---|---|
| `[2, 2, 2, 2]` hacia el frente | `[4, 4]` (dos fusiones independientes) |
| `[4, 2, 2]` hacia el frente | `[4, 4]` (el 4 nuevo **no** se fusiona con el 4 original en el mismo movimiento) |
| Deslizar sin que nada se mueva ni se fusione | Movimiento inválido: sin ficha nueva, deshacer no cambia |
| Aparece 4096 sin haber pasado por la victoria (objetivo 2048) | Imposible: los valores se duplican de a uno; la victoria se anunció al aparecer 2048 |
| Tablero lleno pero con dos vecinas iguales | No es derrota: hay al menos un movimiento válido |

## 13. Ejemplos (se convierten en pruebas)

Tablero de radio 2; los valores se muestran en su celda. Todos los resultados se verificaron con el simulador de referencia. Los ejemplos de deslizamiento **no incluyen la ficha nueva**, que se prueba aparte (E-HM-6).

**E-HM-1 — Fusión y desplazamiento hacia el E.**

```
Antes                          Después de deslizar E
      .   .   .                      .   .   .
    .   .   .   .                  .   .   .   .
  2   .   2   4   4              .   .   .   4   8
    .   .   .   .                  .   .   .   .
      .   .   .                      .   .   .
```

Fila `r = 0` desde el frente (E): `4, 4, 2, 2` → `8, 4`. Puntos: 8 + 4 = **12**.

**E-HM-2 — Una fusión por ficha.**

| Fila `r = 0` (desde O hacia E) | Deslizar E | Puntos |
|---|---|---|
| `. 2 2 2 .` | `. . . 2 4` | 4 |
| `2 2 2 2 .` | `. . . 4 4` | 8 |
| `. 4 2 2 .` | `. . . 4 4` | 4 |

**E-HM-3 — Diagonal NE.**

```
Antes                          Después de deslizar NE
      .   .   4                      .   .   4
    .   .   .   .                  .   .   4   .
  .   .   2   .   .              .   .   8   .   .
    .   2   .   .                  .   .   .   .
      8   .   .                      .   .   .
```

La línea `s = 0` desde el frente (NE): `4, 2, 2, 8` → `4, 4, 8`. Puntos: **4**. El 4 producido no se fusiona con el 4 que ya estaba (RN-HM-42).

**E-HM-4 — Movimiento inválido.** Fichas en `(2,0)` = 2, `(1,1)` = 4 y `(2,−1)` = 8 (todas pegadas al borde E de su fila). Deslizar E **no cambia** el tablero → inválido, sin ficha nueva. Deslizar O **sí** lo cambia → válido.

**E-HM-5 — Derrota.** Tablero lleno con el patrón `(q − r) mod 3` → 0 = 2, 1 = 4, 2 = 8, que nunca pone dos valores iguales como vecinos:

```
      8   2   4
    2   4   8   2
  4   8   2   4   8
    2   4   8   2
      8   2   4
```

Ninguna de las 6 direcciones cambia el tablero → **derrota**.

**E-HM-6 — Inicio determinista.** Con semilla `12345` y xorshift32 (E-COM-1), tablero vacío de 19 celdas:
1. Primera ficha: `3336926330 mod 19 = 11` → celda `(2,0)`; `1697253807 mod 100 = 7` < 10 → valor **4**.
2. Segunda ficha: `2816511904 mod 18 = 10` → celda `(1,0)`; `1955480042 mod 100 = 42` → valor **2**.

```
      .   .   .
    .   .   .   .
  .   .   .   2   4
    .   .   .   .
      .   .   .
```

**E-HM-7 — Deshacer.** Desde el tablero "Después" de E-HM-1 (puntaje 12): deslizar O, deshacer → vuelven el tablero "Después" de E-HM-1, el puntaje 12 y el estado del generador; deshacer queda deshabilitado. Volver a deslizar O produce exactamente la misma ficha nueva que la primera vez.
