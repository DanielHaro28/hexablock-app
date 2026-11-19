# 04 — Historias de usuario (v2) · App (`hexablock-app`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 (v1 del 28-10-2026 por el equipo) |
| Repositorio | `hexablock-app` (`docs/requirements/04-HISTORIAS.md`). Las historias del backend están en el mismo archivo de `hexablock-api` |
| Relacionados | `02-RN-*.md`, `03-REQUISITOS.md`, `05-TRAZABILIDAD.md` |

## Qué cambió respecto de la v1

- Las **reglas de juego** que estaban dentro de los criterios ahora viven en `02-RN-*.md`. Los criterios las **citan** por ID (por ejemplo, "según RN-HS-42") en lugar de repetirlas.
- Se agregó a cada historia el **RF** que cubre.
- Se aplicaron las respuestas del profesor, lo que ya define el enunciado y las decisiones del equipo (`docs/DECISIONES.md`): sin rotación en Hexa Lines, 1 pila en la bandeja de Hexa Sort, Hexa Merge continúa tras 2048, ranking de Fit por estrellas → tiempo → movimientos, modo invitado y offline.
- **API-05** pasa de *Should* a **Must** (profesor, P-08). **NAV-04** pasa a **Must** (el patrón State exige el estado de pausa).
- **Historias nuevas:** NAV-06, NAV-07, NAV-08, API-06, API-07, API-08, TEC-06 a TEC-09 (app) y TEC-10 (api).
- **Separación por repositorio (11-11):** las historias que tocan app y servidor (API-01 a 03, LVL-01) aparecen en **los dos repos con el mismo ID**, cada una con los criterios de su lado. Las que son solo de servidor (API-04, LVL-02, TEC-05, TEC-10) están en `hexablock-api`. En GitHub se crea **un Issue por repo**, con el mismo ID y la etiqueta `app` o `api`.
- **Topologías (11-11):** TEC-06 cubre triángulos, cuadrados, hexágonos y cubos; TEC-07 a TEC-09 son nuevas.

## Formato

- **ID** = prefijo de la épica + número. En GitHub, cada historia será un Issue con el ID en el título y una etiqueta por épica.
- **Historia:** Como [rol], quiero [acción], para [beneficio].
- **Criterios:** Dado / Cuando / Entonces. Cada criterio se convierte en al menos una prueba automatizada.
- **Prioridad (MoSCoW)** · **RF** que cubre · **Reglas** que aplica.

**Roles:** jugador (con o sin cuenta), jugador registrado, equipo de desarrollo.

## Resumen de épicas

| Épica | Prefijo | Historias | Alcance |
|---|---|---|---|
| 1. Navegación y experiencia general | NAV | 8 | Inicio, ajustes, audio, idioma, pausa, cuenta, ranking, figura de celdas |
| 2. Hexa Lines | HL | 6 | Partida sin fin, líneas, récord |
| 3. Hexa Fit | HF | 6 | Niveles, rotación, deshacer/rehacer, estrellas |
| 4. Hexa Sort | HS | 5 | Pilas, cascada, metas |
| 5. Hexa Merge | HM | 5 | Deslizar, fusión, semilla, deshacer |
| 6. Progreso local y resultados | PRG | 4 | Victoria, derrota, guardado local, desbloqueo |
| 7. Cuenta, sincronización y ranking (parte app) | API | 7 | Registro, sesión, invitado, importar, cerrar sesión, offline, sync |
| 8. Niveles remotos (parte app) | LVL | 1 | Descarga y validación de niveles |
| 9. Historias técnicas (app) | TEC | 8 | Motor, extensibilidad, AOP, CI, topologías |

**Total en la app: 50 historias** (42 funcionales + 8 técnicas). En `hexablock-api`: 9 (6 funcionales + 3 técnicas), de las cuales 5 comparten ID con la app (API-01, API-02, API-03, LVL-01, TEC-04).

---

## Épica 1 · Navegación y experiencia general

