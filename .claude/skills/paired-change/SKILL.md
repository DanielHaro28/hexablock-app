---
name: paired-change
description: Change a document shared with hexablock-api, or the API contract, in both repositories with two paired pull requests.
argument-hint: "[file or topic]"
disable-model-invocation: true
---

Cambio en un documento compartido o en el contrato: **$ARGUMENTS**.

Documentos compartidos (deben quedar idénticos en los dos repos): `docs/adr/ADR-001-tech-stack.md`, `docs/architecture/ARQ-00-SISTEMA.md`, `docs/security/SECURITY-BASELINE.md`, `docs/requirements/01-GLOSARIO.md`, `02-RN-NIVELES.md`, `02-RN-CUENTA-PROGRESO-RANKING.md` y `docs/ai/APPROVED-TOOLS.md`. El contrato `docs/contracts/` tiene su **fuente en `hexablock-api`**; aquí hay una copia que no se edita a mano (D-23).

1. Comprueba que el clon de `hexablock-api` esté al lado de este repo (`../hexablock-api`) y actualizado (`git -C ../hexablock-api pull`). Si no está, pide al usuario que lo clone.
2. Usa **el mismo nombre de rama** en los dos repos (`docs/<tema>`): el CI de documentos compara contra la rama de igual nombre del otro repo (D-72).
3. Haz el cambio:
   - **Documento compartido:** edítalo aquí y copia el archivo al otro repo con un comando (`cp`), para que queden byte a byte iguales.
   - **Contrato:** edítalo en `../hexablock-api/docs/contracts/`, corre ahí `python3 -I docs/contracts/check_contracts.py` y después copia la carpeta completa a este repo con `cp -r`. El hook de este repo bloquea la edición directa de la copia.
4. Verifica con `python3 -I tools/docs-check/check_shared.py . ../hexablock-api`.
5. Si el cambio toca una decisión, una regla o un ejemplo, actualiza `DECISIONES.md`, la trazabilidad o el ejemplo en los dos repos donde aplique.
6. Un commit por repo con el mismo mensaje, y dos PR que se enlacen entre sí ("Paired with DanielHaro28/hexablock-api#<n>"). Se integran los dos, uno tras otro.
