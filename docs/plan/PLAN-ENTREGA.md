# Plan de entrega (Paso 7)

| Campo | Valor |
|---|---|
| Estado | Decidido por el equipo (D-62 a D-65, 20-11); los Issues ya están creados en los dos repos |
| Fecha | 2026-11-20 |
| Entrega | Lunes 14-12-2026 |
| Repositorio | `hexablock-app` (`docs/plan/PLAN-ENTREGA.md`); el repo de la API lo enlaza desde su README |

## 1. Equipo (D-62, D-77)

| Integrante | Área | Incluye |
|---|---|---|
| @DanielHaro28 | Motor y despliegue (D-77) | Motor genérico y topologías (TEC-01, TEC-02, TEC-06 a TEC-08, T-03), AWS, CI y release de los dos repos, configuración de GitHub y Claude Code, documentación de planificación. **Hexa Lines** (HL-01 a HL-06, D-78, asignada el 22-11) |
| @DavidCR20 | API (D-78, asignada el 20-11) | Backend NestJS: esqueleto (T-04), cuenta (API-01, API-02), sincronización (API-03), ranking (API-04), niveles (LVL-01, LVL-02) y errores y Swagger (TEC-05) |
| @dicpc | Interfaz (D-78, asignada el 20-11) | Pantallas y navegación (NAV-01 a NAV-08), victoria y derrota (PRG-01, PRG-02), registro e inicio de sesión en la app (API-01, API-02), ajustes al diseño (T-05) y vista 3D (TEC-09) |
| @dicpc y @DavidCR20 | Resto del frontend (D-77) | Hexa Fit, Hexa Sort y Hexa Merge, casos de uso y progreso de la app. **Cómo se lo reparten está por definir (D-78)** |

Cada área tiene un **responsable, no un dueño exclusivo**: cualquiera puede ayudar en otra sección. Cada PR lo revisa alguien de otra área (`CODEOWNERS` pide la revisión automáticamente). El 20-11 cambió el reparto de D-62 (D-77): los Issues que dicen "por definir" se asignan cuando el equipo cierre D-78.

## 2. Milestones (D-63)

| Milestone | Fechas | Issues | Horas | Meta |
|---|---|---|---|---|
| M0 · Preparación | 20 al 23-11 | 16 | 33 | Repos listos, CI, AWS, Claude Code configurado |
| M1 · Base jugable | 24 al 30-11 | 25 | 120.5 | Motor + hexágonos + **Hexa Lines** jugable de punta a punta; API con login y desplegada |
| M2 · Las otras tres variantes | 1 al 7-12 | 23 | 128 | Merge, Fit y Sort jugables con sus 25 niveles; progreso local; API completa |
| M3 · Conectado y entregable | 8 al 12-12 | 20 | 80 | Conectado (sincronización, ranking, invitado), extensibilidad, documentación y APK firmado |
| Sin milestone (solo si sobra tiempo) | — | 3 | 42 | Cuadrados, triángulos, cubos y vista 3D |

El 13 y el 14-12 quedan de margen y para ensayar la defensa.

**Horas por responsable** (D-77; las tareas de los tres se reparten por tercios):

| Responsable | Con milestone | Sin milestone (opcional) |
|---|---|---|
| @DanielHaro28 | 114.7 h (27 h de Hexa Lines, D-78) | 26 h |
| Por definir (@dicpc y @DavidCR20, D-78) | 238.5 h + 8.3 h de tareas de los tres (≈ 123 h cada uno) | 16 h |

Es una estimación con Claude Code escribiendo la mayor parte del código (D-62). Se anota el tiempo real en el campo **Estimación (h)** del tablero y se recalcula al cerrar M1.

## 3. Definition of Done (D-64)

Está en `docs/DECISIONES.md` (D-64) y como casillas en cada Issue de historia y en la plantilla `.github/ISSUE_TEMPLATE/story.yml`.

## 4. Tablero (D-65)

El tablero de GitHub Projects se crea desde la web con la sesión del dueño (T-02), porque la API de Projects no está disponible en la sesión de planificación. Estado al 20-11:

