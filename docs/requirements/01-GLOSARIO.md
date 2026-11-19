# 01 — Glosario de HexaBlock Suite

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | **Compartido:** `hexablock-app` y `hexablock-api`, en `docs/requirements/`. Las dos copias deben ser **idénticas** |

**Para qué sirve:** que cada palabra signifique lo mismo en todos los documentos, en las conversaciones con la IA y en el código. La columna **Código** es el nombre en inglés que se usará en clases, variables y endpoints (el código y los commits van en inglés; los documentos internos, en español).

**Regla:** si un documento usa un término que no está aquí, o lo usa con otro significado, se corrige el documento o se agrega el término a este glosario en el mismo PR.

---

## 1. Suite y variantes

| Término | Código | Definición |
|---|---|---|
| Suite | `HexaBlockSuite` | La aplicación completa, con sus cuatro juegos |
| Variante | `Variant` | Cada uno de los juegos de la suite: Hexa Lines, Hexa Fit, Hexa Sort y Hexa Merge |
| Identificador de variante | `gameId` | Texto fijo que identifica a una variante en la app, en la API y en la base de datos: `hexa-lines`, `hexa-fit`, `hexa-sort`, `hexa-merge` |
| Motor | `GameEngine` | La parte común que ejecuta el ciclo de partida de cualquier variante. No conoce ninguna variante en particular |
| Reglas de la variante | `Rules` | Lo que cambia entre variantes: qué movimientos valen, cómo se resuelven y cuándo termina la partida |
| Variante sin fin | `EndlessVariant` | Variante sin niveles cuyo objetivo es el puntaje máximo (Hexa Lines y Hexa Merge) |
| Variante por niveles | `LevelBasedVariant` | Variante con niveles definidos en archivos de configuración (Hexa Fit y Hexa Sort) |

## 2. Tablero y geometría

| Término | Código | Definición |
|---|---|---|
| Tablero | `Board` | Conjunto finito de celdas sobre el que se juega una partida. Cada celda tiene un contenido |
| Celda | `Cell` | Una posición del tablero. Puede estar **vacía** u **ocupada**. Según la topología es un hexágono, un cuadrado, un triángulo (▲ o ▼) o un cubo |
| Contenido de celda | `TCell` | Lo que guarda una celda. Depende de la variante: un color (Lines), un identificador de pieza (Fit), una pila (Sort) o un número (Merge) |
| Coordenada | `Coord` | Identificador de una celda. Depende de la topología: `(q, r)` en hexágonos, `(x, y)` en cuadrados y triángulos, `(x, y, z)` en cubos. En el motor es el parámetro genérico `TCoord extends Coord` (D-07) |
| Topología | `Topology` | La forma y el modo de conexión de las celdas: quiénes son vecinas, cuáles son las líneas, las direcciones y cómo se rota. Se soportan **hexágonos, cuadrados y triángulos** (2D) y **cubos** (3D). El jugador la elige en Ajustes como **"figura de las celdas"** y queda fija durante cada partida |
| Forma del tablero | `BoardShape` | Qué celdas existen en un tablero concreto: un hexágono de cierto radio o una figura arbitraria |
| Radio | `radius` | Tamaño de un tablero hexagonal: número de anillos alrededor de la celda central. Radio 2 = 19 celdas; radio 4 = 61 celdas |
| Vecina | `neighbor` | Celda que comparte un lado con otra. En la topología hexagonal, cada celda tiene hasta 6 vecinas |
| Eje | `Axis` | Cada una de las familias de líneas paralelas del tablero. La topología hexagonal tiene 3 ejes (q, r, s) |
| Línea | `Line` | Conjunto de todas las celdas del tablero alineadas en un mismo eje, de borde a borde |
| Dirección | `Direction` | Sentido en el que se recorre un eje. La topología hexagonal tiene 6: E, O, NE, NO, SE, SO (en código: `E`, `W`, `NE`, `NW`, `SE`, `SW`) |
| Rayo | `ray` | Secuencia de celdas que se obtiene al avanzar desde una celda en una dirección hasta el borde del tablero |
| Giro básico | `basicRotation` | Giro mínimo que deja la rejilla igual a sí misma. En 2D hay uno (60° en hexágonos y triángulos, 90° en cuadrados); en 3D hay tres (90° sobre cada eje) |
| Orden de vecinas | `neighborOrder` | Orden fijo de las vecinas de una celda. En 2D es el **horario** desde las 12 (en hexágonos: NE, E, SE, SO, O, NO); en 3D, una lista fija de la topología |
| Orden de lectura | `readingOrder` | Orden fijo para recorrer celdas cuando hace falta desempatar: en 2D, por fila y luego por columna; en 3D, por capa, fila y columna |

