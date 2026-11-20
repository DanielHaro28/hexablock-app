# ARQ-03 — Arquitectura detallada de la app (Paso 4)

| Campo | Valor |
|---|---|
| Estado | **Decidido (19-11-2026)**: D-38 a D-43 (`docs/DECISIONES.md`) |
| Fecha | 2026-11-19 |
| Repositorio | `hexablock-app` (`docs/architecture/ARQ-03-APP-DETALLE.md`) |
| Parte de | `ARQ-01-APP-GENERAL.md` (dónde vive cada pieza) y `ARQ-02-MOTOR.md` (cómo es el motor por dentro) |
| Fija | Forma de los casos de uso, manejo de errores, firmas de casos de uso y puertos, adaptadores, aspectos AOP y su orden, *composition root*, mapa completo de patrones y ejemplos de SOLID |
| No fija | Tablas de Drift (`ARQ-04-APP-DATOS.md`), JSON de niveles y `openapi.yaml` (`docs/contracts/`), ambos del Paso 5 |
| Diagramas | `docs/diagrams/clases.puml` (PlantUML), `capas.mmd` y `extensibilidad.mmd` (Mermaid) |

> Los esbozos de Dart siguen sin compilar (no hay SDK en la planificación); se validan en el *spike* de TEC-01, junto con los de `ARQ-02-MOTOR.md`. El código va en inglés.

---

## 1. Forma de los casos de uso (D-38)

Todos los casos de uso implementan **la misma interfaz**, con un solo método. Así un aspecto se escribe una vez y envuelve a cualquiera (enunciado §3.5).

```dart
// hexa_application/lib/src/use_case.dart
abstract interface class UseCase<TIn, TOut> {
  Future<TOut> execute(TIn input);
}
```

- La entrada es **un** objeto: una clase de entrada o un *record* (`(gameKey: ..., page: 1)`). Si no hace falta entrada, el tipo es el *record* vacío `()`.
- `execute` devuelve un `Future` aunque el trabajo sea síncrono (como `ApplyMoveUseCase`). Esperarlo cuesta una microtarea: la pantalla recibe el resultado antes del siguiente cuadro (D-32).
- Los casos de uso que trabajan con una partida son **genéricos** en los cuatro parámetros del motor: `ApplyMoveUseCase<C, TCell, TMove, TState>`. Se instancian una vez por partida, en el `VariantModule` de la variante (ARQ-02 §3.1), y nunca nombran una variante (RNF-07).

## 2. Errores (D-39)

**Por dentro, excepciones tipadas.** Los adaptadores (capa 3) traducen los errores técnicos (de dio, de Drift, de la plataforma) a excepciones de la aplicación. El caso de uso no las atrapa: queda limpio.

**Hacia la pantalla, `Result`.** El aspecto de errores (§5) atrapa esas excepciones, aplica reintentos si corresponde y entrega un `Result`. La pantalla hace un `switch` exhaustivo sobre él.

```dart
// hexa_application/lib/src/errors.dart
sealed class AppException implements Exception { const AppException(); }
final class NetworkException extends AppException { const NetworkException({this.timeout = false}); final bool timeout; }
final class SessionExpiredException extends AppException { const SessionExpiredException(); }
final class ConflictException extends AppException { const ConflictException(this.code); final String code; }
final class ValidationException extends AppException { const ValidationException(this.fields); final Map<String, String> fields; }
final class PersistenceException extends AppException { const PersistenceException(); }
final class RuleException extends AppException { const RuleException(this.code); final String code; } // e.g. 'game-in-progress'

sealed class AppFailure { const AppFailure(); }
final class NetworkFailure extends AppFailure { const NetworkFailure(); }
final class SessionFailure extends AppFailure { const SessionFailure({required this.expired}); final bool expired; }
final class ConflictFailure extends AppFailure { const ConflictFailure(this.code); final String code; }
final class ValidationFailure extends AppFailure { const ValidationFailure(this.fields); final Map<String, String> fields; }
final class PersistenceFailure extends AppFailure { const PersistenceFailure(); }
final class RuleFailure extends AppFailure { const RuleFailure(this.code); final String code; }
final class UnexpectedFailure extends AppFailure { const UnexpectedFailure(); } // programming error, already logged

sealed class Result<T> { const Result(); }
final class Success<T> extends Result<T> { const Success(this.value); final T value; }
final class Failure<T> extends Result<T> { const Failure(this.error); final AppFailure error; }
```

