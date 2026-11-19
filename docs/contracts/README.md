# Contracts

Single source of the contract between `hexablock-app` and `hexablock-api` (D-23). The app keeps a **byte-identical copy** of this folder in `hexablock-app/docs/contracts/`, and its CI fails if the copy differs. Change the contract here first, in its own PR, and then copy it to the app in a PR with the same title.

| File | What it defines | Rules |
|---|---|---|
| `openapi.yaml` | Every route, parameter, body, response and error (OpenAPI 3.1). Swagger in `/docs` is generated from it (TEC-05) | D-44, D-46, D-48, D-51, D-52 (pending) |
| `schemas/common.schema.json` | Shared types: `gameId`, topology, cell, level id, colors, instants, display name | D-46, D-47, RN-COM-109 |
| `schemas/level.schema.json` | A level: common part + `variant` section that changes with `gameId` (Fit, Sort) | RN-COM-70 to 77, RN-HF-11, RN-HS-11, D-47 |
| `schemas/progress.schema.json` | Progress per user and `gameId`, one section per topology, two shapes (`highScore`, `levels`) | D-27, D-45, D-49, RN-COM-80 to 90 |
| `schemas/leaderboard.schema.json` | One page of a ranking | RN-COM-100 to 107 |
| `schemas/problem.schema.json` | Error responses (Problem Details, RFC 9457) | D-51 |
| `examples/` | Shared examples. Both repos test their mappers and use cases with them | E-HF-NIVEL, E-COM-2, E-COM-3 |
| `check_contracts.py` | Checks all of the above (see below) | — |

## Checking the contract

```bash
python3 -I docs/contracts/check_contracts.py   # needs jsonschema >= 4.18 and PyYAML
```

The script checks that:
1. every schema is valid JSON Schema 2020-12;
2. every example validates, and a list of broken variants is rejected (wrong section for the `gameId`, `any` with initial stacks, a 4-star result, an instant outside UTC, an email in the ranking, a problem with a `stack` member…);
3. the level examples pass the rules a schema cannot express (RN-HF-12 a–g on hexagons, RN-HS-12);
4. E-COM-2 consolidates to the expected result in any order, when repeated and when only the changed level is sent (RN-COM-83, 84; D-49);
5. E-COM-3 ranks follow RN-COM-102, 103 and 105;
6. in every problem example, `code` equals the end of `type`;
7. in `openapi.yaml`, every `$ref` resolves, every route except `/health` starts with `/v1`, every error is `application/problem+json`, every 401 has `WWW-Authenticate`, every 429 has `Retry-After`, and every example file validates.

A real OpenAPI linter (Redocly or Spectral) runs in the API's CI once the project is scaffolded.

## Naming

- Example files: `<name>.<kind>.json`, where `<kind>` is `level`, `progress`, `progress-update`, `leaderboard` or `problem`.
- `https://hexablock-api.example` is a reserved example domain (RFC 2606). It is replaced by the real domain of the API when it exists; the app does not depend on it, because it reads `code`, not `type`.
