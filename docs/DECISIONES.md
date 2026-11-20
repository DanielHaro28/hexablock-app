# DECISIONES — hexablock-app

> Registro de las **decisiones cerradas** que afectan a `hexablock-app`: las del equipo (`D-*`) y las respuestas del profesor o del enunciado (`P-*`).
>
> - Las decisiones **abiertas** están en `hexablock-app/docs/PENDIENTES.md` §1.1. Al cerrarse, pasan aquí con su fecha y se borran de allí.
> - Este archivo reúne **todas** las decisiones del proyecto; la columna *Repos* dice a cuál afecta cada una.
> - Las decisiones que afectan a los dos repos aparecen **con el mismo texto** en el `DECISIONES.md` de `hexablock-api` (columna *Repos*: **Ambos**). Si cambian, se cambian en los dos.
> - Si un documento citado en *Dónde quedó* no está en este repo, está en `hexablock-api`.
> - Una decisión cerrada solo se reabre si el equipo lo decide explícitamente. Los IDs nunca se reutilizan.
>
> **Última actualización:** 2026-11-19

---

## 1. Decisiones del equipo

### Organización y flujo de trabajo

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-01 | Los repos están en la cuenta de **DanielHaro28**, que los creó y los administra | ADR-001 §2.4 | Ambos | 11-11 |
| D-24 | La protección de `main` exige PR y CI en verde, pero **no** la aprobación de otra persona; autorrevisión con la plantilla de PR y revisión de un compañero recomendada | ADR-001 §2.4, SECURITY §7, SEC-AGT-05, 07 | Ambos | 11-11 |

### Cuenta, progreso y ranking

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-04 | Ranking por nivel de Hexa Sort: **movimientos ↑ → puntaje ↓** (menos pilas colocadas primero; el puntaje desempata) | RN-COM-103, RN-HS-71 | Ambos | 11-11 |
| D-05 | Al iniciar sesión con progreso de invitado, la app **pregunta** "¿importar tu progreso?"; si acepta, se consolida | RN-COM-88 | Ambos | 11-11 |
| D-06 | Al cerrar sesión, el dispositivo **vuelve al perfil invitado** con su propio progreso; el de la cuenta queda guardado localmente | RN-COM-89 | Ambos | 11-11 |

### Reglas de juego

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-08 | Catálogo de Hexa Lines: **8 familias, 24 piezas**, con los pesos propuestos | RN-HL-23 | App | 11-11 |
| D-09 | Puntaje de Hexa Lines: **celdas + ⌊5 × largo × L × racha⌋**, racha (k+1)/2 con máximo ×3 | RN-HL-60 a 64 | App | 11-11 |
| D-10 | Hexa Fit: colocar/mover/retirar cuentan como movimiento; rotar/deshacer/rehacer no. **Estrellas independientes:** ★ completar + ★ movimientos ≤ `m` + ★ tiempo ≤ `t`. Por eso un nivel completado tiene de 1 a 3 estrellas, que es lo que valida el servidor | RN-HF-61 a 64, E-HF-1, RN-COM-108, SEC-API-06 | Ambos | 11-11 |
| D-11 | Pilas de Hexa Sort: altura 2–6, hasta 3 bloques, color distinto del bloque anterior | RN-HS-21 | App | 11-11 |
| D-12 | Puntaje de Hexa Sort: 1 por ficha transferida + 100 por meta (solo desempata el ranking; ver D-04) | RN-HS-60 | Ambos | 11-11 |
| D-13 | Hexa Merge: **90 % de 2 / 10 % de 4**; celda al azar entre las vacías en orden de lectura | RN-HM-21 | App | 11-11 |
| D-14 | Generador aleatorio **xorshift32 propio** en el dominio | RN-COM-43 | App | 11-11 |
| D-15 | Desempate de la cascada de Hexa Sort: gana la pila **evaluada** (la colocada, en el primer paso) si está empatada; si no, la **primera vecina empatada en sentido horario desde las 12**. Los orígenes también transfieren en ese orden | RN-COM-17, RN-HEX-08, RN-HS-42, RN-HS-43, E-HS-8 | App | 11-11 |
| D-16 | Hexa Sort: al llegar a 10 o más se elimina **solo el bloque de cima, completo** (aunque sean 12); lo de abajo queda en la celda | RN-HS-50 | App | 11-11 |
| D-17 | Hexa Sort: "la pila con más fichas de ese color" = la de **bloque de cima más grande** | RN-HS-40, RN-HS-41 | App | 11-11 |

