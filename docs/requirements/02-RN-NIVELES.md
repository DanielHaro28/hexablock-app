# 02 — Reglas de negocio: niveles

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 (RN-COM-70, D-47; RN-COM-76, D-19; RN-COM-77, D-48: 19-11) |
| Repositorio | **Compartido:** `hexablock-app` y `hexablock-api`, en `docs/requirements/`. Las dos copias deben ser **idénticas**: se modifica en un PR de cada repo, con el mismo cambio |
| Relacionados | `02-RN-CUENTA-PROGRESO-RANKING.md`; en la app, `02-RN-HEXA-FIT.md` y `02-RN-HEXA-SORT.md` |

**Por qué es un documento compartido:** los niveles se validan en dos lugares. El **backend** los valida cuando un administrador los publica, y la **app** cuando los empaqueta o los descarga. Ambos necesitan las mismas reglas.

Formato de las reglas y estados (✅ acordada / 🟡 propuesta / ⚠️ decidir): ver `02-RN-COMUNES.md` §0 en el repo de la app. Términos: `01-GLOSARIO.md`.

---

**Reglas de la app que se citan aquí** (resumen para el backend; el detalle está en `hexablock-app`):

| Regla | Resumen |
|---|---|
| RN-COM-19 | La topología de una partida la elige el jugador (entre las disponibles) y la forma del tablero sale de la configuración |
| RN-TOP-34 | Niveles por figura: los de Hexa Fit pertenecen a una topología; los de Hexa Sort sin pilas iniciales sirven para cualquiera (propuesta D-28) |
| RN-HF-62 | Estrellas de Hexa Fit: ★ por completar + ★ si movimientos ≤ `m` + ★ si tiempo ≤ `t` |
| RN-HF-63 | Coherencia de umbrales: `m` ≥ número de piezas y `t` > 0 |
| RN-HS-21 | Generación de pilas de Hexa Sort: altura `altMin`–`altMax` (2–6), hasta `bloquesMax` (3) bloques |

## 1. Reglas comunes a todos los niveles

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-70 | Todos los niveles comparten un **esquema común** (`id`, `gameId`, `topology`, `order`, `version`, `name` en es/en) más una **sección específica** `variant`, cuyo contenido es **distinto según el `gameId`** (Fit: figura, piezas, umbrales y solución; Sort: metas, paleta, semilla, generación y pilas iniciales). Los niveles son archivos **JSON** validados por `level.schema.json`. El `id` es legible, se escribe a mano y nunca cambia: `<variante>-<figura>-<nnn>` (ej. `fit-hex-001`, `sort-any-004`). Una celda se escribe como **lista de enteros** con su dirección según la figura (`[q, r]` en hexágonos, `[x, y]` en cuadrados, `[x, y, z]` en cubos); lo que hay en la celda lo dice la sección `variant` | Enunciado §5.2 | ✅ D-47 (19-11) |
| RN-COM-71 | Un nivel solo se acepta (al empaquetarlo, al publicarlo en el servidor o al descargarlo) si **cumple el esquema** y las **validaciones de su variante** | SECURITY SEC-API-10, SEC-MOB-06 | ✅ |
| RN-COM-72 | Los niveles incluidos en la app y los descargados del servidor se juntan en una sola lista por variante, **ordenada por `order`**. Si un nivel con el mismo `id` existe en ambos, gana el de **mayor `version`** | HU LVL-01 | 🟡 |
| RN-COM-73 | **Desbloqueo:** el nivel de `order` 1 de cada variante está siempre disponible. Completar el nivel N desbloquea el N+1 de esa variante. Un nivel desbloqueado **nunca se vuelve a bloquear** | Enunciado §5.1, HU PRG-04 | ✅ |
| RN-COM-74 | El progreso de un nivel se guarda por su `id`, no por su `version`: si el servidor actualiza un nivel ya completado, sigue contando como completado | Diseño | 🟡 |
| RN-COM-75 | El esquema común incluye la **topología** del nivel y su **forma de tablero** (o la figura, en Hexa Fit). Un nivel de Hexa Sort sin pilas iniciales puede declarar la topología **`any`**: se juega con la que eligió el jugador y el tablero por defecto (RN-TOP-34). La app solo ofrece los niveles de la figura elegida | Decisión del equipo (D-25), RN-COM-19 | 🟡 |
| RN-COM-76 | **Quién valida qué.** El **backend** valida el esquema y todas las reglas **estructurales** (conteos, celdas dentro del tablero, solapamientos, cobertura y coherencia de umbrales). Las reglas **geométricas** que requieren girar formas (RN-HF-12 f) las valida el **dominio de la app**, en CI para los niveles incluidos y al descargar un nivel. Antes de publicar un nivel por la API, el administrador lo pasa por el validador de la app (RF-83) | Equipo | ✅ D-19 (19-11) |
| RN-COM-77 | **Descarga por cambios.** La app pide los niveles de una variante y figura **creados o actualizados después de un cursor** que le dio el servidor en la descarga anterior (la primera vez, sin cursor), en páginas de **hasta 100**; cada respuesta trae el cursor siguiente. El cursor lo genera el servidor, así que no depende del reloj del teléfono. Los niveles **no se borran**: solo se publican o se actualizan subiendo su `version` (RN-COM-73, 74) | Equipo | ✅ D-48 (19-11) |

