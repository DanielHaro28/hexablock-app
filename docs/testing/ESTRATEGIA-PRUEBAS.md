# Estrategia de pruebas — app (Paso 6)

| Campo | Valor |
|---|---|
| Estado | Decidida por el equipo (D-36, D-56 a D-59, 20-11) |
| Fecha | 2026-11-20 |
| Repositorio | `hexablock-app` (`docs/testing/ESTRATEGIA-PRUEBAS.md`) |
| Par | `hexablock-api/docs/testing/ESTRATEGIA-PRUEBAS.md` (misma estructura) |
| Enunciado | §3.6 (casos de prueba), §7.3 (pruebas del código generado por IA) |

## 1. Qué pide el enunciado y dónde se cumple

| Pide (§3.6) | Cómo se cumple | Sección |
|---|---|---|
| Probar cada entidad, caso de uso y servicio de forma aislada | Pruebas unitarias por paquete, con dobles (D-56) | §3, §4 |
| Reglas propias por variante: líneas en 3 ejes, cobertura exacta, cascada, fusión | Cada ejemplo `E-*` de `02-RN-*.md` es una prueba | §3, §6 |
| Motor con un tipo de celda de prueba | `hexa_engine` se prueba con `FakeCell`, sin ninguna variante | §3 |
| *Mocks* o *stubs* para repositorios, red y generador con semilla fija | *Fakes* y *stubs* por defecto; *mocks* solo para verificar llamadas | §4 |
| Patrón AAA y nombres `should_[resultado]_when_[condición]` | Convención obligatoria; la revisa la plantilla de PR | §5 |
| Pruebas no frágiles | Se prueba comportamiento, no detalles; sin *goldens* | §5 |
| Integración: casos de uso con repositorios reales en una base en memoria | Drift con `NativeDatabase.memory()` (D-57) | §3 |
| Flujos completos de guardar y recuperar progreso, por variante | Una prueba de integración por variante | §3 |
| Widget: componentes que se dibujan y responden; navegación entre pantallas | Pruebas de widget y de navegación | §3 |
| Contrato (Pact o equivalente) | Copia idéntica del contrato + mappers probados con sus ejemplos (D-23) | §3 |
| Pruebas en CI en cada PR | Workflow de GitHub Actions | §8 |

## 2. Pirámide

| Nivel | Cuántas | Velocidad | Qué prueba |
|---|---|---|---|
| Unitarias (capas 1 y 2) | La mayoría | Milisegundos | Motor, topologías, reglas de cada variante, casos de uso, aspectos |
| Integración (capa 3) | Decenas | Menos de un segundo | Repositorios Drift en memoria, codecs, gateway contra los ejemplos del contrato |
| Widget y navegación (capa 4) | Decenas | Segundos | Pantallas, tablero, gestos, flujo inicio → partida → victoria o derrota |
| Arquitectura y contenido | Pocas | Segundos | Dependencias entre capas, Template Method, contrato copiado, niveles incluidos |

## 3. Qué se prueba en cada parte

