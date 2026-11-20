---
paths:
  - "packages/hexa_variants/**"
---

# Variantes (capa 1)

- **Una carpeta por variante** (`lib/src/hexa_lines/`, …) con su `VariantFamily` (Abstract Factory), sus reglas, su estado, sus movimientos y su fuente de piezas (ARQ-02 §4.2).
- **Las reglas extienden `GameRules`** y solo implementan `apply`, `resolve`, `afterResolve` y `evaluate`. **Nunca sobrescriben `playTurn`** (D-36): lo comprueba una prueba de arquitectura.
- **Las variantes son genéricas en `C`**: no usan `HexCoord` ni ninguna figura concreta; la figura la elige el jugador (D-25).
- **La fuente de verdad son las reglas** de `docs/requirements/02-RN-HEXA-*.md` y `02-RN-COMUNES.md`. Si una regla es ambigua o falta, no la inventes: pregunta y propone opciones.
- **Cada ejemplo `E-*`** de esas reglas es una prueba con el ID en el `group`. Los ejemplos ya se verificaron con `tools/reference-sim/`: si la prueba falla, el error está en el código.
- Las capacidades opcionales (`IUndoable`, `ITimed`, `IRandomSeeded`, `ILevelBased`) se componen en la fábrica; no se agregan a variantes que no las tienen (Lines no se deshace, RN-COM-60).
