---
paths:
  - "app/assets/levels/**"
  - "tools/reference-sim/**"
---

# Niveles

- Los 25 niveles de `app/assets/levels/` los propuso `tools/reference-sim/levelgen.py` y los revisa el equipo (D-53, P-14). Siguen D-54 (dificultad creciente), D-55 y D-28 (reparto por figura).
- Un cambio a un nivel se valida con `python3 -I tools/reference-sim/levelcheck.py`, que también regenera `docs/levels/CATALOGO.md`; el CI falla si el catálogo quedó viejo.
- El formato es el de `docs/contracts/schemas/level.schema.json`. Los ejemplos del contrato que coinciden con niveles reales deben seguir iguales.
- No borres niveles publicados: el servidor no los borra (D-48).
