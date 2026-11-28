# ARQ-03 — Arquitectura detallada de la app (Paso 4)

| Campo | Valor |
|---|---|
| Estado | **Decidido (19-11-2026)**: D-38 a D-43 (`docs/DECISIONES.md`); precisado el 26-11-2026 por D-160 a D-163 y el 27-11-2026 por D-170 |
| Fecha | 2026-11-19 |
| Repositorio | `hexablock-app` (`docs/architecture/ARQ-03-APP-DETALLE.md`) |
| Parte de | `ARQ-01-APP-GENERAL.md` (dónde vive cada pieza) y `ARQ-02-MOTOR.md` (cómo es el motor por dentro) |
| Fija | Forma de los casos de uso, manejo de errores, firmas de casos de uso y puertos, adaptadores, aspectos AOP y su orden, *composition root*, mapa completo de patrones y ejemplos de SOLID |
| No fija | Tablas de Drift (`ARQ-04-APP-DATOS.md`), JSON de niveles y `openapi.yaml` (`docs/contracts/`), ambos del Paso 5 |
| Diagramas | `docs/diagrams/clases*.puml` (PlantUML: general y tres de detalle, D-76), `capas.mmd` y `extensibilidad.mmd` (Mermaid) |

> Los esbozos de Dart siguen sin compilar (no hay SDK en la planificación); se validan en el *spike* de TEC-01, junto con los de `ARQ-02-MOTOR.md`. El código va en inglés.

---

## 1. Forma de los casos de uso (D-38, D-160)

Todos los casos de uso **y todos los aspectos** implementan **la misma interfaz**, con un solo método: el `ICommandService<TCommand>` del capítulo 10 de *Dependency Injection Principles, Practices, and Patterns* (Seemann y van Deursen). Así un aspecto se escribe una vez y envuelve a cualquiera (enunciado §3.5), y como tiene el mismo tipo que lo que envuelve, los aspectos se encadenan sin cambiar de forma.

```dart
// hexa_application/lib/src/command_service.dart
abstract interface class ICommandService<TCommand, TResult> {
  Future<Either<AppFailure, TResult>> execute(TCommand command);
}

// hexa_application/lib/src/either.dart
sealed class Either<L, R> { const Either(); }
final class Left<L, R> extends Either<L, R> { const Left(this.value); final L value; }   // what went wrong
final class Right<L, R> extends Either<L, R> { const Right(this.value); final R value; } // what it produced

extension EitherOperations<L, R> on Either<L, R> {                     // D-170
  T fold<T>(T Function(L failure) onLeft, T Function(R value) onRight); // both sides to one value
  Either<L, T> map<T>(T Function(R value) transform);                  // functor
  Either<L, T> flatMap<T>(Either<L, T> Function(R value) next);        // monad: Right is the unit
}
```

`Either` es una **mónada** (D-170): `Right` es la unidad, `flatMap` encadena un paso que puede fallar y `map` transforma el valor; un `Left` pasa sin cambios por los dos, así que el primer fallo corta la cadena, y `fold` reduce los dos lados a un valor. Las pruebas comprueban las leyes del funtor y de la mónada. Son una extensión y no métodos de la clase porque las clases genéricas de Dart son covariantes: un `Left<NetworkFailure, int>` visto como `Either<AppFailure, int>` comprobaría en ejecución el `next` de un método contra `Either<NetworkFailure, int>` y lanzaría un `TypeError`; la extensión toma `L` y `R` del tipo estático. Dentro de un caso de uso casi no hace falta, porque los puertos lanzan y no devuelven `Either` (D-161); sirve a quien recibe el resultado, como un Cubit que lo transforma con `map` o arma su estado con `fold`, y la pantalla puede seguir usando el `switch` exhaustivo. Los pasos son síncronos: encadenar dos casos de uso, que devuelven `Future<Either>` (por ejemplo, guardar el progreso y después sincronizarlo), pide una versión asíncrona, que se agrega cuando la necesite el primero que lo haga.

