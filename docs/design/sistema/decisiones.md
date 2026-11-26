# Decisiones

1. **Nombre de la mascota.** «Abi» (de abeja): corto, se lee igual en español e inglés.
2. **Color por juego.** Lines = `sky`, Fit = `mint`, Sort = `peach`, Merge = `lilac`, en la mancha de VariantCard y el borde del chip principal.
3. **Símbolo por color.** Círculo, gota, estrella, triángulo, hoja, rombo, cuadro y flor, en `ink` al 50%. Activos por defecto; el jugador puede ocultarlos en Ajustes › Accesibilidad.
4. **Tamaño de texto de botón.** 22 en botones de 56 dp y 16 en compactos de 48 dp. Si se prefiere 18, hay que añadirlo a la escala.
5. **Estados sin colores nuevos.** Vacía = ink 7%, bloqueada = ink 14%, velo = ink 28%, objetivo de soltado = color de la pieza al 45%.
6. **Escala de Hexa Merge.** 2 butter, 4 peach, 8 rose, 16 coral, 32 lilac, 64 sky, 128 mint, 256 sage; desde 512 se repite con un anillo ink de 3 px. Números de 4 cifras en 16.
7. **Celdas y área táctil.** Radio 2: celda de 59 dp. Hexa Lines (radio 4, 9 celdas de ancho) baja a unos 32 dp. Se arrastra la pieza (ranura de 104×96) y se ajusta al centro más cercano dentro de 0,6 R.
8. **Rotar en Hexa Fit.** Doble toque gira 60°; alternativa accesible: RoundIconButton «Rotar» de 48 dp en la bandeja.
9. **Deshacer según juego.** Fit: ilimitado con rehacer, hasta el estado inicial del nivel. Merge: uno solo. Lines y Sort: el botón no aparece. Si la insignia de Deshacer muestra un número, son los pasos que se pueden deshacer, no un límite.
10. **Partículas.** Los pétalos duran 600 ms; es un efecto, fuera del rango de 180–240 ms. Se apaga con «Reducir movimiento».
11. **Pieza levantada.** Se dibuja 48 dp por encima del dedo, crece 15% y proyecta una sombra suave.
12. **Textos en inglés.** Chips y botones se ajustan al contenido con ancho mínimo, previendo hasta un 30% más de longitud.

## Pendiente de decisión del equipo

- **«Jugar sin guardar» en el error de carga.** Pendiente de decisión del equipo: el diseño anterior decía «Jugar sin conexión» / «Play offline». La pantalla S01 usa «Jugar sin guardar» / «Play without saving» hasta que se elija uno.

## Verificación

- Nada copia una referencia: Abi, los iconos de juego y los títulos son propios.
- Los 4 juegos usan los mismos componentes.
- Contraste 4,5:1 en todo el texto (ver Contraste).
- Áreas táctiles de 48 dp o más.