| Dónde nace | Excepción | Fallo que ve la pantalla | Qué muestra |
|---|---|---|---|
| Gateway: sin red o tiempo agotado | `NetworkException` | `NetworkFailure` (después de los reintentos) | "Sin conexión; se sincronizará después" |
| Gateway: 401 | `SessionExpiredException` | `SessionFailure(expired: true)` | Borra el token y pide iniciar sesión (SEC-MOB-04) |
| Aspecto de sesión: no hay JWT | — | `SessionFailure(expired: false)` | "Inicia sesión para sincronizar" |
| Gateway: 409 (`email-taken`, D-03, o `display-name-taken`, RN-COM-109) | `ConflictException(code)` | `ConflictFailure` | Mensaje del formulario junto al campo |
| Gateway: 400 con `errors` | `ValidationException` (por `pointer` y `code`) | `ValidationFailure` | Errores por campo |
| Gateway: 429 | `NetworkException(retryAfter)` | `NetworkFailure` (si se agotan los reintentos) | El aspecto de reintentos espera lo que dice `Retry-After` |
| Repositorio: Drift falla | `PersistenceException` | `PersistenceFailure` | "No se pudo guardar"; el juego sigue (RNF-35) |
| Caso de uso: una regla lo impide | `RuleException` | `RuleFailure` | Mensaje de la regla (p. ej., RN-COM-113) |
| Cualquier otra excepción | (error de programación) | `UnexpectedFailure` | Mensaje genérico; nunca un *stack* |

**Errores de la API (D-51).** La API responde Problem Details (RFC 9457). El gateway lee **solo `status` y `code`** (y `errors` en los 400, `Retry-After` en los 429): con eso elige la excepción de la tabla de arriba. El texto que ve el jugador sale siempre de los archivos de traducción de la app (ARB, es/en) según el `code`; **nunca** se muestran `title` ni `detail`, y la app no abre la URI de `type`. Un `code` que la app no conoce se trata como `UnexpectedFailure`.

Un **movimiento inválido no es un error**: el motor devuelve `RejectedMove` dentro de un `Success` (RN-COM-21).

## 3. Casos de uso

`GameKey` = `(gameId, topologyId)`: identifica una variante con una figura (D-25, RN-COM-80).

| Caso de uso | Entrada → salida | Puertos | Requisitos |
|---|---|---|---|
| `StartGameUseCase<C, TCell, TMove, TState>` | `StartOptions` (continuar o nueva, nivel, semilla) → `GameSession<C, TCell, TMove, TState>` | `ISavedGameRepository`, `ILevelRepository` | RF-01, RF-64, RN-COM-34, 40 |
| `ApplyMoveUseCase<C, TCell, TMove, TState>` | `TMove` → `MoveResult<C, TState>` | `ISavedGameRepository` (guardado tras cada turno, D-37) | RF-10, RN-COM-20 a 25, 33 |
| `UndoMoveUseCase<…>` / `RedoMoveUseCase<…>` | `()` → `TState` | `ISavedGameRepository` | RF-34, 53; RN-COM-60 a 63 |
| `PauseGameUseCase<…>` / `ResumeGameUseCase<…>` | `()` → `GamePhase` | `ISavedGameRepository` (`flush` al pausar) | RF-05, RN-COM-32 |
| `ContinuePlayingUseCase<…>` | `()` → `GamePhase` (Hexa Merge tras la victoria) | — | RN-COM-31, RN-HM-51 |
| `SaveProgressUseCase` | `GameResult` → `VariantProgress` | `IProgressRepository`, `ISyncOutbox`, `ISavedGameRepository` (borra la partida, RN-COM-35), `IProfileRepository` | RF-60, RN-COM-80, 83 |
| `SyncProgressUseCase` | `()` → `SyncReport` | `IProgressGateway`, `IProgressRepository`, `ISyncOutbox`, `IProfileRepository` | RF-63, RF-72, RN-COM-86. Cubre también el `SyncLeaderboardUseCase` del enunciado: los mejores intentos viajan en el progreso |
| `LoadLevelsUseCase` | `GameKey` → `List<LevelSummary>` | `ILevelRepository`, `IProgressRepository` | RF-61, RF-83, RN-COM-73 |
| `DownloadLevelsUseCase` | `GameKey` → `int` (niveles nuevos o actualizados) | `ILevelGateway`, `ILevelRepository` (guarda también el cursor, D-48) | RF-80, RF-82, RN-COM-77 |
| `RegisterUseCase` / `LoginUseCase` | `Credentials` → `Profile` | `IAuthGateway`, `ISessionStore`, `IProfileRepository` | RF-70, RF-71 |
| `LogoutUseCase` | `()` → `Profile` (vuelve el invitado) | `ISessionStore`, `IProfileRepository` | RN-COM-89 (D-06) |
| `ImportGuestProgressUseCase` | `()` → `int` (variantes consolidadas) | `IProgressRepository`, `IProfileRepository`, `ISyncOutbox` | RN-COM-88 (D-05) |
| `GetLeaderboardUseCase` | `LeaderboardQuery` (`GameKey`, nivel, página) → `LeaderboardPage` | `ILeaderboardGateway` | RF-74, RN-COM-100 a 106 |
| `GetSettingsUseCase` / `UpdateSettingsUseCase` | `()` → `Settings` / `SettingsChange` → `Settings` | `ISettingsRepository`, `ISavedGameRepository` (figura bloqueada si hay partida, RN-COM-113) | RF-02 a 04, RF-09 |