- La entrada es **un** objeto, el comando: una clase de entrada o un *record* (`(gameKey: ..., page: 1)`). Si no hace falta entrada, el tipo es el *record* vacío `()`.
- En lugar del `void` del libro, devuelve `Either` con el fallo fijo en `AppFailure` (D-160): los casos de uso devuelven valores (D-32: los eventos de un movimiento) y una sola abstracción sirve a los que cambian el estado y a los que solo leen, así que cada aspecto se escribe una vez y no una por abstracción. Las clases conservan su nombre (`StartGameUseCase`, `ApplyMoveUseCase`…).
- **Comandos y consultas (CQS).** El capítulo 10 aplica la separación de comandos y consultas: `ICommandService<TCommand>` es para los comandos, que cambian el estado y no devuelven nada, y deja las consultas, que solo leen, para otra abstracción. Aquí una sola interfaz sirve a las dos, a propósito (D-160): `GetProgressUseCase` y `CheckMoveUseCase` solo leen, pero tienen el mismo tipo que `ApplyMoveUseCase` y `SaveProgressUseCase`, así que cada aspecto se escribe una vez. El costo es que el tipo no distingue una lectura de una escritura: un aspecto que solo valga para escrituras (por ejemplo, una auditoría) o solo para lecturas (una caché) se elige por caso de uso en el *composition root*, como hoy el registro y las métricas, y la matriz de §5.3 dice qué hace cada uno (columna «Lee / escribe»). Se conserva el nombre del libro, y no `IUseCase`, para que el código se pueda seguir hasta sus listados.
- `execute` devuelve un `Future` aunque el trabajo sea síncrono (como `ApplyMoveUseCase`). Esperarlo cuesta una microtarea: la pantalla recibe el resultado antes del siguiente cuadro (D-32).
- Los casos de uso que trabajan con una partida son **genéricos** en los cuatro parámetros del motor: `ApplyMoveUseCase<C, TCell, TMove, TState>`. Se instancian una vez por partida, en el `VariantModule` de la variante (ARQ-02 §3.1), y nunca nombran una variante (RNF-07).

## 2. Errores (D-39, D-161)

**Los adaptadores lanzan.** Los adaptadores (capas 3 y 4) traducen los errores técnicos (de dio, de Drift, de la plataforma) a excepciones de la aplicación y las lanzan. El caso de uso no las atrapa: queda sin `try`.

**Los casos de uso devuelven.** Si una regla propia lo impide, el caso de uso devuelve `Left(RuleFailure(code))`: nunca lanza por una regla. Si todo sale bien, devuelve `Right(valor)`. Solo un invariante roto (un error de programación, como la forma del progreso que no coincide en `SaveProgressUseCase`) lanza, y termina en `UnexpectedFailure`.

**Hacia la pantalla, siempre un `Either`.** `ExceptionAspect`, el aspecto más interno (§5), convierte cualquier excepción en un `Left` y deja pasar sin cambios lo que devuelve el caso de uso. La pantalla hace un `switch` exhaustivo sobre el `Either` y sobre el `AppFailure`.

```dart
// hexa_application/lib/src/errors.dart
sealed class AppException implements Exception { const AppException(); }
final class NetworkException extends AppException { const NetworkException({this.timeout = false}); final bool timeout; }
final class SessionExpiredException extends AppException { const SessionExpiredException(); }
final class ConflictException extends AppException { const ConflictException(this.code); final String code; }
final class ValidationException extends AppException { const ValidationException(this.fields); final Map<String, String> fields; }
final class PersistenceException extends AppException { const PersistenceException(); }

sealed class AppFailure { const AppFailure(); }
final class NetworkFailure extends AppFailure { const NetworkFailure(); }
final class SessionFailure extends AppFailure { const SessionFailure({required this.expired}); final bool expired; }
final class ConflictFailure extends AppFailure { const ConflictFailure(this.code); final String code; }
final class ValidationFailure extends AppFailure { const ValidationFailure(this.fields); final Map<String, String> fields; }
final class PersistenceFailure extends AppFailure { const PersistenceFailure(); }
final class RuleFailure extends AppFailure { const RuleFailure(this.code); final String code; } // returned by a use case, e.g. 'game-in-progress'
final class UnexpectedFailure extends AppFailure { const UnexpectedFailure(); } // programming error, already logged
```

| Dónde nace | Excepción | `Left` que ve la pantalla | Qué muestra |
|---|---|---|---|
| Gateway: sin red o tiempo agotado | `NetworkException` | `NetworkFailure` (después de los reintentos) | "Sin conexión; se sincronizará después" |
| Gateway: 401 | `SessionExpiredException` | `SessionFailure(expired: true)` | Borra el token y pide iniciar sesión (SEC-MOB-04) |
| Aspecto de sesión: no hay JWT | — | `SessionFailure(expired: false)` | "Inicia sesión para sincronizar" |
| Gateway: 409 (`email-taken`, D-03, o `display-name-taken`, RN-COM-109) | `ConflictException(code)` | `ConflictFailure` | Mensaje del formulario junto al campo |
| Gateway: 400 con `errors` | `ValidationException` (por `pointer` y `code`) | `ValidationFailure` | Errores por campo |
| Gateway: 429 | `NetworkException(retryAfter)` | `NetworkFailure` (si se agotan los reintentos) | El aspecto de reintentos espera lo que dice `Retry-After` |
| Repositorio: Drift falla | `PersistenceException` | `PersistenceFailure` | "No se pudo guardar"; el juego sigue (RNF-35) |
| Caso de uso: una regla lo impide | — (lo devuelve, D-161) | `RuleFailure` | Mensaje de la regla (p. ej., RN-COM-113) |
| Cualquier otra excepción | (error de programación) | `UnexpectedFailure` | Mensaje genérico; nunca un *stack* |

