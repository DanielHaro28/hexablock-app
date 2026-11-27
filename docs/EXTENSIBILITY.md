# EXTENSIBILITY — cómo se extiende HexaBlock Suite

> Exigido por el enunciado §3.1 y §4.3. Explica, paso a paso, **qué archivos se crean**, **qué líneas de registro y de configuración cambian** y **qué no se toca** para agregar una 5ª variante, otra figura de celda o un cambio de regla pequeño. La regla de oro: **el motor (`packages/hexa_engine`) y los casos de uso (`packages/hexa_application`) no se modifican nunca**.
>
> Las rutas son las del código real, con Hexa Lines como modelo: donde esta guía dice `hexa_fill`, mira el archivo equivalente de `hexa_lines`. Unas pocas piezas ya están decididas pero llegan con su historia, y la guía lo dice en cada caso: la tarjeta del inicio (NAV-01), `EventSounds` (NAV-02) y el *codec* de la partida guardada (NAV-04).
>
> **Última actualización:** 2026-11-27 (D-130: rutas reales, la lista completa de lo que cambia y el registro de variantes de las herramientas)

![Diagrama de extensibilidad](diagrams/extensibilidad.png)

Fuente editable: `docs/diagrams/extensibilidad.mmd`.

---

## 0. Resumen: qué cambia al agregar una variante

| Grupo | Qué | ¿Toca el motor o los casos de uso? |
|---|---|---|
| **Nunca cambia** | `hexa_engine`, `hexa_application`, las carpetas de las otras 4 variantes, `GameCubit`, `BoardView` y los *painters* comunes | — |
| **Clases nuevas** | La carpeta de la variante en `hexa_variants`, su *mapper* y su *codec* en la capa 3, su pantalla, su *painter* y su `EventSounds` en la capa 4, y su `VariantModule` | No |
| **Registro** | Una línea de `export` por archivo público, el módulo y la carga de su JSON en `dependencies.dart`, su tarjeta del inicio y su entrada en `tools/variants.json` | No |
| **Configuración y datos** | Su JSON, sus niveles, sus textos en es y en, su color de juego y sus sonidos; en el **contrato**, su `gameId` (con `/paired-change`), y en el backend, su `gameId` permitido | No |
| **Documentos** | Sus reglas, sus requisitos e historias, la trazabilidad y RN-COM-01 («exactamente 4 variantes») | No |

El contrato enumera los `gameId` a propósito: el servidor rechaza un `gameId` que no conoce (SEC-API-06). Es configuración validada, no código del motor, y `tool/check_architecture.dart` falla si la lista del contrato no coincide con `tools/variants.json`.

## 1. Lo que nunca se modifica

| Paquete o archivo | Qué contiene | Por qué no hace falta tocarlo |
|---|---|---|
| `packages/hexa_engine/` | `GameEngine`, `Board`, `GridTopology`, `GameRules`, fases, eventos, `UndoHistory`, capacidades, `VariantFamily`, `NewGameOptions`, `Xorshift32`, `IMonotonicClock` y las estrategias (`IPieceSource`, `IScoringPolicy`, `IProgressModel`) | Solo conoce abstracciones: no nombra ninguna variante ni figura, y el CI lo comprueba con los nombres de `tools/variants.json` (RNF-02, RNF-04) |
| `packages/hexa_application/` | Casos de uso genéricos (`StartGameUseCase`, `ApplyMoveUseCase`, `CheckMoveUseCase`, `GetProgressUseCase`, `SaveProgressUseCase`), puertos y aspectos (`AspectChain`) | Son genéricos en `C`, `TCell`, `TMove` y `TState` (RNF-07) |
| `packages/hexa_variants/lib/src/hexa_{lines,fit,sort,merge}/` | Las 4 variantes actuales | Cada variante es independiente |
| `packages/hexa_topologies/` | Las figuras de celda (hoy, hexágonos en `src/hex/`) | Una variante funciona con cualquier figura |
| `app/lib/adapters/presentation/game/game_cubit.dart` | `GameCubit<C, TCell, TMove, TState>` | Sirve para cualquier variante |
| `app/lib/frameworks/ui/board/` | `BoardView`, `CellsPainter`, `CellPainter`, `TopologyLayout`, el arrastre y la vista previa | Dibujan cualquier figura y cualquier contenido de celda |
| Repositorios, *gateways*, aspectos y Cubits de pantalla | Persistencia, red, navegación | No dependen de la variante |

