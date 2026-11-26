# Herramientas de IA y servidores MCP aprobados

| Campo | Valor |
|---|---|
| Estado | Aprobado por el equipo (D-86, D-87, 20-11-2026; D-126, 23-11-2026; D-159, 25-11-2026) |
| Repositorio | **Compartido:** `docs/ai/` en los dos repos; las dos copias deben ser idénticas |
| Control | SEC-AGT-04 (cadena de suministro agéntica) |

Solo se usan las herramientas de esta lista. Para agregar otra, se abre un PR que la añade aquí con la razón, y lo aprueba el equipo (`CODEOWNERS` pide la revisión).

## Herramientas de agente

| Herramienta | Uso | Configuración |
|---|---|---|
| **Claude Code** | Herramienta de agente principal del proyecto y la única con configuración en los repos (D-87, D-159) | `CLAUDE.md`, `.claude/settings.json`, `.claude/rules/`, `.claude/agents/`, `.claude/skills/` y `.claude/hooks/` en cada repo |
| **Antigravity** (Google), con modelos Gemini | Segunda herramienta de agente, con condiciones (D-159) | Ninguna en los repos. No lee `.claude/`, así que sus permisos y *hooks* no la protegen: (1) al empezar, se le da `CLAUDE.md` y las reglas de `.claude/rules/` que apliquen como instrucciones; (2) no se le abren `.env*`, claves, *keystores*, `~/.ssh` ni `~/.aws`, ni se usa un modo que omita las confirmaciones (SEC-AGT-02, SEC-AGT-03); (3) antes de abrir el PR, el cambio pasa por los subagentes `architecture-reviewer` y `security-reviewer` de Claude Code cuando su descripción lo pide; (4) `AI_USAGE.md` registra la herramienta y el modelo. Los *hooks* de git (lefthook) y el CI aplican igual |
| **GitHub CLI (`gh`)** | Issues y PR desde la terminal, en lugar de un servidor MCP de GitHub | Cuenta de cada integrante |

## Servidores MCP

| Servidor | Repo | Por qué | Cómo se configura | Riesgo y control |
|---|---|---|---|---|
| **Dart y Flutter MCP** (`dart mcp-server`, del equipo de Dart) | `hexablock-app` | Da a Claude los errores del analizador, la resolución de símbolos y el corredor de pruebas de Dart | `.mcp.json` en la raíz del repo; Claude Code pide aprobarlo la primera vez | Corre en la computadora, sin conexión a internet. Es experimental y necesita Dart 3.9 o posterior. Un cambio a `.mcp.json` pasa por revisión (SEC-AGT-05) |

En `hexablock-api` no hay servidores MCP. Se descartaron el de GitHub (la CLI `gh` alcanza, y leer Issues de externos es el riesgo SEC-AGT-01) y el de Prisma (sirve para la base en la nube de Prisma; la API usa PostgreSQL propio).

## Skills de terceros

Solo las oficiales del equipo de Flutter (`github.com/flutter/agent-plugins`) y del equipo de Dart (`github.com/dart-lang/skills`), y únicamente las que no choquen con las decisiones del proyecto (D-88). Para cada una:

1. Se leen las instrucciones, los scripts y el campo `allowed-tools` (pre-aprueba comandos sin preguntar, y la confianza en la carpeta no lo limita).
2. Se descarta si empuja patrones que contradicen lo decidido (por ejemplo, dependencias en las capas 1 y 2 o generación de código donde no se usa).
3. Se copia a `.claude/skills/` de la app **en una versión fija** (commit del repo de origen) y se agrega a la tabla de abajo, con un PR.

Nunca se instala el plugin completo ni skills de autores desconocidos.

