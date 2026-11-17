# Simulador de referencia

Scripts en Python que se usaron para **verificar los ejemplos** de las reglas de negocio (`docs/requirements/02-RN-*.md`) antes de escribirlos. No son parte de la app ni se ejecutan en CI: sirven como referencia independiente al implementar las pruebas en Dart.

| Archivo | Qué cubre |
|---|---|
| `hexsim.py` | Topología hexagonal (axial *pointy-top*), dibujo ASCII, Hexa Lines (colocar y borrar líneas), Hexa Sort (cascada con desempate horario y metas), Hexa Merge (deslizar y fusionar) y el generador xorshift32 |
| `trisim.py` | Topología de triángulos: índices de línea, vecinas, giro de 60° y tablero hexágono de lado n |

Uso: `python3 trisim.py` imprime una verificación rápida. `hexsim.py` se usa como módulo (`from hexsim import *`).

Si se cambia una regla, conviene actualizar el simulador, volver a correr el ejemplo afectado y recién después actualizar el documento y la prueba. Su uso queda registrado en `AI_USAGE.md` (lo generó un asistente de IA durante la planificación).
