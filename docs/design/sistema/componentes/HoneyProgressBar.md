# HoneyProgressBar

HoneyProgressBar is the loading bar of the splash screen, reusable for level downloads and Hexa Sort goals.

**Provide:** `value` (0–100), `label` (spoken), optional `width` (200).

- 8 high, `track` (ink 10%) with a `butter` fill and a `border-progress` (1.5 px) `ink` border — butter on `bg` is only 1,31:1, the ink border brings the indicator to 9,72:1.
- Each step animates in 180 ms ease-out. Pair it with a live `note-strong` status line in `ink-soft`: «Abriendo tu panal… 68 %».
