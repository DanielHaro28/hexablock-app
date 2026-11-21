# ADR-001 — Stack tecnológico de HexaBlock Suite

| Campo | Valor |
|---|---|
| Estado | **Aceptado** |
| Fecha | 2026-11-11 |
| Revisión | 2.1 (20-11): Prisma ORM 7 (D-89); versiones exactas en el README de cada repo (R-01) · 2.0 (20-11): solo Claude Code como herramienta de agente (D-87) y su configuración en los repos (D-79 a D-86) · 1.9 (17-11): tabla `saved_games` (D-37) y contrato en `hexablock-api` con copia verificada (D-23) · 1.8 (17-11): las decisiones cerradas pasan a `docs/DECISIONES.md` de cada repo · 1.7 (12-11): coherencia con los demás documentos, sin cambios de stack (argon2id como en SECURITY, tabla `profiles`, figura de celdas en preferencias, nota sobre los paquetes de D-21, `CODEOWNERS` y ruleset de `main`) · 1.6: revisión de PR por un compañero recomendada, no obligatoria · 1.5: topologías (hexágonos, cuadrados, triángulos y cubos) y documentos separados por repo · 1.4: diagrama de clases en PlantUML por §4.1 ("notación UML de plantilla"); repos públicos confirmados · 1.3: repos en la cuenta personal Pro de un integrante (antes: organización) · 1.2: diagramas en Mermaid (antes PlantUML) y detalle del almacenamiento local · 1.1: controles de seguridad y referencia a `SECURITY-BASELINE.md` |
| Autores | Equipo HexaBlock Suite |
| Aplica a | `hexablock-app` (cliente) y `hexablock-api` (backend) |
| Repositorio | **Compartido:** `docs/adr/` en ambos repos; las dos copias deben ser idénticas |
| Revisar si | cambia el enunciado o se agotan los créditos de AWS |

---

## 1. Contexto

El proyecto (Enunciado v1.0, 23-10-2026, entrega 14-12-2026) exige:

- Un lenguaje con **programación genérica y restricciones de tipo** (§3.1).
- Una **app móvil** Android o iOS, entregada como ejecutable en un **GitHub Release** (§8).
- Un **backend REST** con JWT, Swagger/OpenAPI y errores HTTP consistentes (§5.2). La cátedra fija **TypeScript + NestJS**.
- Dos repos en GitHub con **ramas protegidas**, PRs, **Conventional Commits en inglés** y **CI que ejecute las pruebas en cada PR** (§2, §3.6, §6.2).
- Pruebas unitarias, de integración (con BD en memoria), de widget/UI, y de contrato como recomendación (§3.6).
- AOP implementado con decoradores o proxies propios, sin depender de librerías AOP (§3.5).
- Diagramas con un **archivo fuente editable** en `/docs` (§4).
- El **backend siempre desplegado**: la defensa no se hace en local (requisito de la cátedra).

Restricciones del equipo:

- **Tiempo**: unos 33 días desde esta decisión hasta la entrega.
- **Equipo**: 3 integrantes.
- **Presupuesto**: USD 0. Contamos con una cuenta AWS en plan Free (USD 100 en créditos, vigente hasta el 11-05-2027) y GitHub Pro (Student Developer Pack) para todos los integrantes.
- **Lo que se evalúa es un único motor genérico**, no cuatro juegos. El stack debe facilitar que el dominio quede aislado del framework.

---

## 2. Decisión

### 2.1 Cliente — `hexablock-app`