| Skill | Origen y versión | Por qué |
|---|---|---|
| `dart-run-static-analysis` | `dart-lang/skills` @ `f84b168` | `dart analyze` y `dart fix`, lo mismo que corre el CI |
| `dart-fix-runtime-errors` | `dart-lang/skills` @ `f84b168` | Ubica y corrige un error en ejecución con el MCP de Dart (ya aprobado) |
| `dart-use-pattern-matching` | `dart-lang/skills` @ `f84b168` | Patrones y `switch` exhaustivos de Dart 3, útiles en las reglas y los mappers |
| `dart-use-primary-constructors` | `dart-lang/skills` @ `f84b168` | Constructores primarios (Dart 3.13 o posterior; el proyecto usa 3.14) |
| `dart-write-documentation` | `dart-lang/skills` @ `f84b168` | Comentarios `///` en inglés, como pide el proyecto |
| `flutter-add-widget-test` | `flutter/agent-plugins` @ `ff6d472` | Pruebas de *widget* con `WidgetTester`. El nombre `should_<resultado>_when_<condición>` y AAA siguen mandando (`.claude/rules/tests.md`) |
| `flutter-fix-layout-issues` | `flutter/agent-plugins` @ `ff6d472` | Corrige desbordes y restricciones sin límite con el MCP de Dart |
| `flutter-build-responsive-layout` | `flutter/agent-plugins` @ `ff6d472` | `LayoutBuilder` y `MediaQuery` para que el tablero se adapte a la pantalla |

Cada carpeta lleva el `LICENSE` (BSD-3) de su repo de origen. Para actualizar una skill se repite la revisión y se cambia el commit en la tabla.

**Descartadas en la revisión de T-03** (20-11-2026):

| Skill | Por qué no |
|---|---|
| `dart-add-unit-test`, `dart-generate-test-mocks` | Generan *mocks* con `mockito` y `build_runner`; el proyecto usa dobles a mano y `mocktail` solo para verificar llamadas (D-56) |
| `dart-collect-coverage` | Usa el paquete `coverage`; la cobertura sale de `flutter test --coverage` y `tool/coverage_gate.dart` (D-58) |
| `dart-migrate-to-checks-package` | Agrega `package:checks`; las capas 1 y 2 solo admiten `test` (D-21) |
| `flutter-apply-architecture-best-practices` | Propone otra arquitectura (UI, lógica y datos con `ChangeNotifier`); el proyecto usa cuatro capas y Cubits (ARQ-01-APP) |
| `flutter-use-http-package` | Usa `http`; la app usa dio (ARQ-01-APP §4.4) |
| `flutter-implement-json-serialization` | Pone `fromJson` y `toJson` en las clases del modelo; aquí la serialización vive en los mappers y códecs de la capa 3 (ARQ-03-APP) |
| `flutter-setup-declarative-routing` | Agrega `go_router`, que no está decidido; la navegación la define quien haga la interfaz |
| `flutter-add-integration-test` | Flutter Driver; las pruebas en emulador se corren a mano y no en CI (estrategia de pruebas §10) |
| `flutter-setup-localization` | Se usa una sola vez; esa configuración entra con la historia de textos en es y en |
| `flutter-add-widget-preview`, `dart-build-cli-app`, `dart-setup-ffi-assets`, `dart-use-ffigen`, `dart-use-path-package`, `dart-use-doc-examples`, `dart-resolve-package-conflicts` | No aplican: el proyecto no tiene CLI, código nativo ni dependencias en el dominio |

## Ayudas para crear skills

Herramientas que ayudan a escribir y evaluar las skills del proyecto, pero que **no se copian al repo** (D-126). Al repo entra la skill que producen, con un PR revisado como cualquier otro cambio a `.claude/` (SEC-AGT-05).

| Herramienta | Origen | Para qué | Riesgo y control |
|---|---|---|---|
| `skill-creator` | Anthropic; viene con la cuenta de Claude de cada integrante (`anthropic-skills:skill-creator`) | Redactar una skill y medirla con evaluaciones: corre los casos con y sin la skill en subagentes y compara los resultados | Los casos de prueba no llevan secretos ni datos reales (SEC-AGT-09). Los casos de prueba van en `evals/` dentro de cada skill, en el repo, para que se repitan igual; los resultados de cada corrida quedan fuera de los dos repos (`../skill-evals/`) y, si sirven de evidencia, se resumen en el PR o en `AI_USAGE.md` |
