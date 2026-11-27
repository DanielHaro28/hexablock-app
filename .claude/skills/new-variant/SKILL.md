---
name: new-variant
description: Add a fifth game variant following docs/EXTENSIBILITY.md, and prove that the engine and the use cases were not modified.
argument-hint: "[variant name, e.g. hexa-fill]"
disable-model-invocation: true
---

Nueva variante: **$ARGUMENTS**. Es la prueba de extensibilidad de la defensa (enunciado §3.1, RNF-03, F-09): agregar una variante son **clases nuevas y registro en configuración**, sin tocar el motor, los casos de uso ni las otras variantes. Todo lo que hagas aquí lo puede revisar el jurado, así que el resultado tiene que poder mostrarse con un `git diff`.

La guía es `docs/EXTENSIBILITY.md` §2; síguela paso a paso y en orden. Sus rutas son las del código real, con Hexa Lines como modelo (D-130). Si aun así algo no coincide, **sigue el código** y anota la diferencia para el usuario.

## 0. Antes de escribir

- **Reglas primero.** Si no existe `docs/requirements/02-RN-<VARIANTE>.md`, redáctalo con el usuario: las reglas de juego las decide el equipo, no las inventes (CLAUDE.md, regla 5). De ellas sale qué archivos opcionales hacen falta: si hay azar (fuente de piezas, `IRandomSeeded`), si es por niveles (`ILevelBased`, constructor de niveles) y si el criterio de progreso es nuevo.
- **Ramas.** `feat/<variante>` desde `main` actualizado. Si llegas al paso 6, la misma rama en `../hexablock-api` (`/paired-change`).
- Resume el plan al usuario (archivos por capa, qué opcionales lleva y por qué) y espera el "ok".

## 1. Reglas (paso 1)

- IDs nuevos con un prefijo propio (`RN-<XX>-*`, `E-<XX>-*`) que no choque con los existentes.
- Agrega la variante al simulador de referencia (`tools/reference-sim/`), verifica cada ejemplo `E-*` y corre `python3 -I tools/docs-check/check_examples.py tools/reference-sim`. Un ejemplo sin verificar no entra (`.claude/rules/docs.md`).

## 2. Dominio, configuración, adaptadores y frameworks (pasos 2 a 5)

Crea los archivos de las tablas de la guía. Lo que más se equivoca:

- Las reglas extienden `GameRules` e implementan solo los pasos (`rejectionOf`, `apply`, `validMoves` y los *hooks* que hagan falta). **Nunca `playTurn`** (D-36).
- La fábrica (`VariantFamily`) entrega **solo** las capacidades que la variante tiene, con `createSession` y `continueSession` (D-111, D-116).
- Las reglas usan las operaciones de `GridTopology`, nunca una figura concreta: la variante tiene que funcionar con cualquier figura (RNF-04).
- **Textos:** en los ARB de español y de inglés, nunca escritos en el widget (RNF-50, D-64 punto 5).
- **Pantalla:** el pintor de celdas sigue `docs/design/` con los ajustes de `REVISION-DISENO.md` (D-66). Si el diseño no tiene nada para esta variante, pregunta al usuario: el diseño también es una decisión del equipo.
- **Niveles** (si es por niveles): en el esquema común con la sección propia de la variante (RN-COM-70), revisados con `python3 -I tools/reference-sim/levelcheck.py`, que regenera `docs/levels/CATALOGO.md`. Siguen D-28, D-54 y D-55; la API guarda una copia (D-61), así que van también en el PR de la API.

Las líneas modificadas de archivos existentes son las del grupo **Registro** de la guía (§0): los `export` de `hexa_variants.dart`, el módulo y la carga de su JSON en `app/lib/config/dependencies.dart`, su tarjeta en `app/lib/config/game_catalog.dart`, la entrada de `tools/variants.json` y, si hace falta, las carpetas de *assets* de `app/pubspec.yaml`.

## 3. Backend y contrato (paso 6)

- En `hexablock-api`, agrega el `gameId` a la configuración de juegos permitidos (SEC-API-06).
- **El contrato enumera los `gameId`**: `docs/contracts/schemas/common.schema.json` (y las condiciones de `progress.schema.json` si la variante es por niveles o por récord) rechaza un `gameId` que no esté en la lista. Se cambia en la fuente, `../hexablock-api/docs/contracts/`, y se copia a este repo con `/paired-change` (D-23). Sin esto, la variante no puede guardar ni sincronizar progreso.

