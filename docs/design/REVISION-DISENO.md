# Revisión del diseño (Paso 7; sistema de diseño y prototipo desde el 25-11)

| Campo | Valor |
|---|---|
| Fuente visual | **Sistema de diseño** de @dicpc ([en línea](https://claude.ai/artifact/BpH2DMc1TY1HiA46vr6nw4); copia en `sistema/`): *tokens*, componentes, textos y medidas para Flutter. Propuesta en D-144 |
| Referencia de cada pantalla | **Prototipo** de @dicpc ([en línea](https://claude.ai/artifact/35wwuL6SEsooCibs35pm1h)), con una captura por pantalla en `pantallas/` (§1) |
| Diseño inicial | "HexaBlock Suite — Diseño", 59 pantallas, de @dicpc (recibido el 20-11). Fue la base de DIS-01 a DIS-16 (§3) y queda como historial: `HexaBlock-Suite-Diseno-v1.pdf` en esta carpeta |
| Fecha | 2026-11-20 (diseño inicial) · 2026-11-25 (sistema y prototipo) |
| Contra qué | Reglas (`docs/requirements/02-RN-*.md`), historias (`04-HISTORIAS.md`), decisiones (`docs/DECISIONES.md`) |
| Estado | **Las 16 propuestas fueron aceptadas** (D-66, 20-11). Quien diseñó decide cómo se ven al aplicarlas; las reglas ya se ajustaron (RN-HL-71, NAV-05). **25-11:** el sistema y el prototipo aplican las 16 (§5); quedan diferencias nuevas, DIS-17 a DIS-24 (§6). Donde el diseño contradice una regla, manda la regla |

## 1. Pantallas del prototipo y sus historias

Una captura por pantalla en `pantallas/` (390×844). Las páginas del PDF que se citan en §2 y §3 son del diseño inicial.

| Capturas (`pantallas/`) | Pantalla | Historias |
|---|---|---|
| `carga`, `error-lectura` | Carga (*splash*) y error al leer el progreso, con «Reintentar» y «Jugar sin guardar» (DIS-19) | PRG-03, API-08 |
| `inicio`, `inicio-primera-vez`, `inicio-ingles`, `inicio-continuar` | Inicio: elegir juego, con récord o nivel en cada tarjeta, «Nuevo» la primera vez, «Continuar» con partida guardada | NAV-01, NAV-03 |
| `ajustes`, `ajustes-sin-sesion`, `ajustes-silenciado`, `ajustes-ingles`, `ajustes-figura-bloqueada` | Ajustes: sonido, idioma, accesibilidad, cuenta y figura de las celdas | NAV-02, NAV-03, NAV-06, NAV-08, API-07 |
| `cuenta-iniciar-sesion`, `cuenta-crear`, `cuenta-foco`, `cuenta-error-validacion`, `cuenta-contrasena-corta`, `cuenta-en-uso`, `cuenta-credenciales`, `cuenta-sin-conexion`, `cuenta-enviando`, `cuenta-teclado` | Iniciar sesión y crear cuenta, con sus errores | API-01, API-02, API-08 |
| `cuenta-progreso-invitado` | Pasar el progreso de invitado a la cuenta | API-06 |
| `niveles-fit`, `niveles-sort`, `niveles-bloqueado`, `niveles-completo` | Selección de niveles de Fit y Sort | HF-01, HS-01, PRG-04 |
| `partida-lines`, `partida-arrastre`, `partida-combo`, `partida-anotada` | Estructura común de la partida (la anotada describe las ranuras) | TEC-11, HL-02, HL-03 |
| `lines`, `lines-jugable`, `lines-dos-lineas`, `lines-despues-limpiar`, `lines-sin-hueco` | Hexa Lines: partida, líneas, racha, «No cabe» | HL-01 a HL-06 |
| `lines-sesion-vencida` | Aviso de sesión vencida sin cortar la partida | API-08 |
| `fit`, `fit-jugable`, `fit-inicio`, `fit-no-cabe` | Hexa Fit: partida, inicio del nivel, pieza que no cabe | HF-02 a HF-05 |
| `sort`, `sort-jugable`, `sort-cascada`, `sort-pila-completa`, `sort-casi-lleno` | Hexa Sort: partida, cascada, pila completa, metas | HS-02 a HS-04 |
| `merge`, `merge-jugable`, `merge-deslizar`, `merge-deshacer-usado` | Hexa Merge: partida, deslizar y fusionar, deshacer | HM-01, HM-02, HM-04 |
| `pausa-fit`, `pausa-lines`, `pausa-salir`, `pausa-salir-record` | Pausa, «?» y confirmación de salir | NAV-04, NAV-05, HL-06, HM-05 |
| `hoja-partida` | Plantilla de la hoja de pausa, victoria y derrota | PRG-01, PRG-02 |
| `victoria-fit`, `victoria-fit-ultimo`, `victoria-sort`, `victoria-merge`, `victoria-sin-conexion`, `victoria-reducir` | Victoria de cada juego, último nivel, sin conexión y con «Reducir movimiento» | PRG-01, HF-06, HS-05, HM-05, API-08 |
| `fin-lines`, `fin-lines-record`, `fin-sort`, `fin-sort-ingles`, `fin-merge`, `fin-merge-deshacer` | Derrota de cada juego, con y sin récord nuevo | PRG-02, HL-05, HS-05, HM-05 |
| `clasificacion-lines`, `clasificacion-fit`, `clasificacion-sin-sesion`, `clasificacion-cargando`, `clasificacion-sin-conexion` | Clasificación por juego y por nivel, con sus estados | NAV-07 |

No hay pantalla de «Cómo jugar» (NAV-05): ver DIS-23.

## 2. Lo que ya cumple

- La **misma estructura** en los cuatro juegos (página 26): barra superior fija, marcadores, tablero, bandeja y acciones. Encaja con el motor genérico: la pantalla cambia según la variante, pero el esqueleto es uno.
- Tableros con las medidas de RN-TOP-10 a 12: Lines de radio 4 (61 celdas); Sort y Merge de radio 2 (19).
- **Sin conexión** y errores con mensajes que tranquilizan y dan una salida: "Tu progreso sigue a salvo", "Jugar sin conexión", "Reintentar" (RN-COM-85, 87; API-08).
- **Login con mensaje genérico**: "El correo o la contraseña no coinciden" no dice cuál falló (SEC-API-02, OWASP WSTG).
- Colores de Hexa Sort que además tienen **símbolo** (gota, estrella, rombo…), como pide RNF-51.
- Dos idiomas (NAV-03); tarjeta "Nuevo" la primera vez; candados en los niveles (RN-HF-72); Merge con "Seguir jugando" al llegar a 2048 (RN-HM-40); Fit con deshacer, rehacer, rotar y reiniciar.
- **Extras que no pedían las reglas y suman:** "Reducir movimiento" (accesibilidad) y la mascota.

## 3. Diferencias con las reglas y propuestas

| ID | Páginas | Qué muestra el diseño | Qué dicen las reglas | Propuesta |
|---|---|---|---|---|
| DIS-01 | 12 | Contraseña "Mínimo 8 caracteres" | **De 15 a 128** (D-52, NIST) | Cambiar el texto a "Mínimo 15 caracteres; puede ser una frase". Agregar los estados de error `too-short` y `too-common` |
| DIS-02 | 44, 46–48 | La victoria de **Fit** muestra PUNTAJE y RÉCORD | Fit **no tiene puntaje**: su progreso es estrellas, tiempo y movimientos (RN-HF-60 a 64, RN-COM-80) | Quitar puntaje y récord de Fit. Mostrar estrellas, tiempo, movimientos y el **mejor intento** del nivel |
| DIS-03 | 31–33, 41, 44 | "3 estrellas: 12 mov. o menos" y "Termina en 12 mov. o menos para la tercera" | **Estrellas independientes** (RN-HF-62): ★ por completar, ★ por movimientos ≤ `m`, ★ por tiempo ≤ `t`. La victoria dice cuál faltó (RN-HF-64) | En la partida mostrar los dos umbrales (por ejemplo "★ ≤ 5 mov. · ★ ≤ 1:20"). En la victoria, marcar cuál estrella se ganó y cuál faltó: "Te faltó la de tiempo: termina en 1:20 o menos" |
| DIS-04 | 55–59 | Clasificación **sin figura** | El ranking se separa **por figura** (D-27) | Usar la figura elegida en Ajustes (D-26, decidida el 20-11) y mostrarla junto al título ("Clasificación · Hexágonos") |
| DIS-05 | 56 | Fit y Sort solo tienen ranking **por nivel** | También hay ranking **global** de la variante: niveles completados y estrellas (RN-COM-104) | Agregar "Todos los niveles" como primera opción del selector de nivel |
| DIS-06 | 56 | Ranking de Fit por nivel con estrellas y movimientos | El orden es estrellas → **tiempo** → movimientos (RN-COM-102) | Agregar el tiempo en cada fila ("3★ · 0:50 · 9 mov.") |
| DIS-07 | 7–10 | Ajustes sin **figura de las celdas** | RF-09 y NAV-08 (*Should*); D-26: una sola figura para todo el juego, elegida en Ajustes | Diseñar la sección "Figura de las celdas" y mostrarla cuando exista una segunda figura (TEC-07); hasta entonces queda oculta |
| DIS-08 | 43 | "¿Salir de la partida? Tu puntaje de 3 420 no se guardará como récord" | Merge **guarda** el récord al salir si lo superó (RN-HM-70); Lines dice "al terminar" (RN-HL-71) sin aclarar si salir cuenta | Igualar Lines a Merge: salir termina la partida y guarda el récord si lo superó (precisa RN-HL-71). El texto pasa a "La partida termina aquí. Tu puntaje (3 420) no supera tu récord (12 850)" o "…¡será tu nuevo récord!" |
| DIS-09 | 34–37 | Sort muestra PUNTAJE y RÉCORD arriba | El mejor intento de Sort se compara primero por **movimientos** y el puntaje solo desempata (RN-HS-71) | Marcadores de Sort: MOVIMIENTOS y PUNTAJE; el récord del nivel en la selección de niveles y en la victoria |
| DIS-10 | — | No hay pantalla para **importar el progreso de invitado** al iniciar sesión | API-06, RN-COM-88 | Agregar un diálogo después del login: "Tienes progreso como invitado. ¿Lo pasamos a tu cuenta?" |
| DIS-11 | 4–5 | La tarjeta de cada juego no ofrece **Continuar** una partida guardada | RN-COM-34 (D-37): al volver se ofrece Continuar, en pausa | Cuando hay partida guardada, la tarjeta muestra "Continuar" (y "Nueva partida" en un menú) |
| DIS-12 | — | No hay aviso de **sesión vencida** | RN-COM-87, D-44: al vencer el JWT, la app pide iniciar sesión antes de sincronizar, sin cortar el juego | Un aviso discreto: "Tu sesión venció. Inicia sesión para sincronizar"; el juego sigue |
| DIS-13 | 12 | Registro sin estados de **correo o nombre ya usados** | 409 `email-taken` (D-03) y `display-name-taken` (RN-COM-109) | Agregar el mensaje junto al campo: "Ese nombre ya lo usa otra persona" |
| DIS-14 | 26 | La nota de la bandeja dice "Lines y Fit: 3 piezas" | En Fit se ven **todas** las piezas del nivel (RN-HF-20), hasta 7 | Corregir la nota: "Fit: todas las piezas del nivel, con desplazamiento" (la página 31 ya lo dibuja así) |
| DIS-15 | 23–43 | Botón "?" (Cómo jugar) en todas las partidas | NAV-05 es *Could* | Subir NAV-05 a *Should*, porque ya está diseñado; si no llega, se oculta el botón |
| DIS-16 | 31 | Deshacer con el número "5" | Deshacer **sin límite** en Fit (RN-HF-80) | Confirmar con quien diseñó: si el número cuenta los pasos que se pueden deshacer, está bien; si es un límite, contradice la regla |

## 4. Qué se toma del diseño para el código

- **Colores por juego:** Lines azul, Fit verde, Sort naranja, Merge violeta (tarjetas, punto del título, borde del *chip* principal). Van en el tema de la app (`app/lib/frameworks/theme/`) como *tokens* (`sistema/tokens.json`), no repartidos en las pantallas. Medidas y *widget* sugerido de cada componente: `sistema/handoff-flutter.md`; las dependencias que sugiere se verifican antes (SEC-AGT-04, DIS-22).
- **Estructura común de la partida** (página 26): un solo *widget* de pantalla con cinco ranuras (barra, marcadores, tablero, bandeja, acciones) que cada variante llena. Es la contraparte visual del Abstract Factory de las variantes (`VariantFamily`).
- **Símbolos de color** (gota, estrella, rombo, triángulo, flor, hoja, cuadrado, círculo): uno por cada *token* de color del contrato (`common.schema.json`), para que los colores también se distingan sin verlos (RNF-51).
- **Textos:** todos van a los archivos ARB (es/en), con los mensajes de error elegidos por `code` (D-51).

## 5. Conciliación con el sistema de diseño y el prototipo (25-11)

Cómo quedó cada propuesta aceptada en D-66. «Cumple» quiere decir que el sistema (`sistema/`) y la captura citada lo muestran así.

| ID | Cómo quedó | Dónde se ve | Estado |
|---|---|---|---|
| DIS-01 | «Mínimo 15 caracteres; puede ser una frase» y los errores «Es muy corta…» y «Es demasiado común…» junto al campo (TextField) | `cuenta-crear`, `cuenta-contrasena-corta` | Cumple |
| DIS-02 | Fit sin puntaje ni récord: estrellas, tiempo, movimientos y «Tu mejor intento» | `fit`, `victoria-fit` | Cumple |
| DIS-03 | Umbrales «★ ≤ 8 mov.» y «★ ≤ 2:20» en la partida; en la victoria, StarRow con la estrella que faltó y «Te faltó la de tiempo…» | `fit`, `victoria-fit` | Cumple |
| DIS-04 | Título «Clasificación · Hexágonos» | `clasificacion-lines`, `clasificacion-fit` | Cumple |
| DIS-05 | Selector de nivel (ChoiceChips) que empieza con «Todos los niveles» | `clasificacion-fit` | Cumple |
| DIS-06 | Fila de Fit por nivel «3★ · 0:58 · 7 mov.» | `clasificacion-fit` | Cumple |
| DIS-07 | Sección «Figura de las celdas» (ChoiceChips), bloqueada con partida en curso y oculta mientras solo haya hexágonos | `ajustes-figura-bloqueada` | Cumple |
| DIS-08 | Salir termina la partida y guarda el récord si lo superó, con los dos textos | `pausa-salir`, `pausa-salir-record` | Cumple |
| DIS-09 | Sort con Movimientos y Puntaje; el récord del nivel en la victoria | `sort`, `victoria-sort` | Cumple |
| DIS-10 | Hoja «Tienes progreso como invitado. ¿Lo pasamos a tu cuenta?» | `cuenta-progreso-invitado` | Cumple |
| DIS-11 | Tarjeta con «Continuar» y «Nueva partida» en su menú (Menu) | `inicio-continuar` | Cumple |
| DIS-12 | StatChip «Tu sesión venció. Inicia sesión para sincronizar.»; la partida sigue | `lines-sesion-vencida` | Cumple |
| DIS-13 | «Ese correo ya tiene una cuenta» y «Ese nombre ya lo usa otra persona» junto al campo | `cuenta-en-uso` | Cumple |
| DIS-14 | Bandeja de Fit con todas las piezas del nivel y desplazamiento horizontal | `fit` | Cumple |
| DIS-15 | «?» en la barra de cada partida y en la pausa; si NAV-05 no llega, se oculta | `lines`, `fit`, `sort`, `merge`, `pausa-fit` | Cumple; falta la pantalla que abre (DIS-23) |
| DIS-16 | La insignia de Deshacer cuenta los pasos que se pueden deshacer; nunca es un límite | `fit` | Cumple |

## 6. Diferencias nuevas del sistema y el prototipo

| ID | Qué muestra el diseño | Qué dicen las reglas | Qué se hace |
|---|---|---|---|
| DIS-17 | Bandeja de Sort con la pila actual **y la siguiente** («Siguiente») (`sort`, PieceTray, `handoff-flutter.md`) | La bandeja ofrece **una pila a la vez** (RN-HS-20) | Manda la regla: el diseño quita «Siguiente». Cambiarla sería reabrir RN-HS-20 y 21 y los ejemplos `E-HS` |
| DIS-18 | Derrota de Merge con «Deshacer último movimiento» (`fin-merge-deshacer`) | No se deshace después de la derrota (RN-HM-83, RN-COM-63) | Manda la regla: el diseño quita el botón de la hoja de derrota |
| DIS-19 | Error de lectura con «Jugar sin guardar»; el diseño inicial decía «Jugar sin conexión». El sistema lo deja pendiente | Ni PRG-03 ni API-08 definen esa salida | Decisión abierta: D-145 |
| DIS-20 | Ajustes › Accesibilidad: «Símbolos en las fichas: Mostrar / Ocultar» (`ajustes`) | No está en los requisitos; RNF-51 pide que los colores se distingan también por un símbolo | Decisión abierta: D-147. Hasta cerrarla, los símbolos siempre se ven |
| DIS-21 | Chip «Racha ×2» en Hexa Lines (`lines`) | Con dos turnos seguidos (k = 2) el multiplicador es ×1,5 (RN-HL-63) | Pregunta para quien diseñó: si el chip muestra k o el multiplicador. No cambia la regla |
| DIS-22 | El *handoff* sugiere `google_fonts`, `flutter_svg` y *widgets* de Material | `google_fonts` descarga las fuentes en línea (API-08); toda dependencia nueva se verifica antes (SEC-AGT-04) | Fuentes: decisión abierta D-146. `flutter_svg` y Material se verifican en el PR del tema |
| DIS-23 | No hay pantalla de «Cómo jugar», que abre el «?» | NAV-05 (*Should*): resumen de reglas, victoria y derrota en el idioma del jugador | Falta diseñarla antes de NAV-05 |
| DIS-24 | Diferencias internas menores: las piezas de la bandeja de Lines llevan símbolo y la guía de Piece dice que no; `error-lectura` no coincide con `sistema/pantalla-carga.md` (botón secundario y nota); el fondo de `victoria-sort` muestra otros datos; algunas hojas salen con una fuente con serifa en la captura | — | Las corrige quien diseñó; para el código vale el sistema (`sistema/`) |
