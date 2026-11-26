# AI_USAGE — hexablock-app

> Registro del uso de herramientas de IA en el repositorio de la app, como exige el enunciado §7.2. Se actualiza **en cada PR que use IA** (RNF-62, SEC-AGT-08, plantilla de PR).
>
> Las tareas de planificación que producen documentos compartidos aparecen **con el mismo ID** en el `AI_USAGE.md` de `hexablock-api`.
>
> **Última actualización:** 2026-11-21 (IA-43)

Los campos marcados con ⚠️ los tiene que completar el equipo: la IA no conoce esos datos y no se inventaron.

---

## 1. Herramientas utilizadas

| Herramienta | Versión o modelo | Rol en el flujo de trabajo | Quién la usa |
|---|---|---|---|
| **Claude** (claude.ai, conversación con herramientas de agente: archivos, terminal, git) | **Claude Opus 5.5** (`claude-opus-5-5`) desde el 12-11-2026. Conversaciones anteriores: ⚠️ completar el modelo | Planificación: propone opciones con ventajas y desventajas, redacta los documentos de `docs/`, verifica los ejemplos de reglas con código, revisa la coherencia entre documentos y sube los cambios por rama y PR | DanielHaro28 |
| **Claude Code** | Extensión de VS Code con **Claude Opus 5.5** (`claude-opus-5-5`) desde el 21-11-2026 (IA-43). ⚠️ completar la versión de la extensión | Herramienta principal de implementación (ADR-001 §2.6), con los permisos de `.claude/settings.json` | Todo el equipo |
| **Antigravity** (Google) | Gemini 4 Neon (High), usada en app #142 y #147. ⚠️ completar la versión | Segunda herramienta de agente, con las condiciones de `docs/ai/APPROVED-TOOLS.md` (D-159) | DanielHaro28 |

## 2. Cómo aplicamos las buenas prácticas (§7.3)

| Práctica del enunciado | Cómo la aplicamos |
|---|---|
| Prompts claros, con contexto y restricciones | Cada conversación empieza con `docs/ai/PROMPT-NUEVA-CONVERSACION.md`, que adjunta el contexto (`docs/ai/CONTEXTO-CONVERSACION.md`, `docs/PENDIENTES.md`, el enunciado) y fija las reglas de trabajo |
| Revisión crítica del resultado | Todo entra por PR con la checklist de autorrevisión (`.github/pull_request_template.md`); la revisión de un compañero es recomendada (D-24) |
| Pruebas del resultado | Los ejemplos de reglas (`E-*`) se verifican con el simulador `tools/reference-sim/` antes de escribirlos y se convierten en pruebas; los diagramas Mermaid se renderizan antes de entregarlos |
| Commits granulares | Conventional Commits en inglés, commits chicos; los commits hechos con ayuda de Claude llevan el trailer `Co-Authored-By: Claude …` |
| La IA no decide el diseño | La IA propone y recomienda; el equipo decide. Las decisiones abiertas quedan en `hexablock-app/docs/PENDIENTES.md` §1.1 y las cerradas, con ID y fecha, en `docs/DECISIONES.md` de cada repo |
| Sin información sensible en los prompts | No se pegan credenciales, tokens, claves ni datos de usuarios (SEC-AGT-02, SEC-AGT-03). Ninguna máquina de desarrollo guarda credenciales de producción |
| Citar las fuentes | Sección 5 de este archivo |

## 3. Registro de uso por tarea

### IA-01 · Stack tecnológico (ADR-001) — compartido

| Campo | Contenido |
|---|---|
| Fecha | Hasta el 11-11-2026 |
| Herramienta | Claude (claude.ai). ⚠️ modelo |
| Prompt | _Paráfrasis reconstruida a partir del documento resultante; ⚠️ reemplazar por la transcripción:_ "Proponer el stack de la app y del backend que cumpla el enunciado, con ventajas, desventajas y alternativas descartadas" |
| Resultado | `docs/adr/ADR-001-tech-stack.md`, revisiones 1.0 a 1.6 |
| Modificaciones del equipo | Repos en la cuenta personal de DanielHaro28 en lugar de una organización (rev. 1.3, D-01); repos públicos confirmados con el profesor (P-01); sin aprobación obligatoria en los PR (rev. 1.6, D-24) |
| Lecciones | La IA propuso Mermaid para todos los diagramas (rev. 1.2), pero Mermaid no dibuja la "notación UML de plantilla" que exige §4.1; se volvió a PlantUML para el diagrama de clases (rev. 1.4). Hay que contrastar cada propuesta con la letra del enunciado |

### IA-02 · Línea base de seguridad (SECURITY-BASELINE) — compartido

| Campo | Contenido |
|---|---|
| Fecha | Hasta el 11-11-2026 |
| Herramienta | Claude (claude.ai). ⚠️ modelo |
| Prompt | _Paráfrasis reconstruida; ⚠️ reemplazar por la transcripción:_ "Definir los controles de seguridad del proyecto alineados con OWASP, con prioridad y forma de verificarlos" |
| Resultado | `docs/security/SECURITY-BASELINE.md`: controles SEC-API, SEC-WEB, SEC-MOB y SEC-AGT, y 13 pruebas de seguridad con nombre |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | La sección de agentes (SEC-AGT) obliga a tratar a la propia IA como un riesgo: permisos acotados y sin credenciales de producción en las máquinas de desarrollo |

### IA-03 · Requisitos: glosario, reglas de negocio, RF/RNF, historias y trazabilidad — compartido en parte

| Campo | Contenido |
|---|---|
| Fecha | Hasta el 11-11-2026 |
| Herramienta | Claude (claude.ai). ⚠️ modelo |
| Prompt | _Paráfrasis reconstruida; ⚠️ reemplazar por la transcripción:_ "A partir del enunciado y de nuestras historias v1, escribir las reglas de negocio de las 4 variantes y las topologías, los requisitos y las historias con criterios de aceptación, y la trazabilidad" |
| Resultado | `docs/requirements/` completo. Las historias v1 del equipo (28-10-2026) pasaron a `04-HISTORIAS.md` (50 historias en la app) |
| Modificaciones del equipo | Lo que el enunciado no fijaba lo decidió el equipo: D-04, D-08 a D-18 y D-25. Las preguntas al profesor (P-01 a P-13) se resolvieron antes de cerrar las reglas |
| Lecciones | Convertir cada regla ambigua en una decisión con ID evita que la IA "rellene" huecos del enunciado por su cuenta |

### IA-04 · Simulador de referencia — solo app

| Campo | Contenido |
|---|---|
| Fecha | Hasta el 11-11-2026 |
| Herramienta | Claude (claude.ai). ⚠️ modelo |
| Prompt | _Paráfrasis reconstruida; ⚠️ reemplazar por la transcripción:_ "Verificar con código cada ejemplo de reglas (tableros antes y después, fórmulas) antes de escribirlo" |
| Resultado | `tools/reference-sim/` (`hexsim.py`, `trisim.py`): simulador en Python de las reglas, usado para comprobar los ejemplos `E-*` |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | Es una herramienta de verificación, no código de producción: la implementación del motor en Dart se hace aparte y se prueba con los mismos ejemplos |

### IA-05 · Arquitectura general (ARQ-00 y ARQ-01-APP) — ARQ-00 compartido

| Campo | Contenido |
|---|---|
| Fecha | Hasta el 11-11-2026 |
| Herramienta | Claude (claude.ai). ⚠️ modelo |
| Prompt | _Paráfrasis reconstruida; ⚠️ reemplazar por la transcripción:_ "Proponer la arquitectura del sistema y de la app en Clean Architecture, sin decidir el diseño del motor" |
| Resultado | `docs/architecture/ARQ-00-SISTEMA.md` y `ARQ-01-APP-GENERAL.md`, con las propuestas ARQ-S-* y ARQ-A-* |
| Modificaciones del equipo | D-07 (coordenada como parámetro genérico, opción A). Las propuestas D-21 a D-23 siguen abiertas |
| Lecciones | El diseño del motor (Paso 3) se dejó explícitamente fuera para que lo decida el equipo (§7.3) |

### IA-06 · Contexto y prompt para continuar entre conversaciones — solo app

| Campo | Contenido |
|---|---|
| Fecha | 11-11 y 12-11-2026 |
| Herramienta | Claude (claude.ai). ⚠️ modelo |
| Prompt | _Paráfrasis reconstruida; ⚠️ reemplazar por la transcripción:_ "Prepararme un archivo de contexto y un prompt para retomar la planificación en otra conversación sin perder lo decidido" |
| Resultado | `docs/ai/CONTEXTO-CONVERSACION.md` y `docs/ai/PROMPT-NUEVA-CONVERSACION.md` |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | Funcionó: la conversación del 12-11 retomó el trabajo solo con estos dos archivos, `PENDIENTES.md` y el enunciado |

### IA-07 · Revisión de integridad de todos los documentos — compartido

| Campo | Contenido |
|---|---|
| Fecha | 12-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "Hola esta es la continuacion de la conversacion del proyecto el promt para que continues esta en el .md" (con `PROMPT-NUEVA-CONVERSACION.md` y los zips de `docs/` adjuntos). Después: "disculpa ahi te pase el documento, revisa que todos los documentos tengan integridad con los otros y estan hablando el mismo proyecto en el cual dejamos en el punto la conversacion de ayer" (con el enunciado adjunto) |
| Resultado | Chequeo automático de IDs citados, nueva verificación de los 59 ejemplos con el simulador, renderizado de los 17 diagramas Mermaid y corrección de 15 archivos entre los dos repos (detalle en `docs/ai/CONTEXTO-CONVERSACION.md` §4). Hallazgo de fondo: la propuesta D-27 contradecía la letra del enunciado §5.2 |
| Modificaciones del equipo | ⚠️ pendiente de la revisión del PR #1 |
| Lecciones | La revisión encontró errores que la misma IA había introducido en los borradores (ver §4.2). Revisar los documentos contra el enunciado de forma periódica vale la pena |

### IA-08 · Subir la planificación a GitHub (ramas, commits y PR) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con acceso a los repos |
| Prompt | Literal: "OK tu puedes pushear cada cambio a estos repos" (con las URL de los dos repos); "intentalo ahora"; "Ok, pero estas siguiendo la nomeclatura de como tienes que poner commit y PR del documento enunciado?" |
| Resultado | Rama `docs/planning-baseline` en cada repo con 2 commits (la línea base del 11-11 y la revisión del 12-11) y el PR #1 en cada repo |
| Modificaciones del equipo | El dueño de los repos dio acceso a la app de Claude en GitHub después del primer intento, que GitHub rechazó (403) |
| Lecciones | La primera versión de los PR no usaba la plantilla del repo y su título no llevaba ámbito; se corrigió tras la pregunta del usuario (ver §4.2). Como `main` solo admite *squash*, el título del PR es el commit que queda en `main` y tiene que cumplir Conventional Commits |

### IA-09 · Este archivo — compartido

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "si prepara el AI USAGE para los 2 Repositorios" |
| Resultado | `AI_USAGE.md` en la raíz de los dos repos (A-03) |
| Modificaciones del equipo | ⚠️ completar los campos marcados y las transcripciones de IA-01 a IA-06 |
| Lecciones | La IA no puede registrar lo que no vio: las conversaciones anteriores al 12-11 tienen que completarse con sus transcripciones |

### IA-10 · Paso 3: opciones del motor genérico y patrones del dominio — solo app

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "OK vamos con el paso 3 y dame recomendaciones y propuestas, acuerdate que hay que incluir patrones de diseño en el motor que es el dominio" |
| Resultado | `docs/architecture/ARQ-02-MOTOR.md`: opciones, ventajas, desventajas y recomendación para las 6 preguntas del Paso 3 (D-29 a D-35), 14 patrones GoF ubicados en el dominio con el problema que resuelve cada uno, y esbozos en Dart. `tools/reference-sim/engine_model.py`: modelo en Python que comprueba la lógica de deshacer y de fases contra E-HF-3, E-HM-7 y RN-COM-21, 24 y 60 a 63 |
| Modificaciones del equipo | ⚠️ pendiente: el equipo decide D-29 a D-35 |
| Lecciones | La IA propone y el equipo decide (§7.3): ninguna opción queda cerrada en el documento. En su propia revisión, la IA encontró que el primer borrador del despacho necesitaba un cast para el layout y lo corrigió agrupando topología y layout en una entrada del registro. Sin SDK de Dart, los esbozos no se pudieron compilar: se validan en el *spike* de TEC-01 |

### IA-11 · Explicación del motor y mejora de los eventos — solo app

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "Como lo estoy viendo, las recomendaciones me parecen buenas, pero necesito que me expliques mejor cada cosa por que siento que va a delay en el motor y los eventos de dominio el delay quizas". Después: "Con convence las recomendaciones mas la mejora de los eventos, los tiempos de evidencia si quieres dejalos afuera del documento" |
| Resultado | Medición con el simulador en Python (fuera del documento, a pedido del usuario): la operación más lenta del motor, buscar si alguna pieza de Lines cabe en el peor caso, tardó 0,33 ms, contra 16,7 ms de un cuadro a 60 fps. Mejora de D-32 en `ARQ-02-MOTOR.md` §6: la pantalla recibe los eventos como valor de retorno de `submit` y el `Stream` queda para los oyentes secundarios |
| Modificaciones del equipo | DanielHaro28 aceptó las recomendaciones del Paso 3 con la mejora; falta confirmarlas con el equipo |
| Lecciones | La duda sobre el retraso se resolvió midiendo, no razonando. La espera visible no viene del motor sino de las animaciones, que controla la vista |

### IA-12 · Cierre del Paso 3 y archivo de decisiones por repo — compartido

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "Cierra D-29 a D35, y vamos a reorganizar algo todas las desiciones tomadas hasta ahora a un documento nuevo para cada repositorio, es decir cada repo debe tener su archivo de desiciones, despues haz el merge y vamos con el paso 4" |
| Resultado | D-29 a D-35 cerradas (ARQ-02 pasa a "decidido"). `docs/DECISIONES.md` nuevo en cada repo: 38 decisiones en la app y 15 en la API. Se generaron con un script desde una sola lista, así que las compartidas tienen el mismo texto en los dos. `PENDIENTES.md` queda solo con las abiertas y se actualizaron las referencias de los demás documentos |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | D-35 dejaba sin resolver cómo proteger el Template Method; en lugar de decidirlo, la IA lo separó en una decisión abierta nueva (D-36) con recomendación |

### IA-13 · Cierre de D-21 y D-22 contra el enunciado; D-36 y D-37 — compartido

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "D21 acepto tu recomendacion mientras cumpla lo que dice en el enunciado de carpetas y arquitectura / D22 acepto tu recomendacion mientras cumpla lo que dice en el enunciado de carpetas y arquitectura / D23 explicame mas / d37 y que pasa si cierro el proceso en segundo plano?" |
| Resultado | Comparación de D-21 y D-22 con el enunciado §3.4, §3.5 y §4. D-21 y D-22 cerradas; en D-22, `infrastructure/` queda solo con adaptadores (capa 3) y la capa 4 se nombra aparte. D-36 cambia de recomendación (sin `package:meta`, porque §3.4 prohíbe dependencias externas en la capa 1). D-37 registrada como abierta, con recomendación |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | Revisar una recomendación contra la letra del enunciado puede cambiarla: la de D-36 (del día anterior) contradecía §3.4 |

### IA-14 · Cierre de D-23 y D-37 — compartido

| Campo | Contenido |
|---|---|
| Fecha | 17-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "Me gusta las 2 recomendaciones cierralas modifica los documentos que tengas que modificar y vamos al paso 4" |
| Resultado | D-23 cerrada (contrato en `hexablock-api/docs/contracts/` con copia verificada por CI en la app; ARQ-S-05 y ARQ-B-05). D-37 cerrada: reglas RN-COM-33 a 35 nuevas, RN-COM-32 confirmada, RF-64 pasa a Must, criterio nuevo en NAV-04, puerto `ISavedGameRepository`, tabla `saved_games` en el ADR (rev. 1.9) y término "Partida guardada" en el glosario |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | Una pregunta del usuario ("¿qué pasa si cierro la app?") destapó un requisito que faltaba: guardar la partida en curso |

### IA-15 · Paso 4: arquitectura detallada, diagramas y EXTENSIBILITY — compartido

| Campo | Contenido |
|---|---|
| Fecha | 17-11 al 19-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal, en orden: "Explicame todas por que no entiendo algunas"; "D38 es la mejor manera que se puede hacer eso? / D39 que otras maneras tenemos de manejar ese errores / D40 me gusta la recomendacion, pero cofuncionaria lo de la sesion y el registro con todo lo que tenemos / D41 me gusta como esta / D42 sigamos esa propuesta / D43 hazlo en mermaid"; "Ok me gustan las propuestas para D-43 yo puedo instalar la extension y generar los UML" |
| Resultado | D-38 a D-43 cerradas. `ARQ-03-APP-DETALLE.md` y `ARQ-03-API-DETALLE.md`; `docs/diagrams/` en los dos repos (`capas.mmd` en los dos y `extensibilidad.mmd` en la app, con imágenes generadas y revisadas; `clases.puml` en los dos); `docs/EXTENSIBILITY.md` |
| Modificaciones del equipo | El usuario pidió Mermaid para todos los diagramas; la IA advirtió que reabría P-11 (notación UML de plantilla) y el usuario eligió PlantUML para el de clases, generado por él (R-04) |
| Lecciones | La IA no pudo dibujar PlantUML (sin la herramienta ni red para instalarla): los `.puml` quedan sin verificar hasta R-04. El diagrama de extensibilidad necesitó cuatro intentos hasta que Mermaid dejó el motor en el centro. Al aplicar D-39 al backend, la IA precisó su texto: allí la salida uniforme la da el filtro global de NestJS, no un `Result` |

### IA-16 · Paso 5: decisiones de los contratos — compartido