### Topologías (figura de las celdas)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-18 | **Topologías:** solo rejillas regulares. Hexágonos (dominio + app, Must); cuadrados y triángulos (dominio + app 2D, Should); cubos (dominio con pruebas, Should; vista 3D, Could) | RN-COM-18, RN-TOP-01 a 04 | Ambos | 11-11 |
| D-25 | **El jugador elige la figura de las celdas en Ajustes** (solo las disponibles; hexágonos por defecto). La figura se fija al crear la partida y **no se puede cambiar durante ella**: la opción se bloquea mientras haya una partida en curso o en pausa | RN-COM-19, RN-COM-113, RN-TOP-30, 31; RF-09; NAV-08 | Ambos | 11-11 |

### Arquitectura general (Paso 2)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-21 | **Paquetes de la app:** pub workspace con **4 paquetes Dart puros** y la app Flutter. Capa 1: `hexa_engine`, `hexa_topologies` y `hexa_variants` (una carpeta por variante). Capa 2: `hexa_application` (casos de uso genéricos, puertos y aspectos). Capas 3 y 4: la app (`lib/adapters/` = capa 3; `lib/frameworks/`, `lib/config/` y `main.dart` = capa 4). Los paquetes de las capas 1 y 2 no tienen dependencias de terceros (enunciado §3.4) y su `pubspec` impide importar capas externas | ARQ-01-APP §3, ARQ-A-02 a 04 | App | 17-11 |
| D-22 | **Estructura del backend:** módulos por área (`auth`, `users`, `progress`, `leaderboard`, `levels`, `health`) con `domain/` (capa 1), `application/` (capa 2: casos de uso y puertos), `presentation/` e `infrastructure/` (capa 3: controladores y DTOs; adaptadores que implementan los puertos, como repositorios Prisma, argon2 y JWT). `main.ts`, `src/prisma/` y la configuración de NestJS son capa 4. **Un caso de uso por clase.** Cómo se guarda el progreso (JSON) queda para D-27 | ARQ-01-API §2 a §4, ARQ-B-01, 02 | API | 17-11 |
| D-23 | **Contrato entre app y API:** `openapi.yaml` y los ejemplos compartidos (E-COM-2, E-COM-3, E-HF-NIVEL) viven en `hexablock-api/docs/contracts/`, la fuente única. La API valida sus respuestas contra ese archivo; la app guarda una **copia** para probar sus mappers y su CI **falla si la copia difiere** de la del repo de la API (es la herramienta "equivalente a Pact" del enunciado §3.6) | ARQ-00 §6 (ARQ-S-05), ARQ-01-API §9 (ARQ-B-05) | Ambos | 17-11 |

