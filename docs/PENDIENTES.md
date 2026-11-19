# PENDIENTES — HexaBlock Suite

> Lista única de pendientes del proyecto. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí. Las decisiones **cerradas** no están aquí: están en `docs/DECISIONES.md` de cada repo.
>
> Reúne los que estaban en `ADR-001-tech-stack.md` §6, `SECURITY-BASELINE.md` §9 y `CONTEXTO-CONVERSACION.md` §7; esos documentos ahora apuntan aquí.
>
> **Última actualización:** 2026-11-19 (Paso 4 fusionado: PR app #6 y api #4; Paso 5 en curso con D-44 a D-50; planificación en `main` por los PR #1; `AI_USAGE.md` en los PR #2; Paso 3 decidido; decisiones cerradas en `DECISIONES.md`; D-21 a D-23 y D-37 a D-43 cerradas; D-36 revisada; Paso 4 listo) · **Entrega:** lunes 14-12-2026
>
> Completar la columna **Responsable** al repartir el trabajo. Al cerrar un ítem: cambiar ☐ por ☑ y anotar la fecha.

---

## 1. Decisiones del equipo

### 1.1 Abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-02 | **Repartir variantes y áreas** entre los 3 integrantes. Propuesta a discutir: motor + Hexa Merge · Hexa Lines + Hexa Sort · Hexa Fit + backend | Equipo | 12-11 | CONTEXTO §5 |
| ☐ D-03 | Respuesta de `POST /auth/register` cuando el correo ya existe. **Recomendación: A)** mantener **409** con rate limiting (5/min por IP), login genérico y en tiempo constante; aceptarlo como riesgo documentado. B) mensaje genérico + verificación por correo (lo ideal según OWASP, pero requiere enviar correos: fuera de alcance). C) 400 genérico (peor experiencia y no evita del todo la enumeración). SECURITY §3 y API-01 ya describen la opción A como propuesta | Equipo | Reunión | SECURITY §3, OWASP Authentication Cheat Sheet |
| ☐ D-19 | **Quién valida qué en los niveles.** **A)** el backend valida el esquema y las reglas **estructurales** (RN-HF-12 a–e, g; RN-HS-12); el dominio de la app valida además la **geométrica** (RN-HF-12 f: la solución de cada pieza es una orientación de su forma), en CI para los niveles incluidos y al descargar; el administrador pasa el nivel por el validador de la app antes de publicarlo. **B)** el backend valida todo, también (f): obliga a reescribir en TypeScript los giros de las 4 figuras y mantener dos copias iguales. **C)** el backend solo valida el esquema: un nivel mal hecho se publica y la app lo descarta al descargarlo. **Recomendación: A.** Si un nivel pasa el servidor pero falla (f), la app lo descarta (RN-COM-71) y el jugador nunca lo ve | Equipo | Paso 5 (contratos) | RN-COM-76 |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos | Equipo | Al implementar cada topología | RN-TOP-21 a 23 |
| ☐ D-26 | **Figura global o por variante.** Recomendación: **una sola figura para todo el juego**, elegida en Ajustes | Equipo | Reunión | RN-TOP-32 |
| ☐ D-27 | **Progreso, récord y ranking separados por figura.** Recomendación: **sí**, porque los tableros no son comparables. **Cuidado con el enunciado §5.2**, que pide "una entrada de progreso por usuario y por variante". Dos formas de guardarlo: **A)** la topología forma parte de la clave (`userId` + `gameId` + `topology`): consultas simples, pero hay varias entradas por usuario y variante, lo que se aparta de la letra del enunciado; **B)** una entrada por `userId` + `gameId`, con una sección por figura dentro del JSON: cumple el enunciado al pie de la letra, a cambio de que la consolidación recorra las secciones. `BEST_ATTEMPT` lleva la columna `topology` en los dos casos, porque el ranking la filtra. Recomendación: **B**. Los documentos describen hoy A como borrador (ARQ-01-API §6). **Con B, en el contrato:** `PUT /v1/me/progress/{gameId}` recibe `{ sections: { "<topología>": … } }` solo con las figuras que cambiaron, y el servidor consolida sección por sección | Equipo | Reunión (afecta el Paso 5) | RN-TOP-33, RN-COM-80, 100; Enunciado §5.2 |
| ☐ D-28 | **Niveles por figura.** Recomendación: los 15 de Fit y 10 de Sort obligatorios en hexágonos; Fit con niveles de muestra para las otras figuras; los de Sort sin pilas iniciales sirven para cualquier figura (`topology: any`); "No disponible con esta figura" si no hay niveles | Equipo | Paso 6 | RN-TOP-34, RN-COM-75 |
| ☐ D-36 | **Cómo se protege el Template Method** de las reglas (`GameRules.playTurn`, ARQ-02 §9.6), ya que Dart no tiene métodos `final`. **Recomendación (revisada el 17-11): B)** sin dependencias: una regla en la plantilla de PR más una prueba de arquitectura en CI que falle si una clase de `hexa_variants` declara `playTurn`. Motivo: el enunciado §3.4 pide que la capa 1 no tenga **ninguna** dependencia externa, y A) `@nonVirtual` de `package:meta` lo sería, aunque sea del equipo de Dart | Equipo | Antes de TEC-01 | ARQ-02 §9.6, D-35; Enunciado §3.4 |
| ☐ D-44 | **Duración de la sesión (JWT).** **A)** un solo token válido **24 h**; al vencer, la app pide iniciar sesión antes de sincronizar (RN-COM-87) y se sigue jugando sin conexión. **B)** token de acceso de 1 h + token de renovación de 7 días, rotativo y guardado con hash: el jugador inicia sesión una vez por semana, a cambio de una tabla `refresh_tokens`, `POST /v1/auth/refresh`, rotación y detección de reutilización. **Recomendación: A** por el plazo (SECURITY lo marca Must; B es Should). Agregar B después no rompe el contrato: es un endpoint nuevo | Equipo | Paso 5 | SEC-API-02, SEC-MOB-01, RN-COM-87 |
| ☐ D-45 | **Forma del progreso que viaja entre app y API** (el JSON de cada variante). **A)** una sola forma para todo, con campos opcionales. **B)** **dos formas, según el modelo de progreso** (`IProgressModel`): récord (`{ kind: "highScore", best: { score, achievedAt } }`, para Lines y Merge) y niveles (`{ kind: "levels", levels: { "<levelId>": { stars?, timeMs, moves, score, achievedAt } } }`, para Fit y Sort; un nivel está completado si aparece en el mapa). **C)** cuatro formas, una por `gameId`. **Recomendación: B**: coincide con el enunciado (puntaje máximo frente a niveles con estrellas), la consolidación es una por modelo (unión de niveles, máximo de récord, mejor intento con el criterio de la variante) y una 5.ª variante reutiliza una de las dos | Equipo | Paso 5 | RN-COM-80, 83; Enunciado §3.1 (`IProgressModel`) |
| ☐ D-46 | **Convenciones de la API.** **A)** prefijo de versión **`/v1`**; JSON en `camelCase`; fechas ISO 8601 en UTC; duraciones en milisegundos; usuarios con UUID; paginación con `limit` (1–100, 20 por defecto) y `offset`; errores `{ code, message, details }` (D-39). **B)** igual pero sin prefijo de versión. **C)** igual pero con paginación por cursor. **Recomendación: A.** El APK instalado no se actualiza solo: si algún día hay un cambio incompatible, va a `/v2` y los teléfonos con la versión vieja siguen funcionando. El ranking es corto, así que `offset` basta | Equipo | Paso 5 | SEC-API-04, D-39, RNF-25 |
| ☐ D-47 | **Identidad y formato de los niveles.** `id` legible y estable, escrito a mano: `<variante>-<figura>-<nnn>` (ej. `fit-hex-001`, `sort-any-003`), en vez de UUID, porque los niveles incluidos y los descargados se juntan por `id` (RN-COM-72). Archivos en **JSON** (no YAML), con el mismo JSON Schema que usa la API, para no sumar un lector de YAML a la app. Celdas como **listas de enteros** (`[q, r]` en hexágonos, `[x, y, z]` en cubos), cuyo largo depende de la figura. **Recomendación: las tres cosas.** La alternativa YAML se escribe más cómodo a mano y admite comentarios, pero obliga a convertir y a validar dos formatos | Equipo | Paso 5 | RN-COM-70, 72, 75; Enunciado §3.3 (Builder) |
| ☐ D-48 | **Cómo descarga la app los niveles nuevos.** **A)** `GET /v1/levels?gameId=…&topology=…` devuelve **todos** los niveles publicados de esa variante y figura, con `ETag`; la app manda `If-None-Match` y recibe **304** si no cambió nada. **B)** `?since=<fecha>` devuelve solo los cambiados desde esa fecha. **Recomendación: A**: son menos de 50 niveles de pocos KB, y no depende de que los relojes coincidan. En los dos casos **no hay `DELETE`**: los niveles solo se agregan (`POST`) o se actualizan subiendo la `version` (`PUT`), así el progreso nunca apunta a un nivel que desapareció (RN-COM-73, 74) | Equipo | Paso 5 | RN-COM-72 a 74, P-09 |
| ☐ D-49 | **Base de datos local (Drift).** El progreso se guarda con **el mismo JSON** que viaja a la API (D-45), no en tablas normalizadas: un solo formato y la misma consolidación en los dos lados. La **cola de sincronización** guarda solo **qué combinación (perfil + variante) tiene cambios**, no cada cambio; al sincronizar se envía el progreso actual. **Alternativa:** guardar cada cambio como un evento: más filas y más peticiones, sin ganar nada porque se envía el progreso completo (RN-COM-86). **Recomendación: JSON + cola de marcas.** Tablas: `profiles`, `progress`, `saved_games` (D-37), `downloaded_levels`, `sync_outbox`; los ajustes van en `shared_preferences` y el JWT en almacenamiento seguro | Equipo | Paso 5 | RN-COM-82, 85, 86; D-37; SEC-MOB-01 |
| ☐ D-50 | **Nombre visible en el ranking.** **A)** **único** (sin distinguir mayúsculas), de 3 a 20 caracteres (letras, números, espacio, `_`, `-`, `.`); si ya existe, `409 DISPLAY_NAME_TAKEN`. **B)** repetible, y el ranking agrega un sufijo (`Ana#4821`). **C)** repetible, sin sufijo. **Recomendación: A**: dos "Ana" en el ranking confunden y es lo habitual en juegos. No expone datos privados, a diferencia del correo (D-03) | Equipo | Paso 5 | RN-COM-106, RF-70 |

