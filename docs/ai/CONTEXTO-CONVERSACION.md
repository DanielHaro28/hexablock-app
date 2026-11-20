# Contexto del proyecto HexaBlock Suite (para retomar con una IA)

> **Para qué sirve:** retomar la planificación en otra conversación o herramienta (Claude, Claude Code, Cline…) sin perder nada de lo decidido. Es una **foto del estado actual**; el detalle está en los documentos que se citan.
>
> **Última actualización:** 2026-11-17 · **Idioma de trabajo:** español (código, commits y README en inglés).
>
> **Va junto con:** `docs/PENDIENTES.md` (estado de todo lo que falta) y el prompt `PROMPT-NUEVA-CONVERSACION.md`.

---

## 1. Reglas de trabajo para el asistente

1. Lee este archivo y `PENDIENTES.md` antes de responder. El **enunciado** es la fuente de verdad del proyecto.
2. **No reabras decisiones cerradas** (`docs/DECISIONES.md` de cada repo) salvo que el usuario lo pida.
3. **Cada vez que una respuesta cambie algo o mencione un documento, actualiza ese documento en el momento y entrégalo** (incluido `PENDIENTES.md`). Pedido explícito del usuario.
4. Los **documentos compartidos** existen en los dos repos y deben quedar **idénticos**: se actualizan las dos copias.
5. Las decisiones de **diseño** (genéricos, patrones, capas) **las toma el equipo** (§7.3 del enunciado): el asistente propone opciones con ventajas y desventajas, recomienda y documenta, pero no decide.
6. Lo que el enunciado no especifica **lo decide el equipo** (indicación del profesor, 11-11). No hay preguntas pendientes al profesor.
7. Todo ejemplo de reglas (tableros antes/después, fórmulas) se **verifica con código** antes de escribirlo. El simulador de referencia está en `tools/reference-sim/`.
8. Los diagramas Mermaid se comprueban renderizándolos antes de entregarlos.
9. Responder en español, directo y sin repetir lo que ya está documentado.

## 2. El proyecto en una página

- **Materia:** Desarrollo de Software (NRC 15671). Proyecto semestral en grupo de **3 personas**, 20 puntos. **Entrega: lunes 14-12-2026.**
- **Qué se construye:** *HexaBlock Suite*, una app móvil Android con **4 juegos de tablero** sobre **un único motor genérico**, más un **backend REST** siempre desplegado.
- **Lo que más se evalúa:** que exista **un solo motor**, con genéricos y restricciones de tipo, SOLID, patrones GoF (Strategy y Abstract Factory obligatorios), Clean Architecture en 4 capas, al menos 1 aspecto AOP con decoradores, pruebas con CI, 3 diagramas (clases con **notación UML de plantilla**, capas, extensibilidad), `EXTENSIBILITY.md`, README en inglés, `AI_USAGE.md`, Conventional Commits en inglés y el APK en un GitHub Release. En la defensa piden **en vivo** una 5ª variante o un cambio de regla, y el profesor avisó que podría pedir **otra figura de celda** (triángulos, cuadrados o cubos).

| Variante | Mecánica | Tablero (hexágonos) | Fin | Progreso | Deshacer |
|---|---|---|---|---|---|
| **Hexa Lines** | Colocar piezas de 1 a 5 celdas (bandeja de 3, sin rotación); se borran líneas completas en todos los ejes | Radio 4 (61) | Ninguna pieza cabe | Récord | No |
| **Hexa Fit** | Cubrir una figura con un set fijo de piezas; rotar en la bandeja | Figura del nivel | Figura cubierta (sin derrota) | ≥ 15 niveles con estrellas | Ilimitado + rehacer |
| **Hexa Sort** | Colocar pilas de colores; transferencia en cascada; bloque de 10 = meta | Radio 2 (19) | Metas / tablero lleno | ≥ 10 niveles | No |
| **Hexa Merge** | 2048 deslizando en las direcciones de la topología; ficha nueva con semilla | Radio 2 (19) | Ficha objetivo (se puede seguir) / sin movimientos | Récord | 1 movimiento |