### Arquitectura detallada (Paso 4)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-38 | **Forma de los casos de uso:** una interfaz única `UseCase<TIn, TOut>` con un solo método `execute` (en Dart `Future<TOut> execute(TIn input)`; en TypeScript `execute(input: I): Promise<O>`). La entrada es un solo objeto o *record*. Así un mismo aspecto envuelve cualquier caso de uso (enunciado §3.5) | ARQ-03-APP §1, ARQ-03-API §1 | Ambos | 19-11 |
| D-39 | **Errores:** por dentro, **excepciones tipadas** (los adaptadores traducen los errores técnicos a excepciones de la aplicación y el caso de uso no las maneja); hacia afuera, una salida uniforme: en la app, un **`Result` *sealed*** (éxito o fallo tipado) que entrega el aspecto de errores a la pantalla; en el backend, el **filtro global de errores** de NestJS convierte cada error tipado en **Problem Details (RFC 9457)**, como se ajustó en D-51 (RF-91). Sin librerías externas (D-21). Las excepciones no tipadas son errores de programación | ARQ-03-APP §2, ARQ-03-API §2 | Ambos | 19-11 (backend ajustado por D-51) |
| D-40 | **Aspectos de la app (4):** registro (logging) con el tablero antes y después de cada movimiento solo en modo desarrollo y con redacción de contraseñas, tokens y correos; métricas de tiempo (`ApplyMove`, `StartGame`; RNF-31); errores centralizados en todos los casos de uso, con reintentos solo en los que usan red; sesión (comprobación local del JWT, sin red) solo en los casos de uso que necesitan cuenta. Jugar, guardar el progreso y guardar la partida nunca pasan por el aspecto de sesión. La caché del ranking es opcional | ARQ-03-APP §5; SEC-WEB-06, SEC-MOB-04, 05 | App | 19-11 |
| D-41 | **Orden de los aspectos:** de afuera hacia adentro, sesión → errores y reintentos → métricas → registro → caso de uso. Lo arma un ayudante (`AspectChain`) en el *composition root*, con una línea por caso de uso | ARQ-03-APP §5.2 | App | 19-11 |
| D-42 | **AOP en el backend:** clases decoradoras sobre `UseCase<I, O>` (registro con redacción, métricas y caché del ranking), igual que en la app. Lo propio de HTTP queda en los mecanismos de NestJS: guards (JWT y roles), filtro global de errores, `ValidationPipe`, throttler y el registro de accesos HTTP de SEC-WEB-06 | ARQ-03-API §4; ARQ-01-API §5 (ARQ-B-04) | API | 19-11 |
| D-43 | **Diagramas:** el de clases en **PlantUML** (notación UML de plantilla, §4.1; se mantiene P-11), un archivo por repo; las imágenes las genera DanielHaro28 con la extensión de PlantUML de VS Code, sin robot de CI. Capas y extensibilidad en **Mermaid**, con imágenes generadas y comprobadas al escribirlos. Todo en `docs/diagrams/` | docs/diagrams/, ADR-001 §2.5 | Ambos | 19-11 |