**Errores de la API (D-51).** La API responde Problem Details (RFC 9457). El gateway lee **solo `status` y `code`** (y `errors` en los 400, `Retry-After` en los 429): con eso elige la excepción de la tabla de arriba. El texto que ve el jugador sale siempre de los archivos de traducción de la app (ARB, es/en) según el `code`; **nunca** se muestran `title` ni `detail`, y la app no abre la URI de `type`. Un `code` que la app no conoce se trata como `UnexpectedFailure`.

Un **movimiento inválido no es un error**: el motor devuelve `RejectedMove` dentro de un `Right` (RN-COM-21).

## 3. Casos de uso

`GameKey` = `(gameId, topologyId)`: identifica una variante con una figura (D-25, RN-COM-80). `SavedGameKey` = `(ProfileId, GameKey)`: la partida guardada de un perfil en una variante y una figura, que es una sola (RN-COM-33, D-37).

| Caso de uso | Entrada → salida | Puertos | Requisitos |
|---|---|---|---|
| `StartGameUseCase<C, TCell, TMove, TState>` | `StartOptions` (continuar o nueva, con un `NewGameOptions` que lleva la semilla, D-124, y el `levelId` del nivel elegido en una variante por niveles, D-125) → `GameSession<C, TCell, TMove, TState>`, con `VariantFamily.createSession(newGame)` o `continueSession(saved)` (D-116) | `ISavedGameRepository`, `ILevelRepository` | RF-01, RF-64, RN-COM-34, 40 |
| `ApplyMoveUseCase<C, TCell, TMove, TState>` | `TMove` → `MoveResult<C, TState>` | `ISavedGameRepository` (guardado tras cada turno, D-37) | RF-10, RN-COM-20 a 25, 33 |
| `CheckMoveUseCase<C, TCell, TMove, TState>` | `TMove` → `RejectionReason?` (`null` = se jugaría), con `GameEngine.check`: no cambia la partida ni guarda nada | — | RF-21, D-138 |
| `UndoMoveUseCase<…>` / `RedoMoveUseCase<…>` | `()` → `TState` | `ISavedGameRepository` | RF-34, 53; RN-COM-60 a 63 |
| `PauseGameUseCase<…>` / `ResumeGameUseCase<…>` | `()` → `GamePhase` | `ISavedGameRepository` (al pausar: guarda un `snapshot()` nuevo, con el tiempo activo, y hace `flush`) | RF-05, RN-COM-32, 33 |
| `ContinuePlayingUseCase<…>` | `()` → `GamePhase` (Hexa Merge tras la victoria) | `ISavedGameRepository` (guarda el turno de la victoria al elegir seguir, D-112) | RN-COM-31, RN-HM-51 |
| `SaveProgressUseCase` | `GameResult` → `VariantProgress` | `IProgressRepository`, `ISyncOutbox`, `ISavedGameRepository` (borra la partida, RN-COM-35), `IProfileRepository` | RF-24, RF-60, RN-COM-80, 83, RN-HL-71. Desde HL-06 guarda el récord (`HighScoreProgress`, con la fecha de `IClock`) si el puntaje lo supera; `ISyncOutbox`, `ISavedGameRepository` e `IProfileRepository` llegan con PRG-03 y API-03 (D-142). Desde PRG-03 usa el perfil activo de `IProfileRepository` y lee, consolida y escribe dentro de una `IUnitOfWork` (ARQ-04 §3, D-158) |
| `GetProgressUseCase` | `GameKey` → `VariantProgress?` (`null` si no hay) | `IProgressRepository` (y después `IProfileRepository`) | RF-24, RN-HL-70 (D-142) |
| `SyncProgressUseCase` | `()` → `SyncReport` | `IProgressGateway`, `IProgressRepository`, `ISyncOutbox`, `IProfileRepository` | RF-63, RF-72, RN-COM-86. Cubre también el `SyncLeaderboardUseCase` del enunciado: los mejores intentos viajan en el progreso |
| `LoadLevelsUseCase` | `GameKey` → `List<LevelSummary>` | `ILevelRepository`, `IProgressRepository` | RF-61, RF-83, RN-COM-73 |
| `DownloadLevelsUseCase` | `GameKey` → `int` (niveles nuevos o actualizados) | `ILevelGateway`, `ILevelRepository` (guarda también el cursor, D-48) | RF-80, RF-82, RN-COM-77 |
| `RegisterUseCase` / `LoginUseCase` | `Credentials` → `Profile` | `IAuthGateway`, `ISessionStore`, `IProfileRepository` | RF-70, RF-71 |
| `LogoutUseCase` | `()` → `Profile` (vuelve el invitado) | `ISessionStore`, `IProfileRepository` | RN-COM-89 (D-06) |
| `ImportGuestProgressUseCase` | `()` → `int` (variantes consolidadas) | `IProgressRepository`, `IProfileRepository`, `ISyncOutbox` | RN-COM-88 (D-05) |
| `GetLeaderboardUseCase` | `LeaderboardQuery` (`GameKey`, nivel, página) → `LeaderboardPage` | `ILeaderboardGateway` | RF-74, RN-COM-100 a 106 |
| `GetSettingsUseCase` / `UpdateSettingsUseCase` | `()` → `Settings` / `SettingsChange` → `Settings` | `ISettingsRepository`, `ISavedGameRepository` (figura bloqueada si hay partida, RN-COM-113) | RF-02 a 04, RF-09 |

