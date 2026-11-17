# 02 — Reglas de negocio comunes

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/02-RN-COMUNES.md`) |
| Relacionados | `01-GLOSARIO.md`, `02-RN-TOPOLOGIAS.md`, `02-RN-HEXA-*.md`, `02-RN-NIVELES.md`, `02-RN-CUENTA-PROGRESO-RANKING.md` |

---

## 0. Cómo leer estos documentos

### 0.1 Formato de cada regla

Cada regla tiene un **ID estable** (`RN-COM-21`, `RN-HS-42`…) que se cita desde los requisitos, las historias de usuario, las pruebas y los commits. **Un ID nunca se reutiliza**: si una regla se elimina, su ID queda marcado como "retirada".

| Estado | Significado |
|---|---|
| ✅ **Acordada** | Viene del enunciado o la confirmó el profesor. No se cambia sin una nueva fuente |
| 🟡 **Propuesta** | Redactada como recomendación. El equipo la acepta, la ajusta o la cambia en la revisión |
| ⚠️ **Decidir** | Hay varias opciones razonables y hace falta una decisión explícita (aparece en `PENDIENTES.md`) |

### 0.2 Independencia de la topología

El profesor avisó que la forma de las celdas puede cambiar: **triángulos, cuadrados o cubos en 3D** (11-11-2026). Por eso las reglas de este documento y de las variantes usan solo los **conceptos de topología** de `02-RN-TOPOLOGIAS.md` (vecinas, ejes, líneas, direcciones, rayos, giros básicos, órdenes canónicos), sin suponer números propios del hexágono ni que el tablero es plano. Todo lo propio de cada forma de celda está en los anexos de ese documento.

### 0.3 Mapa de documentos de reglas

| Documento | Contenido | Repositorio |
|---|---|---|
| `02-RN-COMUNES.md` | Formato, notación, ciclo de turno, estados, aleatoriedad, puntuación, deshacer, idioma | App |
| `02-RN-TOPOLOGIAS.md` | Conceptos de topología, alcance, tableros por defecto, anexos de cada forma de celda | App |
| `02-RN-HEXA-LINES.md` · `-FIT` · `-SORT` · `-MERGE` | Reglas de cada variante | App |
| `02-RN-NIVELES.md` | Esquema y validaciones de niveles | **Compartido** |
| `02-RN-CUENTA-PROGRESO-RANKING.md` | Perfiles, sincronización, consolidación, ranking | **Compartido** |

### 0.4 Notación de los ejemplos

Los ejemplos de las variantes usan la topología hexagonal (`02-RN-TOPOLOGIAS.md`, Anexo A), con celdas de **vértice hacia arriba** (*pointy-top*). Cada fila es un valor de `r` (de arriba hacia abajo) y, dentro de la fila, `q` crece hacia la derecha. `.` = celda vacía.

Tablero de radio 2 con las direcciones vistas desde la celda central `0 = (0, 0)`:

```
  . . .      r=-2
 . n N .     r=-1        n = NO (0,-1)    N = NE (+1,-1)
. W 0 E .    r=+0        W = O  (-1, 0)   E = E  (+1, 0)
 . S s .     r=+1        S = SO (-1,+1)   s = SE (0,+1)
  . . .      r=+2