### Contratos (Paso 5)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-19 | **Quién revisa los niveles (opción A).** El backend revisa el esquema y las reglas **estructurales** (RN-HF-12 a–e y g, RN-HS-12) y rechaza con `400 invalid-level`; el dominio de la app revisa además la **geométrica** (RN-HF-12 f), en CI para los niveles incluidos y al descargar. Antes de publicar por la API, el nivel se pasa por el validador de la app (RF-83). Un nivel que pasara el servidor pero fallara (f) lo descarta la app y el jugador nunca lo ve (RN-COM-71) | RN-COM-76, RF-82, RF-83, ARQ-00 §6, ARQ-04-API §5 | Ambos | 19-11 |
| D-27 | **Progreso, récord y ranking separados por figura (opción B).** En el servidor, **una entrada de progreso por usuario y `gameId`** (cumple el enunciado §5.2 al pie de la letra) con **una sección por figura** dentro del JSON. La sincronización es `PUT /v1/me/progress/{gameId}` con las secciones que cambiaron, y el servidor consolida sección por sección. `BEST_ATTEMPT` lleva la columna `topology`, porque el ranking la filtra | RN-TOP-33, RN-COM-80, 100; ARQ-01-API §6 y ARQ-B-03 | Ambos | 19-11 |
| D-44 | **Sesión: un solo JWT válido 24 h (opción A).** Al vencer, la app pide iniciar sesión antes de sincronizar y se sigue jugando sin conexión (RN-COM-87). El token de renovación (refresh) queda para después: sería un endpoint nuevo y no rompe el contrato | SEC-API-02 | Ambos | 19-11 |
| D-45 | **Forma del progreso: dos formas según el modelo de progreso (opción B, `IProgressModel`).** Récord para Lines y Merge (`kind: "highScore"`, con el mejor puntaje y su fecha) y niveles para Fit y Sort (`kind: "levels"`, un mapa `levelId` → mejor intento; un nivel está completado si aparece en el mapa). Una consolidación por forma; una 5.ª variante reutiliza una de las dos | RN-COM-80, ARQ-B-03; esquema en `docs/contracts/` (Paso 5) | Ambos | 19-11 |
| D-46 | **Convenciones de la API (opción A).** Se apoyan en estándares: fechas ISO 8601 / RFC 3339 en UTC; códigos de estado, `ETag` y `304` según HTTP (RFC 9110). Y en convenciones muy usadas, aunque no son norma: versión mayor en la ruta (`/v1`, como Google AIP-185; `/health` queda sin versión) y nombres en `camelCase` (Google JSON Style Guide). Duraciones en milisegundos, usuarios con UUID, paginación con `limit` (1–100, 20 por defecto) y `offset`. El formato de errores sigue siendo el de D-39 hasta que se cierre D-51 | ARQ-03-API §3; `openapi.yaml` (Paso 5) | Ambos | 19-11 |
| D-47 | **Identidad y formato de los niveles.** `id` legible, escrito a mano y que nunca cambia: `<variante>-<figura>-<nnn>` (ej. `fit-hex-001`, `sort-any-004`); el orden lo da `order`. Archivos **JSON** validados por el mismo `level.schema.json` en la app (CI) y en la API. Celdas como **listas de enteros** (`[q, r]`, `[x, y]`, `[x, y, z]`): la lista es solo la dirección; lo que hay en la celda va en la sección `variant`, **distinta según el `gameId`** (condición del usuario: cada juego guarda sus propios datos) | RN-COM-70; `docs/contracts/schemas/level.schema.json` | Ambos | 19-11 |
| D-48 | **Descarga de niveles por cambios (opción B).** `GET /v1/levels?gameId=…&topology=…&cursor=…&limit=100` devuelve los niveles creados o actualizados después de un cursor que genera el servidor, en páginas de hasta 100, más `nextCursor`. No depende del reloj del teléfono y escala a miles de niveles. Los niveles **no se borran** (solo `POST` y `PUT` subiendo la `version`). Es la única ruta paginada por cursor; el ranking sigue con `limit` + `offset` (D-46) | RN-COM-77; ARQ-00 §5; ARQ-01-API §6; RF-80, LVL-01 | Ambos | 19-11 |
| D-49 | **Base local y sincronización incremental (opción B).** En Drift, una fila por resultado (`level_results`) y una por récord (`records`), cada una con una marca de pendiente de enviar; no hay tabla de cola aparte. Al sincronizar se envía **solo lo que cambió**, con la forma de D-45; es seguro porque la consolidación da lo mismo sin importar el orden ni las repeticiones (RN-COM-84). El progreso completo solo se baja al iniciar sesión en un dispositivo nuevo (RN-COM-90). Tablas: `profiles`, `level_results`, `records`, `downloaded_levels`, `level_sync_cursors` y `saved_games` | RN-COM-86; ARQ-S-04; ADR-001 §2.1; ARQ-01-APP §4 | Ambos | 19-11 |
| D-51 | **Errores con Problem Details (RFC 9457)** (reabre la parte del backend de D-39, a pedido del usuario). `application/problem+json` con `type` (URI absoluta y fija por tipo en el dominio público de la API; la app no la abre), `title` y `detail` fijos en inglés y sin valores enviados ni datos internos (CWE-209), `status`, `instance` = `urn:uuid:<correlation id>` (ASVS 7.4.1) y los campos propios `code` (`kebab-case`, el que lee la app) y `errors` (JSON Pointer + código, sin el valor). 401 con `WWW-Authenticate: Bearer` (RFC 6750); 429 con `Retry-After` (RFC 6585); el filtro atrapa también los errores del framework (CWE-211); la app muestra solo sus textos traducidos por `code`, nunca `detail` | ARQ-03-API §2, ARQ-03-APP §2, SEC-API-08, SEC-WEB-07, RF-91, TEC-05 | Ambos | 19-11 |
| D-52 | **Contraseñas (opción A, NIST SP 800-63B rev. 4):** de 15 a 128 caracteres, porque la contraseña es el único factor; sin reglas de composición ni cambio obligatorio; espacios y Unicode permitidos; nunca se truncan; se rechazan las de una lista pública de contraseñas comunes incluida en el backend. Errores `too-short`, `too-long` y `too-common`, sin repetir la contraseña | SEC-API-02, API-01, `openapi.yaml` (`Password`) | Ambos | 19-11 |
| D-50 | **Nombre visible único (opción A):** sin distinguir mayúsculas, de 3 a 20 caracteres (letras, números, espacio, `_`, `-` y `.`). Si ya existe, `409` con el código `display-name-taken` (escritura ajustada por D-51) | RN-COM-109, glosario, RF-70, API-01 | Ambos | 19-11 |