## 2. Agregar una 5ª variante (ejemplo: Hexa Fill)

*Hexa Fill* es el ejemplo del enunciado: pintar celdas con restricciones. Las reglas concretas las definiría el equipo; aquí importa **dónde** va cada pieza. Una 5ª variante cambia RN-COM-01, así que en la defensa se hace con `/rule-change` y `/new-variant`.

### Paso 1 · Reglas de negocio

| Crear | Contenido |
|---|---|
| `docs/requirements/02-RN-HEXA-FILL.md` | Reglas con IDs nuevos (por ejemplo `RN-FL-*`) y ejemplos `E-*` verificados con `tools/reference-sim/` |

### Paso 2 · Dominio (capa 1): una carpeta nueva en `hexa_variants`

| Crear en `packages/hexa_variants/lib/src/hexa_fill/` | Qué implementa | Punto de extensión |
|---|---|---|
| `fill_state.dart` | `FillState<C> implements GameState<C, FillColor>`, con `FillColor` (`TCell`) y los eventos `sealed class FillEvent<C> extends GameEvent<C>` (como `lines_state.dart`); si hay azar, también `IRandomSeeded`; si hay niveles, `ILevelBased`, y el estado guarda el nivel que usa (D-165) | `GameState`, `GameEvent` (D-32), capacidades (D-33) |
| `fill_move.dart` (o dentro del estado) | `sealed class FillMove<C>` con sus movimientos, como `PaintCell<C>` (`TMove`) | — |
| `fill_rejections.dart` (opcional) | `sealed class FillRejection extends RejectionReason`, solo si la pantalla explica por qué se rechaza un movimiento; si no, `const InvalidMove()` | `RejectionReason` (D-95) |
| `hexa_fill_rules.dart` | `HexaFillRules<C> extends GameRules<C, FillColor, FillMove<C>, FillState<C>>`: `rejectionOf`, `apply`, `validMoves` y, si hacen falta, `resolve`, `afterResolve` y `evaluate`. Nunca `playTurn` (D-36) | `GameRules` (Strategy + Template Method) |
| `fill_scoring.dart` | `FillScoring<C> implements IScoringPolicy<FillState<C>, FillEvent<C>>`, con los valores leídos de configuración (RNF-11, D-139) | `IScoringPolicy` (D-98) |
| `fill_piece_source.dart` (si hay azar) | `FillPieceSource implements IPieceSource<FillPiece>`: recibe el generador del estado y devuelve la pieza y el generador siguiente (D-97) | `IPieceSource` |
| `fill_progress.dart` (si el criterio es nuevo) | `FillProgressModel implements IProgressModel<…>`; si sirve el récord o el criterio de niveles, se reutiliza | `IProgressModel` (D-99) |
| `fill_level.dart` y `fill_level_builder.dart` (si es por niveles) | El nivel del dominio y su Builder, que lo arma y valida | Builder |
| `hexa_fill_factory.dart` | `HexaFillFactory<C> implements VariantFamily<C, FillColor, FillMove<C>, FillState<C>>`: reglas, puntuación, fuente de piezas, estado inicial (D-93) y `GameSession` nueva o continuada (`GameEngine.paused`, D-111, D-116), con **solo** las capacidades que tenga (D-33). Si es por niveles, recibe el catálogo de niveles de la figura y busca el nivel por `options.levelId` (D-125) | `VariantFamily` (Abstract Factory) |

| Modificar | Cambio |
|---|---|
| `packages/hexa_variants/lib/hexa_variants.dart` | Una línea `export 'src/hexa_fill/<archivo>.dart';` por archivo que use la app (Hexa Lines exporta 6) |

