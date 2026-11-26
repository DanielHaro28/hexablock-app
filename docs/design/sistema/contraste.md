# Contraste

WCAG 2.1, texto normal 4,5:1. `ink` pasa en todo; `ink-soft` solo en crema y superficie.

| Fondo | `ink` | `ink-soft` | Ajuste |
| --- | --- | --- | --- |
| `bg` | 9,72 ✓ | 4,87 ✓ | — |
| `surface` | 10,30 ✓ | 5,15 ✓ | — |
| `rose` | 6,13 ✓ | 3,07 ✗ | Usar ink · texto grande: sí |
| `sky` | 6,29 ✓ | 3,15 ✗ | Usar ink · texto grande: sí |
| `butter` | 7,43 ✓ | 3,72 ✗ | Usar ink · texto grande: sí |
| `peach` | 6,46 ✓ | 3,23 ✗ | Usar ink · texto grande: sí |
| `mint` | 7,24 ✓ | 3,62 ✗ | Usar ink · texto grande: sí |
| `lilac` | 6,65 ✓ | 3,33 ✗ | Usar ink · texto grande: sí |
| `sage` | 5,60 ✓ | 2,80 ✗ | Usar ink · texto grande: no |
| `coral` | 4,84 ✓ | 2,42 ✗ | Usar ink · texto grande: no |

## Ajustes

- `ink-soft` no se usa sobre pastel: falla en los 8 (de 2,42 a 3,72:1). Sobre pastel, el texto secundario va en `ink` con Nunito 500 y la jerarquía se marca con tamaño y peso.
- Se descartó un `ink-soft` más oscuro (#5E4C58): aún falla sobre salvia (4,24) y coral (3,67).
- Botones desactivados: `bg` + borde discontinuo + texto `ink-soft` (4,87:1), en lugar de opacidad global.
- Contraste no textual: pasteles contra `surface` entre 1,38 y 2,13:1, compensado con símbolo, `tile-stroke` y contorno del tablero. `butter` sobre `bg` da 1,31:1, por eso HoneyProgressBar lleva borde `ink`.

## Pares usados en componentes

- Número de insignia: `ink` sobre `coral` → 4,84:1
- Botón primario: `ink` sobre `lilac` → 6,65:1
- Botón secundario: `ink` sobre `peach` → 6,46:1
- Botón desactivado: `ink-soft` sobre `bg` → 4,87:1
- Número 2 / 512 / 2048 en Merge: `ink` sobre `butter` → 7,43:1