| Aspecto | Elección | Justificación |
|---|---|---|
| Lenguaje / framework | **Dart 3 + Flutter** (última versión estable al iniciar; la versión exacta se fija en `pubspec.yaml` y en el README) | Genéricos con restricciones (`T extends Mergeable<T>`), *sealed classes* y *pattern matching* para modelar movimientos y eventos. Pruebas de widget nativas |
| Organización | **Pub workspace** con paquetes Dart puros para el dominio y los casos de uso (como mínimo `packages/hexa_engine`) y la app Flutter. La propuesta de 4 paquetes (`hexa_engine`, `hexa_topologies`, `hexa_variants`, `hexa_application`) está en `ARQ-01-APP-GENERAL.md` §3 (D-21) | El dominio **no puede importar Flutter**, porque su `pubspec` no lo declara. La regla de dependencia de Clean se cumple por construcción. Se prueba con `dart test`, sin emulador |
| Render del tablero | `CustomPainter` | Son juegos por turnos y no necesitan *game loop*. **Se descarta Flame**, porque su propio ciclo de juego competiría con `GameEngine`. Hay **una estrategia de dibujo por topología** (hexágonos, cuadrados, triángulos); la vista 3D de los cubos es *Could* y se evaluará aparte (`02-RN-TOPOLOGIAS.md` §2) |
| Presentación (capa 3) | `flutter_bloc` (Cubit como ViewModel) + `bloc_test` | Estado explícito y fácil de probar |
| Inyección de dependencias | `get_it` con un único *composition root* | Ahí se registra la Abstract Factory de cada variante |
| Persistencia local | **Drift** (SQLite, vía `drift_flutter`) | Tipado, con migraciones versionadas, mantenido, y con BD en memoria (`NativeDatabase.memory()`) para las pruebas de integración. Vive en la capa 4, detrás de `IProgressRepository` e `ILevelRepository`. **Se descartan Hive e Isar** por falta de mantenimiento de su autor original |
| Preferencias | `shared_preferences` | Idioma, audio y figura de las celdas (D-25). **Nunca** para tokens ni datos sensibles |
| Almacenamiento seguro | `flutter_secure_storage` | Guarda el JWT en Keystore/Keychain (SEC-MOB-01) |
| HTTP | `dio`, envuelto en un Adapter | Sus interceptores sirven para el aspecto de reintentos y el token JWT |
| i18n | `flutter_localizations` + ARB (`gen-l10n`) | Solución oficial para es/en |
| Audio | `just_audio` (o `audioplayers`), detrás de `AudioFacade` | Encaja con el patrón Facade del enunciado |
| Pruebas | `test`, `flutter_test`, `mocktail`, `integration_test` | Unitarias, de widget y de navegación |
| Calidad | `very_good_analysis` (o `flutter_lints` en modo estricto) + `dart format` | Se ejecuta en CI |
| Configuración por entorno | `--dart-define=API_BASE_URL=...` | El APK del Release apunta a producción sin cambiar código |

**Qué se guarda en cada almacenamiento del dispositivo:**

| Dato | Almacenamiento |
|---|---|
| Perfiles locales (invitado y cuentas que iniciaron sesión en el dispositivo, D-05, D-06) | Drift: tabla `profiles` |
| Progreso por perfil, `gameId` y figura (D-27): una fila por resultado de nivel y una por récord, cada una con su marca de pendiente de enviar (D-49) | Drift: tablas `level_results` y `records` |
| Niveles descargados del servidor (id, `gameId`, figura, orden, versión, JSON) y el cursor de la última descarga por variante y figura (D-48) | Drift: tablas `downloaded_levels` y `level_sync_cursors` |
| Cambios de progreso pendientes de sincronizar | La marca de pendiente de `level_results` y `records` (D-49); no hay tabla aparte |
| Partida en curso, para continuarla si la app se cierra (D-37) | Drift: tabla `saved_games` |
| Niveles incluidos en la app | Assets JSON (`assets/levels/<gameId>/*.json`), cargados con el Builder |
| Idioma, audio y figura de las celdas | `shared_preferences` |
| JWT | `flutter_secure_storage` |

### 2.2 Backend — `hexablock-api`