### NAV-01 · Seleccionar un juego desde el inicio
Como jugador, quiero ver una pantalla de inicio con las cuatro variantes, para elegir a cuál jugar.
- Dado que abro la app, cuando carga, entonces veo el nombre de la suite, un acceso a ajustes y las tarjetas de Hexa Lines, Hexa Fit, Hexa Sort y Hexa Merge.
- Dado que toco Hexa Lines o Hexa Merge, entonces empieza una partida nueva.
- Dado que toco Hexa Fit o Hexa Sort, entonces voy a su selección de niveles.

**Must** · RF-01 · RN-COM-01, 02

### NAV-02 · Controlar el audio
Como jugador, quiero silenciar la música y los efectos por separado, para jugar donde no puedo hacer ruido.
- Dado que estoy en ajustes, cuando desactivo la música, entonces se detiene y los efectos siguen sonando.
- Dado que desactivo los efectos, entonces dejan de sonar los de colocar, eliminar y fusionar.
- Dado que cierro y vuelvo a abrir la app, entonces se mantiene mi configuración.

**Must** · RF-04 · RN-COM-111

### NAV-03 · Cambiar el idioma
Como jugador, quiero usar la app en español o en inglés, para entender los textos.
- Dado que abro la app por primera vez, entonces se muestra en el idioma del sistema si es español o inglés; si no, en inglés.
- Dado que cambio el idioma en ajustes, entonces todos los textos cambian sin reiniciar.
- Dado que reinicio la app, entonces se conserva el idioma elegido.

**Must** · RF-03 · RN-COM-110, 112

### NAV-04 · Pausar una partida
Como jugador, quiero pausar la partida, para retomarla después sin perder el estado.
- Dado que estoy jugando, cuando toco pausa, entonces el tablero deja de aceptar movimientos y veo continuar, reiniciar y salir al menú.
- Dado que la variante mide tiempo (Hexa Fit), entonces el cronómetro se detiene durante la pausa.
- Dado que la app pasa a segundo plano, entonces la partida se pausa sola.
- Dado que cierro la app (o Android la cierra) a mitad de partida, cuando vuelvo a abrir esa variante, entonces veo **Continuar** y la partida sigue en pausa desde el último movimiento, sin contar el tiempo que estuvo cerrada (RN-COM-33, 34).

**Must** · RF-05, RF-64 · RN-COM-24, 30 a 35, 52

### NAV-05 · Consultar cómo se juega
Como jugador nuevo, quiero ver las reglas de cada variante, para entender el objetivo antes de jugar.
- Dado que estoy en la tarjeta de una variante o en pausa, cuando toco "Cómo jugar", entonces veo un resumen de reglas, victoria y derrota en mi idioma.

**Could** · RF-08

### NAV-06 · Acceder a mi cuenta desde la app _(nueva)_
Como jugador, quiero registrarme o iniciar sesión desde la app, para guardar mi progreso en el servidor.
- Dado que estoy como invitado, entonces en ajustes veo "Crear cuenta" e "Iniciar sesión".
- Dado que completo el formulario con datos válidos, entonces inicio sesión y veo mi nombre visible.
- Dado que hay un error (correo repetido, credenciales incorrectas, sin conexión), entonces veo un mensaje claro en mi idioma y sigo pudiendo jugar como invitado.

**Must** · RF-75 · RN-COM-81, 88

### NAV-07 · Ver el ranking en la app _(nueva)_
Como jugador, quiero ver el ranking de cada variante desde la app, para compararme con otros.
- Dado que abro el ranking de una variante, entonces veo los mejores resultados con nombre visible y posición.
- Dado que la variante es por niveles, entonces puedo elegir un nivel y ver su ranking.
- Dado que no hay conexión, entonces veo un aviso y el último ranking descargado (si existe).

**Must** · RF-74, RF-75 · RN-COM-100 a 107

### NAV-08 · Elegir la figura de las celdas _(nueva)_
Como jugador, quiero elegir con qué figura de celda juego (hexágonos, cuadrados, triángulos o cubos), para variar la experiencia.
- Dado que estoy en Ajustes sin una partida en curso, entonces veo "Figura de las celdas" con las figuras disponibles y hexágonos por defecto (RN-TOP-30).
- Dado que elijo una figura, entonces las partidas nuevas de cualquier variante se crean con ella y la elección se conserva al reiniciar la app.
- Dado que hay una partida en curso o en pausa, entonces la opción aparece bloqueada con un aviso, y la partida sigue con su figura (RN-TOP-31).
- Dado que una variante por niveles no tiene niveles para la figura elegida, entonces su tarjeta dice "No disponible con esta figura" (RN-TOP-34).
- Mi récord, mi progreso y el ranking se muestran para la figura elegida (RN-TOP-33).

