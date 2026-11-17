# ARQ-01 — Arquitectura general de la app

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo (Paso 2) |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/architecture/ARQ-01-APP-GENERAL.md`) |
| Relacionados | `ARQ-00-SISTEMA.md` (compartido), `ADR-001-tech-stack.md`, `03-REQUISITOS.md` (RNF-01 a 11), `02-RN-TOPOLOGIAS.md` |

## 0. Alcance de este documento

**Decide:** las capas, los paquetes y su grafo de dependencias, qué componente vive en cada capa, los puertos principales, los flujos de alto nivel, dónde se configura cada variante y cada topología, y qué controla el CI.

**No decide** (se deja para los pasos siguientes):
- **Paso 3, motor genérico (lo decide el equipo):** firmas de los genéricos (`TCell`, `TMove`, `TState`), representación de la coordenada (D-07), máquina de estados, modelo de eventos, cómo se implementa deshacer.
- **Paso 4, arquitectura detallada:** firmas de los casos de uso, mapa de patrones (patrón → clase → por qué), aspectos AOP concretos, diagramas oficiales y `EXTENSIBILITY.md`.

**Estados:** ✅ ya decidido (ADR-001 o enunciado) · 🟡 propuesta para que el equipo confirme.

---

## 1. Qué tiene que cumplir esta arquitectura

| Requisito | Qué le exige a la arquitectura |
|---|---|
| RNF-01, 02 (un solo motor genérico, sin condicionales por variante) | El motor no puede **ver** ninguna variante: ni importarla ni nombrarla |
| RNF-03 (5ª variante sin tocar el motor) | Agregar una variante = código nuevo + registro en configuración |
| RNF-04 (topología intercambiable, hasta cubos) | El motor y las reglas dependen de la **abstracción** de topología; su dibujo es otra pieza, en presentación |
| RNF-06 (Clean: el dominio no depende de nada externo) | Dominio sin Flutter, sin base de datos y sin red. Se prueba con `dart test` |
| RNF-07 (casos de uso genéricos) | Los casos de uso no pueden **ver** las variantes |
| RNF-10 (AOP sin librerías) | Los casos de uso tienen una interfaz común que se puede decorar |
| RNF-20 (determinismo) | El azar y el reloj entran por puertos inyectables |
| RNF-34 (offline) | Todo el juego funciona con adaptadores locales; la red es opcional |

## 2. Las cuatro capas

```mermaid
flowchart TB
    subgraph C4[Capa 4 · Frameworks e infraestructura]
        direction TB
        F[Flutter: widgets y painters<br/>Drift / SQLite · dio / HTTP<br/>audio · almacenamiento seguro · preferencias]
        subgraph C3[Capa 3 · Adaptadores de interfaz]
            direction TB
            A[Cubits / ViewModels<br/>repositorios y gateways<br/>mappers y DTOs]
            subgraph C2[Capa 2 · Casos de uso]
                direction TB
                U[casos de uso genéricos<br/>puertos · aspectos AOP]
                subgraph C1[Capa 1 · Entidades / dominio]
                    E[motor genérico<br/>topologías<br/>reglas de las 4 variantes]
                end
            end
        end
    end
    F --> A --> U --> E
