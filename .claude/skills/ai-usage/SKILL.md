---
name: ai-usage
description: Add the AI_USAGE.md entry for the work done with AI in the current branch, as the assignment requires (§7.2).
disable-model-invocation: true
---

Agrega la entrada de esta rama a `AI_USAGE.md` (enunciado §7.2, RNF-62).

1. Lee la plantilla de `AI_USAGE.md` §6 y el último ID `IA-*` de la sección 3. La entrada nueva usa el siguiente libre: **los IDs no se reutilizan**.
2. Reúne lo que hiciste en esta rama: `git log main..HEAD --oneline` y `git diff main...HEAD --stat`.
3. Completa la entrada:
   - **Herramienta:** Claude Code y el modelo exacto de esta sesión.
   - **Prompt:** el pedido del usuario **literal** (o una paráfrasis fiel si es muy largo). Nunca copies secretos, tokens ni datos reales: si los hubo, escribe "[omitido: dato sensible]" y avisa al usuario (SEC-AGT-09).
   - **Resultado:** qué archivos, pruebas o documentos produjo, con el número del Issue.
   - **Modificaciones del equipo:** pregúntale al usuario qué cambió del resultado y por qué. Si todavía no lo sabe, deja `⚠️ completar`.
   - **Lecciones:** errores de la IA que se detectaron y cómo, o límites encontrados.
4. Marca la entrada como `— solo app` o `— compartido`. Si es compartida, la misma entrada va en el `AI_USAGE.md` de `hexablock-api`, con el mismo ID: avisa al usuario.
5. Si la IA se equivocó en algo que se detectó y corrigió, agrega también una fila en §4.2 ("Resultados incorrectos o mejorables").
6. Haz commit: `docs(ai-usage): add IA-<n>`.