### Contenido y pruebas (Paso 6)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-26 | **Una sola figura para todo el juego** (las 4 variantes), elegida en Ajustes; la clasificación muestra la de esa figura. Mientras solo exista hexágonos, la opción queda oculta (DIS-07) | RN-TOP-32, RF-09, NAV-08; DIS-04, DIS-07 | App | 20-11 |
| D-28 | **Niveles por figura:** los 15 de Fit en hexágonos; de los 10 de Sort, los 6 primeros sin pilas iniciales con `topology: any` (sirven para todas las figuras) y los 4 últimos en hexágonos, con pilas iniciales como obstáculos. Fit suma 3 niveles de muestra por figura cuando cada figura esté implementada. Sin niveles para la figura elegida, la tarjeta dice "No disponible con esta figura" | RN-TOP-34, RN-COM-75; D-55 | Ambos | 20-11 |
| D-61 | **Niveles incluidos también en la API (opción A).** La fuente es `hexablock-app/app/assets/levels/`. La API guarda una copia en `prisma/seed/levels/`, la publica con el *seed* al desplegar (validada con las reglas estructurales) y su CI falla si la copia difiere de la app. Así la revisión de plausibilidad y el ranking por nivel conocen los 25 niveles | ARQ-04-API §3, §5; ESTRATEGIA-PRUEBAS (API) §9 | Ambos | 20-11 |
| D-53 | **Diseño de niveles (opción D).** Ahora, un **generador como herramienta de autor** (`tools/`, fuera de la app) propone niveles que cumplen D-54 y D-55; el equipo los elige, juega, ajusta y nombra, y al APK entran archivos JSON fijos. Al final, si sobra tiempo después de los *Must*, un modo extra con generador dentro del juego (*Could*). Antes de usar los niveles generados se pregunta al profesor si cuentan como "diseñados manualmente" (P-14); si dice que no, se diseñan a mano y el generador queda como ayuda para verificar | `tools/reference-sim/`; P-14 | App | 20-11 |
| D-54 | **Curva de dificultad y umbrales de Hexa Fit.** Niveles 1–3: 2 a 3 piezas y 6 a 10 celdas; 4–7: 3 a 4 piezas y 10 a 16 celdas; 8–11: 4 a 5 piezas y 16 a 24 celdas; 12–15: 5 a 7 piezas y 24 a 36 celdas, con 4 soluciones o menos. `levelkit.py` mide cada nivel y el esfuerzo de búsqueda debe crecer de un tramo al siguiente. Umbrales: `m` = piezas + 1, `t` = 20 s por pieza; se ajustan después de jugarlos | RN-HF-12, 62, 63; `tools/reference-sim/levelkit.py` | App | 20-11 |
| D-55 | **Curva de dificultad de Hexa Sort** (medida con `levelkit.py`). Niveles 1–2: 1 a 2 metas, 3 colores; 3–4: 3 metas, 3 a 4 colores; 5–6: 5 metas, 4 a 5 colores; 7–8: 8 metas, 5 colores y 2 o 3 pilas iniciales; 9–10: 10 a 12 metas, 6 colores y pilas iniciales. Cada semilla elegida debe poder ganarla el jugador voraz; la dificultad se mide por sus movimientos | RN-HS-11, 12, 21; `levelkit.py` | App | 20-11 |
| D-56 | **Dobles de prueba (opción C):** *fakes* y *stubs* escritos a mano por defecto (repositorios en memoria, reloj falso, xorshift real con semilla fija, gateway que responde con los ejemplos del contrato); *mocks* (`mocktail`, `jest.fn()`) solo para verificar una llamada sin otro efecto visible. Las librerías de *mocks* son solo de desarrollo. Los escribe la IA junto con las pruebas y el equipo los revisa (D-59) | Estrategia de pruebas de cada repo | Ambos | 20-11 |
| D-57 | **Base de datos de las pruebas de integración en memoria.** App: Drift con `NativeDatabase.memory()`. API: PostgreSQL real como *service container* de GitHub Actions con los datos en `tmpfs` (RAM), el mismo motor que producción. Costo: los repos son públicos y los *runners* estándar no gastan minutos; el contenedor suma unos segundos por ejecución | Estrategia de pruebas de cada repo; ARQ-04-API | Ambos | 20-11 |
| D-58 | **Cobertura mínima que hace fallar el CI:** dominio ≥ 90 %, casos de uso ≥ 80 %, total ≥ 70 %, en los dos repos. La interfaz cuenta en el total pero no tiene umbral propio | Estrategia de pruebas; CI | Ambos | 20-11 |
| D-59 | **Pruebas del código generado por IA (opción C):** la IA escribe el código y sus pruebas, y el equipo las revisa y ajusta antes de aprobar el PR; en `AI_USAGE.md` queda qué ajustó cada integrante. Puede cambiar a B (primero las pruebas del equipo) si en la práctica la revisión no alcanza. Riesgo aceptado: el enunciado §7.3 dice "preferiblemente" el equipo, así que C se permite, pero deja menos evidencia propia | Estrategia de pruebas; plantilla de PR; AI_USAGE | Ambos | 20-11 |
| D-60 | **Precisión de RN-HS-21 (opción A):** el color de cada bloque después del primero se elige entre los colores de la paleta **menos el anterior**, con `siguiente() mod (tamaño − 1)`; orden fijo (altura, bloques, reparto, colores, de abajo hacia arriba). Cada pila gasta siempre la misma cantidad de números. Ejemplo E-HS-GEN. Precisa D-11, no la reabre | RN-HS-21, E-HS-GEN | App | 20-11 |