```

Las dependencias apuntan **siempre hacia adentro**: la capa 4 conoce a la 3, la 3 a la 2, la 2 a la 1. Nunca al revés.

| Capa | Qué contiene | Qué **no** puede contener |
|---|---|---|
| **1. Entidades** | Motor genérico (tablero, ciclo de turno, estados, historial, eventos de dominio); abstracciones de topología, fuente de piezas, puntuación, progreso y azar (xorshift32); topologías concretas (hexágonos, cuadrados, triángulos, cubos); reglas, puntuación, fuentes y criterios de mejor intento de las 4 variantes; validadores de niveles; consolidación del progreso | Flutter, Drift, dio, `dart:io`, reloj del sistema, cualquier paquete de terceros |
| **2. Casos de uso** | Casos de uso **genéricos** (iniciar partida, aplicar movimiento, deshacer, rehacer, pausar, guardar progreso, sincronizar, cargar niveles, iniciar y cerrar sesión, importar progreso de invitado, consultar ranking); **puertos** (interfaces) que necesitan; **aspectos** como decoradores que solo dependen de puertos | Implementaciones concretas, Flutter, cualquier nombre de variante |
| **3. Adaptadores** | Cubits (uno por tipo de pantalla, genéricos sobre la variante); implementaciones de repositorios y gateways; mappers dominio ↔ DTO y la serialización del estado de cada variante | Widgets, consultas SQL, detalles HTTP |
| **4. Frameworks** | Widgets, `CustomPainter` por topología y por contenido de celda, base de datos Drift, cliente dio, audio, almacenamiento seguro, preferencias, i18n (ARB), `main.dart` y el *composition root* | Reglas de juego |

## 3. Paquetes del repositorio (pub workspace)

La regla de dependencia no se deja a la disciplina: **la hace cumplir el gestor de paquetes**. Un paquete solo puede importar lo que declara en su `pubspec.yaml`.

```
hexablock-app/
├── pubspec.yaml                 # workspace: lista los paquetes
├── packages/
│   ├── hexa_engine/             # Capa 1 · motor genérico y abstracciones
│   ├── hexa_topologies/         # Capa 1 · hexágonos, cuadrados, triángulos, cubos
│   ├── hexa_variants/           # Capa 1 · Lines, Fit, Sort, Merge (una carpeta por variante)
│   └── hexa_application/        # Capa 2 · casos de uso, puertos, aspectos
├── app/                         # Capas 3 y 4 · aplicación Flutter
│   ├── lib/
│   │   ├── adapters/            # Capa 3
│   │   │   ├── presentation/    #   cubits por tipo de pantalla
│   │   │   ├── repositories/    #   implementaciones de los puertos de persistencia
│   │   │   ├── gateways/        #   implementaciones de los puertos remotos
│   │   │   └── mappers/         #   DTO ↔ dominio, serialización por variante
│   │   ├── frameworks/          # Capa 4
│   │   │   ├── ui/              #   pantallas, widgets, painters (topología × contenido)
│   │   │   ├── persistence/     #   Drift (tablas, migraciones)
│   │   │   ├── network/         #   dio, interceptores
│   │   │   └── platform/        #   audio, almacenamiento seguro, preferencias, logger
│   │   ├── config/              #   registro de variantes y topologías
│   │   └── main.dart            #   composition root (get_it)
│   ├── assets/                  #   niveles incluidos, configuración por variante, audio, l10n
│   └── test/                    #   pruebas de widget, de navegación y de integración
├── tools/                       # scripts de CI (verificación de arquitectura, validador de niveles)
└── docs/
```

### 3.1 Grafo de dependencias permitido

```mermaid
flowchart BT
    ENG[hexa_engine]
    TOP[hexa_topologies] --> ENG
    VAR[hexa_variants] --> ENG
    APPL[hexa_application] --> ENG
    APP[app · Flutter] --> APPL
    APP --> VAR
    APP --> TOP
    APP --> ENG
