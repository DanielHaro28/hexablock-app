# PENDIENTES — HexaBlock Suite

> Lista única de pendientes del proyecto. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí. Las decisiones **cerradas** no están aquí: están en `docs/DECISIONES.md` de cada repo.
>
> Reúne los que estaban en `ADR-001-tech-stack.md` §6, `SECURITY-BASELINE.md` §9 y `CONTEXTO-CONVERSACION.md` §7; esos documentos ahora apuntan aquí.
>
> **Última actualización:** 2026-11-20 (revisión de documentos y seguridad: D-67 a D-75 abiertas) · **Entrega:** lunes 14-12-2026
>
> Completar la columna **Responsable** al repartir el trabajo. Al cerrar un ítem: cambiar ☐ por ☑ y anotar la fecha.

---

## 1. Decisiones del equipo

### 1.1 Abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-02 | **Repartir variantes y áreas** entre los 3 integrantes. _20-11: propuesta de cerrarla como cubierta por D-62 y los responsables de cada Issue._ Propuesta a discutir: motor + Hexa Merge · Hexa Lines + Hexa Sort · Hexa Fit + backend | Equipo | 12-11 | CONTEXTO §5 |
| ☐ D-03 | Respuesta de `POST /auth/register` cuando el correo ya existe. **Recomendación: A)** mantener **409** con rate limiting (5/min por IP), login genérico y en tiempo constante; aceptarlo como riesgo documentado. B) mensaje genérico + verificación por correo (lo ideal según OWASP, pero requiere enviar correos: fuera de alcance). C) 400 genérico (peor experiencia y no evita del todo la enumeración). SECURITY §3 y API-01 ya describen la opción A como propuesta | Equipo | Reunión | SECURITY §3, OWASP Authentication Cheat Sheet |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos | Equipo | Al implementar cada topología | RN-TOP-21 a 23 |
| ☐ D-67 | **Registro único de decisiones.** Hoy las decisiones están en `DECISIONES.md` y además en las tablas "Decisiones de este documento" de ARQ-01-APP, ARQ-01-API, ARQ-02 y ARQ-03 (con IDs propios `ARQ-A-*`), en `CONTEXTO-CONVERSACION.md` §3 y en textos de estado de este archivo. **A)** `DECISIONES.md` es el único registro: las tablas de los ARQ se cambian por una línea con los IDs, y las `ARQ-A-*` que no tienen D-* pasan a `DECISIONES.md` con su ID de siempre. **B)** Dejarlo como está. **Recomendación: A** | Equipo | 23-11 | Revisión de documentos (20-11) |
| ☐ D-68 | **Formato de `ARQ-02-MOTOR.md`** (629 líneas escritas como preguntas con opciones) y §10 de `ARQ-01-APP-GENERAL.md` (preguntas ya respondidas). **A)** Reescribir ARQ-02 como el diseño final, con las alternativas descartadas en una línea por decisión. **B)** Agregar al principio un resumen de una página del diseño final, pasar las opciones a un anexo y borrar ARQ-01 §10. **Recomendación: B** (menos trabajo y conserva los argumentos para la defensa) | Equipo | 23-11 | Revisión de documentos (20-11) |
| ☐ D-69 | **Tareas en un solo lugar.** Las tareas G-*, W-*, A-*, R-* y T-* están en las secciones 4 y 5 de este archivo y también como Issues. **A)** Las tareas viven solo en los Issues; aquí quedan las decisiones abiertas y las preguntas al profesor, y la hoja de ruta (§3) pasa a `PLAN-ENTREGA.md`. **B)** Mantener las dos listas. **Recomendación: A** | Equipo | 23-11 | Revisión de documentos (20-11) |
| ☐ D-70 | **`docs/ai/`** (`CONTEXTO-CONVERSACION.md` y `PROMPT-NUEVA-CONVERSACION.md`) sirve para retomar en un chat con zips y repite el índice, las decisiones y este archivo. **A)** En el Paso 8 se reemplaza por un `CLAUDE.md` en cada repo (reglas de trabajo y mapa de documentos) y se borra `docs/ai/`. **B)** Mantener los dos. **Recomendación: A** | Equipo | Paso 8 (T-01) | Revisión de documentos (20-11) |
| ☐ D-71 | **Contenido "para el README".** El enunciado §6.1 pide en el README los patrones, SOLID, AOP y el motor genérico, que hoy están en ARQ-02 §9 y ARQ-03 §5, §7 y §8. **A)** El README tiene el texto final, con enlaces al código, y los ARQ guardan solo la justificación y enlazan al README. **B)** El README resume y enlaza a los ARQ. **Recomendación: A** (el enunciado pide las secciones en el README), al escribirlo en T-07 | Equipo | T-07 | Enunciado §6.1 |
| ☐ D-72 | **Herramientas de revisión de documentos.** Los scripts que comprueban IDs, ejemplos, tablas y documentos compartidos, y el que genera `DECISIONES.md`, están solo en la sesión de la IA y se pierden al cerrarla. **A)** Pasarlos a `tools/docs-check/` en la app y correrlos en el CI de los dos repos; `DECISIONES.md` se edita a mano. **B)** No versionarlos. **Recomendación: A** | Equipo | M0 | Revisión de documentos (20-11) |
| ☐ D-73 | **Archivos binarios grandes.** El PDF del diseño pesa 10,5 MB y ya está en el historial (borrarlo no achica el repo). **A)** Dejarlo y no subir más binarios de más de 1 MB: las versiones nuevas del diseño van como enlace o como PNG de las pantallas que cambian. **B)** Git LFS (obliga a reescribir el historial). **Recomendación: A** | Equipo | 23-11 | Revisión de documentos (20-11) |
| ☐ D-74 | **Cómo se reportan vulnerabilidades (`SECURITY.md`, G-05).** SECURITY-BASELINE §7 dice "correo del equipo". **A)** *Private vulnerability reporting* de GitHub, sin publicar correos. **B)** Un correo del equipo en el `SECURITY.md`. **Recomendación: A** | Equipo | M0 (G-05) | Revisión de seguridad (20-11) |
| ☐ D-75 | **Keystore de firma del APK.** ADR-001 §2.4 dice que va en GitHub Secrets, pero SECURITY-BASELINE no tiene un control. **A)** Nuevo SEC-MOB-07: el keystore nunca está en el repo; va en base64 en un secreto del environment `release`, restringido a tags `v*`; el CI genera `key.properties` y lo borra; el dueño guarda una copia fuera de línea. **B)** Dejarlo solo en el ADR. **Recomendación: A** | Equipo | Antes de T-06 | Revisión de seguridad (20-11) |

