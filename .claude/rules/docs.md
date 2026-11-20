---
paths:
  - "docs/**"
  - "*.md"
---

# Documentos

- Se escriben en **español**; `README.md` en inglés (enunciado §6.1).
- **IDs:** nunca se reutilizan ni se renumeran. Una regla o decisión nueva toma el siguiente libre.
- **`docs/DECISIONES.md` es el único registro de decisiones** y se edita a mano (D-67, D-72). Las abiertas van a `docs/PENDIENTES.md` con recomendación; las tareas, a Issues (D-69).
- **Documentos compartidos** (lista en `docs/README.md`) y **`docs/contracts/`**: idénticos en los dos repos. Se cambian con `/paired-change`, con dos PR y el mismo nombre de rama. La copia del contrato de este repo **no se edita a mano** (D-23).
- **Ejemplos de reglas:** antes de escribir o cambiar un `E-*`, verifícalo con `tools/reference-sim/`.
- **Binarios:** nada de más de 1 MB (D-73). Los diagramas se exportan desde su fuente (`docs/diagrams/`).
- Antes de abrir el PR corre los scripts de `tools/docs-check/` (los mismos que el CI).
