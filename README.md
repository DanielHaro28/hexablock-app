# hexablock-app
HexaBlock Suite – Flutter mobile app with a generic hexagonal puzzle engine (Lines, Fit, Sort, Merge)

## Versions

Exact versions used by the team and by CI (R-01). Upgrading any of them is a PR that changes this table, the CI workflows and, for Flutter, `pubspec.lock`.

| Tool | Version | Where it is pinned |
|---|---|---|
| Flutter | 3.50.0 (stable) | `FLUTTER_VERSION` in `.github/workflows/ci.yml` and `release.yml`; `environment.flutter` in `app/pubspec.yaml` |
| Dart | 3.14.0 (bundled with Flutter) | `environment.sdk: ^3.14.0` in every `pubspec.yaml` |
| Android build | JDK 17, compile and target SDK from Flutter 3.50.0 | `app/android/app/build.gradle.kts` |

The backend versions (Node.js, NestJS, Prisma, PostgreSQL) are in the README of [hexablock-api](https://github.com/DanielHaro28/hexablock-api#versions).

## Getting started

```bash
flutter pub get          # resolves the whole workspace (one pubspec.lock)
dart analyze --fatal-infos
cd app && flutter test
```

The workspace layout is described in `docs/architecture/ARQ-01-APP-GENERAL.md` §3.

## Continuous integration and releases

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
