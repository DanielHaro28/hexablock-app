# PillButton

PillButton is the main action: everything you tap is a pill or a circle, never a hexagon.

**Provide:** `children` (label), `variant` (`primary` = `lilac`, `secondary` = `peach`), optional `icon` (an Icon name), `disabled`, `width` (342 for full-width sheet actions).

- Height 56 (min), padding 0 24, min width 120, text `subtitle` (Fredoka 600, 22) in `ink`: 6,65:1 on lilac, 6,46:1 on peach.
- Pressed: no outer shadow, `shadow-pressed`, moves down 2 px. Disabled: `bg` fill, 2 px dashed `ink-soft` border, `ink-soft` text (4,87:1) — never global opacity.
- Labels may wrap to 2 lines; the button grows rather than truncating (English can run ~30% longer).
- Pair at most one primary with one secondary: «Siguiente nivel» / «Repetir», «Reintentar» / «Volver al menú».
