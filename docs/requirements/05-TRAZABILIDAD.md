# 05 — Matriz de trazabilidad · App (`hexablock-app`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app`. La matriz del backend está en el mismo archivo de `hexablock-api` |

**Para qué sirve:** demostrar que todo lo que pide el enunciado está cubierto por un requisito, que cada requisito tiene una historia y sus reglas, y que cada ejemplo de las reglas se convierte en una prueba. Cuando existan las pruebas, se agrega su nombre en la columna **Pruebas**.

**Regla de mantenimiento:** todo PR que agregue o cambie un RF, una HU, una RN o un ejemplo actualiza esta matriz en el mismo PR.

---

## 1. Enunciado → requisitos

### 1.1 Funcionalidades mínimas (§5)

| Enunciado | Qué pide | RF |
|---|---|---|
| §5.1 (1) | Inicio, ajustes y selector de juego | RF-01 |
| §5.1 (2) | Selección de niveles con progreso y bloqueo | RF-02, RF-61 |
| §5.1 (3) | Motor genérico compartido | RF-10, RF-11, RF-12 |
| §5.1 (4) | Lines y Merge sin fin con puntaje máximo | RF-20 a 24, RF-50 a 54 |
| §5.1 (5) | Fit ≥ 15 niveles y Sort ≥ 10, desde configuración | RF-30, RF-40 |
| §5.1 (6) | Puntuación por variante definida por el equipo | RF-22, RF-34, RF-44, RF-51 |
| §5.1 (7) | Pantallas de victoria y derrota | RF-06, RF-07 |
| §5.1 (8) | Deshacer/rehacer en Fit; deshacer 1 en Merge | RF-33, RF-53 |
| §5.1 (9) | Persistencia local por variante | RF-60 |
| §5.1 (10) | Música y efectos con silencio | RF-04 |
| §5.1 (11) | Español e inglés | RF-03 |
| §5.2 (1) | Registro e inicio de sesión con JWT (pantallas y token seguro) | RF-70, RF-71, RF-75 |
| §5.2 (2) | Sincronización de progreso por `gameId` (cliente, cola, consolidación local) | RF-72, RF-73 |
| §5.2 (3) | Ranking por `gameId` y por nivel (pantalla) | RF-74, RF-75 |
| §5.2 (4) | Niveles remotos (descarga y validación completa) | RF-80, RF-82, RF-83 |
| §5.2 (5), (6) | Swagger y errores | Solo servidor → `hexablock-api` |
| Profesor (P-08) | Modo invitado y offline-first | RF-62, RF-63, RF-73 |

### 1.2 Descripción de las variantes (§1)

| Enunciado | RF | Reglas |
|---|---|---|
| §1.1 Hexa Lines | RF-20 a 24 | `02-RN-HEXA-LINES.md` |
| §1.2 Hexa Fit | RF-30 a 34 | `02-RN-HEXA-FIT.md` |
| §1.3 Hexa Sort | RF-40 a 44 | `02-RN-HEXA-SORT.md` |
| §1.4 Hexa Merge | RF-50 a 54 | `02-RN-HEXA-MERGE.md` |
| §1.5 Dimensiones de variabilidad | RF-10 | Tabla "Dimensión" al inicio de cada `02-RN-HEXA-*.md` |

### 1.3 Requisitos técnicos y de entrega (§2 a §9)

| Enunciado | Qué pide | RNF |
|---|---|---|
| §2 | Un solo motor, sin duplicación | RNF-01, RNF-02 |
| §3.1 | Programación genérica, restricciones de tipo, extensibilidad | RNF-01 a 05, RNF-11 |
| §3.2 | SOLID documentado | RNF-08 |
| §3.3 | Patrones GoF (Strategy y Abstract Factory obligatorios) | RNF-09 |
| §3.4 | Clean Architecture | RNF-06, RNF-07 |
| §3.5 | AOP con decoradores/proxies | RNF-10 |
| §3.6 | Pruebas y CI | RNF-20 a 26 |
| §4 | Diagramas de clases, capas y extensibilidad | RNF-61 |
| §6 | README en inglés y Conventional Commits | RNF-60, RNF-26 |
| §7 | Documentación del uso de IA | RNF-62 |
| §8 | Ejecutable en GitHub Release | RNF-52 |
| §9 | Participación individual | RNF-63 |
| Profesor (11-11) | Topología intercambiable: triángulos, cuadrados, hexágonos y cubos | RNF-04 |
| Equipo (D-25) | El jugador elige la figura de las celdas; fija durante la partida | RF-09 |
| SECURITY-BASELINE | Controles de seguridad de la app | RNF-40 |

---

## 2. Requisitos → historias → reglas → ejemplos

