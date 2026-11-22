# PENDIENTES — HexaBlock Suite

> Decisiones abiertas del proyecto y preguntas al profesor. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí.
>
> - Las decisiones **cerradas** están en `docs/DECISIONES.md` de cada repo. Al cerrar una, se pasa allí con su fecha y se borra de aquí.
> - Las **tareas** no están aquí: son Issues de los dos repos, en el tablero [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) (D-69). El plan y la hoja de ruta están en `docs/plan/PLAN-ENTREGA.md`.
>
> **Última actualización:** 2026-11-21 (D-97 a D-99 cerradas; D-100 y D-101 abiertas; D-93 a D-96 cerradas; D-90 a D-92 cerradas) · 2026-11-20 (D-03 cerrada; paso 8: D-79 a D-88 cerradas; D-77 cerrada y D-78 abierta; ARQ-S-02 y ARQ-S-03 confirmadas; D-02 y D-67 a D-75 cerradas; tareas pasadas a los Issues) · **Entrega:** lunes 14-12-2026

---

## 1. Decisiones abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-100 | **Qué expone `VariantFamily` de sus estrategias.** Con D-98, `createScoring()` devolvería `IScoringPolicy<TState, TEvent>`, pero `VariantFamily<C, TCell, TMove, TState, TPiece>` no tiene `TEvent`; con D-97, `createPieceSource` ya no recibe la semilla y Hexa Fit no tiene fuente. Opciones: **A.** sacar `createScoring` y `createPieceSource` de la interfaz: son colaboradores que la fábrica concreta conecta en sus reglas y nadie fuera de ella los pide (la interfaz queda con `createRules` y `createSession`, y `EXTENSIBILITY.md` sigue diciendo "una línea en `createScoring()`" de la fábrica concreta); **B.** agregar un 6.º genérico `TEvent` a `VariantFamily` y dejar `createPieceSource` opcional (Fit devolvería `null`). **Recomendación: A** (ISP: la interfaz solo tiene lo que usa el *composition root*, y no crece en genéricos) | Equipo | Al escribir `VariantFamily` (primera variante) | D-97, D-98 |
| ☐ D-101 | **Redondeo de la puntuación cuando un multiplicador abarca varios pasos (RN-COM-51, D-98).** Con D-98 la política se llama una vez por paso (`apply`, `resolve`…). Si un decorador con fracciones envolviera una política usada en varios pasos, redondearía una vez por paso y no una por turno: con ×1,5, 5 celdas en `apply` y 15 de bono en `resolve` dan ⌊7,5⌋ + ⌊22,5⌋ = 29 en vez de ⌊30⌋ = 30. Hoy no pasa: la única fracción, la racha de Lines, solo multiplica el bono de líneas, que se calcula en un solo paso. Opciones: **A.** regla de diseño: un multiplicador con fracciones envuelve solo la política del paso cuyos eventos multiplica (se documenta en ARQ-02 §9.7 y `EXTENSIBILITY.md` §3); **B.** puntos racionales: la política devuelve un valor con numerador y denominador, las reglas los suman en el turno y redondean una vez en el último paso. **Recomendación: A** mientras no exista un multiplicador del turno completo; si la defensa pide uno (p. ej., ×1,5 a todo), se pasa a B en `hexa_variants` sin tocar el motor | Equipo | Antes del primer decorador de puntuación con fracciones (HL-03, HL-06) | D-98, RN-COM-51 |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos. **20-11:** se deja para TEC-07 (topologías adicionales, solo si sobra tiempo); no bloquea nada antes | Equipo | Al empezar TEC-07 | RN-TOP-21 a 23 |
| ☐ D-78 | **Reparto de la API y el frontend** entre @dicpc y @DavidCR20 (D-77): backend NestJS, las 4 variantes (HL, HF, HS, HM), casos de uso y progreso de la app (TEC-03, PRG, API-05, 06, 08, LVL-01) e interfaz. Son 55 Issues y 265,5 h con milestone, ≈ 137 h por persona. **20-11: la API (backend NestJS, 8 Issues de `hexablock-api`) quedó para @DavidCR20 y la interfaz (14 Issues de la app con `area:ui`) para @dicpc**; falta repartir las variantes, los casos de uso y el progreso. Lo conversa @DanielHaro28 con ellos; después se asignan los Issues "por definir" y se actualizan `PLAN-ENTREGA.md` y `CODEOWNERS` | @DanielHaro28 con el equipo | Antes de M1 (24-11) | D-77 |

## 2. Preguntas para el profesor

El profesor indicó (11-11) que lo que el enunciado no especifica lo decide el equipo. Las respuestas (P-01 a P-14) están en `docs/DECISIONES.md` §2. No hay preguntas abiertas.

## 3. Dónde quedaron las tareas (D-69)

Las listas que había aquí pasaron a Issues el 20-11:

| IDs | Dónde están |
|---|---|
| G-03, G-05 a G-07, G-10, A-02 a A-04, R-01 a R-05 | Issues de `hexablock-app` (en el título llevan el ID) |
| G-08, W-01 a W-06 | Issues de `hexablock-api` |
| G-01 | Issue de `hexablock-app` (aceptar invitaciones y asignar los Issues pendientes) |
| A-01 | Dentro de T-01 (Paso 8) |
| F-01 a F-10 | Lista de verificación de T-07 (antes de la defensa) |
| G-02, G-04, G-09 | Hechas (ver el historial de este archivo) |
