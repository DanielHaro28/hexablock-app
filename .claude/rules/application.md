---
paths:
  - "packages/hexa_application/**"
---

# Casos de uso, puertos y aspectos (capa 2)

Diseño: `docs/architecture/ARQ-03-APP-DETALLE.md`.

- **Un caso de uso por clase**, que implementa `ICommandService<TCommand, TResult>`: `execute` devuelve `Future<Either<AppFailure, TResult>>` (D-160). Los aspectos implementan la misma interfaz y extienden `Aspect`.
- **Los puertos** (`IProgressRepository`, `ISavedGameRepository<TState>`…) son interfaces de esta capa. Las implementaciones que se apoyan en un framework (Drift, almacenamiento seguro, preferencias) van en `app/lib/frameworks/`; los gateways y los códecs, en `app/lib/adapters/` (D-156).
- **No depende de `hexa_variants`** (RNF-07): los casos de uso de partida son genéricos en `<C, TCell, TMove, TState>`.
- **Errores** (D-39, D-161): los adaptadores **lanzan** una `AppException`; los casos de uso **devuelven** `Left(RuleFailure(...))` si una regla lo impide y nunca lanzan ni atrapan. `ExceptionAspect` convierte lo que se lanza en `Left`.
- **Ningún caso de uso, presentador ni gateway llama a `ILogger` ni a `IMetrics`** (RNF-10): en esta capa solo los usan los aspectos (`aspects/`). En la capa 4, `ILogger` lo usan solo los manejadores de los errores de fuera de un caso de uso (D-163) y los repositorios con cola, para los fallos que ningún caso de uso ve (D-172). El registro, las métricas, los errores y la sesión son aspectos (decoradores), en el orden sesión → reintentos → métricas → registro → excepciones → caso de uso con `AspectChain` (D-40, D-41, D-161).
- `LoggingAspect` **redacta** contraseñas, tokens y correos antes de registrar (SEC-WEB-06).