- **Proyecto:** [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) (Project de usuario n.º 1, privado), vinculado a `hexablock-app` y `hexablock-api`. @dicpc y @DavidCR20 tienen permiso de escritura.
- **Columnas (campo Status):** Backlog → Por Hacer → En Curso → En revision → Hecho. Backlog es el valor por defecto.
- **Contenido:** los 87 Issues (86 del 20-11 y G-01, que se agregó al pasar las tareas a Issues, D-69). Los de M0 y M1 (41) están en Por Hacer; los de M2, M3 y los que no tienen milestone (46) están en Backlog.
- **Campo numérico Estimación (h):** tiene las horas de la sección 5 en todos los Issues, 403.5 h en total.
- **Vistas:**
  - **Tablero:** las columnas.
  - **Tabla:** agrupada por milestone, con la suma de Estimación (h) por grupo.
  - No hay vista Roadmap, porque los Issues no tienen campos de fecha. Las fechas están en los milestones.
- **Workflows:**
  - Item added to project → Backlog.
  - Pull request linked to issue → En Curso.
  - Item closed o Pull request merged → Hecho.
  - Status Hecho → cierra el Issue.
  - Auto-add: un workflow por repo (Auto-add to project para `hexablock-app` y Auto-add from hexablock-api), con el filtro `is:issue is:open`. La cuenta tiene GitHub Pro, que permite hasta 5.
  - Además, las plantillas de Issue de los dos repos traen `projects: ["DanielHaro28/1"]`.

## 5. Issues

Las historias vienen de `docs/requirements/04-HISTORIAS.md` (en los dos repos para las compartidas, enlazadas entre sí). Las tareas `G-*`, `W-*`, `A-*` y `R-*` vinieron de `docs/PENDIENTES.md` y ahora solo viven como Issues (D-69); las `T-*` se definen aquí:

| ID | Tarea |
|---|---|
| T-04 | Esqueleto NestJS + Prisma + Docker |
| T-01 | Paso 8: CLAUDE.md, agentes y reglas de Claude Code en los dos repos |
| T-02 | Crear el tablero de GitHub Projects |
| T-03 | Esqueleto del workspace Flutter (pub workspace, 4 paquetes y la app) |
| T-05 | Aplicar los ajustes al diseño DIS-01 a DIS-16 |
| T-06 | Release: APK firmado en GitHub Releases |
| T-07 | Entrega: README final y ensayo de la defensa |

### M0 · Preparación

