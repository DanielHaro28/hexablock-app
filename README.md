# hexablock-app
HexaBlock Suite – Flutter mobile app with a generic hexagonal puzzle engine (Lines, Fit, Sort, Merge)

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