```dart
// hexa_application/lib/src/game/apply_move_use_case.dart
final class ApplyMoveUseCase<C extends Coord, TCell extends Object, TMove,
        TState extends GameState<C, TCell>>
    implements UseCase<TMove, MoveResult<C, TState>> {
  ApplyMoveUseCase(this._session, this._savedGames, this._key);
  final GameSession<C, TCell, TMove, TState> _session;
  final ISavedGameRepository<TState> _savedGames;
  final SavedGameKey _key;

  @override
  Future<MoveResult<C, TState>> execute(TMove move) async {
    final result = _session.engine.submit(move); // synchronous, < 1 ms (D-32)
    if (result is AcceptedMove<C, TState>) {
      _savedGames.scheduleSave(_key, _session.snapshot()); // does not wait (D-37)
    }
    return result;
  }
}
```

`scheduleSave` no espera la escritura: el repositorio (capa 3) la encola, conserva solo la última y escribe en una transacción. `flush()` fuerza la escritura y lo llama `PauseGameUseCase` cuando la app pasa a segundo plano. Así el guardado nunca retrasa la pantalla y un cierre inesperado pierde, como mucho, el turno que se estaba escribiendo.

## 4. Puertos (capa 2) y adaptadores (capa 3)

| Puerto | Firma principal | Adaptador (capa 3) → framework (capa 4) |
|---|---|---|
| `IProgressRepository` | `load(ProfileId, GameKey)`, `save(ProfileId, GameKey, VariantProgress)` (transacción) | `DriftProgressRepository` → Drift |
| `IProfileRepository` | `active()`, `activate(Profile)`, `guest()` | `DriftProfileRepository` → Drift |
| `ISavedGameRepository<TState>` | `scheduleSave(SavedGameKey, SavedGame<TState>)`, `flush()`, `load(SavedGameKey)`, `delete(SavedGameKey)`, `exists(ProfileId)` | `DriftSavedGameRepository<TState>` + `IGameStateCodec<TState>` de la variante → Drift |
| `ILevelRepository` | `bundled(GameKey)`, `downloaded(GameKey)`, `store(List<LevelDefinition>)` | `LevelRepository` → assets + Drift |
| `ISyncOutbox` | `markPending(ProfileId, GameKey, ResultKey)`, `pending(ProfileId)`, `markSent(...)` | `DriftSyncOutbox` → marca de pendiente en `level_results` y `records` (D-49) |
| `IProgressGateway` | `push(GameKey, VariantProgress) → VariantProgress` (consolidado), `pullAll()` | `HttpProgressGateway` → dio |
| `ILevelGateway` | `fetchPublished(GameKey, {since})` | `HttpLevelGateway` → dio |
| `ILeaderboardGateway` | `fetch(LeaderboardQuery) → LeaderboardPage` | `HttpLeaderboardGateway` → dio |
| `IAuthGateway` | `register(Credentials)`, `login(Credentials) → AuthToken` | `HttpAuthGateway` → dio |
| `ISessionStore` | `read() → Session?`, `write(Session)`, `clear()` | `SecureSessionStore` → `flutter_secure_storage` |
| `ISettingsRepository` | `read() → Settings`, `write(Settings)` | `PrefsSettingsRepository` → `shared_preferences` |
| `IClock` (extiende `IMonotonicClock` del dominio) | `now()`, `nowMillis()` | `SystemClock` (en pruebas, `FakeClock`) |
| `IConnectivity` | `isOnline`, `changes` | `ConnectivityAdapter` → plugin de conectividad |
| `ILogger` | `log(LogEntry)` (solo lo usan los aspectos, RNF-10) | `PlatformLogger` |
| `IMetrics` | `record(String name, Duration elapsed)` | `LogMetrics` (escribe en el registro) |

