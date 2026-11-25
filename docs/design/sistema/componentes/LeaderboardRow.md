# LeaderboardRow

LeaderboardRow is one line of the leaderboard: rank, display name and result.

**Provide:** `rank`, `name` (display name, 3–20 characters), `result` (a preformatted string for the game and filter), optional `you` (the player's own row), `last` (no divider).

- 56 high (min), padding 8 16, `surface`, a 1 px `track` divider between rows. Rank in `subtitle` (16 from 4 digits), name and result in `body-strong`, all `ink`. Long names wrap; the result never wraps.
- Stack rows inside one `surface` card with `radius-card` and `shadow-soft`.
- The player's own row (`you`) is `primary` (lilac) with `radius-chip` and stays visible under the list even when out of view: name «Tú» / «You», e.g. rank 128.
- Results by game and filter:
  - Hexa Fit, per level, in this order: «3★ · 0:50 · 9 mov.» / «3★ · 0:50 · 9 moves».
  - Hexa Fit, all levels: «12 niveles · 31★» / «12 levels · 31★». Hexa Sort, all levels: «8 niveles» / «8 levels».
  - Hexa Sort, per level: «14 mov. · 2 448» / «14 moves · 2 448».
  - Hexa Lines and Hexa Merge: the score, «12 850».
- The screen title names the cell shape: «Clasificación · Hexágonos» / «Leaderboard · Hexagons» (TopBar, up to 2 lines).
