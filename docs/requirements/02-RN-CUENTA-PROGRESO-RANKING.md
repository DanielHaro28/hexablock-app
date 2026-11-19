# 02 — Reglas de negocio: cuenta, progreso y ranking

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 (revisión de coherencia: 12-11; D-27, D-45, D-49 y D-50: 19-11) |
| Repositorio | **Compartido:** `hexablock-app` y `hexablock-api`, en `docs/requirements/`. Las dos copias deben ser **idénticas**: se modifica en un PR de cada repo, con el mismo cambio |
| Relacionados | `02-RN-NIVELES.md`, `docs/security/SECURITY-BASELINE.md` |

**Figura de celda (D-25, 11-11):** el jugador elige la figura (hexágonos, cuadrados, triángulos o cubos) antes de jugar y no puede cambiarla durante la partida. Por eso la **topología** es una dimensión más del progreso y del ranking, junto con el `gameId`.

**Por qué es un documento compartido:** la **app** guarda el progreso, lo consolida localmente y maneja los perfiles y la cola sin conexión. El **backend** consolida en el servidor y calcula el ranking. Las dos partes deben aplicar **exactamente** las mismas reglas de consolidación y de orden.

Formato de las reglas y estados (✅ acordada / 🟡 propuesta / ⚠️ decidir): ver `02-RN-COMUNES.md` §0 en el repo de la app. Términos: `01-GLOSARIO.md`.

| Parte | Responsable |
|---|---|
| Perfiles locales, cola sin conexión, importar progreso de invitado (RN-COM-81, 82, 85, 87 a 89) | App |
| Consolidación (RN-COM-83, 84) | **Ambos**, con la misma regla y los mismos ejemplos de prueba |
| Sincronización (RN-COM-86, 90) | App (cliente) + backend (endpoint) |
| Ranking (RN-COM-100 a 108) | Backend (cálculo) + app (pantalla) |

---

## 1. Progreso, perfiles y sincronización

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-80 | El progreso se guarda **por perfil, por variante y por figura de celda** (topología; RN-TOP-33, D-27): niveles completados, mejor intento por nivel y récord. En el servidor hay **una entrada por usuario y variante**, con **una sección por figura** dentro (D-27). El contenido de cada sección tiene una de **dos formas**, según el modelo de progreso de la variante: **récord** (Lines, Merge) o **niveles** con su mejor intento (Fit, Sort) (D-45) | Enunciado §5.1, §5.2 | ✅ (por figura: D-27, 19-11) |
| RN-COM-81 | **Modo invitado:** sin cuenta se pueden jugar las 4 variantes y el progreso se guarda en el dispositivo, en el perfil **invitado** | Profesor (P-08) | ✅ |
| RN-COM-82 | **Offline-first:** con o sin conexión, el juego funciona igual. El progreso se guarda **primero en el dispositivo**; la conexión solo hace falta para sincronizar, ver el ranking global y descargar niveles nuevos | Profesor (P-08) | ✅ |
| RN-COM-83 | **El progreso solo mejora.** Para combinar dos versiones del mismo progreso (dispositivo y servidor, o dos dispositivos) se aplica la **consolidación**: niveles completados = **unión**; récord = **máximo**; mejor intento de cada nivel = **el mejor de los dos** según el criterio de la variante, tomado completo | Profesor (P-08) | ✅ |
| RN-COM-84 | La consolidación da el mismo resultado sin importar el orden ni cuántas veces se repita. Por eso, reintentar una sincronización o sincronizar desde varios dispositivos nunca pierde progreso ni lo duplica | Consecuencia de RN-COM-83 | ✅ |
| RN-COM-85 | Un usuario con cuenta y **sin conexión** sigue jugando normalmente; cada cambio de progreso se guarda en la **cola de sincronización** del dispositivo | Profesor (P-08) | ✅ |
| RN-COM-86 | Al recuperar la conexión con sesión válida, la app envía, por cada variante con cambios, **solo los resultados que cambiaron** desde la última sincronización confirmada (cada uno en la sección de su figura). El servidor los consolida con los suyos y devuelve el resultado de lo enviado, que la app guarda; después quita la marca de pendiente. Enviar solo una parte es seguro porque la consolidación da lo mismo sin importar el orden ni las repeticiones (RN-COM-84). El progreso completo solo se descarga al iniciar sesión (RN-COM-90) | Diseño (P-08) | ✅ D-49 (19-11) |
| RN-COM-87 | Si la sesión **expiró** mientras estaba sin conexión, se sigue jugando; antes de sincronizar se pide iniciar sesión otra vez. La cola no se pierde | Diseño | 🟡 |
| RN-COM-88 | Al **iniciar sesión** en un dispositivo con progreso de invitado: se le pregunta al jugador si quiere **importar** ese progreso a su cuenta. Si acepta, se consolida con el de la cuenta; si no, el progreso de invitado queda intacto en su perfil | Equipo | ✅ D-05 (11-11) |
| RN-COM-89 | Al **cerrar sesión**, el dispositivo vuelve al perfil **invitado** con su propio progreso. El progreso de la cuenta queda guardado localmente para cuando vuelva a iniciar sesión | Equipo | ✅ D-06 (11-11) |
| RN-COM-90 | Al iniciar sesión en un dispositivo nuevo, se descarga y consolida el progreso de las 4 variantes, en todas las figuras que tenga | HU API-03 | ✅ |

