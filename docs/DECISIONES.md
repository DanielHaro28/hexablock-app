# DECISIONES — hexablock-app

> Registro de las **decisiones cerradas** que afectan a `hexablock-app`: las del equipo (`D-*`) y las respuestas del profesor o del enunciado (`P-*`).
>
> - Las decisiones **abiertas** están en `hexablock-app/docs/PENDIENTES.md` §1.1. Al cerrarse, pasan aquí con su fecha y se borran de allí.
> - Este archivo reúne **todas** las decisiones del proyecto; la columna *Repos* dice a cuál afecta cada una.
> - Las decisiones que afectan a los dos repos aparecen **con el mismo texto** en el `DECISIONES.md` de `hexablock-api` (columna *Repos*: **Ambos**). Si cambian, se cambian en los dos.
> - Si un documento citado en *Dónde quedó* no está en este repo, está en `hexablock-api`.
> - Una decisión cerrada solo se reabre si el equipo lo decide explícitamente. Los IDs nunca se reutilizan.
>
> **Última actualización:** 2026-11-17

---

## 1. Decisiones del equipo

### Organización y flujo de trabajo

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-01 | Los repos están en la cuenta de **DanielHaro28**, que los creó y los administra | ADR-001 §2.4 | Ambos | 11-11 |
| D-24 | La protección de `main` exige PR y CI en verde, pero **no** la aprobación de otra persona; autorrevisión con la plantilla de PR y revisión de un compañero recomendada | ADR-001 §2.4, SECURITY §7, SEC-AGT-05, 07 | Ambos | 11-11 |

### Cuenta, progreso y ranking

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-04 | Ranking por nivel de Hexa Sort: **movimientos ↑ → puntaje ↓** (menos pilas colocadas primero; el puntaje desempata) | RN-COM-103, RN-HS-71 | Ambos | 11-11 |
| D-05 | Al iniciar sesión con progreso de invitado, la app **pregunta** "¿importar tu progreso?"; si acepta, se consolida | RN-COM-88 | Ambos | 11-11 |
| D-06 | Al cerrar sesión, el dispositivo **vuelve al perfil invitado** con su propio progreso; el de la cuenta queda guardado localmente | RN-COM-89 | Ambos | 11-11 |

### Reglas de juego

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-08 | Catálogo de Hexa Lines: **8 familias, 24 piezas**, con los pesos propuestos | RN-HL-23 | App | 11-11 |
| D-09 | Puntaje de Hexa Lines: **celdas + ⌊5 × largo × L × racha⌋**, racha (k+1)/2 con máximo ×3 | RN-HL-60 a 64 | App | 11-11 |
| D-10 | Hexa Fit: colocar/mover/retirar cuentan como movimiento; rotar/deshacer/rehacer no. **Estrellas independientes:** ★ completar + ★ movimientos ≤ `m` + ★ tiempo ≤ `t`. Por eso un nivel completado tiene de 1 a 3 estrellas, que es lo que valida el servidor | RN-HF-61 a 64, E-HF-1, RN-COM-108, SEC-API-06 | Ambos | 11-11 |
| D-11 | Pilas de Hexa Sort: altura 2–6, hasta 3 bloques, color distinto del bloque anterior | RN-HS-21 | App | 11-11 |
| D-12 | Puntaje de Hexa Sort: 1 por ficha transferida + 100 por meta (solo desempata el ranking; ver D-04) | RN-HS-60 | Ambos | 11-11 |
| D-13 | Hexa Merge: **90 % de 2 / 10 % de 4**; celda al azar entre las vacías en orden de lectura | RN-HM-21 | App | 11-11 |
| D-14 | Generador aleatorio **xorshift32 propio** en el dominio | RN-COM-43 | App | 11-11 |
| D-15 | Desempate de la cascada de Hexa Sort: gana la pila **evaluada** (la colocada, en el primer paso) si está empatada; si no, la **primera vecina empatada en sentido horario desde las 12**. Los orígenes también transfieren en ese orden | RN-COM-17, RN-HEX-08, RN-HS-42, RN-HS-43, E-HS-8 | App | 11-11 |
| D-16 | Hexa Sort: al llegar a 10 o más se elimina **solo el bloque de cima, completo** (aunque sean 12); lo de abajo queda en la celda | RN-HS-50 | App | 11-11 |
| D-17 | Hexa Sort: "la pila con más fichas de ese color" = la de **bloque de cima más grande** | RN-HS-40, RN-HS-41 | App | 11-11 |

