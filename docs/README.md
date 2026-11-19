# Documentación de `hexablock-app`

Índice de los documentos de diseño de la app (Flutter + motor genérico en Dart). Los documentos están en español; el `README.md` de la raíz del repo va en inglés (enunciado §6.1).

## Estructura

```
docs/
├── README.md                              ← este índice
├── PENDIENTES.md                          ← lista única de pendientes del PROYECTO (solo vive aquí)
├── DECISIONES.md                          ← decisiones cerradas (D-* y P-*); las compartidas también en hexablock-api
├── adr/
│   └── ADR-001-tech-stack.md              [compartido]
├── architecture/
│   ├── ARQ-00-SISTEMA.md                  [compartido] vista del sistema (app + API + EC2)
│   ├── ARQ-01-APP-GENERAL.md              arquitectura general de este repo
│   ├── ARQ-02-MOTOR.md                    motor genérico: opciones y patrones del dominio (Paso 3)
│   └── ARQ-03-APP-DETALLE.md              casos de uso, puertos, aspectos AOP, patrones y SOLID (Paso 4)
├── diagrams/                              clases.puml (PlantUML), capas.mmd y extensibilidad.mmd (Mermaid) + imágenes .png
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
    ├── CONTEXTO-CONVERSACION.md           foto del estado del proyecto para retomar con una IA
    └── PROMPT-NUEVA-CONVERSACION.md       prompt listo para continuar en una conversación nueva
```

Fuera de `docs/`: `.github/pull_request_template.md` (checklist de autorrevisión) y `tools/reference-sim/` (simulador que verificó los ejemplos de las reglas).

Se irán agregando con los siguientes pasos: `contracts/` (Paso 5) y `ops/`.

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

**Regla:** un cambio en un documento compartido se hace con un PR en cada repo, con el mismo contenido, y se enlazan entre sí. El revisor comprueba que las dos copias queden iguales.

## Orden de lectura sugerido (para integrantes nuevos o para una IA)

1. `ADR-001-tech-stack.md`: qué se usa y por qué.
2. `01-GLOSARIO.md`: el vocabulario.
3. `ARQ-00-SISTEMA.md` y `ARQ-01-APP-GENERAL.md`: cómo está organizado el sistema y la app. `ARQ-02-MOTOR.md`: cómo es el motor por dentro y qué patrones usa. `ARQ-03-APP-DETALLE.md` y `EXTENSIBILITY.md`: casos de uso, aspectos y cómo se extiende.
4. `02-RN-COMUNES.md` y `02-RN-TOPOLOGIAS.md`: cómo funciona cualquier variante.
5. La regla de la variante en la que vas a trabajar (`02-RN-HEXA-*.md`).
6. `03-REQUISITOS.md` y `04-HISTORIAS.md`: qué hay que construir.
7. `SECURITY-BASELINE.md`: antes de tocar autenticación, red o agentes.
8. `DECISIONES.md`: qué está decidido y dónde quedó. `PENDIENTES.md`: qué falta y quién lo hace.

Para retomar la planificación con una IA: `ai/PROMPT-NUEVA-CONVERSACION.md`.