## 4. Herramientas: una entrada en `tools/variants.json`

Las herramientas leen las variantes de un solo registro (D-130). Agrega la entrada **antes** de crear la carpeta: `gameId`, el prefijo de las clases (`HexaFill`), la carpeta (`hexa_fill`), el prefijo de reglas e historias y cuántos niveles trae (o `null`). Con eso:

- `tool/check_architecture.dart` prohíbe sus nombres en el motor y en los casos de uso (RNF-02, RNF-07) y falla si la carpeta, la de niveles o el `enum` del contrato no coinciden con el registro.
- `tools/docs-check/check_ids.py` revisa sus `RN-<XX>-*` y sus historias.
- `tools/reference-sim/levelcheck.py` cuenta sus niveles y falla hasta que tenga su sección de validación (si es por niveles).

`tools/docs-check/check_examples.py` sí cambia: sus ejemplos son reglas nuevas, con sus verificaciones nuevas (sección 1).

Y hay documentos que enumeran las variantes. Búscalos (`grep -rn "hexa-merge" docs/`) y muéstraselos al usuario:

- **RN-COM-01** dice que son exactamente 4 variantes. Es una regla cerrada: cambiarla va con `/rule-change` y la decide el equipo.
- El glosario compartido y los documentos de datos de los dos repos se cambian con `/paired-change`.

No son cambios del motor, pero **sí son líneas modificadas**: muéstraselas al usuario aparte en la comprobación final, para que la defensa las explique en vez de que el jurado las encuentre.

## 5. Pruebas (paso 7)

Las cuatro de la guía: un `group` por cada ejemplo `E-*` con su ID (`should_<resultado>_when_<condición>`, AAA), la de determinismo con semilla fija, el contrato de la fábrica (`checkVariantFamilyContract`) y el codec de ida y vuelta. Si es por niveles o por récord, también la prueba de integración de progreso de la variante: jugar hasta ganar, guardar, sincronizar y volver a leer (`docs/testing/ESTRATEGIA-PRUEBAS.md` §3).

## 6. Diagramas y documentos

- **Diagrama:** agrega las clases nuevas a `docs/diagrams/clases-variantes.puml` y exporta su imagen (no más de 1 MB ni de 4096 px, D-73). Si pasa de unas 40 clases, la imagen deja de leerse (D-76): propón al usuario partirlo y espera la respuesta.
- **Trazabilidad:** las reglas y pruebas nuevas en `docs/requirements/05-TRAZABILIDAD.md`. Si hay historias nuevas, van en `04-HISTORIAS.md` con el equipo.
- **La guía:** si encontraste diferencias entre `EXTENSIBILITY.md` y el código, o la variante necesitó tocar algo que la guía no lista, díselo al usuario: la guía es lo que se presenta en la defensa.

## 7. Comprobación final

Corre y muéstrale al usuario la salida de cada comando:

```bash
# Tienen que salir vacíos: el motor, los casos de uso y las otras variantes no cambian
git diff main...HEAD --stat -- packages/hexa_engine packages/hexa_application
git diff main...HEAD --stat -- packages/hexa_variants/lib/src/hexa_lines packages/hexa_variants/lib/src/hexa_fit packages/hexa_variants/lib/src/hexa_sort packages/hexa_variants/lib/src/hexa_merge
# Los archivos existentes que sí cambiaron: solo los de registro, la copia del contrato y los de la sección 4
git diff main...HEAD --diff-filter=M --name-only
```

Después, las mismas revisiones del CI: `dart analyze`, las pruebas de cada paquete y de la app, `dart run tool/check_architecture.dart`, `dart run tool/check_examples_covered.dart` y los scripts de `tools/docs-check/`.

Si un comando del primer bloque no sale vacío, **detente**: es una señal de diseño que el equipo tiene que ver, no algo que se arregla en esta rama.

## 8. Revisión y PR

`architecture-reviewer` sobre los archivos cambiados (y `security-reviewer` si tocaste la API), `/ai-usage` y los PR. Si hubo paso 6, son dos PR enlazados con el mismo nombre de rama. Pega la salida de la comprobación final en la descripción del PR de la app: es la evidencia de RNF-03.