**Should** · RF-09 · RN-COM-113, RN-TOP-30 a 34

---

## Épica 2 · Hexa Lines

### HL-01 · Empezar una partida sin fin
Como jugador, quiero empezar con el tablero vacío y tres piezas, para jugar sin límite de niveles.
- Dado que inicio Hexa Lines, entonces veo el tablero vacío (RN-HL-10, 11) y una bandeja con 3 piezas del catálogo (RN-HL-20, 23).
- Dado que la fuente de piezas recibe la misma semilla, entonces genera la misma secuencia (RN-COM-41, RN-HL-24).

**Must** · RF-20 · RN-HL-10, 11, 20 a 25

### HL-02 · Colocar una pieza
Como jugador, quiero arrastrar una pieza de la bandeja al tablero, para ocupar celdas libres.
- Dado que arrastro una pieza sobre el tablero, entonces veo una vista previa de dónde quedaría y si es válida.
- Dado que la suelto en una posición válida (RN-HL-31), entonces queda colocada y sale de la bandeja.
- Dado que la suelto en una posición inválida, entonces vuelve a la bandeja y el tablero no cambia (E-HL-3).

**Must** · RF-21 · RN-HL-22, 30 a 32

### HL-03 · Eliminar líneas completas
Como jugador, quiero que una línea completa desaparezca, para liberar espacio y sumar puntos.
- Dado que una colocación completa una o varias líneas, entonces se eliminan todas a la vez según RN-HL-40 a 42 (E-HL-1, E-HL-2).
- Dado que una celda pertenece a dos líneas completadas, entonces se vacía una vez y cuenta para ambas (E-HL-2).
- Dado que elimino líneas en turnos seguidos, entonces se aplica la racha (RN-HL-63).

**Must** · RF-22 · RN-HL-40 a 44, 60 a 64

### HL-04 · Recibir una nueva bandeja
Como jugador, quiero recibir tres piezas nuevas al usar las tres actuales, para seguir jugando.
- Dado que coloco la tercera pieza, entonces se generan 3 nuevas.
- Dado que aún quedan piezas en la bandeja, entonces no se genera ninguna.

**Must** · RF-20 · RN-HL-21

### HL-05 · Terminar cuando nada cabe
Como jugador, quiero que la partida termine cuando no puedo colocar ninguna pieza, para saber que acabó.
- Dado que ninguna pieza de la bandeja cabe en ninguna posición, entonces la partida termina y voy a la pantalla de fin (E-HL-4).
- Dado que al menos una cabe, entonces la partida continúa (E-HL-4).

**Must** · RF-23 · RN-HL-50 a 52

### HL-06 · Ver mi puntaje y mi récord
Como jugador, quiero ver mi puntaje actual y mi récord, para intentar superarme.
- Dado que estoy jugando, entonces veo el puntaje y el récord.
- Dado que coloco una pieza, entonces el puntaje suma según RN-HL-60 a 64.
- Dado que termino con un puntaje mayor al récord, entonces el récord se actualiza y se guarda.

**Must** · RF-24 · RN-HL-60 a 64, 70, 71

---

## Épica 3 · Hexa Fit

### HF-01 · Elegir un nivel
Como jugador, quiero ver la lista de niveles con mi progreso, para elegir cuál jugar.
- Dado que entro a Hexa Fit, entonces veo al menos 15 niveles con las estrellas de los completados (RN-HF-72).
- Dado que un nivel está bloqueado, entonces se ve con candado y no se puede abrir.
- Los niveles salen de archivos de configuración que cumplen RN-HF-12.

**Must** · RF-02, RF-30 · RN-COM-03, 73, RN-HF-10 a 13, 72

