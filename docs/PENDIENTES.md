# PENDIENTES — HexaBlock Suite

> Lista única de pendientes del proyecto. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí. Las decisiones **cerradas** no están aquí: están en `docs/DECISIONES.md` de cada repo.
>
> Reúne los que estaban en `ADR-001-tech-stack.md` §6, `SECURITY-BASELINE.md` §9 y `CONTEXTO-CONVERSACION.md` §7; esos documentos ahora apuntan aquí.
>
> **Última actualización:** 2026-11-19 (Paso 4 fusionado: PR app #6 y api #4; Paso 5 en curso: D-27, D-44 a D-46, D-48 a D-50 cerradas; planificación en `main` por los PR #1; `AI_USAGE.md` en los PR #2; Paso 3 decidido; decisiones cerradas en `DECISIONES.md`; D-21 a D-23 y D-37 a D-43 cerradas; D-36 revisada; Paso 4 listo) · **Entrega:** lunes 14-12-2026
>
> Completar la columna **Responsable** al repartir el trabajo. Al cerrar un ítem: cambiar ☐ por ☑ y anotar la fecha.

---

## 1. Decisiones del equipo

### 1.1 Abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-02 | **Repartir variantes y áreas** entre los 3 integrantes. Propuesta a discutir: motor + Hexa Merge · Hexa Lines + Hexa Sort · Hexa Fit + backend | Equipo | 12-11 | CONTEXTO §5 |
| ☐ D-03 | Respuesta de `POST /auth/register` cuando el correo ya existe. **Recomendación: A)** mantener **409** con rate limiting (5/min por IP), login genérico y en tiempo constante; aceptarlo como riesgo documentado. B) mensaje genérico + verificación por correo (lo ideal según OWASP, pero requiere enviar correos: fuera de alcance). C) 400 genérico (peor experiencia y no evita del todo la enumeración). SECURITY §3 y API-01 ya describen la opción A como propuesta | Equipo | Reunión | SECURITY §3, OWASP Authentication Cheat Sheet |
| ☐ D-19 | **Quién revisa que un nivel esté bien hecho.** Que el equipo suba los niveles por el endpoint no quita la revisión: el endpoint es la **última barrera** antes de que un nivel llegue a todos los teléfonos (un error de tipeo, un archivo equivocado o un token de administrador robado; SEC-API-10 pide validar toda entrada). La pregunta es solo **qué revisa cada lado**. **A)** el backend revisa el esquema y las reglas **estructurales** (RN-HF-12 a–e y g; RN-HS-12) y rechaza con 400; la app revisa además la **geométrica** (RN-HF-12 f: la solución de cada pieza es su forma girada y trasladada), en CI para los niveles incluidos y al descargar; antes de publicar, quien sube el nivel lo pasa por el validador de la app (un comando: `dart run tool/validate_level.dart nivel.json`). **B)** el backend revisa todo, también (f): hay que escribir en TypeScript los giros de las 4 figuras y mantener dos copias iguales. **C)** el backend solo revisa el esquema. **Recomendación: A.** Si un nivel pasara el servidor pero fallara (f), la app lo descarta al descargarlo (RN-COM-71) y el jugador nunca lo ve | Equipo | Paso 5 (contratos) | RN-COM-71, 76; SEC-API-10 |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos | Equipo | Al implementar cada topología | RN-TOP-21 a 23 |
| ☐ D-26 | **Figura global o por variante.** Recomendación: **una sola figura para todo el juego**, elegida en Ajustes | Equipo | Reunión | RN-TOP-32 |
| ☐ D-28 | **Niveles por figura.** Recomendación: los 15 de Fit y 10 de Sort obligatorios en hexágonos; Fit con niveles de muestra para las otras figuras; los de Sort sin pilas iniciales sirven para cualquier figura (`topology: any`); "No disponible con esta figura" si no hay niveles | Equipo | Paso 6 | RN-TOP-34, RN-COM-75 |
| ☐ D-36 | **Cómo se protege el Template Method** de las reglas (`GameRules.playTurn`, ARQ-02 §9.6), ya que Dart no tiene métodos `final`. **Recomendación (revisada el 17-11): B)** sin dependencias: una regla en la plantilla de PR más una prueba de arquitectura en CI que falle si una clase de `hexa_variants` declara `playTurn`. Motivo: el enunciado §3.4 pide que la capa 1 no tenga **ninguna** dependencia externa, y A) `@nonVirtual` de `package:meta` lo sería, aunque sea del equipo de Dart | Equipo | Antes de TEC-01 | ARQ-02 §9.6, D-35; Enunciado §3.4 |
| ☐ D-47 | **Identidad y formato de los niveles.** Recomendación con el contexto del proyecto: **(1) `id` legible, escrito a mano y que nunca cambia:** `<variante>-<figura>-<nnn>` (ej. `fit-hex-001`, `sort-any-004`; patrón `^[a-z]+-(hex\|square\|tri\|cube\|any)-[0-9]{3,4}$`). Motivos: los niveles incluidos y los descargados se juntan por `id` (RN-COM-72); el progreso se guarda por `id` (RN-COM-74); el equipo escribe 25 niveles a mano (Paso 6) y los sube por Swagger, donde un UUID se confunde fácil; incluye la figura (D-28) y `any` para Sort (RN-COM-75); una 5.ª variante sigue igual (`fill-hex-001`). El número es un nombre, no la posición: el orden lo da `order`, así que meter un nivel entre el 3 y el 4 no renombra nada. **(2) Archivos en JSON, no YAML:** la API solo habla JSON; un mismo JSON Schema valida los archivos de la app en CI y lo que llega a `POST /v1/levels`; Dart lee JSON con `dart:convert`, sin paquetes extra; el Builder (enunciado §3.3) no cambia. YAML se escribe más cómodo y admite comentarios, pero suma un paquete y una conversión. **(3) Celdas como listas de enteros** (la lista es solo la **dirección** de la celda; lo que hay en ella va en la sección de la variante: en Fit, qué pieza la cubre en la solución; en Sort, la pila inicial con sus colores): `[q, r]` en hexágonos (axiales), `[x, y]` en cuadrados y `[x, y, z]` en cubos; el esquema revisa el largo según la figura. Objetos como `{q, r}` se leen mejor, pero cada figura tendría nombres distintos y su propio esquema | Equipo | Paso 5 | RN-COM-70 a 75; D-28; Enunciado §3.3 (Builder) |
| ☐ D-51 | **Errores según estándares internacionales y sin filtrar información** (reabre la parte del backend de D-39, a pedido del usuario). No hay norma ISO para el formato de errores HTTP; los estándares de HTTP son del **IETF** y las guías de seguridad, de **OWASP** y **MITRE (CWE)**. **Lo que ya cumple:** sin *stack* en producción (SEC-API-08; CWE-209); login con 401 genérico y en tiempo constante (OWASP WSTG-IDNT-04); 500 genérico con *correlation id* (ASVS 7.4.1); filtro global que falla cerrado (SEC-WEB-07; OWASP A10:2025); redacción en los registros (SEC-WEB-06); la app nunca muestra un *stack*. **Lo que falta:** (1) el formato es propio y no el RFC 9457; (2) los códigos tienen dos estilos (`email-taken` y `DISPLAY_NAME_TAKEN`); (3) los 401 no llevan `WWW-Authenticate: Bearer` (RFC 9110, RFC 6750); (4) los 429 no llevan `Retry-After` (RFC 6585); (5) no se exige que los errores del propio framework (JSON mal formado, cuerpo demasiado grande, ruta inexistente) pasen por el filtro (CWE-211); (6) no se prohíbe repetir en un 400 el valor que mandó el usuario; (7) no se dice que la app muestra solo sus propios textos traducidos, nunca el `detail` del servidor; (8) el 409 por correo registrado permite saber si un correo tiene cuenta (CWE-204; sigue en D-03). **A)** dejar D-39 como está. **B)** RFC 9457 y los 8 puntos: `application/problem+json`; `type` = URI absoluta `https://<dominio de la API>/problems/<code>`, documentada en Swagger; `code` en un solo estilo, `kebab-case` (`display-name-taken`), igual al final del `type`; `title` y `detail` fijos por tipo, en inglés, sin valores enviados ni datos internos; `instance` = `urn:uuid:<correlation id>`; `errors` = `[{ "pointer": "/displayName", "code": "too-short" }]` (JSON Pointer, RFC 6901), sin el valor; 401 con `WWW-Authenticate: Bearer` (y `error="invalid_token"` si el token vino vencido o alterado, sin descripción); 429 con `Retry-After` en segundos, que el aspecto de reintentos de la app respeta; el filtro atrapa **todo**, también los errores del framework; la app elige el mensaje por `code` en su idioma (ARB) y nunca muestra `detail`. **Recomendación: B.** Cambia el filtro global, la tabla de errores de ARQ-03-API, SEC-WEB-07, RF-91, TEC-05, el ADR y el texto de D-39 (parte del backend); en D-50 y RN-COM-109 el código pasa a `display-name-taken`. La parte de la app de D-39 (excepciones tipadas y `Result`) no cambia | Equipo | Paso 5 | D-03, D-39, D-46, D-50; RFC 9457, 9110, 6750, 6585, 6901; OWASP ASVS 7.4.1 / V16.5, WSTG-IDNT-04, A10:2025; CWE-204, 209, 211 |

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
| 5 | **Contratos:** `openapi.yaml`, JSON Schema de niveles y de progreso, ejemplos compartidos en JSON, modelo de datos local (Drift) y del servidor (Prisma) | Ambos | 🟡 **En curso (19-11):** cerradas D-27, D-44 a D-46, D-48, D-49 y D-50; abiertas D-19, D-47 y D-51; los contratos se escriben al cerrarlas | |
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
