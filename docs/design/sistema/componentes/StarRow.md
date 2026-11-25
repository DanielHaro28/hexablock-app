# StarRow

StarRow shows up to 3 stars, earned or missed.

**Provide:** `count` (the first `count` stars are earned), or `earned` — one boolean per star — when stars are independent, as in Hexa Fit; optional `labels` (one caption per star), `size` (16 under a LevelBubble, gap 4; 32 in the victory sheet, gap 8) and `label` (spoken summary).

- Earned: `star` (butter) with an `ink` outline. Not earned: dashed `ink-soft` outline, no fill — the difference is shape, not only colour.
- Hexa Fit stars are independent and always in this order: complete the level, moves ≤ m, time ≤ t. Any of the last two can be missed alone, so pass `earned` (`[true, true, false]`), never a count.
- On the victory sheet, caption each star: «Completar» / «Complete», «≤ 5 mov.» / «≤ 5 moves», «≤ 1:20». An earned caption is `note-strong` in `ink`; a missed one is `note` in `ink-soft`. Spoken label: «2 de 3 estrellas; te faltó la de tiempo» / «2 of 3 stars; you missed the time star».
