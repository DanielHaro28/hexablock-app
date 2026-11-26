# VariantCard

VariantCard is the game picker tile on the home screen, in a 2-column grid.

**Provide:** `game` (`lines`, `fit`, `sort`, `merge`), `title`, `description` (one short sentence), optional `meta` + `metaIcon` (record or level progress), `isNew`, `menu` (Menu items) with `menuOpen`/`onMenu`/`menuAlign`, `href`/`onClick`.

- 163×212, `surface`, `radius-card`, `shadow-soft`, padding `space-16`, gap `space-8`.
- The 72 px hexagonal blob is the game's colour (`game-lines` sky, `game-fit` mint, `game-sort` peach, `game-merge` lilac) in full colour, with the game's own line icon on top.
- Title `subtitle`, description `note` in `ink-soft`, meta `note-strong`. «Nuevo» / «New» badge in `badge`.
- With a saved game, the card offers to continue it: `meta` «Continuar» / «Continue» with `metaIcon: 'play'`, and tapping the card resumes the game, paused. «Nueva partida» / «New game» moves to a Menu opened from a 48 dp «more» button in the card's top-right corner (`menu`, `menuOpen`, `onMenu`, `menuLabel` «Más opciones» / «More options»). The menu opens towards the side with room: `menuAlign: 'start'` (opens to the right) for cards in the left column, `'end'` (default, opens to the left) for the right column.