### 1.2 Cerradas

Están en **`docs/DECISIONES.md` de cada repo** (desde el 17-11): `hexablock-app/docs/DECISIONES.md` tiene todas y `hexablock-api/docs/DECISIONES.md`, las que afectan al backend, con el mismo texto. Al cerrar una decisión de §1.1, se borra de aquí y se agrega allí con su fecha.

## 2. Preguntas para el profesor

El profesor indicó (11-11) que lo que el enunciado no especifica lo decide el equipo. Las respuestas (P-01 a P-13) están en `docs/DECISIONES.md` §2. Esta sí está especificada en el enunciado, por eso se pregunta:

| # | Pregunta | Por qué | Responsable |
|---|---|---|---|
| ☑ P-14 | ¿Cuentan como **"diseñados manualmente"** (enunciado §1.2 y §5.1) los niveles que propone un generador y que el equipo después elige, juega, ajusta y nombra, uno por uno? | D-53: si la respuesta es no, los 25 niveles se diseñan a mano y el generador queda solo para verificar | Dueño · **Respuesta (20-11): sí**; ver `DECISIONES.md` |

## 3. Documentos de diseño (hoja de ruta)

Objetivo: terminar los Pasos 1 a 8 en **una semana como máximo** (≈ 18-11-2026). La arquitectura se hace en **dos pasadas**, con el motor en medio: la general enmarca el motor y la detallada depende de sus interfaces.