### 1.2 Cerradas

Están en **`docs/DECISIONES.md` de cada repo** (desde el 17-11): `hexablock-app/docs/DECISIONES.md` tiene todas y `hexablock-api/docs/DECISIONES.md`, las que afectan al backend, con el mismo texto. Al cerrar una decisión de §1.1, se borra de aquí y se agrega allí con su fecha.

## 2. Preguntas para el profesor

No quedan preguntas abiertas: el profesor indicó (11-11) que lo que el enunciado no especifica lo decide el equipo. Las respuestas (P-01 a P-13) están en `docs/DECISIONES.md` §2.

## 3. Documentos de diseño (hoja de ruta)

Objetivo: terminar los Pasos 1 a 8 en **una semana como máximo** (≈ 18-11-2026). La arquitectura se hace en **dos pasadas**, con el motor en medio: la general enmarca el motor y la detallada depende de sus interfaces.

| Paso | Documento | Repo | Estado | Responsable |
|---|---|---|---|---|
| 0 | `docs/adr/ADR-001-tech-stack.md` | Ambos (compartido) | ✅ Hecho (rev. 1.6) | — |
| 0b | `docs/security/SECURITY-BASELINE.md` | Ambos (compartido) | ✅ Hecho | — |
| 1 | **Requisitos** (`docs/requirements/`): glosario, reglas de negocio (comunes, topologías, 4 variantes, niveles, cuenta/progreso/ranking), RF + RNF, historias, trazabilidad | Ambos (ver `docs/README.md`) | 📝 **Borrador listo — revisión de cada integrante.** Abiertas: D-19, D-20 | |
| 2 | **Arquitectura general** (`docs/architecture/`): `ARQ-00-SISTEMA.md` (compartido), `ARQ-01-APP-GENERAL.md`, `ARQ-01-API-GENERAL.md` | Ambos | ✅ **Decisiones cerradas** (D-21 a D-23, 17-11). Las propuestas 🟡 sin número (ARQ-S-02 a 04, ARQ-A-05 a 08, ARQ-B-04) se confirman o ajustan en el Paso 4 | |
| 3 | **Motor genérico:** tipos genéricos, interfaces de topología y reglas, ciclo de turno, estados, eventos, coordenada (D-07) | App | ✅ **Decidido (17-11)** en `docs/architecture/ARQ-02-MOTOR.md` (D-29 a D-35). Queda abierta D-36 | |
| 4 | **Arquitectura detallada:** casos de uso genéricos, puertos y adaptadores, mapa de patrones, aspecto AOP, los 3 diagramas (clases en PlantUML; capas y extensibilidad en Mermaid) y `EXTENSIBILITY.md` | Ambos | 📝 **Listo (19-11)**: `ARQ-03-APP-DETALLE.md`, `ARQ-03-API-DETALLE.md`, `docs/diagrams/` y `EXTENSIBILITY.md` (D-38 a D-43). Falta generar `clases.png` en los dos repos (R-04) | DanielHaro28 (R-04) |
| 5 | **Contratos:** `openapi.yaml`, JSON Schema de niveles y de progreso, ejemplos compartidos en JSON, modelo de datos local (Drift) y del servidor (Prisma) | Ambos | 🟡 **En curso (19-11):** propuestas en D-19, D-27 y D-44 a D-50; los contratos se escriben al cerrarlas | |
| 6 | **Contenido y pruebas:** 15 niveles de Hexa Fit y 10 de Hexa Sort; estrategia de pruebas | App (+ API para pruebas) | ☐ Pendiente | |
| 7 | **Plan:** historias en GitHub Issues (un Issue por repo para las compartidas), milestones semanales, Definition of Done | Ambos | ☐ Pendiente | |
| 8 | **Preparación para Claude Code:** `CLAUDE.md`, `.claude/agents/`, `.claude/settings.json` por repo | Ambos | ☐ Pendiente | |

