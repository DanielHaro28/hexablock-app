# 02 — Reglas de negocio: Hexa Fit (`hexa-fit`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/`) |
| Responsable | _(por asignar)_ |
| Fuente principal | Enunciado §1.2 y §1.5 |
| Convenciones | Ver `02-RN-COMUNES.md` §0 (estados ✅/🟡/⚠️, notación, topología) |

## 1. Resumen

Rompecabezas **por niveles**. Cada nivel define una **figura** y un conjunto fijo de piezas cuya área total es igual a la de la figura. El jugador debe cubrir la figura completa, sin huecos ni solapamientos, rotando las piezas (en pasos de 60° en hexágonos). No hay derrota: puede retirar, mover, deshacer y rehacer sin límite. Al completar el nivel obtiene de 1 a 3 estrellas: una por completarlo, otra por hacerlo en pocos movimientos y otra por hacerlo rápido.

| Dimensión (tabla 1.5) | Valor en Hexa Fit |
|---|---|
| Contenido de la celda | Vacía u ocupada por un **identificador de pieza** |
| Forma del tablero | **Figura arbitraria** definida por el nivel |
| Topología | La que eligió el jugador al crear la partida (RN-TOP-30, 31). Los ejemplos de este documento usan **hexágonos** |

| Fuente de piezas | **Lista fija** del nivel |
| Tipo de movimiento | **Colocar / retirar / mover / rotar** pieza |
| Regla de resolución | **Ninguna** (solo se valida la cobertura) |
| Fin de partida | **Figura cubierta** (victoria); sin derrota |
| Modelo de progreso | **Niveles con estrellas** |
| Deshacer | **Sí, ilimitado + rehacer** |

## 2. Contenido de la celda

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-01 | Cada celda de la figura está **vacía** u **ocupada por el identificador de la pieza** que la cubre. Las celdas fuera de la figura **no existen** en el tablero de ese nivel | Enunciado §1.5 | ✅ |

## 3. Forma del tablero y definición del nivel

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-10 | El tablero de cada nivel es su **figura**: un conjunto arbitrario de celdas de la topología | Enunciado §1.2 | ✅ |
| RN-HF-11 a 13 | Formato del nivel, validaciones y solución de referencia → **`02-RN-NIVELES.md`** (documento compartido con el backend). La solución de referencia nunca se le muestra al jugador | — | — |

## 4. Fuente de piezas

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-20 | Las piezas son las del nivel, **todas visibles** en la bandeja desde el inicio, en el orden del archivo y cada una en su orientación inicial | Enunciado §1.5 | 🟡 |
| RN-HF-21 | No hay aleatoriedad en Hexa Fit | Enunciado §1.5 | ✅ |

## 5. Movimientos y validación

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-30 | **Colocar:** llevar una pieza de la bandeja a la figura con su origen en una celda ancla. Es válido si **todas** sus celdas están **dentro de la figura** y **vacías** | Enunciado §1.2 | ✅ |
| RN-HF-31 | **Rotar:** aplicar un **giro básico** (RN-COM-14) a una pieza **que está en la bandeja**: en 2D, un paso horario (60° en hexágonos); en 3D, el jugador elige el eje. Es válido si la pieza **cambia de orientación**; si queda igual (una pieza simétrica, como la de una celda), es inválido (RN-COM-21) y no entra al historial | Enunciado §1.2, HU HF-03, D-114 | ✅ (en bandeja: 🟡) |
| RN-HF-32 | **Retirar:** devolver una pieza colocada a la bandeja; sus celdas quedan vacías. Conserva la orientación con la que estaba colocada | HU HF-04 | 🟡 |
| RN-HF-33 | **Mover:** llevar una pieza colocada a otra posición de la figura, en un solo gesto y con la misma orientación. Es válido si la nueva posición cumple RN-HF-30 **ignorando las celdas que ocupa la propia pieza**. Si es inválido, la pieza se queda donde estaba | HU HF-04 | 🟡 |
| RN-HF-34 | Soltar una pieza fuera de la figura equivale a **retirarla** (si estaba colocada) o a **no hacer nada** (si venía de la bandeja) | HU HF-02, HF-04 | 🟡 |

## 6. Resolución

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-40 | Hexa Fit **no tiene resolución**: después de cada movimiento solo se evalúa la cobertura | Enunciado §1.5 | ✅ |

## 7. Fin de partida

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-50 | **Victoria:** todas las celdas de la figura quedan cubiertas. Como las áreas son iguales y no hay solapamientos, equivale a que **todas las piezas estén colocadas** | Enunciado §1.2 | ✅ |
| RN-HF-51 | **No hay derrota.** El jugador puede reiniciar el nivel (vuelve todo al estado inicial y se reinician el tiempo y los movimientos) o salir | Enunciado §1.2 | ✅ |
| RN-HF-52 | El **tiempo activo** (RN-COM-52) corre desde que el nivel termina de cargarse hasta la victoria, y se detiene durante la pausa | HU NAV-04, HF-06 | 🟡 |