| Paso | Documento | Repo | Estado | Responsable |
|---|---|---|---|---|
| 0 | `docs/adr/ADR-001-tech-stack.md` | Ambos (compartido) | ✅ Hecho (rev. 1.9) | — |
| 0b | `docs/security/SECURITY-BASELINE.md` | Ambos (compartido) | ✅ Hecho | — |
| 1 | **Requisitos** (`docs/requirements/`): glosario, reglas de negocio (comunes, topologías, 4 variantes, niveles, cuenta/progreso/ranking), RF + RNF, historias, trazabilidad | Ambos (ver `docs/README.md`) | 📝 **Borrador listo — revisión de cada integrante.** Abiertas: D-19, D-20 | |
| 2 | **Arquitectura general** (`docs/architecture/`): `ARQ-00-SISTEMA.md` (compartido), `ARQ-01-APP-GENERAL.md`, `ARQ-01-API-GENERAL.md` | Ambos | ✅ **Decisiones cerradas** (D-21 a D-23, 17-11). Las propuestas 🟡 sin número (ARQ-S-02 a 04, ARQ-A-05 a 08, ARQ-B-04) se confirman o ajustan en el Paso 4 | |
| 3 | **Motor genérico:** tipos genéricos, interfaces de topología y reglas, ciclo de turno, estados, eventos, coordenada (D-07) | App | ✅ **Decidido (17-11)** en `docs/architecture/ARQ-02-MOTOR.md` (D-29 a D-35). Queda abierta D-36 | |
| 4 | **Arquitectura detallada:** casos de uso genéricos, puertos y adaptadores, mapa de patrones, aspecto AOP, los 3 diagramas (clases en PlantUML; capas y extensibilidad en Mermaid) y `EXTENSIBILITY.md` | Ambos | 📝 **Listo (19-11)**: `ARQ-03-APP-DETALLE.md`, `ARQ-03-API-DETALLE.md`, `docs/diagrams/` y `EXTENSIBILITY.md` (D-38 a D-43). Falta generar `clases.png` en los dos repos (R-04) | DanielHaro28 (R-04) |
| 5 | **Contratos:** `openapi.yaml`, JSON Schema de niveles, progreso, ranking y errores, ejemplos compartidos en JSON, modelo de datos local (Drift) y del servidor (Prisma) | Ambos | ✅ **Hecho (19-11):** `hexablock-api/docs/contracts/` (copia idéntica en la app), `ARQ-04-API-DATOS.md`, `ARQ-04-APP-DATOS.md`. Cerradas D-27, D-44 a D-51 (D-39 ajustada). D-19 y D-52 cerradas después (19-11) | |
| 6 | **Contenido y pruebas:** 15 niveles de Hexa Fit y 10 de Hexa Sort; estrategia de pruebas | App (+ API para pruebas) | ✅ **Hecho (20-11):** 25 niveles candidatos en `app/assets/levels/` (catálogo en `docs/levels/`), `levelgen.py` y `levelcheck.py`, `docs/testing/ESTRATEGIA-PRUEBAS.md` en los dos repos. Cerradas D-28, D-36, D-53 a D-60. P-14 respondida (sí) y D-61 cerrada. Queda la aprobación de los niveles por el equipo en el APK (R-05) | Equipo (aprobar niveles) |
| 7 | **Plan:** historias en GitHub Issues (un Issue por repo para las compartidas), milestones semanales, Definition of Done | Ambos | ✅ **Hecho (20-11):** 86 Issues (69 en la app, 17 en la API) con etiquetas, milestones M0 a M3, responsables y estimación; plantillas de Issue y `CODEOWNERS`; `docs/plan/PLAN-ENTREGA.md`; diseño revisado (`docs/design/`). Cerradas D-26 y D-62 a D-66. Tablero [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) creado (T-02, ver `PLAN-ENTREGA.md` §4). Falta: aceptar las invitaciones (G-01) | Dueño (G-01) |
| 8 | **Preparación para Claude Code:** `CLAUDE.md`, `.claude/agents/`, `.claude/settings.json` por repo | Ambos | ☐ Pendiente | |

**Topologías adicionales** (historias TEC-07 a TEC-09), después de tener las 4 variantes jugables con hexágonos: cuadrados y triángulos jugables (Should), cubos en el dominio (Should), vista 3D (Could).

## 4. Configuración inicial

### 4.1 GitHub (antes de escribir código)

| # | Pendiente | Responsable | Origen |
|---|---|---|---|
| ☐ G-01 | Repos `hexablock-app` y `hexablock-api` **creados** en la cuenta de DanielHaro28 (11-11). **Falta:** invitar a los otros 2 como colaboradores (permiso de escritura) | Dueño | ADR-001 §2.4 | _20-11: invitaciones enviadas a @dicpc (diseño e interfaz) y @DavidCR20 (dominio). **Falta que las acepten**: todavía no se les puede asignar Issues (55 quedan con la asignación pendiente, `docs/plan/PLAN-ENTREGA.md`)._
| ☑ G-02 | Ruleset `protect-main` en ambos repos: PR obligatorio con 0 aprobaciones, solo *squash*, historial lineal, sin *force push* ni borrado, sin bypass (11-11) | Dueño | SECURITY §7 |
| ☐ G-03 | Activar **secret scanning**, **push protection** y **Dependabot** (alerts, security updates y `.github/dependabot.yml`) | Dueño | SECURITY §7 |
| ☑ G-04 | Crear `CODEOWNERS` con los 3 usuarios reales (solo pide revisión, no bloquea) | Dueño | SECURITY §6.2 | _Hecho el 20-11: `.github/CODEOWNERS` en los dos repos, por área (D-62)._
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
| ☐ R-05 | **Revisar los 25 niveles candidatos** (D-53): cada integrante los juega en el orden de `docs/levels/CATALOGO.md` y ajusta los que no le convenzan (nombre, figura, piezas, semilla). Después de cada cambio, `python3 -I tools/reference-sim/levelcheck.py` debe pasar. Lo que ajustó cada uno queda en `AI_USAGE.md`. **Se hace cuando el juego esté implementado en el APK** (decisión del 20-11), al final del milestone en que Fit y Sort sean jugables | Los 3 | D-53, D-54, D-55; P-14 |

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
