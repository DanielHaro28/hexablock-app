# SheetDialog

SheetDialog is the bottom sheet for victory, defeat, leaving a game and account prompts, over a `scrim` (ink 28%).

**Provide:** `title`, `mascot` (`celebrate` for victory, `cup` for defeat, pause or leaving, `wave` for account prompts), optional `stars` (a StarRow, or a number), `body`, `stats` (`{label, value}` ScoreCards, in a row), `footnote` (one `note` line in `ink-soft`) and the actions as `children` (two full-width PillButtons, `width: 342`). `scrim: false` renders the sheet alone.

- `surface`, top corners `radius-card`, padding 12 / 24 / 32, gap `space-16`, a 40×5 `handle`.
- Title `title` (28), body `body`. Defeat copy stays kind: «Tómate un respiro y vuelve a intentarlo.» / «Take a breather and try again.»
- Stats by game:
  - Hexa Lines and Hexa Merge: «Puntaje» / «Score» and «Récord» / «Best».
  - Hexa Fit: no score or best. A StarRow with `earned` and `labels` marks which star was won and which was missed («Completar» / «Complete», «≤ 5 mov.» / «≤ 5 moves», «≤ 1:20»); `body` says what was missing: «Te faltó la de tiempo: termina en 1:20 o menos.» / «You missed the time star: finish in 1:20 or less.»; stats «Tiempo» / «Time» and «Movimientos» / «Moves»; `footnote` the level's best try: «Tu mejor intento: 2★ · 1:12 · 7 mov.» / «Your best try: 2★ · 1:12 · 7 moves».
  - Hexa Sort: «Movimientos» / «Moves» and «Puntaje» / «Score»; `footnote` the level best: «Récord del nivel: 14 mov. · 2 448» / «Level best: 14 moves · 2 448».
- Leaving a game (Hexa Lines and Hexa Merge): the game ends and the best is saved if beaten. Title «¿Salir de la partida?» / «Leave this game?»; body «La partida termina aquí. Tu puntaje (3 420) no supera tu récord (12 850).» / «This game ends here. Your score (3 420) doesn't beat your best (12 850).» or «La partida termina aquí. ¡3 420 será tu nuevo récord!» / «This game ends here. 3 420 will be your new best!»; actions «Seguir jugando» / «Keep playing» (primary) and «Salir» / «Leave» (secondary).
- Guest progress after signing in: title «Tienes progreso como invitado» / «You have progress as a guest», body «¿Lo pasamos a tu cuenta?» / «Shall we move it to your account?», actions «Sí, pasarlo» / «Yes, move it» and «Ahora no» / «Not now». Saying no leaves the guest progress untouched.