### Topologías (figura de las celdas)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-18 | **Topologías:** solo rejillas regulares. Hexágonos (dominio + app, Must); cuadrados y triángulos (dominio + app 2D, Should); cubos (dominio con pruebas, Should; vista 3D, Could) | RN-COM-18, RN-TOP-01 a 04 | Ambos | 11-11 |
| D-25 | **El jugador elige la figura de las celdas en Ajustes** (solo las disponibles; hexágonos por defecto). La figura se fija al crear la partida y **no se puede cambiar durante ella**: la opción se bloquea mientras haya una partida en curso o en pausa | RN-COM-19, RN-COM-113, RN-TOP-30, 31; RF-09; NAV-08 | Ambos | 11-11 |

### Arquitectura general (Paso 2)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-21 | **Paquetes de la app:** pub workspace con **4 paquetes Dart puros** y la app Flutter. Capa 1: `hexa_engine`, `hexa_topologies` y `hexa_variants` (una carpeta por variante). Capa 2: `hexa_application` (casos de uso genéricos, puertos y aspectos). Capas 3 y 4: la app (`lib/adapters/` = capa 3; `lib/frameworks/`, `lib/config/` y `main.dart` = capa 4). Los paquetes de las capas 1 y 2 no tienen dependencias de terceros (enunciado §3.4) y su `pubspec` impide importar capas externas | ARQ-01-APP §3, ARQ-A-02 a 04 | App | 17-11 |
| D-22 | **Estructura del backend:** módulos por área (`auth`, `users`, `progress`, `leaderboard`, `levels`, `health`) con `domain/` (capa 1), `application/` (capa 2: casos de uso y puertos), `presentation/` e `infrastructure/` (capa 3: controladores y DTOs; adaptadores que implementan los puertos, como repositorios Prisma, argon2 y JWT). `main.ts`, `src/prisma/` y la configuración de NestJS son capa 4. **Un caso de uso por clase.** Cómo se guarda el progreso (JSON) queda para D-27 | ARQ-01-API §2 a §4, ARQ-B-01, 02 | API | 17-11 |

### Motor genérico (Paso 3)

| ID | Decisión | Dónde quedó | Repos | Fecha |
|---|---|---|---|---|
| D-07 | **Coordenada como parámetro genérico (opción A).** `Board<TCoord extends Coord, TCell>`, `GridTopology<TCoord>`, `IGameRules<TCoord, TCell, TMove, TState>` y `GameEngine<TCoord, TCell, TMove, TState>`; `HexBoard<TCell>` es un `typedef` de `Board<HexCoord, TCell>` en `hexa_topologies` | ARQ-01-APP §4.1, §9; ARQ-02 §3; TEC-01; glosario | App | 11-11 |
| D-29 | **Despacho de la figura:** registro de topologías + **Visitor** genérico (`accept` → `visit<C>`), sin `switch` ni casts; en la app, cada figura se registra junto con su layout. `TCoord` llega hasta el widget del tablero | ARQ-02 §3 | App | 17-11 |
| D-30 | **Tipos genéricos:** estado **inmutable**; celda vacía = `null` con `TCell extends Object`; movimientos *sealed* por variante; `TState extends GameState<C, TCell>`; en Hexa Merge, `Tile implements Mergeable<Tile>` en vez de `int`. Instanciación por variante en ARQ-02 §4.2 | ARQ-02 §4 | App | 17-11 |
| D-31 | **Deshacer y rehacer:** **Command + Memento** con un `UndoHistory` genérico que configura la fábrica de cada variante (sin límite + rehacer en Fit; límite 1 sin rehacer en Merge; nada en Lines y Sort); la fase decide si se puede deshacer | ARQ-02 §5 | App | 17-11 |
| D-32 | **Eventos de dominio:** las reglas **devuelven** los eventos en orden; la pantalla los recibe como **valor de retorno** de `submit` (`MoveResult`). El `Stream` del motor (Observer) queda para el historial y el cronómetro (síncronos) y para el audio y la analítica. Base `abstract base` y una familia *sealed* por variante | ARQ-02 §6 | App | 17-11 |
| D-33 | **Capacidades opcionales:** `IUndoable`, `ITimed`, `IRandomSeeded` e `ILevelBased`, implementadas por componentes que la fábrica compone en una `GameSession` (Lines no tiene `IUndoable`); puerto `IMonotonicClock` en el dominio | ARQ-02 §7 | App | 17-11 |
| D-34 | **Fases de la partida:** patrón **State** con una jerarquía *sealed* (`PlayingPhase`, `ResolvingPhase`, `PausedPhase`, `VictoryPhase`, `GameOverPhase`); `Victory(canContinue)` para que Hexa Merge siga tras la victoria | ARQ-02 §8 | App | 17-11 |
| D-35 | **Patrones de diseño del dominio (14).** Creacionales: Abstract Factory, Builder, Factory Method. Estructurales: Bridge, Composite, Decorator. De comportamiento: Strategy, Template Method, State, Observer, Command, Memento, Iterator, Visitor. Cómo se protege el Template Method sigue abierto en D-36 | ARQ-02 §9 | App | 17-11 |