| Campo | Contenido |
|---|---|
| Fecha | 19-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal, en orden: "Ok sube los sube y aprueba los PR que necesites y acuerdate que las deciones van en documentos separados en los repos, y comenzemos el paso 5"; "D19 no entiendo por que nosotros subimos niveles con el endpoint entonces no enitneod eso de verificar / D27La recomendacion / D44 A / D45B / D46 A si sigue convenciones internacionales / D47 recomiendame con el conetxto de todo que tenemos / D48 Que pasaria si son batantes niveles pensando a futuro / D49 Ok me gusta pero lo mismo con lo de arriba que pasa cuando tiene mucho niveles / D50 A" |
| Resultado | PR del Paso 4 fusionados (app #6, api #4). D-27, D-44, D-45, D-46 y D-50 cerradas en el `DECISIONES.md` de cada repo; regla nueva RN-COM-109 (nombre visible único); rutas con `/v1` en los documentos. D-19 explicada otra vez; D-47 recomendada con el contexto; D-48 y D-49 revisadas pensando en miles de niveles; D-51 nueva (errores según RFC 9457) |
| Modificaciones del equipo | El usuario condicionó D-46 a que siga convenciones internacionales y pidió revisar D-48 y D-49 pensando en el crecimiento. ⚠️ completar |
| Lecciones | Al buscar las convenciones de D-46, la IA encontró que el formato de errores de D-39 era propio y no el estándar del IETF (RFC 9457), y lo propuso como D-51 en vez de cambiarlo por su cuenta. La pregunta por muchos niveles cambió dos recomendaciones: la lista completa y el envío del progreso completo funcionan con 25 niveles pero no escalan |

### IA-17 · Paso 5: D-48 y D-49 cerradas; revisión de errores contra estándares — compartido

| Campo | Contenido |
|---|---|
| Fecha | 19-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con búsqueda web |
| Prompt | Literal: "D46 vamos a hacer una cosa, necesito que D39 siga formatos internacionales de ISO o otros agentes verificados, tambien pensando en seguridad sobre como mostrar los errores quiero que verifiques eso en todo lo que se a hecho, despues de eso dime una recomendacion tomando esto en cuenta. / D47 ok entiendo, pero no entiendo eso de celda q r si las celdas van a tener otras cosas por juego no? / D48 acepto la recomendacion B / D49 Acepto la recomendacion B" |
| Resultado | D-48 y D-49 cerradas: regla nueva RN-COM-77 (descarga por cambios), RN-COM-86 reescrita (solo lo que cambió), ARQ-S-04, tablas Drift en el ADR y en ARQ-01-APP, `LEVEL.updatedAt` en el modelo del servidor, RF-63, 72, 80 e historias API-03 y LVL-01. Revisión de los 8 lugares que describen errores, contrastada con RFC 9457, 9110, 6750 y 6585, OWASP (ASVS, WSTG, Top 10 2025) y MITRE CWE: 6 cosas ya cumplen y 8 faltan; quedan en D-51 con recomendación |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | La IA verificó cada estándar en su fuente (rfc-editor.org, owasp.org, cwe.mitre.org) antes de citarlo. Aclaró que no existe una norma ISO para el formato de errores HTTP en lugar de inventar una. La revisión encontró una inconsistencia propia: dos estilos de código de error introducidos en pasos distintos |

### IA-18 · Paso 5: contratos y modelos de datos — compartido

| Campo | Contenido |
|---|---|
| Fecha | 19-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con búsqueda web |
| Prompt | Literal: "D39 y D51 vamos con la B, aunque no es un riesgo de seguridad mandar el https? / D47 mientras se cumpla que se guarden cosas distintas para distintos tipos de juegos y vamos con el paso 5" |
| Resultado | D-39 (backend), D-47 y D-51 cerradas y aplicadas en todos los documentos. `docs/contracts/` en la API (copia idéntica en la app): `openapi.yaml` 3.1 con 9 operaciones, 5 JSON Schema, 13 ejemplos compartidos (E-HF-NIVEL, E-COM-2, E-COM-3 y otros) y `check_contracts.py`. `ARQ-04-API-DATOS.md` y `ARQ-04-APP-DATOS.md` con sus diagramas `datos.mmd`. D-52 nueva (política de contraseñas, NIST SP 800-63B rev. 4) |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | La IA verificó en el RFC 9457 la respuesta sobre la URI `https` de `type` antes de contestar. El verificador del contrato pasó a la primera, así que se le hicieron 6 pruebas de mutación (consolidado erróneo, `$ref` roto, 429 sin `Retry-After`, ranking desordenado, pila fuera del tablero, `code` distinto de `type`) y las detectó todas. Al escribir el contrato aparecieron dos huecos que no estaban decididos: la política de contraseñas (se registró como D-52 en vez de inventarla) y dos códigos de conflicto de niveles (`level-exists`, `stale-version`). Se cambió la fecha por una secuencia (`change_seq`) para el cursor, porque dos fechas pueden coincidir |

### IA-19 · Cierre de D-19 y D-52 — compartido

| Campo | Contenido |
|---|---|
| Fecha | 19-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "D19 vamos con la A / D52 acepto tu recomendacion" |
| Resultado | D-19 y D-52 en el `DECISIONES.md` de cada repo. RN-COM-76 pasa a acordada; la política de contraseñas queda en SEC-API-02, en la historia API-01 de los dos repos y en `openapi.yaml` (sin la marca de pendiente). Se corrigió `05-TRAZABILIDAD.md` de los dos repos, que todavía listaba como abiertas decisiones ya cerradas |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | Al buscar cada cita de las dos decisiones, la IA encontró una lista de decisiones abiertas desactualizada. Ninguna revisión anterior la había detectado, porque el verificador de IDs solo confirma que un ID existe, no si su estado es el correcto |

### IA-20 · Paso 6: herramientas de niveles y propuestas

| Campo | Contenido |
|---|---|
| Fecha | 19-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "vamos al paso 6" |
| Resultado | `tools/reference-sim/levelkit.py`: resolvedor de Hexa Fit (cuenta soluciones; confirma las 2 de E-HF-NIVEL) y jugador automático de Hexa Sort (voraz y búsqueda en haz) con el xorshift32 comprobado contra E-COM-1. Medición de la dificultad de Sort en 9 combinaciones con 20 semillas cada una. Propuestas D-53 a D-60 en `PENDIENTES.md`, y D-28 precisada |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | Al programar la generación de pilas, la IA encontró que RN-HS-21 (cerrada en D-11) no dice cómo se evita repetir el color del bloque anterior. Las dos formas posibles dan pilas distintas con la misma semilla, lo que rompería el determinismo entre la app y las pruebas. Se propuso como D-60 en vez de elegir en silencio. También se señaló que el enunciado pide niveles "diseñados manualmente", lo que descarta generarlos al azar (D-53) |

### IA-21 · Paso 6: cierre de D-54, D-55, D-57 a D-59 y explicaciones — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con búsqueda web |
| Prompt | Literal: "D53 quisiera un generador de niveles, aunque podemos discutir mas esta opcion dame recomendaciones / D54 Me gusta tu propuesta / D55 me gusta tu propuesta / D56 que es los dobles de pruebas, mocks y todo eso y que me recomiendas / D57 vamos con la A, aunque no consumiera mas de CI o es negible? / D58 vamos con la A / D59 creo que con la C y el equipo puede ajustar, aunque puede quedar a cambio / D60 explicame mas esto / D36 expicame mas esto" |
| Resultado | D-54, D-55, D-57, D-58 y D-59 en el `DECISIONES.md` de cada repo (D-54 y D-55 solo en la app). D-53 reescrita con cuatro opciones para un generador y la recomendación de preguntar al profesor. Explicaciones de dobles de prueba (D-56), de RN-HS-21 con un ejemplo calculado (D-60) y de la protección del Template Method (D-36) |
| Modificaciones del equipo | El usuario eligió C en D-59 en lugar de la recomendación B, aceptando el riesgo y dejando abierto el cambio. ⚠️ completar |
| Lecciones | La IA verificó en GitHub que los repos son públicos y en la documentación de GitHub que los *runners* estándar no gastan minutos en repos públicos, antes de responder sobre el costo del CI. Revisó el enunciado antes de ofrecer composición como alternativa en D-36: el §3.3 pide Template Method "en una clase abstracta", así que esa alternativa no sirve |

### IA-22 · Paso 6: generador, 25 niveles candidatos y estrategia de pruebas — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con búsqueda web |
| Prompt | Literal: "D57 vamos con la recomendacion / D53 D / D56 C, pero esos dobles los escribes tu? / D60 A / D36 B"; y la respuesta "Recomendación" a la pregunta sobre D-28 |
| Resultado | D-28, D-36, D-53, D-56 y D-60 cerradas. `levelgen.py` (generador como herramienta de autor) y `levelcheck.py` (verificador). 25 niveles candidatos en `assets/levels/` con catálogo en `docs/levels/`. Estrategia de pruebas en los dos repos. E-COM-2, E-COM-3, E-HF-1, E-HF-4 y E-HF-NIVEL corregidos. D-61 y P-14 nuevas; R-05 para que el equipo revise los niveles |
| Modificaciones del equipo | Los niveles son **candidatos**: el equipo debe jugarlos, ajustarlos y aprobarlos (R-05), y el profesor debe confirmar que cuentan como "diseñados manualmente" (P-14). ⚠️ completar con lo que ajuste cada integrante |
| Lecciones | (1) Comparar los ejemplos con niveles reales mostró que dos ejemplos ya "verificados" eran imposibles: el script solo comprobaba el orden de los intentos, no que las estrellas fueran coherentes con los umbrales. Se agregó esa comprobación. (2) El verificador de niveles pasó a la primera, así que se probó con 5 roturas a propósito, y las detectó todas. (3) El catálogo y el informe del generador se sacaron de `assets/` porque todo lo que está ahí entra al APK. (4) Al revisar la sincronización apareció un hueco del Paso 5: la API debe conocer los niveles incluidos para revisar la plausibilidad (D-61) |

### IA-23 · Paso 7: revisión del diseño inicial y propuestas del plan — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "P14 Si / R05 lo hacemos cuando tengamos el juego implementado en la apk / D61 Hagamos eso / Sigamos al siguiente paso sabiendo que somos 3 personas en el desarrollo, tambien uno de lo integrante ya hizo un diseño inicial." (con el PDF del diseño adjunto) |
| Resultado | P-14 respondida, R-05 aplazada y D-61 cerrada (copia de los niveles en el *seed* de la API). Revisión de las 59 pantallas del diseño contra las reglas (`docs/design/REVISION-DISENO.md`): qué cumple y 16 diferencias con propuesta. Propuestas D-62 a D-66 para el plan |
| Modificaciones del equipo | ⚠️ completar (quien diseñó decide qué ajustes acepta, D-66) |
| Lecciones | La IA leyó el texto de todas las páginas y miró las más representativas antes de opinar. Separó lo que el diseño hace bien de lo que contradice reglas ya decididas, y dejó cada cambio como propuesta para quien diseñó, sin cambiar el diseño ni las reglas por su cuenta. Encontró también un hueco en las reglas (RN-HL-71 no dice si salir guarda el récord, mientras que Merge sí lo dice) |

### IA-24 · Paso 7: estimación, Definition of Done y tablero — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con búsqueda web |
| Prompt | Literal: "Es una propuesta de diseño para que vallamos visualizando el juego, pero se puede cambiar para acoplar lo definido. / D62 me parece bien, pero cuanto trabajo seria en realidad en horas, mas o menos / D-63 que la base jugable tenga 1 variante / D64 - si cumple con el enunciado y lo que deberia ser un definitions of done / D65 Como es ese tablero? / D66 Ok / D26 Me parece bien / Ya estan los colaboradores en el repositorio / https://github.com/dicpc ella hizo el diseño" |
| Resultado | D-26, D-64 y D-66 cerradas; el PDF del diseño en `docs/design/`; RN-HL-71 precisada; NAV-05 y RF-08 a *Should*; G-01 marcada como hecha. Estimación de horas por área en D-62; D-63 con una sola variante en M1; maqueta del tablero de GitHub Projects mostrada en el chat |
| Modificaciones del equipo | El usuario pidió una sola variante en la base jugable (D-63). ⚠️ completar |
| Lecciones | La IA verificó que el enunciado no define una Definition of Done y la alineó con la definición del Scrum Guide 2020. Intentó comprobar los colaboradores y la cuenta @dicpc, pero el proxy de la sesión solo permite rutas del repo; lo dijo en vez de darlo por comprobado. La estimación de horas es una aproximación y se recalibra al cerrar M1 |

### IA-25 · Paso 7: Issues, milestones y plan de entrega — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` sobre los dos repos |
| Prompt | Literal: "D-62 me parece bien / D63 Ok / D65 me parece bien"; y las respuestas "Yo puedo tomar el backend y devops, pero toma en cuenta que calquiera de nosotros puede ayudar con lo de otra seccion" y "https://github.com/DavidCR20" |
| Resultado | D-62, D-63 y D-65 cerradas. 16 etiquetas y 4 milestones en cada repo; 86 Issues creados desde `04-HISTORIAS.md` y `PENDIENTES.md`, con responsables, estimación y Definition of Done; historias compartidas enlazadas. Plantillas de Issue y `CODEOWNERS` en los dos repos. `docs/plan/PLAN-ENTREGA.md`. Niveles movidos a `app/assets/levels/` |
| Modificaciones del equipo | El usuario aclaró que cualquiera puede ayudar en otra área; quedó en D-62, en el plan y en cada Issue. ⚠️ completar |
| Lecciones | (1) La IA probó primero en modo de prueba (cuántos Issues, horas por persona y por milestone) y, al ver que M1 tenía 132 h, lo aligeró antes de crear nada. (2) La primera corrida creó solo los Issues de Daniel: GitHub rechaza asignar a quien no aceptó la invitación, y el script buscaba el error en la salida equivocada. Se corrigió consultando antes quién es asignable; la segunda corrida saltó los ya creados, sin duplicados. (3) Al escribir `CODEOWNERS` se vio que los niveles estaban en la raíz y no en `app/assets/`, donde los busca la app |

### IA-26 · Tablero de GitHub Projects (T-02) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con el navegador integrado de la app de escritorio (sesión de GitHub iniciada por el dueño) |
| Prompt | Literal: "ya estoy en la aplicacion de claude ahora que hago para que tu puedas hacerlo y si despues uso mi laptop no habria probremas?" y "intentalo de nuevo, no estaba en la pc"; luego eligió "Agregar Backlog" y los cuatro cambios propuestos (vincular `hexablock-api`, campo Estimación (h), vista Tabla, acceso del equipo) |
| Resultado | Tablero [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) completado: columna Backlog por defecto, 46 Issues de M2, M3 y sin milestone en Backlog, campo Estimación (h) con las horas de los 86 Issues (403 h), vistas Tablero y Tabla, proyecto vinculado a los dos repos, @dicpc y @DavidCR20 con escritura. Las plantillas de Issue agregan los Issues nuevos al proyecto (`projects:`) |
| Modificaciones del equipo | El dueño ya había creado el proyecto, las columnas, los workflows y agregado los 86 Issues; la IA revisó eso antes de tocar nada y preguntó por la diferencia con D-65 (faltaba Backlog). ⚠️ completar |
| Lecciones | (1) El dueño inició sesión en GitHub él mismo; la IA no escribió credenciales. (2) Las horas no se cargaron a mano celda por celda: se usó el mismo pedido que hace la página al editar una celda y se comprobó al final que los 86 valores y los 46 estados coincidían con `issues_created.json`. (3) La IA afirmó primero que el plan solo permitía un filtro de auto-add y lo suplió con `projects:` en las plantillas; al revisar la documentación de GitHub vio que la cuenta Pro permite 5, y agregó el workflow de `hexablock-api` |

### IA-27 · Revisión de organización y seguridad de los documentos — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` y búsquedas en los dos repos |
| Prompt | Literal: "Ok vamos a revisar todos los documentos de los Repos y vamos a ordenar sus contenidos, ponemos donde va cada cosa, que documento esta de adicional cuando podria ir en otro, tambien revisemos en cuanto a seguridad que documentos deberian estar en el repo y cuales no y sus contenidos en cuanto a seguridad." |
| Resultado | Inventario de los dos repos contra lo que el enunciado fija (§3.1, §4, §6.1, §7.2, §8). Búsqueda de secretos, correos, IP, identificadores de AWS y datos personales: no se encontró nada; los metadatos del PDF del diseño están limpios. Nueve decisiones abiertas (D-67 a D-75) con recomendación. Arreglos que no necesitan decisión: `.gitignore` con patrones de secretos en los dos repos, saldo de créditos de AWS quitado de `CONTEXTO-CONVERSACION.md`, fechas y revisiones viejas en `PENDIENTES.md` |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | La IA buscó en los repos con patrones (correos, IP, claves, `arn:aws`, nombres) en vez de leer todo a ojo, y comprobó con el enunciado qué ubicaciones son obligatorias antes de proponer mover algo. Encontró que sus propios scripts de verificación no están en ningún repo (D-72) |

### IA-28 · Reorganización de los documentos (D-02, D-67 a D-75) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` y el navegador integrado de la app de escritorio |
| Prompt | Literal: "Lo del problema, si ya esta registrado en el issue que lo tiene que reemplazar perfecto. de las decisiones acepto todas tus recomendaciones" |
| Resultado | D-02 y D-67 a D-75 cerradas. Las tablas de decisiones de los ARQ pasaron a apuntar a `DECISIONES.md`, que suma las `ARQ-A-*` y `ARQ-B-06`. `ARQ-02-MOTOR.md` empieza con el diseño final en una página y las opciones van en el Anexo A. Se borró ARQ-01-APP §10. `PENDIENTES.md` quedó con D-03, D-20, ARQ-S-02 y ARQ-S-03; las tareas pasaron a Issues (G-01 nuevo, app #83; F-01 a F-10 en T-07) y la hoja de ruta, a `PLAN-ENTREGA.md` §6. Scripts de revisión en `tools/docs-check/` con un workflow `docs-check` en los dos repos. `tools/planning/` para asignar los Issues pendientes. SEC-MOB-07 y el environment `release` en SECURITY-BASELINE; `SECURITY.md` en los dos repos. R-03 ahora incluye cambiar la plantilla del `.gitignore` |
| Modificaciones del equipo | El usuario aceptó todas las recomendaciones. ⚠️ completar |
| Lecciones | (1) Al quitar las tablas de los ARQ, sus IDs (`ARQ-S-*`, `ARQ-A-*`, `ARQ-B-*`) quedaban sin definir; se dejó una tabla corta de "ID → dónde está ahora" y el verificador lo comprueba. (2) ARQ-S-02 y ARQ-S-03 seguían como propuestas: en vez de darlas por cerradas, se pasaron a `PENDIENTES.md` para que el equipo las confirme. (3) El verificador de IDs viejo tomaba el final de `IA-05` como si fuera una tarea `A-*`; se corrigió antes de ponerlo en CI y se probó con roturas a propósito. (4) No se pudo activar *Private vulnerability reporting* desde la sesión (la API respondió 403); lo activa el dueño (G-05) |

### IA-29 · Confirmación de ARQ-S-02 y ARQ-S-03 — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "2. confirmalas" |
| Resultado | ARQ-S-02 (el servidor no ejecuta reglas de juego) y ARQ-S-03 (consolidación en Dart y TypeScript con ejemplos compartidos) pasan de `PENDIENTES.md` a `DECISIONES.md` en los dos repos; ARQ-00 §6 apunta allí |
| Modificaciones del equipo | Las confirmó el usuario |
| Lecciones | Ninguna nueva: el contrato ya las daba por hechas, solo faltaba registrarlas |

### IA-30 · Diagramas de clases en varias imágenes (D-76) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai |
| Prompt | Literal: "el puml se ve mal, se exporta mal por que es muy grande, aparte tiene que ser un diseño asi, no le prestes atencion a los colores" (con la imagen de un diagrama de ejemplo: cajas de tres partes, «interface», flecha punteada para implementar y sólida para usar), "Entiendo la 1 seria la mejor opcion, pero como haria la comunicacion entre capas? si van a estar en 4 diagramas?" y "hazlo" |
| Resultado | La app pasa de un diagrama de 122 clases a 4 (general de 28, motor de 41, variantes de 37, aplicación y adaptadores de 38); la API, de uno de 68 a 2 (general de 32, dominio y casos de uso de 43). El general muestra las 4 capas y sus interfaces; en los de detalle, las interfaces del borde aparecen solo con su nombre («motor», «puerto»). D-76 en `DECISIONES.md`; R-04 actualizada |
| Modificaciones del equipo | El usuario eligió la opción de un general más diagramas de detalle y el estilo del ejemplo. ⚠️ completar |
| Lecciones | (1) PlantUML recorta las imágenes de más de 4096 px, por eso el diagrama grande se exportaba cortado. (2) En la sesión no hay PlantUML: la IA no pudo dibujar los `.puml`. Revisó con un script que cada clase de una relación esté declarada y que las llaves cierren, y usó solo construcciones que ya funcionaban en el diagrama anterior; el dibujo lo valida el equipo al exportar (R-04) |

### IA-31 · Nuevo reparto de responsabilidades (D-77) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "Ok vamos a cambiar responsabilidades, yo me voy a encargar de todo el motor y despliegue, la API y frontend para los demas, pero no asignes nada a ellos, lo voy a discutir quien quiere hacer que, pero yo voy a hablar con ellos, solo asigname todo lo del despliegue y motor a mi"; después eligió "Motor y topologías" y quitarse los Issues de API y frontend |
| Resultado | D-77 cerrada y D-78 abierta. @DanielHaro28 asignado a TEC-01, TEC-02, TEC-06, TEC-07, TEC-08 y T-03 (además del despliegue, que ya tenía); quitado de los 17 Issues de API, frontend y Hexa Merge. Los Issues de los demás dicen "por definir" y no se asignaron a nadie; `tools/planning/issues_created.json` ya no los asigna. `PLAN-ENTREGA.md` §1 y §5 y `CODEOWNERS` actualizados |
| Modificaciones del equipo | ⚠️ completar al cerrar D-78 |
| Lecciones | La IA preguntó qué entraba en "todo el motor" antes de reasignar, porque la etiqueta `area:engine` también incluía casos de uso y progreso de la app. Vio que el script de G-01 habría vuelto a asignar el reparto viejo, y lo corrigió |

### IA-32 · Solo Claude Code (D-87) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "vi que mencionan cline, no lo voy a utilizar solo claude code" |
| Resultado | D-87: Cline sale de ADR-001 §2.6 (rev. 2.0), de SECURITY §6 (SEC-AGT-05, §6.1 y §6.2), de las plantillas de PR y de la tabla de herramientas de `AI_USAGE.md` |
| Modificaciones del equipo | Lo decidió el usuario |
| Lecciones | La IA buscó en los dos repos todas las menciones antes de cambiar nada, para que los documentos compartidos quedaran iguales |

### IA-33 · Paso 8: configuración de Claude Code (D-79 a D-86) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` y la documentación oficial de Claude Code (memory, permissions, hooks, sub-agents, skills, sandboxing) |
| Prompt | Literal: "Empieza el paso 8, aqui yo no tengo muchos conocimientos del claude.md asi que me vas a tener que explica rtodo"; luego "D-79 A / D80 A / D81 A / D82 A / D83 A / D84 recomiendame skill para este proyecto / D85 A si no gasta tantos tokens / D86 A, que es un MCP y cual funcionaria en este proyecto" y "D85 OK / D84 me gustan esos skills y skills creados por la comunidad? / D86 B" |
| Resultado | En los dos repos: `CLAUDE.md`, `.claude/rules/`, `.claude/settings.json`, hooks en Node (`protect-files`, `guard-git`, `format-file`), subagentes `architecture-reviewer` y `security-reviewer`, y skills (`/implement-story`, `/ai-usage`, `/paired-change`; en la app también `/rule-change` y `/new-variant`). En la app, `.mcp.json` con el servidor MCP de Dart y Flutter. `docs/ai/APPROVED-TOOLS.md` (compartido, A-04). SECURITY §6.1 y §6.2 y ADR-001 §2.6 apuntan a la configuración real. Se borraron `CONTEXTO-CONVERSACION.md` y `PROMPT-NUEVA-CONVERSACION.md` (D-70). D-88 (skills de terceros) queda abierta |
| Modificaciones del equipo | El usuario aceptó las recomendaciones y pidió la explicación de cada pieza; eligió el MCP de Dart y Flutter después de ver los candidatos. ⚠️ completar |
| Lecciones | (1) La IA revisó la documentación actual antes de escribir: descubrió que el *sandbox* no funciona en Windows nativo y que las reglas sobre comandos se pueden eludir, y lo dejó escrito en SECURITY §6.1. (2) Recomendó primero "ningún MCP" sin haber mirado los candidatos; al revisarlos cambió la recomendación y lo dijo. (3) Los hooks se probaron con entradas simuladas (rutas de Windows, `.env.example`, `push` a `main`) antes de subirlos; dentro de Claude Code los prueba el equipo al instalarlo. (4) Al revisar la instalación en Windows vio que Claude Code puede usar PowerShell en lugar de Bash, y agregó las reglas gemelas `PowerShell(...)` y el mismo hook de git |

### IA-34 · Cierre de D-88 (skills de terceros) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "D88 A" |
| Resultado | D-88 cerrada: solo skills oficiales de Flutter y Dart, revisadas una por una y copiadas en una versión fija. `docs/ai/APPROVED-TOOLS.md` (compartido) explica el procedimiento; T-03 tiene la tarea de revisarlas |
| Modificaciones del equipo | Lo decidió el usuario |
| Lecciones | Ninguna nueva |

### IA-35 · Cierre de D-03; D-20 para TEC-07 — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "D03 A / D20 Recomendacion / M0 vamos a eso" |
| Resultado | D-03 cerrada (409 `email-taken`, riesgo aceptado y mitigado); SECURITY §3, API-01, REVISION-DISENO y la trazabilidad de la API actualizadas. D-20 sigue abierta con fecha "al empezar TEC-07" |
| Modificaciones del equipo | Lo decidió el usuario |
| Lecciones | Ninguna nueva |

### IA-36 · R-03: .gitignore de la app

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "D03 A / D20 Recomendacion / M0 vamos a eso" (R-03 es requisito de T-03) |
| Resultado | El `.gitignore` era la plantilla del repo de Flutter (ignoraba `*.lock`); se reemplazó por la plantilla de app de `flutter create`, adaptada a `app/` y `packages/`, conservando las reglas de secretos |
| Modificaciones del equipo | Ninguna todavía |
| Lecciones | Ninguna nueva |

### IA-37 · T-03: esqueleto del workspace y skills oficiales — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "D03 A / D20 Recomendacion / M0 vamos a eso" |
| Resultado | Workspace de pub con `hexa_engine`, `hexa_topologies`, `hexa_variants`, `hexa_application`, `hexa_test_support` y `app/`; `analysis_options.yaml` estricto sin paquetes de terceros; proyecto Android generado con `flutter create` en el CI (Flutter 3.50.0) y `pubspec.lock`. Revisión de las 25 skills oficiales: 8 copiadas con su commit y licencia, 17 descartadas con el motivo en APPROVED-TOOLS (D-88). Una prueba de *widget* mínima escrita por Claude |
| Modificaciones del equipo | Pendiente: revisar la prueba de *widget* (D-59) y confirmar el `applicationId` `io.github.danielharo28.hexablock_app` antes del primer release |
| Lecciones | Desde Flutter 3.47 `package:flutter/material.dart` está obsoleto (Material pasó al paquete `material_ui`); el análisis estricto lo detectó en el CI. El esqueleto usa solo `widgets.dart` |

### IA-38 · TEC-04 (app): CI y release firmado

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "D03 A / D20 Recomendacion / M0 vamos a eso" |
| Resultado | `ci.yml` (título del PR en Conventional Commits, `pub get --enforce-lockfile`, formato con el diff en el log, análisis, arquitectura, pruebas con cobertura, puerta de cobertura, ejemplos `E-*` y APK de depuración) y `release.yml` (tag `v*` sobre `main`, keystore del environment `release`, APK ofuscado y firmado, verificación de que no es la clave de depuración, GitHub Release con SHA-256). Scripts en `tool/`: `check_architecture.dart`, `coverage_gate.dart`, `check_examples_covered.dart` y la lista `examples_pending.txt`. Verificados en el CI con violaciones a propósito (motor con `hexa-lines` y `DateTime.now`, `playTurn` en una variante, `ILogger` en un caso de uso, cobertura de 25 %, ejemplo probado aún en la lista) y luego revertidas |
| Modificaciones del equipo | Pendiente: crear el keystore y los 4 secretos del environment `release`, y exigir el check `ci` en el ruleset (G-10) |
| Lecciones | Flutter 3.50 agrega por su cuenta `analyzer: exclude: android/**` al `analysis_options.yaml` de la app; si no está en el repo, el paso de formato ve un cambio. Probar los scripts de CI con violaciones a propósito encontró que el control de cobertura funciona también en paquetes Dart puros con `flutter test --coverage` |

### IA-39 · R-01 y D-89: versiones exactas y Prisma ORM 7 — compartido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "Prisma 7.10" (respuesta a la decisión sobre Prisma 7 u 8 que propuso Claude) |
| Resultado | D-89 cerrada (Prisma ORM 7, 7.10.1) en los dos registros y en ADR-001 §2.2 (rev. 2.1). Tablas de versiones exactas en los dos README: Flutter 3.50.0 y Dart 3.14.0 (vistas en el CI), Node 26 LTS, NestJS 12.5.0, Prisma 7.10.1 y PostgreSQL 18.7 (buscadas en la web el 20-11) |
| Modificaciones del equipo | Lo decidió el usuario |
| Lecciones | Ninguna nueva |

### IA-40 · CI: APK de depuración más rápido

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "esa prueba en el Ci de apk tarda mucho no hay forma de ponerla mas rapido" y luego "la 1 y 2 me parece bien me da miedo que ese en cache" |
| Resultado | El job `apk` del CI solo arma el APK si el PR cambia `app/android/`, `app/pubspec.yaml`, `pubspec.lock` o los workflows (siempre en `main`); si no, pasa en segundos para que el check obligatorio no quede esperando. Caché de Gradle solo en ese job; `release.yml` no usa caché |
| Modificaciones del equipo | Lo eligió el usuario (opciones 1 y 2 de las que propuso Claude) |
| Lecciones | Los runners estándar son gratis en repos públicos (D-57), así que el costo real del job era el tiempo de espera, no minutos |

### IA-41 · La API se asigna a @DavidCR20 (D-78, parcial)

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "asignale API a david" |
| Resultado | Los 8 Issues sin responsable de `hexablock-api` (T-04, API-01 a API-04, LVL-01, LVL-02 y TEC-05, 49 h) asignados a @DavidCR20 y con su línea de responsable actualizada; PLAN-ENTREGA §1 y sus filas, PENDIENTES (D-78 sigue abierta para el frontend) y `tools/planning/issues_created.json` |
| Modificaciones del equipo | Lo decidió el usuario |
| Lecciones | Ninguna nueva |

### IA-42 · La interfaz se asigna a @dicpc (D-78, parcial)

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Opus 5.5 (`claude-opus-5-5`) en claude.ai, con `gh` |
| Prompt | Literal: "asigna UI a diana" |
| Resultado | Los 14 Issues de la app con `area:ui` y sin responsable (NAV-01 a NAV-08, PRG-01, PRG-02, API-01 y API-02 de la app, T-05 y TEC-09; 76 h) asignados a @dicpc, con su línea de responsable actualizada; PLAN-ENTREGA §1 y sus filas, PENDIENTES (D-78 sigue abierta para las variantes, los casos de uso y el progreso) y `tools/planning/issues_created.json` |
| Modificaciones del equipo | Lo decidió el usuario |
| Lecciones | Ninguna nueva |

### IA-43 · Motor genérico: tablero, topología y formas (TEC-01, PR 1 de 5) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 21-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); subagente `architecture-reviewer` |
| Prompt | Literal: "Implementa el PR 1 del plan del motor (TEC-01 #64)" y "tambien me vas a explicar que hace cada archivo, clase y otras cosas que pongas, que recibe de donde y todo lo necesario para saber que estas implementando"; después, "ok, B y dejar la colocación fuera, empieza" |
| Resultado | Issue #64, rama `feat/tec-01-board-topology`. En `packages/hexa_engine/lib/src/board/`: `Coord`, `Axis`, `Direction`, `Rotation`, `ShapeSpec`, `Shape` (Composite), `GridTopology` (normalizar, rotar, orientaciones, rayos y Visitor escritos una vez), `TopologyVisitor` y `Board` inmutable (Bridge). Dobles `FakeCoord`, `FakeTopology` y `FakeCell` en `hexa_test_support`. 56 pruebas, cobertura del dominio de 94,5 %. Documentos: D-90, D-91 y D-92 en `DECISIONES.md` (D-92 propuesta por la revisión de arquitectura y cerrada por el usuario con la opción A), avance del *spike* en ARQ-02, EXTENSIBILITY §4 y trazabilidad de RF-10 |
| Modificaciones del equipo | El usuario eligió que una coordenada fuera del tablero lance un error (opción B, D-91) y dejar la colocación en un ancla fuera del PR. ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) Claude dijo que Python no estaba instalado: solo probó `python` y `python3`, que en Windows son accesos de Microsoft Store; el usuario lo corrigió y funciona con `py`. (2) El esbozo de ARQ-02 §4.3 daba por hecho que `Coord` obligaría a implementar `==`; al compilarlo se vio que Dart no lo exige, y quedó documentado. (3) La revisión de arquitectura encontró una igualdad de tableros que fallaba con dos instancias de la misma topología y la pregunta de las anclas en triángulos (D-92) |

### IA-44 · Topología hexagonal intercambiable y colocación en un ancla (TEC-06, PR 2 de 5) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 21-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); subagente `architecture-reviewer` |
| Prompt | Paráfrasis fiel del pedido: implementar el PR 2 del plan del motor (TEC-06 #67, rama `feat/tec-06-hex-topology`, `Closes #67`) después de comprobar que el PR #100 estaba fusionado: `HexCoord` y `HexTopology` (RN-HEX-01 a 08) con solo las primitivas de D-90, el `typedef` `HexBoard<TCell>`, la prueba de E-HEX-1, la prueba de contrato común `checkTopologyContract` en `hexa_test_support`, `GridTopology.place` según D-92 y la sección de restricciones de tipo del README; plan primero, pruebas primero, revisión de arquitectura, `AI_USAGE.md` y PR con la plantilla. Después, literal: "Cual es ese mal codificacion, y cada commit no deberia ser un PR_?" y "ok, sigue con tus recomendaciones y place en este PR" |
| Resultado | Issue #67, rama `feat/tec-06-hex-topology`. En `packages/hexa_topologies/lib/src/hex/`: `HexCoord` (con `distanceTo`, RN-HEX-07), `HexTopology` y `HexBoard`. En `hexa_engine`: `GridTopology.place` (D-92). En `hexa_test_support`: `checkTopologyContract` (ahora depende de `package:test`) y `FakeCheckeredTopology` (dos tipos de celda y dos giros básicos). 102 pruebas en `hexa_engine` y 77 en `hexa_topologies`; cobertura de 97 % en `hexa_engine` y 100 % en `hexa_topologies`. Documentos: sección *Generic engine* del README (RNF-05), EXTENSIBILITY §4, ARQ-02 §3.1 y §4.3, `clases-motor.puml` y trazabilidad de RF-10 y E-HEX-1 |
| Modificaciones del equipo | El usuario aceptó las dos recomendaciones del plan (la distancia como `HexCoord.distanceTo` y el doble a cuadros para probar el `null` de `place`) y pidió dejar `place` en este PR. ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) Al leer el código se encontró un `§` mal codificado (`Â§`) que había entrado con IA-43. (2) Para comprobar que la prueba de contrato sirve, se rompió `HexTopology` a propósito de dos maneras (sentidos invertidos en un eje y orden de vecinas distinto según la celda) y el contrato falló en las dos. (3) La revisión de arquitectura encontró que el contrato no relacionaba las vecinas con `step`, que el doble a cuadros no tenía un giro que cambiara el tipo de celda (como en triángulos) y que `FakeTopology.step` aceptaba direcciones de otra topología con el mismo `id`; se corrigió con pruebas. (4) Límites del entorno: OneDrive bloqueó `build/` de `hexa_engine` y `flutter test --coverage` falló ahí, así que la cobertura del motor se midió con `dart test --coverage`; `check_ids.py` no se pudo correr completo porque `hexablock-api` no está clonado en esta máquina, y lo verifica el CI |

### IA-45 · Motor genérico: ciclo de turno, fases, eventos y motor (TEC-01, PR 3 de 5) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 21-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); subagente `architecture-reviewer` |
| Prompt | Paráfrasis fiel del pedido: implementar el PR 3 del plan del motor (rama `feat/tec-01-turn-cycle`, `Refs #64`) después de comprobar el estado de los PR y de `dart`: `GameState`, `GameRules` como Template Method (`playTurn` fijo, D-36), `TurnResult`, `Step`, `GameOutcome`, `GamePhase` (5 fases), `GameEvent`, `MoveResult`, `GameEngine` con *streams* síncrono y asíncrono y `FakeRules`; leer ARQ-02, RN-COM-20 a 25 y 31, y D-36 y D-90 a D-92; proponer opciones con recomendación para lo no decidido y esperar la respuesta; pruebas primero, revisión de arquitectura, `AI_USAGE.md` y PR con la plantilla. Respuestas del usuario, literales: "Explicame bien cada opcion y dime por que una es mejor que otra y si sige las reglas del enunciado y reglas escritas.", "1. A 2. A, que pasaria con esos 2 eventos por fase que ignora generan carga en el sistema? 3. Dame una mejor Opcion por que veo que si mas adelante intento agregar una variantes con otro motivo propopio no serviria.", "Ok me gusta la opcion C, como hacemos para mitigar las desventajas?" y "Me gusta, arranca" |
| Resultado | Issue #64, rama `feat/tec-01-turn-cycle`. En `packages/hexa_engine/lib/src/game/`: `GameState`, `GameOutcome`, `GamePhase` y sus 5 fases, `RejectionReason` con `InvalidMove` y `NotAcceptingMoves`, `GameEvent` con `PhaseChanged`, `ScoreChanged` y `MoveRejected`, `Step` y `TurnResult`, `IGameRules` y `GameRules` (Template Method con `rejectionOf`), `MoveResult` y `GameEngine` (dos *streams*, protección contra la reentrada y vuelta atrás si las reglas fallan). En `hexa_test_support`: `FakeRules`, `FakeState`, `FakeMove`, `FakeEvent` y `CellOccupied`. 161 pruebas en `hexa_engine` (60 nuevas); cobertura del dominio de 98,4 %. Decisiones D-93 a D-95 cerradas y D-96 abierta. Documentos: ARQ-02 (primera página, §2, §4.3, §6, §8, §9.6 y §12), `EXTENSIBILITY.md` §2, README (restricciones de tipo), `clases-motor.puml`, `clases.puml` y trazabilidad de RF-05, RF-10 y RF-12 |
| Modificaciones del equipo | El usuario eligió las opciones A de D-93 y D-94. En D-95 rechazó la recomendación inicial (un `enum`), porque no servía para una variante nueva con motivos propios, y pidió una opción mejor (la jerarquía abierta) y cómo mitigar sus desventajas (nombre `rejectionOf`, ayudante `isValid`, constructor privado de `NotAcceptingMoves`). ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) La primera recomendación de D-95 (un `enum`) no consideraba la extensibilidad; la detectó el usuario. (2) La revisión de arquitectura encontró que `close()` llamado desde un oyente síncrono cortaba un turno a la mitad, que faltaba explicar por qué `TState` no tiene restricción en los tipos de resultado, que ARQ-02 §9.6 citaba una prueba de D-36 que no existe y que había cuatro nombres de prueba sin `_when_`; todo se corrigió, con una prueba para `close()`. (3) También encontró una contradicción del diseño: el decorador de reglas de ARQ-02 §9.2 tendría que declarar `playTurn`, que D-36 prohíbe; quedó abierta como D-96 para el equipo. (4) Límites del entorno: VS Code heredó un PATH antiguo, así que `dart` y el servidor MCP de Dart no estaban disponibles; se usó la ruta del SDK en cada comando |