### HF-02 · Colocar una pieza dentro de la figura
Como jugador, quiero arrastrar una pieza a la figura, para ir cubriéndola.
- Dado que la suelto en una posición válida (RN-HF-30), entonces queda colocada.
- Dado que alguna celda queda fuera de la figura o encima de otra pieza, entonces vuelve a la bandeja (E-HF-2).

**Must** · RF-31 · RN-HF-30, 34

### HF-03 · Rotar una pieza
Como jugador, quiero rotar una pieza, para encontrar la orientación que encaja.
- Dado que toco una pieza de la bandeja, entonces rota un giro básico (RN-HF-31): un paso horario en 2D (60° en hexágonos).
- Dado que la roto tantas veces como pasos tiene una vuelta (6 en hexágonos), entonces vuelve a su orientación original (E-HEX-1).

**Must** · RF-32 · RN-COM-14, RN-HF-31

### HF-04 · Retirar o mover una pieza
Como jugador, quiero sacar o mover una pieza ya colocada, para corregir mi intento.
- Dado que arrastro una pieza colocada fuera de la figura, entonces vuelve a la bandeja y sus celdas quedan libres (RN-HF-32, 34).
- Dado que la arrastro a otra posición válida, entonces se mueve allí (RN-HF-33).
- Dado que la arrastro a una posición inválida, entonces se queda donde estaba.

**Must** · RF-31 · RN-HF-32 a 34

### HF-05 · Deshacer y rehacer sin límite
Como jugador, quiero deshacer y rehacer mis movimientos, para probar alternativas sin empezar de nuevo.
- Dado que hice N acciones (colocar, mover, retirar o rotar), entonces puedo deshacer las N hasta el estado inicial (RN-HF-80, 81).
- Dado que deshice, cuando toco rehacer, entonces se reaplican en el mismo orden.
- Dado que deshice y hago una acción nueva, entonces se descarta el rehacer (E-HF-3).

**Must** · RF-33 · RN-HF-80 a 82

### HF-06 · Completar el nivel y ganar estrellas
Como jugador, quiero ganar estrellas por completar, por ser eficiente y por ser rápido, para tener un motivo para repetir niveles.
- Dado que la figura queda cubierta, entonces el nivel se completa y voy a la pantalla de victoria (RN-HF-50).
- Gano una estrella por completar, otra si no supero `m` movimientos y otra si no supero `t` de tiempo; la pantalla muestra cuál me faltó (RN-HF-61 a 64, E-HF-1).
- Hexa Fit no tiene derrota (RN-HF-51).
- Dado que repito un nivel, entonces se guarda el mejor intento (RN-HF-71, E-HF-4).

**Must** · RF-34 · RN-HF-50 a 52, 60 a 64, 70, 71

---

## Épica 4 · Hexa Sort

### HS-01 · Elegir un nivel
Como jugador, quiero ver los niveles de Hexa Sort con su meta, para elegir cuál jugar.
- Dado que entro a Hexa Sort, entonces veo al menos 10 niveles con su estado (RN-HS-72).
- Dado que abro un nivel, entonces veo las metas a cumplir, el tablero y la pila de la bandeja.
- Los niveles salen de archivos de configuración que cumplen RN-HS-12.

**Must** · RF-02, RF-40 · RN-COM-03, 73, RN-HS-10 a 12, 72

### HS-02 · Colocar una pila
Como jugador, quiero colocar la pila de la bandeja en una celda vacía, para agrupar colores.
- Dado que toco una celda vacía, entonces la pila se coloca allí y la bandeja ofrece una nueva (RN-HS-20, 30).
- Dado que toco una celda ocupada, entonces no pasa nada (E-HS-6).

**Must** · RF-41 · RN-HS-20 a 22, 30, 31

### HS-03 · Transferir fichas en cascada
Como jugador, quiero que las fichas del mismo color se junten solas, para formar pilas grandes.
- Dado que coloco una pila, entonces se resuelve la cascada según RN-HS-40 a 44 (E-HS-1, E-HS-3).
- Dado que hay empate entre pilas, entonces gana la colocada si está empatada y, si no, la primera vecina en sentido horario (RN-HS-43, E-HS-2, E-HS-8).
- La animación muestra cada paso en orden (RN-HS-45).

**Must** · RF-42 · RN-HS-40 a 45