## 3. Piezas y fuentes

| Término | Código | Definición |
|---|---|---|
| Forma | `Shape` | Conjunto de celdas relativas a un origen; describe el dibujo de una pieza, sin posición en el tablero |
| Pieza | `Piece` | Forma que el jugador coloca en el tablero (Hexa Lines y Hexa Fit): celdas unidas por sus caras. En hexágonos, un **poli-hexágono** |
| Orientación | `orientation` | Cada una de las rotaciones distintas de una forma |
| Familia de piezas | `PieceFamily` | Una forma con todas sus orientaciones (por ejemplo, la "línea de 3" tiene 3 orientaciones) |
| Ancla | `anchor` | Celda del tablero donde se coloca el origen `(0, 0)` de una forma normalizada |
| Forma normalizada | `normalize` | Forma trasladada para que su primera celda en orden de lectura quede en `(0, 0)` |
| Bandeja | `Tray` | Zona donde se le ofrecen al jugador las piezas o pilas disponibles para colocar |
| Fuente de piezas | `PieceSource` | Lo que produce las piezas de la bandeja: un generador aleatorio con semilla o una lista fija del nivel |
| Semilla | `seed` | Número que inicializa el generador aleatorio. La misma semilla produce siempre la misma secuencia |
| Generador aleatorio | `RandomGenerator` | Algoritmo determinista que, a partir de la semilla, entrega números pseudoaleatorios. Es inyectable para las pruebas |

## 4. Partida y turnos

| Término | Código | Definición |
|---|---|---|
| Partida | `GameSession` | Una ejecución de una variante, desde que empieza hasta que termina o se abandona |
| Estado de la partida | `GameState` | Todo lo necesario para continuar una partida: tablero, bandeja, puntaje, estado del generador, contadores, etc. |
| Movimiento | `Move` | Acción del jugador sobre la partida: colocar, retirar, mover o rotar una pieza; colocar una pila; deslizar el tablero |
| Movimiento válido | `isValid` | Movimiento que las reglas permiten en el estado actual. Un movimiento inválido no cambia nada y no cuenta |
| Turno | `Turn` | Procesamiento completo de un movimiento válido: validar → aplicar → resolver → evaluar fin de partida |
| Resolución | `Resolution` | Los efectos automáticos que siguen a un movimiento: eliminar líneas (Lines), transferir en cascada (Sort), fusionar (Merge). Hexa Fit no tiene resolución |
| Fin de partida | `GameOver` | La partida termina y ya no acepta movimientos. Puede ser **victoria** o **derrota** |
| Victoria | `Victory` | Condición de éxito de la variante |
| Derrota | `Defeat` | Condición de fracaso de la variante. En Hexa Lines, a la derrota se le llama **fin de partida**, porque no hay victoria posible |
| Pausa | `Pause` | Estado en que la partida no acepta movimientos y el cronómetro está detenido |
| Partida guardada | `SavedGame` | Copia en el dispositivo de la partida en curso, que se actualiza tras cada turno y permite **continuarla** aunque la app se cierre (RN-COM-33 a 35) |
| Tiempo activo | `activeTime` | Tiempo de juego sin contar pausas ni la app en segundo plano |
| Deshacer / rehacer | `undo` / `redo` | Volver al estado anterior a un movimiento / volver a aplicar un movimiento deshecho |
| Historial | `History` | Lista de movimientos que se pueden deshacer y rehacer |

## 5. Puntuación y progreso

| Término | Código | Definición |
|---|---|---|
| Puntaje | `score` | Número entero, no negativo, que acumula una partida según la política de puntuación de la variante |
| Política de puntuación | `ScoringPolicy` | Las reglas que dicen cuántos puntos da cada evento de la variante |
| Combo | `combo` | Varios logros en un mismo turno (por ejemplo, varias líneas eliminadas a la vez) |
| Racha | `streak` | Turnos **consecutivos** con al menos un logro (por ejemplo, eliminar líneas en turnos seguidos) |
| Récord | `bestScore` | El mayor puntaje obtenido en una variante sin fin, por perfil |
| Nivel | `Level` | Partida predefinida de una variante por niveles, cargada desde un archivo de configuración |
| Orden del nivel | `order` | Posición del nivel dentro de su variante (1, 2, 3…). Define el desbloqueo |
| Versión del nivel | `version` | Número que aumenta cada vez que se modifica la definición de un nivel en el servidor |
| Estado del nivel | `LevelStatus` | `bloqueado`, `disponible` o `completado` |
| Estrellas | `stars` | Calificación de 1 a 3 de un nivel completado de Hexa Fit |
| Intento | `Attempt` | Una partida completada de un nivel, con sus resultados (estrellas, tiempo, movimientos, puntaje) |
| Mejor intento | `bestAttempt` | El intento con mejor resultado según el criterio de comparación de la variante, tomado **completo** (no se mezclan valores de intentos distintos) |
| Progreso | `Progress` | Lo que el jugador ha logrado en una variante: niveles completados, mejor intento por nivel, récord |
| Modelo de progreso | `ProgressModel` | Cómo mide el progreso una variante: puntaje máximo (sin fin) o niveles (con o sin estrellas) |

