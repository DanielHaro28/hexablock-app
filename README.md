# hexablock-app
HexaBlock Suite – Flutter mobile app with a generic hexagonal puzzle engine (Lines, Fit, Sort, Merge)

## Versions

Exact versions used by the team and by CI (R-01). Upgrading any of them is a PR that changes this table, the CI workflows and, for Flutter, `pubspec.lock`.

| Tool | Version | Where it is pinned |
|---|---|---|
| Flutter | 3.50.0 (stable) | `FLUTTER_VERSION` in `.github/workflows/ci.yml` and `release.yml`; `environment.flutter` in `app/pubspec.yaml` |
| Dart | 3.14.0 (bundled with Flutter) | `environment.sdk: ^3.14.0` in every `pubspec.yaml` |
| Android build | JDK 17, compile and target SDK from Flutter 3.50.0 | `app/android/app/build.gradle.kts` |
| Node.js (commit tooling only) | 22.12 or later; CI uses 26 LTS | `engines` in `package.json`; `node-version` in the `pr-title` job of `ci.yml` |

The backend versions (Node.js, NestJS, Prisma, PostgreSQL) are in the README of [hexablock-api](https://github.com/DanielHaro28/hexablock-api#versions).

## Getting started

```bash
npm ci                   # commit tooling only: installs the commitlint hook (D-123)
flutter pub get          # resolves the whole workspace (one pubspec.lock)
dart analyze --fatal-infos
cd app && flutter test
```

The workspace layout is described in `docs/architecture/ARQ-01-APP-GENERAL.md` §3.

## Generic engine

One engine (`packages/hexa_engine`) plays the four variants on any cell shape. It knows no variant and no cell shape: each cell shape is a `GridTopology<C>` in `packages/hexa_topologies`, and each variant is a set of rules in `packages/hexa_variants`. The full design is in `docs/architecture/ARQ-02-MOTOR.md`; adding a variant or a cell shape is described in `docs/EXTENSIBILITY.md`.

### Type constraints

Every constraint on a type parameter is there for a reason (RNF-05, ARQ-02 §4.3). Rows marked *planned* belong to engine parts that are not merged yet; their constraint is already decided.

| Parameter | Constraint | Why | Where |
|---|---|---|---|
| `C` (coordinate) | `C extends Coord` | Boards and shapes use coordinates as map keys and set members, so every coordinate must compare by value. `Coord` is a `base` class, so a coordinate is always a real subclass, and, since Dart cannot force a subclass to override `==` and `hashCode`, the shared contract test (`checkTopologyContract` in `hexa_test_support`) checks that each topology's coordinates compare by value | `Board`, `GridTopology`, `Shape`, `TopologyVisitor` |
| `TCell` (cell content) | `TCell extends Object` | Rules out nullable contents, so `TCell?` always means "empty cell" (D-30) and the board stores only occupied cells. Like a coordinate, a content must compare by value (override `==` and `hashCode`; a Hexa Sort stack is a value class, not a `List`), because two boards are equal when their contents are; Dart cannot enforce it, so each variant's tests check it | `Board`, `HexBoard`, `GameState` |
| `TState` (game state) | `TState extends GameState<C, TCell>` | The engine reads the board and the score of any state to notify and save it, without knowing the variant. `Step`, `TurnResult` and `MoveResult` only carry the state, and `IScoringPolicy` only reads the variant's own state, so they leave it unconstrained instead of adding an unused `C` and `TCell` | `IGameRules`, `GameRules`, `GameEngine` |
| `TMove` (move) | None | The engine never inspects a move: it only hands it to the rules. An empty constraint would be decorative | `IGameRules`, `GameRules`, `GameEngine` |
| `TPiece` (piece) | None | A Hexa Sort stack is not a shape; the piece source only hands out values | `IPieceSource` |
| `TEvent` (variant event) | None | The scoring policy switches exhaustively over the variant's own sealed event family; bounding it by `GameEvent<C>` would force an unused `C` on the policy (D-98) | `IScoringPolicy` |
| `TAttempt` (attempt) | None | Each variant decides what an attempt records (stars, time, moves, score); the progress model only compares two of them (D-99) | `IProgressModel` |
| `T` in `SlideMergeResolver<C, T>` | `T extends Mergeable<T>` (F-bounded) | Sliding and merging only need to know whether two values merge and into what, so the algorithm works for any mergeable content, not only powers of 2 | Hexa Merge (*planned*) |

**Why the coordinate is a type parameter.** The course statement names the hexagonal board `HexBoard<TCell>`: a board that is generic in its content only, with hexagons built in. After the professor warned that the cell shape could change (triangles, squares or cubes, `docs/requirements/02-RN-TOPOLOGIAS.md`), the team made the coordinate a type parameter too (D-07). `Board<C, TCell>` works with any cell shape, and `HexBoard<TCell>` stays as a `typedef` of `Board<HexCoord, TCell>` in `hexa_topologies`. Because `C` is checked at compile time, a game created with `HexCoord` cannot receive a coordinate of another shape (RN-TOP-31). The constraint `C extends Coord` is the minimum the board needs from a coordinate: value equality.

## Continuous integration and releases

- Commit messages follow Conventional Commits in English: `npm ci` installs a `commit-msg` hook (`lefthook.yml`) that runs `commitlint` (`commitlint.config.mjs`), and CI checks the PR title with the same rules, because squash merges use it as the commit on `main`.
- Every pull request runs `.github/workflows/ci.yml` (title in Conventional Commits, format, analysis, architecture checks, tests with coverage, debug APK) and `.github/workflows/docs-check.yml`.
- Pushing a tag `vX.Y.Z` on a commit of `main` runs `.github/workflows/release.yml`, which publishes the signed APK in a GitHub Release.

The release needs these secrets in the `release` environment (restricted to tags `v*`, SEC-MOB-07):

| Secret | Content |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | The upload keystore (`.jks`) encoded in base64 |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_ALIAS` | Key alias |
| `ANDROID_KEY_PASSWORD` | Key password |

Create the keystore once, outside the repository, and keep an offline copy: without it no update can be signed.

```bash
keytool -genkeypair -v -keystore hexablock-release.jks -keyalg RSA -keysize 4096 -validity 10000 -alias hexablock
base64 -w 0 hexablock-release.jks   # value of ANDROID_KEYSTORE_BASE64
```
