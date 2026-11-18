# AI_USAGE — hexablock-app

> Registro del uso de herramientas de IA en el repositorio de la app, como exige el enunciado §7.2. Se actualiza **en cada PR que use IA** (RNF-62, SEC-AGT-08, plantilla de PR).
>
> Las tareas de planificación que producen documentos compartidos aparecen **con el mismo ID** en el `AI_USAGE.md` de `hexablock-api`.
>
> **Última actualización:** 2026-11-17 (IA-13)

Los campos marcados con ⚠️ los tiene que completar el equipo: la IA no conoce esos datos y no se inventaron.

---

## 1. Herramientas utilizadas

| Herramienta | Versión o modelo | Rol en el flujo de trabajo | Quién la usa |
|---|---|---|---|
| **Claude** (claude.ai, conversación con herramientas de agente: archivos, terminal, git) | **Claude Opus 5.5** (`claude-opus-5-5`) desde el 12-11-2026. Conversaciones anteriores: ⚠️ completar el modelo | Planificación: propone opciones con ventajas y desventajas, redacta los documentos de `docs/`, verifica los ejemplos de reglas con código, revisa la coherencia entre documentos y sube los cambios por rama y PR | DanielHaro28 |
| **Claude Code** | ⚠️ completar al empezar a usarlo (versión de la CLI y modelo) | Herramienta principal de implementación (ADR-001 §2.6), con los permisos de `.claude/settings.json` | Todo el equipo |
| **Cline** | ⚠️ completar si se usa | Permitida de forma individual; sus reglas solo apuntan a `docs/` (ADR-001 §2.6) | ⚠️ |

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