### Paso 3 · Configuración y datos

| Crear | Contenido |
|---|---|
| `app/assets/config/hexa-fill.json` | Tablero y catálogo por figura, colores y valores del puntaje (RNF-11), como `hexa-lines.json`. `assets/config/` ya está declarado en `app/pubspec.yaml` |
| `app/assets/levels/hexa-fill/*.json` (si es por niveles) | Niveles en el esquema común, con la sección específica `hexa-fill` (RN-COM-70) |
| Sonidos en `app/assets/audio/` | Solo si la variante trae sonidos propios, con su licencia (D-150, D-166) |

| Modificar | Cambio |
|---|---|
| `app/pubspec.yaml` (si es por niveles o trae sonidos) | Una línea en `assets:` por carpeta nueva (`- assets/levels/hexa-fill/`): Flutter no incluye subcarpetas solas |

### Paso 4 · Adaptadores (capa 3)

| Crear | Qué implementa |
|---|---|
| `app/lib/adapters/mappers/fill_config_mapper.dart` | Lee `hexa-fill.json` con el `CoordOf` de la figura (`coord_of.dart`), como `lines_config_mapper.dart` (D-132) |
| `app/lib/adapters/mappers/fill_level_mapper.dart` (si es por niveles) | Lee cada nivel en `FillLevel<C>` para el catálogo de la fábrica (D-125) |
| El *codec* de su estado | `IGameStateCodec<FillState<C>>`, para la partida guardada (D-37); llega con NAV-04 para todas las variantes (D-156) |

### Paso 5 · Pantalla y módulo (capa 4)

| Crear | Qué implementa |
|---|---|
| `app/lib/frameworks/ui/hexa_fill/` | Su pantalla y su *painter* de celda, como `lines_game_screen.dart` y `lines_cell_painter.dart`: cómo se dibuja una `FillColor` en una celda de **cualquier** figura (el *layout* lo pone la topología) |
| `app/lib/frameworks/ui/hexa_fill/fill_event_sounds.dart` | `FillEventSounds implements EventSounds`: qué sonido toca cada `FillEvent`; los del motor los cubre `CommonEventSounds` (D-166; `EventSounds` llega con NAV-02) |
| `app/lib/config/hexa_fill_module.dart` | `HexaFillModule implements VariantModule`: su `gameId`, sus `sounds` y `open<C>()`, que crea `HexaFillFactory<C>`, envuelve los casos de uso con `AspectChain` y arma el `GameCubit` (ARQ-02 §3.1), como `hexa_lines_module.dart` |