### IA-46 · Cierre de D-96: decoradores de reglas sobre `GameRules` — solo app

| Campo | Contenido |
|---|---|
| Fecha | 21-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel: cerrar D-96 (abierta en IA-45) con la opción A que eligió el usuario y alinear los documentos. Lo redactó una sesión anterior, que dejó los cambios sin commit en la rama de #102; esta sesión los pasó a una rama propia. Pedido literal de esta sesión: "ya esta el PR y la desicion de D96" |
| Resultado | Issue #64, rama `docs/d-96-rule-decorators`. D-96 pasa de `PENDIENTES.md` a `DECISIONES.md`. ARQ-02 §9.2, §9.6 (esbozo de `MoveLimitRulesDecorator`), §10 y §12, `EXTENSIBILITY.md` §3 y el comentario de `GameRules` describen que un decorador extiende `GameRules`, delega cada paso y nunca declara `playTurn` |
| Modificaciones del equipo | El usuario eligió la opción A recomendada en IA-45 |
| Lecciones | (1) Los cambios del cierre quedaron sin commit en la rama de #102, que se integró sin ellos; se detectó al revisar `git status` antes de seguir. (2) Al compilar y correr el esbozo de §9.6 contra `FakeRules` se vio que devolvía derrota cuando el último movimiento permitido también ganaba, contra RN-COM-23; se corrigió para que respete la victoria de las reglas envueltas, y la corrección también se comprobó corriéndola |

### IA-47 · Motor genérico: generador, reloj y estrategias (TEC-01, PR 4 de 5) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 21-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); subagente `architecture-reviewer` |
| Prompt | Paráfrasis fiel del pedido: implementar el PR 4 del plan del motor (rama `feat/tec-01-strategies`, `Refs #64`) después de comprobar el estado de los PR, de `dart`, del MCP de Dart y de la identidad de git: `IPieceSource<TPiece>`, `IScoringPolicy<TState>` e `IProgressModel` (Strategy, D-35); `Xorshift32` según RN-COM-40 a 45, con el estado del generador como valor inmutable dentro del estado de la partida (RN-COM-42) y la prueba de E-COM-1 (sin E-COM-2 ni E-COM-3); `IMonotonicClock` y `FakeClock`; nada de `Random()` ni `DateTime.now()` en el dominio; dejar fuera lo del PR 5. Leer ARQ-02, RN-COM-40 a 45 y 50 a 52 y D-14, D-31, D-33, D-35 y D-93 a D-96; si una firma no está decidida, proponer opciones explicadas y esperar; pruebas primero, revisión de arquitectura, `AI_USAGE.md` y PR con la plantilla. Respuestas del usuario, literales: "acepto las recomendaciones y sigue", "Traeme las nuevas deciciones" y "Acepto las recomendaciones" |
| Resultado | Issue #64, rama `feat/tec-01-strategies`. En `packages/hexa_engine/lib/src/`: `random/xorshift32.dart` (`next`, `nextInt`, `chance`, semilla 0 → `0x9E3779B9` como `tools/reference-sim`, semilla fuera de 32 bits → error), `time/monotonic_clock.dart` y `strategy/` (`IPieceSource`, `IScoringPolicy<TState, TEvent>` e `IProgressModel<TAttempt>`). En `hexa_test_support`: `FakeClock`, `FakePieceSource`, `FakeScoring`, `FakeAttempt` y `FakeProgressModel`, y su primera carpeta `test/`. 188 pruebas en `hexa_engine` (27 nuevas) y 4 en `hexa_test_support`; cobertura del dominio de 98 %. E-COM-1 sale de `tool/examples_pending.txt`. Decisiones D-97 a D-101 cerradas (D-100 y D-101 salieron de la revisión de arquitectura). Documentos: ARQ-02 (primera página, §2, §4.2, §4.3, §9.2, §9.3, §9.7 nueva y §12), `EXTENSIBILITY.md`, README (restricciones de tipo), TEC-01, trazabilidad, `ESTRATEGIA-PRUEBAS.md` §4 y las fuentes de `clases-motor.puml`, `clases-variantes.puml`, `extensibilidad.mmd` y `capas.mmd` |
| Modificaciones del equipo | El usuario aceptó las recomendaciones: B en la fuente de piezas, B en la puntuación y A en el progreso, y después A en D-100 (`VariantFamily` solo con `createRules` y `createSession`, sin `TPiece`) y A en D-101 (un multiplicador con fracciones envuelve solo la política de un paso). ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) El esbozo de `IPieceSource` del diagrama de clases (la fuente guarda su generador) no servía para Hexa Merge, que saca la celda y el valor del mismo generador (RN-HM-21); se vio al recorrer cómo usaría la firma cada variante antes de proponer las opciones. (2) Claude escribió en el comentario de `Xorshift32` que ninguna otra semilla llegaba al estado de la semilla 0, lo que es falso (la semilla `0x9E3779B9` llega); lo corrigió antes del commit. (3) La revisión de arquitectura encontró el nombre de una variante en un comentario del motor (el CI no lo detecta porque ignora los comentarios), un esbozo de §9.7 que aplicaba la racha de Lines dentro de la política y contradecía el decorador de §9.2, `group` con reglas que las pruebas no comprobaban, dos pruebas que comprobaban dos cosas y el redondeo por paso de un multiplicador que abarque varios pasos (D-101). (4) Límites del entorno: no hay ninguna herramienta aprobada para exportar los diagramas, así que `extensibilidad.png` queda desactualizada hasta que alguien la exporte |