| Parte | Tipo | Qué se prueba | Dobles |
|---|---|---|---|
| `hexa_engine` | Unitaria | Tablero genérico, fases (`GamePhase`), `GameEngine`, deshacer y rehacer (`UndoHistory`), eventos. **Con `FakeCell` y una topología de prueba**, para demostrar que el motor no conoce ninguna variante (RNF-01, RNF-02) | `FakeCell`, `FakeTopology`, `FakeRules` |
| `hexa_topologies` | Unitaria | Vecinas, líneas, giros y tablero por defecto de cada figura (RN-TOP-*) | — |
| `hexa_variants` | Unitaria | Cada ejemplo `E-HL-*`, `E-HF-*`, `E-HS-*`, `E-HM-*`: líneas en los 3 ejes, cobertura exacta, cascada con desempate horario, fusión por choque; puntajes; generación de pilas (E-HS-GEN); validadores de nivel | xorshift real con semilla fija |
| `hexa_application` | Unitaria | Cada caso de uso (tabla de ARQ-03-APP §3) y cada aspecto (sesión, errores y reintentos, métricas, logging) y su orden (D-41) | *Fakes* de todos los puertos (§4) |
| `lib/adapters/` | Integración | Repositorios Drift en una base en memoria; migraciones (ARQ-04-APP §6); codecs de partida guardada (ida y vuelta); gateway HTTP con un servidor falso que responde con `docs/contracts/examples/` | `NativeDatabase.memory()`, `FakeHttpServer` |
| Flujo de progreso | Integración | **Por cada variante**: jugar hasta ganar → `SaveProgressUseCase` → Drift en memoria → `SyncProgressUseCase` contra el gateway falso → borrar y volver a leer → mismo progreso (§3.6 del enunciado) | Drift en memoria, gateway falso |
| `lib/frameworks/` | Widget | El tablero se dibuja con la figura elegida; tocar, arrastrar y rotar llaman al caso de uso correcto; la victoria muestra estrellas o puntaje | Casos de uso falsos |
| Navegación | Widget | Inicio → selección de juego → selección de nivel → partida → victoria y derrota → reintentar, siguiente, salir; niveles bloqueados con candado | Router real, casos de uso falsos |
| Arquitectura | Estática | Ningún paquete de capa 1 o 2 importa Flutter, Drift, dio ni otra capa externa (D-21, RNF-06); el motor no nombra ninguna variante (RNF-02); ninguna clase de `hexa_variants` declara `playTurn` (D-36) | — |
| Contrato | Estática + unitaria | `docs/contracts/` es idéntico al del repo de la API (D-23); cada mapper lee y escribe todos los ejemplos del contrato; cada petición que arma la app valida contra su esquema | Ejemplos del contrato |
| Niveles incluidos | Unitaria | Los 25 archivos de `assets/levels/` pasan el esquema, el validador del dominio (incluida la regla geométrica, D-19) y la revisión de dificultad (D-54, D-55) | — |

Prueba de arquitectura de D-36 (`packages/hexa_variants/test/architecture/template_method_test.dart`): recorre `lib/` del paquete y falla si encuentra una declaración de `playTurn`. Usa `package:analyzer` como **dependencia de desarrollo** del test, no del paquete, así que no rompe la regla de la capa 1.

## 4. Dobles de prueba (D-56)

**Por defecto, *fakes* y *stubs* escritos a mano.** Se comportan como el objeto real, pero en memoria. Viven en un paquete del workspace solo para pruebas, `packages/hexa_test_support`, que los demás paquetes usan como `dev_dependency`.

| Puerto (ARQ-03-APP §4) | Doble | Tipo |
|---|---|---|
| `IProgressRepository`, `ISavedGameRepository`, `ILevelRepository`, `IProfileRepository`, `ISettingsRepository` | `InMemory…Repository` | *Fake* |
| `ISyncOutbox` | `InMemorySyncOutbox` (marca y revisión, como ARQ-04-APP §4) | *Fake* |
| `ILevelGateway`, `IProgressGateway`, `IAuthGateway`, `ILeaderboardGateway` | `Contract…Gateway`: responden con `docs/contracts/examples/` | *Stub* |
| `IClock`, `IMonotonicClock` | `FakeClock` (se adelanta a mano) | *Fake* |
| `IRandomSeeded`, `IPieceSource` | El **xorshift32 real** con semilla fija (RN-COM-43) | Real |
| `IConnectivity` | `FakeConnectivity` (se pasa a "sin conexión" a mano) | *Fake* |
| `ISessionStore` | `InMemorySessionStore` | *Fake* |
| `ILogger` | `RecordingLogger` (guarda lo que recibió) | *Spy* |
| `IMetrics` | `RecordingMetrics` | *Spy* |

**Cuándo un *mock* (`mocktail`):** solo cuando lo único observable es que algo se llamó. Por ejemplo: que `LoggingAspect` **no** pase la contraseña al logger, o que `SessionAspect` **no** llame al caso de uso con un token vencido. Nunca para devolver datos: para eso hay *stubs*.

**Quién los escribe:** la IA, junto con las pruebas (D-59), y el equipo los revisa en el PR.

## 5. Convenciones

