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

### IA-55 · Interfaz `VariantFamily` y `NewGameOptions` en el motor, antes de HL-01 (TEC-01, D-124) — solo app

| Campo | Contenido |
|---|---|
| Fecha | 23-11-2026 |
| Herramienta | Claude Code (extensión de VS Code) con Claude Opus 5.5 (`claude-opus-5-5`) |
| Prompt | Paráfrasis fiel del pedido: implementar Hexa Lines (HL-01 a HL-06, #32 a #37), una historia por PR y en orden, con `/implement-story`. HL-01 es la primera fábrica de variante: sigue D-116 y escribe `checkVariantFamilyContract`. La variante solo implementa los pasos del turno (D-36) y no cambia el motor: si al motor le falta algo, detenerse y proponer opciones, porque ese cambio va en su propio PR. No tocar TEC-01 (#64). Cada `E-HL-*` es una prueba y no se inventan reglas. Si falta una pantalla, proponer opciones y esperar. Si el PR anterior no está integrado, crear la rama desde la suya. Al terminar, `architecture-reviewer`, PR con la plantilla y la entrada de `AI_USAGE.md` con el siguiente ID libre. Respuesta del usuario a las 5 propuestas, literal: "Me gusta las recomendaciones, las pruebas tienes que estar bien hechas, Un PR por Issue, aunque estamos haciendo una variante debe haber la posibilidad hacer las otras variantes, una pregunta aqui se van a hacer los casos de uso y si es asi van a ser genericos para manejar los tipos de juegos?" |
| Resultado | Antes de escribir HL-01, Claude encontró que `VariantFamily` no existía en el código y que `createSession(options)` no tenía tipo: el `StartOptions` de ARQ-03 es de la capa 2 y la interfaz es de la capa 1. Propuso 5 decisiones con opciones (dónde vive `VariantFamily` y qué recibe una partida nueva, el color de la pieza, el formato del catálogo, la bandeja y qué hacer sin la pantalla de NAV-01). PR #112 (rama `feat/tec-01-variant-family`, `Refs #64`): `VariantFamily<C, TCell, TMove, TState>` y `NewGameOptions` en `hexa_engine/lib/src/session/`, `Xorshift32.maxSeed` público y 6 pruebas en `group('D-124')`. D-124 cerrada y D-125 abierta en PENDIENTES (cómo llega el nivel a la fábrica de Fit y Sort). ARQ-02 (§2, §3.1, §9.1, §11, §12), ARQ-03 §3 y los tres `.puml` de clases actualizados. Claude respondió que los casos de uso (capa 2, `hexa_application`) son genéricos, uno por tipo para las 4 variantes (RNF-07), y que no son parte de las historias HL |
| Modificaciones del equipo | El usuario aceptó las 5 recomendaciones (A en todas) y pidió pruebas bien hechas, un PR por Issue y que el diseño deje hacer las otras variantes. ⚠️ Completar con lo que ajuste quien revise las pruebas (D-59) |
| Lecciones | (1) Un diseño documentado (D-100, D-116) no garantiza que el código exista: hay que buscarlo antes de planificar la historia que lo usa. (2) El `architecture-reviewer` encontró que la primera versión de D-124 prometía poner el nivel en `NewGameOptions`, que no puede llevar el nivel propio de cada variante sin un *cast* o un genérico más. Se dejó abierto como D-125 en vez de decidirlo sin el equipo. (3) Cambiar una firma obliga a revisar también los `.puml` y los esbozos de los documentos, no solo el código |

## 4. Evaluación crítica

### 4.1 Porcentaje aproximado de asistencia

| Parte | Asistencia de IA |
|---|---|
| Código de la app | Motor (`hexa_engine`, desde IA-43; ciclo de turno en IA-45; generador, reloj y estrategias en IA-47; deshacer, cronómetro y sesión en IA-48; `VariantFamily` y `NewGameOptions` en IA-55) y topología hexagonal (`hexa_topologies`, IA-44): escritos con Claude Code, con el diseño y las decisiones del equipo. ⚠️ El equipo estima el porcentaje al cerrar M1 |
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
| La primera versión de D-124 decía que el nivel de Fit y Sort se agregaría a `NewGameOptions`, un tipo del motor que no puede llevar el nivel propio de cada variante; el comentario del código además nombraba variantes dentro del motor | Subagente `architecture-reviewer` (IA-55) | El comentario es genérico y la pregunta quedó abierta como D-125, con una recomendación |
| Los `.puml` de clases seguían con `createSession(o: StartOptions)`, y el esbozo de ARQ-02 §3.1 llamaba a `createSession` sin pasar por `StartGameUseCase` ni por los aspectos | Subagente `architecture-reviewer` (IA-55) | `createSession(o: NewGameOptions)` en los tres diagramas; el esbozo arma `StartGameUseCase` con `AspectChain` |

### 4.3 Reflexión del equipo

⚠️ Completar por el equipo: impacto de la IA en la productividad y en la calidad, qué funcionó y qué no.

## 5. Fuentes de algoritmos y referencias sugeridos por la IA

| Tema | Fuente | Dónde se usa |
|---|---|---|
| Generador xorshift32 | G. Marsaglia, "Xorshift RNGs", *Journal of Statistical Software* 8(14), 2003 | RN-COM-43, E-COM-1 (D-14) |
| Coordenadas axiales y cúbicas de hexágonos, vecindad, rotación y distancia | A. Patel, "Hexagonal Grids", Red Blob Games | `02-RN-TOPOLOGIAS.md` (RN-HEX-*) |
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