| Aspecto | Elección | Justificación |
|---|---|---|
| Lenguaje / framework | **TypeScript + NestJS** (impuesto por la cátedra) sobre **Node.js LTS activa** | — |
| Base de datos | **PostgreSQL** | Relacional, con soporte JSONB para la sección específica de cada `gameId` en los niveles |
| ORM / migraciones | **Prisma ORM 7** (D-89) | Esquema declarativo y migraciones versionadas (`migrate deploy` al arrancar) |
| Autenticación | `@nestjs/jwt` + Passport; contraseñas con **argon2id** | §5.2 punto 1; SEC-API-02 |
| Validación | `class-validator` + `ValidationPipe({ whitelist: true, forbidNonWhitelisted: true })` | Errores 400 con detalle por campo; bloquea la asignación masiva (SEC-API-03) |
| Endurecimiento HTTP | `helmet` + `@nestjs/throttler` (rate limiting global y estricto en `/v1/auth/*`) | SEC-API-04, SEC-API-08 |
| Autorización | `RolesGuard` con denegación por defecto; `userId` siempre tomado del JWT | SEC-API-01, SEC-API-05 |
| Documentación | `@nestjs/swagger`, con **`openapi.yaml` como contrato fuente** (*contract-first*) | Swagger público en `/docs` para que el jurado pueda probar la API |
| Errores | Un *exception filter* global que responde siempre con **Problem Details (RFC 9457)**: `application/problem+json` con `type`, `title`, `status`, `detail` e `instance`, más los campos propios `code` y `errors` (D-51) | §5.2 punto 6 |
| Pruebas | Jest (unitarias) + Supertest (endpoints) contra Postgres en un *service container* de CI | §3.6 |
| Contrato | Respuestas validadas contra `openapi.yaml` (por ejemplo `jest-openapi`); el cliente prueba sus mappers con los ejemplos del mismo archivo | Cubre la recomendación de pruebas de contrato con menos riesgo que Pact. `pact_dart` no recibe cambios desde 2023. Pact queda como mejora opcional |
| Contenedores | **Docker**: `Dockerfile` multi-stage (imagen `node:*-alpine`) + `docker-compose.yml` (api + postgres) para desarrollo | El mismo artefacto corre en local, en CI y en producción |

### 2.3 Infraestructura y despliegue

| Aspecto | Elección |
|---|---|
| Proveedor | **AWS**, cuenta en plan Free (USD 100 en créditos, vence el 11-05-2027) |
| Cómputo | **1 instancia EC2 `t3.small`** (2 vCPU, 2 GB RAM, x86_64), con 20 GB gp3, en **`us-east-1`** |
| Orquestación | **Docker Compose** en la instancia: `api` + `postgres` (con volumen persistente) + `caddy` |
| HTTPS | **Caddy** como *reverse proxy*, con certificado Let's Encrypt automático sobre un subdominio gratuito (DuckDNS). Es obligatorio: Android bloquea por defecto el tráfico HTTP sin cifrar |
| Registro de imágenes | **GitHub Container Registry (GHCR)** |
| Despliegue | Al hacer merge a `main` en `hexablock-api`, GitHub Actions construye la imagen, la sube a GHCR y luego por SSH ejecuta `docker compose pull && docker compose up -d` |
| Secretos | `JWT_SECRET`, `DATABASE_URL` y la contraseña de Postgres viven en un `.env` en la instancia (fuera del repo). La clave SSH y el host van en GitHub Secrets |
| Security Group | Puertos 80 y 443 abiertos; 22 solo con autenticación por clave. Postgres (5432) **no se expone** |
| Observabilidad mínima | Endpoint `GET /health`, *healthcheck* en Compose y `restart: unless-stopped` |
| Respaldo | `pg_dump` diario por *cron* a un volumen local (opcional: subirlo a S3) |
| Control de costos | **AWS Budgets** con alertas al 50 % y al 80 % de los créditos. En el plan Free la cuenta **se cierra al agotar los créditos**, así que no se crean RDS, balanceadores ni NAT Gateways |

Costo estimado (on-demand, `us-east-1`): unos USD 15/mes por la instancia, unos USD 1,6/mes por el disco y unos USD 3,6/mes por la IPv4 pública. **Total aproximado: USD 20/mes**, por lo que los créditos alcanzan para unos 5 meses. Las cifras deben verificarse en la AWS Pricing Calculator al crear la instancia.