## 3. Decisiones vigentes (resumen)

El detalle y la fecha de cada una están en `docs/DECISIONES.md` (en la app, todas; en la API, las que la afectan).

**Stack e infraestructura (ADR-001, rev. 1.7):**
- **App:** Flutter + Dart 3; pub workspace con paquetes Dart puros; `CustomPainter` (sin Flame); `flutter_bloc` (Cubit); `get_it`; **Drift** (SQLite); `shared_preferences` (solo ajustes); `flutter_secure_storage` (JWT); `dio`; i18n con ARB; `--dart-define=API_BASE_URL`.
- **Backend (impuesto por la cátedra):** NestJS + TypeScript, PostgreSQL, Prisma, JWT + argon2id (ADR rev. 1.7), `class-validator` con whitelist, `helmet`, `@nestjs/throttler`, Swagger con `openapi.yaml` como contrato, Jest + Supertest, Docker.
- **Despliegue:** AWS EC2 `t3.small` en `us-east-1` con Docker Compose (Caddy + API + Postgres), HTTPS con Let's Encrypt sobre DuckDNS, imágenes en GHCR, deploy por SSH desde Actions. Hay que crear el budget de AWS antes de lanzar la instancia (W-01).
- **GitHub:** repos **públicos** `hexablock-app` y `hexablock-api` en la cuenta de **DanielHaro28** (D-01). Ruleset `protect-main` en ambos: PR obligatorio **sin aprobaciones obligatorias** (D-24), solo *squash*, historial lineal, sin *force push* ni borrado, sin bypass. Plantilla de PR con checklist de autorrevisión. Status checks: se activan cuando exista el CI (G-10).
- **Diagramas:** clases en **PlantUML** (lo exige la notación de plantilla de §4.1); capas, extensibilidad y apoyo en **Mermaid**.
- **IA:** Claude Code como herramienta principal; Cline permitido individualmente. Cada integrante commitea desde su cuenta. `AI_USAGE.md` desde el día 1.

**Seguridad (`SECURITY-BASELINE.md`):** controles por ID con prioridad y verificación, alineados con OWASP API Top 10 (2023), Top 10:2025, MASVS y Agentic Top 10 (2026), con 13 pruebas de seguridad ya nombradas. Claves: `userId` siempre del JWT, `role` nunca aceptado del cliente, rate limiting en `/auth`, ranking sin correos, plausibilidad de puntajes, errores sin stack, logging con redacción, secret scanning y Dependabot, permisos de agentes en `.claude/settings.json`, **sin credenciales de producción en las máquinas de desarrollo**.

**Reglas de juego (todas cerradas):**
- **Lines:** catálogo de 8 familias / 24 piezas con pesos (D-08); puntaje = celdas + ⌊5 × largo × L × racha⌋, racha (k+1)/2 con máximo ×3 (D-09).
- **Fit:** colocar/mover/retirar cuentan como movimiento, rotar/deshacer/rehacer no; **estrellas independientes**: ★ completar + ★ movimientos ≤ `m` + ★ tiempo ≤ `t` (D-10). Mejor intento: estrellas ↓ → tiempo ↑ → movimientos ↑ (profesor).
- **Sort:** pilas de altura 2–6 con hasta 3 bloques (D-11); puntaje 1 por ficha + 100 por meta, pero el ranking por nivel es **movimientos ↑ → puntaje ↓** (D-04, D-12); cascada determinista con cola; desempate a favor de la pila evaluada y luego **sentido horario desde las 12** (D-15); al llegar a 10 se elimina **solo el bloque de cima, completo** (D-16); "más fichas de ese color" = bloque de cima más grande (D-17).
- **Merge:** 90 % de 2 / 10 % de 4 (D-13); una fusión por ficha; deshacer restaura también el generador.
- **Común:** generador **xorshift32** propio (D-14); modo invitado + offline-first con **consolidación monótona** (unión / máximo / mejor intento completo); al iniciar sesión se pregunta si importar el progreso de invitado (D-05); al cerrar sesión se vuelve al perfil invitado (D-06).

