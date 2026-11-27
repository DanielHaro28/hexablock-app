# PENDIENTES — HexaBlock Suite

> Decisiones abiertas del proyecto y preguntas al profesor. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí.
>
> - Las decisiones **cerradas** están en `docs/DECISIONES.md` de cada repo. Al cerrar una, se pasa allí con su fecha y se borra de aquí.
> - Las **tareas** no están aquí: son Issues de los dos repos, en el tablero [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) (D-69). El plan y la hoja de ruta están en `docs/plan/PLAN-ENTREGA.md`.
>
> **Última actualización:** 2026-11-27 (D-167 abierta: salió de la revisión de arquitectura de #164; D-168, abierta y descartada; D-169 cerrada: las horas reales son opcionales y salen del CI) · 2026-11-26 (D-121, D-122, D-125, D-128, D-130, D-145, D-147, D-150 y D-164 cerradas; D-165 y D-166, nuevas y cerradas, en la revisión de los pendientes; D-20 sigue abierta con la propuesta corregida) · 2026-11-26 (D-164 abierta: errores de producción, TEC-03) · 2026-11-25 (D-144, D-146, D-148, D-149 y D-151 a D-153 cerradas: interfaz de NAV-01; D-150 abierta) · 2026-11-25 (D-144 a D-147 abiertas: sistema de diseño y prototipo, REVISION-DISENO §6) · 2026-11-24 (D-140 y D-143 cerradas en HL-06; antes, D-140 abierta y D-78 cerrada: reparto completo) · 2026-11-23 (D-117 a D-120 cerradas; D-121 y D-122 abiertas; D-124 y D-129 cerradas; D-125 y D-130 abiertas; D-128 abierta) · 2026-11-22 (D-78: Hexa Lines asignada; D-102 a D-107, D-109 y D-110 a D-116 cerradas) · 2026-11-21 (D-97 a D-101 cerradas; D-93 a D-96 cerradas; D-90 a D-92 cerradas) · 2026-11-20 (D-03 cerrada; paso 8: D-79 a D-88 cerradas; D-77 cerrada y D-78 abierta; ARQ-S-02 y ARQ-S-03 confirmadas; D-02 y D-67 a D-75 cerradas; tareas pasadas a los Issues) · **Entrega:** lunes 14-12-2026

---

## 1. Decisiones abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados, triángulos y cubos. **20-11:** se deja para TEC-07 (topologías adicionales, solo si sobra tiempo); no bloquea nada antes. **26-11:** sigue abierta hasta TEC-07, pero la propuesta de cuadrados (RN-TOP-21) se corrigió a 8 familias con pesos que suman 100: la de 9 familias no cumplía D-131 (un color por familia, y hay 8 pasteles) ni RN-HL-24 (pesos sobre 100). Sale la T de 4. Triángulos y cubos se definen al implementar su topología | Equipo | Al empezar TEC-07 | RN-TOP-21 a 23 |
| ☐ D-167 | **Qué recibe el jugador si el nivel que eligió ya no está al empezar la partida.** Hoy la fábrica de Fit o de Sort lanza un `ArgumentError` (D-125) y `ExceptionAspect` lo convierte en `UnexpectedFailure`, que se registra como error de programación (D-161). Pero el servidor puede retirar o cambiar un nivel entre que la pantalla muestra la lista y el jugador empieza (LVL-02, RN-COM-115), y eso no es un error de programación. **Opciones:** A, dejarlo así (la pantalla muestra el texto genérico); B, que `StartGameUseCase` compruebe el nivel con `ILevelRepository` antes de llamar a la fábrica y devuelva un `RuleFailure` con su código, y la pantalla diga que el nivel ya no está y vuelva a la lista (el `ArgumentError` queda para los errores de verdad); C, una excepción del motor para un nivel desconocido que `ExceptionAspect` traduzca (el motor sumaría un tipo de error solo para esto). **Recomendación:** B. Salió de la revisión de arquitectura de #164 (27-11) | @DanielHaro28 y @dicpc | Antes de HF-01 (#38) y HS-01 (#44) | D-125, D-161; revisión de #164 |

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