**Otros adaptadores de la capa 3:**

| Componente | Responsabilidad |
|---|---|
| `GameCubit<C, TCell, TMove, TState>` | Uno para las 4 variantes. Recibe el `Result<MoveResult>` de `ApplyMoveUseCase`, convierte los eventos en animaciones y expone un estado de pantalla. Muestra deshacer solo si `session.undo != null` (D-33) |
| `HomeCubit`, `LevelSelectCubit`, `SettingsCubit`, `AccountCubit`, `LeaderboardCubit` | Una por tipo de pantalla |
| `IGameStateCodec<TState>` (uno por variante: `LinesStateCodec`, …) | Serializa y deserializa el estado inmutable para la partida guardada (D-37). Es un puerto de la capa 2 que implementa cada variante en la capa 3 |
| Mappers | Dominio ↔ DTO de la API (con los ejemplos de `docs/contracts/`, D-23) y dominio ↔ filas de Drift |
| Traductor de errores | Convierte `DioException` y los errores de Drift en `AppException` (§2) |

## 5. Aspectos AOP (D-40, D-41)

### 5.1 Los cuatro aspectos

| Aspecto | Patrón | Qué hace | A qué casos de uso |
|---|---|---|---|
| `LoggingAspect<TIn, TOut>` | Decorator | Registra inicio, fin, duración y resultado. **Redacta** contraseñas, tokens y correos (SEC-WEB-06). El volcado del tablero antes y después de cada movimiento (el ejemplo del enunciado §3.5) solo se escribe en modo desarrollo (SEC-MOB-05). Cómo se describe cada entrada lo decide un `UseCaseDescriber` (Strategy) | Todos |
| `MetricsAspect<TIn, TOut>` | Decorator | Mide la duración con `IMonotonicClock`; si supera el presupuesto, lo registra como advertencia | `ApplyMove` (16 ms, RNF-31), `StartGame`, `Undo` |
| `ErrorHandlingAspect<TIn, TOut>` | Decorator (convierte `UseCase<TIn, TOut>` en `UseCase<TIn, Result<TOut>>`) | Atrapa las excepciones, reintenta según una `RetryPolicy` (Strategy) y devuelve `Result` (D-39) | Todos; con reintentos (2, con espera de 0,5 s y 1 s), solo los que usan red: `SyncProgress`, `DownloadLevels`, `GetLeaderboard`, `Register`, `Login` |
| `SessionAspect<TIn, TOut>` | Proxy de protección | Antes de ejecutar, comprueba **en el dispositivo** que hay un JWT vigente (sin red); si no, devuelve `SessionFailure` sin llamar al caso de uso | Solo `SyncProgress` e `ImportGuestProgress`. **Nunca** jugar, guardar progreso ni guardar la partida (RN-COM-81, 82, 85) |

La caché del ranking (un Proxy de caché sobre `GetLeaderboard`) queda como opcional (*Could*).

```dart
// hexa_application/lib/src/aspects/logging_aspect.dart
final class LoggingAspect<TIn, TOut> implements UseCase<TIn, TOut> {
  LoggingAspect(this._inner, this._logger, {required this.name, UseCaseDescriber<TIn, TOut>? describe})
      : _describe = describe ?? DefaultDescriber<TIn, TOut>();
  final UseCase<TIn, TOut> _inner;
  final ILogger _logger;
  final String name;
  final UseCaseDescriber<TIn, TOut> _describe;

  @override
  Future<TOut> execute(TIn input) async {
    _logger.log(LogEntry.debug('$name started', _describe.input(input)));   // redacted
    try {
      final output = await _inner.execute(input);
      _logger.log(LogEntry.info('$name finished', _describe.output(output)));
      return output;
    } on Object catch (error) {
      _logger.log(LogEntry.warning('$name failed', {'error': error.runtimeType.toString()}));
      rethrow; // ErrorHandlingAspect, outside, turns it into a Result
    }
  }
}
```

### 5.2 Orden y ensamblado (D-41)

De afuera hacia adentro: **sesión → errores y reintentos → métricas → registro → caso de uso**.

- La sesión va primero: sin cuenta no tiene sentido reintentar.
- Las métricas van dentro de los reintentos: miden un intento, no la suma de todos.
- El registro va pegado al caso de uso: anota cada intento con sus datos.