| Modificar | Cambio |
|---|---|
| `app/lib/config/dependencies.dart` | La carga de su JSON (`await _json(bundle, HexaFillModule.configAsset)`) y `..add(HexaFillModule(...))` en el `VariantRegistry` |
| `app/lib/config/game_catalog.dart` | Su tarjeta del inicio (`HomeGame`: `gameId`, si es por niveles, su SVG y sus textos), con `assets/games/hexa-fill.svg` (llega con NAV-01, #146) |
| `app/assets/l10n/app_es.arb` y `app_en.arb` | Sus textos en los dos idiomas (RNF-50); `check_architecture.dart` falla si un idioma tiene una clave que el otro no |
| Sistema de diseño y tema | Su color de juego (`game-fill`, como `game-lines`), en `docs/design/sistema/` y en los *tokens* del tema. Es una decisión de diseño |

### Paso 6 · Contrato y backend (`/paired-change`, D-23)

El contrato tiene su fuente en `hexablock-api`: se cambia allí y se copia aquí.

| Modificar en `docs/contracts/schemas/` | Cambio |
|---|---|
| `common.schema.json` | `hexa-fill` en el `enum` de `gameId`. Si es por niveles, también en `levelGameId` y en el patrón de `levelId` (`^(fit\|sort\|fill)-…`) |
| `progress.schema.json` | La condición por `gameId` que dice qué forma de progreso usa (récord o niveles) |
| `level.schema.json` (si es por niveles) | Su sección específica `variant` |
| `leaderboard.schema.json` (si es por niveles) | Su `kind` de ranking por nivel |
| Configuración de `gameId` permitidos en `hexablock-api` | `hexa-fill`, para que la validación de plausibilidad lo acepte (SEC-API-06) |

### Paso 7 · Herramientas del equipo

| Modificar | Cambio |
|---|---|
| `tools/variants.json` | **Una entrada**: `gameId`, el prefijo de sus clases (`HexaFill`), su carpeta, el prefijo de sus reglas e historias y cuántos niveles trae. Desde ahí, `check_architecture.dart` prohíbe sus nombres en el motor y en los casos de uso y compara las carpetas y el contrato, `check_ids.py` reconoce sus IDs y `levelcheck.py` cuenta sus niveles |
| `tools/reference-sim/` y `tools/docs-check/check_examples.py` | El simulador de sus reglas y la verificación de sus ejemplos `E-*`: son reglas nuevas, así que sus verificaciones también lo son |
| `tools/reference-sim/levelcheck.py` (si es por niveles) | Su sección de validación: hasta tenerla, el script falla con «no validator for its levels yet» |

### Paso 8 · Pruebas

| Crear | Qué comprueba |
|---|---|
| `packages/hexa_variants/test/hexa_fill/hexa_fill_rules_test.dart` | Cada ejemplo `E-*` de `02-RN-HEXA-FILL.md`, con su ID en el `group` y nombres `should_<resultado>_when_<condición>` (RNF-22) |
| `packages/hexa_variants/test/hexa_fill/hexa_fill_factory_test.dart` | En un `group`, `checkVariantFamilyContract(HexaFillFactory(...))` de `hexa_test_support`: una partida continuada empieza en pausa y su `snapshot()` vuelve igual (RN-COM-34, D-116) |
| `packages/hexa_variants/test/hexa_fill/hexa_fill_any_shape_test.dart` | Las mismas reglas con otra figura, como `hexa_lines_any_shape_test.dart` (RNF-04) |
| Determinismo | Misma semilla y mismos movimientos → mismo estado (RNF-20) |
| `app/test/adapters/mappers/` | Sus *mappers* leen la configuración y los niveles |

### Paso 9 · Documentos

`03-REQUISITOS.md` (sus RF), `04-HISTORIAS.md` (sus historias), `05-TRAZABILIDAD.md`, `01-GLOSARIO.md` (compartido), RN-COM-01 en `02-RN-COMUNES.md` y, si es por niveles, `docs/levels/CATALOGO.md` (lo genera `levelcheck.py`).

### Comprobación final

`git diff --stat main` debe mostrar:

1. **Ningún cambio** en `packages/hexa_engine/`, `packages/hexa_application/`, las carpetas de las otras 4 variantes, `game_cubit.dart` ni `app/lib/frameworks/ui/board/`.
2. **Archivos nuevos** en `hexa_variants/lib/src/hexa_fill/`, `app/lib/adapters/mappers/`, `app/lib/frameworks/ui/hexa_fill/` y `app/lib/config/hexa_fill_module.dart`, con sus pruebas.
3. **Líneas de registro:** `hexa_variants.dart`, `dependencies.dart`, `game_catalog.dart`, `tools/variants.json` y, si hace falta, `app/pubspec.yaml`.
4. **Configuración y datos:** su JSON, sus niveles, los `.arb`, el color, el contrato (en los dos repos) y la configuración del backend.
5. **Documentos.**

`dart run tool/check_architecture.dart` demuestra el punto 1: el motor y los casos de uso no nombran la variante.

## 3. Cambios de regla pequeños (lo que puede pedir el jurado)

| Pedido | Dónde se implementa | Qué se toca |
|---|---|---|
| **Otro tamaño de tablero** | `app/assets/config/<gameId>.json` → `GridTopology.cellsOf(ShapeSpec)` (Factory Method) | Solo configuración |
| **Otra política de puntuación** | Una clase nueva `…Scoring implements IScoringPolicy<TState, TEvent>`, o un decorador sobre la política (D-98). Un multiplicador con fracciones envuelve solo la política del paso cuyos eventos multiplica, para redondear una sola vez (D-101, RN-COM-51) | La clase nueva y **una línea** en `_createScoring()` de la fábrica concreta (D-100), como en `hexa_lines_factory.dart` |
| **Otros valores del puntaje** (p. ej., 10 puntos por celda de línea o un tope ×4 de la racha en Lines) | `app/assets/config/<gameId>.json`, sección `scoring` (RNF-11, D-139) | Solo configuración |
| **Una forma de pieza nueva** | El catálogo de piezas en la configuración (Lines) o la definición del nivel (Fit) | Solo configuración |
| **Una restricción de regla** (p. ej., límite de movimientos) | Un decorador de reglas: `MoveLimitRulesDecorator<…> extends GameRules<…>`, que envuelve las reglas de la variante, delega cada paso y agrega la condición en su paso (`rejectionOf`, `evaluate`). No declara `playTurn`, así que la comprobación de D-36 lo acepta (D-96, ARQ-02 §9.6) | La clase nueva y una línea en `createRules()` |
| **Otra ficha objetivo** (Merge) o **más metas** (Sort) | Configuración de la variante o del nivel | Solo configuración |
| **Otro sonido para un evento** | El `EventSounds` de esa variante (D-166) | Una línea en su `soundOf` |

En ningún caso se modifica `GameEngine`, `Board` ni un caso de uso.

## 4. Agregar otra figura de celda

| Crear | Qué implementa |
|---|---|
| `packages/hexa_topologies/lib/src/<figura>/<figura>_coord.dart` | `final class XCoord extends Coord` (igualdad por valor), como `src/hex/hex_coord.dart` |
| `packages/hexa_topologies/lib/src/<figura>/<figura>_topology.dart` | `final class XTopology extends GridTopology<XCoord>` con constructor `const`. Declara sus ejes, direcciones y giros básicos, e implementa solo las primitivas de la figura: `cellsOf`, `neighbors` (en orden canónico), `step`, `lines`, `compareReadingOrder`, `rotateCell`, `normalizationOrigin` y `translate` (RN-COM-10 a 17). Normalizar, rotar, las orientaciones, los rayos, la colocación en un ancla (`place`, D-92) y el Visitor ya vienen escritos en `GridTopology` (D-90) |
| `packages/hexa_topologies/test/<figura>/<figura>_topology_test.dart` | Las pruebas del anexo y, en un `group`, `checkTopologyContract(XTopology(), <tablero por defecto>)` de `hexa_test_support` (igualdad por valor, vecinas, orden de lectura, líneas y direcciones, normalizar, orientaciones y colocar) |
| `docs/requirements/02-RN-TOPOLOGIAS.md` (anexo nuevo) | Reglas y ejemplos verificados de la figura |
| `app/lib/frameworks/ui/board/<figura>_layout.dart` | `XLayout implements TopologyLayout<XCoord>`: dónde se dibuja cada celda y qué celda se tocó, como `hex_layout.dart` |
| Catálogos y niveles por figura | Una entrada `"<figura>"` en `topologies` de cada `app/assets/config/<gameId>.json` (catálogos de Lines según D-20, abierta); niveles según D-28: 3 de muestra de Fit por figura nueva; los de Sort con `any` ya sirven |

| Modificar | Cambio |
|---|---|
| `packages/hexa_topologies/lib/hexa_topologies.dart` | Los `export` de la figura |
| `app/lib/config/dependencies.dart` | Una línea en el registro: `..add(const TopologyEntry(XTopology(), XLayout(), _xCoord))`, con el `CoordOf` que lee una celda `[…]` de la configuración. El *Visitor* (D-29) recupera el tipo `XCoord`, sin `switch` |
| `tool/check_architecture.dart` | Los nombres de la figura (`XCoord`, `XTopology`) en `_shapeIds`, para que el motor no pueda nombrarlos (RNF-04) |

Ninguna variante cambia: sus reglas usan las operaciones de `GridTopology`, así que funcionan con la figura nueva.
