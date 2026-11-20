# SECURITY-BASELINE — Línea base de seguridad de HexaBlock Suite

| Campo | Valor |
|---|---|
| Estado | **Aceptado** |
| Fecha | 2026-11-11 |
| Revisión | 20-11: keystore del APK (SEC-MOB-07, D-75), reporte privado de vulnerabilidades (D-74) y tareas pasadas a Issues (D-69) · 12-11: estrellas 1–3 (D-10), enumeración de correos marcada como pendiente de D-03, ruleset de `main` (G-02) y tabla de §6 reparada |
| Aplica a | `hexablock-app`, `hexablock-api`, infraestructura AWS y flujo de desarrollo con agentes de IA |
| Relacionado | [ADR-001 — Stack tecnológico](../adr/ADR-001-tech-stack.md) · Tareas de configuración: Issues de los dos repos (D-69) |
| Repositorio | **Compartido:** `docs/security/` en ambos repos; las dos copias deben ser idénticas |

---

## 1. Propósito y alcance

Este documento fija los **controles mínimos de seguridad** del proyecto y los conecta con las listas de OWASP vigentes. No es una auditoría: es la lista de lo que **debemos implementar y probar**.

| Marco | Versión | Aplica a |
|---|---|---|
| OWASP API Security Top 10 | 2023 (vigente) | Backend NestJS — **marco principal** |
| OWASP Top 10 | 2025 (final enero 2026) | Backend, CI/CD, infraestructura |
| OWASP MASVS | Versión vigente | App Flutter |
| OWASP Top 10 for Agentic Applications | 2026 (publicado 09-12-2025) | **Nuestro flujo de desarrollo** con Claude Code / Cline (el producto no contiene agentes) |

**Prioridad (MoSCoW):** **Must** = se implementa y se prueba antes de la entrega; **Should** = se implementa si el tiempo lo permite; **Won't** = descartado conscientemente (con motivo).

**Regla general:** cada control **Must** tiene una **verificación** (prueba automatizada, chequeo de CI o configuración revisable). Un control sin verificación no cuenta como implementado.

---

## 2. Modelo de amenazas resumido

| Activo | Amenaza principal | Atacante |
|---|---|---|
| Cuentas de usuario (correo, hash de contraseña) | Robo de credenciales, enumeración, fuerza bruta | Cualquiera en internet |
| Progreso y puntajes | Leer/modificar datos de otro usuario; inflar el ranking | Jugador malicioso |
| Definiciones de niveles | Publicar niveles maliciosos o rotos | Usuario sin rol de admin |
| Instancia EC2 / base de datos | Acceso remoto, fuga de secretos, caída en la defensa | Bots de internet |
| Repos públicos y CI | Secretos filtrados, dependencias maliciosas, workflows abusados desde forks | Cualquiera en GitHub |
| **Agentes de IA del equipo** | Instrucciones inyectadas en issues/PRs, comandos destructivos, uso de credenciales | Contenido no confiable que el agente lee |

**Superficie expuesta:** solo los puertos 80/443 (Caddy → API). Postgres no se expone. El SSH (22) solo acepta autenticación por clave.

---

## 3. Backend — OWASP API Security Top 10 (2023)