### HS-04 · Completar un bloque de 10
Como jugador, quiero que 10 fichas del mismo color desaparezcan, para avanzar hacia la meta.
- Dado que un bloque de cima llega a 10 o más, entonces se elimina y el contador de metas sube en 1 (RN-HS-50, E-HS-4).
- Dado que la eliminación deja otro color en la cima, entonces la cascada continúa (RN-HS-51, E-HS-5).

**Must** · RF-43 · RN-HS-50, 51

### HS-05 · Ganar o perder el nivel
Como jugador, quiero saber cuándo gané o perdí, para pasar de nivel o reintentar.
- Dado que al terminar la resolución alcanzo las metas del nivel, entonces gano (RN-HS-52).
- Dado que al terminar la resolución no quedan celdas vacías y no gané, entonces pierdo (RN-HS-53, E-HS-7).

**Must** · RF-43, RF-44 · RN-HS-52 a 54, 60, 61

---

## Épica 5 · Hexa Merge

### HM-01 · Deslizar en seis direcciones
Como jugador, quiero deslizar el tablero en cualquiera de las direcciones, para mover todas las fichas a la vez.
- Dado que inicio Hexa Merge, entonces veo el tablero con 2 fichas iniciales (RN-HM-11).
- Dado que hago un gesto, entonces se interpreta como la dirección más cercana a su ángulo.
- Dado que deslizo, entonces las fichas se mueven según RN-HM-40, 41 (E-HM-1, E-HM-3).
- Dado que el deslizamiento no cambia el tablero, entonces no cuenta y no aparece ficha nueva (E-HM-4).

**Must** · RF-50 · RN-HM-11, 30, 31, 40, 41

### HM-02 · Fusionar fichas iguales
Como jugador, quiero que dos fichas iguales que chocan se fusionen, para crear fichas de mayor valor.
- Dado que dos fichas iguales chocan, entonces se fusionan en una de valor doble y el puntaje suma ese valor (RN-HM-41, 60).
- Dado que una ficha ya se fusionó en este movimiento, entonces no vuelve a fusionarse (RN-HM-42, E-HM-2).

**Must** · RF-51 · RN-HM-40 a 43, 60, 61

### HM-03 · Aparición reproducible de fichas nuevas
Como equipo de desarrollo, quiero que la ficha nueva use un generador con semilla inyectable, para probar el juego de forma determinista.
- Dado un movimiento válido, entonces aparece una ficha de 2 o 4 según RN-HM-21.
- Dados el mismo estado inicial, la misma semilla y los mismos movimientos, entonces el resultado es idéntico (E-HM-6).

**Must** · RF-52 · RN-COM-40 a 45, RN-HM-20 a 22

### HM-04 · Deshacer un movimiento
Como jugador, quiero deshacer mi último movimiento, para corregir un error.
- Dado que hice al menos un movimiento, cuando toco deshacer, entonces vuelven el tablero, el puntaje y el generador (RN-HM-80, E-HM-7).
- Dado que ya deshice una vez, entonces el botón queda deshabilitado hasta el próximo movimiento (RN-HM-81).

**Must** · RF-53 · RN-HM-80 a 83

### HM-05 · Ganar, perder y guardar el récord
Como jugador, quiero saber cuándo gané o perdí y ver mi récord, para medir mi progreso.
- Dado que aparece la ficha objetivo (2048 por defecto), entonces gano y elijo "seguir jugando" o "nueva partida" (RN-HM-50, 51).
- Dado que ningún deslizamiento cambia el tablero, entonces pierdo (RN-HM-52, E-HM-5).
- Dado que termino con un puntaje mayor al récord, entonces el récord se actualiza y se guarda (RN-HM-70).

**Must** · RF-54 · RN-HM-50 a 53, 70

---

## Épica 6 · Progreso local y resultados

### PRG-01 · Ver la pantalla de victoria
Como jugador, quiero ver mi resultado al ganar, para saber cómo me fue y decidir qué hacer.
- Dado que gano, entonces veo la puntuación (y en Hexa Fit, estrellas, tiempo y movimientos).
- Dado que la variante es por niveles, entonces veo "Siguiente nivel" y "Volver a niveles".
- Dado que es Hexa Merge, entonces veo "Seguir jugando" y "Nueva partida" (RN-HM-51).