- **Nombre:** `should_[resultado]_when_[condición]`, en inglés. Ejemplo: `should_clear_three_lines_when_piece_completes_all_axes`.
- **AAA:** cada prueba tiene los bloques `// Arrange`, `// Act`, `// Assert`, en ese orden y una sola vez.
- **Un comportamiento por prueba.** Si el nombre necesita "and", son dos pruebas.
- **Ejemplos de las reglas:** el `group` lleva el ID del ejemplo (`group('E-HS-3', …)`), así cada `E-*` se encuentra con una búsqueda (§6).
- **Sin esperas reales ni azar:** el tiempo sale de `FakeClock` y el azar de una semilla fija. Si una prueba falla una vez de cada diez, se arregla o se borra.
- **Comportamiento, no detalles:** se comprueba el estado, los eventos o lo que ve la pantalla; no qué métodos privados se llamaron ni en qué orden interno.
- **Sin *golden tests*** (comparar capturas de pantalla): cambian con la fuente y la plataforma, y son frágiles.

## 6. Trazabilidad

Cada ejemplo `E-*` de `docs/requirements/02-RN-*.md` tiene una prueba con su ID en el `group`. Un script de CI (`tool/check_examples_covered.dart`) lista los IDs de los documentos y falla si alguno no aparece en `test/` ni en `packages/*/test/`. Los ejemplos ya están verificados con el simulador de referencia (`tools/reference-sim/`), así que una prueba en rojo indica un error en el código, no en el ejemplo.

## 7. Cobertura (D-58)

| Parte | Mínimo | Qué cubre |
|---|---|---|
| Dominio: `hexa_engine`, `hexa_topologies`, `hexa_variants` | **90 %** de líneas | Capa 1 |
| Casos de uso: `hexa_application` | **80 %** | Capa 2 |
| Total del repo | **70 %** | Todo, incluidas las pantallas |

`flutter test --coverage` en cada paquete genera `lcov.info`, y `tool/coverage_gate.dart` suma por parte y **hace fallar el CI** si alguna queda debajo de su mínimo. Los archivos generados (Drift, `*.g.dart`) no cuentan.

## 8. Pruebas del código generado por IA (D-59)

1. La IA escribe el código **y sus pruebas** en el mismo PR, siguiendo §5.
2. Un integrante **lee y ajusta** las pruebas antes de aprobar: que prueben el comportamiento de la regla y no lo que el código hace por dentro; que cubran el ejemplo `E-*` correspondiente; que el nombre diga lo que comprueba.
3. La plantilla de PR tiene una casilla para esto, y `AI_USAGE.md` dice qué ajustó cada integrante.
4. Si en la práctica la revisión no alcanza (pruebas que pasan pero no detectan errores), se cambia a la opción B de D-59: el integrante escribe primero las pruebas y la IA implementa.

## 9. CI en cada PR

`.github/workflows/ci.yml`, en este orden; un paso que falla corta el resto:

1. `dart format --set-exit-if-changed .`
2. `flutter analyze` (con `analysis_options.yaml` estricto)
3. Pruebas de arquitectura (D-21, D-36, RNF-02)
4. Contrato: `docs/contracts/` igual al del repo de la API (D-23) y `python3 docs/contracts/check_contracts.py`
5. Niveles incluidos: `python3 tools/reference-sim/levelcheck.py` y la prueba en Dart con el validador del dominio
6. `flutter test --coverage` en cada paquete y en la app
7. `tool/coverage_gate.dart` (D-58) y `tool/check_examples_covered.dart` (§6)

Costo: los repos son públicos, así que los *runners* estándar no gastan minutos (D-57).

## 10. Fuera del alcance (por ahora)

| Qué | Por qué |
|---|---|
| Pruebas en un emulador (`integration_test`) en CI | Lentas en GitHub Actions; se corren a mano antes de cada entrega. Las de widget cubren la navegación |
| Pruebas de mutación | *Could*: si sobra tiempo, para medir si las pruebas detectan errores |
| Rendimiento | La medición del Paso 3 dejó al motor muy por debajo del presupuesto de un cuadro; se repite a mano si cambia el motor |