| ID | Riesgo | Control | Prioridad | Verificación |
|---|---|---|---|---|
| SEC-API-01 | **API1 BOLA** (acceso a objetos de otro usuario) | El `userId` se obtiene **siempre del JWT** (`req.user.sub`). Ningún endpoint de progreso o perfil recibe `userId` por ruta, query ni body. Rutas tipo `/v1/me/progress/:gameId` | Must | E2E: el usuario A no puede leer ni escribir el progreso de B (404/403) |
| SEC-API-02 | **API2 Autenticación rota** | JWT HS256 con secreto aleatorio ≥ 32 bytes; algoritmo fijado en la verificación (rechazar `none`); expiración ≤ 24 h (Must) o access 1 h + refresh 7 días rotativo y guardado con hash (Should). **Elegido: un solo token de 24 h (D-44, 19-11)**; el refresh queda para después y se agregaría como un endpoint nuevo, sin romper el contrato. **Contraseñas (D-52, NIST SP 800-63B rev. 4):** de **15 a 128** caracteres, porque la contraseña es el único factor; sin reglas de composición (mayúsculas, símbolos) ni cambio obligatorio; se aceptan espacios y Unicode; nunca se truncan; se rechazan las que están en una lista pública de contraseñas comunes, incluida en el backend (sin llamar a servicios externos, SEC-API-10). El error solo dice `too-short`, `too-long` o `too-common`. Contraseñas con **argon2id**, longitud 8–128 sin reglas de composición. Login responde 401 genérico | Must | E2E: token expirado → 401; token con firma alterada → 401; login incorrecto no distingue "correo inexistente" de "contraseña incorrecta"; registro con 14 caracteres → 400 `too-short`; con una contraseña común → 400 `too-common` |
| SEC-API-03 | **API3 Autorización a nivel de propiedad** (asignación masiva / exposición excesiva) | `ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true })`. El campo `role` **nunca** es aceptado desde el cliente. DTOs de respuesta explícitos: el ranking muestra `displayName`, **nunca el correo** ni IDs internos | Must | E2E: registro con `role: "admin"` → 400; respuesta del leaderboard no contiene `email` |
| SEC-API-04 | **API4 Consumo de recursos sin límite** | `@nestjs/throttler`: límite global + límite estricto en `/v1/auth/login` y `/v1/auth/register` (ej. 5/min por IP). Tamaño máximo de body (ej. 100 KB). Paginación obligatoria en leaderboard (`limit` máx. 100) | Must | E2E: sexto intento de login en un minuto → 429; `limit=1000` → 400 o recortado a 100 |
| SEC-API-05 | **API5 Autorización a nivel de función** | `RolesGuard` con **denegación por defecto**; endpoints de administración de niveles (LVL-02) requieren `role = admin`. El admin inicial se crea por *seed*/script, no por la API | Must | E2E: usuario normal → `POST /v1/levels` → 403; sin token → 401 |
| SEC-API-06 | **API6 Acceso irrestricto a flujos de negocio** (trampas en el ranking) | Validación de plausibilidad del lado del servidor: estrellas 1–3 (completar un nivel de Hexa Fit siempre da al menos 1★, RN-HF-62), nivel existente para el `gameId`, puntaje ≥ 0 y bajo un tope por variante, `gameId` en lista cerrada. Se acepta que no es antitrampa completo | Must | Unit/E2E: puntaje negativo, estrellas = 0 o 4, o `gameId` desconocido → 400 |
| SEC-API-07 | **API7 SSRF** | La API no hace peticiones salientes con URLs del usuario. Si se agrega alguna, lista blanca de destinos | Must (por diseño) | Revisión en PR |
| SEC-API-08 | **API8 Mala configuración de seguridad** | `helmet`; CORS deshabilitado o restringido (la app móvil no lo necesita); mensajes de error sin stack trace en producción; `title` y `detail` fijos por tipo de error, sin los valores enviados ni datos internos (CWE-209); `instance` = `urn:uuid:<correlation id>` (ASVS 7.4.1); 401 con `WWW-Authenticate: Bearer` (RFC 6750) y 429 con `Retry-After` (RFC 6585); la app muestra sus propios textos por `code` y nunca `detail`; `NODE_ENV=production`; Swagger público **solo de lectura de la documentación** (no expone secretos) | Must | E2E: forzar un 500 → la respuesta no contiene `stack`; un 400 no repite el valor enviado; un 401 trae `WWW-Authenticate`; cabeceras de helmet presentes |
| SEC-API-09 | **API9 Inventario deficiente** | `openapi.yaml` es la fuente única; versión de API en la ruta (`/api/v1`); no hay endpoints "ocultos" fuera del contrato | Must | CI: las respuestas se validan contra `openapi.yaml` |
| SEC-API-10 | **API10 Consumo inseguro de APIs** | No consumimos APIs de terceros. Las definiciones de nivel subidas por admin se validan con **JSON Schema** antes de guardarse (incluida la regla área de piezas = área de figura en Hexa Fit) | Must | Unit: nivel inválido → 400 con detalle |

**Enumeración de correos (pendiente de D-03):** la propuesta es que `POST /v1/auth/register` responda **409** si el correo ya existe (historia API-01). Esto permite enumerar correos; la recomendación es aceptarlo por usabilidad, mitigado con el rate limiting de SEC-API-04 y un login genérico y en tiempo constante. Las alternativas y su estado están en `PENDIENTES.md` (D-03).

---

## 4. Backend, CI/CD e infraestructura — OWASP Top 10:2025 (complemento)

Solo se listan los puntos no cubiertos ya en la sección 3.