**Topologías (D-18, D-25):**
- Solo **rejillas regulares**: hexágonos (Must), cuadrados y triángulos (Should, jugables), cubos 3D (Should en dominio, Could en vista 3D). Anexos verificados en `02-RN-TOPOLOGIAS.md`.
- **El jugador elige la figura en Ajustes** (solo las disponibles; hexágonos por defecto). Se fija al crear la partida y **no cambia durante ella**; la opción se bloquea mientras haya una partida en curso o en pausa (D-25).

**Motor (D-07, opción A):** la coordenada es un **parámetro genérico**: `Board<TCoord extends Coord, TCell>`, `GridTopology<TCoord>`, `IGameRules<TCoord, TCell, TMove, TState>`, `GameEngine<TCoord, TCell, TMove, TState>`. `HexBoard<TCell>` es un `typedef` de `Board<HexCoord, TCell>` que vive en `hexa_topologies` (no en el motor). La figura elegida se despacha en el composition root con una función genérica que conserva `TCoord`.

**Arquitectura y persistencia (17-11):** app en 4 paquetes Dart puros + Flutter (D-21); backend en módulos con carpetas Clean y un caso de uso por clase, con `infrastructure/` solo para adaptadores (D-22); el contrato vive en `hexablock-api/docs/contracts/` y la app guarda una copia verificada por CI (D-23); la partida en curso se guarda tras cada turno en `saved_games` y se puede continuar aunque la app se cierre (D-37).

## 4. Estado de la hoja de ruta

| Paso | Contenido | Estado |
|---|---|---|
| 0 | ADR-001 + SECURITY-BASELINE | ✅ |
| 1 | Requisitos: glosario, reglas de negocio, RF/RNF, historias, trazabilidad | 📝 Borrador listo; revisión de cada integrante |
| 2 | Arquitectura general (`ARQ-00`, `ARQ-01` app y API) | ✅ D-21 a D-23 cerradas (17-11) |
| 3 | Motor genérico (`ARQ-02-MOTOR.md`) | ✅ Decidido el 17-11 (D-29 a D-35); queda D-36 |
| 4 | Arquitectura detallada (`ARQ-03-APP-DETALLE.md`, `ARQ-03-API-DETALLE.md`, `docs/diagrams/`, `EXTENSIBILITY.md`) | ✅ 19-11 (D-38 a D-43); falta `clases.png` (R-04, DanielHaro28) |
| **5** | **Contratos:** `openapi.yaml`, JSON Schema de niveles y de progreso, modelo de datos local y del servidor | ✅ **Hecho (19-11):** contratos en `hexablock-api/docs/contracts/` y modelos de datos ARQ-04; D-19 y D-52 cerradas el mismo día |
| 6 | Contenido (15 + 10 niveles) y estrategia de pruebas | ✅ **Hecho (20-11):** 25 niveles candidatos, `levelgen.py`, `levelcheck.py`, estrategia de pruebas en los dos repos; quedan P-14, R-05 y D-61 |
| 7 | Plan: Issues, milestones, Definition of Done | ✅ **Hecho (20-11):** 86 Issues con milestones, responsables y estimación; `docs/plan/PLAN-ENTREGA.md`; tablero de GitHub Projects creado (T-02); falta G-01 (aceptar invitaciones) |
| 8 | Preparación para Claude Code: `CLAUDE.md`, agentes, permisos | ☐ |