```dart
// hexa_application/lib/src/use_cases/apply_move_use_case.dart
final class ApplyMoveUseCase<C extends Coord, TCell extends Object, TMove,
        TState extends GameState<C, TCell>>
    implements ICommandService<TMove, MoveResult<C, TState>> {
  ApplyMoveUseCase(this._session, this._savedGames, this._key);
  final GameSession<C, TCell, TMove, TState> _session;
  final ISavedGameRepository<TState> _savedGames;
  final SavedGameKey _key;

  @override
  Future<Either<AppFailure, MoveResult<C, TState>>> execute(TMove move) async {
    final result = _session.engine.submit(move); // synchronous, < 1 ms (D-32)
    switch (result) {
      case AcceptedMove(outcome: Ongoing()):
        // After submit returned, so the history has the turn (D-113).
        _savedGames.scheduleSave(_key, _session.snapshot()); // does not wait (D-37)
      case AcceptedMove(outcome: Defeat() || Victory(canContinue: false)):
        _savedGames.delete(_key); // a finished game is never saved (D-110, RN-COM-35)
      case AcceptedMove(outcome: Victory(canContinue: true)):
        break; // ContinuePlayingUseCase saves it if the player goes on (D-112)
      case RejectedMove():
        break; // nothing changed (RN-COM-21)
    }
    return Right(result); // a rejected move is a Right too
  }
}
```

`scheduleSave` no espera la escritura: el repositorio (capa 3) la encola, conserva solo la última y escribe en una transacción. `delete` pasa por la **misma cola** y descarta el guardado pendiente, así que la última operación gana y una partida terminada nunca reaparece (D-110). `flush()` fuerza la escritura y lo llama `PauseGameUseCase` cuando la app pasa a segundo plano. Así el guardado nunca retrasa la pantalla y un cierre inesperado pierde, como mucho, el turno que se estaba escribiendo.

**Qué se guarda y cuándo (D-110, D-112, D-113).** Lo guardado es el `SavedGame<TState>` de `GameSession.snapshot()`: estado, historial de deshacer y tiempo activo. Se toma siempre después de que `submit`, `undo` o `redo` devolvieron, nunca desde un oyente del motor. Guardan `ApplyMoveUseCase` (turno en curso), `UndoMoveUseCase` y `RedoMoveUseCase` (después de restaurar), `ContinuePlayingUseCase` (el turno de la victoria de Merge, al elegir seguir) y `PauseGameUseCase`, que después de `pause()` guarda un `snapshot()` nuevo y hace `flush()`, para que el tiempo jugado desde el último turno no se pierda (RN-COM-33): en Fit ese tiempo decide una estrella (RN-HF-62). Solo guarda si la partida quedó en `PausedPhase`: una pausa pedida en la victoria o en la derrota no cambia la fase, y esas partidas no se guardan (D-110, D-112). Para **continuar**, `StartGameUseCase` carga el `SavedGame<TState>` y llama a `VariantFamily.continueSession(saved)` (D-116), que arma la sesión con `GameEngine.paused(rules, saved.state)`, `UndoHistory(…, from: saved.undo)` y `ActiveTimer(…, elapsed: saved.activeTime!)` (el codec de una variante con cronómetro siempre lo escribe, ARQ-04 §8): la partida vuelve en pausa (RN-COM-34, D-111).