## 6. Hexa Sort

| Término | Código | Definición |
|---|---|---|
| Ficha | `Token` | Unidad de color que forma una pila |
| Pila | `ColorStack` | Secuencia ordenada de fichas en una celda, **de abajo hacia arriba**. Notación: `GRR` = abajo G, luego R, arriba R |
| Cima | `top` | La ficha de más arriba de una pila |
| Bloque de cima | `topRun` | El grupo de fichas **consecutivas del mismo color** que hay en la parte de arriba de la pila. En `GRR` el bloque de cima es `RR` (color R, tamaño 2) |
| Transferencia | `Transfer` | Mover el bloque de cima de una pila a otra cuya cima es del mismo color |
| Cascada | `Cascade` | Secuencia de transferencias que se encadenan después de colocar una pila, hasta que ninguna más es posible |
| Meta | `Goal` | Se cumple cada vez que un bloque de cima llega a 10 fichas del mismo color y se elimina |

## 7. Hexa Merge

| Término | Código | Definición |
|---|---|---|
| Ficha numérica | `Tile` | Celda ocupada con un valor potencia de 2 (2, 4, 8, …) |
| Deslizar | `Slide` | Mover todas las fichas del tablero en una dirección hasta el borde o hasta otra ficha |
| Fusión | `Merge` | Dos fichas de igual valor que chocan al deslizar se convierten en una de valor doble |
| Ficha nueva | `spawn` | Ficha de valor 2 o 4 que aparece en una celda vacía aleatoria después de cada movimiento válido |
| Ficha objetivo | `targetTile` | Valor cuya aparición da la victoria (2048 por defecto, configurable) |

## 8. Hexa Fit

| Término | Código | Definición |
|---|---|---|
| Figura | `Figure` | Conjunto de celdas que el jugador debe cubrir en un nivel. Es el tablero de ese nivel |
| Cobertura | `coverage` | Celdas de la figura ocupadas por piezas. Cobertura completa = victoria |
| Solución de referencia | `referenceSolution` | Colocación de todas las piezas que cubre la figura. Va en el archivo del nivel para validar que el nivel tiene solución. No se le muestra al jugador |

## 9. Cuentas y sincronización

| Término | Código | Definición |
|---|---|---|
| Perfil local | `LocalProfile` | Conjunto de datos de progreso guardados en el dispositivo para una persona: el perfil **invitado** o el de una **cuenta** |
| Invitado | `Guest` | Jugador sin cuenta. Su progreso solo vive en el dispositivo |
| Cuenta | `Account` | Usuario registrado (correo + contraseña) cuyo progreso también se guarda en el servidor |
| Nombre visible | `displayName` | Nombre público que aparece en el ranking. Nunca se muestra el correo |
| Sincronización | `Sync` | Intercambio de progreso entre el dispositivo y el servidor |
| Cola de sincronización | `SyncOutbox` | Lista local de cambios de progreso pendientes de enviar al servidor |
| Consolidación de progreso | `reconcile` | Combinar dos versiones del progreso quedándose con lo mejor de cada una. **No confundir con la fusión de Hexa Merge** |
| Ranking | `Leaderboard` | Tabla de clasificación global por `gameId` y, en las variantes por niveles, por nivel |
| Administrador de contenido | `Admin` | Usuario con rol `admin` que puede publicar o modificar niveles por la API |

## 10. Términos que se evitan

| No usar | Usar | Motivo |
|---|---|---|
| "Ficha" para las piezas de Lines o Fit | **Pieza** | "Ficha" se reserva para Hexa Sort (`Token`) y Hexa Merge (`Tile`) |
| "Fusión" para el progreso | **Consolidación** | "Fusión" es la regla de Hexa Merge |
| "Jugada" | **Movimiento** o **turno** | Ambiguo entre la acción y su procesamiento completo |
| "Hexágono" para hablar del tablero en general | **Tablero** / **topología** | El tablero podría no ser hexagonal |