**Revisión de integridad (12-11):** se revisaron todos los documentos de los dos repos contra el enunciado y entre sí. Los IDs citados existen todos, los compartidos son idénticos y los 59 chequeos de ejemplos pasan con el simulador. Se corrigieron desajustes de redacción: estrellas 1–3 en SEC-API-06, D-03 como pendiente en SECURITY §3, argon2id, tabla `profiles` y figura en preferencias en el ADR (rev. 1.7), D-07 ya no figura como abierta en ARQ-01-APP §0, script de CI por identificadores, TEC-08 alineada con RN-TOP-04, PRG-03 y RF-32 con figura, RF-90 a 93, E-COM-3 con un puntaje posible y decisiones abiertas en las trazabilidades. Hallazgo de fondo: **D-27 choca con la letra del enunciado §5.2** ("una entrada de progreso por usuario y por variante"); en `PENDIENTES.md` quedan las dos formas de guardarlo, con recomendación.

**Paso 4 (19-11):** todos los casos de uso implementan `UseCase<TIn, TOut>` con `execute` (D-38). Por dentro hay excepciones tipadas; hacia la pantalla, un `Result`, y en el backend, el filtro global de NestJS (D-39). La app tiene 4 aspectos (registro, métricas, errores con reintentos, sesión) en el orden sesión → errores → métricas → registro, armados con `AspectChain` (D-40, D-41). El backend usa decoradores propios (registro, métricas, caché del ranking) y deja la tubería HTTP a NestJS (D-42). El diagrama de clases es PlantUML y lo genera DanielHaro28; capas y extensibilidad son Mermaid (D-43). El guardado de la partida no espera la escritura (`scheduleSave` + `flush` al pausar).

