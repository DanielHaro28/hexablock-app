---
name: ai-usage
description: Add the AI_USAGE.md entry for the work done with AI in the current branch, as the assignment requires (§7.2).
disable-model-invocation: true
---

Agrega la entrada de esta rama a `AI_USAGE.md` (enunciado §7.2, RNF-62). El profesor lee este registro como evidencia de cómo se usó la IA: vale por lo que dice que el equipo revisó y cambió, y pierde valor si repite un ID o si deja campos sin completar.

## 1. El siguiente ID libre

Los IDs no se reutilizan (CLAUDE.md, regla 6). Cada integrante agrega entradas en su propia rama, así que el último `IA-*` de `main`, o el de la rama actual, casi nunca es el último usado. No lo busques a mano: usa el script, que revisa todas las ramas locales y remotas de los dos repos y los archivos sin commit.

```bash
git fetch --quiet && git -C ../hexablock-api fetch --quiet
python3 -I tools/docs-check/next_id.py IA . ../hexablock-api
```

Imprime el ID libre (`IA-` y el número) y, en la salida de error, dónde encontró el mayor. Si el `fetch` falla (sin red, sin el clon de al lado), avisa al usuario: puede faltar una rama de otro integrante.

## 2. Qué se hizo

Reúne el trabajo de la rama con `git log main..HEAD --oneline`, `git diff main...HEAD --stat` y lo que se habló en la conversación: los pedidos del usuario, lo que propuso la IA y lo que el usuario corrigió.

## 3. La entrada

Copia la plantilla de §6 al final de la sección 3, justo antes de `## 4. Evaluación crítica`, y complétala:

- **Herramienta:** Claude Code y el modelo exacto de esta sesión.
- **Prompt:** el pedido del usuario **literal**, o una paráfrasis fiel si es muy largo o son varios mensajes. Nunca copies secretos, tokens ni datos reales: si los hubo, escribe "[omitido: dato sensible]" y avisa al usuario (SEC-AGT-09).
- **Resultado:** qué archivos, pruebas o documentos produjo, con el número del Issue (suele estar en la rama o en el Issue que se implementó; si no, `gh issue list --search "<ID> in:title"`). El PR todavía no existe cuando se corre esta skill (en `/implement-story` va antes del push), así que no lo pidas ni lo dejes pendiente. Si el trabajo no tiene Issue (una decisión, un cambio de documentos), escríbelo así en el campo.
- **Modificaciones del equipo:** lo que el usuario cambió, rechazó o eligió entre opciones, y por qué. Si no salió en la conversación, pregúntaselo; si todavía no lo sabe (por ejemplo, falta la revisión de las pruebas, D-59), deja `⚠️ completar` y dilo.
- **Lecciones:** errores de la IA que se detectaron y cómo, o límites encontrados.

Marca el título con `— solo app` o `— compartido`. Es compartida si el trabajo tocó también `hexablock-api` (un documento compartido, el contrato, una decisión de los dos repos): entonces la **misma entrada, con el mismo ID**, va en el `AI_USAGE.md` de `../hexablock-api`, en su rama del mismo nombre.

**No cites IDs que todavía no estén en `main`** (un `D-*`, `IA-*` o `RN-*` que solo existe en otra rama sin integrar): `check_ids.py` los marca como no definidos y el CI falla. Descríbelos sin el ID ("la decisión de la rama de TEC-01").

## 4. Las otras secciones

- **§4.2 Resultados incorrectos o mejorables:** si la IA se equivocó en algo que se detectó y corrigió, agrega una fila (problema, cómo se detectó, corrección). Es la evidencia de la revisión crítica que pide el enunciado §7.3.
- **§5 Fuentes de algoritmos y referencias:** si en esta rama la IA propuso o implementó un algoritmo, una fórmula o una referencia externa que no está en la tabla, agrégalo con su fuente (autor, título, año o URL). El enunciado pide citar de dónde sale.

Esta skill **solo cambia `AI_USAGE.md`**: es el registro de lo que se hizo, no una revisión del código. Si notas algo que falta en el código, por ejemplo que la clase que implementa el algoritmo no cita la misma fuente en su comentario (§7.3), díselo al usuario en el mensaje final y no lo arregles aquí; ese cambio va en un commit del trabajo, con su revisión.

## 5. Revisar y hacer commit

1. Corre `python3 -I tools/docs-check/check_ids.py . ../hexablock-api` y `check_tables.py` con los mismos argumentos. Si falla por un ID de otra rama, reescribe esa parte sin el ID.
2. Busca los `⚠️ completar` que queden en el archivo (`grep -n "⚠️" AI_USAGE.md`) y muéstrale al usuario los de sus entradas: hay que completarlos antes de la entrega.
3. Commit en cada repo donde agregaste la entrada: `docs(ai-usage): add IA-<n>`.
