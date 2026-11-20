---
name: rule-change
description: Change a game rule (RN-*) safely, as the jury may ask in the defence: verify with the reference simulator, update docs, example and test, without touching the engine.
argument-hint: "[rule-id, e.g. RN-HS-21] [what changes]"
disable-model-invocation: true
---

Cambio de regla: **$ARGUMENTS** (enunciado §3.1: el cambio debe quedar confinado a clases nuevas o a configuración).

1. Lee la regla y sus ejemplos `E-*` en `docs/requirements/02-RN-*.md`, y las decisiones que la tocan en `docs/DECISIONES.md`. Si el cambio contradice una decisión cerrada, dilo y pregunta antes de seguir.
2. **Antes de tocar código**, verifica el comportamiento nuevo con el simulador (`tools/reference-sim/`): ajusta o agrega la función y recalcula los ejemplos afectados. Corre `python3 -I tools/docs-check/check_examples.py tools/reference-sim`.
3. Explica al usuario **qué clases cambian y por qué ninguna es del motor**: lo normal es una estrategia o un paso de la variante (`apply`, `resolve`, `evaluate`), una política (`IScoringPolicy`, `IPieceSource`) o un valor de configuración. Si hiciera falta tocar `hexa_engine`, detente: es una señal de diseño que el equipo tiene que ver.
4. Actualiza la regla y el ejemplo en el documento (los IDs no cambian; una regla nueva toma el siguiente ID libre), la prueba del `E-*` y la trazabilidad.
5. Pruebas en verde, `architecture-reviewer` y PR con `/ai-usage`.