## 4. Puertos (capa 2) y adaptadores (capa 3)

| Puerto | Firma principal | Implementación → framework (capa 4 si se apoya en un framework, D-156) |
|---|---|---|
| `IProgressRepository` | `load(ProfileId, GameKey)`, `save(ProfileId, GameKey, VariantProgress)` (transacción) | `DriftProgressRepository` → Drift (en `frameworks/persistence/`, capa 4, D-156) |
| `IProfileRepository` | `active()`, `activate(Profile)`, `guest()` | `DriftProfileRepository` → Drift (en `frameworks/persistence/`, capa 4, D-156) |
| `IUnitOfWork` | `run<T>(Future<T> Function() work)`: una transacción; las unidades no se intercalan (D-158) | `DriftUnitOfWork` → transacción de Drift (en `frameworks/persistence/`, capa 4, D-156) |
| `ISavedGameRepository<TState>` | `scheduleSave(SavedGameKey, SavedGame<TState>)`, `flush()`, `load(SavedGameKey)`, `delete(SavedGameKey)` (en la misma cola que `scheduleSave`, D-110), `exists(ProfileId)` | `DriftSavedGameRepository<TState>` + `IGameStateCodec<TState>` de la variante → Drift |
| `ILevelRepository` | `bundled(GameKey)`, `downloaded(GameKey)`, `store(List<LevelDefinition>)` | `LevelRepository` → assets + Drift |
| `ISyncOutbox` | `markPending(ProfileId, GameKey, ResultKey)`, `pending(ProfileId)`, `markSent(...)` | `DriftSyncOutbox` → marca de pendiente en `level_results` y `records` (D-49) |
| `IProgressGateway` | `push(GameKey, VariantProgress) → VariantProgress` (consolidado), `pullAll()` | `HttpProgressGateway` → dio |
| `ILevelGateway` | `fetchPublished(GameKey, {since})` | `HttpLevelGateway` → dio |
| `ILeaderboardGateway` | `fetch(LeaderboardQuery) → LeaderboardPage` | `HttpLeaderboardGateway` → dio |
| `IAuthGateway` | `register(Credentials)`, `login(Credentials) → AuthToken` | `HttpAuthGateway` → dio |
| `ISessionStore` | `read() → Session?`, `write(Session)`, `clear()` | `SecureSessionStore` → `flutter_secure_storage` |
| `ISettingsRepository` | `read() → Settings`, `write(Settings)` | `PrefsSettingsRepository` → `shared_preferences` |
| `IClock` (extiende `IMonotonicClock` del dominio) | `now()` (en UTC), `nowMillis()` | `SystemClock` en `frameworks/platform/` (en pruebas, `FakeClock`) |
| `IConnectivity` | `isOnline`, `changes` | `ConnectivityAdapter` → plugin de conectividad |
| `ILogger` | `log(LogEntry)` (solo lo usan los aspectos, RNF-10) | `PlatformLogger` (capa 4, `frameworks/platform/`): consola de la plataforma; en *release*, solo advertencias y errores, sin datos (D-163) |
| `IMetrics` | `record(String name, Duration elapsed)` (solo lo usan los aspectos, RNF-10) | `LogMetrics` (capa 3, `adapters/metrics/`): escribe cada medición en el registro (D-163) |

**Otros adaptadores de la capa 3:**

| Componente | Responsabilidad |
|---|---|
| `GameCubit<C, TCell, TMove, TState>` | Uno para las 4 variantes. Recibe el `Either<AppFailure, MoveResult>` de `ApplyMoveUseCase`, convierte los eventos en animaciones y expone un estado de pantalla. Muestra deshacer solo si `session.undo != null` (D-33). Mientras se arrastra una pieza, `preview(move)` pide a `CheckMoveUseCase` si se jugaría y deja en `GameReady` un `MovePreview`; `clearPreview()` y jugar el movimiento la quitan, y una respuesta adelantada por otra llamada se descarta (D-138) |
| `HomeCubit`, `LevelSelectCubit`, `SettingsCubit`, `AccountCubit`, `LeaderboardCubit` | Una por tipo de pantalla |
| `IGameStateCodec<TState>` (uno por variante: `LinesStateCodec`, …) | Serializa y deserializa el estado inmutable para la partida guardada (D-37). Es un puerto de la capa 2 que implementa cada variante en la capa 3 |
| Mappers | Dominio ↔ DTO de la API (con los ejemplos de `docs/contracts/`, D-23) y dominio ↔ filas de Drift |
| Traductor de errores | Convierte `DioException` y los errores de Drift en `AppException` (§2) |

