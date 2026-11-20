---
paths:
  - "packages/hexa_application/**"
---

# Casos de uso, puertos y aspectos (capa 2)

Diseño: `docs/architecture/ARQ-03-APP-DETALLE.md`.

- **Un caso de uso por clase**, que implementa `UseCase<TIn, TOut>` con `execute` (D-38).
- **Los puertos** (`IProgressRepository`, `ISavedGameRepository<TState>`…) son interfaces de esta capa; sus implementaciones van en `app/lib/adapters/`.
- **No depende de `hexa_variants`** (RNF-07): los casos de uso de partida son genéricos en `<C, TCell, TMove, TState>`.
- **Errores** (D-39): por dentro, excepciones tipadas (`AppException`); hacia la pantalla, `Result<T>`, que arma `ErrorHandlingAspect`.
- **Nadie llama a `ILogger` ni a `IMetrics` fuera de `aspects/`** (RNF-10). El registro, las métricas, los errores y la sesión son aspectos (decoradores), en el orden sesión → errores → métricas → registro con `AspectChain` (D-40, D-41).
- `LoggingAspect` **redacta** contraseñas, tokens y correos antes de registrar (SEC-WEB-06).