### 2.4 Repositorios, CI/CD y flujo de trabajo

| Aspecto | Elección |
|---|---|
| Hosting | **Cuenta personal de un integrante con GitHub Pro** (Student Pack): **DanielHaro28** (D-01), dueña de `hexablock-app` y `hexablock-api`. Los otros 2 integrantes entran como **colaboradores** (permiso de escritura): pueden hacer push a ramas, abrir PRs y aprobar, pero no cambiar la configuración |
| Visibilidad | **Públicos** (confirmado por el profesor el 11-11-2026) |
| Minutos de Actions | Ilimitados en los runners estándar (repos públicos). Si algún día pasaran a privados: 3.000/mes de la cuenta Pro del dueño |
| Administración | Solo el dueño configura la protección de ramas, los secretos, Dependabot y los Environments. Es punto único de falla: la configuración se documenta en `docs/ops/GITHUB-SETUP.md` para poder rehacerla |
| Ramas | `main` protegida con el ruleset `protect-main`: todo cambio entra por **PR**, solo *squash*, historial lineal, sin *force push*, sin borrado y sin bypass; **CI en verde** y la rama actualizada en cuanto exista el primer workflow (G-10). **No se exige la aprobación de otra persona** (el enunciado pide ramas protegidas y pull requests, no un número de revisores): el autor se revisa con la checklist de la plantilla de PR, y la revisión de un compañero es recomendada. Ramas de trabajo con el formato `feat/<issue>-<slug>`, `fix/...`, `docs/...` |
| Commits | **Conventional Commits en inglés**, validados con `commitlint` + hook local (`lefthook` en los dos repos) y también en CI |
| CI en cada PR (app) | `dart format --set-exit-if-changed` → `flutter analyze` → `dart test` (motor) → `flutter test` (widgets) → verificación de arquitectura |
| CI en cada PR (api) | `lint` → `test` (unitarias) → `test:e2e` con Postgres → validación contra `openapi.yaml` |
| Verificación de arquitectura | Script en CI que falla si `hexa_engine` importa Flutter o paquetes de infraestructura, o si nombra una variante o una figura de celda concreta (detalle en `ARQ-01-APP-GENERAL.md` §8) |
| Release | Un tag `v*` en `hexablock-app` dispara la compilación del **APK firmado** (keystore en GitHub Secrets) y lo publica en un GitHub Release |
| Eficiencia | `concurrency` con `cancel-in-progress`, caché de `pub` y `npm`, filtros por ruta (`paths-ignore: docs/**`), sin runners macOS |
| Seguridad del repositorio | *Secret scanning* + *push protection*, Dependabot (pub, npm, Actions, Docker), `npm audit` en CI, `CODEOWNERS` para `CLAUDE.md`, `.claude/`, `.github/workflows/`, `docs/security/` y `docs/adr/` (solo pide revisión automáticamente; no bloquea el merge) |
| Seguridad del pipeline | `permissions:` mínimos por workflow, **sin `pull_request_target`**, deploy solo desde `main` a través del GitHub Environment `production` |

### 2.5 Documentación y diagramas

El enunciado §4.1 exige que el diagrama de clases muestre los genéricos **en "notación UML de plantilla"** (el parámetro en un recuadro punteado en la esquina de la clase). Mermaid no dibuja esa notación, así que el formato se elige por diagrama:

| Diagrama | Herramienta | Motivo |
|---|---|---|
| **Clases** (§4.1) | **PlantUML** (`.puml`) | Dibuja la notación de plantilla UML exacta (`class HexBoard<TCell>`), estereotipos, relaciones `«bind»` para mostrar cómo cada variante instancia el genérico, `package` por capa con color, y controla mejor el layout de diagramas grandes |
| **Capas Clean** (§4.2) | **Mermaid** (`.mmd`) | Subgraphs anidados (4 capas, flechas hacia adentro); GitHub lo muestra de forma nativa |
| **Extensibilidad** (§4.3) | **Mermaid** (`.mmd`) | Motor en el centro y variantes como extensiones; GitHub lo muestra de forma nativa |
| Diagramas de apoyo en documentos (flujos, estados, secuencias) | **Mermaid** | Se escriben directamente dentro de los `.md` |

