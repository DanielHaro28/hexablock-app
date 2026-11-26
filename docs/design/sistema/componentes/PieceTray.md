# PieceTray

PieceTray holds the pieces under the board, in 104×96 slots: three pieces in Hexa Lines, every piece of the level in Hexa Fit, the current and the next stack in Hexa Sort.

**Provide:** `slots`: `{cells, color}` for a piece, `{stack, count}` for a stack, `{rotate: true}` for the rotate button, with optional `state` (`used` → dashed empty slot, `nofit` → piece at 35% with the note «No cabe» / «Won't fit», `next` → 55% with the note «Siguiente» / «Next») and `note`.

- Hexa Lines: 3 pieces; a new tray comes when all three are used.
- Hexa Fit: all the level's pieces (up to 7), visible from the start, in the level's order. With more than 3 slots the tray scrolls horizontally (`space-8` between slots, snapping to a slot).
- Hexa Sort: the current stack and the next one.
- Tray: `surface`, `radius-card`, `shadow-soft`, 120 high, padding `space-12`.
- Rotating in Hexa Fit is a double tap on the piece (60°); the 48 dp RoundIconButton «Rotar» / «Rotate» is the accessible alternative.