| ID | Categoría 2025 | Control | Prioridad | Verificación |
|---|---|---|---|---|
| SEC-WEB-01 | **A02 Security Misconfiguration** | EC2: solo clave SSH, `PasswordAuthentication no`, `PermitRootLogin no`, `unattended-upgrades` activo, **IMDSv2 obligatorio**, sin rol IAM con permisos amplios. Security Group: 80/443 abiertos, 22 abierto solo con clave, 5432 cerrado | Must | Checklist de despliegue en `docs/ops/DEPLOY.md` |
| SEC-WEB-02 | **A03 Software Supply Chain Failures** | Dependabot (pub, npm, GitHub Actions, Docker) activo; `npm ci` con *lockfile*; `npm audit --audit-level=high` en CI; `pubspec.lock` versionado; imagen base Docker con etiqueta fija | Must | CI falla con vulnerabilidades *high/critical* |
| SEC-WEB-03 | **A03 — seguridad del pipeline** | Cada workflow declara `permissions:` mínimos (`contents: read` por defecto). **Prohibido `pull_request_target`** con checkout del código del PR (repos públicos + forks). Las acciones de terceros se fijan por versión mayor o SHA. El job de deploy corre solo en `push` a `main` y usa un **GitHub Environment `production`** con sus propios secretos | Must | Revisión de `.github/workflows/` por CODEOWNERS |
| SEC-WEB-04 | **A04 Cryptographic Failures** | TLS en todo el tráfico (Caddy + Let's Encrypt). Contraseñas con argon2id. Ningún secreto en el repo ni en la imagen Docker | Must | *Secret scanning* + *push protection* de GitHub activos (gratis en repos públicos) |
| SEC-WEB-05 | **A05 Injection** | Solo consultas parametrizadas de Prisma; **prohibido `$queryRawUnsafe`**. Validación de entrada en todos los DTOs | Must | CI: `grep` que falla si aparece `queryRawUnsafe` |
| SEC-WEB-06 | **A09 Logging & Alerting Failures** | Registrar logins fallidos, 401/403/429 y errores 5xx con un *correlation id*. **Nunca** registrar contraseñas, tokens JWT ni el cuerpo de `/v1/auth/*`: el aspecto de logging aplica **redacción** de campos sensibles | Must | Unit: el decorador de logging redacta `password` y `token` |
| SEC-WEB-07 | **A10 Mishandling of Exceptional Conditions** | Filtro global de excepciones que responde siempre Problem Details (RFC 9457, D-51) y atrapa **todos** los errores, también los que genera el propio framework (JSON mal formado, cuerpo demasiado grande, ruta inexistente; CWE-211); **falla cerrada** (ante error de autorización se deniega, nunca se permite); en el cliente, los errores de red no corrompen el progreso local | Must | E2E: excepción inesperada → 500 `internal-error` sin detalles internos; JSON mal formado → 400 sin el texto del *parser* |
| SEC-WEB-08 | Respaldo y disponibilidad | `pg_dump` diario; `restart: unless-stopped`; *healthcheck*; prueba de humo el día anterior a la defensa | Should | Script de respaldo y restauración probado una vez |

---

## 5. App móvil — OWASP MASVS (lo esencial)

| ID | Área MASVS | Control | Prioridad | Verificación |
|---|---|---|---|---|
| SEC-MOB-01 | STORAGE | El JWT (y el refresh token, si existe) se guardan en **`flutter_secure_storage`** (Keystore/Keychain), **nunca** en `shared_preferences` ni en Drift | Must | Unit: el `TokenRepository` usa el adaptador de almacenamiento seguro |
| SEC-MOB-02 | STORAGE | Ningún secreto embebido en el APK. Solo se inyecta `API_BASE_URL` (no es secreto) vía `--dart-define` | Must | Revisión: no hay claves en el código ni en `--dart-define` |
| SEC-MOB-03 | NETWORK | Solo HTTPS; tráfico en claro deshabilitado (comportamiento por defecto de Android, no se relaja con `usesCleartextTraffic`) | Must | Revisión de `AndroidManifest.xml` |
| SEC-MOB-04 | AUTH | Al recibir 401, la app borra el token y pide iniciar sesión; el cierre de sesión borra el token del almacenamiento seguro | Must | Widget/Unit: 401 → navegación a login y token eliminado |
| SEC-MOB-05 | CODE | Build de release con `--obfuscate --split-debug-info`; sin logs de depuración con datos de usuario en release | Should | Workflow de release usa los flags |
| SEC-MOB-06 | RESILIENCE | Validar en el cliente los niveles descargados (mismo JSON Schema que el backend) antes de usarlos | Should | Unit: nivel inválido descargado → se ignora y se conserva el nivel local |
| SEC-MOB-07 | CODE | **Keystore de firma del APK** (D-75): nunca está en el repo (`*.jks`, `*.keystore` y `key.properties` en `.gitignore`). Va en base64 en un secreto del environment `release` de `hexablock-app`, restringido a tags `v*`; el workflow de release genera `key.properties` en el runner y lo borra al terminar. El dueño guarda una copia fuera de línea: sin ella no se puede publicar una actualización con la misma firma | Must | Revisión del workflow de release por CODEOWNERS; *secret scanning* sin alertas |
| — | NETWORK | *Certificate pinning* | **Won't** | Caddy rota certificados automáticamente; fijarlos rompería la app sin aportar valor en este alcance |

---

## 6. Flujo de desarrollo con agentes — OWASP Top 10 for Agentic Applications (2026)

El producto no incluye agentes, pero **el equipo desarrolla con agentes** (Claude Code como herramienta principal; Cline permitido). Aplicamos los principios de la lista: **mínima agencia** (el agente solo tiene el poder que necesita) y **observabilidad fuerte** (todo uso queda registrado).

| ID | Riesgo | Cómo nos afecta | Control | Prioridad |
|---|---|---|---|---|
| SEC-AGT-01 | **ASI01 Secuestro del objetivo** | Los repos son públicos: un tercero puede escribir instrucciones ocultas en un issue, comentario o PR que el agente luego lea | El contenido creado por personas **ajenas al equipo** es no confiable: no se pide a un agente "resolver el issue #N" si lo abrió un externo. Los issues de trabajo los crea el equipo. Interacciones de externos limitadas (*interaction limits*) si aparece spam | Must |
| SEC-AGT-02 | **ASI02 Mal uso de herramientas** / **ASI05 Ejecución de código inesperada** | El agente ejecuta comandos destructivos (`rm -rf`, `git push --force`, `prisma migrate reset`, `docker system prune`) | Reglas `deny`/`ask` en `.claude/settings.json` (ver 6.1). **Nunca** usar el modo que omite confirmaciones. Rama `main` protegida: el agente no puede escribir en ella | Must |
| SEC-AGT-03 | **ASI03 Abuso de identidad y privilegios** | El agente usa la clave SSH de producción, credenciales de AWS o el `.env` | **El despliegue solo lo hace el CI.** Ninguna máquina de desarrollo guarda la clave SSH de EC2 ni credenciales de AWS con permisos de escritura. El agente tiene denegada la lectura de `.env*` y de `~/.ssh`, `~/.aws` | Must |
| SEC-AGT-04 | **ASI04 Cadena de suministro agéntica** | El agente sugiere un paquete inexistente que alguien registró con código malicioso (*slopsquatting*), o se instala un servidor MCP no revisado | Toda dependencia nueva se verifica en pub.dev / npmjs.com (autor, descargas, repositorio) antes de agregarla, y el PR lo menciona. Solo servidores MCP aprobados y listados en `docs/ai/APPROVED-TOOLS.md` | Must |
| SEC-AGT-05 | **ASI06 Envenenamiento de memoria y contexto** | Un PR altera `CLAUDE.md`, `.clinerules` o `.claude/` para cambiar el comportamiento de los agentes de todo el equipo | La plantilla de PR tiene una casilla "cambia la configuración de agentes o de CI" que obliga a avisar al equipo; `CODEOWNERS` pide revisión automáticamente (ver 6.2). Solo los 3 colaboradores pueden integrar a `main`, así que un PR de alguien externo nunca entra sin que un integrante lo lea | Must |
| SEC-AGT-06 | **ASI08 Fallos en cascada** | Varias sesiones paralelas construyen sobre una abstracción equivocada | Interfaces del motor congeladas (tag `engine-v0.1`) antes de paralelizar variantes; CI con verificación de arquitectura | Must |
| SEC-AGT-07 | **ASI09 Explotación de la confianza humana** | Se aprueba un PR del agente sin leerlo porque "se ve bien" | **Autorrevisión obligatoria** con la checklist de la plantilla de PR; el autor humano responde por todo el código (§7.1 del enunciado); la revisión de un compañero es recomendada; subagente `architecture-reviewer` y CI como apoyo, no como reemplazo | Must |
| SEC-AGT-08 | **ASI10 Agentes descontrolados** / observabilidad | No se sabe qué hizo el agente ni con qué prompt | `AI_USAGE.md` actualizado por PR; commits pequeños y frecuentes; las sesiones largas se resumen en el PR | Must |
| SEC-AGT-09 | Información sensible en prompts (§7.3 del enunciado) | Pegar `.env`, tokens o datos de usuarios en un chat con IA | Prohibido. Solo datos de prueba ficticios en prompts y fixtures | Must |
| — | ASI07 Comunicación insegura entre agentes | No aplica: no hay agentes comunicándose entre sí fuera de la herramienta | — | Won't |

### 6.1 Permisos base para Claude Code (`.claude/settings.json`)

> Verificar la sintaxis exacta con la documentación de Claude Code de la versión que use el equipo. **Importante:** las reglas sobre comandos son coincidencias de prefijo y pueden eludirse; el control real es que **los secretos de producción no existan en las máquinas de desarrollo** (SEC-AGT-03).

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Bash(rm -rf:*)",
      "Bash(git push --force:*)",
      "Bash(git push -f:*)",
      "Bash(git reset --hard:*)",
      "Bash(npx prisma migrate reset:*)",
      "Bash(docker system prune:*)",
      "Bash(ssh:*)",
      "Bash(aws:*)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(npm install:*)",
      "Bash(flutter pub add:*)",
      "Bash(dart pub add:*)"
    ]
  }
}
```

El equivalente para Cline va en `.clinerules`, que solo apunta a este documento y a los demás de `docs/`.

### 6.2 `CODEOWNERS`

```
# Configuración de agentes y CI: GitHub pide revisión automáticamente (no bloquea el merge)
/CLAUDE.md              @integrante1 @integrante2 @integrante3
/.clinerules            @integrante1 @integrante2 @integrante3
/.claude/               @integrante1 @integrante2 @integrante3
/.github/workflows/     @integrante1 @integrante2 @integrante3
/docs/security/         @integrante1 @integrante2 @integrante3
/docs/adr/              @integrante1 @integrante2 @integrante3
```

Reemplazar `@integrante1..3` por los usuarios reales de GitHub. Los repos están en una cuenta personal, que no tiene *teams*, así que se listan los 3 usuarios. Como la protección de `main` **no** exige aprobaciones (decisión del equipo, 11-11), `CODEOWNERS` solo sirve para que GitHub pida revisión y avise; no bloquea el merge.

---

## 7. Configuración de GitHub (ambos repos)

| Ajuste | Valor |
|---|---|
| Protección de `main` | Ruleset `protect-main`: PR obligatorio, solo *squash*, historial lineal, sin *force push*, sin borrado y sin bypass. **Sin aprobaciones obligatorias** (decisión del equipo, 11-11). CI en verde y rama actualizada cuando exista el primer workflow (G-10) |
| Plantilla de PR | `.github/pull_request_template.md` con la checklist de autorrevisión: pruebas, arquitectura, seguridad, `AI_USAGE.md`, y la casilla "cambia configuración de agentes o de CI" |
| Secret scanning + push protection | Activado |
| Dependabot alerts + security updates + version updates | Activado (`.github/dependabot.yml`) |
| Workflows desde forks | Requieren aprobación para colaboradores externos |
| Environment `production` (solo `hexablock-api`) | Secretos de deploy (`EC2_HOST`, `EC2_SSH_KEY`); restringido a la rama `main`. Disponible en repos públicos y, gracias al Pro del dueño, también en privados |
| Environment `release` (solo `hexablock-app`) | Keystore del APK en base64 y sus contraseñas (SEC-MOB-07); restringido a tags `v*` |
| Colaboradores | Los 2 integrantes que no son dueños entran con permiso de **escritura** (no admin). Solo el dueño cambia la configuración |
| `SECURITY.md` en la raíz | Cómo reportar una vulnerabilidad: *Private vulnerability reporting* de GitHub activado, sin publicar correos (D-74) |

---

## 8. Pruebas de seguridad (resumen para la suite)

Nombradas con la convención del enunciado. Todas son **Must**:

- `should_return_404_when_user_reads_another_users_progress`
- `should_return_401_when_token_is_expired`
- `should_return_401_when_token_signature_is_tampered`
- `should_return_same_401_when_email_does_not_exist_or_password_is_wrong`
- `should_return_400_when_register_payload_contains_role`
- `should_not_expose_email_when_listing_leaderboard`
- `should_return_429_when_login_attempts_exceed_limit`
- `should_return_403_when_non_admin_publishes_level`
- `should_return_400_when_score_is_not_plausible`
- `should_return_400_when_level_piece_area_differs_from_figure_area`
- `should_not_include_stack_when_internal_error_occurs`
- `should_redact_password_and_token_when_logging_use_case`
- `should_clear_token_and_navigate_to_login_when_api_returns_401` (app)

---

## 9. Checklist antes de la defensa

Es la lista de verificación de la tarea T-07 (ítems F-01 a F-10). La configuración inicial de GitHub, agentes y AWS que exige este documento está en los Issues G-*, A-* y W-* (D-69).
