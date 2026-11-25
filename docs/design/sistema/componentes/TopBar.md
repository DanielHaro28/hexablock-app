# TopBar

TopBar is the 72-high bar on top of every play screen: back, title, «How to play» and settings.

**Provide:** `title` («Hexa Sort · Nivel 6»), optional `onBack`, `onAction`, `onHelp` (or `help: true`) to show the «?» button, `leftIcon`/`rightIcon` (pass `rightIcon: null` to hide the right button), `helpLabel`.

- Transparent over `bg`, padding 0 16, gap `space-8`, 48 dp RoundIconButtons, title in `subtitle`, centred.
- The title may take two lines (the bar grows from 72); it is never cut. With three buttons, long titles such as «Clasificación · Hexágonos» / «Leaderboard · Hexagons» wrap.
- «?» opens «Cómo jugar» / «How to play». It is in the TopBar of every game; on the pause screen it is a RoundIconButton with the `help` icon. If the story doesn't make the release, hide it — never show it disabled.