**Ejemplo E-COM-2 (consolidación).**

| Dato (Hexa Fit) | En el dispositivo | En el servidor | Resultado |
|---|---|---|---|
| Niveles completados | {1, 2, 3} | {1, 2, 4} | {1, 2, 3, 4} |
| Mejor intento nivel 2 | 3★, 01:40, 9 mov. | 3★, 01:10, 12 mov. | 3★, 01:10, 12 mov. (mismas estrellas, menor tiempo) |
| Mejor intento nivel 1 | 2★, 00:30, 4 mov. | 3★, 02:00, 7 mov. | 3★, 02:00, 7 mov. (más estrellas) |

Aplicar la consolidación otra vez con el resultado no cambia nada.

## 2. Ranking

| ID | Regla | Fuente | Estado |
|---|---|---|---|
| RN-COM-100 | Hay un ranking global **por `gameId` y por figura de celda** (RN-TOP-33, D-27) y, en las variantes por niveles, también **por nivel** | Enunciado §5.2 | ✅ (por figura: D-27, 19-11) |
| RN-COM-101 | Variantes sin fin (Lines, Merge): se ordena por **récord descendente** | Enunciado §1.5 | ✅ |
| RN-COM-102 | Hexa Fit por nivel: **estrellas ↓ → tiempo ↑ → movimientos ↑**, comparando el mejor intento **completo** de cada jugador | Profesor (P-07) | ✅ |
| RN-COM-103 | Hexa Sort por nivel: **movimientos ↑ → puntaje ↓** (gana quien completa el nivel colocando menos pilas; el puntaje solo desempata). Así el ranking premia la eficiencia y no alargar la partida | Equipo | ✅ D-04 / D-12 (11-11) |
| RN-COM-104 | Ranking global por variante en las variantes por niveles: **niveles completados ↓ → suma de estrellas ↓ (solo Fit)** | Equipo | 🟡 |
| RN-COM-105 | Si dos jugadores empatan en todos los criterios, va primero el que **logró antes** el resultado | Diseño | 🟡 |
| RN-COM-106 | El ranking muestra el **nombre visible** y la posición, **nunca el correo**. Con sesión iniciada, el jugador ve su propia posición aunque no esté en el top | HU API-04, SEC-API-03 | ✅ |
| RN-COM-107 | Los invitados no aparecen en el ranking global. Si un invitado crea una cuenta e importa su progreso (RN-COM-88), sus resultados pasan a contar desde ese momento | Diseño | 🟡 |
| RN-COM-108 | El servidor rechaza resultados **no plausibles** (puntaje negativo o por encima del tope de la variante, estrellas fuera de 1–3, nivel inexistente, `gameId` desconocido) | SECURITY SEC-API-06 | ✅ |
| RN-COM-109 | El **nombre visible** es **único** sin distinguir mayúsculas, tiene de **3 a 20 caracteres** (letras, números, espacio, `_`, `-` y `.`) y no empieza ni termina con espacio. Si otra cuenta ya lo usa, el registro se rechaza con **409** y el código `DISPLAY_NAME_TAKEN` | Equipo | ✅ D-50 (19-11) |

**Ejemplo E-COM-3 (orden del ranking por nivel).**

| Hexa Fit, nivel 3 | Estrellas | Tiempo | Movimientos | Posición |
|---|---|---|---|---|
| Ana | 3★ | 01:10 | 12 | 2 |
| Beto | 3★ | 01:10 | 9 | **1** (empata en estrellas y tiempo; menos movimientos) |
| Caro | 2★ | 00:30 | 3 | 3 (menos estrellas, aunque fue más rápida) |

| Hexa Sort, nivel 2 | Movimientos | Puntaje | Posición |
|---|---|---|---|
| Ana | 12 | 300 | 3 |
| Beto | 12 | 450 | 2 |
| Caro | 10 | 112 | **1** (menos movimientos; el puntaje solo desempata) |

_(Los puntajes de Hexa Sort son posibles según RN-HS-60: completar un nivel exige al menos 1 meta y al menos 1 ficha transferida, así que el mínimo es 101.)_

**Criterios de "mejor intento" por variante** (los usan la consolidación y el ranking):

| Variante | Mejor intento | Regla |
|---|---|---|
| Hexa Lines | Mayor puntaje | RN-COM-101 |
| Hexa Merge | Mayor puntaje | RN-COM-101 |
| Hexa Fit (por nivel) | Estrellas ↓ → tiempo ↑ → movimientos ↑ | RN-COM-102 |
| Hexa Sort (por nivel) | Movimientos ↑ → puntaje ↓ | RN-COM-103 |
