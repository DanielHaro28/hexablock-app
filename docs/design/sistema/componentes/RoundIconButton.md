# RoundIconButton

RoundIconButton is a circular icon action, optionally with a coral count badge.

**Provide:** `icon`, `label` (spoken name — required, the icon has no text), optional `badge` (number), `size` (56 default, 48 in the TopBar and tray), `disabled`.

- `surface` circle with `shadow-soft`, icon 24 in `ink`. Badge: 22 high, `badge` (coral) with `ink` Fredoka 13 (4,84:1), 2 px `surface` ring, at (−4, −4).
- Disabled: `bg` + dashed `ink-soft` border + `ink-soft` icon.
- Undo by game: Fit undo/redo unlimited, back to the level's start; Merge one undo then disabled; Lines and Sort do not show it at all (absent, not disabled).
- A badge on Undo counts the steps that can be undone right now; it is never a limit. In Hexa Fit it grows with every step and never blocks undoing.
- «Cómo jugar» / «How to play»: a «?» button in the TopBar of every game and on the pause screen. Use the `help` icon.