## 8. Puntuación: estrellas

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-60 | Al completar el nivel se obtienen de **1 a 3 estrellas** según **movimientos y tiempo** | Enunciado §1.2 | ✅ |
| RN-HF-61 | **Movimientos que cuentan:** cada **colocar**, **mover** y **retirar** válidos suma 1. **Rotar, deshacer y rehacer no suman ni restan.** Motivo: deshacer no debe "borrar" el esfuerzo, y rotar en la bandeja es explorar | Equipo | ✅ D-10 (11-11) |
| RN-HF-62 | **Estrellas independientes** con 2 umbrales por nivel, `m` (movimientos) y `t` (tiempo): **★** por completar el nivel; **+★** si movimientos ≤ `m`; **+★** si tiempo ≤ `t`. Resultado: de 1 a 3 estrellas. El jugador ve cuál le faltó | Equipo, HU HF-06 | ✅ D-10 (11-11) |
| RN-HF-63 | Coherencia de umbrales: `m` ≥ número de piezas (el mínimo posible) y `t` > 0. Valores por defecto sugeridos para diseñar niveles: `m` = número de piezas + 1 (permite un error) y `t` según el tamaño de la figura | Equipo | 🟡 |
| RN-HF-64 | La pantalla de victoria muestra las estrellas, indicando cuál se ganó y cuál faltó, con el tiempo y los movimientos | Enunciado §5.1 | ✅ |

## 9. Progreso

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-70 | Completar un nivel lo marca como **completado** y desbloquea el siguiente (RN-COM-73) | Enunciado §5.1 | ✅ |
| RN-HF-71 | Por nivel se guarda el **mejor intento**, comparando **estrellas ↓ → tiempo ↑ → movimientos ↑** sobre el intento completo. El mismo criterio ordena el ranking por nivel (RN-COM-102) | Profesor (P-07) | ✅ |
| RN-HF-72 | La selección de niveles muestra, por nivel: bloqueado (con candado), disponible, o completado con sus estrellas | HU HF-01 | ✅ |

## 10. Deshacer y rehacer

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-80 | Se puede **deshacer sin límite** hasta el estado inicial del nivel, y **rehacer** en el mismo orden | Enunciado §1.2, §5.1 | ✅ |
| RN-HF-81 | El historial incluye **colocar, mover, retirar y rotar** (deshacer una rotación la revierte) | HU HF-05 | ✅ |
| RN-HF-82 | Un movimiento nuevo tras deshacer **descarta** el historial de rehacer (RN-COM-62) | HU HF-05 | ✅ |

## 11. Notificaciones

**Pieza colocada / movida / retirada / rotada** → **movimientos actualizados** → **nivel completado** (con estrellas, tiempo y movimientos).

## 12. Casos borde

| Caso | Resultado |
|---|---|
| Colocar la última pieza cubre la figura | Victoria inmediata; deshacer ya no está disponible (RN-COM-63) |
| Mover una pieza a una posición que se solapa consigo misma | Válido si cumple RN-HF-33 (sus propias celdas no cuentan como ocupadas) |
| Rotar una pieza colocada | No se permite directamente: hay que retirarla, rotarla en la bandeja y volver a colocarla |
| Repetir un nivel ya completado con peor resultado | Se conserva el mejor intento (RN-HF-71) |

## 13. Ejemplos (se convierten en pruebas)

**Nivel de ejemplo E-HF-NIVEL.** Figura de 6 celdas `F = {(2,−1), (0,0), (1,0), (2,0), (0,1), (1,1)}`:

```
  . . .      r=-2
 . . . F     r=-1
. . F F F    r=+0
 . . F F     r=+1
  . . .      r=+2
```

Piezas: **A** = arco de 3, orientación inicial `(0,0)(1,0)(1,1)`; **B** = triángulo de 3, orientación inicial `(0,0)(1,0)(0,1)`. Área 3 + 3 = 6 = área de la figura ✅. Umbrales: `m` = 3, `t` = 40 s (los de D-54 para 2 piezas: piezas + 1 y 20 s por pieza). Solución de referencia (celdas absolutas, RN-HF-11): A ocupa `{(2,−1), (2,0), (1,1)}` (su forma rotada 1 paso); B ocupa `{(0,0), (1,0), (0,1)}` (sin rotar). (El simulador encontró exactamente 2 soluciones para este nivel.)

**E-HF-1 — Partida completa.**

| # | Acción | Resultado | Movimientos |
|---|---|---|---|
| 1 | Colocar A (sin rotar) con ancla `(0,0)` | Válido: cubre `(0,0)(1,0)(1,1)`. Quedan libres `(0,1)(2,−1)(2,0)`, donde B no cabe en ninguna orientación | 1 |
| 2 | Deshacer | A vuelve a la bandeja | 1 |
| 3 | Rotar A un paso | A queda `(0,0)(0,1)(−1,2)` | 1 |
| 4 | Colocar A con ancla `(2,−1)` | Válido: cubre `(2,−1)(2,0)(1,1)` | 2 |
| 5 | Colocar B con ancla `(0,0)` | Válido: cubre `(0,0)(1,0)(0,1)` → figura cubierta → **victoria** | 3 |

Con tiempo de 45 s: ★ por completar; 3 movimientos ≤ `m` = 3 → ★ de movimientos (el umbral permite justo el error del paso 1); 45 s > `t` = 40 s → **sin** la estrella de tiempo. Total: **2★** (faltó la de tiempo). Con 40 s o menos habría sacado **3★**.

**E-HF-2 — Colocaciones inválidas** (después del paso 4 de E-HF-1):
- B con ancla `(1,0)` → necesitaría `(2,0)`, que está ocupada por A → inválido.
- B con ancla `(−1,0)` → `(−1,0)` no pertenece a la figura → inválido.

**E-HF-3 — Rehacer descartado.** Colocar A → colocar B → deshacer (B vuelve) → rotar B → **rehacer ya no está disponible** (RN-HF-82).

**E-HF-4 — Mejor intento** (en el nivel de E-HF-NIVEL, `m` = 3 y `t` = 40 s). Intento 1: 2★, 00:50, 2 mov. Intento 2: 2★, 00:45, 3 mov. → mejor intento = **intento 2** (mismas estrellas, menos tiempo; los movimientos solo desempatan). Las estrellas son coherentes con los umbrales: los dos ganan la de movimientos y pierden la de tiempo.