## 2. Hexa Fit

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HF-11 | La sección específica de un nivel de Hexa Fit contiene: la **figura** (lista de celdas), las **piezas** (id, forma normalizada en su orientación inicial, color), los **umbrales de estrellas** `m` y `t` (RN-HF-62) y la **solución de referencia**: para cada pieza, las **celdas absolutas** que ocupa en la figura | Enunciado §1.2, §5.2, D-19 | 🟡 |
| RN-HF-12 | **Validaciones de un nivel de Hexa Fit:** (a) la suma de las áreas de las piezas es **igual** al área de la figura; (b) cada pieza es una forma **conectada** de 1 a 6 celdas; (c) los `id` de pieza son únicos; (d) las celdas de la solución de cada pieza están dentro de la figura, no se solapan entre piezas y entre todas cubren la figura completa; (e) cada pieza ocupa en la solución **tantas celdas como tiene su forma**; (f) las celdas de la solución de cada pieza son **una orientación trasladada** de su forma; (g) los umbrales son coherentes (RN-HF-63) | Enunciado §1.2, HU LVL-02 | 🟡 |
| RN-HF-13 | La solución de referencia **nunca se le muestra al jugador**. Sirve para garantizar que todo nivel publicado tiene solución | Diseño | 🟡 |

## 3. Hexa Sort

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-HS-11 | La sección específica del nivel contiene: **número de metas**, **paleta** de colores (3 a 6), **semilla**, **parámetros de generación** (RN-HS-21) y, opcionalmente, **pilas iniciales** en celdas concretas | HU HS-01, Enunciado §5.2 | 🟡 |
| RN-HS-12 | Validaciones del nivel: metas ≥ 1; paleta de 3 a 6 colores distintos; parámetros de generación coherentes; las pilas iniciales están dentro del tablero, usan colores de la paleta y **ninguna tiene un bloque de cima de 10 o más**; queda al menos una celda vacía | Diseño | 🟡 |

## 4. Ejemplo

**E-HF-NIVEL.** El nivel de ejemplo de `02-RN-HEXA-FIT.md` §13, con solución de referencia: A ocupa `{(2,−1), (2,0), (1,1)}` y B ocupa `{(0,0), (1,0), (0,1)}`. Cumple (a)–(g). Variaciones que deben fallar, cada una con su prueba:
- La pieza B con 4 celdas → falla (a).
- La solución de A incluye `(3,0)`, que no está en la figura → falla (d).
- La solución de A ocupa `{(0,0), (1,0), (2,0)}` (una línea, no un arco) → pasa (a)–(e) en el backend, pero **falla (f)** en el validador de la app.
