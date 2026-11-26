# Sistema de diseño · HexaBlock Suite

> **Copia fiel** del sistema de diseño de @dicpc del 25-11-2026 (fuente: https://claude.ai/artifact/BpH2DMc1TY1HiA46vr6nw4). No se edita aquí: el cambio se hace en el sistema y se vuelve a copiar. Las guías de `componentes/` están en inglés, como en el origen. Donde contradice las reglas, mandan las reglas: ver `../REVISION-DISENO.md` §5.

**Una taza de té y un rompecabezas.** Base visual común para Hexa Lines, Hexa Fit, Hexa Sort y Hexa Merge, para un teléfono de 390×844. El hexágono redondeado es la forma madre; lo que se toca es píldora o círculo; el único contorno de tinta es el del tablero.

## Principios

1. Fondo crema (`bg`) y el tablero como objeto: `surface` con contorno `ink` de 3 px (`border-board`) y `radius-board`.
2. Esqueleto de partida vertical: TopBar, chips de progreso (StatChip), tablero en tarjeta, bandeja (PieceTray), botones redondos con insignia.
3. Paleta empolvada lila, durazno y salvia; ilustración de línea de 4 px sobre una mancha hexagonal.
4. Cada juego muestra solo sus marcadores, en tarjetas crema: Puntaje y Récord en Hexa Lines y Hexa Merge; estrellas, tiempo y movimientos en Hexa Fit; Movimientos y Puntaje en Hexa Sort (ver «Marcadores por juego»). Acciones: el par Deshacer / Nueva partida. Sin modo oscuro, sin neón.
5. Hexágono para lo jugable (HexCell, LevelBubble, manchas); píldora (`radius-pill`) y círculo para lo tocable.
6. Cada color de ficha lleva un símbolo: nunca el color solo. Están activos por defecto; solo el jugador puede ocultarlos, en Ajustes › Accesibilidad.
7. Texto siempre en `ink` sobre pastel; `ink-soft` solo sobre `bg` y `surface`.
8. Movimiento de miel: suave al entrar, rebote corto al colocar, pétalos al limpiar.

## Contenido y tono

- Español de tú, cálido y breve; inglés como segundo idioma. Exclamaciones solo para celebrar: «¡Nivel superado!», «¡Combo ×3!», «¡Pila completa!», «¡Fusión 512!».
- La derrota no culpa: «Sin movimientos — Tómate un respiro y vuelve a intentarlo. Tu récord sigue en 12 850.» Los errores tranquilizan primero: «No pudimos leer tu progreso» + «Tu progreso sigue a salvo».
- Metáforas de panal con moderación: «Abriendo tu panal…», lema «Rompecabezas para una tarde tranquila».
- Mayúscula inicial en botones y títulos («Siguiente nivel», «Volver al menú»); MAYÚSCULAS solo en `label` («PUNTAJE», «RÉCORD»).
- Números con espacio de miles («12 850»), decimales con coma («1,2 s»). Abreviaturas cortas: «14 mov.», «Metas 3/5», «Nivel 7 de 15».
- Sin emoji. La estrella «★» solo como valor de ComboToast («3 ★»).
- Prevé hasta un 30% más de longitud en inglés: chips y botones crecen con ancho mínimo y hasta 2 líneas, nunca cortan texto.

## Color

- Fondo de pantalla `bg`; tarjetas, bandeja, hojas y tablero `surface`.
- Texto e iconos en `ink` (9,72:1 sobre `bg`, 10,30:1 sobre `surface`, de 4,84:1 a 7,43:1 sobre los pasteles). Texto secundario en `ink-soft` solo sobre `bg` (4,87:1) o `surface` (5,15:1). Sobre pastel la jerarquía se marca con tamaño y peso, no con color.
- Los 8 pasteles (`rose`, `sky`, `butter`, `peach`, `mint`, `lilac`, `sage`, `coral`) son colores de ficha, con su símbolo activo por defecto (ver Símbolos). Roles: `primary` = lilac, `secondary` = peach, `badge` = coral, `success` = mint, `star` = butter.
- Color por juego: `game-lines` sky, `game-fit` mint, `game-sort` peach, `game-merge` lilac — en la mancha de VariantCard y el borde del chip principal.
- Escala de Hexa Merge: `merge-2` butter … `merge-256` sage; desde 512 el ciclo se repite con un anillo `ink` de 3 px.
- Estados sin colores nuevos, solo transparencias de tokens: `cell-empty` (ink 7%), `cell-locked` (ink 14%), `scrim` (ink 28%), objetivo de soltado = color de la pieza al 45%, `hint` (butter 55%), `blob` (ink 6%).
- Contraste no textual: los pasteles contra `surface` quedan entre 1,38 y 2,13:1. Se compensa con el símbolo, el trazo `tile-stroke` de cada ficha y el contorno del tablero. Mantequilla y menta quedan muy cerca en claridad: los símbolos son la versión por defecto.

## Tipografía

- Dos familias: Fredoka 600 (`display`) para lo que se lee de un vistazo y Nunito 500/700 (`text`) para leer.
- Escala cerrada 40 · 28 · 22 · 16 · 13: `display` (nombre de la suite), `title` (diálogos, ScoreCard), `subtitle` (botones de 56 dp, TopBar, números de celda), `number-sm` (números de 4 cifras, botones compactos de 48 dp), `badge`, `body-strong`, `body`, `label` (mayúsculas, 0,08em), `note-strong`, `note`.
- No añadas tamaños: el 18 de algunos ejemplos no existe; usa 22 en botones de 56 dp y 16 en compactos.

## Espaciado, radios, sombra

- Ritmo de 8: `space-8` icono–texto, `space-16` dentro de tarjetas y márgenes laterales, `space-24` entre bloques, `space-32` entre secciones, `space-48` área táctil mínima, `space-64` márgenes de hoja. `space-12` en bandeja y ScoreCard. La única excepción: `space-4` entre celdas.
- Radios: `radius-pill` botones e insignias, `radius-card` (24) tarjetas, `radius-chip` (16) chips y ranuras, `radius-board` (28) tablero, `radius-cell` (6) esquinas de hexágono.
- Una sola sombra, `shadow-soft` (y 6, blur 16, ink 10%), en tarjetas, bandeja, tablero y botones en reposo. Presionado: `shadow-pressed` y baja 2 px. Pieza levantada: `shadow-lifted`.
- Bordes: solo el tablero, LevelBubble disponible y el anillo de 512+ llevan contorno `ink` de 3 px. Chips y toast llevan 2 px de color. Desactivados: 2 px discontinuo `ink-soft` sobre `bg` — nunca opacidad global (bajaría el texto a menos de 3:1).
- Foco: anillo sólido `ink` de 3 px con 3 px de separación (9,72:1 sobre `bg`).

## Movimiento

- Colocar 180 ms: escala 1,00 → 1,06 → 1,00, rebote corto.
- Transferir / deslizar 200 ms ease-out, ficha por ficha cada 40 ms.
- Limpiar línea o pila 240 ms: la celda se encoge a 0 y brotan 4 pétalos y 2 estrellitas (los pétalos duran 600 ms en total: es un efecto, no una transición).
- ComboToast 220 ms: entra 16 px desde arriba y se queda 1,2 s.
- Con «Reducir movimiento»: sin rebote ni partículas, solo fundido de 180 ms.

## Interacción

- Áreas táctiles de 48 dp o más: píldoras de 56, botones redondos de 56 (48 en la barra), burbujas de 62×72, ranuras de 104×96.
- Las celdas no son objetivos sueltos: se arrastra la pieza y se ajusta al centro más cercano dentro de 0,6 R. Al arrastrar, la pieza se dibuja 48 dp sobre el dedo y crece 15%.
- Rotar en Hexa Fit: doble toque (60°) o el RoundIconButton «Rotar» de 48 dp.
- Deshacer: Fit ilimitado con rehacer, hasta el estado inicial del nivel; Merge un solo deshacer y luego desactivado; Lines y Sort no muestran el botón. Si la insignia de «Deshacer» muestra un número, cuenta los pasos que se pueden deshacer ahora; nunca es un límite.
- «Cómo jugar»: un botón «?» en la barra de todas las partidas y en la pausa. Si la historia no llega a la entrega, el botón se oculta (no se muestra desactivado). Se dibuja con el icono `help` en la TopBar (`onHelp`) y como RoundIconButton en la pausa.
- Acciones en el tercio inferior, en la zona del pulgar; nada que tocar en la mitad superior.

## Marcadores por juego

Arriba del tablero, cada juego muestra solo lo que define su progreso. Los valores van en ScoreCard (pares) o StatChip (datos en vivo).

| Juego | En la partida | En la victoria o el final |
| --- | --- | --- |
| Hexa Lines | ScoreCard «Puntaje» / «Score» y «Récord» / «Best» | Puntaje y Récord |
| Hexa Merge | ScoreCard «Puntaje» / «Score» y «Récord» / «Best» | Puntaje y Récord |
| Hexa Fit | Sin puntaje ni récord. StatChips de tiempo y movimientos, y los dos umbrales de estrella: «★ ≤ 5 mov.» / «★ ≤ 5 moves» y «★ ≤ 1:20» | Estrellas (cuál se ganó y cuál faltó), tiempo, movimientos y el mejor intento del nivel |
| Hexa Sort | ScoreCard «Movimientos» / «Moves» y «Puntaje» / «Score» | Movimientos y Puntaje; el récord del nivel va en la victoria y en la selección de niveles |

- El tiempo se escribe `m:ss` («1:24»); los movimientos con abreviatura: «14 mov.» / «14 moves».
- No muestres un récord en la partida de Hexa Sort ni un puntaje en Hexa Fit.

## Estrellas de Hexa Fit

- Tres estrellas independientes: una por completar el nivel, una por movimientos ≤ m y una por tiempo ≤ t. Se pueden ganar la de tiempo y no la de movimientos, o al revés.
- En la partida, los dos umbrales se ven como StatChips con borde `star`: «★ ≤ 5 mov.» y «★ ≤ 1:20» («★ ≤ 5 moves», «★ ≤ 1:20»). La «★» es el icono `star` del chip, no un carácter del texto.
- En la victoria, StarRow marca cada estrella con su etiqueta: «Completar» / «Complete», «≤ 5 mov.» / «≤ 5 moves», «≤ 1:20». La que faltó va vacía y se explica en una línea:
  - «Te faltó la de tiempo: termina en 1:20 o menos.» / «You missed the time star: finish in 1:20 or less.»
  - «Te faltó la de movimientos: termina en 5 mov. o menos.» / «You missed the moves star: finish in 5 moves or fewer.»
  - Si faltan las dos: «Te faltaron las de tiempo y movimientos: termina en 1:20 o menos y en 5 mov. o menos.» / «You missed the time and moves stars: finish in 1:20 or less, in 5 moves or fewer.»
- Debajo de los marcadores, el mejor intento del nivel: «Tu mejor intento: 2★ · 1:12 · 7 mov.» / «Your best try: 2★ · 1:12 · 7 moves».

## Salir de la partida

- En Hexa Lines y Hexa Merge, salir termina la partida y guarda el récord si lo superó. La confirmación es un SheetDialog con Abi y su taza:
  - Título: «¿Salir de la partida?» / «Leave this game?»
  - Si no lo supera: «La partida termina aquí. Tu puntaje (3 420) no supera tu récord (12 850).» / «This game ends here. Your score (3 420) doesn't beat your best (12 850).»
  - Si lo supera: «La partida termina aquí. ¡3 420 será tu nuevo récord!» / «This game ends here. 3 420 will be your new best!»
  - Acciones: primario «Seguir jugando» / «Keep playing», secundario «Salir» / «Leave».

## Clasificación

- El título nombra la figura de las celdas elegida en Ajustes: «Clasificación · Hexágonos» / «Leaderboard · Hexagons». En la TopBar el título puede ocupar dos líneas; nunca se corta.
- En Hexa Fit y Hexa Sort, el selector de nivel empieza con «Todos los niveles» / «All levels» (ranking global: niveles completados y, en Fit, estrellas). Después, «Nivel 1», «Nivel 2»… / «Level 1», «Level 2»…
- Cada fila: puesto, nombre visible y el resultado en `body-strong`.
  - Hexa Fit por nivel, en este orden: «3★ · 0:50 · 9 mov.» / «3★ · 0:50 · 9 moves».
  - Hexa Fit global: «12 niveles · 31★» / «12 levels · 31★». Hexa Sort global: «8 niveles» / «8 levels».
  - Hexa Sort por nivel: «14 mov. · 2 448» / «14 moves · 2 448». Hexa Lines y Hexa Merge: el puntaje, «12 850».
- Tu puesto se ve siempre, aunque no estés en la lista visible: «Tú · Puesto 128» / «You · Rank 128».
- Componentes: LeaderboardRow para cada fila y ChoiceChips para el selector de nivel.

## Ajustes · Figura de las celdas

- Sección «Figura de las celdas» / «Cell shape», con una opción por figura; «Hexágonos» / «Hexagons» viene elegida por defecto. Una sola figura vale para los cuatro juegos.
- Con una partida en curso o en pausa, la sección queda bloqueada (`cell-locked` + icono `lock`) y dice: «Termina o cierra tu partida para cambiar la figura.» / «Finish or close your game to change the shape.»
- Queda oculta mientras solo exista hexágonos; se muestra cuando haya una segunda figura.
- Componente: ChoiceChips, con `locked` y su aviso.

## Ajustes · Accesibilidad

- «Símbolos en las fichas» / «Symbols on tiles»: un ChoiceChips con «Mostrar» / «Show» (por defecto) y «Ocultar» / «Hide». Cambia al instante en todos los juegos.
- Sin símbolos, las fichas conservan su trazo `tile-stroke` y el tablero su contorno; el color pasa a ser la única forma de distinguirlas, por eso nunca se ocultan por defecto.

## Cuenta

- Crear cuenta: bajo la contraseña, «Mínimo 15 caracteres; puede ser una frase» / «At least 15 characters; a phrase works too» (de 15 a 128).
- Los errores van junto a su campo, en `note-strong` y `ink`, nunca solo en color:
  - Muy corta: «Es muy corta: usa 15 caracteres o más.» / «Too short: use 15 characters or more.»
  - Demasiado común: «Es demasiado común; prueba una frase tuya.» / «That one is too common; try a phrase of your own.»
  - Correo ya registrado: «Ese correo ya tiene una cuenta.» / «That email already has an account.»
  - Nombre en uso: «Ese nombre ya lo usa otra persona.» / «Someone else is already using that name.»
- Iniciar sesión: un solo mensaje para credenciales incorrectas, sin decir cuál falló: «El correo o la contraseña no coinciden.» / «The email or password doesn't match.»
- Después de iniciar sesión, si hay progreso de invitado, un SheetDialog con Abi saludando: «Tienes progreso como invitado. ¿Lo pasamos a tu cuenta?» / «You have progress as a guest. Shall we move it to your account?». Acciones: «Sí, pasarlo» / «Yes, move it» y «Ahora no» / «Not now». Si dice que no, el progreso de invitado queda intacto.
- Sesión vencida: un aviso discreto que no corta el juego, un StatChip bajo la TopBar: «Tu sesión venció. Inicia sesión para sincronizar.» / «Your session expired. Sign in to sync.» Al tocarlo se abre el inicio de sesión; la partida sigue.
- Componente: TextField, con la pista (`hint`) o el error (`error`) junto al campo.

## Tamaños de pantalla

El diseño base es 390×844. Los tokens no cambian: lo que se adapta es el espacio libre.

- Más angosto, desde 360 de ancho: márgenes laterales `space-16` fijos; el tablero calcula R con el ancho disponible (la celda de radio 2 baja de 59 a unos 54 dp); las ranuras de la bandeja se reparten el ancho sin bajar de 48 dp táctiles, y en Fit la bandeja se desplaza; los botones de hoja ocupan el ancho menos `space-24` a cada lado; VariantCard mantiene 2 columnas y su texto pasa a más líneas.
- Más alto: TopBar y marcadores arriba, bandeja y acciones abajo en la zona del pulgar; el tablero se centra en el espacio que sobra y no crece más allá de lo que permite el ancho.
- El texto nunca se corta: botones y chips crecen en alto (hasta 2 líneas) antes que achicar la letra.

## Componentes

Las mismas piezas para los cuatro juegos; ningún juego necesita un widget propio. HexCell cubre color, pila y número; HexBoard, cualquier forma; PieceTray, pieza y pila; SheetDialog, victoria y derrota. Cada componente tiene su guía y su vista previa.

## Iconografía e ilustración

- Iconos de línea propios en una retícula de 24, trazo 2,2 redondeado, en `ink` (grupo Iconos; componente `Icon`). `ink-soft` solo en desactivados.
- Símbolos de ficha: círculo, gota, estrella, triángulo, hoja, rombo, cuadro y flor, en `ink` al 50% (grupo Símbolos).
- Abi, la abejita, es la mascota: cuerpo `butter`, dos rayas `ink`, alas `surface` con brillo `sky`, antenas con puntas `rose`, trazo de 4 px (`stroke-illustration`), sin aguijón, sobre una mancha hexagonal. Saludando (inicio, `sky`), celebrando (victoria, `lilac`), abrazando una taza (derrota y pausa, `mint`). Usa los SVG del grupo Mascota o el componente `Abi`; no la redibujes.
- No hay logotipo: el nombre «HexaBlock Suite» se escribe en `display` y va acompañado de Abi. Nada copia una referencia: sin animales, globos, logos ni textos de los juegos de referencia.
