# Simulador de referencia

Scripts en Python que se usaron para **verificar los ejemplos** de las reglas de negocio (`docs/requirements/02-RN-*.md`) antes de escribirlos. No son parte de la app: sirven como referencia independiente al implementar las pruebas en Dart. `levelcheck.py` y la verificación de los ejemplos (`tools/docs-check/check_examples.py`) corren en el CI de documentos (D-72).

| Archivo | Qué cubre |
|---|---|
| `hexsim.py` | Topología hexagonal (axial *pointy-top*), dibujo ASCII, Hexa Lines (colocar y borrar líneas), Hexa Sort (cascada con desempate horario y metas), Hexa Merge (deslizar y fusionar) y el generador xorshift32 |
| `trisim.py` | Topología de triángulos: índices de línea, vecinas, giro de 60° y tablero hexágono de lado n |
| `engine_model.py` | Modelo del historial de deshacer y de las fases propuestos en `ARQ-02-MOTOR.md` (§5, §8), comprobado contra E-HF-3, E-HM-7 y RN-COM-21, 24 y 60 a 63. Uso: `python3 engine_model.py` |
| `levelkit.py` | Herramientas del Paso 6 para niveles en hexágonos. **Hexa Fit:** cuenta todas las soluciones de un nivel (las 6 rotaciones de cada pieza), comprueba que la solución de referencia sea una de ellas e informa el esfuerzo de búsqueda; con E-HF-NIVEL encuentra las 2 soluciones ya documentadas. **Hexa Sort:** juega el nivel con su semilla fija, con un jugador voraz y con una búsqueda en haz de 30, e informa si se puede ganar y en cuántos movimientos. Usa RN-HS-21 con la precisión propuesta en D-60. Uso: `python3 -I levelkit.py fit\|sort <nivel.json>…` |
| `levelgen.py` | **Generador de niveles** (D-53, herramienta de autor; no es parte de la app). Propone los 15 niveles de Fit y los 10 de Sort siguiendo D-54, D-55 y D-28, de forma reproducible (semilla maestra 2026). En Fit pega piezas para armar la figura y descarta las que no cumplen su tramo; en Sort busca semillas que el jugador voraz gane. Escribe en `app/assets/levels/` y deja el informe en `docs/levels/generation-report.json`. Uso: `python3 -I tools/reference-sim/levelgen.py app/assets/levels` |
| `levelcheck.py` | **Verificador de los niveles incluidos:** esquema, reglas (RN-HF-12, RN-HS-12), solución, dificultad creciente, reparto por figura (D-28), igualdad con los ejemplos del contrato y estrellas posibles en E-COM-2 y E-COM-3. Escribe `docs/levels/CATALOGO.md`. Uso: `python3 -I tools/reference-sim/levelcheck.py`. Probado con 5 roturas a propósito |

Uso: `python3 trisim.py` imprime una verificación rápida. `hexsim.py` se usa como módulo (`from hexsim import *`).

Si se cambia una regla, conviene actualizar el simulador, volver a correr el ejemplo afectado y recién después actualizar el documento y la prueba. Su uso queda registrado en `AI_USAGE.md` (lo generó un asistente de IA durante la planificación).
