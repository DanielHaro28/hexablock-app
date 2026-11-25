# Documentación de `hexablock-app`

Índice de los documentos de diseño de la app (Flutter + motor genérico en Dart). Los documentos están en español; el `README.md` de la raíz del repo va en inglés (enunciado §6.1).

## Estructura

```
docs/
├── README.md                              ← este índice
├── PENDIENTES.md                          ← decisiones abiertas y preguntas al profesor del PROYECTO (solo vive aquí); las tareas son Issues (D-69)
├── DECISIONES.md                          ← decisiones cerradas (D-* y P-*); las compartidas también en hexablock-api
├── adr/
│   └── ADR-001-tech-stack.md              [compartido]
├── architecture/
│   ├── ARQ-00-SISTEMA.md                  [compartido] vista del sistema (app + API + EC2)
│   ├── ARQ-01-APP-GENERAL.md              arquitectura general de este repo
│   ├── ARQ-02-MOTOR.md                    motor genérico: diseño final, patrones del dominio y, en el anexo, las opciones descartadas (Paso 3)
│   ├── ARQ-03-APP-DETALLE.md              casos de uso, puertos, aspectos AOP, patrones y SOLID (Paso 4)
│   └── ARQ-04-APP-DATOS.md                tablas Drift, sincronización, niveles disponibles y migraciones (Paso 5)
├── contracts/                             COPIA idéntica de hexablock-api/docs/contracts/ (D-23); no se edita aquí
├── design/
│   ├── HexaBlock-Suite-Diseno-v1.pdf      diseño inicial de @dicpc (59 pantallas); historial desde el 25-11
│   ├── REVISION-DISENO.md                 revisión del diseño contra las reglas: DIS-01 a DIS-16 aceptadas; conciliación y DIS-17 a DIS-24 (25-11)
│   ├── sistema/                           COPIA del sistema de diseño de @dicpc (fuente visual, D-144); no se edita aquí
│   │   ├── README.md                      principios, color, tipografía, movimiento, textos y marcadores por juego
│   │   ├── decisiones.md, contraste.md    decisiones de diseño y contraste WCAG de cada par de colores
│   │   ├── handoff-flutter.md             widget sugerido, medidas y colores de cada componente
│   │   ├── pantalla-carga.md              pantalla de carga y error de lectura, con su animación
│   │   ├── tokens.json                    tokens de color, tipografía, espaciado, radios y sombras
│   │   └── componentes/                   guía de cada componente (en inglés, como en el origen)
│   └── pantallas/                         una captura PNG por pantalla del prototipo (REVISION-DISENO §1)
├── plan/
│   └── PLAN-ENTREGA.md                    equipo, milestones, tablero, Issues y hoja de ruta de la planificación (Paso 7)
├── levels/                                CATALOGO.md e informe del generador de los niveles de app/assets/levels/ (Paso 6)
├── testing/
│   └── ESTRATEGIA-PRUEBAS.md              pirámide, dobles, cobertura, pruebas del código de IA y CI (Paso 6)
├── diagrams/                              clases.puml (general) + clases-motor, clases-variantes y clases-aplicacion (PlantUML, D-76); capas.mmd, extensibilidad.mmd y datos.mmd (Mermaid) + imágenes .png
├── EXTENSIBILITY.md                       cómo agregar una 5ª variante, una figura o un cambio de regla (§3.1)
├── security/
│   └── SECURITY-BASELINE.md               [compartido]
├── requirements/
│   ├── 01-GLOSARIO.md                     [compartido]
│   ├── 02-RN-COMUNES.md                   formato, notación, turno, estados, azar, puntuación, deshacer, idioma
│   ├── 02-RN-TOPOLOGIAS.md                hexágonos, cuadrados, triángulos y cubos
│   ├── 02-RN-HEXA-LINES.md
│   ├── 02-RN-HEXA-FIT.md
│   ├── 02-RN-HEXA-SORT.md
│   ├── 02-RN-HEXA-MERGE.md
│   ├── 02-RN-NIVELES.md                   [compartido]
│   ├── 02-RN-CUENTA-PROGRESO-RANKING.md   [compartido]
│   ├── 03-REQUISITOS.md                   RF y RNF de la app
│   ├── 04-HISTORIAS.md                    historias de la app
│   └── 05-TRAZABILIDAD.md                 enunciado → RF → HU → RN → pruebas (app)
└── ai/
    └── APPROVED-TOOLS.md                  [compartido] herramientas de IA y servidores MCP aprobados (D-86)
```