### IA-48 · Motor genérico: deshacer, cronómetro y sesión (TEC-01, PR 5 de 5) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 22-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); subagente `architecture-reviewer` |
| Prompt | Paráfrasis fiel del pedido: implementar el PR 5 del plan del motor (rama `feat/tec-01-session`) después de comprobar que #104 estaba integrado, el estado de `git`, `dart`, el MCP de Dart y la identidad de git: `Restorable`, `UndoableEngine`, `MoveCommand` y `UndoHistory` con `limit` y `allowsRedo` (D-31); en el motor, `restore`, `StateRestored` y `committedTurns`, y `allowsUndo` en las fases; las capacidades `IUndoable`, `ITimed`, `IRandomSeeded` e `ILevelBased` (D-33); `ActiveTimer` con `IMonotonicClock` y `FakeClock`, sin esperas reales (RN-COM-52); `GameSession` con solo las capacidades que tenga; pruebas de RN-COM-52 y 60 a 63, y de que deshacer restaura el generador con un estado de prueba que lleve un `Xorshift32`, usando `engine_model.py` como referencia, sin quitar E-HF-3 ni E-HM-7 de los pendientes. Fuera: `VariantFamily`, casos de uso, codec, E-COM-2 y E-COM-3. Proponer opciones explicadas para lo no decidido y esperar; pruebas primero, revisión de arquitectura, `AI_USAGE.md`, PR con la plantilla y comparar los criterios de TEC-01 antes de decidir entre `Closes #64` y `Refs #64`. Respuestas del usuario, literales: "D102 B / D103 B / D104 A / D105 A / D106 A + A", "Ok explicame D107", "Eligo la B ve que se consideren las desventajas bien", "si no sabe que movimiento fue como llevamos la cuenta que en movimiento esta para el ranking?" y "vamos con la A" |
| Resultado | Issue #64, rama `feat/tec-01-session`. En `packages/hexa_engine/lib/src/`: `allowsUndo` y `countsActiveTime` en `GamePhase`; `StateRestored`; `GameEngine.restore` y `committedTurns`; `undo/` (`Restorable`, `UndoableEngine`, `MoveCommand`, `UndoHistory` con `carryOver`, y `UndoSnapshot`, para guardar y continuar el historial); `session/` (las cuatro capacidades y `GameSession`); `time/` (`TimedEngine` y `ActiveTimer`). En `hexa_test_support`: `FakeSeededState` y `FakeSeededRules`. 260 pruebas en `hexa_engine` (72 nuevas). Decisiones D-102 a D-107 y D-109 cerradas (D-107, guardar el historial de deshacer, salió de la revisión de arquitectura; D-109, conservar la cuenta de movimientos de Fit al deshacer, de una pregunta del usuario; D-108, la región de AWS, es de IA-49). Documentos: ARQ-02 (primera página, §5 a §8 y §12), ARQ-04 §8, `clases-motor.puml`, RN-COM-52, trazabilidad de RF-05, RF-10, RF-33, RF-53 y RF-64 y `ESTRATEGIA-PRUEBAS.md` |
| Modificaciones del equipo | El usuario aceptó las recomendaciones: B en D-102 (`restore` mantiene la fase y exige `allowsUndo`), B en D-103 (`StateRestored` y después `ScoreChanged`), A en D-104 (`levelId`), A en D-105 (`Duration`) y A + A en D-106 (tiempo calculado al leerlo; la fase dice si corre). En D-107 pidió que se explicara a fondo, eligió B (guardar solo la línea de estados) y pidió que se trataran bien sus desventajas: cada una quedó con su mitigación en D-107 y, donde se puede, con una prueba. Después preguntó cómo se cuentan los movimientos para el ranking si un turno restaurado no sabe qué movimiento fue; eso destapó que restaurar el estado entero bajaba la cuenta de Fit, contra RN-HF-61, y eligió A en D-109 (`carryOver`). ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) La revisión de arquitectura encontró que `UndoHistory` sacaba el turno del historial antes de restaurar, así que lo perdía si `restore` lanzaba un error (por ejemplo, llamado desde un oyente síncrono); se agregaron dos pruebas que fallaban y se corrigió. (2) También encontró un `levelId` de ejemplo con el nombre de una variante en un comentario del motor (el CI no revisa comentarios), `StateRestored` ausente del esbozo de ARQ-02 §6 y dos pruebas en un `group` que no comprobaban (RN-COM-60, D-102); todo se corrigió. (3) La revisión señaló que el historial de deshacer no se puede guardar (RN-COM-33, D-37); quedó como D-107. Claude recomendó primero guardar los comandos completos (A) y, al analizarlo para el usuario, vio que eso obligaba a cada variante con deshacer a escribir un codec de movimientos; cambió la recomendación a B y lo dijo. (4) La pregunta del usuario sobre la cuenta de movimientos encontró un conflicto entre RN-COM-61 (deshacer restaura todo, contadores incluidos) y RN-HF-61 (en Fit deshacer no resta movimientos) que el diseño de D-31 y el modelo de `engine_model.py` no habían visto; se resolvió con D-109. Una segunda revisión de arquitectura encontró que la prueba de rehacer con `carryOver` pasaba igual sin él (el estado de destino ya tenía la misma cuenta) y que la del *snapshot* tampoco distinguía nada; se reescribieron y se comprobó con una mutación del código que la de rehacer ahora falla si rehacer no aplica `carryOver`. También pidió dos pruebas más de la carga, poner al día el esbozo de ARQ-02 §5 y aclarar que `engine_model.py` no cubre D-107 ni D-109. (5) Límites del entorno: dos comandos de Bash con un *heredoc* largo fallaron sin aplicar nada, así que las ediciones grandes se hicieron con scripts en el directorio temporal; a mitad de la sesión el repositorio quedó en otra rama (`docs/aws-region`) con cambios ajenos sin commit, así que se siguió en un *worktree* aparte para no tocarlos |

### IA-49 · Plan del setup de AWS y región `us-east-2` (D-108) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 22-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); un subagente para leer la documentación de AWS |
| Prompt | Literal: "Voy a hacer el setup de AWS hazme el plan y que tengo que hacer paso a paso". Después, capturas de la consola ("estoy usando el new experience de AWS"), la región asignada y "acepto la recomendacion" |
| Resultado | Plan paso a paso de W-01 a W-06, TEC-10 y A-02, a partir de ADR-001 §2.3, SECURITY-BASELINE y los Issues. Rama `docs/aws-region` en los dos repos: D-108 en los dos `DECISIONES.md`, ADR-001 §2.3 (rev. 2.2) y el título de W-03 en `PLAN-ENTREGA.md` |
| Modificaciones del equipo | El usuario aceptó la opción recomendada: usar la región asignada, sin activar las *advanced features* |
| Lecciones | (1) El primer plan suponía la consola clásica (elegir `us-east-1`, usuario root y usuarios IAM). La experiencia nueva de AWS asigna la región y usa AWS Builder ID. Se detectó por la captura del usuario y se verificó en la documentación de AWS. (2) El agente no ejecuta `aws` ni `ssh` y no recibe claves (SEC-AGT-03), así que los pasos en la consola los hace una persona. (3) DuckDNS apunta el subdominio nuevo a la IP de quien lo crea, y hay que cambiarla mientras no exista la instancia |

