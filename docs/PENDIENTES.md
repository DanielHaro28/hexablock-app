# PENDIENTES — HexaBlock Suite

> Lista única de pendientes del proyecto. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí. Las decisiones **cerradas** no están aquí: están en `docs/DECISIONES.md` de cada repo.
>
> Reúne los que estaban en `ADR-001-tech-stack.md` §6, `SECURITY-BASELINE.md` §9 y `CONTEXTO-CONVERSACION.md` §7; esos documentos ahora apuntan aquí.
>
> **Última actualización:** 2026-11-19 (Paso 4 fusionado: PR app #6 y api #4; Paso 5 hecho; Paso 6 en curso con D-53 a D-60; planificación en `main` por los PR #1; `AI_USAGE.md` en los PR #2; Paso 3 decidido; decisiones cerradas en `DECISIONES.md`; D-21 a D-23 y D-37 a D-43 cerradas; D-36 revisada; Paso 4 listo) · **Entrega:** lunes 14-12-2026
>
> Completar la columna **Responsable** al repartir el trabajo. Al cerrar un ítem: cambiar ☐ por ☑ y anotar la fecha.

---

## 1. Decisiones del equipo

### 1.1 Abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-02 | **Repartir variantes y áreas** entre los 3 integrantes. Propuesta a discutir: motor + Hexa Merge · Hexa Lines + Hexa Sort · Hexa Fit + backend | Equipo | 12-11 | CONTEXTO §5 |
| ☐ D-03 | Respuesta de `POST /auth/register` cuando el correo ya existe. **Recomendación: A)** mantener **409** con rate limiting (5/min por IP), login genérico y en tiempo constante; aceptarlo como riesgo documentado. B) mensaje genérico + verificación por correo (lo ideal según OWASP, pero requiere enviar correos: fuera de alcance). C) 400 genérico (peor experiencia y no evita del todo la enumeración). SECURITY §3 y API-01 ya describen la opción A como propuesta | Equipo | Reunión | SECURITY §3, OWASP Authentication Cheat Sheet |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos | Equipo | Al implementar cada topología | RN-TOP-21 a 23 |
| ☐ D-26 | **Figura global o por variante.** Recomendación: **una sola figura para todo el juego**, elegida en Ajustes | Equipo | Reunión | RN-TOP-32 |
| ☐ D-28 | **Niveles por figura.** **Recomendación (precisada en el Paso 6):** los 15 de Fit y los 10 de Sort obligatorios se hacen en **hexágonos**. De los 10 de Sort, los **6 primeros sin pilas iniciales** con `topology: any`, así que sirven para todas las figuras; los **4 últimos en hexágonos**, con pilas iniciales como obstáculos. Fit tiene niveles de muestra (3 por figura) cuando cada figura esté implementada (TEC-07 a TEC-09). Si una variante no tiene niveles para la figura elegida, su tarjeta dice "No disponible con esta figura" | Equipo | Paso 6 | RN-TOP-34, RN-COM-75 |
| ☐ D-36 | **Cómo se protege el Template Method** de las reglas (`GameRules.playTurn`, ARQ-02 §9.6), ya que Dart no tiene métodos `final`. **Recomendación (revisada el 17-11): B)** sin dependencias: una regla en la plantilla de PR más una prueba de arquitectura en CI que falle si una clase de `hexa_variants` declara `playTurn`. Motivo: el enunciado §3.4 pide que la capa 1 no tenga **ninguna** dependencia externa, y A) `@nonVirtual` de `package:meta` lo sería, aunque sea del equipo de Dart | Equipo | Antes de TEC-01 | ARQ-02 §9.6, D-35; Enunciado §3.4 |
| ☐ D-53 | **Cómo se diseñan los niveles.** El enunciado pide niveles **"diseñados manualmente"** (§1.2, §5.1). **A)** el equipo diseña los 25 a mano (en papel o en el editor) y `levelkit.py` + el validador comprueban que cada uno tenga solución y que la dificultad suba. **B)** Claude propone un **borrador de cada nivel**, diseñado uno por uno siguiendo la curva de D-54 y D-55 (no sale de un generador al azar), y el equipo los **juega, ajusta y aprueba**; en `AI_USAGE.md` queda qué cambió cada integrante. **C)** un generador automático y el equipo elige los mejores: es lo más rápido, pero contradice "diseñados manualmente". **Recomendación: B** por el plazo, con la condición de que cada integrante juegue todos los niveles y modifique los que no le convenzan antes de aprobarlos. C queda descartada | Equipo | Paso 6 | Enunciado §1.2, §5.1; IA-* |
| ☐ D-54 | **Curva de dificultad y umbrales de Hexa Fit.** Propuesta: niveles **1–3** de 2 a 3 piezas y 6 a 10 celdas (aprender a colocar, rotar y retirar); **4–7** de 3 a 4 piezas y 10 a 16 celdas; **8–11** de 4 a 5 piezas y 16 a 24 celdas; **12–15** de 5 a 7 piezas y 24 a 36 celdas, con **4 soluciones o menos**. `levelkit.py` mide cada nivel (soluciones y esfuerzo de búsqueda) y el esfuerzo debe crecer de un tramo al siguiente. Umbrales: `m` = piezas + 1 (permite un error, RN-HF-63) y `t` = **20 s por pieza**; se ajustan después de que el equipo los juegue. **Alternativa** más exigente: `m` = piezas (cero errores) | Equipo | Paso 6 | RN-HF-12, RN-HF-62, 63 |
| ☐ D-55 | **Curva de dificultad de Hexa Sort**, medida con `levelkit.py` en el tablero de radio 2 (20 semillas por combinación; movimientos medianos del jugador voraz): 1 meta y 3 colores → 7; 3 metas y 4 colores → 14; 5 metas y 5 colores → 23; 8 metas y 6 colores → 33,5; 12 metas y 6 colores → 46, y ahí el jugador voraz ya pierde en 7 de 20 semillas. Propuesta: **1–2:** 1 a 2 metas, 3 colores; **3–4:** 3 metas, 3 a 4 colores; **5–6:** 5 metas, 4 a 5 colores; **7–8:** 8 metas, 5 colores y 2 o 3 pilas iniciales; **9–10:** 10 a 12 metas, 6 colores y pilas iniciales. **Regla de aceptación:** cada semilla elegida debe poder ganarla el **jugador voraz**, para asegurar que una estrategia simple alcanza; la dificultad se mide por sus movimientos | Equipo | Paso 6 | RN-HS-11, 12, 21; D-28 |
| ☐ D-56 | **Dobles de prueba** (el enunciado pide *mocks* o *stubs* y pruebas no frágiles). **A)** *fakes* escritos a mano: repositorios en memoria, reloj falso, el xorshift real con semilla fija, gateway falso que responde con los ejemplos del contrato. **B)** librerías de *mocks* (`mocktail` en Dart, `jest.fn()` en NestJS) para todo. **C)** *fakes* por defecto y *mocks* solo para verificar una llamada que no tiene otro efecto visible (por ejemplo, que el aspecto de logging redacte la contraseña). **Recomendación: C.** Los *fakes* prueban comportamiento y no se rompen al refactorizar; las librerías de *mocks* van solo como dependencias de desarrollo, así que no rompen la regla de la capa 1 (D-21) | Equipo | Paso 6 | Enunciado §3.6; D-21 |
| ☐ D-57 | **Base de datos de las pruebas de integración** (el enunciado pide "base de datos en memoria"). En la app, Drift tiene `NativeDatabase.memory()`, así que no hay nada que decidir. En la API: **A)** PostgreSQL real en un contenedor de GitHub Actions con los datos en **`tmpfs`** (memoria RAM): es en memoria y es el mismo motor que producción (`citext`, `jsonb`, `FOR UPDATE`). **B)** `pg-mem`, un emulador de PostgreSQL en memoria: Prisma no lo soporta de forma oficial. **C)** SQLite en memoria con Prisma: no tiene `citext` ni `FOR UPDATE`, así que se probaría otra cosa distinta a producción. **Recomendación: A** | Equipo | Paso 6 | Enunciado §3.6; ARQ-04-API |
| ☐ D-58 | **Cobertura mínima.** **A)** umbrales que **hacen fallar el CI**: dominio ≥ 90 %, casos de uso ≥ 80 %, total ≥ 70 %, en los dos repos. **B)** solo se informa (badge en el README) sin bloquear. **C)** un único umbral total. **Recomendación: A**: el dominio es lógica pura y fácil de cubrir, y el umbral hace cumplir que "todo código generado por IA debe estar cubierto por pruebas" (enunciado §7.3). La interfaz (widgets) queda fuera del cálculo por capa, pero cuenta en el total | Equipo | Paso 6 | Enunciado §3.6, §7.3 |
| ☐ D-59 | **Quién escribe las pruebas del código generado por IA** (el enunciado §7.3 dice "preferiblemente el equipo"). **A)** la IA implementa y un integrante escribe después las pruebas. **B)** **primero las pruebas:** un integrante escribe las pruebas desde los ejemplos `E-*` ya verificados y la IA implementa hasta que pasen; el integrante revisa el código. **C)** la IA escribe código y pruebas y el equipo revisa. **Recomendación: B**: los ejemplos ya existen y están verificados, el historial de commits muestra qué escribió cada uno (*test* antes que *feat*) y deja evidencia clara para la defensa. Se agrega una casilla a la plantilla de PR | Equipo | Paso 6 | Enunciado §7.3; plantilla de PR |
| ☐ D-60 | **Precisión de RN-HS-21** (encontrada al programar el jugador automático). La regla dice que el color de cada bloque es "distinto del bloque anterior", pero no dice **cómo**, y las dos formas dan pilas distintas con la misma semilla. **A)** el color se elige **entre los colores de la paleta menos el anterior**: `siguiente() mod (tamaño − 1)` sobre esa lista, siempre un número por bloque. **B)** se sortea `siguiente() mod tamaño` y, si sale el anterior, **se vuelve a sortear**: la cantidad de números por pila varía. También se fija el orden: altura, número de bloques, reparto, colores, y los bloques de abajo hacia arriba. **Recomendación: A**: siempre consume la misma cantidad de números, no tiene bucle y es más fácil de probar. Si se elige, se agrega el ejemplo E-HS-GEN calculado con el simulador. No reabre D-11: solo la precisa | Equipo | Paso 6 | RN-HS-21, D-11, RN-COM-41 |

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
| 5 | **Contratos:** `openapi.yaml`, JSON Schema de niveles, progreso, ranking y errores, ejemplos compartidos en JSON, modelo de datos local (Drift) y del servidor (Prisma) | Ambos | ✅ **Hecho (19-11):** `hexablock-api/docs/contracts/` (copia idéntica en la app), `ARQ-04-API-DATOS.md`, `ARQ-04-APP-DATOS.md`. Cerradas D-27, D-44 a D-51 (D-39 ajustada). D-19 y D-52 cerradas después (19-11) | |
| 6 | **Contenido y pruebas:** 15 niveles de Hexa Fit y 10 de Hexa Sort; estrategia de pruebas | App (+ API para pruebas) | 🟡 **En curso (19-11):** `tools/reference-sim/levelkit.py` listo; propuestas D-28, D-36 y D-53 a D-60 | |
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
