# LevelBubble

LevelBubble is one level on the level-select screen of Hexa Fit and Hexa Sort.

**Provide:** `level` (number), `state` (`locked`, `available`, `done`), `stars` (0–3 when done), `onClick`.

- A 62×72 hexagon (the playable shape) with the number in `subtitle`; `space-8` above its StarRow.
- Available: `primary` (lilac) with a 3 px `ink` outline. Done: `success` (mint). Locked: `cell-locked` + padlock, no stars.