Fuera de `docs/`: `CLAUDE.md`, `.claude/` y `.mcp.json` (configuración de Claude Code, paso 8), `SECURITY.md` (cómo reportar una vulnerabilidad, D-74), `.github/pull_request_template.md` (checklist de autorrevisión), `.github/workflows/docs-check.yml` (revisión automática de los documentos de los dos repos), `tools/docs-check/` (los scripts de esa revisión, D-72) y `tools/reference-sim/` (simulador que verificó los ejemplos de las reglas y herramientas de niveles).

## Reglas de los documentos

- **Decisiones:** `DECISIONES.md` es el único registro y se edita a mano (D-67, D-72). Los demás documentos citan los IDs.
- **Tareas:** son Issues de los dos repos, en el [tablero](https://github.com/users/DanielHaro28/projects/1) (D-69). `PENDIENTES.md` solo tiene decisiones abiertas y preguntas.
- **Binarios:** ningún archivo de más de 1 MB, salvo el PDF del diseño; las versiones nuevas del diseño van como enlace o como PNG de las pantallas que cambian (D-73). Lo comprueba el CI.
- **Seguridad:** nada que no pueda ser público. Ni secretos, ni correos, ni datos de cuentas (AWS, facturación), ni el keystore (SEC-MOB-07): los secretos van en los environments de GitHub.

Se irá agregando con los siguientes pasos: `ops/`.

## Documentos compartidos con `hexablock-api`

Los marcados **[compartido]** existen en los dos repos y deben ser **idénticos**:

| Documento | Por qué se comparte |
|---|---|
| `adr/ADR-001-tech-stack.md` | El stack, la infraestructura y el flujo de trabajo afectan a ambos |
| `architecture/ARQ-00-SISTEMA.md` | Cómo se reparten las responsabilidades entre app y API |
| `security/SECURITY-BASELINE.md` | Controles de app, backend, CI y agentes |
| `requirements/01-GLOSARIO.md` | Mismo vocabulario en ambos repos |
| `requirements/02-RN-NIVELES.md` | La app y el backend validan niveles |
| `requirements/02-RN-CUENTA-PROGRESO-RANKING.md` | La app y el backend consolidan el progreso con la misma regla |
| `ai/APPROVED-TOOLS.md` | Las mismas herramientas de IA en los dos repos (SEC-AGT-04) |

**Regla:** un cambio en un documento compartido se hace con un PR en cada repo, con el mismo contenido, y se enlazan entre sí. El CI de documentos comprueba que las dos copias queden iguales; para eso, los dos PR usan el mismo nombre de rama (D-72).

## Orden de lectura sugerido (para integrantes nuevos o para una IA)

1. `ADR-001-tech-stack.md`: qué se usa y por qué.
2. `01-GLOSARIO.md`: el vocabulario.
3. `ARQ-00-SISTEMA.md` y `ARQ-01-APP-GENERAL.md`: cómo está organizado el sistema y la app. `ARQ-02-MOTOR.md`: cómo es el motor por dentro y qué patrones usa. `ARQ-03-APP-DETALLE.md` y `EXTENSIBILITY.md`: casos de uso, aspectos y cómo se extiende.
4. `02-RN-COMUNES.md` y `02-RN-TOPOLOGIAS.md`: cómo funciona cualquier variante.
5. La regla de la variante en la que vas a trabajar (`02-RN-HEXA-*.md`).
6. `03-REQUISITOS.md` y `04-HISTORIAS.md`: qué hay que construir.
7. `SECURITY-BASELINE.md`: antes de tocar autenticación, red o agentes.
8. `DECISIONES.md`: qué está decidido y dónde quedó. `PENDIENTES.md`: qué falta y quién lo hace.

Para trabajar con Claude Code: `CLAUDE.md` en la raíz del repo y la carpeta `.claude/` (reglas por carpeta, permisos, hooks, subagentes y skills, D-79 a D-84). Reemplazan a la antigua carpeta `docs/ai/` de contexto y prompt (D-70).