## 5. Aspectos AOP (D-40, D-41, D-160 a D-163)

Cada aspecto implementa `ICommandService` y extiende `Aspect` (D-160): tiene el mismo tipo que lo que envuelve, así que se anidan sin saber qué hay adentro, como el `Decorate` del capítulo 10 de Seemann y van Deursen. Una cadena no admite dos aspectos de la misma clase (`Aspect.kind`): un caso de uso nunca se registra ni se mide dos veces.

### 5.1 Los aspectos

| Aspecto | Patrón | Qué hace | A qué casos de uso |
|---|---|---|---|
| `LoggingAspect<TCommand, TResult>` | Decorator | Registra `<nombre> started` (debug), y después `<nombre> finished` (info) con `ms` o `<nombre> failed` (warning) con `ms`, el tipo de fallo y, en un conflicto o una regla, su código. Solo en modo desarrollo (`verbose`, SEC-MOB-05) agrega lo que dice un `CommandDescriber` (Strategy) sobre el comando y el resultado, **redactado** por `Redactor`: contraseñas, tokens y correos, por la clave o por la forma del valor, también anidados (SEC-WEB-06). `MoveDescriber` vuelca el tablero antes y después de cada movimiento (el ejemplo del enunciado §3.5) | Todos, menos `CheckMove`: se llama en cada paso de un arrastre (D-138) |
| `MetricsAspect<TCommand, TResult>` | Decorator | Mide cada intento con `IMonotonicClock` y lo entrega a `IMetrics`; si supera el presupuesto, lo registra como advertencia. Va por fuera del registro, así que en desarrollo también mide el volcado del tablero: el presupuesto solo es representativo en *profile* o *release* | `ApplyMove` y `CheckMove` (16 ms, RNF-31), `StartGame`, `Undo` |
| `ExceptionAspect<TCommand, TResult>` | Decorator | El más interno: convierte las excepciones en `Left` y deja pasar lo que devuelve el caso de uso (D-161). Registra un error inesperado con su tipo y su *stack*: es el único lugar que registra una excepción | Todos |
| `RetryAspect<TCommand, TResult>` (T-09, D-162) | Decorator | Reintenta si recibe `Left(NetworkFailure())`, según una `RetryPolicy` (Strategy): 2 reintentos, con espera de 0,5 s y 1 s | Solo los que usan red: `SyncProgress`, `DownloadLevels`, `GetLeaderboard`, `Register`, `Login` |
| `SessionAspect<TCommand, TResult>` (T-10, D-162) | Proxy de protección | Antes de ejecutar, comprueba **en el dispositivo** que hay un JWT vigente (sin red); si no, devuelve `Left(SessionFailure(expired: false))` sin llamar al caso de uso | Solo `SyncProgress` e `ImportGuestProgress`. **Nunca** jugar, guardar progreso ni guardar la partida (RN-COM-81, 82, 85) |

La caché del ranking (un Proxy de caché sobre `GetLeaderboard`) queda como opcional (*Could*).

```dart
// hexa_application/lib/src/aspects/logging_aspect.dart (abridged)
final class LoggingAspect<TCommand, TResult> extends Aspect<TCommand, TResult> {
  @override
  Future<Either<AppFailure, TResult>> execute(TCommand command) async {
    final start = _clock.nowMillis();
    _logger.log(LogEntry.debug('$name started', _details(() => _describe.command(command))));
    final result = await inner.execute(command); // an Either: ExceptionAspect is inside
    final ms = _clock.nowMillis() - start;
    switch (result) {
      case Right(:final value):
        _logger.log(LogEntry.info('$name finished', {'ms': ms, ..._details(() => _describe.result(value))}));
      case Left(:final value):
        _logger.log(LogEntry.warning('$name failed', {'ms': ms, ..._failure(value)}));
    }
    return result;
  }

  // Only in development, and always redacted (SEC-MOB-05, SEC-WEB-06).
  Map<String, Object?> _details(Map<String, Object?> Function() describe) =>
      verbose ? _redactor.redact(describe()) : const {};
}
```