## 2. Respuestas del profesor y del enunciado

> **Indicación del profesor (11-11):** lo que el enunciado no especifica **lo decide el equipo**. Por eso no quedan preguntas abiertas: las que el enunciado no resolvía pasaron a decisiones del equipo.

| ID | Pregunta | Respuesta | Fuente | Repos | Fecha |
|---|---|---|---|---|---|
| P-01 | ¿Se aceptan repos públicos? | **Sí** | Profesor | Ambos | 11-11 |
| P-02 | ¿Se pueden rotar las piezas en Hexa Lines? | **No**. La tabla 1.5 indica "Colocar pieza" para Lines y "Colocar / retirar / rotar" solo para Fit | Enunciado §1.5 | App | 11-11 |
| P-03 | ¿La bandeja de Hexa Sort ofrece 1 pila o varias? | **1**: "coloca en una celda vacía *la pila* que la bandeja le ofrece" | Enunciado §1.3 | App | 11-11 |
| P-04 | Desempate de la cascada de Hexa Sort | El enunciado no lo fija → **D-15** (decisión del equipo) | Profesor: lo decide el equipo | App | 11-11 |
| P-05 | ¿La derrota en Hexa Sort es tablero lleno? | **Sí**: "el tablero se llena sin movimientos válidos". Como el único movimiento es colocar en una celda vacía, tablero lleno = sin movimientos. Se evalúa **después** de resolver la cascada y retirar las metas | Enunciado §1.3 | App | 11-11 |
| P-06 | ¿Se puede seguir jugando tras 2048? | **Sí**. §5.1 exige Hexa Merge "en modo partida sin fin con registro de puntaje máximo". La pantalla de victoria ofrece "Seguir jugando" además de "Nueva partida" | Enunciado §5.1 | App | 11-11 |
| P-07 | Orden del ranking por nivel de Hexa Fit | **Estrellas (desc) → tiempo (asc) → movimientos (asc)**, comparando el **mismo intento** completo (no la mejor estrella de un intento con el mejor tiempo de otro) | Profesor | Ambos | 11-11 |
| P-08 | ¿Jugar sin cuenta y sincronizar después? | **Sí**. Modo invitado con progreso local; un usuario registrado sin conexión sigue jugando y sincroniza al reconectar. API-05 pasa de *Should* a **Must** | Profesor | Ambos | 11-11 |
| P-09 | ¿Basta con endpoints de admin + Swagger para publicar niveles? | **Sí**: §5.2 pide un "endpoint para obtener y actualizar la definición de niveles"; no pide interfaz de administración | Enunciado §5.2 | Ambos | 11-11 |
| P-10 | ¿Historias técnicas como HU o aparte? | El enunciado no exige HU: **decisión del equipo**. Se mantienen como historias habilitadoras (TEC) en el backlog | Enunciado (no lo regula) | Ambos | 11-11 |
| P-11 | ¿Mermaid o notación UML de plantilla en el diagrama de clases? | **Notación UML de plantilla** (§4.1) → diagrama de clases en **PlantUML** | Enunciado §4.1 | Ambos | 11-11 |
| P-12 | Hexa Sort: ¿se elimina la pila o el bloque de 10? | El enunciado no lo fija → **D-16** (decisión del equipo) | Profesor: lo decide el equipo | App | 11-11 |
| P-13 | Hexa Sort: ¿"cantidad de ese color" es el bloque de cima o el total? | El enunciado no lo fija → **D-17** (decisión del equipo) | Profesor: lo decide el equipo | App | 11-11 |
