---
name: defense-rehearsal
description: Rehearse the project defence - a jury-style rule change timed in a throwaway worktree, plus architecture questions checked against the docs.
argument-hint: "[rounds, e.g. 3]"
disable-model-invocation: true
---

Ensayo de la defensa, **$ARGUMENTS** rondas (3 si no se indica). En la defensa el jurado puede pedir un cambio de regla o de configuración en vivo y preguntar por el diseño (enunciado §3.1). Lo que se evalúa es que el equipo sepa **dónde** va el cambio y que quede confinado a clases nuevas o a configuración (RNF-03). Por eso, en el ensayo **la persona hace el trabajo**; tú haces de jurado: pides, mides el tiempo, preguntas y compruebas. Si te pide que lo hagas tú para ver el camino, hazlo, pero dilo en el informe.

## 1. Preparar

Crea un *worktree* desechable desde `main`, fuera del repo, para que nada del ensayo llegue a una rama real:

```bash
git fetch --quiet
git worktree add ../hexablock-rehearsal -b rehearsal/$(date +%Y%m%d-%H%M) origin/main
```

Revisa qué variantes ya tienen código en `packages/hexa_variants/lib/src/`: solo se ensaya sobre lo que existe.

## 2. Cada ronda

1. **El pedido.** Elige al azar una fila de `docs/EXTENSIBILITY.md` §3 (otro tamaño de tablero, otra puntuación, una pieza nueva, una restricción de regla, otra meta) y una variante que exista. Pídelo como lo haría el jurado, con un caso concreto ("en Hexa Lines, que cada línea valga el doble"), y anota la hora (`date +%s`).
2. **Antes de escribir código**, pídele que diga qué clases cambian y por qué ninguna es del motor. Compara su respuesta con la tabla de §3 y con D-96, D-98, D-100 y D-101.
3. **El cambio**, en el *worktree*, con `/rule-change` si quiere. No lo apures ni le des la respuesta.
4. **La comprobación**, con la salida a la vista:
   - `git diff --stat` en el *worktree*: nada en `packages/hexa_engine` ni en `packages/hexa_application`, y en archivos existentes solo la línea de registro o de configuración.
   - Las pruebas del paquete que cambió y `dart run tool/check_architecture.dart`.
5. **Tres preguntas de diseño** relacionadas con lo que se cambió. Por ejemplo: por qué ninguna variante sobrescribe `playTurn` (D-36), qué significan `C`, `TCell`, `TMove` y `TState` (ARQ-02 §4), cómo se agrega una figura sin `switch` (D-29, EXTENSIBILITY §4), dónde se calculan los puntos (D-98), por qué ningún caso de uso registra en el log (RNF-10) o qué ve la pantalla cuando una jugada falla (D-39). Escucha la respuesta entera y después compárala con el documento, citando la sección.

Entre ronda y ronda, `git -C ../hexablock-rehearsal checkout -- . && git -C ../hexablock-rehearsal clean -fd`.

## 3. Informe y limpieza

Muestra una tabla por ronda: el pedido, el tiempo, si el cambio quedó confinado, y qué preguntas se respondieron bien, a medias o mal, con la sección del documento que conviene repasar para cada una. Termina con los dos o tres temas más débiles.

Borra el *worktree* y su rama: `git worktree remove ../hexablock-rehearsal` y `git branch -D rehearsal/...`. El ensayo no deja commits ni archivos en el repo.