### 5.2 Orden y ensamblado (D-41, D-161)

De afuera hacia adentro: **sesión → reintentos → métricas → registro → excepciones → caso de uso**.

- La sesión va primero: sin cuenta no tiene sentido reintentar.
- Las métricas van dentro de los reintentos: miden un intento, no la suma de todos.
- El registro va dentro de los reintentos: anota cada intento con sus datos.
- Las excepciones van pegadas al caso de uso: los demás aspectos solo ven un `Either` y ninguno necesita `try`.

`AspectChain` (en `hexa_application`, porque solo usa puertos) arma la cadena. El *composition root* la usa en una línea por caso de uso: elige **qué** aspectos lleva cada uno (matriz de §5.3), y el orden no se elige. Los reintentos y la sesión se agregan aquí con T-09 y T-10 (D-162):

```dart
// hexa_application/lib/src/aspects/aspect_chain.dart (abridged)
ICommandService<TCommand, TResult> wrap<TCommand, TResult>(
  ICommandService<TCommand, TResult> service, {
  required String name,     // given: a release build obfuscates type names
  bool logged = true,
  bool measured = false,
  Duration? budget,         // AspectChain.frameBudget = 16 ms (RNF-31)
  CommandDescriber<TCommand, TResult>? describe,
}) {
  ICommandService<TCommand, TResult> wrapped = ExceptionAspect(service, _logger, name: name);
  if (logged) wrapped = LoggingAspect(wrapped, _logger, _clock, name: name, describe: describe, verbose: verbose);
  if (measured || budget != null) wrapped = MetricsAspect(wrapped, _metrics, _clock, _logger, name: name, budget: budget);
  return wrapped;
}

// app/lib/config/hexa_lines_module.dart (composition root)
applyMoveFor: (session) => _chain.wrap(ApplyMoveUseCase(session, savedGames, key),
    name: 'ApplyMove', budget: AspectChain.frameBudget, describe: MoveDescriber(session)),
```

### 5.3 Matriz de aspectos

| Caso de uso | Lee / escribe | Sesión | Errores | Reintentos | Métricas | Registro |
|---|---|---|---|---|---|---|
| `StartGame`, `Undo`, `Redo`, `Pause`, `Resume`, `ContinuePlaying` | Escribe | — | ✓ | — | ✓ | ✓ |
| `ApplyMove` | Escribe | — | ✓ | — | ✓ (16 ms) | ✓ (tablero en modo desarrollo) |
| `CheckMove` | Lee | — | ✓ | — | ✓ (16 ms; `LogMetrics` escribe cada medición en debug) | — (D-138) |
| `SaveProgress`, `Logout`, `UpdateSettings` | Escribe | — | ✓ | — | — | ✓ |
| `GetProgress`, `LoadLevels`, `GetSettings` | Lee | — | ✓ | — | — | ✓ |
| `SyncProgress`, `ImportGuestProgress` | Escribe | ✓ | ✓ | `SyncProgress` | — | ✓ |
| `DownloadLevels`, `Register`, `Login` | Escribe | — | ✓ | ✓ | — | ✓ (redactado) |
| `GetLeaderboard` | Lee | — | ✓ | ✓ | — | ✓ (redactado) |

«Escribe» es cambiar el estado, en el dispositivo, en el servidor o en la partida que está en memoria; «lee» no cambia nada (CQS, §1).

Como `ApplyMoveUseCase` es genérico, sus aspectos aplican a las 4 variantes sin cambios (enunciado §3.5).

## 6. *Composition root* (capa 4)

| Momento | Qué se crea | Dónde |
|---|---|---|
| Arranque (`main.dart`) | Manejadores globales de errores (`installErrorHandlers`: los errores fuera de los casos de uso van al mismo `ILogger`, D-163), base de datos, adaptadores, `ILogger`, `IMetrics`, `AspectChain`, casos de uso que no dependen de una partida, Cubits de pantalla; registro de **topologías con su layout** (`TopologyEntry`, D-29) y de **módulos de variante** (`VariantModule`) | `app/lib/config/`, con `get_it` (*lazy singletons*) |
| Al abrir una partida | `topologyRegistry[figura].accept(OpenGame(module, opciones))` → el módulo crea su `VariantFamily<C>`, la `GameSession`, el codec del estado, los casos de uso de partida envueltos por `AspectChain` y el `GameCubit` | `VariantModule.open<C>()` (ARQ-02 §3.1) |
| Al pasar a segundo plano | Un `WidgetsBindingObserver` llama a `PauseGameUseCase`, que pausa, guarda un `snapshot()` nuevo y hace `flush()` de la partida guardada | `app/lib/frameworks/lifecycle/` |

