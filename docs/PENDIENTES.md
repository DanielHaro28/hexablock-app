# PENDIENTES — HexaBlock Suite

> Decisiones abiertas del proyecto y preguntas al profesor. **Vive solo en `hexablock-app/docs/PENDIENTES.md`**; el índice de documentación del backend apunta aquí.
>
> - Las decisiones **cerradas** están en `docs/DECISIONES.md` de cada repo. Al cerrar una, se pasa allí con su fecha y se borra de aquí.
> - Las **tareas** no están aquí: son Issues de los dos repos, en el tablero [HexaBlock Suite](https://github.com/users/DanielHaro28/projects/1) (D-69). El plan y la hoja de ruta están en `docs/plan/PLAN-ENTREGA.md`.
>
> **Última actualización:** 2026-11-24 (D-140 y D-143 cerradas en HL-06; antes, D-140 abierta y D-78 cerrada: reparto completo) · 2026-11-23 (D-117 a D-120 cerradas; D-121 y D-122 abiertas; D-124 y D-129 cerradas; D-125 y D-130 abiertas; D-128 abierta) · 2026-11-22 (D-78: Hexa Lines asignada; D-102 a D-107, D-109 y D-110 a D-116 cerradas) · 2026-11-21 (D-97 a D-101 cerradas; D-93 a D-96 cerradas; D-90 a D-92 cerradas) · 2026-11-20 (D-03 cerrada; paso 8: D-79 a D-88 cerradas; D-77 cerrada y D-78 abierta; ARQ-S-02 y ARQ-S-03 confirmadas; D-02 y D-67 a D-75 cerradas; tareas pasadas a los Issues) · **Entrega:** lunes 14-12-2026

---

## 1. Decisiones abiertas

| # | Pendiente | Responsable | Fecha límite | Origen |
|---|---|---|---|---|
| ☐ D-20 | **Catálogos de piezas de Hexa Lines** para cuadrados (hay propuesta), triángulos y cubos. **20-11:** se deja para TEC-07 (topologías adicionales, solo si sobra tiempo); no bloquea nada antes | Equipo | Al empezar TEC-07 | RN-TOP-21 a 23 |
| ☐ D-121 | **Limitar la clave del CI al despliegue.** Hoy `hexablock-deploy` (D-118) entra como `ubuntu`, que puede usar `sudo` sin contraseña: si la clave se filtra, se pierde el control del servidor. Propuesta: en `~ubuntu/.ssh/authorized_keys`, anteponer a esa clave `restrict,command="/opt/hexablock/deploy.sh"`, para que solo pueda ejecutar el script de despliegue. **A favor:** una clave filtrada solo sirve para volver a desplegar la imagen de GHCR. **En contra:** cada cambio en la forma de desplegar pasa por ese script, y el script se edita por EC2 Instance Connect. **Recomendación:** sí, al escribir el script de TEC-10 | @DanielHaro28 | Al implementar TEC-10 | D-118; api #16 |
| ☐ D-122 | **Verificar la huella del servidor en el CI.** Propuesta: guardar la huella ED25519 de `hexablock.duckdns.org` como variable `EC2_KNOWN_HOSTS` del Environment `production` y usarla como `known_hosts`, en lugar de `StrictHostKeyChecking=no`. **A favor:** el CI no le entrega la clave a un servidor falso (por ejemplo, si alguien cambia el registro de DuckDNS). La huella es pública, así que no hace falta que sea secreto. **En contra:** si se recrea la instancia, hay que actualizar la variable. **Recomendación:** sí, en TEC-10 | @DanielHaro28 | Al implementar TEC-10 | D-118; api #16 |
| ☐ D-125 | **Cómo llega el nivel a la fábrica de una variante por niveles** (Fit y Sort). `StartOptions` (capa 2) dice qué nivel se juega, pero `createSession` solo recibe `NewGameOptions` (D-124), un tipo del motor que no puede llevar un nivel de Fit o de Sort sin un `Object` con *cast* ni un genérico más. **A (recomendada):** el `VariantModule` de la variante (capa 4, conoce los tipos concretos) carga el nivel y crea la fábrica con él, `HexaFitFactory<C>(topology, level)`, como `HexaLinesFactory<C>(topology, config)`; `NewGameOptions` se queda con la semilla y el motor no cambia. Desventaja: una fábrica por nivel, y `StartGameUseCase` no ve el nivel (solo lo usa para buscar la partida guardada por `GameKey`). **B:** un `String? levelId` en `NewGameOptions` (como `ILevelBased.levelId`, D-104) y la fábrica recibe una función que busca el nivel por su id. Desventaja: el motor conoce la idea de nivel y una variante sin niveles recibe un campo que ignora | Equipo | Antes de HF-01 | Revisión de D-124 (23-11) |
| ☐ D-128 | **¿Las skills escriben las horas reales en el tablero?** D-65 dio al tablero un campo de horas y D-62 pide recalcular la estimación al cerrar M1, pero hoy nadie anota las horas reales. `/implement-story` y `/close-milestone` (D-127) podrían hacerlo con `gh project item-edit`. **A (recomendada):** la skill pregunta las horas a la persona y las escribe solo con su confirmación; queda el dato sin que nadie lo olvide. Desventaja: una pregunta más al terminar. **B:** las estima la skill a partir de los commits y las escribe sola. Desventaja: la estimación puede ser mala y es un cambio visible para todo el equipo sin revisión. **C:** las skills no tocan el tablero y cada uno anota sus horas. Desventaja: es lo que pasa hoy, y el dato falta | Equipo | Antes de `/close-milestone` (30-11) | D-127 (23-11) |
| ☐ D-130 | **`EXTENSIBILITY.md` promete menos cambios de los reales para una 5ª variante.** Dice que solo cambian dos líneas de registro y la lista de `gameId` del backend, y que el esquema no cambia. En la práctica también cambian el `enum` de `gameId` del contrato (`common.schema.json`, y el patrón de `levelId` si es por niveles), cuatro herramientas con la lista de variantes fija (`check_architecture.dart`, `check_ids.py`, `levelcheck.py`, `check_examples.py`), RN-COM-01 ("exactamente 4 variantes") y el glosario y los documentos de datos. Es lo que se presenta en la defensa (RNF-03). **A:** corregir la guía para que liste todo y explique por qué nada de eso es el motor. Rápido y honesto; la promesa queda más débil. **B:** reducir los cambios reales: las herramientas deducen las variantes de las carpetas y de los `02-RN-*`, el contrato usa un patrón en vez del `enum` y se reescribe RN-COM-01. La promesa se cumple, pero es más trabajo, toca el contrato y una regla cerrada, y un patrón valida menos que un `enum`. **C (recomendada):** A ahora y, si sobra tiempo, la parte de B que automatiza las herramientas, sin tocar el `enum` (se defiende como configuración validada a propósito) | Equipo | Antes del ensayo de la defensa (T-07) | Revisión de `/new-variant` (23-11) |

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