**Must** · RF-06 · RN-COM-31, RN-HF-64, RN-HS-61, RN-HM-51

### PRG-02 · Ver la pantalla de derrota
Como jugador, quiero ver mi resultado al perder, para reintentar rápido.
- Dado que pierdo, entonces veo mi puntuación, mi récord, "Reintentar" y "Menú".
- Dado que toco "Reintentar", entonces empieza una partida nueva del mismo juego o nivel.

**Must** · RF-07 · RN-COM-31

### PRG-03 · Guardar el progreso en el dispositivo
Como jugador, quiero que mi progreso se guarde en el teléfono, para no perderlo al cerrar la app.
- Dado que completo un nivel o termino una partida, entonces se guarda localmente, por perfil, variante y figura (RN-COM-80).
- Dado que cierro y vuelvo a abrir la app sin conexión, entonces mi progreso sigue disponible.

**Must** · RF-60 · RN-COM-80

### PRG-04 · Desbloquear niveles en orden
Como jugador, quiero que el siguiente nivel se desbloquee al completar el actual, para avanzar con dificultad progresiva.
- Dado que soy nuevo, entonces solo está disponible el nivel 1 de Hexa Fit y de Hexa Sort.
- Dado que completo el nivel N, entonces se desbloquea el N + 1 de esa variante, y nunca se vuelve a bloquear (RN-COM-73).

**Must** · RF-61 · RN-COM-73

---

## Épica 7 · Cuenta, sincronización y ranking (parte de la app)

> Las reglas están en `02-RN-CUENTA-PROGRESO-RANKING.md` (compartido). **API-04** (consultar el ranking) es solo de servidor y está en `hexablock-api`; en la app la cubre **NAV-07**.

### API-01 · Registrarme ↔ también en `hexablock-api`
Como jugador, quiero crear una cuenta desde la app, para guardar mi progreso en el servidor.
- Dado que completo correo, contraseña y nombre visible válidos, cuando me registro, entonces quedo con la sesión iniciada y el JWT se guarda en almacenamiento seguro (SEC-MOB-01).
- Dado que el correo o el nombre visible ya existen (409) o los datos son inválidos (400), entonces veo el mensaje junto al campo correspondiente, en mi idioma (RN-COM-109).
- Dado que escribo una contraseña de menos de 15 caracteres, entonces la app me avisa antes de enviarla; si el servidor la rechaza por común (`too-common`), veo ese aviso junto al campo (SEC-API-02, D-52).
- Dado que no hay conexión, entonces veo un aviso y sigo jugando como invitado.

**Must** · RF-70, RF-75 · SEC-MOB-01, SEC-API-02

### API-02 · Iniciar sesión ↔ también en `hexablock-api`
Como jugador registrado, quiero iniciar sesión desde la app, para acceder a mi progreso.
- Dadas credenciales correctas, entonces el JWT se guarda en almacenamiento seguro y veo mi nombre visible.
- Dadas credenciales incorrectas (401), entonces veo un mensaje genérico.
- Dado que la API responde 401 a una petición con sesión, entonces la app borra el token y me pide iniciar sesión (SEC-MOB-04).

**Must** · RF-71, RF-75 · RN-COM-87, SEC-MOB-04

### API-03 · Sincronizar mi progreso por juego ↔ también en `hexablock-api`
Como jugador registrado, quiero que mi progreso se sincronice, para no perderlo si cambio de teléfono.
- Dado que termino una partida con conexión y sesión, entonces la app envía solo los resultados que cambiaron en esa variante y figura y guarda lo consolidado que devuelve la API (RN-COM-86).
- Dado que inicio sesión en otro dispositivo, entonces se descarga y consolida el progreso de las 4 variantes (RN-COM-90).
- La consolidación local da el mismo resultado que la del servidor (RN-COM-83, 84, E-COM-2).

**Must** · RF-72 · RN-COM-83 a 87, 90

### API-05 · Jugar como invitado
Como jugador, quiero jugar sin registrarme, para probar la app sin dar mis datos.
- Dado que no inicié sesión, entonces puedo jugar las 4 variantes con progreso solo local (RN-COM-81).
- Los invitados no aparecen en el ranking global (RN-COM-107).