### Plan (Paso 7)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-62 | **Reparto por área con revisor cruzado.** @dicpc: interfaz de la app (tema, pantallas, navegación, textos, pruebas de *widget*). @DavidCR20: dominio y aplicación de la app (motor, topologías, variantes, casos de uso, aspectos, Drift). @DanielHaro28: backend y DevOps (NestJS, Prisma, AWS, CI de los dos repos) y los adaptadores HTTP de la app; también Hexa Merge, para aliviar el dominio. Cada área tiene un **responsable, no un dueño exclusivo**: cualquiera puede ayudar en otra sección. Cada PR lo revisa alguien de otra área. Estimación: 95 a 135 h por persona (con Claude Code), que se recalcula al cerrar M1 | CODEOWNERS; Issues; `docs/plan/PLAN-ENTREGA.md` | Ambos | 20-11 |
| D-63 | **Milestones semanales.** M0 · Preparación (20 al 23-11); M1 · Base jugable con **una sola variante, Hexa Lines** (24 al 30-11); M2 · Las otras tres variantes y los niveles (1 al 7-12); M3 · Conectado y entregable (8 al 12-12); 13 y 14-12 de margen y ensayo. Las topologías extra (TEC-07 a 09) quedan sin milestone, solo si sobra tiempo | Milestones de GitHub; `docs/plan/PLAN-ENTREGA.md` | Ambos | 20-11 |
| D-64 | **Definition of Done** (Scrum Guide 2020: descripción formal del estado del incremento cuando cumple las medidas de calidad; es binaria y la crea el equipo). Una historia está hecha cuando: (1) cumple sus criterios de aceptación; (2) tiene pruebas con la convención del enunciado §3.6 y los ejemplos `E-*` que le tocan, revisadas por una persona (D-59); (3) el CI está en verde: formato, análisis, pruebas, cobertura (D-58), arquitectura (D-36) y contrato (D-23); (4) el PR usa la plantilla y lo revisó alguien de otra área; (5) los textos están en es y en, sin textos fijos; (6) si es una pantalla, sigue el diseño acordado (D-66); (7) documentos, trazabilidad y `AI_USAGE.md` al día (enunciado §7); (8) está fusionada en `main` y funciona en el APK de desarrollo o, en la API, desplegada en EC2. No hay "casi hecho": si falta un punto, la historia sigue abierta | Plantillas de Issue y de PR; ESTRATEGIA-PRUEBAS | Ambos | 20-11 |
| D-65 | **Organización en GitHub.** Un Issue por historia (en los dos repos para las compartidas, enlazados) y por tarea de configuración; etiquetas `type:`, `area:`, `variant:` y `priority:`; los milestones de D-63 en los dos repos; plantillas de Issue (historia, tarea, *bug*) con la Definition of Done (D-64); un tablero de GitHub Projects con los dos repos (Backlog → Por hacer → En curso → En revisión → Hecho) y un campo de horas. Los Issues, etiquetas y milestones se crean con `gh`; el tablero lo crea el dueño desde la web | Issues, `.github/ISSUE_TEMPLATE/`, `docs/plan/PLAN-ENTREGA.md` | Ambos | 20-11 |
| D-66 | **Ajustes al diseño inicial aceptados** (DIS-01 a DIS-16, `docs/design/REVISION-DISENO.md`). El diseño de @dicpc es una propuesta visual que se adapta a lo definido. Cambios en reglas: RN-HL-71 (salir también guarda el récord, como en Merge) y NAV-05 / RF-08 pasa a *Should*. El PDF queda en `docs/design/` | REVISION-DISENO; RN-HL-71; RF-08 | Ambos | 20-11 |

