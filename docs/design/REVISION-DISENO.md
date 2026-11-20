# Revisión del diseño inicial (Paso 7)

| Campo | Valor |
|---|---|
| Diseño revisado | "HexaBlock Suite — Diseño", 59 pantallas, hecho por **@dicpc** (recibido el 20-11). Es una **propuesta visual** para ir viendo el juego; se ajusta a lo definido. Archivo: `HexaBlock-Suite-Diseno-v1.pdf` en esta carpeta |
| Fecha | 2026-11-20 |
| Contra qué | Reglas (`docs/requirements/02-RN-*.md`), historias (`04-HISTORIAS.md`), decisiones (`docs/DECISIONES.md`) |
| Estado | **Las 16 propuestas fueron aceptadas** (D-66, 20-11). Quien diseñó decide cómo se ven al aplicarlas; las reglas ya se ajustaron (RN-HL-71, NAV-05) |

## 1. Pantallas del diseño y sus historias

| Páginas | Pantalla | Historias |
|---|---|---|
| 1–3 | Carga (*splash*) y error al leer el progreso, con "Reintentar" y "Jugar sin conexión" | PRG-03, API-08 |
| 4–6 | Inicio: elegir juego, con récord o nivel en cada tarjeta, "Nuevo" la primera vez; en español e inglés | NAV-01, NAV-03, NAV-07 |
| 7–10 | Ajustes: sonido, música, volumen, idioma, "Reducir movimiento", cuenta (con o sin sesión) | NAV-02, NAV-03, NAV-06, API-07 |
| 11–18 | Iniciar sesión y crear cuenta, con errores (correo sin @, credenciales, sin conexión) | API-01, API-02, API-05, API-08 |
| 19–22 | Selección de niveles de Fit y Sort: camino de hexágonos, candados, estrellas, "todo completado" | HF-01, HS-01, PRG-04 |
| 23–30 | Hexa Lines: partida, arrastre, combo, racha, "No cabe"; la página 26 describe la estructura común | HL-01 a HL-06 |
| 31–33 | Hexa Fit: partida, inicio del nivel, pieza que vuelve a la bandeja | HF-02 a HF-05 |
| 34–37 | Hexa Sort: partida, transferencia, "¡Pila completa!", metas | HS-02 a HS-04 |
| 38–40 | Hexa Merge: partida, fusión, objetivo 2048 | HM-01, HM-02 |
| 41–43 | Pausa (Fit y Lines) y confirmación de salir | NAV-04 |
| 44–48 | Victoria de Fit (con estrellas), de Merge (con "Seguir jugando"), los 15 niveles completados, guardado en el teléfono | PRG-01, HF-06, HM-05 |
| 49–54 | Derrota de Lines (con y sin récord nuevo), de Sort ("Tablero lleno", en dos idiomas) y de Merge ("Sin movimientos") | PRG-02, HL-05, HS-05, HM-05 |
| 55–59 | Clasificación: Lines, Fit por nivel, Sort, Merge; "Tú · Puesto 128"; error de carga | NAV-07, API-04 |

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

- **Colores por juego:** Lines azul, Fit verde, Sort naranja, Merge violeta (tarjetas, punto del título, borde del *chip* principal). Van en el tema de la app (`lib/frameworks/theme/`) como *tokens*, no repartidos en las pantallas.
- **Estructura común de la partida** (página 26): un solo *widget* de pantalla con cinco ranuras (barra, marcadores, tablero, bandeja, acciones) que cada variante llena. Es la contraparte visual del Abstract Factory de las variantes (`VariantFamily`).
- **Símbolos de color** (gota, estrella, rombo, triángulo, flor, hoja, cuadrado, círculo): uno por cada *token* de color del contrato (`common.schema.json`), para que los colores también se distingan sin verlos (RNF-51).
- **Textos:** todos van a los archivos ARB (es/en), con los mensajes de error elegidos por `code` (D-51).