**Paso 5 (19-11, hecho):** el Paso 4 se fusionó (app #6, api #4). Cerradas: D-27 (una entrada de progreso por usuario y `gameId`, con una sección por figura), D-44 (un JWT de 24 h), D-45 (dos formas de progreso: récord o niveles), D-46 (`/v1`, ISO 8601, RFC 9110, `camelCase`, `limit` + `offset`), D-47 (ids legibles, JSON, celdas como listas y sección `variant` distinta por `gameId`), D-48 (descarga de niveles con cursor del servidor, RN-COM-77), D-49 (filas por resultado y sincronización de solo lo que cambió, RN-COM-86), D-50 (nombre visible único, RN-COM-109) y D-51 (Problem Details, RFC 9457; ajusta la parte del backend de D-39). Entregado: `hexablock-api/docs/contracts/` (`openapi.yaml` 3.1, 5 esquemas, 13 ejemplos y `check_contracts.py`, copia idéntica en la app), `ARQ-04-API-DATOS.md` (Prisma, transacción de sincronización, ranking, cursor con `change_seq`) y `ARQ-04-APP-DATOS.md` (tablas Drift, `pending` + `revision`, migraciones). Después se cerraron D-19 (A: el backend revisa lo estructural y la app también lo geométrico) y D-52 (contraseñas de 15 a 128, NIST SP 800-63B rev. 4). Siguiente: Paso 6 cuando el usuario lo pida.

**Paso 6 (19 y 20-11, hecho):** herramientas en `tools/reference-sim/`: `levelkit.py` (resolvedor de Fit y jugador automático de Sort), `levelgen.py` (generador de niveles como herramienta de autor, D-53) y `levelcheck.py` (verificador de los niveles incluidos, probado con 5 roturas). Los 25 niveles candidatos están en `app/assets/levels/` (15 de Fit en hexágonos; Sort 1–6 con `any` y 7–10 en hexágonos con pilas iniciales, D-28) y su catálogo con dibujos en `docs/levels/CATALOGO.md`. Cerradas: D-28, D-36 (regla de PR + prueba de arquitectura), D-53 (opción D: generador ahora, modo en el juego como *Could*), D-54, D-55, D-56 (*fakes* y *stubs*; *mocks* solo para verificar llamadas), D-57 (PostgreSQL en `tmpfs`), D-58 (90/80/70 que bloquea), D-59 (C: la IA escribe código y pruebas; el equipo las ajusta) y D-60 (color entre los demás; ejemplo E-HS-GEN). Al comparar con los niveles reales se encontró que **E-COM-2 (nivel 1) y E-COM-3 (Fit) eran imposibles** con la regla de estrellas independientes (RN-HF-62), porque el verificador de ejemplos solo comprobaba el orden; se corrigieron junto con E-HF-1, E-HF-4 y los umbrales de E-HF-NIVEL (D-54), y el verificador ahora también revisa que las estrellas sean posibles. `docs/testing/ESTRATEGIA-PRUEBAS.md` en cada repo; RNF-23 alineado con D-58 en los dos. Pendientes: P-14 (preguntar al profesor si los niveles generados y curados cuentan como "diseñados manualmente"), R-05 (cada integrante juega y ajusta los 25 niveles) y D-61 (cómo conoce la API los niveles incluidos; recomendación A). Siguiente: Paso 7 (plan: Issues, milestones, Definition of Done) cuando el usuario lo pida.

**Paso 7 (20-11, en curso):** el usuario respondió P-14 (sí: los niveles del generador, revisados por el equipo, cuentan como diseñados a mano), dejó R-05 para cuando el juego esté en el APK y cerró D-61 (la API guarda una copia de `app/assets/levels/` en `prisma/seed/levels/`, con chequeo en CI). El equipo son **3 personas** y **una ya hizo un diseño inicial** (PDF de 59 pantallas). Se revisó contra las reglas en `docs/design/REVISION-DISENO.md`: cumple mucho (estructura común de partida, sin conexión, login genérico, símbolos en los colores) y tiene 16 diferencias con propuesta (DIS-01 a 16; las principales: contraseña de 15, Fit sin puntaje, estrellas independientes, ranking por figura y global, y faltan las pantallas de importar invitado, Continuar y sesión vencida). Propuestas abiertas: D-62 (reparto por área con revisor cruzado), D-63 (milestones M0 a M3 semanales hasta el 14-12), D-64 (Definition of Done), D-65 (Issues, etiquetas, tablero de Projects) y D-66 (aceptar los ajustes al diseño). D-26 (figura global) ahora urge por el diseño. Después (20-11, tarde): el diseño es una **propuesta visual** de **@dicpc** que se ajusta a lo definido; se guardó en `docs/design/HexaBlock-Suite-Diseno-v1.pdf`. Cerradas D-26 (una figura para todo el juego, en Ajustes), D-64 (Definition of Done, alineada con el Scrum Guide 2020: el enunciado no la define) y D-66 (las 16 propuestas aceptadas; RN-HL-71 precisada y NAV-05 sube a *Should*). G-01 hecha: los colaboradores ya están invitados (no se puede comprobar desde la sesión, el proxy bloquea esa API). D-62 lleva una estimación de 95 a 135 h por persona; D-63 cambió a una sola variante en M1 (Hexa Lines). El tercer integrante es **@DavidCR20** (dominio); @DanielHaro28 toma backend y DevOps, y cualquiera puede ayudar en otra área. Se cerraron D-62, D-63 y D-65 y se crearon **86 Issues** (69 en la app, 17 en la API) con etiquetas, milestones M0 a M3 (con fecha), responsables, estimación y la Definition of Done; las historias compartidas quedan enlazadas entre repos. M1 se aligeró a unas 120 h moviendo los aspectos (TEC-03) a M2. @dicpc y @DavidCR20 todavía no aceptaron la invitación, así que 55 Issues tienen la asignación pendiente (el responsable figura en el texto). También: plantillas de Issue, `CODEOWNERS` (G-04) y los niveles movidos a `app/assets/levels/` (estaban en la raíz por error). Siguiente: Paso 8 (Claude Code: `CLAUDE.md`, agentes) cuando el usuario lo pida. Los Issues, etiquetas y milestones se crean con `gh` (endpoints del repo); el tablero de Projects lo crea el dueño desde la web, porque esa API no pasa por el proxy.

**Orden de implementación sugerido:** motor con celda de prueba → Hexa Merge → Hexa Lines → Hexa Sort → Hexa Fit (todo con hexágonos); backend en paralelo; después, cuadrados y triángulos (TEC-07), cubos en el dominio (TEC-08) y vista 3D (TEC-09).

**Decisiones abiertas para la reunión del equipo** (todas con recomendación en `PENDIENTES.md` §1.1): D-02 (reparto), D-03 (409 al registrarse; recomendado mantenerlo), D-19 (validación de niveles), D-20 (catálogos de otras figuras), D-26 (figura global; recomendado sí), D-27 (progreso y ranking por figura; recomendado sí, con una entrada por usuario y variante y una sección por figura para cumplir §5.2), D-28 (niveles por figura), D-36 (protección del Template Method; recomendada una regla + prueba de arquitectura, sin dependencias, por §3.4).

**Paso 3 (`ARQ-02-MOTOR.md`, decidido el 17-11):** el equipo adoptó todas las recomendaciones: Visitor genérico para despachar la figura y `TCoord` hasta el widget del tablero (D-29); estado inmutable, celda vacía = `null`, movimientos *sealed* y `Tile implements Mergeable<Tile>` (D-30); Command + Memento para deshacer (D-31); eventos devueltos por las reglas, que la pantalla recibe como retorno de `submit`, y un `Stream` solo para historial, cronómetro, audio y analítica (D-32); capacidades ISP compuestas por la fábrica en una `GameSession` (D-33); fases con el patrón State (D-34); 14 patrones GoF en el dominio, 3 + 3 + 8 (D-35). Los esbozos de Dart **no están compilados** (sin SDK en la planificación): se validan en el *spike* de TEC-01. La lógica de deshacer y de fases se comprobó con `tools/reference-sim/engine_model.py`.

**Configuración de GitHub pendiente:** invitar colaboradores (G-01), secret scanning + push protection + Dependabot (G-03), `CODEOWNERS` (G-04), `SECURITY.md` (G-05), aprobación de workflows de forks (G-06), `GITHUB-SETUP.md` (G-08), completar `AI_USAGE.md` (A-03, creado en los PR #2), `APPROVED-TOOLS.md` (A-04).

**Sin PR hasta que el usuario lo pida (17-11):** los cambios se suben como commits a una rama `docs/...`; el PR se abre y se fusiona solo cuando el usuario lo indique.

**Decisiones en archivo propio (17-11):** las decisiones cerradas (D-* y P-*) salieron de `PENDIENTES.md` y están en `docs/DECISIONES.md` de cada repo. Las compartidas tienen el mismo texto en los dos (columna *Repos*: Ambos). `PENDIENTES.md` solo guarda las abiertas.

**Repos en GitHub (17-11):** los documentos de los Pasos 0 a 2 están en `main` de los dos repos (PR #1, *squash*). Claude tiene acceso de escritura y trabaja siempre con una rama `docs/...` y un PR que sigue la plantilla del repo, con título Conventional Commits con ámbito (p. ej. `docs(planning): …`), porque con *squash* el título del PR es el commit que queda en `main`.

## 5. Arquitectura en breve

- **Sistema (`ARQ-00`, compartido):** cliente–servidor **offline-first**. El dispositivo es la fuente primaria del progreso; la API consolida, calcula el ranking y publica niveles. **El servidor no ejecuta reglas de juego.** La consolidación existe en Dart y en TypeScript con ejemplos compartidos. Sincronización por snapshot de cada combinación `gameId` + figura.
- **App (`ARQ-01-APP`):** paquetes `hexa_engine` (motor y abstracciones; no ve variantes ni figuras), `hexa_topologies`, `hexa_variants` y `hexa_application` (casos de uso, puertos y aspectos como decoradores), todos Dart puros, más `app/` Flutter (`adapters/` = capa 3, `frameworks/` = capa 4, `config/` y `main.dart` como composition root). Los `pubspec` impiden que el motor o los casos de uso importen variantes o figuras, y el CI lo verifica. El tablero se dibuja como layout de la topología × pintor de contenido de la variante.
- **API (`ARQ-01-API`):** módulos `auth`, `users`, `progress`, `leaderboard`, `levels`, `health`, `common`, `prisma`; cada uno con `domain` / `application` / `presentation` / `infrastructure`; ESLint impide que `domain` importe NestJS o Prisma. Datos: `USER`, `PROGRESS` (JSON por `gameId` + topología), `BEST_ATTEMPT` (columnas para el ranking, con topología), `LEVEL`.

## 6. Mapa de documentos

| Documento | `hexablock-app` | `hexablock-api` |
|---|---|---|
| `docs/README.md` (índice) | ✅ | ✅ |
| `docs/adr/ADR-001-tech-stack.md` | compartido | compartido |
| `docs/security/SECURITY-BASELINE.md` | compartido | compartido |
| `docs/architecture/ARQ-00-SISTEMA.md` | compartido | compartido |
| `docs/architecture/ARQ-01-APP-GENERAL.md` / `ARQ-01-API-GENERAL.md` | app | API |
| `docs/architecture/ARQ-02-MOTOR.md` (motor genérico y patrones del dominio) | ✅ | — |
| `docs/architecture/ARQ-03-APP-DETALLE.md` / `ARQ-03-API-DETALLE.md` (Paso 4) | app | API |
| `docs/diagrams/` (`clases.puml`, `capas.mmd`, `extensibilidad.mmd` solo en la app, e imágenes) | ✅ | ✅ |
| `docs/EXTENSIBILITY.md` | ✅ | — |
| `docs/requirements/01-GLOSARIO.md` | compartido | compartido |
| `docs/requirements/02-RN-COMUNES.md`, `02-RN-TOPOLOGIAS.md`, `02-RN-HEXA-*.md` | ✅ | — |
| `docs/requirements/02-RN-NIVELES.md`, `02-RN-CUENTA-PROGRESO-RANKING.md` | compartido | compartido |
| `docs/requirements/03-REQUISITOS.md`, `04-HISTORIAS.md`, `05-TRAZABILIDAD.md` | versión app (50 historias) | versión API (9 historias) |
| `docs/DECISIONES.md` (decisiones cerradas) | ✅ (todas) | ✅ (las que afectan al backend) |
| `docs/PENDIENTES.md`, `docs/ai/CONTEXTO-CONVERSACION.md`, `docs/ai/PROMPT-NUEVA-CONVERSACION.md` | ✅ (solo aquí) | — |
| `.github/pull_request_template.md` | ✅ (app) | ✅ (API) |
| `tools/reference-sim/` (simulador de referencia de los ejemplos) | ✅ | — |

**Archivos originales del usuario** (no están en los repos): `Enunciado_ProyectoSemestral_HexaBlockSuite_v1.0_2026-10-23.html` (fuente de verdad) y `Historias_de_Usuario___HexaBlock_Suite.pdf` (v1 de las historias, ya reemplazada por `04-HISTORIAS.md`).

**Convenciones de IDs:** `RN-COM-*`, `RN-TOP-*`, `RN-HEX/TRI/SQR/CUB-*`, `RN-HL/HF/HS/HM-*` (reglas); `RF-*`, `RNF-*` (requisitos); `NAV/HL/HF/HS/HM/PRG/API/LVL/TEC-*` (historias; las que tocan ambos repos tienen el mismo ID en los dos); `E-*` (ejemplos que se convierten en pruebas); `SEC-*` (seguridad); `ARQ-S/A/B-*` (decisiones de arquitectura); `D-*`, `G-*`, `A-*`, `W-*`, `F-*`, `R-*` (pendientes). Los IDs nunca se reutilizan.