### IA-50 · Revisión de los PR del motor y cómo se guarda y continúa una partida (TEC-01) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 22-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`); subagente `architecture-reviewer` |
| Prompt | Literal: "quiero que veas todos los cambios que sean hecho hoy y revises uno por uno, sabiendo el contexto general del juego, revises si no se escapo nada haciendo cada PR si falto algo o si algo va a fallar por algun mala definicion [...] dime lo que encuentres y no hagas cambios". Después: "Dime soluciones para esto", "Acepto tus recomendaciones, hazlo, mientras no rompa las reglas de arquitectura", una pregunta sobre si repetir líneas en la fábrica viola ISP y "vamos con al B" |
| Resultado | Revisión de #100 a #106 contra las reglas comunes, el Anexo A y las reglas de fin de partida, deshacer y contadores de las 4 variantes: sin errores en lo integrado, pero con huecos en cómo se guarda y continúa una partida. Issue #64, rama `feat/engine-save-continue`. En `packages/hexa_engine/lib/src/`: `GameEngine.paused` (D-111); `session/saved_game.dart` (`SavedGame<TState>`) y `GameSession.snapshot()`, que guarda `UndoHistory` y `ActiveTimer` con su tipo y los muestra como `IUndoable?` e `ITimed?` (D-113). 270 pruebas en `hexa_engine` (10 nuevas). Decisiones D-110 a D-116 cerradas. Documentos: RN-COM-33 a 35, RN-HF-31, RN-HM-51 y 83, HF-03, ARQ-01 a ARQ-04, `EXTENSIBILITY.md`, los cuatro `.puml`, la trazabilidad de RF-05 y RF-64, y la restricción de `TCell` en el README |
| Modificaciones del equipo | El usuario aceptó todas las recomendaciones (A en D-110, D-111, D-112, D-113 y D-115; B en D-114). En D-116 preguntó si repetir líneas en cada fábrica era violar ISP; Claude explicó que es un tema de DRY y no de ISP, y el usuario eligió B (`continueSession`). ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) La revisión encontró lo que ningún PR veía por separado: el motor siempre arrancaba en juego y no evaluaba el estado, y el caso de uso guardaba también el turno que termina la partida, así que un guardado encolado después del borrado reabría una partida terminada (D-110). (2) La revisión de arquitectura encontró que ARQ-03 no guardaba al pasar a segundo plano, contra RN-COM-33 y D-37, y que en Fit eso permitía ganar la estrella de tiempo cerrando la app; se corrigió sin decisión nueva porque la regla ya lo pedía. También encontró que no estaba definido cómo llega la partida guardada a la fábrica, que quedó como D-116. (3) Claude había llamado `SessionSnapshot` al tipo nuevo; el glosario compartido y el puerto del repositorio ya usaban `SavedGame`, así que se renombró antes de integrar, sin tocar documentos compartidos. (4) Durante la sesión, otra sesión integró el PR 5 (#106) y quitó su *worktree*: se comprobó que los cambios sin commit que había visto ya estaban en `main` antes de seguir. (5) `check_contracts.py` no corre en local por falta de `yaml`; este PR no toca `docs/contracts/` |

### IA-51 · Próximos pasos, Hexa Lines asignada y reporte privado de vulnerabilidades (D-78, G-05) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 22-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "Ok que es lo siguiente que deberia hacer?". Después: "Sí, empieza con G-05 y G-07, hexa lines damelos a mi" |
| Resultado | Prioridades a partir de los milestones y los Issues abiertos: D-78 sin cerrar con Hexa Lines sin responsable a 8 días del fin de M1, y 7 Issues de M0 que vencen el 23-11. HL-01 a HL-06 (#32 a #37) asignados a @DanielHaro28, con el responsable en su descripción; rama `docs/assign-hexa-lines`: `PLAN-ENTREGA.md` §1, horas y tabla de M1, y la nota de D-78 en `PENDIENTES.md` (sigue abierta para Fit, Sort y Merge). G-05: los dos `SECURITY.md` ya existían (#84), pero remitían al *Private vulnerability reporting*, que estaba desactivado; se activó en los dos repos |
| Modificaciones del equipo | El usuario eligió tomar Hexa Lines |
| Lecciones | (1) G-05 parecía hecho porque el archivo existía; solo al consultar la API de GitHub se vio que el botón que el archivo indica no estaba activo. (2) G-07 pide `commitlint`, que es de Node, en un repo de Dart, y en `hexablock-api` todavía no hay `package.json` (T-04 está abierto); como obliga a decidir algo, se propusieron opciones antes de escribir código |

### IA-52 · Instancia EC2 lanzada y endurecida, y sus decisiones (W-01 a W-06, D-117 a D-122) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "que me quedan de mi issue de AWS?". Después: "W-01 esta listo, W-03 que tengo que hacer por que ya tengo el dominio de duckdns pero no el IP todavia", "no pienso pagar mas dinero por el proyecto", "vamos a usar la IP elastica no quiero estar cambiando lo del dns", "nunca e lanzado una EC2 [...] tienes que explicarme paso a paso", "vamos a hacer W04", "subir esa clave ahi no es malo?" y "agrega esas 2 cosas y sigamos con W06 paso a paso". El usuario envió capturas de la consola de AWS, de GitHub y de las terminales en cada paso |
| Resultado | Guía paso a paso, revisando cada captura, para lanzar la `t3.small` (`i-0b8ac57d2e03c2f4a`, Ubuntu 24.04, 20 GiB gp3, IMDSv2, sin rol IAM, créditos `standard`) con la IP elástica `16.59.192.154` y `hexablock.duckdns.org`; endurecer SSH (`PermitRootLogin no`, solo clave) y verificar `unattended-upgrades` por EC2 Instance Connect; y crear el Environment `production` con `EC2_HOST` y `EC2_SSH_KEY`. Issues cerrados con su resumen: W-01 a W-04 y W-06 (api #19 a #22 y #24). Casilla de @DanielHaro28 en A-02 (app #74). Notas en TEC-10 (api #16) y W-05 (api #23). Rama `docs/ec2-launch-decisions` en los dos repos: D-117 a D-120 en los dos `DECISIONES.md`, y D-121 y D-122 abiertas en `PENDIENTES.md` |
| Modificaciones del equipo | Claude recomendó primero una IP elástica y después la automática, cuando el usuario dijo que no quería gastar más. El usuario eligió la elástica para no tener que actualizar DuckDNS (D-117). El usuario preguntó si subir la clave a GitHub era un riesgo; aceptó la explicación y pidió registrar las dos mitigaciones propuestas (D-121 y D-122). Aceptó las recomendaciones de D-118 y D-119. ⚠️ El equipo confirma D-117 a D-120 en la revisión del PR |
| Lecciones | (1) Varios valores por defecto de la consola contradecían el ADR o SEC-WEB-01: Ubuntu 26.04, disco de 8 GiB, créditos `Unlimited` ("Additional charges apply") y un Security Group sin HTTP ni HTTPS. Se detectaron porque el usuario mandó una captura antes de cada clic importante. (2) Claude anticipó que `sshd -T` mostraría el `AuthorizedKeysCommand` de EC2 Instance Connect, pero mostró `none`, porque Instance Connect pasa esa opción al arrancar el servicio. Abrir una segunda sesión de Instance Connect antes de cerrar la primera confirmó que no se había perdido el acceso. (3) El agente nunca vio la clave: las reglas le impiden leer `*.pem` y ejecutar `ssh` y `aws`. El usuario la copió del archivo a GitHub, la borró y comprobó que no quedaran copias ni `~/.aws`. Claude verificó con la API de GitHub solo los nombres de los secretos. (4) La API de GitHub mostró que el Environment quedó como `Production`; los nombres de Environment no distinguen mayúsculas, así que funciona igual. (5) `/ai-usage` solo lo puede invocar el usuario |

### IA-53 · Orden de los Issues pendientes, Dependabot, workflows de forks y CI obligatorio (G-03, G-06, G-10) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "Ok ya estoy listo para los Issue que me quedan, hazme un lista de cuales son". Después: "Ok perfecto, ahora dime en que orden deberiamos hacerlo" y "Cerremos primero la rama actual, G1 ya esta listo, y vamos con la Fase 1." |
| Resultado | Lista de los 26 Issues abiertos del usuario en los dos repos y un orden en cuatro fases según los milestones y sus dependencias (G-10 después de TEC-04, TEC-02 después de las 4 variantes, R-05 después del APK firmado). Rama `docs/ec2-launch-decisions`: PR app #109 y api #43 con el CI en verde, a la espera de la revisión de otra área (D-62); el cambio de `clases-motor.puml` se guardó en un *stash* para R-04 (#23). G-06 (#18): la aprobación de workflows de forks pasó de "primeros contribuidores" a "todos los colaboradores externos" en los dos repos, como pide SECURITY-BASELINE §7. G-03 (#16): secret scanning y push protection ya estaban activos; se activaron las alertas y las actualizaciones de seguridad de Dependabot en los dos repos, y la rama `ci/dependabot-version-updates` agrega `.github/dependabot.yml` (app: `pub` en la raíz del workspace, `npm` para las herramientas de commits (G-07) y `github-actions`; api: `npm`, `docker` y `github-actions`), con prefijos de commit que pasan el chequeo de título Conventional Commits. G-10 (#20): el ruleset `protect-main` exige ahora, con la rama actualizada, `pr-title`, `flutter`, `apk` y `docs` en la app, y `docs` en la api (lint, pruebas y contrato se agregan con TEC-04, api #14). Además se dejó solo *squash*, como pide SECURITY-BASELINE §7: el ruleset también permitía *merge* y *rebase*. TEC-04 de la app (#12): solo le faltan la validación de commits (G-07) y el environment `release` con el keystore, que crea una persona (SEC-MOB-07, T-06) |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | (1) SECURITY-BASELINE §7 pide aprobación para todos los colaboradores externos, pero los repos tenían el valor por defecto de GitHub (solo primeros contribuidores); se vio al consultar la API, no en la interfaz. (2) Los títulos por defecto de Dependabot ("Bump x from a to b") no pasan el job `pr-title`; por eso `commit-message.prefix`. (3) En `hexablock-api` aún no hay `package.json` ni `Dockerfile` (T-04, api #41), así que Dependabot marcará error en `npm` y `docker` hasta que se integre. (4) El modo automático bloqueó cerrar G-01 (#83) desde la terminal; lo cierra el usuario. (5) El ruleset decía permitir los tres métodos de integración aunque el equipo había acordado solo *squash*; se vio al leer el ruleset por la API antes de agregarle los checks |

### IA-54 · `commitlint` y `lefthook` en la app (G-07, D-123) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Continuación de la sesión de G-03, G-06 y G-10 ("vamos con la Fase 1"). Claude propuso tres opciones para instalar `commitlint` en un repo de Dart y dos para la mitad de la API; el usuario eligió "package.json solo de dev" y "PR aparte tras #41" |
| Resultado | D-123 en `DECISIONES.md`. `package.json` privado con `@commitlint/cli` 21.2.4, `@commitlint/config-conventional` 21.2.4 y `lefthook` 2.2.2 (verificados en npm: licencia MIT, repositorios oficiales y más de 10 millones de descargas por semana; SEC-AGT-04), y `package-lock.json`. `commitlint.config.mjs` (Conventional Commits y *scope* en `kebab-case`, como la regex anterior), `lefthook.yml` con el hook `commit-msg`, el job `pr-title` de `ci.yml` con el mismo `commitlint` en vez de la regex, y el README (versión de Node y `npm ci`). La mitad de `hexablock-api` queda para cuando se integre T-04 (api #41) |
| Modificaciones del equipo | ⚠️ completar |
| Lecciones | (1) `config-conventional` no exige el *scope* en minúsculas que exigía la regex del CI (`fix(Engine)` pasaba); se agregó `scope-case`. (2) En cambio, sí rechaza un asunto que empieza con mayúscula (`feat: Add thing`), que la regex aceptaba; de los 38 títulos de `main` solo falla `Initial commit`, anterior a la regla. (3) Se leyó el `postinstall` de `lefthook` antes de ejecutarlo: solo corre `lefthook install` y no lo hace en CI; el CI instala con `--ignore-scripts` |

### IA-55 · Interfaz `VariantFamily` y `NewGameOptions` en el motor, antes de HL-01 (TEC-01, D-124) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel del pedido: implementar Hexa Lines (HL-01 a HL-06, #32 a #37), una historia por PR y en orden, con `/implement-story`. HL-01 es la primera fábrica de variante: sigue D-116 y escribe `checkVariantFamilyContract`. La variante solo implementa los pasos del turno (D-36) y no cambia el motor: si al motor le falta algo, detenerse y proponer opciones, porque ese cambio va en su propio PR. No tocar TEC-01 (#64). Cada `E-HL-*` es una prueba y no se inventan reglas. Si falta una pantalla, proponer opciones y esperar. Si el PR anterior no está integrado, crear la rama desde la suya. Al terminar, `architecture-reviewer`, PR con la plantilla y la entrada de `AI_USAGE.md` con el siguiente ID libre. Respuesta del usuario a las 5 propuestas, literal: "Me gusta las recomendaciones, las pruebas tienes que estar bien hechas, Un PR por Issue, aunque estamos haciendo una variante debe haber la posibilidad hacer las otras variantes, una pregunta aqui se van a hacer los casos de uso y si es asi van a ser genericos para manejar los tipos de juegos?" |
| Resultado | Antes de escribir HL-01, Claude encontró que `VariantFamily` no existía en el código y que `createSession(options)` no tenía tipo: el `StartOptions` de ARQ-03 es de la capa 2 y la interfaz es de la capa 1. Propuso 5 decisiones con opciones (dónde vive `VariantFamily` y qué recibe una partida nueva, el color de la pieza, el formato del catálogo, la bandeja y qué hacer sin la pantalla de NAV-01). PR #112 (rama `feat/tec-01-variant-family`, `Refs #64`): `VariantFamily<C, TCell, TMove, TState>` y `NewGameOptions` en `hexa_engine/lib/src/session/`, `Xorshift32.maxSeed` público y 6 pruebas en `group('D-124')`. D-124 cerrada y D-125 abierta en PENDIENTES (cómo llega el nivel a la fábrica de Fit y Sort). ARQ-02 (§2, §3.1, §9.1, §11, §12), ARQ-03 §3 y los tres `.puml` de clases actualizados. Claude respondió que los casos de uso (capa 2, `hexa_application`) son genéricos, uno por tipo para las 4 variantes (RNF-07), y que no son parte de las historias HL |
| Modificaciones del equipo | El usuario aceptó las 5 recomendaciones (A en todas) y pidió pruebas bien hechas, un PR por Issue y que el diseño deje hacer las otras variantes. ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) Un diseño documentado (D-100, D-116) no garantiza que el código exista: hay que buscarlo antes de planificar la historia que lo usa. (2) El `architecture-reviewer` encontró que la primera versión de D-124 prometía poner el nivel en `NewGameOptions`, que no puede llevar el nivel propio de cada variante sin un *cast* o un genérico más. Se dejó abierto como D-125 en vez de decidirlo sin el equipo. (3) Cambiar una firma obliga a revisar también los `.puml` y los esbozos de los documentos, no solo el código |

### IA-56 · Skills de revisión de código y aprobación de `skill-creator` (D-126) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel: el usuario preguntó si se podía hacer una skill de revisión de código después de implementar y otra que revise los PR, que hicieran su trabajo lo mejor posible, y pidió opciones. Después pidió revisar que el código no tuviera castings, valores fijos ni dependencia de una geometría particular, y también todo el código implementado hasta ese momento. Preguntó si había un plugin para hacer skills, y pidió: "registra la P-xx con la opción A". Por último: "por que en pendiente? si es una desicion y haz el commit mas PR" |
| Resultado | Cuatro opciones para las skills de revisión (ligera, coordinada con verificación, sobre `/code-review`, en el CI), con la coordinada como recomendada. Qué cubren hoy `analysis_options.yaml` y `tool/check_architecture.dart` y qué falta para castings, valores fijos y geometría. Dos opciones para `skill-creator`. D-126 cerrada en `DECISIONES.md` de los dos repos y la sección "Ayudas para crear skills" en `docs/ai/APPROVED-TOOLS.md` (compartido), en dos PR enlazados. Revisión de las skills existentes con los criterios de `skill-creator` y lista ordenada de 15 skills y agentes, con D-127 cerrada y D-128 (horas en el tablero) abierta. Las skills todavía no se escriben |
| Modificaciones del equipo | El usuario eligió la opción A y cerró la decisión directamente, sin dejarla abierta en `PENDIENTES.md`. Confirmó las recomendaciones de D-127 y corrigió el lugar de los casos de prueba (en el repo y no fuera, como decía la primera versión de D-126) |
| Lecciones | (1) Claude llamó `P-xx` a la decisión, pero en este proyecto `P-*` son las preguntas al profesor; se registró como `D-126`. (2) Claude la dejó abierta en `PENDIENTES.md` aunque el usuario ya la había decidido; el usuario lo corrigió y se pasó a `DECISIONES.md`. (3) La rama de TEC-01, que todavía no se integra, ya usa la decisión y la entrada de este archivo que siguen a las de `main`: para no reutilizar IDs se revisaron todas las ramas de los dos repos, no solo `main`. (4) Una búsqueda rápida de `is` en el motor encontró 9 casos, todos dentro de `operator ==`: una regla que solo busque el patrón daría falsos positivos, y por eso la propuesta combina la herramienta con un revisor que tenga criterio |

### IA-57 · `/ai-usage` sin IDs repetidos: `next_id.py` y evaluaciones con `skill-creator` — compartido

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel: el usuario pidió revisar las skills existentes y las que quería crear "usando la nueva skill" (`skill-creator`), y que las reglas de los documentos guiaran qué agregar. Confirmó la lista ordenada de skills con "ok, confirmo los supuestos, empieza con el 1"; después de ver los resultados pidió "aplica las correcciones" y "sigamos" |
| Resultado | `tools/docs-check/next_id.py`, que da el siguiente ID libre revisando todas las ramas locales y remotas de los dos repos y los archivos sin commit (solo Markdown fuera de `.claude/`), con 13 pruebas. `/ai-usage` reescrita en los dos repos: usa el script, corre `check_ids.py` antes del commit, no cita IDs de ramas sin integrar, agrega las fuentes de §5, lista los `⚠️` pendientes, solo cambia `AI_USAGE.md` y pone el Issue en vez del PR. Tres casos de prueba en `.claude/skills/ai-usage/evals/` con un generador de repos de juguete. Dos iteraciones de evaluación: la skill nueva pasó 18 de 18 y 20 de 20; la anterior, en un repo sin el script, 14 de 18 y 19 de 20. Sin Issue: es la primera tarea de la lista de skills acordada el 23-11 |
| Modificaciones del equipo | El usuario confirmó las recomendaciones del plan, eligió escribir los casos de prueba uno por uno con confirmación cuando el sistema de permisos rechazó crearlos con un script, y aprobó las tres correcciones de la primera iteración. ⚠️ completar con lo que ajuste quien revise las pruebas del script (D-59) |
| Lecciones | (1) Las primeras corridas de la skill anterior usaron `next_id.py` porque el repo de juguete ya lo tenía: la línea base no era justa y se repitió sin el script. (2) Sin el script, la skill anterior eligió un ID repetido en una corrida y acertó en la otra: con una corrida por caso, la diferencia apenas se ve en el promedio. (3) En la primera iteración la skill nueva editó código (`shuffle.dart`) porque leyó una frase como una orden, y dejó pendiente el número de PR en las tres corridas; se corrigió y la segunda iteración lo confirmó. (4) El propio script contaba como usados los IDs de ejemplo: primero uno en su comentario y después otro en la nueva `SKILL.md`; ahora solo cuenta Markdown fuera de `.claude/`. (5) El calificador castigaba dos veces el mismo ID equivocado; se corrigió antes de comparar |

### IA-58 · `/new-variant`: los pasos que faltaban y las listas fijas de variantes — solo app

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "sigue con el número 2" (corregir `/new-variant` según la lista de skills acordada el 23-11) |
| Resultado | `/new-variant` reescrita: el paso del backend, el contrato (el `enum` de `gameId` en `common.schema.json`, que la guía no menciona), las herramientas con la lista de variantes fija (`check_architecture.dart`, `check_ids.py`, `levelcheck.py`, `check_examples.py`), los textos es/en, el diseño, los niveles y su copia en la API, el diagrama de clases, la trazabilidad y una comprobación final con `git diff` que también cubre las otras 4 variantes. Dos casos de prueba de `skill-creator` que evalúan el plan del paso 0 sobre clones de los dos repos: la skill nueva sacó 13 de 14 y la anterior 10 de 14 (le faltaron el diagrama, los prefijos de `check_ids.py` y la copia de los niveles). Sin Issue |
| Modificaciones del equipo | Ninguna sobre la skill. El usuario decidió no seguir evaluando cada skill por el costo y reducir la lista |
| Lecciones | (1) La guía `EXTENSIBILITY.md` promete menos cambios de los reales: una 5ª variante también cambia el contrato, cuatro herramientas, una regla común cerrada y varios documentos; queda como decisión del equipo. (2) La skill anterior encontró sola la mayor parte porque el modelo lee el código; la diferencia estuvo en lo que omitió. (3) Una afirmación de la evaluación pedía reutilizar un modelo de récord que todavía no existe en `main`; se reescribió. (4) Cada skill evaluada con línea base y dos iteraciones costó entre 6 y 9 corridas completas: demasiado para el tiempo que queda |

### IA-59 · Lista de skills reducida, revisor de arquitectura ampliado y ensayo de la defensa (D-129, T-08) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "vale la pena seguir haciendo estos skills ya se me fue el limite de laconversacion haciendo 2". Después: "Ok hagamos lo que ya esta esos que valen la pena y los demas en una lista si queda tiempo" |
| Resultado | D-129 (precisa el orden de D-127): solo se hacen las skills que valen la pena para la entrega. `architecture-reviewer` revisa también castings, suposiciones de una geometría particular y valores fijos (lo que se quería de un `genericity-reviewer`). Skill nueva `/defense-rehearsal`: un cambio de regla con tiempo medido en un *worktree* desechable y preguntas de diseño comparadas con los documentos. El resto de la lista quedó en T-08 (#116). D-130 abierta: `EXTENSIBILITY.md` promete menos cambios de los reales para una 5ª variante. `CLAUDE.md` lista la skill nueva |
| Modificaciones del equipo | El usuario decidió reducir la lista y dejar el resto para si sobra tiempo. ⚠️ completar con lo que ajuste quien revise el agente y la skill |
| Lecciones | (1) Evaluar cada skill con línea base y dos iteraciones consumió la mayor parte de la conversación: las evaluaciones convienen cuando corrigen un error que ya pasó, como el ID repetido de `/ai-usage`. (2) Varias de las skills planeadas ya las cubren herramientas existentes (`/code-review` de Claude Code y los dos revisores del proyecto) |

### IA-60 · Hexa Lines: empezar una partida sin fin (HL-01, #32, D-131 a D-134) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "/implement-story HL-01"; después de ver el plan: "Ok, pero commit 112 esta listo" (el PR #112 ya estaba integrado, así que la rama sale de `main` y no apilada). Antes, en la misma conversación: "usar nuvos skills para la HL-01 que esta en PR", "revisa el codigo del PR y ve si esta bien estructurado y si esta bien el el conetxto general" y "Resuelve con main y sube la rama" (revisión de #112 con el `architecture-reviewer` ampliado y conflicto con `main` resuelto) |
| Resultado | Rama `feat/hl-01-endless-game` (Issue #32). En `hexa_variants/lib/src/hexa_lines/`: `PieceColor`, `LinesPiece`, `LinesFamily` y `LinesConfig` (catálogo con la forma base de cada familia; las orientaciones las da la topología), `LinesPieceSource` (RN-HL-24) y `drawTray`, `LinesState` con 3 casillas fijas, `PlacePiece`, `PiecePlaced`, `HexaLinesRules` (colocación: `rejectionOf`, `apply`, `validMoves`) y `HexaLinesFactory`. En `hexa_test_support`: `checkVariantFamilyContract` (D-116), que comprueba partida nueva, semilla, continuar en pausa, volver a jugar y la ida y vuelta de `snapshot()` con historial de deshacer y rehacer y tiempo activo. 50 pruebas en `hexa_variants/test/hexa_lines/`, entre ellas E-HL-3 y la variante sobre una topología falsa de dos tipos de celda (RNF-04); cobertura del dominio 95,7 %. D-131 a D-134 en `DECISIONES.md`; ARQ-02 §4.2 y §12 y `05-TRAZABILIDAD.md` (RF-20, RF-21, E-HL-3) actualizados; E-HL-3 sale de `tool/examples_pending.txt` |
| Modificaciones del equipo | El usuario eligió la opción recomendada en las 4 decisiones que Claude volvió a proponer: color fijo por familia (D-131), HL-01 solo dominio con el JSON, el *mapper* y la pantalla para el Issue de la interfaz (D-132), bandeja de 3 casillas fijas (D-133) y la colocación incluida en HL-01 (D-134). El equipo revisó las pruebas (D-59) |
| Lecciones | (1) IA-55 decía que el usuario había aceptado 5 decisiones para HL-01, pero solo D-124 llegó a `DECISIONES.md`: las otras 4 no estaban en ningún documento ni en la memoria y hubo que proponerlas de nuevo. Una decisión aceptada en la conversación se registra en el mismo PR (D-85). (2) Antes de confiar en que `topology.orientations()` diera el orden de la tabla de RN-HL-23 (del que depende RN-HL-24), Claude lo comprobó con un script aparte y después con una prueba. (3) Los valores esperados de RN-HL-24 se calcularon con un xorshift32 independiente en Python, para no repetir en la prueba el código que se prueba; dos mutaciones del código confirmaron que las pruebas fallan. (4) La revisión del `architecture-reviewer` mejoró sobre todo las pruebas y el contrato, pero una de sus sugerencias (hacer `const` las reglas) era un error que solo detectó el contrato al ejecutarse |

### IA-61 · Integración de los PR abiertos y títulos de Dependabot en commitlint (D-135) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "Resuelve mis PR y mergea"; a mitad del trabajo: "acuerdate de no borrar ramas". Después: "todavia queda un PR ahi que es eso?" y "dale con la B" |
| Resultado | Se integraron con *squash* #118 (HL-01), #109 con api#43 (decisiones del EC2), #110 con api#44 (Dependabot) y #111 (`commitlint` y `lefthook`). Los conflictos estaban en `AI_USAGE.md` (las entradas IA-52 a IA-54 iban en el mismo lugar; se ordenaron por número con un script que parte de la versión de `main` y agrega solo lo de cada rama) y en `PENDIENTES.md` (se conservaron las dos fechas y todas las decisiones abiertas). El job `docs` de #109 fallaba porque clona la rama de la API con el mismo nombre, que estaba atrás de `main`: se actualizaron también las ramas gemelas de la API. El PR que quedaba era el #120, el primero de Dependabot, rechazado por `subject-case`; D-135 hace que `commitlint.config.mjs` ignore solo los títulos con la forma de Dependabot, probado con títulos del equipo y de Dependabot. Sin Issue (mantenimiento del CI y una decisión) |
| Modificaciones del equipo | El usuario pidió no borrar las ramas y eligió la opción B de las tres que propuso Claude para los títulos de Dependabot (A: renombrar cada PR a mano; C: desactivar `subject-case`). Ninguno de los PR integrados tenía la revisión de otra área (D-62): ⚠️ completar con quién los revisó |
| Lecciones | (1) Claude integró con `--delete-branch` y borró 5 ramas antes de que el usuario pidiera conservarlas; se restauraron desde el último commit de cada PR. (2) El CI de `docs` de un PR compartido depende de que la rama del otro repo esté al día, y un PR gemelo puede fallar solo por el orden en que se suben las dos ramas: se sube una, se espera y se vuelve a correr el otro. (3) `config-conventional` rechaza los títulos que genera Dependabot, algo que la regex anterior del CI aceptaba; se vio con el primer PR de Dependabot, no al revisar #111 |

### IA-62 · Estructura común de la partida (TEC-11, D-136) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | `/implement-story HL-02`. Después, ante la propuesta de un Issue habilitador: "Ese issue no tiene dueño? o es nuevo issue?" y "sí, TEC-11 asignado a mí, dale"; ante la pregunta de cómo entrar a la partida sin NAV-01: "Explicame bien". Tras un cierre de VS Code a mitad del trabajo: "sigue que por error cerre vs code". Al final preguntó si el PR traía los aspectos, porque ahí va el logger |
| Resultado | HL-02 no se podía implementar: en `main` no había pantalla, casos de uso de partida, `GameCubit` ni `BoardView`, y ningún Issue los tenía. Se creó TEC-11 (Issue #122) y se registró D-136. La rama `feat/tec-11-game-structure` agrega: en la capa 2, `UseCase`, `StartGameUseCase`, `ApplyMoveUseCase`, el puerto `ISavedGameRepository`, las claves de partida, los errores y `Result` de D-39 y `ErrorHandlingAspect`; en `hexa_test_support`, `FakeSavedGameRepository` y `FakeVariantFamily`; en la capa 3, `GameCubit` genérico, el mapper de `assets/config/hexa-lines.json` y un repositorio de partidas en memoria; en la capa 4, `TopologyLayout` y `HexLayout`, `BoardGeometry`, `BoardView`, `ShapeView`, `GamePage` con las cinco ranuras del diseño, el pintor y la bandeja de Lines, los tokens del tema, los registros tipados de topologías y variantes, `HexaLinesModule` y la configuración de l10n (ARB en es y en). `main` abre Hexa Lines directamente. Dependencias nuevas de ADR-001, revisadas en pub.dev: `flutter_bloc`, `get_it`, `intl`, `flutter_localizations` y `bloc_test`. 22 pruebas en la capa 2 y 35 en la app; cobertura de la capa 2 al 100 %. Se corrigió además la comprobación de paridad de ARB de `tool/check_architecture.dart` |
| Modificaciones del equipo | El usuario eligió una opción "Other" sin texto en la primera pregunta (se le volvió a preguntar), aceptó crear TEC-11 asignado a sí mismo con @dicpc de revisor, y eligió: que `main` abra Lines hasta NAV-01 (después de pedir una explicación más clara de las dos opciones), el puerto de partidas guardadas con un adaptador en memoria, `Result` con `ErrorHandlingAspect` desde ya, y dejar anotado que no se puede continuar una partida hasta PRG-03 en lugar de adelantar el codec. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59), que las aprobó sin cambios |
| Lecciones | (1) La historia citaba una decisión (D-134) que daba por hecho una pantalla inexistente; leer el código antes de planear evitó empezar HL-02 sobre nada. (2) Dentro de un mapa `Map<String, TopologyEntry<Coord>>`, Dart infiere `TopologyEntry<Coord>` y la partida se abría con `C = Coord`, sin error de compilación; lo detectó la prueba de widget y se cambió por un registro con `add<C>()`, con una prueba propia. (3) El `GameCubit` y su estado se escribieron antes que sus pruebas, contra la regla de pruebas primero; el resto de la rama sí fue pruebas primero. (4) La revisión de arquitectura encontró que `StartGameUseCase` borraba la partida guardada antes de crear la nueva, tamaños fijos en las pantallas y un tipo común que dependía del mapper de Lines; se corrigieron en la misma rama. (5) `flutter pub add` quedó colgado en el sandbox sin acceso a pub.dev y hubo que lanzarlo con red |

### IA-63 · División de historias grandes en PR apilados (D-137) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "Pregunta relaciona Es normal meter tantos commits en un solo PR o seria mejor hacer varios PR con menos commits ya que estoy viendo que son muchos cambios no?". Después: "agregaa la propuesta a desiciones con la desicion que se divide PR apilados con subtareas del issue" |
| Resultado | D-137 en `docs/DECISIONES.md` de los dos repos, con el mismo texto: una historia o tarea de más de unas 8 h, o de más de unas 600 líneas previstas, lleva subtareas en su Issue y cada una va en su propio PR, apilado sobre el anterior; cómo se rebasa e integra cada uno, y que solo el último cierra el Issue. Sin Issue (una decisión del flujo de trabajo) |
| Modificaciones del equipo | Claude explicó que la cantidad de commits no era el problema (se integra con *squash*), sino el tamaño del PR de TEC-11 (unas 3.000 líneas), y propuso dividir las historias grandes en PR apilados. El usuario la tomó como decisión cerrada y eligió que las partes sean subtareas del mismo Issue en lugar de Issues nuevos. Los umbrales de 8 h y 600 líneas son la propuesta de Claude, aceptada sin cambios |
| Lecciones | (1) La regla "un Issue por PR" ataba el tamaño de un PR al de su Issue; el problema apareció recién con el primer PR grande (#123). (2) La línea de CLAUDE.md que dice "Un Issue por PR" queda desactualizada hasta que se cambie; es configuración del agente (SEC-AGT-05) y no se tocó sin el visto bueno del usuario |

### IA-64 · Regla de PR apilados en CLAUDE.md y arreglo de docs-check (D-137) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "sí, arregla el script y abre los PR"; después: "Hazlo en uno aparte, y haz mergue si puedes de los 2 que creaste" y "Acuerdate de no borrar ramas." |
| Resultado | (1) `tools/docs-check/check_ids.py` y `check_tables.py` se saltan `node_modules/`; iba en los PR de D-137 (app #124 y api #50), que se integraron con *squash* cuando el CI pasó, sin borrar las ramas. (2) En una rama aparte, `CLAUDE.md` de los dos repos: la regla "Un Issue por PR" ahora dice que un PR nunca mezcla dos Issues, y una línea nueva remite a D-137 (umbral de 8 h o 600 líneas, subtareas en el Issue, PR apilados, `Refs #n` y solo el último cierra el Issue). Sin Issue (aplica una decisión) |
| Modificaciones del equipo | El usuario pidió el cambio de `CLAUDE.md` en un PR aparte del de D-137, como propuso Claude por ser configuración del agente (SEC-AGT-05), pidió integrar los dos PR de D-137 y recordó no borrar ramas. El usuario avisó al equipo del cambio de `CLAUDE.md` antes de integrarlo (SEC-AGT-05) |
| Lecciones | (1) `check_ids.py` recorría cualquier `.md` salvo `.git`, así que una instalación local de npm en `hexablock-api` metía los README de los paquetes y marcaba como no definidos textos de esos README con forma de ID; en el CI no pasaba porque ahí no hay `node_modules`. `check_tables.py` tenía el mismo hueco y pasaba de casualidad. (2) Un PR que cita una decisión tiene que salir de `main` después de que esa decisión se integre: si no, `check_ids.py` la marca como no definida. Por eso el cambio de `CLAUDE.md` esperó a #124 y #50. (3) En la API, el CI de un PR solo de documentos corre únicamente el job `docs` |

### IA-65 · Cierre del reparto del equipo (D-78) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "Merge David y fit dicpc y dejame sort, progreso y caoss de uso dejamelos a mi por ahora. Lo del lado de APP de la cuenta en es la APP? R02 dejamelo a mi T08 a mi"; después: "Damelos a mi los de API, y estaria todo asignado" |
| Resultado | D-78 cerrada en `docs/DECISIONES.md` de los dos repos y quitada de `docs/PENDIENTES.md`. Hexa Merge (HM-01 a HM-05) para @DavidCR20; Hexa Fit (HF-01 a HF-06) para @dicpc; Hexa Sort (HS-01 a HS-05), el progreso (PRG-03, PRG-04), los casos de uso (TEC-03, API-05, API-06, API-08, LVL-01), la parte de la app de la cuenta (API-03, API-07), R-02 y T-08 para @DanielHaro28. En GitHub se asignaron los 27 Issues y se cambió su línea "Responsable"; no queda ningún Issue abierto sin responsable en los dos repos. `PLAN-ENTREGA.md` (tabla del equipo y responsable de cada Issue), `.github/CODEOWNERS` (una línea por carpeta de variante; casos de uso y persistencia para @DanielHaro28) y `tools/planning/issues_created.json` siguen el mismo reparto. Sin Issue (una decisión del equipo) |
| Modificaciones del equipo | El usuario decidió el reparto. Preguntó si la cuenta era de la app; Claude explicó que API-03 tiene su mitad del servidor (de @DavidCR20) y API-07 es solo de la app, y propuso API-03 para el usuario y API-07 para @dicpc; el usuario se quedó con los dos. Claude agregó a `CODEOWNERS` las carpetas de cada variante y pasó a @DanielHaro28 la persistencia del progreso, que tenía @DavidCR20 desde D-62 |
| Lecciones | (1) `issues_created.json` estaba desactualizado: Hexa Lines figuraba sin responsable aunque en GitHub estaba asignado desde el 22-11, y T-08 no estaba en el archivo y tampoco tenía responsable en GitHub, aunque el plan lo nombraba. (2) `assign_pending.py` recorre los 87 Issues y no terminó en 5 minutos con la API lenta; se asignaron directamente solo los que cambiaban. (3) Un corte de conexión hizo que el script que editaba los cuerpos leyera un cuerpo vacío y lo escribiera así en #52 (HM-04); se detectó al verificar los 26 Issues después de editarlos y se restauró desde el historial de ediciones de GitHub. Un script que reescribe datos remotos tiene que negarse a escribir si lo que leyó no tiene la forma esperada |

### IA-66 · Consulta de validez para la vista previa (HL-02, parte 1 de 2) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | `/implement-story HL-02`; después del plan: "Ok empieza" |
| Resultado | Issue #33, primera subtarea (rama `feat/hl-02-check-move`). Claude vio que el dominio de la colocación ya estaba en `main` (D-134) y que la vista previa necesitaba preguntar si un movimiento es válido sin jugarlo, algo que el motor no ofrecía; propuso opciones y se registró D-138. En la capa 1, `IGameRules.rejectionOf` pasa a la interfaz y `GameEngine.check(move)` da el motivo que daría `submit` (la fase o las reglas) sin cambiar ni publicar nada. En la capa 2, `CheckMoveUseCase` genérico. En la capa 3, `GameScreenState` gana el parámetro `TMove`, `GameReady` lleva un `MovePreview` y `GameCubit` agrega `preview` y `clearPreview`, que descartan la respuesta de una consulta adelantada por otra llamada; `HexaLinesModule` lo conecta. Pruebas: 6 del motor, 3 del caso de uso y 11 del Cubit, todas del grupo D-138. Documentos: D-138, ARQ-02 (tabla, diagrama, §9.6, §12), ARQ-03 (§3, §4 y la matriz de aspectos) y la trazabilidad de RF-21. Se agregaron al Issue las dos subtareas de D-137 |
| Modificaciones del equipo | El usuario eligió las cuatro recomendaciones de Claude entre las opciones propuestas: la consulta genérica en el motor con caso de uso (se descartaron que el *widget* llamara a las reglas y precalcular los movimientos válidos), un color de error para la posición inválida hasta que @dicpc lo confirme, dividir HL-02 en 2 PR apilados y, para `CheckMove`, errores y métricas sin registro (lo planteó el `architecture-reviewer`). Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) La historia decía "vista previa válida o inválida", pero ningún documento decía de dónde sale la validez sin jugar el movimiento; apareció al leer `GameEngine` antes de planear. (2) El `architecture-reviewer` encontró que D-138 citaba una sección de ARQ-02 que no existe, que `check` respondía con el motor cerrado y que faltaban casos de concurrencia de la vista previa; se corrigieron en la rama con 5 pruebas más. (3) Una prueba nueva del Cubit falló porque el doble lanzaba en `applyMoveFor`, que el Cubit llama al empezar: era un error de la prueba, no del código |

### IA-67 · Arrastrar una pieza al tablero con vista previa (HL-02, parte 2 de 2) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "sigue con el PR 2" |
| Resultado | Issue #33, segunda subtarea (rama `feat/hl-02-drag-piece`, sobre la de la primera). En la capa 4: `BoardPreview` y su pintor, un *decorator* para envolver el tablero dibujado, `BoardGeometry.atScale` y `PieceDrag` (dónde va la pieza respecto del dedo y cuál es su celda ancla), genéricos en `frameworks/ui/board/` para que Hexa Fit los reuse; `GamePage` recibe `previewOf` y `boardDecoratorOf`. En Lines: la bandeja con `Draggable` (la pieza a la escala del tablero y por encima del dedo, la casilla punteada mientras tanto, como en la página 24 del diseño), `LinesBoardTarget` (convierte la primera celda de la pieza en el ancla, pide la vista previa al Cubit y juega el movimiento al soltar), `linesPreviewOf` y `LinesGameScreen`, que el módulo ahora solo conecta. Tokens nuevos en el tema, con el color de la posición inválida provisional hasta que lo confirme @dicpc. `HexaBlockApp` muestra la primera pantalla como ruta, porque sin `Navigator` no había `Overlay` para la pieza arrastrada. `StubStartGame` en `hexa_test_support` (D-56). Pruebas: 7 de widget del arrastre (HL-02 y E-HL-3), 5 de `linesPreviewOf` y 2 de geometría. Trazabilidad de RF-21 y de E-HL-3 |
| Modificaciones del equipo | El usuario pidió seguir con el segundo PR apilado, como se acordó en la primera parte. Claude dejó para HF-02 generalizar el destino del arrastre y para TEC-07 la vista previa en figuras con dos tipos de celda, y se lo planteó al usuario. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) La pantalla de TEC-11 mostraba su contenido con `WidgetsApp.builder`, sin `Navigator` ni `Overlay`, y cualquier `Draggable` fallaba también en la app; las pruebas de TEC-11 no lo vieron porque no arrastraban nada, y lo detectó la primera prueba de arrastre. (2) Una prueba de geometría comparaba con `Path.getBounds()` a 1e-6, pero `Path` guarda sus puntos en precisión simple; se subió la tolerancia a 1e-3 con un comentario. (3) El `architecture-reviewer` señaló que `PieceDrag` no tenía nada de Lines y que Fit tendría que copiarlo; se movió a los *widgets* comunes del tablero en la misma rama |

### IA-68 · Merge de `main` en vez de rebase en los PR apilados (precisión de D-137) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Literal: "Mergea el #127 y haz el rebase del #128"; ante el bloqueo del *force push*, eligió "Merge de main" entre las opciones; después: "sí, haz el paired-change de D-137" |
| Resultado | Se integró app #127 (la primera parte de HL-02) con *squash* y sin borrar la rama. El rebase de app #128 no se pudo subir: el *hook* de git bloquea el *force push* (SEC-AGT-02). Claude integró `main` en la rama de #128 con un merge (sus dos conflictos venían del *squash* de #127; se tomó la versión de la rama y se comprobó que el árbol no cambiaba), la subió sin *force* y cambió su base a `main`. Después, D-137 en `docs/DECISIONES.md` de los dos repos, con el mismo texto: la rama del siguiente PR apilado integra `main` con un merge en lugar de rebasarse, con el motivo y qué hacer ante un conflicto con el *squash* anterior. Sin Issue (precisa una decisión cerrada) |
| Modificaciones del equipo | El usuario eligió el merge de `main` entre las tres opciones de Claude (merge, rama y PR nuevos, o que el usuario hiciera el *force push* a mano) y pidió precisar D-137 en los dos repos. Claude lo escribió como precisión de D-137 y no como una decisión nueva, para no reabrirla |
| Lecciones | (1) D-137 se escribió (IA-63) con un paso que su propia configuración de seguridad prohíbe: ninguna revisión cruzó la decisión con los *hooks*, y apareció la primera vez que se integró un PR apilado. (2) El sistema de permisos rechazó un `git reset --hard` para descartar el rebase local; se hizo el merge en una rama local nueva desde la versión remota y se subió como avance normal, sin borrar nada. La rama local rebasada quedó desalineada y se dejó para que el usuario decida |

### IA-69 · Eliminar líneas completas y puntuarlas con la racha (HL-03, parte 1 de 2) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | `/implement-story HL-03`; después del plan: "ok, adelante" |
| Resultado | Issue #34, primera subtarea (rama `feat/hl-03-clear-lines`). En la capa 1 (`hexa_variants`, el motor no cambia): `LinesState.streak` (la racha `k`), el evento `LinesCleared` (líneas, celdas vaciadas y racha, como pide RN-HL §11), el paso `resolve` de `HexaLinesRules`, que vacía a la vez todas las líneas completas de todos los ejes y cada celda compartida una sola vez (RN-HL-40 a 43), y las políticas `LinesScoring`, `LineBonus` y `StreakMultiplier`, que la fábrica conecta y las reglas reciben en el constructor (D-98, D-100, D-101). Pruebas: E-HL-1 y E-HL-2 (27, 101 y 151 puntos), RN-HL-40 a 43, 60 a 64 y la racha con su tope, el estado y la eliminación en una figura con dos tipos de celda (RNF-04). Documentos: el esbozo de `LinesCleared` en ARQ-02, la trazabilidad de RF-22 y `tool/examples_pending.txt` |
| Modificaciones del equipo | El usuario aceptó el plan de Claude, que agregó la racha al evento (RN-HL §11) y no aplicó RN-HL-44 como optimización. El `architecture-reviewer` no encontró bloqueantes. Claude aplicó dos de sus sugerencias: probar la eliminación en otra figura y quitar un *cast* de una prueba. Como el cambio pasaba de las ~600 líneas de D-137, Claude lo dividió en 2 PR apilados. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) `resolve` solo ve el estado, no el movimiento, así que no sabe qué celdas se colocaron. Revisar todas las líneas da el mismo resultado que RN-HL-44 y no obliga a guardar en el estado un dato de un solo turno (D-98). (2) Dos ediciones en lote con un script fallaron porque el *hook* de formato había cambiado el texto que buscaban. El script se detenía con un `assert` en lugar de escribir a medias, y se rehicieron sobre el archivo actual |

### IA-70 · Valores del puntaje de Hexa Lines en configuración (HL-03, parte 2 de 2, D-139) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Pregunta de Claude sobre RNF-11 con tres opciones; el usuario eligió "Parámetros en JSON (Recommended)" |
| Resultado | Issue #34, segunda subtarea (rama `feat/hl-03-scoring-config`, sobre la de la primera). `LinesScoringConfig` (puntos por celda de línea y tope de la racha, validados) dentro de `LinesConfig`. `LineBonus` y `StreakMultiplier` reciben los valores, y `HexaLinesFactory._createScoring` arma la política con ellos. En `hexa-lines.json`, una sección `scoring` con 5 y 3 (D-09), que `LinesConfigMapper` lee. Pruebas: 4 de las políticas y de la validación, 1 de la fábrica (E-HL-1 con 10 puntos por celda da 52) y 3 del *mapper*. Documentos: D-139, ARQ-02 §9.7 y §10, `EXTENSIBILITY.md` §3 y la trazabilidad de RF-22 |
| Modificaciones del equipo | El `architecture-reviewer` vio que RNF-11 (Must) pide leer las fórmulas de puntaje de la configuración y que la primera parte dejaba los valores como constantes. Claude no lo resolvió por su cuenta: planteó tres opciones (valores en el JSON, precisar RNF-11 o aplazarlo) y el usuario eligió la recomendada. Claude propuso que un valor fuera de rango lance el `ArgumentError` del dominio, como pasa con los pesos del catálogo, y no un `FormatException`. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) El plan de HL-03 no revisó los requisitos no funcionales, solo las reglas de la historia, y RNF-11 apareció en la revisión de arquitectura. (2) ARQ-02 §10 y RNF-11 parecían contradecirse. D-139 los concilia: la forma de la fórmula es una clase y sus valores son configuración |

### IA-71 · Bandeja nueva al colocar la tercera pieza (HL-04) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | `/implement-story HL-04`; después del plan: "ok". Ante el desajuste del orden de eventos, el usuario eligió "Anotar en PENDIENTES (Recomendado)" |
| Resultado | Issue #35 (rama `feat/hl-04-new-tray`). En la capa 1 (`hexa_variants`, el motor no cambia): el paso `afterResolve` de `HexaLinesRules`, que saca una bandeja nueva de 3 con el generador de la partida cuando las tres casillas están vacías (RN-HL-21, RN-COM-42); la fábrica le pasa la fuente de piezas (D-100), y el evento `TrayRefilled`, que el puntaje ignora. El fin de partida se evalúa con la bandeja nueva (RN-HL-50). Pruebas en `hexa_lines_tray_test` (RN-HL-21, RN-HL-50, la bandeja nueva tras las líneas eliminadas y la misma semilla con las mismas bandejas) y en `hexa_lines_any_shape_test` (otra figura, RNF-04); se ajustaron una prueba de RN-HL-40 que vaciaba la bandeja sin querer y la prueba de arrastre de la app, que arma las reglas a mano. Documentos: la trazabilidad de RF-20 y la decisión abierta D-140 en `PENDIENTES.md` |
| Modificaciones del equipo | El usuario aceptó el plan sin cambios. El `architecture-reviewer` no encontró bloqueantes; Claude aplicó sus sugerencias (usar `LinesState.traySize` y `LinesPieceSource.totalWeight` en las pruebas, probar otra figura y decir el alcance de la prueba del orden de eventos). El desajuste entre RN-HL §11 y D-94 no lo resolvió Claude: planteó cuatro opciones y el usuario eligió registrarlo como D-140, con la recomendación de ajustar el texto de §11. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) El orden de notificaciones de §11 y el de D-94 ya no coincidían, pero no se notaba hasta que hubo un evento de "después de resolver"; una prueba sobre los eventos de las reglas no ve los que agrega el motor. (2) Correr las pruebas antes de implementar mostró una que pasaba por casualidad |

### IA-73 · Terminar la partida cuando nada cabe (HL-05) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | `/implement-story HL-05`. Ante el alcance de "voy a la pantalla de fin" (que es PRG-02), el usuario eligió "Aviso mínimo (Recomendado)"; después del plan: "ok, adelante" |
| Resultado | Issue #36 (rama `feat/hl-05-game-over`). El dominio no cambió: `HexaLinesRules` ya terminaba la partida con el `evaluate` por defecto, evaluado con la bandeja nueva. Pruebas en `hexa_variants/test/hexa_lines/hexa_lines_game_over_test` (E-HL-4 con sus dos bandejas, RN-HL-51 con las piezas que quedan, RN-HL-50 con las líneas eliminadas antes de evaluar, RN-HL-52 con el tablero vacío sin victoria, y RN-HL §11 con el motor: el fin de partida es el último evento y después se rechazan los movimientos). Un doble nuevo en `hexa_test_support`, `StubPieceSource`, que entrega piezas fijas (una por estado del generador) con sus pruebas. En la app, `GamePage` reemplaza la bandeja por el aviso "Sin movimientos" / "No moves left" (título de las páginas 49 y 50 del diseño, `liveRegion`) cuando la fase es `GameOverPhase`, con pruebas de *widget* en es y en, y una prueba del `GameCubit`. Documentos: la decisión del aviso mínimo en `DECISIONES.md`, la trazabilidad de RF-23 y E-HL-4 fuera de `tool/examples_pending.txt` |
| Modificaciones del equipo | El usuario eligió el alcance entre tres opciones (solo dominio, aviso mínimo o pantalla de derrota completa) y aceptó el plan sin cambios. El `architecture-reviewer` no encontró bloqueantes; Claude aplicó tres sugerencias (renombrar el parámetro de tipo del *stub*, documentar que las reglas deben sacar números solo a través de la fuente y usar `isA().having` en la prueba del *cubit*) y dejó opcional escribir la fase con un `switch`. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) Como la regla ya existía, las pruebas pasaron desde el principio; para comprobar que detectan el error se rompió `evaluate` a propósito y fallaron las 4 de derrota. (2) La primera versión de la prueba "la partida continúa" de la pantalla jugaba un dominó que no cabía, así que el movimiento se rechazaba y no probaba nada; se cambió por una bandeja a la que le queda un mono. (3) Las celdas vacías de E-HL-4 se leyeron del dibujo y se comprobaron con un script (9 celdas, ninguna vecina de otra, ninguna línea completa) antes de usarlas |

### IA-74 · Ver el puntaje y el récord (HL-06, en dos PR apilados, D-142) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | `/implement-story HL-06`. Claude mostró que el puntaje ya estaba en pantalla, que el guardado del récord de ARQ-03 es de PRG-03 y que D-140 tenía como fecha límite "antes de HL-06", y preguntó tres cosas. El usuario eligió "Puerto + memoria (Recommended)", "A: cambiar el §11 (Recommended)" y "Récord guardado (Recommended)"; después del plan respondió "ok". Ante el tamaño de la rama (D-137) eligió "Dos PR apilados (Recommended)" |
| Resultado | Issue #37, en dos PR. **1/2** (`feat/hl-06-record-use-cases`): en `hexa_application`, `VariantProgress` con la forma `HighScoreProgress` y `GameResult`, los puertos `IProgressRepository` e `IClock`, `GetProgressUseCase` y `SaveProgressUseCase` (guarda el puntaje solo si supera el récord o si no había, con la fecha del reloj); `FakeProgressRepository` y `FakeClock` como `IClock` en `hexa_test_support`, con sus pruebas (RN-HL-70, RN-HL-71, RN-COM-80); D-142, D-143 (abierta) y ARQ-03 §3 y §4. **2/2** (`feat/hl-06-score-and-record`): `GameCubit` con `RecordUseCases` opcionales (lee el récord al empezar, muestra el turno que termina la partida y después guarda y muestra el récord nuevo, sin perder la vista previa), `GameReady.record`, `MemoryProgressRepository` (uno para toda la app), `SystemClock`, los marcadores PUNTAJE \| RÉCORD de `GamePage` (`recordLabel` en es y en) y la conexión en `HexaLinesModule` y `registerDependencies`. Pruebas del presentador, del repositorio, del reloj, de la pantalla (`lines_score_test`: textos en es y en, el puntaje que suma al colocar una pieza y el récord nuevo al terminar) y de integración. Documentos: D-140 cerrada (el §11 de Lines, Sort y Merge pone el puntaje después de los eventos de las reglas), RN-HL-70 precisada y la trazabilidad de RF-12 y RF-24 |
| Modificaciones del equipo | El usuario eligió las tres decisiones entre las opciones propuestas (D-142: puerto y adaptador en memoria en vez de solo mostrar el récord o de adelantar PRG-03; D-140: cambiar el texto del §11 en vez de reabrir D-94; marcador con el récord guardado en vez del máximo en vivo) y dividir la rama en dos PR apilados. El `architecture-reviewer` no encontró bloqueantes; Claude corrigió los dos puntos importantes (la vista previa que se perdía al mostrar el récord y la comprobación no exhaustiva de `SaveProgressUseCase`) y dejó como D-143 la duda sobre `IProgressModel` (D-99), que el usuario cerró con la opción A (el récord se consolida por su forma). Los puntos menores (`showsRecord` y `RecordUseCases` dicen lo mismo en dos lugares; el patrón de "partida terminada" repetido en el caso de uso y en el *cubit*) quedaron anotados en el PR. Las pruebas las escribió Claude y las revisó @DanielHaro28 (D-59) |
| Lecciones | (1) La primera versión de `GameCubit` guardaba el récord y después emitía el estado nuevo sin la vista previa; el revisor lo detectó y una prueba con un guardado que no termina (`Completer`) lo reproduce: se comprobó que falla sin la corrección. (2) Una historia de 3 h dependía de piezas de otra de 8 h (PRG-03); separar el puerto del adaptador, como en D-136, permitió cumplir los tres criterios sin mezclar los dos Issues. (3) El total de la rama (unas 1300 líneas, dos tercios de pruebas) pasó el umbral de D-137 aunque el código de producción no llegaba a 400; se dividió por capas después de terminar, reconstruyendo las ramas desde el árbol final y comprobando que la segunda quedara igual |

### IA-72 · Prueba del orden completo de las notificaciones de Hexa Lines con el motor (D-140) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Preguntas previas: "que es d140?", "esto es para esos modos de juego no modificariamos los otros modos si modificamos el caso de uso o es puro texto?" y "tiene sentido esto que hicimos en esa implementacion". Después: "Ok, haz el /rule-change para D-140 con la opción A" y "sí, súbela y abre el PR". Ante el conflicto con `main`, el usuario eligió "Reducirlo a la prueba (Recommended)" |
| Resultado | Sin Issue (rama `docs/d-140-notification-order`). Una prueba nueva en `hexa_variants/test/hexa_lines/hexa_lines_tray_test.dart`, grupo `RN-HL §11`, que juega un turno con el `GameEngine` real y comprueba el orden completo: `PhaseChanged → PiecePlaced → LinesCleared → TrayRefilled → ScoreChanged → PhaseChanged`. La prueba que ya había solo veía los eventos de las reglas. El comentario del archivo dice ahora qué cubre. El cambio de los §11 y el cierre de D-140 ya estaban en `main` por HL-06 (IA-74), así que esta rama dejó esos documentos como están en `main` |
| Modificaciones del equipo | El usuario eligió la opción A de D-140. Claude cambió los §11, cerró D-140 y abrió el PR, pero HL-06 se había integrado antes con el mismo cierre; Claude propuso reducir el PR a la prueba o cerrarlo, y el usuario eligió reducirlo. El `architecture-reviewer` no encontró bloqueantes en la prueba. Las pruebas las escribió Claude. ⚠️ completar: revisión de las pruebas por una persona (D-59) |
| Lecciones | (1) La prueba pasó a la primera, como se esperaba: comprueba lo que el motor ya hacía. (2) Dos sesiones trabajaban en paralelo en el mismo clon y las dos cerraron D-140; ninguna miró `main` antes de empezar. Antes de un cambio de documentos hay que revisar si `main` ya lo tiene |

### IA-76 · Comillas en la ruta del mensaje para commitlint (lefthook) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 24-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | "haz el PR para arreglar lefthook.yml" |
| Resultado | Sin Issue (rama `fix/lefthook-commit-msg-path`). En `lefthook.yml`, el hook `commit-msg` pasa la ruta del mensaje entre comillas (`commitlint --edit "{1}"`), con un comentario que dice por qué. En un *worktree* de git esa ruta es absoluta, dentro del `.git` del clon principal, y tenía espacios ("Hexa Family Games"); sin comillas, `commitlint` recibía la ruta partida, mostraba su ayuda y todo commit fallaba. Se comprobó en un *worktree*: un mensaje inválido lo rechaza `commitlint` y el commit del arreglo pasa con el hook activo. El CI no usa este hook (revisa el título del PR) |
| Modificaciones del equipo | Mientras terminaba el PR de la prueba de D-140 (#138), Claude encontró el fallo y propuso dos caminos: hacer ese commit sin el hook o arreglar el hook en un PR aparte. El usuario eligió hacer aquel commit sin `commitlint`, después de que Claude comprobó a mano que el mensaje pasaba, y pidió después este PR |
| Lecciones | (1) El fallo solo aparece con un *worktree* y una ruta con espacios: en el clon principal git pasa una ruta relativa. (2) Para ver la versión de lefthook, Claude corrió `npx --yes` en el *worktree* sin `node_modules`, lo que puede descargar el paquete de npm; dio la misma versión fija del proyecto y no cambió el repositorio, pero debió usar la copia instalada |

### IA-86 · Sistema de diseño y prototipo en el repo (T-05) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Claude Code (app de escritorio) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel: "Trabajo el Issue T-05 (#72). Quiero llevar al repo el sistema de diseño y el prototipo de pantallas, que hoy están fuera de él", con ocho pasos: leer el Issue, REVISION-DISENO, el sistema (README, decisiones, *handoff*, *tokens*, guías de componentes) y el prototipo con sus capturas; antes de escribir, comparar el sistema y el prototipo con DIS-01 a DIS-16 y con las reglas en una tabla y relacionar cada pantalla con su historia, y esperar el ok; copiar los documentos, las guías y las capturas (menos de 1 MB cada una, sin `.dc.html`, SVG ni fuentes); actualizar REVISION-DISENO y el índice; abrir como pendientes las decisiones nuevas con el siguiente `D-*` libre; correr `tools/docs-check/`, hacer commits pequeños y preparar el PR. Después de las tablas: "Sí, sigue así" |
| Resultado | Issue #72 (rama `docs/t-05-design-system`). `docs/design/sistema/` con README (más un título y una nota de copia fiel), `decisiones.md`, `contraste.md`, `handoff-flutter.md`, `pantalla-carga.md`, `tokens.json` y `componentes/` con la guía de los 21 componentes. `docs/design/pantallas/` con 71 capturas renombradas en minúsculas y guiones (la mayor, 637 KB). REVISION-DISENO: el sistema es la fuente visual y el prototipo la referencia de cada pantalla, con sus enlaces; la tabla de páginas del PDF pasó a captura → historia (§1); §5 concilia DIS-01 a DIS-16 (los 16 cumplen) y §6 agrega DIS-17 a DIS-24. PENDIENTES: D-144 (fuente visual), D-145 («Jugar sin guardar»), D-146 (fuentes empaquetadas) y D-147 (ocultar los símbolos), abiertas con opciones y recomendación. Índice de `docs/README.md` al día |
| Modificaciones del equipo | @dicpc aceptó las recomendaciones de Claude: guardar en un *stash* el trabajo sin commit de la rama anterior y partir de `main`; copiar las guías de componentes en inglés, como en el origen, con una nota; que en la bandeja de Sort con «Siguiente» y en el deshacer de la derrota de Merge mande la regla (DIS-17 y DIS-18) sin abrir una decisión; agregar D-147 a las tres decisiones pedidas; no copiar la captura de carga repetida ni la miniatura del prototipo; dejar la «Racha ×2» como pregunta para quien diseñó |
| Lecciones | (1) La rama de trabajo anterior proponía D-117 a D-120 sin commit, pero en `main` esos IDs ya eran las decisiones de AWS: `main` local iba 28 commits atrás. Se detectó al comparar con `origin/main` antes de escribir, y `next_id.py` confirmó D-144. (2) Dos capturas del prototipo eran idénticas byte a byte (carga normal y con «Reducir movimiento»): se vio por el tamaño y se comprobó con `cmp`. (3) Varias contradicciones solo aparecen en las capturas, no en las guías (el deshacer en la derrota de Merge, la racha ×2), así que revisar las dos fuentes valió la pena. (4) `check_shared.py` marca `APPROVED-TOOLS.md` como distinto porque el clon local de `hexablock-api` está atrasado; en `origin/main` los dos son iguales |

### IA-87 · Decisiones de la interfaz antes de NAV-01 (D-148 a D-153) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Claude Code (app de escritorio) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel: "Voy a empezar las historias de interfaz (NAV-01 a NAV-08, PRG-01, PRG-02). Lee CLAUDE.md, las reglas de la app, ADR-001, ARQ-01, ARQ-03 (§4 y §6), REVISION-DISENO, el sistema de diseño y el prototipo. Para cada punto (widgets base, navegación, audio, SVG, fuentes, *tokens*, estructura de `frameworks/ui/` y ARB), dame 2 o 3 opciones con ventajas, desventajas y una recomendación, verificando en pub.dev los paquetes. No escribas código. Cuando elija, agrégalas como abiertas en PENDIENTES y prepara la rama, el commit y el PR". Después de las opciones: "Sí, con las recomendaciones" |
| Resultado | Rama `docs/ui-decisions`, apilada sobre `docs/t-05-design-system` (#140), porque cita el sistema de diseño y D-146 que todavía no están en `main`. PENDIENTES: D-148 (Material con `material_ui` envuelto en componentes propios), D-149 (`Navigator` con `AppRoute` sellada, sin `go_router`), D-150 (`audioplayers`), D-151 (`flutter_svg`), D-152 (*tokens* a mano con una prueba contra `tokens.json`) y D-153 (estructura de `frameworks/ui/` y ARB), abiertas con opciones, recomendación y los datos de pub.dev. Las fuentes no tienen ID nuevo: ya eran D-146 |
| Modificaciones del equipo | @dicpc aceptó las seis recomendaciones sin cambios; el equipo las cierra en el PR |
| Lecciones | (1) Desde Flutter 3.47 Material es un paquete aparte (`material_ui`): el *handoff* lo da por incluido, y por eso el comentario de `hexablock_app.dart` lo dejaba como decisión. (2) El punto de las fuentes ya estaba abierto como D-146: se buscó en PENDIENTES antes de numerar para no duplicarlo. (3) El componente `TextField` del sistema choca con el de Material: de ahí el prefijo `Hexa` en D-153 |

### IA-88 · Cierre de las decisiones de la interfaz (D-144, D-146, D-148, D-149, D-151 a D-153) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Claude Code (app de escritorio) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | "/implement-story NAV-01" con la condición de detenerse si las decisiones de UI no estaban cerradas en `docs/DECISIONES.md` o si T-05 no estaba en `main`; después de avisar: "Listo" y, ante la propuesta de abrir un PR que las cerrara con las opciones recomendadas, "Sí, ábrelo" |
| Resultado | Sin código. Rama `docs/close-ui-decisions` desde `main`. DECISIONES: sección «Interfaz (25-11)» con D-144, D-146, D-148, D-149 y D-151 a D-153 cerradas con la opción recomendada. PENDIENTES: se borran las cerradas y vuelve D-150 (audio), que se había perdido. REVISION-DISENO: la cabecera y DIS-22 citan las decisiones cerradas. Se recupera IA-87 |
| Modificaciones del equipo | El equipo cerró todas con la opción recomendada; D-145, D-147 y D-150 siguen abiertas porque no bloquean NAV-01 |
| Lecciones | El PR apilado #141 se integró 46 s después de #140, cuando su base (`docs/t-05-design-system`) ya estaba integrada con *squash*: su contenido quedó en esa rama y nunca llegó a `main`. Antes de integrar un PR apilado hay que cambiar su base a `main`. Se detectó al revisar `main` antes de empezar NAV-01 |

### IA-93 · Perfiles y progreso por nivel en la capa de aplicación (PRG-03, PR 1 de 2) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Antigravity con Gemini 4 Neon (High); subagente `architecture-reviewer` |
| Prompt | `implementa la historia PRG-03 siguiendo implement-story`. Se propusieron 3 decisiones de alcance (dejar `saved_games` para NAV-04, incluir `LevelsProgress` y `LevelAttempt` agnósticos a la variante, y crear las 6 tablas en v1 manteniendo el respaldo de Android para Drift) junto con el plan en 2 PR apilados (D-137). El usuario respondió: "Acepto las recomendaciones y empieza, me gusta el plan". |
| Resultado | Issue #56 (PR 1/2, rama `feat/prg-03-progress-application`). En `packages/hexa_application`: `Profile`, `ProfileKind` y `IProfileRepository` (`active`, `activate`, `guest`); `LevelAttempt`, `LevelsProgress`, `GameResult` sellado en `HighScoreResult` y `LevelCompletedResult`; actualización de `GetProgressUseCase` y `SaveProgressUseCase` para usar el perfil activo vía `IProfileRepository` y consolidar intentos de nivel con `IProgressModel<LevelAttempt>` (desempate por `achievedAt` más antiguo, ARQ-04 §3). En `packages/hexa_test_support`: `FakeProfileRepository` y sus pruebas. En `app/`: `MemoryProfileRepository` temporal y cableado de `GameCubit`, `dependencies.dart` y `HexaLinesModule`. Pruebas unitarias en `profile_test.dart`, `progress_test.dart`, `get_progress_use_case_test.dart` y `save_progress_use_case_test.dart`. |
| Modificaciones del equipo | El usuario aceptó las 3 recomendaciones de alcance y el plan en 2 PR apilados. Las pruebas fueron revisadas y aprobadas por @DanielHaro28 (D-59). |
| Lecciones | (1) El `switch ((input, saved))` sobre una tupla en Dart 3 requiere enlazar la variable del patrón (`final HighScoreProgress current`) para promover el tipo no anulable del campo en el `return`. (2) El `architecture-reviewer` señaló como mejora futura alinear `SavedGameKey` con el perfil activo al conectar `saved_games` en Drift y considerar atomicidad en `SyncProgressUseCase` cuando consolide en paralelo. (3) Al verificar `next_id.py` tras `git fetch`, se detectaron IDs ya usados en ramas remotas no integradas, evitando colisiones. |

### IA-92 · Persistencia local con Drift para perfiles y progreso (PRG-03, PR 2 de 2, D-156) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Antigravity con Gemini 4 Neon (High); subagentes `architecture-reviewer` y `security-reviewer` |
| Prompt | Continuación de PRG-03 en rama apilada (PR 2/2). Ante el hallazgo bloqueante de `architecture-reviewer` sobre la dependencia Capa 3 → Capa 4 de los repositorios Drift, el usuario pidió explicación, preguntó por el puerto entre Capa 4 y Capa 2 y decidió: "Aplica A, y despues quiero que hagas la verificacion del PR dos de nuevo que este todo bien". |
| Resultado | Issue #56 (PR 2/2, rama `feat/prg-03-drift-persistence`). Dependencias verificadas en `pub.dev`: `drift`, `drift_flutter`, `drift_dev` y `build_runner`. En `app/lib/frameworks/persistence/` (capa 4, D-156): `AppDatabase` (`schemaVersion = 1` con las 6 tablas de ARQ-04 §2, perfil `guest` sembrado en `onCreate` y `PRAGMA foreign_keys = ON`), `drift_error.dart` (`runDrift` → `PersistenceException`), `DriftProfileRepository` (`insertOnConflictUpdate` en transacción para no disparar `ON DELETE CASCADE`) y `DriftProgressRepository` (carga y guardado transaccional de `HighScoreProgress` y `LevelsProgress`, `pending`/`revision` de D-49). Retiro de los repositorios en memoria de perfil/progreso y actualización de `dependencies.dart` y `hexa_lines_module.dart`. Pruebas de integración con `NativeDatabase.memory()` y archivo SQLite temporal en `drift_profile_repository_test.dart`, `drift_progress_repository_test.dart` y `hexa_lines_game_test.dart` (reapertura sin conexión). Documentos: `D-156` en `DECISIONES.md`, `ARQ-03-APP-DETALLE.md` §4 y trazabilidad de `RF-24` y `RF-60` en `05-TRAZABILIDAD.md`. Verificación completa en verde, incluido `flutter build apk --debug`. |
| Modificaciones del equipo | El usuario eligió la opción A propuesta por la revisión de arquitectura: mover `DriftProfileRepository`, `DriftProgressRepository` y `drift_error.dart` a `app/lib/frameworks/persistence/` (capa 4) implementando directamente los puertos de capa 2, en lugar de mantener consultas Drift en `adapters/repositories/`. Las pruebas fueron revisadas y aprobadas por @DanielHaro28 (D-59). |
| Lecciones | (1) `architecture-reviewer` detectó una contradicción entre documentos (`ARQ-01-APP` §2 y `capas.mmd` vs. `ARQ-03` §4 y `clases-aplicacion.puml`): ubicar los repositorios Drift en `adapters/repositories/` generaba imports de capa 3 → capa 4; moverlos a `frameworks/persistence/` dejó 0 bloqueantes en la segunda revisión. (2) En `testWidgets`, abrir y cerrar `NativeDatabase(file)` directamente dentro del cuerpo de prueba se bloquea en la zona `FakeAsync`; envolver la configuración y cierre en `tester.runAsync` resolvió el *timeout* manteniendo determinismo. (3) Usar `insertOnConflictUpdate` en lugar de `insertOrReplace` en `profiles` evita que SQLite dispare `ON DELETE CASCADE` sobre `records` y `level_results`. (4) Volver a correr `next_id.py` antes de cerrar el PR detectó IDs recién usados en otra rama remota, evitando colisiones al reasignar a `D-156` e `IA-92`. |

### IA-94 · Revisión de los PR de PRG-03, correcciones y decisiones D-156 y D-158 (#142, #147) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | "Revisa exhaustivamente los PR de PRG-03" y, después de la revisión, "Corrige primero lo que no necesita decisión, y hazme una lista con las que requieren decisión"; ante las opciones: "1A, 2A, 3A, 4C, 5 lo que creas recomendado y sube las ramas y actualiza los repos" |
| Resultado | Issue #56. Revisión de #142 y #147: formato, `dart analyze --fatal-infos`, `check_architecture`, pruebas de `hexa_application`, `app` y `hexa_test_support`, y regeneración de `app_database.g.dart` con `build_runner` (igual salvo fin de línea). **#142** (`feat/prg-03-progress-application`): integra `main` con un merge (D-137); su entrada de IA pasa de IA-88, que ya usaba `main` (#143), a **IA-93**; el desempate del mejor intento cita ARQ-04 §3 y no RN-COM-105 (que es el empate del ranking); la prueba del empate se renombra (`..._achieved_later`) y se agrega el caso a la misma hora. **#147** (`feat/prg-03-drift-persistence`): integra #142; `DriftProfileRepository.activate` actualiza solo el nombre y la marca de activo de un perfil existente, así no pisa su `kind` ni su `createdAt`; `active()` devuelve el invitado si no hay perfil activo (lo que promete el puerto) y lanza `PersistenceException` si hay más de uno; un `kind` desconocido da `PersistenceException` y no un `ArgumentError` (D-39); volcado del esquema v1 en `app/drift_schemas/drift_schema_v1.json` y su mención en ARQ-04 §6; D-156 cita ARQ-04 §3 para el desempate. Cuatro pruebas nuevas en `drift_profile_repository_test.dart` y una en `save_progress_use_case_test.dart`. **Decisiones del usuario:** D-158 (4C): puerto `IUnitOfWork` en la capa 2, `SaveProgressUseCase` lee, consolida y escribe dentro de `run`, `FakeUnitOfWork` en `hexa_test_support`, `MemoryUnitOfWork` en el #142 y `DriftUnitOfWork` (transacción de Drift) en el #147; las pruebas de guardados simultáneos fallan sin la unidad (se comprobó quitándola). D-156 (2A y 3A): puntos 1 a 3 ratificados y el punto 4 ampliado a todo repositorio sobre un framework; ARQ-01-APP-GENERAL (§2, §3, §4.2 a §4.4, §8), ARQ-02 §9.4, ARQ-03 (§4, §7, §8), ESTRATEGIA-PRUEBAS, `capas.mmd`, los dos `.puml` y `.claude/rules/app-layers.md` y `application.md` al día; `tool/check_architecture.dart` falla si `app/lib/adapters/` importa `frameworks/` o `package:drift` (probado con un archivo de prueba). Trazabilidad de RF-60. La aprobación de la herramienta (1A) va en un PR pareado aparte, con los dos repos |
| Modificaciones del equipo | ⚠️ Falta que una persona revise las 12 pruebas nuevas (D-59): 4 de `drift_profile_repository_test`, 3 de `save_progress_use_case_test`, 2 de `fake_unit_of_work_test` y 3 de `drift_unit_of_work_test`. El usuario eligió las opciones recomendadas de las cuatro decisiones (1A, 2A, 3A, 4C) y dejó a criterio de Claude la quinta: el control de `*.g.dart` en el CI va a un Issue aparte, porque cambia un *workflow* y no es de PRG-03. `capas.png` falta exportarlo a mano desde `capas.mmd` (D-43) |
| Lecciones | (1) `next_id.py` en la rama no basta si `main` avanza después: el IA-88 estaba libre cuando se escribió y lo tomó #143 antes de integrar. (2) Un cambio de capa como el de D-156 toca más que la tabla de ARQ-03: ARQ-01-APP-GENERAL, `capas.mmd`/`capas.png`, los dos `.puml` y dos reglas de `.claude/rules/` dicen lo contrario. (3) Las transacciones de Drift se atan a la zona, así que una unidad de trabajo en la capa 2 no obliga a cambiar los repositorios: su propia transacción pasa a ser un *savepoint* |

### IA-95 · Aprobación de Antigravity como segunda herramienta de agente (D-159) — compartido

| Campo | Contenido |
|---|---|
| Fecha | 25-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | En la revisión de los PR de PRG-03 (app #142 y #147), Claude señaló que se habían hecho con Antigravity, que no estaba aprobada (D-86, D-87), y propuso tres opciones: aprobarla, registrar una excepción o rehacer los PR. El usuario respondió "1A, 2A, 3A, 4C, 5 lo que creas recomendado y sube las ramas y actualiza los repos" |
| Resultado | Rama `docs/approve-antigravity` en los dos repos (`/paired-change`). D-159 en `DECISIONES.md` de cada repo. Documentos compartidos, copiados byte a byte: `docs/ai/APPROVED-TOOLS.md` (fila de Antigravity con sus cuatro condiciones; Claude Code sigue como principal y única con configuración), ADR-001 §2.6 (revisión 2.3) y SECURITY-BASELINE §6. Fila de Antigravity en la §1 de este archivo |
| Modificaciones del equipo | El usuario eligió la opción A, la recomendada era B (excepción puntual). Las cuatro condiciones las redactó Claude a partir de los controles que Antigravity no recibe de `.claude/` (SEC-AGT-02, 03, 05); ⚠️ el equipo las confirma al revisar el PR (CODEOWNERS) |
| Lecciones | Una herramienta que no lee `.claude/` deja sin efecto los permisos y los *hooks* de agente; lo único que aplica igual son los *hooks* de git y el CI. Por eso la aprobación lleva condiciones de uso y no solo la fila de la lista |

### IA-96 · El CI comprueba que el código generado por Drift está al día (#149) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 26-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | "Implementa el #149" (el Issue lo abrió Claude en la revisión de PRG-03, IA-94) |
| Resultado | Issue #149 (rama `ci/drift-generated-code`). Paso nuevo en el job `flutter` de `.github/workflows/ci.yml`, después de las dependencias: corre `dart run build_runner build --delete-conflicting-outputs` en `app/` y falla si `git status --porcelain -- '*.g.dart'` no está vacío, así detecta un archivo cambiado y también uno generado que nunca se subió. Sin acciones nuevas ni permisos nuevos. Documentos: ARQ-01-APP §8 (fila del control) y ARQ-04 §6. Se simuló el paso como en el runner (un *worktree* con `core.autocrlf=false`): pasa con el código actual y falla en dos casos, con una columna nueva sin regenerar y con el archivo generado fuera del índice |
| Modificaciones del equipo | ⚠️ Cambia un *workflow* (SEC-AGT-05): hay que avisar al equipo |
| Lecciones | (1) En el repo los archivos generados están con LF, y el runner no convierte los fines de línea, así que el `git status` no da falsos positivos; en Windows con `core.autocrlf=true` sí podría marcar el archivo, por eso la prueba local se hizo con `autocrlf=false`. (2) `git diff --exit-code`, la propuesta original del Issue, no ve un archivo generado nuevo que nadie subió; `git status --porcelain` sí. (3) El *hook* de git bloqueó un `--no-verify` en la prueba; el caso se armó sin commit, sacando el archivo del índice |

## 4. Evaluación crítica

### 4.1 Porcentaje aproximado de asistencia

| Parte | Asistencia de IA |
|---|---|
| Código de la app | Motor (`hexa_engine`, desde IA-43; ciclo de turno en IA-45; generador, reloj y estrategias en IA-47; deshacer, cronómetro y sesión en IA-48; `VariantFamily` y `NewGameOptions` en IA-55), topología hexagonal (`hexa_topologies`, IA-44) y Hexa Lines (`hexa_variants`, desde IA-60): escritos con Claude Code, con el diseño y las decisiones del equipo. ⚠️ El equipo estima el porcentaje al cerrar M1 |
| Documentación de planificación (`docs/`) | Redactada en su mayor parte con Claude; las decisiones (D-*) las tomó el equipo. ⚠️ El equipo estima el porcentaje al cerrar la revisión de los Pasos 1 y 2 |
| Herramientas de verificación (`tools/reference-sim/`) | Escritas con Claude |

### 4.2 Resultados incorrectos o mejorables y cómo se detectaron

| Problema | Cómo se detectó | Corrección |
|---|---|---|
| Mermaid para todos los diagramas, aunque no dibuja la notación de plantilla de §4.1 | Contraste con el enunciado | Diagrama de clases en PlantUML (ADR rev. 1.4) |
| Estrellas válidas "0–3" en SEC-API-06, mientras RN-COM-108 decía 1–3 | Revisión cruzada (IA-07) | 1–3 (D-10: completar da al menos 1★) |
| E-COM-3 con un puntaje de Hexa Sort imposible (100; el mínimo es 101) | Revisión cruzada contra RN-HS-60 (IA-07) | 112 |
| Chequeo de CI que buscaba `sort`, `tri` o `hex` y daría falsos positivos con `List.sort()`, `String` o `hexa_engine` | Revisión cruzada (IA-07) | Búsqueda por identificadores completos (ARQ-01-APP §8) |
| TEC-08 decía que 2 variantes resuelven cubos; la regla cerrada RN-TOP-04 dice las 4 | Revisión cruzada (IA-07) | TEC-08 alineada con RN-TOP-04 |
| ADR admitía "argon2 (o bcrypt)"; SECURITY exige argon2id | Revisión cruzada (IA-07) | ADR rev. 1.7 |
| Tablas de Markdown rotas (SEC-AGT-05 y 07; barras `\|q\|` en RN-HEX-05 y 07) | Script que cuenta columnas (IA-07) | Separadores agregados y barras escapadas |
| La propuesta D-27 (figura en la clave del progreso) se apartaba del enunciado §5.2 | Lectura completa del enunciado (IA-07) | Dos opciones registradas en D-27 para que decida el equipo |
| G-09 figuraba como hecha, pero la plantilla de PR no estaba en los repos | Al clonar los repos (IA-08) | Se agrega con el PR #1 |
| PR sin la plantilla del repo y título sin ámbito | Pregunta del usuario (IA-08) | Título `docs(planning): …` y descripción con la plantilla |
| "Python no está instalado", cuando sí lo estaba (solo se probaron los accesos de Microsoft Store) | El usuario lo corrigió (IA-43) | Se usa `py`; los scripts de `tools/docs-check/` se corrieron antes del PR |
| `Board.==` comparaba la topología por identidad: dos tableros iguales con dos instancias de la topología eran distintos | Subagente `architecture-reviewer` (IA-43) | Las topologías se comparan por clase e `id`, con una prueba |
| Un `§` mal codificado (`Â§`) en un comentario de `board.dart` (IA-43) | Lectura del código al empezar IA-44 | Corregido en IA-44 |
| La prueba de contrato no relacionaba las vecinas con `step`, y el doble a cuadros no probaba un giro que cambia el tipo de celda | Subagente `architecture-reviewer` (IA-44) | El contrato exige que las vecinas sean las celdas a un paso; el doble gira cambiando el tipo y tiene un segundo giro básico |
| `FakeTopology.step` reconocía la dirección solo por su `id`, así que aceptaba la de otra topología | Subagente `architecture-reviewer` (IA-44) | Compara la dirección entera, y el contrato prueba que una dirección ajena lanza un error |
| `GameEngine.close()` no estaba protegido: un oyente síncrono podía cerrar el motor a mitad de un turno ya aplicado | Subagente `architecture-reviewer` (IA-45) | `close()` lanza `StateError` desde un oyente síncrono, con una prueba |
| Primera recomendación de D-95 (`enum` de motivos), cerrada para una 5.ª variante | El usuario la cuestionó (IA-45) | Jerarquía abierta `RejectionReason` (D-95) |
| El esbozo del decorador de reglas (D-96) daba derrota aunque el último movimiento permitido ganara, contra RN-COM-23 | Se compiló y corrió el esbozo con `FakeRules` (IA-46) | `evaluate` respeta primero la victoria de las reglas envueltas |
| El esbozo de `IPieceSource` en `clases-motor.puml` (la fuente guarda su generador) no permitía que Hexa Merge sacara la celda y el valor del mismo generador (RN-HM-21) | Al recorrer cómo usaría la firma cada variante (IA-47) | La fuente recibe el generador del estado y devuelve el siguiente (D-97) |
| El comentario de `Xorshift32` decía que ninguna otra semilla llegaba al estado de la semilla 0 | Relectura antes del commit (IA-47) | El comentario dice que las semillas 0 y `0x9E3779B9` dan la misma secuencia |
| El comentario de `IMonotonicClock` nombraba una variante dentro del motor | Subagente `architecture-reviewer` (IA-47) | Comentario genérico |
| El esbozo de ARQ-02 §9.7 aplicaba la racha dentro de `LinesScoring`, contra el decorador de §9.2, que envuelve solo el bono de líneas | Subagente `architecture-reviewer` (IA-47) | El esbozo y `clases-variantes.puml` envuelven `LineBonus` con `StreakMultiplier` |
| Pruebas de los dobles agrupadas por reglas (RN-COM-40, 51, 52, 83) que no comprobaban | Subagente `architecture-reviewer` (IA-47) | Agrupadas por decisión (D-56, D-97 a D-99); la trazabilidad deja esas reglas para las variantes |
| `UndoHistory` sacaba el turno del historial antes de restaurar y lo perdía si `restore` lanzaba un error | Subagente `architecture-reviewer` (IA-48) | El turno sale del historial solo después de restaurar; dos pruebas en `group('D-32')` |
| El comentario de `ILevelBased` usaba un `levelId` de ejemplo con el nombre de una variante dentro del motor | Subagente `architecture-reviewer` (IA-48) | El comentario cita el contrato de niveles |
| Dos pruebas agrupadas por una regla o decisión que no comprobaban (RN-COM-60 en la sesión, D-102 en la reentrada) | Subagente `architecture-reviewer` (IA-48) | Agrupadas por D-33 y D-32 |
| La primera recomendación de D-107 (guardar los comandos con su movimiento) obligaba a cada variante con deshacer a escribir un codec de movimientos, contra RNF-03 | Claude, al explicar las opciones a fondo para el usuario (IA-48) | Recomendación cambiada a B (solo estados), elegida por el usuario |
| Deshacer restauraba el estado entero, también la cuenta de movimientos de Fit, contra RN-HF-61 (D-10) | Pregunta del usuario sobre cómo se cuentan los movimientos para el ranking (IA-48) | `UndoHistory` conserva lo que pide la variante con `carryOver` (D-109); RN-COM-61 precisado |
| Dos pruebas de D-109 (rehacer y *snapshot*) pasaban aunque el código no hiciera lo que comprobaban | Segunda revisión del subagente `architecture-reviewer` (IA-48) | Reescritas; la de rehacer se verificó con una mutación del código |
| El plan del setup de AWS suponía la consola clásica (elegir `us-east-1`, usuario root e IAM), pero la cuenta usa la experiencia nueva, que asigna la región | Captura de la consola enviada por el usuario y documentación de AWS (IA-49) | D-108: región `us-east-2`; plan ajustado a AWS Builder ID y MFA en AWS Settings |
| Claude anticipó que `sshd -T` mostraría el `AuthorizedKeysCommand` de EC2 Instance Connect, pero mostró `none` | Salida que envió el usuario, y una segunda sesión de Instance Connect abierta antes de cerrar la primera (IA-52) | Se explicó que Instance Connect pasa la opción al arrancar el servicio; el acceso se comprobó con la segunda sesión |
| La primera versión de D-124 decía que el nivel de Fit y Sort se agregaría a `NewGameOptions`, un tipo del motor que no puede llevar el nivel propio de cada variante; el comentario del código además nombraba variantes dentro del motor | Subagente `architecture-reviewer` (IA-55) | El comentario es genérico y la pregunta quedó abierta como D-125, con una recomendación |
| Los `.puml` de clases seguían con `createSession(o: StartOptions)`, y el esbozo de ARQ-02 §3.1 llamaba a `createSession` sin pasar por `StartGameUseCase` ni por los aspectos | Subagente `architecture-reviewer` (IA-55) | `createSession(o: NewGameOptions)` en los tres diagramas; el esbozo arma `StartGameUseCase` con `AspectChain` |
| Llamó `P-xx` a una decisión nueva (D-126); en el proyecto `P-*` son las preguntas al profesor, y además la dejó abierta en `PENDIENTES.md` aunque el usuario ya la había decidido | El usuario (IA-56) | Se registró como D-126 y se cerró en `DECISIONES.md` |
| `/ai-usage` nueva editó `shuffle.dart` y dejó pendiente el número de PR | Evaluación con `skill-creator`, primera iteración (IA-57) | Solo cambia `AI_USAGE.md` y usa el Issue; la segunda iteración lo confirmó |
| `next_id.py` contaba como usados los IDs de ejemplo de su comentario y de una skill | Corriendo el script sobre los repos reales (IA-57) | Solo cuenta Markdown fuera de `.claude/`, con una prueba por caso |
| El `architecture-reviewer` sugirió escribir `const HexaLinesRules()` en `createRules()`. Dentro de una clase genérica una constante no puede usar `C`, así que Dart infiere `HexaLinesRules<Never>`, que la covarianza deja pasar al compilar | `checkVariantFamilyContract` falló al ejecutarse ("`LinesState<HexCoord>` is not a subtype of `LinesState<Never>`") (IA-60) | `HexaLinesRules<C>()` sin `const`, con un comentario que explica por qué |
| La primera versión de `checkVariantFamilyContract` guardaba la partida un turno después y sin tiempo, así que no detectaba una fábrica que olvide `saved.activeTime` o el historial de rehacer; dos pruebas de la fábrica repetían el bucle del código que probaban | Subagente `architecture-reviewer` (IA-60) | El contrato juega dos turnos, deshace uno si puede, guarda un tiempo distinto de cero y comprueba que la partida continuada vuelve a jugar; las pruebas usan valores calculados aparte y otra configuración de tablero |
| Claude integró los PR con `gh pr merge --delete-branch` y borró las ramas, que el equipo conserva | El usuario lo pidió a mitad del trabajo (IA-61) | Las 5 ramas se volvieron a crear desde el último commit de cada PR; los merges siguientes no borran ramas |
| Dentro de un mapa de entradas `TopologyEntry<Coord>`, la entrada hexagonal se infería como `TopologyEntry<Coord>` y la partida se abría con `C = Coord` (IA-62) | Prueba de widget de la partida, que falló en ejecución | Registro con `add<C>()`, que toma `C` del argumento, y una prueba que comprueba el tipo visitado |
| `StartGameUseCase` borraba la partida guardada antes de crear la nueva: si la creación fallaba, se perdía (IA-62) | Revisión con el subagente `architecture-reviewer` | Crea la sesión y después borra; prueba de RN-COM-35 para ese caso |
| La comprobación de paridad de ARB contaba las claves internas de los metadatos `@clave` (`description`) como mensajes (IA-62) | Falló `tool/check_architecture.dart` en local al agregar el primer ARB con metadatos | Lee el JSON y compara solo las claves de primer nivel |
| Al editar en lote los cuerpos de 26 Issues, un corte de conexión dejó vacío el de #52 (HM-04): el script escribía aunque la lectura hubiera fallado (IA-65) | Verificación posterior del largo y del responsable de cada Issue | Texto restaurado desde el historial de ediciones de GitHub (GraphQL `userContentEdits`); los reintentos se negaban a escribir un cuerpo sin la forma esperada |
| D-138 citaba "ARQ-02 §3.3", una sección que no existe, y `GameEngine.check` respondía aunque el motor estuviera cerrado (IA-66) | `architecture-reviewer` antes del PR | Cita corregida a §2 y §9.6; `check` lanza `StateError` con el motor cerrado, con su prueba |
| La pantalla de TEC-11 mostraba su contenido con `WidgetsApp.builder`, sin `Navigator` ni `Overlay`, así que arrastrar una pieza fallaba también en la app (IA-62, IA-67) | La primera prueba de widget del arrastre de HL-02 | `HexaBlockApp` muestra la primera pantalla como ruta, con `home` y `pageRouteBuilder` |
| D-137 pedía rebasar la rama del siguiente PR apilado, lo que exige un *force push* que SEC-AGT-02 prohíbe (IA-63, IA-68) | El *hook* de git bloqueó el *force push* al integrar la primera parte de HL-02 | Precisión de D-137 en los dos repos: merge de `main` en vez de rebase |
| El plan de HL-03 dejaba los valores del puntaje (5 puntos por celda, tope ×3) como constantes en el código, aunque RNF-11 pide leerlos de la configuración (IA-69, IA-70) | `architecture-reviewer` antes del PR | D-139: los valores pasan a `hexa-lines.json` y la fábrica se los da a las políticas |
| Una prueba de HL-04 (misma semilla, mismas bandejas) pasaba sin la implementación, porque las dos bandejas quedaban vacías y eran iguales (IA-71) | Al correr las pruebas antes de implementar, para ver que fallaran por la razón esperada | La prueba exige además que la bandeja final esté llena |
| La prueba `RN-HL §11` de HL-04 parecía cubrir todo el orden de notificaciones, pero solo ve los eventos de las reglas; el motor publica `ScoreChanged` después de todos ellos (D-94), y §11 pide el puntaje antes de la bandeja nueva (IA-71) | `architecture-reviewer` antes del PR | La prueba dice su alcance y el desajuste quedó abierto como D-140 para el equipo |
| La primera versión de HL-06 emitía el récord nuevo sobre el último estado sin copiar su vista previa, así que un arrastre durante el guardado la perdía; además, `SaveProgressUseCase` comprobaba la forma del progreso con un `if case` que no avisaría al llegar la forma por niveles (IA-74) | `architecture-reviewer` antes del PR | Se copia la vista previa (con una prueba que falla sin la corrección) y el caso de uso usa un `switch` exhaustivo; la duda sobre `IProgressModel` quedó como D-143, cerrada por el equipo con la opción A |
| La rama de IA-72 cerró D-140 en los §11 y en `DECISIONES.md` cuando el PR de HL-06 (IA-74) ya lo había hecho en `main`; dos sesiones trabajaban en paralelo | Conflicto del PR en GitHub al integrar `main` | Se dejaron los documentos de `main` y el PR quedó solo con la prueba del orden completo |
| El hook `commit-msg` de `lefthook.yml` pasaba la ruta del mensaje sin comillas, así que en un *worktree* con espacios en la ruta todo commit fallaba (IA-76) | Un commit de merge en un *worktree* falló con la ayuda de `commitlint` | `"{1}"` entre comillas, probado con un mensaje inválido y uno válido |
| Los repositorios Drift en `adapters/repositories/` (capa 3) importaban `AppDatabase` (capa 4) y `package:drift`, contra `ARQ-01-APP` §2 y `capas.mmd` (IA-92) | Subagente `architecture-reviewer` antes del PR | Movidos a `app/lib/frameworks/persistence/` (capa 4) implementando los puertos de capa 2 (D-156); la segunda revisión dio 0 bloqueantes |
| La entrada de IA del #142 usaba IA-88, que `main` ya tenía por #143, y `activate` de Drift pisaba la fecha de creación de un perfil existente (IA-94) | Revisión de los PR de PRG-03 con Claude Code | Pasó a IA-93; `activate` actualiza solo el nombre y la marca de activo, con una prueba que falla sin el arreglo |

### 4.3 Reflexión del equipo

⚠️ Completar por el equipo: impacto de la IA en la productividad y en la calidad, qué funcionó y qué no.

## 5. Fuentes de algoritmos y referencias sugeridos por la IA

| Tema | Fuente | Dónde se usa |
|---|---|---|
| Generador xorshift32 | G. Marsaglia, "Xorshift RNGs", *Journal of Statistical Software* 8(14), 2003 | RN-COM-43, E-COM-1 (D-14) |
| Coordenadas axiales y cúbicas de hexágonos, vecindad, rotación y distancia; conversión entre píxeles y celdas *pointy-top* y redondeo cúbico | A. Patel, "Hexagonal Grids", Red Blob Games | `02-RN-TOPOLOGIAS.md` (RN-HEX-*); `app/lib/frameworks/ui/board/hex_layout.dart` |
| Riesgos de seguridad | OWASP API Security Top 10 (2023), OWASP Top 10:2025, OWASP MASVS, OWASP Top 10 for Agentic Applications (2026) | `docs/security/SECURITY-BASELINE.md` |
| Formato de commits | Conventional Commits 1.0.0 | Enunciado §6.2, ADR-001 §2.4 |

Cuando el código implemente uno de estos algoritmos, el comentario de la clase cita la fuente (§7.3).

## 6. Plantilla para nuevas entradas

Copiar al final de la sección 3, con el siguiente ID libre (los IDs no se reutilizan):

```markdown
### IA-NN · <tarea> — <solo app | compartido>

| Campo | Contenido |
|---|---|
| Fecha | DD-MM-AAAA |
| Herramienta | <herramienta y modelo exacto> |
| Prompt | Literal o paráfrasis fiel |
| Resultado | Qué produjo (archivos, PR) |
| Modificaciones del equipo | Qué se cambió del resultado y por qué |
| Lecciones | Limitaciones o aprendizajes |
```