## 7. Mapa completo de patrones de la app (para el README)

> El texto final de esta sección va en el README, con enlaces al código; aquí queda la justificación (D-71, T-07).

Los 14 del dominio están detallados en `ARQ-02-MOTOR.md` §9. Aquí, todos con su ubicación prevista en el código:

| Patrón | Categoría | Capa | Dónde (ruta prevista) |
|---|---|---|---|
| Abstract Factory | Creacional | 1 | `hexa_variants/lib/src/*/hexa_*_factory.dart` (`VariantFamily`) |
| Builder | Creacional | 1 | `hexa_variants/lib/src/hexa_fit/fit_level_builder.dart`, `hexa_sort/sort_level_builder.dart` |
| Factory Method | Creacional | 1 | `hexa_topologies/lib/src/*/…_topology.dart` (`cellsOf`) |
| Singleton (por inyección) | Creacional | 4 | `app/lib/config/injection.dart` (`get_it`) |
| Bridge | Estructural | 1 · 4 | `hexa_engine/lib/src/board.dart` ↔ `GridTopology`; en la vista, `TopologyLayout` × pintor de contenido (ARQ-A-06) |
| Composite | Estructural | 1 | `hexa_engine/lib/src/shape.dart` |
| Decorator | Estructural | 1 · 2 | Puntuación (`StreakMultiplier`), reglas; aspectos `LoggingAspect`, `MetricsAspect`, `ExceptionAspect` |
| Proxy | Estructural | 2 | `SessionAspect` (protección); caché del ranking (opcional) |
| Adapter | Estructural | 3 y 4 | Gateways HTTP e `IGameStateCodec` por variante (capa 3); repositorios Drift y de plataforma (capa 4, D-156) |
| Facade | Estructural | 4 | `AudioFacade`, con `audioplayers` (D-150); recibe solo un `SoundId` |
| Strategy | Comportamiento | 1 · 2 · 4 | `IGameRules`, `IScoringPolicy`, `IPieceSource`, `IProgressModel`; `RetryPolicy`, `CommandDescriber` (`MoveDescriber`); en la capa 4, `EventSounds` (qué sonido toca cada evento, uno por variante en su `VariantModule`, D-166) |
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
| **D**, inversión de dependencias | `ApplyMoveUseCase` depende de `ISavedGameRepository` (capa 2), que implementa `DriftSavedGameRepository` (capa 4, D-156); el dominio define `IMonotonicClock` y la plataforma lo implementa | Las dependencias apuntan hacia el núcleo (§3.4) |

## 9. Diagramas (D-43)

| Diagrama | Fuente editable | Imagen para el README | Cómo se genera |
|---|---|---|---|
| Clases, general (notación UML de plantilla, §4.1) | `docs/diagrams/clases.puml` | `docs/diagrams/clases.png` | DanielHaro28, con la extensión de PlantUML de VS Code (exportar a PNG) |
| Clases, detalle del motor | `docs/diagrams/clases-motor.puml` | `docs/diagrams/clases-motor.png` | Igual |
| Clases, detalle de las variantes | `docs/diagrams/clases-variantes.puml` | `docs/diagrams/clases-variantes.png` | Igual |
| Clases, detalle de aplicación y adaptadores | `docs/diagrams/clases-aplicacion.puml` | `docs/diagrams/clases-aplicacion.png` | Igual |
| Capas Clean (§4.2) | `docs/diagrams/capas.mmd` | `docs/diagrams/capas.png` | Generada con Mermaid al escribirlo |
| Extensibilidad (§4.3) | `docs/diagrams/extensibilidad.mmd` | `docs/diagrams/extensibilidad.png` | Generada con Mermaid al escribirlo |

El general muestra las 4 capas y las interfaces por las que se comunican; los de detalle repiten esas interfaces solo con su nombre (marcadas «motor») para que se pueda seguir de uno a otro (D-76). Cuando el código exista, los nombres se revisan contra las clases reales.

## 10. Decisiones de este documento

D-38 a D-41 y D-43, en `docs/DECISIONES.md` (D-67); D-160 (`ICommandService` y `Either`), D-161 (los adaptadores lanzan, los casos de uso devuelven, y las excepciones son el aspecto más interno), D-162 (alcance de TEC-03), D-163 (destino del registro) y D-170 (`Either` es una mónada). Abierta: D-164 (los errores de producción, `PENDIENTES.md`).
