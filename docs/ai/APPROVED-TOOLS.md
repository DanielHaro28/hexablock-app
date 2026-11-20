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

Ninguna por ahora. Las únicas que se pueden evaluar son las oficiales de Flutter y Dart (D-88, pendiente en `hexablock-app/docs/PENDIENTES.md`). Nunca se instalan skills de autores desconocidos: una skill puede traer scripts y pre-aprobar sus propios comandos.