**Must** _(antes Should)_ · RF-62 · RN-COM-81, 107

### API-06 · Importar mi progreso de invitado
Como jugador, quiero llevar a mi cuenta lo que jugué como invitado, para no empezar de cero.
- Dado que tengo progreso de invitado, cuando inicio sesión o me registro, entonces la app me pregunta si quiero importarlo (RN-COM-88).
- Dado que acepto, entonces se consolida con el progreso de mi cuenta y se sincroniza (RN-COM-83).
- Dado que no acepto, entonces el progreso de invitado queda intacto en su perfil.

**Must** · RF-73 · RN-COM-83, 88

### API-07 · Cerrar sesión
Como jugador registrado, quiero cerrar sesión, para que otra persona use el dispositivo.
- Dado que cierro sesión, entonces el token se borra del almacenamiento seguro (SEC-MOB-04) y el dispositivo vuelve al perfil invitado con su propio progreso (RN-COM-89).
- Dado que vuelvo a iniciar sesión, entonces recupero el progreso de mi cuenta.

**Must** · RF-71 · RN-COM-89

### API-08 · Seguir jugando sin conexión
Como jugador registrado, quiero seguir jugando en modo avión, para no depender de la red.
- Dado que no hay conexión, entonces juego normalmente y mis cambios quedan en la cola de sincronización (RN-COM-85).
- Dado que vuelve la conexión, entonces la cola se envía sin bloquear el juego (RN-COM-86).
- Dado que mi sesión expiró mientras estaba sin conexión, entonces se me pide iniciar sesión antes de sincronizar y la cola no se pierde (RN-COM-87).

**Must** · RF-63, RF-72 · RN-COM-82, 85 a 87

---

## Épica 8 · Niveles remotos (parte de la app)

> Las reglas están en `02-RN-NIVELES.md` (compartido). **LVL-02** (publicar niveles) es solo de servidor y está en `hexablock-api`.

### LVL-01 · Recibir niveles nuevos sin actualizar la app ↔ también en `hexablock-api`
Como jugador, quiero que aparezcan niveles nuevos de Hexa Fit y Hexa Sort, para tener más contenido sin descargar otra versión.
- Dado que abro la selección de niveles con conexión, entonces la app pide los niveles de esa variante y figura cambiados desde la última descarga y agrega los nuevos o actualizados (RN-COM-72, 77).
- Dado que no hay conexión, entonces se usan los incluidos en la app y los descargados antes.
- Dado que un nivel descargado no pasa la validación completa (incluida la geométrica), entonces se ignora (RN-COM-76, SEC-MOB-06).

**Must** · RF-80, RF-82 · RN-COM-70 a 72, 74 a 77

---

## Épica 9 · Historias técnicas (app)

No entregan una función visible, pero el enunciado las evalúa directamente. TEC-01 y TEC-06 van primero: las épicas 2 a 5 dependen de ellas.

### TEC-01 · Motor genérico compartido
Como equipo de desarrollo, quiero un motor genérico (`Board<TCoord, TCell>` con `HexBoard<TCell>` como su versión hexagonal, `IGameRules<TCoord, TCell, TMove, TState>`, `GameEngine<TCoord, TCell, TMove, TState>`, `IPieceSource<TPiece>`, `IScoringPolicy<TState>`, `IProgressModel`), para que cada variante sea una instanciación y no una copia.
- Las 4 variantes usan el mismo tablero y el mismo motor.
- `GameEngine` no tiene condicionales por variante (RNF-02).
- El motor pasa sus pruebas con un tipo de celda de prueba.
- El dominio no importa Flutter ni librerías externas (RNF-06).

**Must** · RF-10 · RNF-01, 02, 05, 06, RN-COM-20 a 25

### TEC-02 · Agregar una quinta variante sin tocar el motor
Como equipo de desarrollo, quiero documentar y demostrar cómo se agrega una variante, para superar la prueba de extensibilidad.
- Existe `docs/EXTENSIBILITY.md` con los archivos a crear y los que no se modifican, con clases reales.
- Agregar una variante requiere solo clases nuevas y su registro en configuración (RNF-03).
- `EXTENSIBILITY.md` explica también cómo agregar una **topología** (RN-COM-19).
- Existe el diagrama de extensibilidad en `/docs`.