**Topologías adicionales** (historias TEC-07 a TEC-09), después de tener las 4 variantes jugables con hexágonos: cuadrados y triángulos jugables (Should), cubos en el dominio (Should), vista 3D (Could).

## 4. Configuración inicial

### 4.1 GitHub (antes de escribir código)

| # | Pendiente | Responsable | Origen |
|---|---|---|---|
| ☐ G-01 | Repos `hexablock-app` y `hexablock-api` **creados** en la cuenta de DanielHaro28 (11-11). **Falta:** invitar a los otros 2 como colaboradores (permiso de escritura) | Dueño | ADR-001 §2.4 |
| ☑ G-02 | Ruleset `protect-main` en ambos repos: PR obligatorio con 0 aprobaciones, solo *squash*, historial lineal, sin *force push* ni borrado, sin bypass (11-11) | Dueño | SECURITY §7 |
| ☐ G-03 | Activar **secret scanning**, **push protection** y **Dependabot** (alerts, security updates y `.github/dependabot.yml`) | Dueño | SECURITY §7 |
| ☐ G-04 | Crear `CODEOWNERS` con los 3 usuarios reales (solo pide revisión, no bloquea) | Dueño | SECURITY §6.2 |
| ☐ G-05 | Crear `SECURITY.md` en la raíz de ambos repos | Cualquiera | SECURITY §7 |
| ☐ G-06 | Exigir aprobación para workflows de colaboradores externos (forks) | Dueño | SECURITY §7 |
| ☐ G-07 | Configurar `commitlint` + `lefthook` en ambos repos | Cualquiera | ADR-001 §2.4 |
| ☐ G-08 | Escribir `docs/ops/GITHUB-SETUP.md` con toda la configuración aplicada (el dueño es punto único de falla) | Dueño | ADR-001 §4 |
| ☑ G-09 | `.github/pull_request_template.md` con la checklist de autorrevisión, en ambos repos (redactada el 11-11; en `main` desde el 17-11 por los PR #1) | Cualquiera | SECURITY §7 |
| ☐ G-10 | Activar **Require status checks to pass** en el ruleset de cada repo cuando su primer workflow de CI haya corrido | Dueño | SECURITY §7 |

### 4.2 Agentes de IA (antes de usar Claude Code o Cline en los repos)

| # | Pendiente | Responsable | Origen |
|---|---|---|---|
| ☐ A-01 | Crear `.claude/settings.json` con los permisos base, después de verificar la sintaxis contra la versión de Claude Code en uso | | SECURITY §6.1 |
| ☐ A-02 | Verificar que **ninguna máquina de desarrollo** tenga la clave SSH de EC2 ni credenciales de AWS con permisos de escritura | Cada integrante | SECURITY SEC-AGT-03 |
| ☐ A-03 | Crear `AI_USAGE.md` en ambos repos y registrar el uso de IA de esta planificación (incluida la conversación con Claude). **17-11: creado en los PR #2 de cada repo.** Falta que el equipo complete los campos ⚠️: modelo de las conversaciones anteriores al 12-11, transcripciones de IA-01 a IA-06, uso de Claude Code y Cline por integrante, porcentaje de asistencia y reflexión | Equipo | ADR-001 §2.6, Enunciado §7.2 |
| ☐ A-04 | Crear `docs/ai/APPROVED-TOOLS.md` (herramientas y servidores MCP aprobados) | | SECURITY SEC-AGT-04 |

### 4.3 AWS (antes de lanzar EC2)

| # | Pendiente | Responsable | Origen |
|---|---|---|---|
| ☐ W-01 | Crear el **budget** en AWS Budgets con alertas al 50 % y 80 % de los créditos | Dueño de la cuenta AWS | ADR-001 §2.3 |
| ☐ W-02 | Registrar el subdominio en **DuckDNS** | | ADR-001 §2.3 |
| ☐ W-03 | Lanzar EC2 `t3.small` en `us-east-1` y confirmar el precio en AWS Pricing Calculator | | ADR-001 §2.3 |
| ☐ W-04 | Endurecer la instancia: solo clave SSH, `PermitRootLogin no`, `unattended-upgrades`, IMDSv2 obligatorio, Security Group 80/443/22 (5432 cerrado) | | SECURITY SEC-WEB-01 |
| ☐ W-05 | Escribir `docs/ops/DEPLOY.md` con el checklist de despliegue | | SECURITY SEC-WEB-01 |
| ☐ W-06 | Crear el Environment `production` en `hexablock-api` con los secretos `EC2_HOST` y `EC2_SSH_KEY` | Dueño | SECURITY §7 |

### 4.4 Documentación del proyecto

| # | Pendiente | Responsable | Origen |
|---|---|---|---|
| ☐ R-01 | Fijar en el README las versiones exactas de Flutter, Dart, Node, NestJS, Prisma y PostgreSQL | | ADR-001 §2.1–2.2 |
| ☐ R-02 | Citar las fuentes de los algoritmos sugeridos por la IA (xorshift32 de Marsaglia en RN-COM-43; coordenadas hexagonales de Red Blob Games en `02-RN-TOPOLOGIAS.md`) y repetir la cita en el comentario de la clase que los implemente | | Enunciado §7.3, `AI_USAGE.md` §5 |
| ☐ R-03 | Quitar `*.lock` del `.gitignore` de la app antes del primer commit de código, para que `pubspec.lock` se suba | | Revisión del 17-11 |
| ☐ R-04 | Generar `docs/diagrams/clases.png` en los dos repos desde `clases.puml` con la extensión de PlantUML de VS Code (exportar en alta resolución) y corregir el `.puml` si PlantUML marca algún error. Repetir cada vez que cambie el `.puml` | DanielHaro28 | D-43 |

## 5. Antes de la defensa

| # | Pendiente | Responsable | Origen |
|---|---|---|---|
| ☐ F-01 | Todas las pruebas de seguridad (SECURITY §8) en verde en CI | | SECURITY §9 |
| ☐ F-02 | `npm audit` y Dependabot sin alertas *high/critical* abiertas | | SECURITY §9 |
| ☐ F-03 | Secret scanning sin alertas abiertas | | SECURITY §9 |
| ☐ F-04 | EC2: `/health` responde por HTTPS, puertos verificados, respaldo reciente y probado | | SECURITY §9, SEC-WEB-08 |
| ☐ F-05 | El usuario admin de la demo tiene contraseña robusta y **no** aparece en el README | | SECURITY §9 |
| ☐ F-06 | `AI_USAGE.md` al día en ambos repos | | SECURITY §9 |
| ☐ F-07 | Prueba de humo el día anterior + video de respaldo de las 4 variantes | | ADR-001 §5 |
| ☐ F-08 | APK firmado publicado en el GitHub Release | | Enunciado §8 |
| ☐ F-09 | Ensayar en vivo cómo se agregaría una 5ª variante o un cambio de regla | Equipo | Enunciado §3.1 |
| ☐ F-10 | Ensayar en vivo el **cambio de topología** (triángulos, cuadrados o cubos), o mostrarlo ya implementado | Equipo | Profesor 11-11 |
