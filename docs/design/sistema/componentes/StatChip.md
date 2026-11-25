# StatChip

StatChip shows one live figure above the board (level, goals, stars, moves, time) or a reassurance line.

**Provide:** `children` (text), `icon` (18 px Icon name, e.g. `goal`, `check`, `star-filled`, `moves`, `time`), `color` — the border colour of the datum (the game's `game-*` token for the main chip).

- 40 high (min), padding 0 16, `radius-chip`, `surface` with a 2 px coloured border, `body-strong` in `ink`. Text may wrap.
- Hexa Fit shows its two star thresholds as StatChips with the `star` border; the `star` icon is the «★», so the text is only the threshold: «★ ≤ 5 mov.» / «★ ≤ 5 moves» and «★ ≤ 1:20», next to the live time and moves.
- A session that expired shows a quiet StatChip under the TopBar, without stopping the game: «Tu sesión venció. Inicia sesión para sincronizar.» / «Your session expired. Sign in to sync.» Tapping it opens sign-in.
