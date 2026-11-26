# ChoiceChips

ChoiceChips lets the player pick one option from a short row: the level filter of the leaderboard and the cell shape in Settings.

**Provide:** `options` (`{value, label, icon?, disabled?}`), `value`, `onChange`, optional `label` (section heading, rendered uppercase in `label`), `locked` + `lockedNote` (the whole group can't change right now), `wrap` (wrap instead of scrolling).

- Each chip is 48 high (touch minimum), padding 0 16, `radius-chip`, `body-strong`. Unselected: `surface` with a 2 px `ink-soft` border (5,15:1). Selected: `primary` (lilac) with a 2 px `ink` border and a check icon — selection is shown by fill, border and icon, never colour alone. `ink` text on both (6,65:1 on lilac).
- The row scrolls horizontally and snaps to a chip; it never wraps a label.
- Locked: every chip turns `bg` with a dashed `ink-soft` border and `ink-soft` text (4,87:1), and a line with the `lock` icon explains why, in `note-strong` `ink`.
- Leaderboard level filter (Hexa Fit and Hexa Sort): the first option is always «Todos los niveles» / «All levels», then «Nivel 1», «Nivel 2»… / «Level 1», «Level 2»…
- Settings, «Figura de las celdas» / «Cell shape»: «Hexágonos» / «Hexagons» selected by default. With a game in progress or paused the group is locked: «Termina o cierra tu partida para cambiar la figura.» / «Finish or close your game to change the shape.» The section stays hidden while hexagons are the only shape.
- Settings › Accessibility, «Símbolos en las fichas» / «Symbols on tiles»: «Mostrar» / «Show» (default) and «Ocultar» / «Hide».
