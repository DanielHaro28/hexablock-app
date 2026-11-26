# HexCell

HexCell is the one widget for every board cell in all four games; each game decides only what goes inside it.

**Provide:** `state` (`empty`, `target`, `hint`, `locked`, or omit for a tile) and the content — `color` (one of the 8 pastels) for Hexa Lines / Hexa Fit, `stack` + `count` for Hexa Sort, `value` for Hexa Merge. `R` is the circumradius (34 on a radius-2 board, 18 on Hexa Lines' radius-4 board).

- Every coloured tile carries its symbol (rose circle, sky drop, butter star, peach triangle, mint leaf, lilac rhombus, sage square, coral flower) in `ink` at 50%. Pass `symbols={false}` only when the player hides them in Settings › Accessibility.
- A tile is three layers: pastel fill, 1.5 px inner stroke `tile-stroke`, and a hexagonal `tile-highlight`. The stroke is what separates a pastel from `surface` (1.38–2.13:1).
- Merge numbers follow `merge-2` … `merge-256`; from 512 the colours repeat with a 3 px `ink` ring. 4-digit numbers drop to `number-sm` (16).
- Empty = `cell-empty`, locked = `cell-locked` + padlock, hint = `hint` + dotted ink stroke + sparkle, drop target = the piece colour at 45% + dashed ink stroke. No new colours for states.
- Cells are not separate tap targets: the board owns one gesture detector and snaps a dragged piece to the nearest centre within 0.6 R.
