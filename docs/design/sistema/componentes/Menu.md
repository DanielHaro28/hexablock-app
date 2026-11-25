# Menu

Menu is a short list of secondary actions that opens from a «more» RoundIconButton.

**Provide:** `items` (`{label, icon?, onClick, disabled?}`), optional `label` (spoken), `width`.

- `surface`, `radius-card`, `shadow-soft`, padding 8 0. Each item 48 high, padding 0 16, `body-strong` `ink`, optional 24 icon.
- Open it below its button, towards the side with room on screen (in the home grid: rightwards in the left column, leftwards in the right one); close it on a choice, on tapping outside or with Back. Keep it to 1–3 items; the main action never hides in a menu.
- VariantCard with a saved game: the card itself says «Continuar» / «Continue»; the menu holds «Nueva partida» / «New game» (icon `retry`).
