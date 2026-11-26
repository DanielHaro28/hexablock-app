# ScoreCard

ScoreCard shows one of the two scoreboard values of a game; which pair depends on the game.

**Provide:** `label` (rendered uppercase in `label`, `ink-soft`) and `value` (Fredoka 600, 28, `ink`; group thousands with a space: «12 850»).

- `surface`, `radius-card`, `shadow-soft`, padding 12 16. Use in pairs inside a row with `space-16` gap; each card flexes.
- Pairs by game, during play:
  - Hexa Lines and Hexa Merge: «Puntaje» / «Score» and «Récord» / «Best».
  - Hexa Sort: «Movimientos» / «Moves» and «Puntaje» / «Score». The level best is not shown during play; it goes on the victory sheet and the level select.
  - Hexa Fit: no ScoreCards during play (no score, no best). Time, moves and the two star thresholds are StatChips. On the victory sheet, «Tiempo» / «Time» and «Movimientos» / «Moves».
- Labels can run ~30% longer in English; keep two cards per row.
