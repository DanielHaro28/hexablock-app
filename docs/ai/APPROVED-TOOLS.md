# Herramientas de IA y servidores MCP aprobados

| Campo | Valor |
|---|---|
| Estado | Aprobado por el equipo (D-86, D-87, 20-11-2026) |
| Repositorio | **Compartido:** `docs/ai/` en los dos repos; las dos copias deben ser idénticas |
| Control | SEC-AGT-04 (cadena de suministro agéntica) |

Solo se usan las herramientas de esta lista. Para agregar otra, se abre un PR que la añade aquí con la razón, y lo aprueba el equipo (`CODEOWNERS` pide la revisión).

## Herramientas de agente

| Herramienta | Uso | Configuración |
|---|---|---|
| **Claude Code** | Única herramienta de agente del proyecto (D-87) | `CLAUDE.md`, `.claude/settings.json`, `.claude/rules/`, `.claude/agents/`, `.claude/skills/` y `.claude/hooks/` en cada repo |
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
| _Ninguna todavía: se revisan al empezar T-03_ | | |