```

Las celdas se escriben como `(q, r)`. Las pilas de Hexa Sort se escriben **de abajo hacia arriba** (`GRR`: abajo G, arriba R).

**Cada ejemplo de estos documentos se convierte en al menos una prueba automatizada.** Los ejemplos se verificaron con un simulador de referencia antes de publicarse.

---

## 1. Variantes y configuración general

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-01 | La suite tiene exactamente 4 variantes, identificadas por su `gameId`: `hexa-lines`, `hexa-fit`, `hexa-sort`, `hexa-merge`. El `gameId` es la dimensión obligatoria de todo el progreso, el ranking y los niveles | Enunciado §5.2 | ✅ |
| RN-COM-02 | Hexa Lines y Hexa Merge son **sin fin**: no tienen niveles y su progreso es el puntaje máximo. Hexa Fit y Hexa Sort son **por niveles** | Enunciado §1.5, §5.1 | ✅ |
| RN-COM-03 | Hexa Fit tiene **al menos 15 niveles** y Hexa Sort **al menos 10**, diseñados a mano, con dificultad creciente y cargados desde archivos de configuración (no desde el código) | Enunciado §5.1 | ✅ |
| RN-COM-04 | Los parámetros de cada variante que podrían cambiar (tamaño del tablero, ficha objetivo, catálogo de piezas, pesos, fórmulas de puntaje) se leen de **configuración**, no se escriben fijos en las reglas | Enunciado §3.1 (cambios "confinados a nuevas clases o a configuración") | ✅ |

## 2. Topología

Movida a **`02-RN-TOPOLOGIAS.md`** (reglas RN-COM-10 a 19, alcance, tableros por defecto y anexos de hexágonos, triángulos, cuadrados y cubos).

## 3. Ciclo de un turno

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-20 | Todo movimiento sigue el mismo ciclo: **validar → aplicar → resolver → evaluar fin de partida → notificar**. Ninguna variante se salta pasos; si una variante no tiene resolución, ese paso no hace nada | Enunciado §3.1, §3.3 (Template Method) | ✅ |
| RN-COM-21 | Un **movimiento inválido** no cambia el estado de la partida, no suma puntos, no cuenta como movimiento y no genera piezas ni fichas nuevas | Enunciado §1.4 + consistencia | 🟡 |
| RN-COM-22 | La **resolución** se repite hasta que el tablero queda **estable** (ningún efecto automático más es posible). Cada variante demuestra que su resolución siempre termina | Enunciado §1.3 ("hasta que no haya más movimientos posibles") | ✅ |
| RN-COM-23 | El fin de partida se evalúa **después** de terminar la resolución, nunca a mitad de ella. Si en el mismo turno se cumplen la condición de victoria y la de derrota, **gana la victoria** | Diseño | 🟡 |
| RN-COM-24 | Mientras la partida está **resolviendo, en pausa o terminada**, no acepta movimientos | Enunciado §3.3 (State) | ✅ |
| RN-COM-25 | Cada paso visible de la resolución (una línea eliminada, una transferencia, una fusión) se notifica **en orden**, para que la interfaz, el sonido y la analítica puedan reaccionar y animar | Enunciado §3.3 (Observer) | ✅ |

## 4. Estados de la partida

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-30 | Una partida está siempre en uno de estos estados: **en juego**, **resolviendo**, **en pausa**, **victoria** o **derrota/fin** | Enunciado §3.3 | ✅ |
| RN-COM-31 | Transiciones permitidas: en juego → resolviendo → (en juego \| victoria \| derrota); en juego ↔ en pausa. Desde victoria o derrota solo se puede **reintentar**, ir al **siguiente nivel**, empezar una **nueva partida** o **salir**. Excepción: Hexa Merge permite **seguir jugando** tras la victoria (RN-HM-40) | Enunciado §5.1, P-06 | ✅ |
| RN-COM-32 | Si la app pasa a **segundo plano**, la partida en juego pasa a **en pausa** automáticamente | HU NAV-04 | 🟡 |

## 5. Aleatoriedad y determinismo

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-40 | Todo lo aleatorio (piezas de Hexa Lines, pilas de Hexa Sort, fichas nuevas de Hexa Merge) sale de un **generador aleatorio inyectable con semilla**. Ninguna regla usa el reloj ni un generador global | Enunciado §1.4, §3.1 | ✅ |
| RN-COM-41 | **Determinismo:** con la misma configuración, la misma semilla y la misma secuencia de movimientos, el estado final es idéntico en cualquier ejecución y en cualquier dispositivo | Enunciado §1.4 | ✅ |
| RN-COM-42 | El **estado del generador** es parte del estado de la partida: se guarda al pausar o salir y se restaura al deshacer (para que deshacer no permita "volver a tirar los dados") | Diseño | 🟡 |
| RN-COM-43 | Algoritmo: **xorshift32** implementado en el dominio, con estado de 32 bits. Motivo: es determinista entre plataformas y versiones del SDK, y su estado es un solo entero fácil de guardar. Si la semilla es 0, se usa una constante fija distinta de 0 | Equipo | ✅ D-14 (11-11) |
| RN-COM-44 | Para elegir al azar entre `n` opciones se usa `siguiente() mod n`. Para una probabilidad del `p %` se usa `siguiente() mod 100 < p` | Diseño | 🟡 |
| RN-COM-45 | Si no se indica semilla, la partida usa una semilla nueva al azar y la **registra** en el estado, para poder reproducir la partida | Diseño | 🟡 |

**Ejemplo E-COM-1 (xorshift32).** Con semilla `12345`, los primeros 4 valores son `3336926330`, `1697253807`, `2816511904`, `1955480042`. Esta secuencia es una prueba del generador.

## 6. Puntuación y tiempo

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-50 | El puntaje es un **entero ≥ 0**. Dentro de una partida solo **sube**, salvo al deshacer, que restaura el puntaje anterior | Diseño | 🟡 |
| RN-COM-51 | Cada variante define su **política de puntuación** y la documenta en su archivo de reglas. Las fórmulas usan solo enteros; si hay multiplicadores fraccionarios, se redondea **hacia abajo una sola vez**, al final del cálculo del turno | Enunciado §5.1 | ✅ (fórmulas: 🟡) |
| RN-COM-52 | El **tiempo** de una partida es **tiempo activo**: no cuenta las pausas ni el tiempo en segundo plano. Se mide en milisegundos y se muestra como `mm:ss` | HU NAV-04, HF-06 | 🟡 |

## 7. Deshacer y rehacer

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-60 | Disponibilidad: **Hexa Lines no**, **Hexa Fit ilimitado + rehacer**, **Hexa Sort no**, **Hexa Merge 1 movimiento** | Enunciado §1.5, §5.1 | ✅ |
| RN-COM-61 | Deshacer restaura **todo** el estado anterior al movimiento: tablero, bandeja, puntaje, contadores y estado del generador aleatorio | Diseño | 🟡 |
| RN-COM-62 | Hacer un movimiento nuevo después de deshacer **descarta** lo que se podía rehacer | HU HF-05 | ✅ |
| RN-COM-63 | No se puede deshacer una vez que la partida terminó en derrota. Tras la victoria de Hexa Fit tampoco (el nivel ya quedó registrado). En Hexa Merge, después de la victoria se sigue pudiendo deshacer mientras se sigue jugando | Diseño | 🟡 |

## 8. Niveles → `02-RN-NIVELES.md` (compartido)

Reglas RN-COM-70 a 76 y formato de los niveles de Hexa Fit y Hexa Sort.

## 9. Progreso, perfiles y sincronización → `02-RN-CUENTA-PROGRESO-RANKING.md` (compartido)

Reglas RN-COM-80 a 90 y ejemplo E-COM-2.

## 10. Ranking → `02-RN-CUENTA-PROGRESO-RANKING.md` (compartido)

Reglas RN-COM-100 a 108.

## 11. Idioma, audio y ajustes

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-110 | Idiomas: **español e inglés**. En el primer arranque se usa el idioma del sistema si es uno de los dos; si no, inglés. El jugador puede cambiarlo en ajustes sin reiniciar | Enunciado §5.1, HU NAV-03 | ✅ |
| RN-COM-111 | Música y efectos se pueden silenciar **por separado**; la elección se conserva entre sesiones | Enunciado §5.1, HU NAV-02 | ✅ |
| RN-COM-112 | Los nombres de los niveles y los textos de reglas existen en **ambos idiomas** | Enunciado §5.1 | ✅ |
| RN-COM-113 | En Ajustes también se elige la **figura de las celdas**, que no puede cambiar durante una partida → `02-RN-TOPOLOGIAS.md`, RN-TOP-30 a 34 | Equipo | ✅ D-25 (11-11) |
