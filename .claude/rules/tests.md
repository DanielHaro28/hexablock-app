---
paths:
  - "**/test/**"
  - "packages/hexa_test_support/**"
---

# Pruebas

Estrategia completa: `docs/testing/ESTRATEGIA-PRUEBAS.md`.

- **Nombre** `should_<resultado>_when_<condición>`, en inglés; bloques `// Arrange`, `// Act`, `// Assert`; un comportamiento por prueba (§5).
- **El `group` lleva el ID** del ejemplo o la regla (`group('E-HS-3', …)`). El CI falla si un `E-*` de los documentos no tiene prueba (§6).
- **Dobles** (D-56): *fakes* y *stubs* escritos a mano en `packages/hexa_test_support`. `mocktail` solo para comprobar que algo se llamó o no se llamó, nunca para devolver datos.
- **Sin azar ni esperas reales**: semilla fija y `FakeClock`. Una prueba intermitente se arregla o se borra.
- **Drift en pruebas**: `NativeDatabase.memory()` (D-57).
- **Cobertura mínima** (D-58): 90 % en el dominio, 80 % en los casos de uso, 70 % en total.
- Si escribiste las pruebas, dilo en el PR para que una persona las revise (D-59).