| Issue | Título | Responsable | Horas |
|---|---|---|---|
| [api #14](https://github.com/DanielHaro28/hexablock-api/issues/14) | TEC-04 · Integración continua del backend | @DanielHaro28 | 6 |
| [api #17](https://github.com/DanielHaro28/hexablock-api/issues/17) | T-04 · Esqueleto NestJS + Prisma + Docker | @DavidCR20 | 3 |
| [api #19](https://github.com/DanielHaro28/hexablock-api/issues/19) | W-01 · Budget de AWS con alertas al 50 % y 80 % | @DanielHaro28 | 0.5 |
| [app #12](https://github.com/DanielHaro28/hexablock-app/issues/12) | TEC-04 · Integración continua y release de la app | @DanielHaro28 | 8 |
| [app #13](https://github.com/DanielHaro28/hexablock-app/issues/13) | T-01 · Paso 8: CLAUDE.md, agentes y reglas de Claude Code en los dos repos | @DanielHaro28 | 4 |
| [app #14](https://github.com/DanielHaro28/hexablock-app/issues/14) | T-02 · Crear el tablero de GitHub Projects | @DanielHaro28 | 0.5 |
| [app #16](https://github.com/DanielHaro28/hexablock-app/issues/16) | G-03 · Secret scanning, push protection y Dependabot en los dos repos | @DanielHaro28 | 1 |
| [app #17](https://github.com/DanielHaro28/hexablock-app/issues/17) | G-05 · SECURITY.md en la raíz de los dos repos | @DanielHaro28 | 1 |
| [app #18](https://github.com/DanielHaro28/hexablock-app/issues/18) | G-06 · Exigir aprobación para workflows de forks | @DanielHaro28 | 0.5 |
| [app #19](https://github.com/DanielHaro28/hexablock-app/issues/19) | G-07 · commitlint + lefthook en los dos repos | @DanielHaro28 | 2 |
| [app #21](https://github.com/DanielHaro28/hexablock-app/issues/21) | A-04 · docs/ai/APPROVED-TOOLS.md | @DanielHaro28 | 1 |
| [app #22](https://github.com/DanielHaro28/hexablock-app/issues/22) | R-01 · Versiones exactas de Flutter, Dart, Node, NestJS, Prisma y PostgreSQL en los README | @DanielHaro28 | 1 |
| [app #71](https://github.com/DanielHaro28/hexablock-app/issues/71) | T-03 · Esqueleto del workspace Flutter (pub workspace, 4 paquetes y la app) | @DanielHaro28 | 3 |
| [app #74](https://github.com/DanielHaro28/hexablock-app/issues/74) | A-02 · Ninguna máquina de desarrollo con la clave SSH de EC2 ni credenciales de AWS de escritura | @DanielHaro28, @DavidCR20, @dicpc | 0.5 |
| [app #77](https://github.com/DanielHaro28/hexablock-app/issues/77) | R-03 · Reemplazar el .gitignore de la app por la plantilla de app de Flutter (sin *.lock) | por definir | 0.5 |
| [app #83](https://github.com/DanielHaro28/hexablock-app/issues/83) | G-01 · Aceptar las invitaciones a los repos y asignar los Issues pendientes | @DanielHaro28 | 0.5 |

### M1 · Base jugable

| Issue | Título | Responsable | Horas |
|---|---|---|---|
| [api #8](https://github.com/DanielHaro28/hexablock-api/issues/8) | API-01 · Registrarme | @DavidCR20 | 6 |
| [api #9](https://github.com/DanielHaro28/hexablock-api/issues/9) | API-02 · Iniciar sesión | @DavidCR20 | 5 |
| [api #15](https://github.com/DanielHaro28/hexablock-api/issues/15) | TEC-05 · API documentada y con errores consistentes | @DavidCR20 | 5 |
| [api #16](https://github.com/DanielHaro28/hexablock-api/issues/16) | TEC-10 · Despliegue continuo en AWS | @DanielHaro28 | 12 |
| [api #20](https://github.com/DanielHaro28/hexablock-api/issues/20) | W-02 · Subdominio en DuckDNS | @DanielHaro28 | 0.5 |
| [api #21](https://github.com/DanielHaro28/hexablock-api/issues/21) | W-03 · Lanzar EC2 t3.small en us-east-2 | @DanielHaro28 | 1 |
| [api #22](https://github.com/DanielHaro28/hexablock-api/issues/22) | W-04 · Endurecer la instancia EC2 | @DanielHaro28 | 2 |
| [api #23](https://github.com/DanielHaro28/hexablock-api/issues/23) | W-05 · docs/ops/DEPLOY.md con el checklist de despliegue | @DanielHaro28 | 1 |
| [api #24](https://github.com/DanielHaro28/hexablock-api/issues/24) | W-06 · Environment production con los secretos EC2_HOST y EC2_SSH_KEY | @DanielHaro28 | 0.5 |
| [app #20](https://github.com/DanielHaro28/hexablock-app/issues/20) | G-10 · Exigir que el CI pase en el ruleset de los dos repos | @DanielHaro28 | 0.5 |
| [app #24](https://github.com/DanielHaro28/hexablock-app/issues/24) | NAV-01 · Seleccionar un juego desde el inicio | @dicpc | 6 |
| [app #25](https://github.com/DanielHaro28/hexablock-app/issues/25) | NAV-02 · Controlar el audio | @dicpc | 4 |
| [app #26](https://github.com/DanielHaro28/hexablock-app/issues/26) | NAV-03 · Cambiar el idioma | @dicpc | 4 |
| [app #27](https://github.com/DanielHaro28/hexablock-app/issues/27) | NAV-04 · Pausar una partida | @dicpc | 4 |
| [app #32](https://github.com/DanielHaro28/hexablock-app/issues/32) | HL-01 · Empezar una partida sin fin | @DanielHaro28 | 4 |
| [app #33](https://github.com/DanielHaro28/hexablock-app/issues/33) | HL-02 · Colocar una pieza | @DanielHaro28 | 8 |
| [app #34](https://github.com/DanielHaro28/hexablock-app/issues/34) | HL-03 · Eliminar líneas completas | @DanielHaro28 | 6 |
| [app #35](https://github.com/DanielHaro28/hexablock-app/issues/35) | HL-04 · Recibir una nueva bandeja | @DanielHaro28 | 3 |
| [app #36](https://github.com/DanielHaro28/hexablock-app/issues/36) | HL-05 · Terminar cuando nada cabe | @DanielHaro28 | 3 |
| [app #37](https://github.com/DanielHaro28/hexablock-app/issues/37) | HL-06 · Ver mi puntaje y mi récord | @DanielHaro28 | 3 |
| [app #55](https://github.com/DanielHaro28/hexablock-app/issues/55) | PRG-02 · Ver la pantalla de derrota | @dicpc | 4 |
| [app #56](https://github.com/DanielHaro28/hexablock-app/issues/56) | PRG-03 · Guardar el progreso en el dispositivo | por definir | 8 |
| [app #64](https://github.com/DanielHaro28/hexablock-app/issues/64) | TEC-01 · Motor genérico compartido | @DanielHaro28 | 16 |
| [app #67](https://github.com/DanielHaro28/hexablock-app/issues/67) | TEC-06 · Topología intercambiable | @DanielHaro28 | 8 |
| [app #72](https://github.com/DanielHaro28/hexablock-app/issues/72) | T-05 · Aplicar los ajustes al diseño DIS-01 a DIS-16 | @dicpc | 6 |

### M2 · Las otras tres variantes

| Issue | Título | Responsable | Horas |
|---|---|---|---|
| [api #10](https://github.com/DanielHaro28/hexablock-api/issues/10) | API-03 · Sincronizar mi progreso por juego | @DavidCR20 | 10 |
| [api #11](https://github.com/DanielHaro28/hexablock-api/issues/11) | API-04 · Consultar el ranking | @DavidCR20 | 8 |
| [api #12](https://github.com/DanielHaro28/hexablock-api/issues/12) | LVL-01 · Entregar niveles publicados | @DavidCR20 | 6 |
| [api #13](https://github.com/DanielHaro28/hexablock-api/issues/13) | LVL-02 · Publicar o actualizar un nivel | @DavidCR20 | 6 |
| [app #38](https://github.com/DanielHaro28/hexablock-app/issues/38) | HF-01 · Elegir un nivel | por definir | 6 |
| [app #39](https://github.com/DanielHaro28/hexablock-app/issues/39) | HF-02 · Colocar una pieza dentro de la figura | por definir | 8 |
| [app #40](https://github.com/DanielHaro28/hexablock-app/issues/40) | HF-03 · Rotar una pieza | por definir | 4 |
| [app #41](https://github.com/DanielHaro28/hexablock-app/issues/41) | HF-04 · Retirar o mover una pieza | por definir | 4 |
| [app #42](https://github.com/DanielHaro28/hexablock-app/issues/42) | HF-05 · Deshacer y rehacer sin límite | por definir | 4 |
| [app #43](https://github.com/DanielHaro28/hexablock-app/issues/43) | HF-06 · Completar el nivel y ganar estrellas | por definir | 5 |
| [app #44](https://github.com/DanielHaro28/hexablock-app/issues/44) | HS-01 · Elegir un nivel | por definir | 4 |
| [app #45](https://github.com/DanielHaro28/hexablock-app/issues/45) | HS-02 · Colocar una pila | por definir | 5 |
| [app #46](https://github.com/DanielHaro28/hexablock-app/issues/46) | HS-03 · Transferir fichas en cascada | por definir | 10 |
| [app #47](https://github.com/DanielHaro28/hexablock-app/issues/47) | HS-04 · Completar un bloque de 10 | por definir | 4 |
| [app #48](https://github.com/DanielHaro28/hexablock-app/issues/48) | HS-05 · Ganar o perder el nivel | por definir | 4 |
| [app #49](https://github.com/DanielHaro28/hexablock-app/issues/49) | HM-01 · Deslizar en seis direcciones | por definir | 6 |
| [app #50](https://github.com/DanielHaro28/hexablock-app/issues/50) | HM-02 · Fusionar fichas iguales | por definir | 5 |
| [app #51](https://github.com/DanielHaro28/hexablock-app/issues/51) | HM-03 · Aparición reproducible de fichas nuevas | por definir | 3 |
| [app #52](https://github.com/DanielHaro28/hexablock-app/issues/52) | HM-04 · Deshacer un movimiento | por definir | 3 |
| [app #53](https://github.com/DanielHaro28/hexablock-app/issues/53) | HM-05 · Ganar, perder y guardar el récord | por definir | 4 |
| [app #54](https://github.com/DanielHaro28/hexablock-app/issues/54) | PRG-01 · Ver la pantalla de victoria | @dicpc | 6 |
| [app #57](https://github.com/DanielHaro28/hexablock-app/issues/57) | PRG-04 · Desbloquear niveles en orden | por definir | 3 |
| [app #66](https://github.com/DanielHaro28/hexablock-app/issues/66) | TEC-03 · Aspecto transversal sobre los casos de uso | por definir | 10 |

### M3 · Conectado y entregable

| Issue | Título | Responsable | Horas |
|---|---|---|---|
| [api #18](https://github.com/DanielHaro28/hexablock-api/issues/18) | G-08 · docs/ops/GITHUB-SETUP.md con la configuración aplicada | @DanielHaro28 | 2 |
| [app #10](https://github.com/DanielHaro28/hexablock-app/issues/10) | API-03 · Sincronizar mi progreso por juego | por definir | 8 |
| [app #11](https://github.com/DanielHaro28/hexablock-app/issues/11) | API-07 · Cerrar sesión | por definir | 2 |
| [app #15](https://github.com/DanielHaro28/hexablock-app/issues/15) | T-06 · Release: APK firmado en GitHub Releases | @DanielHaro28 | 3 |
| [app #23](https://github.com/DanielHaro28/hexablock-app/issues/23) | R-04 · Generar las imágenes de los diagramas de clases en los dos repos | @DanielHaro28 | 2 |
| [app #28](https://github.com/DanielHaro28/hexablock-app/issues/28) | NAV-05 · Consultar cómo se juega | @dicpc | 4 |
| [app #29](https://github.com/DanielHaro28/hexablock-app/issues/29) | NAV-06 · Acceder a mi cuenta desde la app | @dicpc | 4 |
| [app #30](https://github.com/DanielHaro28/hexablock-app/issues/30) | NAV-07 · Ver el ranking en la app | @dicpc | 6 |
| [app #31](https://github.com/DanielHaro28/hexablock-app/issues/31) | NAV-08 · Elegir la figura de las celdas | @dicpc | 3 |
| [app #58](https://github.com/DanielHaro28/hexablock-app/issues/58) | API-01 · Registrarme | @dicpc | 5 |
| [app #59](https://github.com/DanielHaro28/hexablock-app/issues/59) | API-02 · Iniciar sesión | @dicpc | 4 |
| [app #60](https://github.com/DanielHaro28/hexablock-app/issues/60) | API-05 · Jugar como invitado | por definir | 4 |
| [app #61](https://github.com/DanielHaro28/hexablock-app/issues/61) | API-06 · Importar mi progreso de invitado | por definir | 4 |
| [app #62](https://github.com/DanielHaro28/hexablock-app/issues/62) | API-08 · Seguir jugando sin conexión | por definir | 5 |
| [app #63](https://github.com/DanielHaro28/hexablock-app/issues/63) | LVL-01 · Recibir niveles nuevos sin actualizar la app | por definir | 5 |
| [app #65](https://github.com/DanielHaro28/hexablock-app/issues/65) | TEC-02 · Agregar una quinta variante sin tocar el motor | @DanielHaro28 | 6 |
| [app #73](https://github.com/DanielHaro28/hexablock-app/issues/73) | T-07 · Entrega: README final y ensayo de la defensa | @DanielHaro28, @DavidCR20, @dicpc | 6 |
| [app #75](https://github.com/DanielHaro28/hexablock-app/issues/75) | A-03 · Completar los campos ⚠️ de AI_USAGE.md | @DanielHaro28, @DavidCR20, @dicpc | 3 |
| [app #76](https://github.com/DanielHaro28/hexablock-app/issues/76) | R-02 · Citar las fuentes de los algoritmos (xorshift32, coordenadas hexagonales) | por definir | 1 |
| [app #78](https://github.com/DanielHaro28/hexablock-app/issues/78) | R-05 · Jugar y aprobar los 25 niveles en el APK | @DanielHaro28, @DavidCR20, @dicpc | 3 |

### Sin milestone (solo si sobra tiempo)

| Issue | Título | Responsable | Horas |
|---|---|---|---|
| [app #68](https://github.com/DanielHaro28/hexablock-app/issues/68) | TEC-07 · Cuadrados y triángulos jugables | @DanielHaro28 | 16 |
| [app #69](https://github.com/DanielHaro28/hexablock-app/issues/69) | TEC-08 · Cubos en el dominio | @DanielHaro28 | 10 |
| [app #70](https://github.com/DanielHaro28/hexablock-app/issues/70) | TEC-09 · Vista 3D | @dicpc | 16 |
| [app #116](https://github.com/DanielHaro28/hexablock-app/issues/116) | T-08 · Skills opcionales si sobra tiempo | @DanielHaro28 | 0 |

**Asignación:** solo @DanielHaro28 tiene Issues asignados en GitHub. Los que dicen "por definir" se asignan cuando el equipo cierre D-78, y los de los tres, cuando todos acepten la invitación (G-01). `tools/planning/assign_pending.py` asigna lo que diga `tools/planning/issues_created.json`.

## 6. Hoja de ruta de la planificación

Los pasos de diseño antes de escribir código (antes en `PENDIENTES.md` §3, D-69).

| Paso | Qué | Repo | Estado |
|---|---|---|---|
| 0 | `ADR-001-tech-stack.md` y `SECURITY-BASELINE.md` | Ambos (compartidos) | ✅ ADR rev. 1.9; SECURITY revisado el 20-11 |
| 1 | Requisitos: glosario, reglas de negocio, RF y RNF, historias, trazabilidad (`docs/requirements/`) | Ambos | ✅ Hecho; cada integrante los revisa al tomar sus Issues |
| 2 | Arquitectura general: ARQ-00 (compartido), ARQ-01-APP, ARQ-01-API | Ambos | ✅ D-21 a D-23 (17-11); ARQ-S-02 y ARQ-S-03 confirmadas (20-11) |
| 3 | Motor genérico: `ARQ-02-MOTOR.md` | App | ✅ D-29 a D-36 |
| 4 | Arquitectura detallada: ARQ-03, diagramas, `EXTENSIBILITY.md` | Ambos | ✅ D-38 a D-43 (19-11); faltan las imágenes de los diagramas de clases (R-04, D-76) |
| 5 | Contratos y modelos de datos: `docs/contracts/`, ARQ-04 | Ambos | ✅ D-44 a D-52 (19-11) |
| 6 | Contenido y pruebas: 25 niveles, generador, estrategia de pruebas | App (+ API) | ✅ D-53 a D-61 (20-11); revisión de los niveles en el APK (R-05) |
| 7 | Plan: Issues, milestones, Definition of Done, tablero | Ambos | ✅ D-62 a D-66 (20-11); tablero creado (T-02) |
| 7b | Revisión de organización y seguridad de los documentos | Ambos | ✅ D-67 a D-75 (20-11) |
| 8 | Claude Code: `CLAUDE.md`, `.claude/` (reglas, permisos, hooks, subagentes, skills) y `.mcp.json` | Ambos | ✅ D-79 a D-88 (20-11) |

**Topologías adicionales** (TEC-07 a TEC-09): después de tener las 4 variantes jugables con hexágonos.
