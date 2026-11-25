# Pantalla S01 · Carga y error de lectura

La primera pantalla: carga normal en máx. 1,5 s y, si la lectura de datos falla, un error tranquilo con las acciones en la zona del pulgar.

## Carga

- Scaffold + SafeArea, Column centrada, padding h 24, arriba 152, fondo `bg` (splash nativo con `bg`: sin destello blanco).
- Mancha hexagonal 280×310 (R 150, esquinas 20% de R) en `blob`; Abi saludando 200×200 centrada.
- Nombre «HexaBlock Suite» en `display`, margen arriba 24, `Semantics(header: true)`. Lema «Rompecabezas para una tarde tranquila» en `body`, `ink-soft`, ancho máx. 320.
- HoneyProgressBar 200×8, margen abajo 12; estado «Abriendo tu panal… 68 %» en `note-strong`, `ink-soft`, liveRegion. Versión en `note`, margen 40 / 32.
- Sin botones: no hay nada que tocar en 1,5 s. Tiempo mínimo visible 800 ms.

## Error de lectura

- Arriba 88; mancha 210×230 (R 110) con Abi abrazando la taza 170×170.
- Título «No pudimos leer tu progreso» en `title`, liveRegion, ancho 342. Mensaje en `body` `ink`, ancho 326.
- Aviso StatChip borde `success` + icono check: «Tu progreso sigue a salvo».
- Acciones en el tercio inferior: PillButton primario «Reintentar» (icono retry) y secundario «Jugar sin guardar», 342 de ancho, alto mín. 56, texto hasta 2 líneas, separación 16. Nota «No se guardará nada hasta que vuelvas a abrir la app.» en `note`, `ink-soft`.

## Animación

| Elemento | Tiempo | Curva |
| --- | --- | --- |
| Mancha | 0–240 ms · escala 0,92 → 1 + fundido | easeOutCubic |
| Abi | 80–280 ms · sube 12 dp | easeOutBack |
| Nombre y lema | 160–360 ms · fundido + sube 8 | easeOut |
| Barra | 240–1300 ms · cada avance en 180 ms | easeOut |
| Saludo de Abi | 360–840 ms · mano ±12°, 2 × 240 ms | easeInOut |
| Salida | 1300–1500 ms · fundido a Inicio 200 ms | easeInOut |
| Pasar a error | 220 ms · fundido cruzado; Abi cambia a la taza | easeInOut |
| Botones de error | 220 ms · suben 16 dp, 40 ms entre uno y otro | easeOutCubic |
| Reintentar | 180 ms · vuelve a la carga con la barra en 0 | easeOut |
| Reducir movimiento | 180 ms · solo fundidos | linear |

## Pendiente de confirmar

- Lecturas de más de 1,5 s: propuesta de pasar a Inicio si solo faltan los puntajes y mostrar error solo si la lectura falla o tarda más de 4 s.
- «Jugar sin guardar»: si se prefiere solo «Reintentar», se quitan el botón secundario y la nota.
