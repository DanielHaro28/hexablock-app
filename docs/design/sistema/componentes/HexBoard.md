# HexBoard

HexBoard draws a hexagonal board in axial coordinates (q, r), pointy-top, inside the one object with an ink outline.

**Provide:** `radius` (2 → 19 cells for Sort / Merge, 4 → 61 cells for Lines) or `shape` (a list of `[q, r]` for a Hexa Fit figure), `R` (cell circumradius: 34 at radius 2, 18 at radius 4) and `cells`, a map from `"q,r"` to HexCell props. Missing cells render empty.

- The board is `surface` with a `border-board` (3 px) `ink` outline, `radius-board` (28), `shadow-soft`, padding `space-16`. It is the only ink contour in the system.
- Cells sit `space-4` apart — the one exception to the 8-point rhythm.
- Real size on 390×844: a radius-2 cell is 59 dp (R 34); Hexa Lines drops to about 32 dp. Margin `space-16` to the screen edges.
