# AI_USAGE — hexablock-app

> Registro del uso de herramientas de IA en el repositorio de la app, como exige el enunciado §7.2. Se actualiza **en cada PR que use IA** (RNF-62, SEC-AGT-08, plantilla de PR).
>
> Las tareas de planificación que producen documentos compartidos aparecen **con el mismo ID** en el `AI_USAGE.md` de `hexablock-api`.
>
> **Última actualización:** 2026-11-20 (IA-37)

Los campos marcados con ⚠️ los tiene que completar el equipo: la IA no conoce esos datos y no se inventaron.

---

## 1. Herramientas utilizadas

| Herramienta | Versión o modelo | Rol en el flujo de trabajo | Quién la usa |
|---|---|---|---|
| **Claude** (claude.ai, conversación con herramientas de agente: archivos, terminal, git) | **Claude Opus 5.5** (`claude-opus-5-5`) desde el 12-11-2026. Conversaciones anteriores: ⚠️ completar el modelo | Planificación: propone opciones con ventajas y desventajas, redacta los documentos de `docs/`, verifica los ejemplos de reglas con código, revisa la coherencia entre documentos y sube los cambios por rama y PR | DanielHaro28 |
| **Claude Code** | ⚠️ completar al empezar a usarlo (versión de la CLI y modelo) | Herramienta principal de implementación (ADR-001 §2.6), con los permisos de `.claude/settings.json` | Todo el equipo |

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

## 4. Evaluación crítica

### 4.1 Porcentaje aproximado de asistencia

| Parte | Asistencia de IA |
|---|---|
| Código de la app | 0 %: todavía no hay código |
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
