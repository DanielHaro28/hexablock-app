# PENDIENTES — HexaBlock Suite

> Decisiones abiertas del proyecto y preguntas al profesor. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí.
>
> - Las decisiones **cerradas** están en `docs/DECISIONES.md` de cada repo. Al cerrar una, se pasa allí con su fecha y se borra de aquí.
> - Las **tareas** no están aquí: son Issues de los dos repos, en el tablero [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) (D-69). El plan y la hoja de ruta están en `docs/plan/PLAN-ENTREGA.md`.
>
> **Última actualización:** 2026-11-20 (D-02 y D-67 a D-75 cerradas; tareas pasadas a los Issues) · **Entrega:** lunes 14-12-2026

---

## 1. Decisiones abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-03 | Respuesta de `POST /auth/register` cuando el correo ya existe. **Recomendación: A)** mantener **409** con rate limiting (5/min por IP), login genérico y en tiempo constante; aceptarlo como riesgo documentado. B) mensaje genérico + verificación por correo (lo ideal según OWASP, pero requiere enviar correos: fuera de alcance). C) 400 genérico (peor experiencia y no evita del todo la enumeración). SECURITY §3 y API-01 ya describen la opción A como propuesta | Equipo | Reunión | SECURITY §3, OWASP Authentication Cheat Sheet |
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos | Equipo | Al implementar cada topología | RN-TOP-21 a 23 |
| ☐ ARQ-S-02 | **Confirmar:** el servidor **no ejecuta reglas de juego**; solo valida la plausibilidad de los resultados (RN-COM-108). Quedó como propuesta (🟡) en ARQ-00 §6, pero el contrato y SEC-API-06 ya la usan. **Recomendación:** confirmarla | Equipo | 23-11 | ARQ-00 §6 (D-67) |
| ☐ ARQ-S-03 | **Confirmar:** la consolidación del progreso existe **dos veces** (Dart y TypeScript), con los ejemplos compartidos E-COM-2 y E-COM-3 para que den el mismo resultado. Quedó como propuesta (🟡) en ARQ-00 §6, pero D-23 y los contratos ya la usan. **Recomendación:** confirmarla | Equipo | 23-11 | ARQ-00 §6 (D-67) |

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