### Partida y persistencia local

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-37 | **Partida guardada:** tabla Drift `saved_games`, una por perfil, variante y figura. Se guarda **después de cada turno válido** y al pasar la app a segundo plano (estado completo, generador, historial de deshacer y tiempo activo). Al volver se ofrece **Continuar** y la partida sigue **en pausa**; el tiempo con la app cerrada no cuenta. Se borra al terminar la partida o al empezar otra de la misma variante y figura | RN-COM-32 a 35, RF-64, NAV-04, ARQ-01-APP §4.2, ADR-001 §2.1 | App | 17-11 |

### Motor genérico (Paso 3)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-07 | **Coordenada como parámetro genérico (opción A).** `Board<TCoord extends Coord, TCell>`, `GridTopology<TCoord>`, `IGameRules<TCoord, TCell, TMove, TState>` y `GameEngine<TCoord, TCell, TMove, TState>`; `HexBoard<TCell>` es un `typedef` de `Board<HexCoord, TCell>` en `hexa_topologies` | ARQ-01-APP §4.1, §9; ARQ-02 §3; TEC-01; glosario | App | 11-11 |
| D-29 | **Despacho de la figura:** registro de topologías + **Visitor** genérico (`accept` → `visit<C>`), sin `switch` ni casts; en la app, cada figura se registra junto con su layout. `TCoord` llega hasta el widget del tablero | ARQ-02 §3 | App | 17-11 |
| D-30 | **Tipos genéricos:** estado **inmutable**; celda vacía = `null` con `TCell extends Object`; movimientos *sealed* por variante; `TState extends GameState<C, TCell>`; en Hexa Merge, `Tile implements Mergeable<Tile>` en vez de `int`. Instanciación por variante en ARQ-02 §4.2 | ARQ-02 §4 | App | 17-11 |
| D-31 | **Deshacer y rehacer:** **Command + Memento** con un `UndoHistory` genérico que configura la fábrica de cada variante (sin límite + rehacer en Fit; límite 1 sin rehacer en Merge; nada en Lines y Sort); la fase decide si se puede deshacer | ARQ-02 §5 | App | 17-11 |
| D-32 | **Eventos de dominio:** las reglas **devuelven** los eventos en orden; la pantalla los recibe como **valor de retorno** de `submit` (`MoveResult`). El `Stream` del motor (Observer) queda para el historial y el cronómetro (síncronos) y para el audio y la analítica. Base `abstract base` y una familia *sealed* por variante | ARQ-02 §6 | App | 17-11 |
| D-33 | **Capacidades opcionales:** `IUndoable`, `ITimed`, `IRandomSeeded` e `ILevelBased`, implementadas por componentes que la fábrica compone en una `GameSession` (Lines no tiene `IUndoable`); puerto `IMonotonicClock` en el dominio | ARQ-02 §7 | App | 17-11 |
| D-34 | **Fases de la partida:** patrón **State** con una jerarquía *sealed* (`PlayingPhase`, `ResolvingPhase`, `PausedPhase`, `VictoryPhase`, `GameOverPhase`); `Victory(canContinue)` para que Hexa Merge siga tras la victoria | ARQ-02 §8 | App | 17-11 |
| D-35 | **Patrones de diseño del dominio (14).** Creacionales: Abstract Factory, Builder, Factory Method. Estructurales: Bridge, Composite, Decorator. De comportamiento: Strategy, Template Method, State, Observer, Command, Memento, Iterator, Visitor. Cómo se protege el Template Method sigue abierto en D-36 | ARQ-02 §9 | App | 17-11 |
| D-36 | **Protección del Template Method (opción B):** regla en la plantilla de PR y una prueba de arquitectura en CI que falla si alguna clase de `hexa_variants` declara `playTurn`. Sin `package:meta`, porque el enunciado §3.4 no permite dependencias externas en la capa 1; la composición queda descartada porque el §3.3 pide una clase abstracta | ARQ-02 §9.6; plantilla de PR | App | 20-11 |

