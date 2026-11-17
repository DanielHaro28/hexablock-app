# PENDIENTES — HexaBlock Suite

> Lista única de pendientes del proyecto. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí.
>
> Reúne los que estaban en `ADR-001-tech-stack.md` §6, `SECURITY-BASELINE.md` §9 y `CONTEXTO-CONVERSACION.md` §7; esos documentos ahora apuntan aquí.
>
> **Última actualización:** 2026-11-17 (documentos de planificación en `main` por los PR #1; `AI_USAGE.md` en los PR #2) · **Entrega:** lunes 14-12-2026
>
> Completar la columna **Responsable** al repartir el trabajo. Al cerrar un ítem: cambiar ☐ por ☑ y anotar la fecha.

---

## 1. Decisiones del equipo

### 1.1 Abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-02 | **Repartir variantes y áreas** entre los 3 integrantes. Propuesta a discutir: motor + Hexa Merge · Hexa Lines + Hexa Sort · Hexa Fit + backend | Equipo | 12-11 | CONTEXTO §5 |
| ☐ D-03 | Respuesta de `POST /auth/register` cuando el correo ya existe. **Recomendación: A)** mantener **409** con rate limiting (5/min por IP), login genérico y en tiempo constante; aceptarlo como riesgo documentado. B) mensaje genérico + verificación por correo (lo ideal según OWASP, pero requiere enviar correos: fuera de alcance). C) 400 genérico (peor experiencia y no evita del todo la enumeración). SECURITY §3 y API-01 ya describen la opción A como propuesta | Equipo | Reunión | SECURITY §3, OWASP Authentication Cheat Sheet |
| ☐ D-19 | **Quién valida qué en los niveles.** Propuesta: el backend valida el esquema y las reglas estructurales; el dominio de la app valida además las geométricas (RN-HF-12 f) y ofrece un validador para usar antes de publicar | Equipo | Paso 5 (contratos) | RN-COM-76 |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos | Equipo | Al implementar cada topología | RN-TOP-21 a 23 |
| ☐ D-21 | **Paquetes de la app:** 4 paquetes Dart puros (`hexa_engine`, `hexa_topologies`, `hexa_variants`, `hexa_application`) + la app Flutter; variantes en un solo paquete con una carpeta por variante | Equipo | Reunión de revisión del Paso 2 | ARQ-01-APP §3, §9 |
| ☐ D-22 | **Estructura del backend:** módulos por área con `domain` / `application` / `presentation` / `infrastructure`; un servicio por caso de uso; progreso como JSON por `gameId` y mejores intentos en tabla para el ranking | Equipo | Reunión de revisión del Paso 2 | ARQ-01-API §9 |
| ☐ D-23 | **Contrato y ejemplos compartidos:** `openapi.yaml` y los ejemplos JSON (E-COM-2, E-COM-3, E-HF-NIVEL) viven en `hexablock-api` y se copian a la app para sus pruebas | Equipo | Paso 5 | ARQ-00 §6 |
| ☐ D-26 | **Figura global o por variante.** Recomendación: **una sola figura para todo el juego**, elegida en Ajustes | Equipo | Reunión | RN-TOP-32 |
| ☐ D-27 | **Progreso, récord y ranking separados por figura.** Recomendación: **sí**, porque los tableros no son comparables. **Cuidado con el enunciado §5.2**, que pide "una entrada de progreso por usuario y por variante". Dos formas de guardarlo: **A)** la topología forma parte de la clave (`userId` + `gameId` + `topology`): consultas simples, pero hay varias entradas por usuario y variante, lo que se aparta de la letra del enunciado; **B)** una entrada por `userId` + `gameId`, con una sección por figura dentro del JSON: cumple el enunciado al pie de la letra, a cambio de que la consolidación recorra las secciones. `BEST_ATTEMPT` lleva la columna `topology` en los dos casos, porque el ranking la filtra. Recomendación: **B**. Los documentos describen hoy A como borrador (ARQ-01-API §6) | Equipo | Reunión (afecta el Paso 5) | RN-TOP-33, RN-COM-80, 100; Enunciado §5.2 |
| ☐ D-28 | **Niveles por figura.** Recomendación: los 15 de Fit y 10 de Sort obligatorios en hexágonos; Fit con niveles de muestra para las otras figuras; los de Sort sin pilas iniciales sirven para cualquier figura (`topology: any`); "No disponible con esta figura" si no hay niveles | Equipo | Paso 6 | RN-TOP-34, RN-COM-75 |

### 1.2 Cerradas