**Must** · RNF-03, RNF-04, RNF-61

### TEC-03 · Aspecto transversal sobre los casos de uso
Como equipo de desarrollo, quiero registrar entrada, salida y duración de los casos de uso con un decorador, para cumplir AOP sin ensuciar la lógica.
- El aspecto envuelve el caso de uso genérico y aplica a las 4 variantes sin cambios.
- Ningún caso de uso llama directamente al logger (RNF-10).
- El aspecto redacta datos sensibles (SEC-WEB-06).

**Must** · RNF-10

### TEC-04 · Integración continua y release de la app ↔ también en `hexablock-api` (su propio CI)
Como equipo de desarrollo, quiero que GitHub Actions ejecute las pruebas en cada PR y publique el APK, para no integrar código roto y entregar el ejecutable.
- Cada PR a `main` ejecuta formato, análisis estático, pruebas y verificación de arquitectura.
- `main` está protegida: todo cambio entra por PR con CI en verde; no se exige la aprobación de otra persona, pero el autor completa la checklist de la plantilla de PR.
- Los commits siguen Conventional Commits y se validan.
- Un tag de versión genera el APK firmado y lo publica en un GitHub Release.

**Must** · RNF-24, 26, 52

### TEC-06 · Topología intercambiable
Como equipo de desarrollo, quiero que la forma de la celda sea un punto de extensión, para poder pasar de hexágonos a triángulos, cuadrados o cubos sin tocar el motor ni las reglas.
- Las reglas de las variantes usan solo las operaciones de topología de RN-COM-10 a 19.
- No hay ninguna suposición de 2D en el motor ni en las reglas: los giros, el orden de vecinas y el orden de celdas los define la topología.
- La topología hexagonal (Anexo A de `02-RN-TOPOLOGIAS.md`) es una implementación intercambiable, y su dibujo es una estrategia separada en la presentación.
- `HexBoard<TCell>` se conserva como nombre del tablero hexagonal: es un `typedef` de `Board<HexCoord, TCell>` en `hexa_topologies` (D-07).
- La coordenada es un parámetro genérico con restricción (`TCoord extends Coord`); el README explica por qué se agregó respecto de las firmas mínimas del enunciado.

**Must** · RNF-04 · RN-COM-10 a 19, RN-TOP-01

### TEC-07 · Cuadrados y triángulos jugables
Como equipo de desarrollo, quiero implementar las topologías de cuadrados y de triángulos, con su dibujo 2D, para demostrar que la forma de la celda es intercambiable.
- Existen ambas topologías con sus pruebas: vecinas, líneas, direcciones, giros y tableros por defecto (Anexos B y C, E-TRI-1, E-TRI-2, E-SQR-1).
- Las 4 variantes se pueden jugar con ellas eligiéndolas en Ajustes (NAV-08).
- El código de las reglas de las variantes no cambia.

**Should** · RNF-04 · RN-TOP-02, RN-TOP-03, RN-TOP-10 a 12

### TEC-08 · Cubos en el dominio
Como equipo de desarrollo, quiero una topología de cubos con pruebas, para demostrar que el motor y las reglas también funcionan en 3D.
- Existe la topología de cubos con sus pruebas, incluidas las 24 orientaciones (Anexo D, E-CUB-1).
- Hay pruebas en las que **las 4 variantes** resuelven tableros 3D con las mismas reglas (RN-TOP-04, D-18). Hexa Lines usa el catálogo de cubos (D-20) y Hexa Fit, un nivel de muestra (D-28).
- No requiere interfaz.

**Should** · RNF-04 · RN-TOP-04

### TEC-09 · Vista 3D
Como jugador, quiero jugar al menos una variante con cubos, para ver el juego en 3D.
- Al menos Hexa Merge se puede jugar con cubos en una vista isométrica o 3D.
- Es una nueva estrategia de presentación: no cambia el dominio.

**Could** · RNF-04 · RN-TOP-04
