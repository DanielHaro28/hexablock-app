# Catálogo de niveles

Generado por `tools/reference-sim/levelcheck.py`; no se edita a mano. **Estado: candidatos** propuestos por el generador (D-53) que el equipo debe jugar, ajustar y aprobar, y que esperan la respuesta del profesor (P-14).

## Hexa Fit (15, hexágonos)

| # | Id | Nombre | Piezas | Celdas | Soluciones | Esfuerzo (nodos) | `m` | `t` |
|---|---|---|---|---|---|---|---|---|
| 1 | `fit-hex-001` | Primer encaje / First fit | 2 | 6 | 2 | 7 | 3 | 40 s |
| 2 | `fit-hex-002` | Dos mitades / Two halves | 2 | 8 | 2 | 8 | 3 | 40 s |
| 3 | `fit-hex-003` | Trío / Trio | 3 | 10 | 2 | 18 | 4 | 60 s |
| 4 | `fit-hex-004` | Panal chico / Small honeycomb | 3 | 11 | 4 | 23 | 4 | 60 s |
| 5 | `fit-hex-005` | Escalera / Staircase | 3 | 13 | 1 | 28 | 4 | 60 s |
| 6 | `fit-hex-006` | Cuatro esquinas / Four corners | 4 | 14 | 8 | 98 | 5 | 80 s |
| 7 | `fit-hex-007` | Mosaico / Mosaic | 4 | 16 | 4 | 127 | 5 | 80 s |
| 8 | `fit-hex-008` | Colmena / Beehive | 4 | 18 | 1 | 142 | 5 | 80 s |
| 9 | `fit-hex-009` | Pétalos / Petals | 5 | 20 | 2 | 247 | 6 | 100 s |
| 10 | `fit-hex-010` | Rompecabezas / Jigsaw | 5 | 22 | 1 | 323 | 6 | 100 s |
| 11 | `fit-hex-011` | Isla / Island | 5 | 24 | 6 | 396 | 6 | 100 s |
| 12 | `fit-hex-012` | Constelación / Constellation | 6 | 26 | 3 | 849 | 7 | 120 s |
| 13 | `fit-hex-013` | Laberinto / Maze | 6 | 29 | 2 | 1156 | 7 | 120 s |
| 14 | `fit-hex-014` | Gran panal / Great honeycomb | 7 | 32 | 2 | 3460 | 8 | 140 s |
| 15 | `fit-hex-015` | Obra maestra / Masterpiece | 7 | 35 | 1 | 4983 | 8 | 140 s |

## Hexa Sort (10)

| # | Id | Nombre | Figura | Metas | Colores | Pilas iniciales | Voraz | Haz de 30 |
|---|---|---|---|---|---|---|---|---|
| 1 | `sort-any-001` | Primer orden / First sort | any | 1 | 3 | 0 | 6 mov., 111 pts | 6 mov. |
| 2 | `sort-any-002` | Dos torres / Two towers | any | 2 | 3 | 0 | 9 mov., 224 pts | 7 mov. |
| 3 | `sort-any-003` | Tres en raya / Three in a row | any | 3 | 3 | 0 | 11 mov., 326 pts | 11 mov. |
| 4 | `sort-any-004` | Arcoíris / Rainbow | any | 3 | 4 | 0 | 14 mov., 334 pts | 11 mov. |
| 5 | `sort-any-005` | Cascada / Cascade | any | 5 | 4 | 0 | 19 mov., 542 pts | 18 mov. |
| 6 | `sort-any-006` | Torbellino / Whirlpool | any | 5 | 5 | 0 | 22 mov., 546 pts | 19 mov. |
| 7 | `sort-hex-007` | Obstáculos / Obstacles | hex | 8 | 5 | 2 | 30 mov., 873 pts | 20 mov. |
| 8 | `sort-hex-008` | Encrucijada / Crossroads | hex | 8 | 5 | 3 | 31 mov., 882 pts | 23 mov. |
| 9 | `sort-hex-009` | Tormenta / Storm | hex | 10 | 6 | 3 | 37 mov., 1082 pts | 30 mov. |
| 10 | `sort-hex-010` | Gran final / Grand finale | hex | 12 | 6 | 4 | 42 mov., 1307 pts | 38 mov. |