| RF | Historias | Reglas | Ejemplos (→ pruebas) | Pruebas |
|---|---|---|---|---|
| RF-01 | NAV-01 | RN-COM-01, 02 | — | |
| RF-02 | HF-01, HS-01 | RN-COM-73, RN-HF-72, RN-HS-72 | — | |
| RF-03 | NAV-03 | RN-COM-110, 112 | — | |
| RF-04 | NAV-02 | RN-COM-111 | — | |
| RF-05 | NAV-04 | RN-COM-24, 30 a 35, 52 | — | |
| RF-06 | PRG-01 | RN-COM-31, RN-HF-64, RN-HS-61, RN-HM-51 | — | |
| RF-07 | PRG-02 | RN-COM-31 | — | |
| RF-08 | NAV-05 | — | — | |
| RF-09 | NAV-08 | RN-COM-113, RN-TOP-30 a 34 | — | |
| RF-10 | TEC-01, TEC-06 | RN-COM-10 a 25 | E-COM-1, E-HEX-1, E-TRI-1, E-TRI-2, E-SQR-1, E-CUB-1 | |
| RF-11 | HL-02, HF-02, HS-02, HM-01 | RN-COM-21 | E-HL-3, E-HF-2, E-HS-6, E-HM-4 | |
| RF-12 | TEC-01, HS-03 | RN-COM-25, RN-HS-45 | — | |
| RF-20 | HL-01, HL-04 | RN-HL-10, 11, 20 a 25 | — | |
| RF-21 | HL-02 | RN-HL-22, 30 a 32 | E-HL-3 | |
| RF-22 | HL-03 | RN-HL-40 a 44, 60 a 64 | E-HL-1, E-HL-2 | |
| RF-23 | HL-05 | RN-HL-50 a 52 | E-HL-4 | |
| RF-24 | HL-06 | RN-HL-70, 71 | — | |
| RF-30 | HF-01 | RN-COM-03, RN-HF-10 a 13 | E-HF-NIVEL | |
| RF-31 | HF-02, HF-04 | RN-HF-30, 32 a 34 | E-HF-1, E-HF-2 | |
| RF-32 | HF-03 | RN-COM-14, RN-HF-31 | E-HEX-1 | |
| RF-33 | HF-05 | RN-HF-80 a 82 | E-HF-1, E-HF-3 | |
| RF-34 | HF-06 | RN-HF-50 a 52, 60 a 64, 70, 71 | E-HF-1, E-HF-4 | |
| RF-40 | HS-01 | RN-COM-03, RN-HS-10 a 12 | — | |
| RF-41 | HS-02 | RN-HS-20 a 22, 30, 31 | E-HS-6 | |
| RF-42 | HS-03 | RN-HS-40 a 45, RN-COM-17 | E-HS-1, E-HS-2, E-HS-3, E-HS-8 | |
| RF-43 | HS-04, HS-05 | RN-HS-50 a 54 | E-HS-4, E-HS-5, E-HS-7 | |
| RF-44 | HS-05 | RN-HS-60, 61, 70, 71 | E-HS-4 | |
| RF-50 | HM-01 | RN-HM-30, 31, 40, 41 | E-HM-1, E-HM-3, E-HM-4 | |
| RF-51 | HM-02 | RN-HM-40 a 43, 60, 61 | E-HM-1, E-HM-2, E-HM-3 | |
| RF-52 | HM-03 | RN-COM-40 a 45, RN-HM-11, 20 a 22 | E-COM-1, E-HM-6 | |
| RF-53 | HM-04 | RN-HM-80 a 83 | E-HM-7 | |
| RF-54 | HM-05 | RN-HM-50 a 53, 70 | E-HM-5 | |
| RF-60 | PRG-03 | RN-COM-80 | — | |
| RF-61 | PRG-04 | RN-COM-73 | — | |
| RF-62 | API-05 | RN-COM-81, 107 | — | |
| RF-63 | API-08 | RN-COM-82, 85 | — | |
| RF-64 | NAV-04 | RN-COM-32 a 35, 42 | — | |
| RF-70 | API-01 | SEC-MOB-01 | — | |
| RF-71 | API-02, API-07 | RN-COM-87, 89, SEC-MOB-04 | — | |
| RF-72 | API-03, API-08 | RN-COM-83 a 87, 90 | E-COM-2 | |
| RF-73 | API-06 | RN-COM-83, 88 | E-COM-2 | |
| RF-74 | NAV-07 | RN-COM-100 a 107 | E-COM-3 | |
| RF-75 | API-01, API-02, NAV-06, NAV-07 | RN-COM-81, 88 | — | |
| RF-80 | LVL-01 | RN-COM-70 a 72, 74, 75 | — | |
| RF-82 | LVL-01 | RN-COM-71, 76, RN-HF-12, RN-HS-12 | E-HF-NIVEL (y sus variaciones) | |
| RF-83 | LVL-01 | RN-COM-76 | E-HF-NIVEL (variación que falla f) | |

**Historias sin RF (solo RNF):** TEC-02 (RNF-03, 04), TEC-03 (RNF-10), TEC-04 (RNF-24, 26, 52), TEC-06 a TEC-09 (RNF-04).

