---
tags: [skill-creator]
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

Corre /ai-usage. Trabajas en `./hexablock-app`; el clon de la API está al lado, en `./hexablock-api`. Contexto: pedí literalmente "implementa la mezcla de los colores de Hexa Sort". La IA propuso e implementó el algoritmo de Fisher–Yates, en la versión de Durstenfeld, en `shuffle.dart`. La primera versión tenía un error de uno: el índice aleatorio podía llegar a i + 1. Lo detecté porque una prueba con semilla fija daba un índice fuera de rango, y la IA lo corrigió. Además, la IA quiso aplicar la decisión D-04 sobre las semillas, pero D-04 solo existe en la rama `feat/tec-05-seeds`, que todavía no está integrada, así que acordamos no depender de ella. El modelo de esta sesión es Claude Opus 5.5 (`claude-opus-5-5`).