| # | Decisión | Dónde quedó | Fecha |
|---|---|---|---|
| ☑ D-01 | Los repos están en la cuenta de **DanielHaro28**, que los creó y los administra | ADR-001 §2.4 | 11-11 |
| ☑ D-04 | Ranking por nivel de Hexa Sort: **movimientos ↑ → puntaje ↓** (menos pilas colocadas primero; el puntaje desempata) | RN-COM-103, RN-HS-71 | 11-11 |
| ☑ D-05 | Al iniciar sesión con progreso de invitado, la app **pregunta** "¿importar tu progreso?"; si acepta, se consolida | RN-COM-88 | 11-11 |
| ☑ D-06 | Al cerrar sesión, el dispositivo **vuelve al perfil invitado** con su propio progreso; el de la cuenta queda guardado localmente | RN-COM-89 | 11-11 |
| ☑ D-07 | **Coordenada como parámetro genérico (opción A).** `Board<TCoord extends Coord, TCell>`, `GridTopology<TCoord>`, `IGameRules<TCoord, TCell, TMove, TState>` y `GameEngine<TCoord, TCell, TMove, TState>`; `HexBoard<TCell>` es un `typedef` de `Board<HexCoord, TCell>` en `hexa_topologies`. Como la topología se elige por configuración, el *composition root* la despacha con una función genérica que conserva el tipo (detalle en el Paso 3) | ARQ-01-APP §4.1, §9, §10; TEC-01; glosario | 11-11 |
| ☑ D-08 | Catálogo de Hexa Lines: **8 familias, 24 piezas**, con los pesos propuestos | RN-HL-23 | 11-11 |
| ☑ D-09 | Puntaje de Hexa Lines: **celdas + ⌊5 × largo × L × racha⌋**, racha (k+1)/2 con máximo ×3 | RN-HL-60 a 64 | 11-11 |
| ☑ D-10 | Hexa Fit: colocar/mover/retirar cuentan como movimiento; rotar/deshacer/rehacer no. **Estrellas independientes:** ★ completar + ★ movimientos ≤ `m` + ★ tiempo ≤ `t` | RN-HF-61 a 64, E-HF-1 | 11-11 |
| ☑ D-11 | Pilas de Hexa Sort: altura 2–6, hasta 3 bloques, color distinto del bloque anterior | RN-HS-21 | 11-11 |
| ☑ D-12 | Puntaje de Hexa Sort: 1 por ficha transferida + 100 por meta (solo desempata el ranking; ver D-04) | RN-HS-60 | 11-11 |
| ☑ D-13 | Hexa Merge: **90 % de 2 / 10 % de 4**; celda al azar entre las vacías en orden de lectura | RN-HM-21 | 11-11 |
| ☑ D-14 | Generador aleatorio **xorshift32 propio** en el dominio | RN-COM-43 | 11-11 |
| ☑ D-15 | Desempate de la cascada de Hexa Sort: gana la pila **evaluada** (la colocada, en el primer paso) si está empatada; si no, la **primera vecina empatada en sentido horario desde las 12**. Los orígenes también transfieren en ese orden | RN-COM-17, RN-HEX-08, RN-HS-42, RN-HS-43, E-HS-8 | 11-11 |
| ☑ D-16 | Hexa Sort: al llegar a 10 o más se elimina **solo el bloque de cima, completo** (aunque sean 12); lo de abajo queda en la celda | RN-HS-50 | 11-11 |
| ☑ D-17 | Hexa Sort: "la pila con más fichas de ese color" = la de **bloque de cima más grande** | RN-HS-40, RN-HS-41 | 11-11 |
| ☑ D-18 | **Topologías:** solo rejillas regulares. Hexágonos (dominio + app, Must); cuadrados y triángulos (dominio + app 2D, Should); cubos (dominio con pruebas, Should; vista 3D, Could) | RN-COM-18, RN-TOP-01 a 04 | 11-11 |
| ☑ D-24 | La protección de `main` exige PR y CI en verde, pero **no** la aprobación de otra persona; autorrevisión con la plantilla de PR y revisión de un compañero recomendada | ADR-001 §2.4, SECURITY §7, SEC-AGT-05, 07 | 11-11 |
| ☑ D-25 | **El jugador elige la figura de las celdas en Ajustes** (solo las disponibles; hexágonos por defecto). La figura se fija al crear la partida y **no se puede cambiar durante ella**: la opción se bloquea mientras haya una partida en curso o en pausa | RN-COM-19, RN-COM-113, RN-TOP-30, 31; RF-09; NAV-08 | 11-11 |

## 2. Preguntas para el profesor

> **Indicación del profesor (11-11):** lo que el enunciado no especifica **lo decide el equipo**. Por eso ya no quedan preguntas abiertas: las que no resolvía el enunciado pasaron a decisiones del equipo (D-15 a D-17, sección 1.2).

### 2.1 Convertidas en decisiones o resueltas por el enunciado

| # | Pregunta | Resultado | Fecha |
|---|---|---|---|
| ☑ P-04 | Desempate de la cascada de Hexa Sort | → **D-15** (decisión del equipo) | 11-11 |
| ☑ P-11 | ¿Mermaid o notación UML de plantilla en el diagrama de clases? | **Resuelta por el enunciado §4.1** ("notación UML de plantilla") → diagrama de clases en **PlantUML** | 11-11 |
| ☑ P-12 | Hexa Sort: ¿se elimina la pila o el bloque de 10? | → **D-16** (decisión del equipo) | 11-11 |
| ☑ P-13 | Hexa Sort: ¿"cantidad de ese color" es el bloque de cima o el total? | → **D-17** (decisión del equipo) | 11-11 |

