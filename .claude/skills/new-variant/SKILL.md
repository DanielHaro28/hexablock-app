---
name: new-variant
description: Add a fifth game variant following docs/EXTENSIBILITY.md, and prove that the engine and the use cases were not modified.
argument-hint: "[variant name, e.g. hexa-fill]"
disable-model-invocation: true
---

Nueva variante: **$ARGUMENTS**. La guía es `docs/EXTENSIBILITY.md`; síguela paso a paso y en orden.

1. **Reglas primero** (paso 1 de la guía): si no existe `docs/requirements/02-RN-<VARIANTE>.md`, redáctalo con el usuario y verifica sus ejemplos con `tools/reference-sim/`. No inventes reglas: pregunta.
2. **Dominio** (paso 2): una carpeta nueva en `packages/hexa_variants/lib/src/`, con su `VariantFamily`, sus reglas (que extienden `GameRules` sin sobrescribir `playTurn`), estado, movimientos y fuente de piezas.
3. **Configuración, adaptadores y frameworks** (pasos 3 a 5): registro de la variante, codec, módulo y pintor de celdas.
4. **Pruebas** (paso 7): una por ejemplo `E-*` de las reglas nuevas.
5. **Comprobación final**: `git diff main...HEAD --stat -- packages/hexa_engine packages/hexa_application` **tiene que salir vacío**. Muéstraselo al usuario: es la prueba de extensibilidad de la defensa (RNF-03, F-09).
6. `architecture-reviewer`, `/ai-usage` y PR.