- **Fuente editable:** `docs/diagrams/*.puml` y `docs/diagrams/*.mmd`.
- **Imagen:** un workflow exporta las fuentes a SVG/PNG en `docs/diagrams/` cuando cambian (PlantUML con su imagen Docker oficial; Mermaid con `@mermaid-js/mermaid-cli`). El README enlaza las imágenes exportadas (§4: "imagen de alta resolución + archivo fuente").
- **Tamaño:** el diagrama de clases se divide en vistas (núcleo del motor, una por variante, casos de uso + puertos, adaptadores) más una vista general.
- Decidido (11-11): como §4.1 exige la notación de plantilla, el diagrama de clases **se queda en PlantUML**.
- Los documentos de diseño se escriben en Markdown en `docs/`: requisitos, reglas de negocio, diseño del motor, arquitectura y ADRs.
- `README.md` en inglés, según §6.1.

### 2.6 Herramientas de IA

- **Herramienta principal: Claude Code**. Cada integrante trabaja en sus propios issues y ramas, y **commitea desde su propia cuenta** (§9).
- **Solo se usa Claude Code** (D-87): no hay reglas ni configuración para otras herramientas de agente. Si el equipo quisiera sumar otra, se decide y se agrega a `docs/ai/APPROVED-TOOLS.md` (SEC-AGT-04).
- **Configuración de Claude Code** en cada repo (paso 8, D-79 a D-86): `CLAUDE.md` corto en español y reglas por carpeta en `.claude/rules/`; permisos en `.claude/settings.json`; hooks en Node en `.claude/hooks/`; dos subagentes de solo lectura (`architecture-reviewer` y `security-reviewer`) en `.claude/agents/`; skills que se activan a mano en `.claude/skills/`. En la app, el servidor MCP de Dart y Flutter en `.mcp.json`. Herramientas aprobadas en `docs/ai/APPROVED-TOOLS.md`.
- **`AI_USAGE.md` se mantiene desde el día 1** en los dos repos, con la herramienta, el modelo y la versión de cada uso (§7.2).
- Las decisiones de diseño (genéricos, patrones, capas) las toma el equipo. La IA implementa y revisa (§7.3).
- **Ninguna máquina de desarrollo guarda credenciales de producción**: el despliegue lo hace solo el CI (SEC-AGT-02, SEC-AGT-03). Los permisos y hooks de `.claude/` son una barrera más, no la principal (SECURITY §6.1).

### 2.7 Seguridad

Los controles de seguridad, su prioridad y su verificación se definen en **[`docs/security/SECURITY-BASELINE.md`](../security/SECURITY-BASELINE.md)**, alineado con:

- OWASP API Security Top 10 (2023): marco principal del backend.
- OWASP Top 10:2025: backend, CI/CD e infraestructura.
- OWASP MASVS: app móvil.
- OWASP Top 10 for Agentic Applications (2026): flujo de desarrollo con agentes de IA.

Este ADR solo fija las herramientas. Cualquier cambio de stack que afecte un control de seguridad debe actualizar también ese documento.

---

## 3. Alternativas consideradas