### 2.2 Respondidas por el profesor o por el enunciado

| # | Pregunta | Respuesta | Fuente | Fecha |
|---|---|---|---|---|
| ☑ P-01 | ¿Se aceptan repos públicos? | **Sí** | Profesor | 11-11 |
| ☑ P-02 | ¿Se pueden rotar las piezas en Hexa Lines? | **No**. La tabla 1.5 indica "Colocar pieza" para Lines y "Colocar / retirar / rotar" solo para Fit | Enunciado §1.5 | 11-11 |
| ☑ P-03 | ¿La bandeja de Hexa Sort ofrece 1 pila o varias? | **1**: "coloca en una celda vacía *la pila* que la bandeja le ofrece" | Enunciado §1.3 | 11-11 |
| ☑ P-05 | ¿La derrota en Hexa Sort es tablero lleno? | **Sí**: "el tablero se llena sin movimientos válidos". Como el único movimiento es colocar en una celda vacía, tablero lleno = sin movimientos. Se evalúa **después** de resolver la cascada y retirar las metas | Enunciado §1.3 | 11-11 |
| ☑ P-06 | ¿Se puede seguir jugando tras 2048? | **Sí**. §5.1 exige Hexa Merge "en modo partida sin fin con registro de puntaje máximo". La pantalla de victoria ofrece "Seguir jugando" además de "Nueva partida" | Enunciado §5.1 | 11-11 |
| ☑ P-07 | Orden del ranking por nivel de Hexa Fit | **Estrellas (desc) → tiempo (asc) → movimientos (asc)**, comparando el **mismo intento** completo (no la mejor estrella de un intento con el mejor tiempo de otro) | Profesor | 11-11 |
| ☑ P-08 | ¿Jugar sin cuenta y sincronizar después? | **Sí**. Modo invitado con progreso local; un usuario registrado sin conexión sigue jugando y sincroniza al reconectar. API-05 pasa de *Should* a **Must** | Profesor | 11-11 |
| ☑ P-09 | ¿Basta con endpoints de admin + Swagger para publicar niveles? | **Sí**: §5.2 pide un "endpoint para obtener y actualizar la definición de niveles"; no pide interfaz de administración | Enunciado §5.2 | 11-11 |
| ☑ P-10 | ¿Historias técnicas como HU o aparte? | El enunciado no exige HU: **decisión del equipo**. Se mantienen como historias habilitadoras (TEC) en el backlog | Enunciado (no lo regula) | 11-11 |

## 3. Documentos de diseño (hoja de ruta)

Objetivo: terminar los Pasos 1 a 8 en **una semana como máximo** (≈ 18-11-2026). La arquitectura se hace en **dos pasadas**, con el motor en medio: la general enmarca el motor y la detallada depende de sus interfaces.

| Paso | Documento | Repo | Estado | Responsable |
|---|---|---|---|---|
| 0 | `docs/adr/ADR-001-tech-stack.md` | Ambos (compartido) | ✅ Hecho (rev. 1.6) | — |
| 0b | `docs/security/SECURITY-BASELINE.md` | Ambos (compartido) | ✅ Hecho | — |
| 1 | **Requisitos** (`docs/requirements/`): glosario, reglas de negocio (comunes, topologías, 4 variantes, niveles, cuenta/progreso/ranking), RF + RNF, historias, trazabilidad | Ambos (ver `docs/README.md`) | 📝 **Borrador listo — revisión de cada integrante.** Abiertas: D-19, D-20 | |
| 2 | **Arquitectura general** (`docs/architecture/`): `ARQ-00-SISTEMA.md` (compartido), `ARQ-01-APP-GENERAL.md`, `ARQ-01-API-GENERAL.md` | Ambos | 📝 **Borrador listo — revisión del equipo** (D-21, D-22, D-23, más las propuestas 🟡 sin número de pendiente: ARQ-S-02 a 04, ARQ-A-05 a 08, ARQ-B-04) | |
| 3 | **Motor genérico:** tipos genéricos, interfaces de topología y reglas, ciclo de turno, estados, eventos, coordenada (D-07). **Lo decide el equipo**; las 6 preguntas de partida están en `ARQ-01-APP-GENERAL.md` §10 | App | ⏭️ **Siguiente** | |
| 4 | **Arquitectura detallada:** casos de uso genéricos, puertos y adaptadores, mapa de patrones, aspecto AOP, los 3 diagramas (clases en PlantUML; capas y extensibilidad en Mermaid) y `EXTENSIBILITY.md` | Ambos | ☐ Pendiente | |
| 5 | **Contratos:** `openapi.yaml`, JSON Schema de niveles, modelo de datos local y del servidor (cierra D-19) | Ambos | ☐ Pendiente | |
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
