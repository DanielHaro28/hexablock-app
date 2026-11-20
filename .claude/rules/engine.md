---
paths:
  - "packages/hexa_engine/**"
  - "packages/hexa_topologies/**"
---

# Motor genérico y topologías (capa 1)

Diseño completo: `docs/architecture/ARQ-02-MOTOR.md` (la primera página resume D-07 y D-29 a D-36).

- **Dart puro.** El `pubspec.yaml` de estos paquetes no declara Flutter ni paquetes de terceros (enunciado §3.4, RNF-06). Si algo parece necesitar una dependencia, pregunta antes.
- **`hexa_engine` no depende de `hexa_variants` ni de `hexa_topologies`**, y su código no contiene identificadores de variante ni de figura: `HexaLines`, `HexaFit`, `HexaSort`, `HexaMerge`, `hexa_variants`, `hexa-lines`, `hexa-fit`, `hexa-sort`, `hexa-merge`, `HexCoord`, `HexTopology`, `SquareCoord`, `TriCoord`, `CubeCoord`, `HexBoard`, `hexa_topologies`. El CI lo comprueba (ARQ-01-APP §8).
- **Restricciones de tipo** (ARQ-02 §4.3): `C extends Coord`, `TCell extends Object` (celda vacía = `null`), `TState extends GameState<C, TCell>`; `TMove` sin restricción. Documenta en el código por qué existe cada una.
- **Estado inmutable**: las reglas devuelven un estado nuevo; nada muta el anterior.
- **`GameRules.playTurn` es el Template Method** (D-36): fija el orden validar → aplicar → resolver → después de resolver → evaluar. Los pasos son `protected`; las variantes no lo sobrescriben.
- **Eventos**: las reglas los devuelven en orden y la pantalla los recibe en el `MoveResult` de `submit` (D-32). El `Stream` del motor es para historial, cronómetro, audio y analítica.
- **Azar**: solo `Xorshift32` con semilla (RN-COM-43, D-14). Nada de `Random()` ni de `DateTime.now()` en el dominio; el tiempo llega por `IMonotonicClock`.
- **Una topología nueva** implementa `GridTopology<C>` con su `Coord` y se registra con su layout (D-29): no se agregan `switch` sobre la figura.