**RF solo de servidor** (en `hexablock-api`): RF-81, RF-90 a 93.

---

## 3. Ejemplos → pruebas

Cada ejemplo de las reglas de negocio debe tener al menos una prueba automatizada (RNF-22). Lista de control:

| Ejemplo | Documento | Qué prueba | Capa | Prueba |
|---|---|---|---|---|
| E-COM-1 | RN-COMUNES | Secuencia de xorshift32 con semilla 12345 | Dominio | |
| E-COM-2 | RN-CUENTA (compartido) | Consolidación de progreso (unión, máximo, mejor intento) y que repetirla no cambia nada. **Mismos datos que en el backend** | Dominio | |
| E-COM-3 | RN-CUENTA (compartido) | Orden del ranking por nivel (lo calcula el backend; la app lo usa para su mejor intento local) | Dominio | |
| E-HEX-1 | RN-TOPOLOGIAS | Rotación de 60° y vuelta completa (hexágonos) | Dominio | |
| E-TRI-1 | RN-TOPOLOGIAS | Tablero de triángulos de lado 2 (24 celdas, líneas 5-7-7-5) | Dominio | |
| E-TRI-2 | RN-TOPOLOGIAS | Giro de triángulos y conservación de vecindades | Dominio | |
| E-SQR-1 | RN-TOPOLOGIAS | Giro de 90° de la L de 3 | Dominio | |
| E-CUB-1 | RN-TOPOLOGIAS | 24 orientaciones del cubo | Dominio | |
| E-HL-1 | RN-HEXA-LINES | Una línea, 27 puntos | Dominio | |
| E-HL-2 | RN-HEXA-LINES | Dos líneas cruzadas, celda compartida, 101 / 151 puntos | Dominio | |
| E-HL-3 | RN-HEXA-LINES | Colocaciones inválidas | Dominio | |
| E-HL-4 | RN-HEXA-LINES | Fin de partida y continuación con un mono | Dominio | |
| E-HF-NIVEL | RN-NIVELES (compartido) | Nivel válido y sus 3 variaciones inválidas, incluida la geométrica (f) | Dominio | |
| E-HF-1 | RN-HEXA-FIT | Partida completa, conteo de movimientos, 2★ por estrellas independientes | Dominio | |
| E-HF-2 | RN-HEXA-FIT | Colocaciones inválidas | Dominio | |
| E-HF-3 | RN-HEXA-FIT | Rehacer descartado | Dominio | |
| E-HF-4 | RN-HEXA-FIT | Mejor intento | Dominio | |
| E-HS-1 | RN-HEXA-SORT | Transferencia simple | Dominio | |
| E-HS-2 | RN-HEXA-SORT | Empate → pila colocada | Dominio | |
| E-HS-3 | RN-HEXA-SORT | Cascada | Dominio | |
| E-HS-4 | RN-HEXA-SORT | Meta, 104 puntos | Dominio | |
| E-HS-5 | RN-HEXA-SORT | Meta antes de procesar todos los orígenes | Dominio | |
| E-HS-6 | RN-HEXA-SORT | Celda ocupada | Dominio | |
| E-HS-8 | RN-HEXA-SORT | Empate entre vecinas → orden horario | Dominio | |
| E-HS-7 | RN-HEXA-SORT | Victoria y derrota | Dominio | |
| E-HM-1 | RN-HEXA-MERGE | Fusión hacia el E, 12 puntos | Dominio | |
| E-HM-2 | RN-HEXA-MERGE | Una fusión por ficha | Dominio | |
| E-HM-3 | RN-HEXA-MERGE | Diagonal NE | Dominio | |
| E-HM-4 | RN-HEXA-MERGE | Movimiento inválido | Dominio | |
| E-HM-5 | RN-HEXA-MERGE | Derrota | Dominio | |
| E-HM-6 | RN-HEXA-MERGE | Inicio determinista con semilla | Dominio | |
| E-HM-7 | RN-HEXA-MERGE | Deshacer restaura el generador | Dominio | |

---

## 4. Chequeos de cobertura

| Chequeo | Resultado |
|---|---|
| Cada punto de §5.1 y §5.2 tiene al menos un RF | ✅ |
| Cada RF tiene al menos una historia | ✅ |
| Cada historia tiene un RF o un RNF | ✅ |
| Cada variante tiene sus reglas con ejemplos | ✅ (Lines 4, Fit 5, Sort 8, Merge 7) |
| Cada topología tiene ejemplos | ✅ (hexágonos 1, triángulos 2, cuadrados 1, cubos 1) |
| Cada ejemplo tiene una prueba | ⏳ Pendiente (se completa durante la implementación) |
| Decisiones abiertas que afectan reglas | ⚠️ D-20 (catálogos de piezas de cuadrados, triángulos y cubos) y D-26 (figura global) |