## 2. Respuestas del profesor y del enunciado

> **Indicación del profesor (11-11):** lo que el enunciado no especifica **lo decide el equipo**. Por eso no quedan preguntas abiertas: las que el enunciado no resolvía pasaron a decisiones del equipo.

| ID | Pregunta | Respuesta | Fuente | Repos | Fecha |
|---|---|---|---|---|---|
| P-01 | ¿Se aceptan repos públicos? | **Sí** | Profesor | Ambos | 11-11 |
| P-02 | ¿Se pueden rotar las piezas en Hexa Lines? | **No**. La tabla 1.5 indica "Colocar pieza" para Lines y "Colocar / retirar / rotar" solo para Fit | Enunciado §1.5 | App | 11-11 |
| P-03 | ¿La bandeja de Hexa Sort ofrece 1 pila o varias? | **1**: "coloca en una celda vacía *la pila* que la bandeja le ofrece" | Enunciado §1.3 | App | 11-11 |
| P-04 | Desempate de la cascada de Hexa Sort | El enunciado no lo fija → **D-15** (decisión del equipo) | Profesor: lo decide el equipo | App | 11-11 |
| P-05 | ¿La derrota en Hexa Sort es tablero lleno? | **Sí**: "el tablero se llena sin movimientos válidos". Como el único movimiento es colocar en una celda vacía, tablero lleno = sin movimientos. Se evalúa **después** de resolver la cascada y retirar las metas | Enunciado §1.3 | App | 11-11 |
| P-06 | ¿Se puede seguir jugando tras 2048? | **Sí**. §5.1 exige Hexa Merge "en modo partida sin fin con registro de puntaje máximo". La pantalla de victoria ofrece "Seguir jugando" además de "Nueva partida" | Enunciado §5.1 | App | 11-11 |
| P-07 | Orden del ranking por nivel de Hexa Fit | **Estrellas (desc) → tiempo (asc) → movimientos (asc)**, comparando el **mismo intento** completo (no la mejor estrella de un intento con el mejor tiempo de otro) | Profesor | Ambos | 11-11 |
| P-08 | ¿Jugar sin cuenta y sincronizar después? | **Sí**. Modo invitado con progreso local; un usuario registrado sin conexión sigue jugando y sincroniza al reconectar. API-05 pasa de *Should* a **Must** | Profesor | Ambos | 11-11 |
| P-09 | ¿Basta con endpoints de admin + Swagger para publicar niveles? | **Sí**: §5.2 pide un "endpoint para obtener y actualizar la definición de niveles"; no pide interfaz de administración | Enunciado §5.2 | Ambos | 11-11 |
| P-10 | ¿Historias técnicas como HU o aparte? | El enunciado no exige HU: **decisión del equipo**. Se mantienen como historias habilitadoras (TEC) en el backlog | Enunciado (no lo regula) | Ambos | 11-11 |
| P-11 | ¿Mermaid o notación UML de plantilla en el diagrama de clases? | **Notación UML de plantilla** (§4.1) → diagrama de clases en **PlantUML** | Enunciado §4.1 | Ambos | 11-11 |
| P-12 | Hexa Sort: ¿se elimina la pila o el bloque de 10? | El enunciado no lo fija → **D-16** (decisión del equipo) | Profesor: lo decide el equipo | App | 11-11 |
| P-13 | Hexa Sort: ¿"cantidad de ese color" es el bloque de cima o el total? | El enunciado no lo fija → **D-17** (decisión del equipo) | Profesor: lo decide el equipo | App | 11-11 |
| P-14 | ¿Cuentan como "diseñados manualmente" los niveles que propone un generador y que el equipo elige, juega, ajusta y nombra? | **Sí** (respuesta registrada por el usuario el 20-11) → se usan los niveles del generador después de la revisión del equipo (D-53, R-05) | Profesor (vía el usuario) | App | 20-11 |