La columna **Voraz** es lo que logra un jugador que elige siempre la mejor jugada inmediata; **Haz de 30** mira varias jugadas adelante. Las dos ganan todos los niveles. Verificado solo en hexágonos; los niveles `any` se prueban en las otras figuras cuando cada una esté implementada.

## Figuras de Hexa Fit

Cada letra es la pieza que cubre esa celda en la solución de referencia. El jugador ve la figura vacía y las piezas en la bandeja, cada una en otra orientación.

### 1. Primer encaje (`fit-hex-001`)

```
       A    r=-1
    B B A    r=+0
     B A    r=+1
```

### 2. Dos mitades (`fit-hex-002`)

```
   A A    r=-1
    B A    r=+0
   B B B    r=+1
    B    r=+2
```

### 3. Trío (`fit-hex-003`)

```
   C C C    r=-1
  B B B    r=+0
   A A    r=+1
  A A    r=+2
```

### 4. Panal chico (`fit-hex-004`)

```
    C    r=-2
   C A    r=-1
  C A A    r=+0
   B A A    r=+1
    B A    r=+2
```

### 5. Escalera (`fit-hex-005`)

```
     C C A A    r=-1
    C B B A    r=+0
   C C A A    r=+1
    C    r=+2
```

### 6. Cuatro esquinas (`fit-hex-006`)

```
  B B    r=-2
 A B B C    r=-1
  A C C    r=+0
 D D C    r=+1
  D D    r=+2
```

### 7. Mosaico (`fit-hex-007`)

```
D D D D    r=-2
 C A D  C    r=-1
C A B B    r=+0
 C A A    r=+1
  C    r=+2
```

### 8. Colmena (`fit-hex-008`)

```
    B B B    r=-2
   A A B D    r=-1
  C A A C D D    r=+0
   C C C D D    r=+1
```

### 9. Pétalos (`fit-hex-009`)

```
   E    r=-3
  E B A C    r=-2
 E B A C C    r=-1
  B A A C    r=+0
   D D C C    r=+1
      D D    r=+2
```

### 10. Rompecabezas (`fit-hex-010`)

```
    C C    r=-2
   C C A D D    r=-1
  A A A B D    r=+0
   B B B B B    r=+1
    E E E    r=+2
     E E    r=+3
```

### 11. Isla (`fit-hex-011`)

```
         A A    r=-3
        C A A    r=-2
       C B A B    r=-1
      C C B B    r=+0
     E C D D    r=+1
      E D D    r=+2
       E E    r=+3
        E E    r=+4
```

### 12. Constelación (`fit-hex-012`)

```
       D D    r=-3
      A A D D E    r=-2
     C A B B E E    r=-1
    F C A B B    r=+0
     F C A B    r=+1
    F F F    r=+2
       F    r=+3
```

### 13. Laberinto (`fit-hex-013`)

```
       E    r=-3
    E E E    r=-2
 F F E A E    r=-1
  F C A A B    r=+0
 F C C B B D    r=+1
    C B B D D    r=+2
     C B D D    r=+3
```

### 14. Gran panal (`fit-hex-014`)

```
   F F    r=-3
  F F F F    r=-2
 C C C A E    r=-1
  C C A A E    r=+0
 C A A B E E    r=+1
  D B B E G    r=+2
   D D B G G    r=+3
```

### 15. Obra maestra (`fit-hex-015`)

```
         G    r=-5
          G    r=-4
         G G G    r=-3
        G C D D    r=-2
       C C C B D    r=-1
      E C C A B B    r=+0
   F E E A A A B    r=+1
    F F E E A B    r=+2
     F E    r=+3
```
