# Handoff Flutter

Tokens en una `ThemeExtension` (HexaColors, HexaRadii, HexaShadows); tipografía con `google_fonts`. Sombra: `BoxShadow(offset: Offset(0, 6), blurRadius: 16, color: ink.withOpacity(0.10))`.

| Componente | Widget sugerido | Padding y márgenes (dp) | Color | Radio | Texto |
| --- | --- | --- | --- | --- | --- |
| HexBoard | CustomPaint (HexBoardPainter) en Container | padding 16; margen h 16; entre celdas 4 | surface, borde ink 3 | 28 | — |
| HexCell | CustomPainter con Path hexagonal; un GestureDetector a nivel tablero | ancho √3·R; R 34 (radio 2), R 18 (radio 4); símbolo 14 | vacía ink 7%; ficha pastel + trazo ink 18%; pista butter 55%; bloqueada ink 14% | 6 (esquinas) | Fredoka 600, 22 (16 con 4 cifras) |
| PieceTray | Row de Draggable<Piece> en Container: 3 en Lines; pila actual + siguiente en Sort; en Fit todas las piezas del nivel (hasta 7) en un ListView horizontal | alto 120; padding 12; ranura 104×96; en Fit separación 8 | surface + sombra suave | 24 (ranura 16) | Nunito 700, 13 |
| PillButton primario | ElevatedButton con StadiumBorder | alto 56; padding h 24; ancho mín. 120 | lilac, texto ink | completo | Fredoka 600, 22 |
| PillButton secundario | ElevatedButton con StadiumBorder | alto 56; padding h 24 | peach, texto ink | completo | Fredoka 600, 22 |
| PillButton presionado | WidgetStateProperty (pressed): elevation 0 + Transform 2 | igual | sin sombra | completo | Fredoka 600, 22 |
| PillButton desactivado | onPressed: null + borde discontinuo (CustomPainter) | igual | bg, borde ink-soft 2, texto ink-soft | completo | Fredoka 600, 22 |
| RoundIconButton | IconButton.filled en SizedBox + Badge | 56×56 (48 en barra); icono 24; insignia 22 en (−4, −4) | surface, icono ink; insignia coral + texto ink | círculo | Fredoka 600, 13 |
| StatChip | DecoratedBox + Row(Icon, Text) | alto 40; padding h 16; separación 8 | surface, borde 2 del color del dato | 16 | Nunito 700, 16 |
| ScoreCard | Card dentro de Expanded | padding v 12, h 16 | surface + sombra | 24 | etiqueta Nunito 700, 13 ink-soft; valor Fredoka 600, 28 |
| TopBar | AppBar con PreferredSize(72) | padding h 16; botones 48 | transparente sobre bg | — | Fredoka 600, 22 |
| VariantCard | InkWell + Card en GridView de 2 columnas | 163×212; padding 16; separación 8; mancha 72 | surface; mancha del color del juego | 24 | título Fredoka 600, 22; texto Nunito 500, 13 ink-soft |
| LevelBubble | CustomPaint hexagonal + Text, en Column | 62×72; separación 8 con StarRow | disponible lilac + borde ink 3; superado mint; bloqueado ink 14% | 6 | Fredoka 600, 22 |
| StarRow | Row de 3 SvgPicture | estrella 16 (sep. 4) o 32 (sep. 8) | llena butter + borde ink; vacía borde ink-soft discontinuo | — | — |
| SheetDialog | showModalBottomSheet | padding 12 / 24 / 32; separación 16; asa 40×5 | surface; velo ink 28% | 24 arriba | título Fredoka 600, 28; cuerpo Nunito 500, 16 |
| ComboToast | OverlayEntry + AnimatedSlide / ScaleTransition | alto 56; padding h 16 / 8; 96 sobre el tablero | surface, borde butter 2; píldora butter | completo | Fredoka 600, 22 (valor 16) |
| HoneyProgressBar | ClipRRect + LinearProgressIndicator(value) en DecoratedBox con borde | 200×8; borde 1,5; margen abajo 12 | relleno butter; pista ink 10%; borde ink | completo | — |
| Mascota Abi | SvgPicture (flutter_svg), 3 archivos | 112 en diálogo; 240–280 en inicio | butter, ink, rose, sky, surface | — | — |
| ChoiceChips | Wrap/ListView horizontal de ChoiceChip en Semantics(inMutuallyExclusiveGroup) | alto 48; padding h 16; separación 8 | sin elegir surface + borde ink-soft 2; elegido lilac + borde ink 2 + check; bloqueado bg + borde ink-soft discontinuo | 16 | Nunito 700, 16; aviso Nunito 700, 13 |
| LeaderboardRow | ListTile dentro de una Card; fila propia fija abajo | alto mín. 56; padding 8 / 16; separación 12; divisor 1 | surface, divisor ink 10%; fila propia lilac | 16 (fila propia) | puesto Fredoka 600, 22; nombre y resultado Nunito 700, 16 |
| TextField | TextFormField con InputDecoration (OutlineInputBorder) | alto 56; padding h 16; separación 8 | surface; borde ink-soft 2; foco y error ink 3; error con icono alert | 16 | etiqueta Nunito 700, 16; texto Nunito 500, 16; pista Nunito 500, 13; error Nunito 700, 13 |
| Menu | MenuAnchor / PopupMenuButton desde un RoundIconButton «more» | items de 48; padding h 16; separación 12 | surface + sombra suave | 24 | Nunito 700, 16 |
| TopBar con «?» | AppBar con acciones [IconButton help, IconButton ajustes] | botones 48; separación 8; título hasta 2 líneas | transparente sobre bg | — | Fredoka 600, 22 |
