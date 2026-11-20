---
paths:
  - "app/**"
---

# App Flutter (capas 3 y 4)

- **Capa 3, `app/lib/adapters/`**: presentadores (Cubits), repositorios Drift, gateways HTTP con `dio`, codecs del estado y mappers. **Capa 4, `app/lib/frameworks/` y `app/lib/config/`**: widgets, red, persistencia y el *composition root* con `get_it` (ARQ-03-APP §6).
- **Un solo `GameCubit<C, TCell, TMove, TState>`** para las 4 variantes; cada variante aporta su módulo (`VariantModule`), su pintor de celdas y su codec.
- **Sin reglas de juego en los widgets ni en los Cubits**: la pantalla muestra lo que devuelve el caso de uso.
- **Textos**: siempre en los ARB de español e inglés, nunca escritos en el widget (D-64, RNF-50).
- **Diseño**: el de `docs/design/` con los ajustes aceptados en `docs/design/REVISION-DISENO.md` (D-66).
- **El JWT** solo en `flutter_secure_storage`, nunca en `shared_preferences` ni en Drift (SEC-MOB-01). La URL de la API llega por `--dart-define=API_BASE_URL` y nada más se embebe en el APK (SEC-MOB-02).
- Los mappers de la API se prueban con los ejemplos de `docs/contracts/examples/`.
