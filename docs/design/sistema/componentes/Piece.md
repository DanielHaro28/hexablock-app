# Piece

Piece draws a poly-hex (1–5 cells) for the tray and for dragging.

**Provide:** `cells` as axial offsets (`[[0,0],[1,0],[2,0]]`), `color`, optional `R` (13 in the tray), and `lifted` while dragging.

- A lifted piece is drawn 48 dp above the finger so the thumb never covers it, grows 15% and casts `shadow-lifted`.
- Pieces in the tray show no symbols; the symbol appears once the tile lands on the board.