`AspectChain` (en `hexa_application`, porque solo usa puertos) arma la cadena; el *composition root* la usa en una línea por caso de uso:

```dart
// hexa_application/lib/src/aspects/aspect_chain.dart
final class AspectChain {
  AspectChain(this._logger, this._metrics, this._clock, this._sessions);
  final ILogger _logger;
  final IMetrics _metrics;
  final IMonotonicClock _clock;
  final ISessionStore _sessions;

  UseCase<TIn, Result<TOut>> wrap<TIn, TOut>(
    UseCase<TIn, TOut> useCase, {
    required String name,
    bool requiresSession = false,
    RetryPolicy retry = RetryPolicy.none,
    Duration? budget,
    UseCaseDescriber<TIn, TOut>? describe,
  }) {
    UseCase<TIn, TOut> inner = LoggingAspect(useCase, _logger, name: name, describe: describe);
    inner = MetricsAspect(inner, _metrics, _clock, name: name, budget: budget);
    UseCase<TIn, Result<TOut>> outer = ErrorHandlingAspect(inner, _logger, retry: retry);
    if (requiresSession) outer = SessionAspect(outer, _sessions, _clock);
    return outer;
  }
}

// app/lib/config/ (composition root)
final syncProgress = chain.wrap(SyncProgressUseCase(...),
    name: 'SyncProgress', requiresSession: true, retry: RetryPolicy.network);
```

### 5.3 Matriz de aspectos

| Caso de uso | Sesión | Errores | Reintentos | Métricas | Registro |
|---|---|---|---|---|---|
| `StartGame`, `Undo`, `Redo`, `Pause`, `Resume`, `ContinuePlaying` | — | ✓ | — | ✓ | ✓ |
| `ApplyMove` | — | ✓ | — | ✓ (16 ms) | ✓ (tablero en modo desarrollo) |
| `SaveProgress`, `LoadLevels`, `Logout`, `GetSettings`, `UpdateSettings` | — | ✓ | — | — | ✓ |
| `SyncProgress`, `ImportGuestProgress` | ✓ | ✓ | `SyncProgress` | — | ✓ |
| `DownloadLevels`, `GetLeaderboard`, `Register`, `Login` | — | ✓ | ✓ | — | ✓ (redactado) |

Como `ApplyMoveUseCase` es genérico, sus aspectos aplican a las 4 variantes sin cambios (enunciado §3.5).

## 6. *Composition root* (capa 4)

| Momento | Qué se crea | Dónde |
|---|---|---|
| Arranque (`main.dart`) | Base de datos, adaptadores, `AspectChain`, casos de uso que no dependen de una partida, Cubits de pantalla; registro de **topologías con su layout** (`TopologyEntry`, D-29) y de **módulos de variante** (`VariantModule`) | `app/lib/config/`, con `get_it` (*lazy singletons*) |
| Al abrir una partida | `topologyRegistry[figura].accept(OpenGame(module, opciones))` → el módulo crea su `VariantFamily<C>`, la `GameSession`, el codec del estado, los casos de uso de partida envueltos por `AspectChain` y el `GameCubit` | `VariantModule.open<C>()` (ARQ-02 §3.1) |
| Al pasar a segundo plano | Un `WidgetsBindingObserver` llama a `PauseGameUseCase`, que pausa y hace `flush()` de la partida guardada | `app/lib/frameworks/lifecycle/` |

## 7. Mapa completo de patrones de la app (para el README)

> El texto final de esta sección va en el README, con enlaces al código; aquí queda la justificación (D-71, T-07).

Los 14 del dominio están detallados en `ARQ-02-MOTOR.md` §9. Aquí, todos con su ubicación prevista en el código:

| Patrón | Categoría | Capa | Dónde (ruta prevista) |
|---|---|---|---|
| Abstract Factory | Creacional | 1 | `hexa_variants/lib/src/*/hexa_*_factory.dart` (`VariantFamily`) |
| Builder | Creacional | 1 | `hexa_variants/lib/src/fit/fit_level_builder.dart`, `sort/sort_level_builder.dart` |
| Factory Method | Creacional | 1 | `hexa_topologies/lib/src/*/…_topology.dart` (`cellsOf`) |
| Singleton (por inyección) | Creacional | 4 | `app/lib/config/injection.dart` (`get_it`) |
| Bridge | Estructural | 1 · 4 | `hexa_engine/lib/src/board.dart` ↔ `GridTopology`; en la vista, `TopologyLayout` × pintor de contenido (ARQ-A-06) |
| Composite | Estructural | 1 | `hexa_engine/lib/src/shape.dart` |
| Decorator | Estructural | 1 · 2 | Puntuación (`StreakMultiplier`), reglas; aspectos `LoggingAspect`, `MetricsAspect`, `ErrorHandlingAspect` |
| Proxy | Estructural | 2 | `SessionAspect` (protección); caché del ranking (opcional) |
| Adapter | Estructural | 3 | Repositorios Drift, gateways HTTP, `IGameStateCodec` por variante |
| Facade | Estructural | 4 | `AudioFacade` |
| Strategy | Comportamiento | 1 · 2 | `IGameRules`, `IScoringPolicy`, `IPieceSource`, `IProgressModel`; `RetryPolicy`, `UseCaseDescriber` |
| Template Method | Comportamiento | 1 | `hexa_engine/lib/src/game_rules.dart` (`playTurn`) |
| State | Comportamiento | 1 | `hexa_engine/lib/src/phases.dart` |
| Observer | Comportamiento | 1 · 3 | `GameEngine.events`; Cubits (estados que escuchan los widgets) |
| Command | Comportamiento | 1 | `hexa_engine/lib/src/undo/move_command.dart` |
| Memento | Comportamiento | 1 | Estados inmutables + `UndoHistory` |
| Iterator | Comportamiento | 1 | `GridTopology.lines`, `ray`, `neighbors`; `validMoves` |
| Visitor | Comportamiento | 1 · 4 | `TopologyVisitor`; `TopologyEntryVisitor` en el *composition root* |

Total: 4 creacionales, 6 estructurales y 8 de comportamiento. RNF-09 pide al menos 2 por categoría.

## 8. SOLID, con un ejemplo real cada uno (RNF-08)

> El texto final de esta sección va en el README, con enlaces al código; aquí queda la justificación (D-71, T-07).

| Principio | Ejemplo | Por qué lo cumple |
|---|---|---|
| **S**, responsabilidad única | `HexaLinesRules` solo valida y aplica; la puntuación está en `LinesScoring`, las piezas en `WeightedRandomPieceSource` y el guardado en `DriftSavedGameRepository` | Cambiar la fórmula de puntaje no toca las reglas ni la persistencia |
| **O**, abierto/cerrado | Una 5ª variante es una carpeta nueva en `hexa_variants` y un `VariantModule`; una figura nueva, una `GridTopology` y su `TopologyEntry` | `GameEngine`, `Board` y los casos de uso no se modifican (`EXTENSIBILITY.md`) |
| **L**, sustitución de Liskov | `GameEngine` funciona con cualquier `IGameRules`; `HexaFitRules` cambia `evaluate` para que nunca haya derrota y sigue cumpliendo el contrato (devuelve un `GameOutcome` válido) | El motor no pregunta qué variante tiene (RNF-02) |
| **I**, segregación de interfaces | `IUndoable`, `ITimed`, `IRandomSeeded` e `ILevelBased` separadas; Hexa Lines no recibe `IUndoable` (D-33). `UndoHistory` solo ve `UndoableEngine`, no todo el motor | Nadie depende de métodos que no usa |
| **D**, inversión de dependencias | `ApplyMoveUseCase` depende de `ISavedGameRepository` (capa 2), que implementa `DriftSavedGameRepository` (capa 3); el dominio define `IMonotonicClock` y la plataforma lo implementa | Las dependencias apuntan hacia el núcleo (§3.4) |

## 9. Diagramas (D-43)

| Diagrama | Fuente editable | Imagen para el README | Cómo se genera |
|---|---|---|---|
| Clases (notación UML de plantilla, §4.1) | `docs/diagrams/clases.puml` | `docs/diagrams/clases.png` | DanielHaro28, con la extensión de PlantUML de VS Code (exportar a PNG en alta resolución) |
| Capas Clean (§4.2) | `docs/diagrams/capas.mmd` | `docs/diagrams/capas.png` | Generada con Mermaid al escribirlo |
| Extensibilidad (§4.3) | `docs/diagrams/extensibilidad.mmd` | `docs/diagrams/extensibilidad.png` | Generada con Mermaid al escribirlo |

Cuando el código exista, los nombres del diagrama de clases se revisan contra las clases reales.

## 10. Decisiones de este documento

D-38 a D-41 y D-43, en `docs/DECISIONES.md` (D-67).