| Alternativa | Motivo de descarte |
|---|---|
| React Native (TypeScript) | Mismo lenguaje que el backend, pero el render de tableros a medida y las pruebas de UI son menos directos que en Flutter, y el equipo prefiere Dart 3 |
| Kotlin + Jetpack Compose | Muy buenos genéricos, pero solo Android y sin ventaja clara frente a Flutter para este alcance |
| Unity (C#) / Godot | Motores pensados para juegos en tiempo real. Su ciclo de juego y su estructura de escenas complican aislar el dominio según Clean. GDScript tiene genéricos débiles |
| Flame (sobre Flutter) | Innecesario para juegos por turnos; añade un *game loop* que compite con `GameEngine` |
| Hive / Isar | Sin mantenimiento por su autor original |
| AWS App Runner | Cerrado a clientes nuevos desde el 30-04-2026 |
| ECS Express Mode + RDS | Mayor costo (balanceador + RDS + Fargate) y complejidad (VPC, IAM) sin aportar puntos al enunciado |
| Organización gratuita con repos públicos | Válida (Actions ilimitado, teams para `CODEOWNERS`, varios administradores), pero el equipo prefirió la simplicidad de una cuenta personal. Si hiciera falta, los repos se pueden transferir a una organización sin perder el historial |
| Repos privados en organización gratuita | Sin protección de ramas en el plan Free de organización → incumple §2 (el Pro personal de los miembros no se traspasa a la organización) |
| Todo en PlantUML | GitHub no lo muestra de forma nativa y requiere Java/Graphviz; se usa solo donde hace falta (diagrama de clases) |
| Todo en Mermaid | No dibuja la "notación UML de plantilla" que exige §4.1 para el diagrama de clases |
| draw.io / Lucidchart | Su formato no se revisa bien en un PR y es difícil que un agente lo mantenga |
| Pact (contrato *consumer-driven*) | El soporte en Dart está inmaduro. Se reemplaza por validación contra OpenAPI (ver §2.2) |

---

## 4. Consecuencias

**Positivas**
- La regla de dependencia de Clean la hace cumplir el gestor de paquetes, no la disciplina del equipo.
- El motor se prueba en segundos, sin emulador, lo que agiliza el TDD de las reglas de cada variante.
- La misma imagen Docker corre en local, en CI y en producción, lo que reduce el riesgo el día de la defensa.
- Costo USD 0 durante el semestre.

**Negativas / costos**
- Dos lenguajes (Dart y TypeScript): los DTOs se duplican. Se mitiga con `openapi.yaml` como fuente única y pruebas de contrato.
- La instancia EC2 la administra el equipo (actualizaciones, espacio en disco, respaldos).
- Toda la configuración de GitHub depende de una sola persona (el dueño). Se mitiga con `docs/ops/GITHUB-SETUP.md`.
- Con repos públicos, el código es visible para otros grupos. Mitigación: commits frecuentes y con fecha, que sirven como evidencia de autoría (§9).

---

## 5. Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| Se agotan los créditos de AWS y la cuenta se cierra | Alertas de AWS Budgets; solo EC2 + EBS + IP; nada de servicios administrados caros |
| La instancia cae durante la defensa | `restart: unless-stopped`, *healthcheck*, prueba de humo con `/health` el día anterior y un video de respaldo |
| 2 GB de RAM no alcanzan (Postgres + Node) | Límites de memoria en Compose y 1 GB de *swap*; subir a `t3.medium` solo si hace falta |
| El certificado HTTPS falla | Caddy lo renueva solo; verificar el DNS de DuckDNS al crear la instancia |
| Un agente de IA rompe la arquitectura | Verificación de arquitectura en CI + `architecture-reviewer` antes de cada PR + autorrevisión con la checklist de la plantilla de PR |
| Un agente ejecuta instrucciones inyectadas en un issue o PR público | Contenido de externos tratado como no confiable, permisos mínimos y sin credenciales de producción en las máquinas de desarrollo (SECURITY-BASELINE §6) |
| Se filtra un secreto en un repo público | *Push protection* + *secret scanning*; si ocurre, se **rota** el secreto de inmediato (borrarlo del historial no basta) |

---

## 6. Pendientes

Los pendientes que deja esta decisión están centralizados en **`hexablock-app/docs/PENDIENTES.md`** (secciones 1 y 4). Las decisiones ya cerradas están en `docs/DECISIONES.md` de cada repo.
