# Prompt para continuar en una conversación nueva

## Cómo usarlo

1. Abre una conversación nueva.
2. **Adjunta estos archivos:**
   - `hexablock-app-docs.zip` (o la carpeta `docs/` del repo `hexablock-app`)
   - `hexablock-api-docs.zip` (o la carpeta `docs/` del repo `hexablock-api`)
   - `Enunciado_ProyectoSemestral_HexaBlockSuite_v1.0_2026-10-23.html` (el enunciado original)
3. **Copia y pega el texto del recuadro** como primer mensaje.
4. Cambia la última línea ("Lo que quiero hacer ahora") por lo que necesites.

---

```text
Hola. Vamos a continuar la planificación del proyecto semestral "HexaBlock Suite".
Te adjunto:
- hexablock-app-docs.zip: documentación del repo de la app (Flutter).
- hexablock-api-docs.zip: documentación del repo del backend (NestJS).
- El enunciado original en HTML (es la fuente de verdad del proyecto).

ANTES DE RESPONDER:
1. Descomprime los dos zips y lee, en este orden:
   a) hexablock-app/docs/ai/CONTEXTO-CONVERSACION.md (foto completa del estado: decisiones, arquitectura, hoja de ruta y reglas de trabajo).
   b) hexablock-app/docs/PENDIENTES.md (decisiones abiertas y cerradas, hoja de ruta y configuración pendiente).
   c) El enunciado completo.
   d) Los documentos que necesites para la tarea, guiándote por el "Mapa de documentos" del contexto y por docs/README.md de cada repo.
2. Confírmame en 3 o 4 líneas en qué paso estamos y cuál es el siguiente, para saber que leíste todo.

REGLAS DE TRABAJO (obligatorias):
- Responde en español. El código, los commits y los README van en inglés.
- No reabras decisiones cerradas (PENDIENTES.md §1.2) salvo que yo lo pida.
- Cada vez que cambies algo o hagas referencia a un documento, actualiza ese documento en el momento y entrégamelo, incluido PENDIENTES.md. Al terminar, entrégame también los zips de los dos repos actualizados.
- Los documentos compartidos (ADR-001, SECURITY-BASELINE, ARQ-00-SISTEMA, 01-GLOSARIO, 02-RN-NIVELES, 02-RN-CUENTA-PROGRESO-RANKING) deben quedar idénticos en los dos repos.
- Las decisiones de diseño las toma el equipo (enunciado §7.3): propón opciones con ventajas y desventajas y una recomendación, pero no decidas por nosotros. Lo que el enunciado no especifica lo decide el equipo (indicación del profesor).
- Verifica con código cualquier ejemplo de reglas (tableros, fórmulas) antes de escribirlo; el simulador de referencia está en hexablock-app/tools/reference-sim/ (si no viene en el zip, recréalo a partir de las reglas). Renderiza los diagramas Mermaid para comprobar que funcionan.
- Mantén los IDs existentes (RN-*, RF-*, RNF-*, historias, E-*, SEC-*, ARQ-*, D-*) y nunca reutilices uno.
- Registra las decisiones nuevas en PENDIENTES.md (abiertas con recomendación, o cerradas con fecha y dónde quedaron) y actualiza CONTEXTO-CONVERSACION.md.

Lo que quiero hacer ahora: [ESCRIBE AQUÍ, por ejemplo: "empezar el Paso 3 (motor genérico): prepárame opciones para las preguntas de ARQ-01-APP-GENERAL.md §10"]
```

---

## Si la herramienta no acepta zips

Adjunta como mínimo estos archivos sueltos y menciona en el prompt que son los únicos disponibles:

1. `docs/ai/CONTEXTO-CONVERSACION.md`
2. `docs/PENDIENTES.md`
3. El enunciado
4. Los documentos de la tarea concreta. Por ejemplo, para el Paso 3: `ARQ-01-APP-GENERAL.md`, `02-RN-COMUNES.md`, `02-RN-TOPOLOGIAS.md` y los cuatro `02-RN-HEXA-*.md`.

## Si vas a continuar en Claude Code (dentro del repo)

El repo ya tiene todo en `docs/`, así que basta con un prompt corto:

```text
Lee docs/ai/CONTEXTO-CONVERSACION.md y docs/PENDIENTES.md antes de hacer nada, y sigue sus reglas de trabajo.
Lo que quiero hacer ahora: [...]
```

En el Paso 8 se creará `CLAUDE.md`, que hará esto automáticamente.