```

| Paquete | Puede depender de | **No** puede depender de | Por qué |
|---|---|---|---|
| `hexa_engine` | Nada (solo el SDK de Dart) | Ningún otro paquete | Es el centro: si el motor no ve las variantes, no puede tener condicionales sobre ellas (RNF-02) |
| `hexa_topologies` | `hexa_engine` | `hexa_variants`, `hexa_application` | Una topología no sabe a qué se juega encima. Agregar una figura nueva es agregar clases aquí; el motor no cambia |
| `hexa_variants` | `hexa_engine` | `hexa_topologies` (solo en pruebas), `hexa_application` | Las reglas usan la **abstracción** de topología (RN-COM-10); así funcionan con cualquiera |
| `hexa_application` | `hexa_engine` | `hexa_variants`, `hexa_topologies` | Si la capa de casos de uso no ve las variantes, no puede haber un caso de uso por juego (RNF-07) |
| `app` | Todos | — | Es la capa externa; el composition root conecta todo |

Los cuatro paquetes de dominio y aplicación no tienen dependencias de terceros (solo `test` como dependencia de desarrollo).

### 3.2 Qué hay que tocar para extender

| Cambio | Archivos nuevos | Archivos que se modifican | Motor |
|---|---|---|---|
| **5ª variante** | Carpeta en `hexa_variants/`; su mapper en `app/adapters/mappers/`; su painter de contenido de celda en `app/frameworks/ui/`; su configuración en `assets/` | Solo el **registro** en `app/lib/config/` | **Sin cambios** |
| **Nueva topología** | Clase en `hexa_topologies/`; su layout en `app/frameworks/ui/`; su anexo en `02-RN-TOPOLOGIAS.md`; su catálogo de piezas | Solo el **registro** en `app/lib/config/` | **Sin cambios** |
| **Cambio de regla** (por ejemplo, otro puntaje) | Una nueva estrategia de puntuación, o un cambio de configuración | La configuración de la variante | **Sin cambios** |

Esta tabla es el borrador de `EXTENSIBILITY.md` (Paso 4).

## 4. Componentes por capa

### 4.1 Capa 1 — dominio

| Componente | Paquete | Responsabilidad |
|---|---|---|
| Motor genérico | `hexa_engine` | Ciclo de turno validar → aplicar → resolver → evaluar → notificar (RN-COM-20); estados de la partida; historial para deshacer y rehacer; eventos de dominio |
| Abstracción de topología | `hexa_engine` | `Coord` y `GridTopology<TCoord extends Coord>` (D-07, opción A): Las operaciones de RN-COM-10: celdas, vecinas ordenadas, ejes, líneas, direcciones, rayos, giros, normalización |
| Abstracciones de variante | `hexa_engine` | Reglas, fuente de piezas, puntuación, modelo de progreso y **fábrica de variante** (Abstract Factory, obligatorio) |
| Azar | `hexa_engine` | Puerto de azar con semilla e implementación xorshift32 (RN-COM-40 a 45) |
| Progreso | `hexa_engine` | Modelo de progreso genérico y **consolidación** (RN-COM-83), parametrizada por el criterio de mejor intento de cada variante |
| Topologías concretas | `hexa_topologies` | Anexos A a D de `02-RN-TOPOLOGIAS.md`: por cada figura, su coordenada y su topología (`HexCoord` + `HexTopology`, `SquareCoord`, `TriCoord`, `CubeCoord`…). Aquí vive también **`HexBoard<TCell>`**, el nombre que usa el enunciado para el tablero hexagonal: **no** puede vivir en `hexa_engine`, porque usa la topología hexagonal |
| Variantes | `hexa_variants` | Por variante: reglas, puntuación, fuente de piezas, criterio de mejor intento, validador de niveles (estructural y geométrico) y su fábrica |

### 4.2 Capa 2 — casos de uso y puertos

**Casos de uso genéricos** (los nombres siguen el enunciado §3.4; las firmas se definen en el Paso 4):

| Caso de uso | Qué hace | Puertos que usa |
|---|---|---|
| `StartGameUseCase` | Crea una partida de cualquier variante a partir de su configuración (y nivel, si aplica) | Registro de variantes, `ILevelRepository`, semilla |
| `ApplyMoveUseCase` | Aplica un movimiento con el motor | — |
| `UndoMoveUseCase` / `RedoMoveUseCase` | Deshace o rehace, si la variante lo permite | — |
| `PauseGameUseCase` / `ResumeGameUseCase` | Pausa y reanuda | `IClock` |
| `SaveProgressUseCase` | Guarda el resultado en el perfil activo y lo encola | `IProgressRepository`, `ISyncOutbox` |
| `SyncProgressUseCase` | Envía la cola y consolida las respuestas | `IProgressGateway`, `IProgressRepository`, `ISyncOutbox`, `ISessionStore` |
| `LoadLevelsUseCase` | Junta los niveles incluidos y los descargados, valida y ordena | `ILevelRepository`, `ILevelGateway` |
| `RegisterUseCase` / `LoginUseCase` / `LogoutUseCase` | Cuenta y sesión | `IAuthGateway`, `ISessionStore`, `IProfileRepository` |
| `ImportGuestProgressUseCase` | Consolida el progreso de invitado en la cuenta | `IProgressRepository`, `IProfileRepository` |
| `GetLeaderboardUseCase` | Consulta el ranking | `ILeaderboardGateway` |
| `SyncLeaderboardUseCase` | (nombre del enunciado) Envía resultados que cuentan para el ranking; puede unificarse con `SyncProgressUseCase` | `IProgressGateway` |

**Puertos** (interfaces definidas en `hexa_application`):

| Puerto | Responsabilidad | Implementación (capa 3 → 4) |
|---|---|---|
| `IProgressRepository` | Progreso por perfil y por `gameId` | Repositorio → Drift |
| `IProfileRepository` | Perfil activo (invitado o cuenta) | Repositorio → Drift + preferencias |
| `ILevelRepository` | Niveles incluidos y descargados | Repositorio → assets + Drift |
| `ISyncOutbox` | Cola de sincronización | Repositorio → Drift |
| `IProgressGateway` | Enviar y recibir el progreso del servidor | Gateway → dio |
| `ILevelGateway` | Descargar niveles | Gateway → dio |
| `ILeaderboardGateway` | Consultar el ranking | Gateway → dio (+ caché) |
| `IAuthGateway` | Registro e inicio de sesión | Gateway → dio |
| `ISessionStore` | Guardar y borrar el JWT | Almacenamiento seguro |
| `ISettingsRepository` | Idioma y audio | Preferencias |
| `IClock` | Hora actual y tiempo activo | Reloj del sistema (en pruebas: reloj falso) |
| `IConnectivity` | Saber si hay red | Plugin de conectividad |
| `ILogger` | Registro estructurado (lo usan los aspectos, no los casos de uso) | Logger de plataforma |

**Aspectos** (decoradores en `hexa_application/aspects/`): envuelven cualquier caso de uso y solo dependen de puertos (`ILogger`, `IClock`, `ISessionStore`). Como envuelven el caso de uso **genérico**, aplican a las 4 variantes sin cambios (§3.5 del enunciado). Candidatos: logging y trazabilidad (obligatorio, TEC-03), métricas de rendimiento, verificación de sesión y reintentos de red. Se eligen en el Paso 4.

### 4.3 Capa 3 — adaptadores

| Componente | Responsabilidad |
|---|---|
| **Cubits** por tipo de pantalla | `GameCubit` (genérico: sirve para las 4 variantes), `LevelSelectCubit`, `HomeCubit`, `SettingsCubit`, `AccountCubit`, `LeaderboardCubit`. Escuchan los eventos de dominio y exponen un estado listo para dibujar |
| **Repositorios** | Implementan los puertos de persistencia sobre Drift, assets y preferencias |
| **Gateways** | Implementan los puertos remotos sobre dio; traducen errores HTTP a errores de aplicación |
| **Mappers** | Dominio ↔ DTO de la API; dominio ↔ filas de Drift; **serialización del estado de cada variante** (para pausar y guardar) |

### 4.4 Capa 4 — frameworks

| Componente | Responsabilidad |
|---|---|
| **UI** | Pantallas y widgets. El tablero se dibuja combinando dos estrategias: el **layout de la topología** (dónde está cada celda y en qué celda cayó el toque) y el **pintor del contenido** de cada variante (color, pila, número, pieza) |
| **Audio** | Fachada (`AudioFacade`) que reacciona a los eventos de dominio: no hay audio en los casos de uso |
| **Persistencia** | Drift: tablas `progress`, `profiles`, `downloaded_levels`, `sync_outbox` (definidas en el Paso 5) |
| **Red** | dio con interceptores: token JWT, tiempo de espera, traducción de errores |
| **Plataforma** | `flutter_secure_storage`, `shared_preferences`, conectividad, logger |
| **Composition root** | `main.dart` + `get_it`: crea las implementaciones, aplica los decoradores y registra variantes y topologías |

## 5. Configuración: variantes y topologías

| Qué | Dónde | Ejemplo |
|---|---|---|
| Qué variantes existen | Registro en `app/lib/config/` | `hexa-lines` → fábrica de Hexa Lines (dominio) + mapper + pintor de contenido (presentación) |
| Qué topologías existen | Registro en `app/lib/config/` | `hex` → topología hexagonal + layout hexagonal |
| Parámetros de cada variante | `assets/config/<gameId>.json` | por topología: forma del tablero y catálogo; además pesos, fórmula de puntaje, ficha objetivo |
| Niveles incluidos | `assets/levels/<gameId>/*.json` | Validados en CI con el validador de niveles |

**Figura elegida por el jugador (D-25):** `StartGameUseCase` lee la figura de `ISettingsRepository`, el *composition root* la despacha con la función genérica de ARQ-A-09 y la partida queda creada con su `TCoord`. Mientras exista una partida en curso o en pausa, `SettingsCubit` bloquea la opción (RN-TOP-31). Las figuras que aparecen en Ajustes son las registradas en `app/lib/config/` (RN-TOP-30).

## 6. Flujos principales

### 6.1 Un movimiento

```mermaid
sequenceDiagram
    autonumber
    participant W as Widget (capa 4)
    participant C as GameCubit (capa 3)
    participant D as Decorador de logging (capa 2)
    participant U as ApplyMoveUseCase (capa 2)
    participant E as GameEngine (capa 1)
    participant A as AudioFacade (capa 4)
    W->>C: gesto traducido a movimiento (con el layout de la topología)
    C->>D: ejecutar(movimiento)
    D->>U: ejecutar(movimiento)
    U->>E: aplicar(movimiento)
    E->>E: validar, aplicar, resolver, evaluar
    E-->>U: nuevo estado + eventos en orden
    U-->>D: resultado
    D->>D: registra entrada, salida y duración
    D-->>C: resultado
    C-->>W: estado para dibujar (con animaciones por evento)
    C-->>A: eventos (sonidos)
```

### 6.2 Fin de partida y progreso

Fin de partida → `SaveProgressUseCase` consolida el resultado en el perfil activo (Drift) y encola la sincronización → si hay conexión y sesión, `SyncProgressUseCase` envía el snapshot de esa variante y guarda el resultado consolidado (ver `ARQ-00-SISTEMA.md` §5.1).

### 6.3 Arranque

`main.dart` → crea la base de datos y los adaptadores → registra variantes y topologías → envuelve los casos de uso con los aspectos → lee el perfil activo → muestra el inicio → en segundo plano, si hay conexión, envía la cola y busca niveles nuevos.

## 7. Errores

| Tipo | Dónde nace | Cómo se maneja |
|---|---|---|
| **Movimiento inválido** | Dominio | No es un error: el motor devuelve "inválido" y el estado no cambia (RN-COM-21) |
| **Nivel inválido** | Dominio (validador) | Se descarta el nivel y se registra |
| **Error de red o de servidor** | Gateway (capa 3) | Se traduce a un error de aplicación (sin conexión, sesión vencida, conflicto, validación); el juego sigue |
| **Error de persistencia** | Repositorio (capa 3) | Se traduce a un error de aplicación; las escrituras son transaccionales (RNF-35) |
| **Error inesperado** | Cualquier capa | Lo captura un aspecto o el cubit; nunca se muestra un stack al jugador |

El dominio **no lanza excepciones de infraestructura** porque no la conoce. La forma concreta de devolver errores (excepciones tipadas o un tipo resultado) se decide en el Paso 4.

## 8. Controles automáticos en CI

| Control | Cómo | Requisito |
|---|---|---|
| El dominio no importa Flutter ni paquetes externos | Los `pubspec.yaml` de los paquetes de dominio no los declaran: no compila | RNF-06 |
| El motor no ve las variantes | `hexa_engine` no depende de `hexa_variants`; además, un script falla si el motor menciona `lines`, `fit`, `sort` o `merge` | RNF-02 |
| El motor no ve las figuras | `hexa_engine` no depende de `hexa_topologies`; además, el mismo script falla si el motor menciona `hex`, `square`, `tri` o `cube` (fuera de comentarios) | RNF-04 |
| Los casos de uso no ven las variantes | `hexa_application` no depende de `hexa_variants` | RNF-07 |
| Ningún caso de uso llama al logger | Script que busca usos de `ILogger` fuera de `aspects/` | RNF-10 |
| Niveles incluidos válidos | Validador de niveles sobre `assets/levels/` | RF-83 |
| Paridad de idiomas | Script que compara las claves de los ARB | RNF-50 |

## 9. Decisiones de este documento

| ID | Decisión | Estado |
|---|---|---|
| ARQ-A-01 | Cuatro capas Clean según el enunciado §3.4 | ✅ |
| ARQ-A-02 | Pub workspace con **4 paquetes Dart puros** (`hexa_engine`, `hexa_topologies`, `hexa_variants`, `hexa_application`) + la app Flutter | 🟡 D-21 |
| ARQ-A-03 | Los casos de uso (capa 2) van en un paquete propio, sin Flutter, para que no puedan ver las variantes y se prueben sin emulador | 🟡 D-21 |
| ARQ-A-04 | Las variantes en **un solo paquete** con una carpeta por variante (no un paquete por variante): menos configuración, y la regla que importa (el motor no ve las variantes) se cumple igual | 🟡 D-21 |
| ARQ-A-05 | Los aspectos AOP son decoradores en la capa 2 que dependen solo de puertos; se conectan en el composition root | 🟡 |
| ARQ-A-06 | El tablero se dibuja combinando **layout de topología × pintor de contenido de la variante** | 🟡 |
| ARQ-A-07 | El audio reacciona a los eventos de dominio desde la capa 4 (Observer + Facade); no hay puerto de audio en los casos de uso | 🟡 |
| ARQ-A-08 | Un solo `GameCubit` genérico para las 4 variantes | 🟡 |
| ARQ-A-09 | **La coordenada es un parámetro genérico** (`TCoord extends Coord`) del tablero, la topología, las reglas y el motor. `HexBoard<TCell>` = `typedef` de `Board<HexCoord, TCell>`, en `hexa_topologies`. El *composition root* elige la topología leída de la configuración y la despacha con una **función genérica** que conserva el tipo `TCoord` al crear la partida | ✅ D-07 (11-11) |

## 10. Preguntas para el Paso 3 (motor genérico)

Las decide el equipo. Este documento solo fija **dónde** viven las piezas, no **cómo** son por dentro:

1. ~~**D-07:** coordenada genérica o abstracta~~ → **decidida: opción A** (ARQ-A-09). Queda para el Paso 3: cómo se despacha la topología en el *composition root* y hasta qué capa llega `TCoord` (¿los casos de uso y el cubit también son genéricos en `TCoord`, o se ocultan detrás de una interfaz?).
2. ¿Qué son `TCell`, `TMove` y `TState` en cada variante? ¿Qué restricciones de tipo llevan y por qué? (por ejemplo, `TCell extends Mergeable<TCell>` en Merge)
3. ¿Deshacer se implementa guardando estados completos (Memento) o con movimientos reversibles (Command)? Hexa Fit necesita deshacer ilimitado; Merge necesita restaurar el generador.
4. ¿Cómo son los eventos de dominio: una jerarquía *sealed* común o un tipo por variante?
5. ¿Cómo se modelan las capacidades opcionales (deshacer, tiempo, azar, niveles): interfaces separadas o configuración?
6. ¿La máquina de estados de la partida (RN-COM-30, 31) es una clase por estado (State) o un enum con transiciones?
