# 03 — Requisitos funcionales y no funcionales · App (`hexablock-app`)

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo |
| Fecha | 2026-11-11 |
| Repositorio | `hexablock-app` (`docs/requirements/03-REQUISITOS.md`). Los requisitos del backend están en el mismo archivo del repo `hexablock-api` |
| Relacionados | `02-RN-*.md` (cómo funciona cada regla), `04-HISTORIAS.md` (criterios de aceptación), `05-TRAZABILIDAD.md` |

**Requisitos compartidos:** los RF de cuenta, sincronización, ranking y niveles remotos (RF-70 a 82) tienen una **parte de la app** (aquí) y una **parte del servidor** (en `hexablock-api`), con el **mismo ID**.

**Cómo se reparte el contenido:**
- Un **RF** dice **qué** hace el sistema, en una línea, y apunta a las reglas (RN) que dicen **cómo**.
- Un **RNF** es un atributo de calidad **medible**, con su forma de **verificación**.
- Los criterios de aceptación detallados están en las **historias de usuario**.

**Prioridad (MoSCoW):** **Must** = exigido por el enunciado o por el profesor; **Should** = importante, no exigido; **Could** = si sobra tiempo.

---

## 1. Requisitos funcionales

### 1.1 Navegación y experiencia general

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-01 | Muestra una pantalla de inicio con el nombre de la suite, acceso a ajustes y un selector con las 4 variantes | RN-COM-01 | Enunciado §5.1 (1) | Must |
| RF-02 | Muestra una pantalla de selección de niveles para Hexa Fit y Hexa Sort, con el estado de cada nivel (bloqueado, disponible, completado) y su progreso | RN-COM-73, RN-HF-72, RN-HS-72 | §5.1 (2) | Must |
| RF-03 | Permite cambiar el idioma (español/inglés) sin reiniciar y conserva la elección | RN-COM-110, RN-COM-112 | §5.1 (11) | Must |
| RF-04 | Reproduce música de fondo y efectos de sonido, silenciables por separado, y conserva la elección | RN-COM-111 | §5.1 (10) | Must |
| RF-05 | Permite pausar la partida (continuar, reiniciar, salir) y la pausa automáticamente al pasar a segundo plano | RN-COM-24, RN-COM-30 a 32 | §3.3 (State) | Must |
| RF-06 | Muestra una pantalla de victoria con la puntuación obtenida y las opciones de siguiente nivel o nueva partida (y "seguir jugando" en Hexa Merge) | RN-COM-31, RN-HF-64, RN-HS-61, RN-HM-51 | §5.1 (7) | Must |
| RF-07 | Muestra una pantalla de derrota / fin de partida con la puntuación, el récord y la opción de reintentar | RN-COM-31 | §5.1 (7) | Must |
| RF-09 | Permite elegir en Ajustes la **figura de las celdas** entre las disponibles; la figura queda fija durante cada partida (la opción se bloquea mientras haya una en curso o en pausa) | RN-COM-113, RN-TOP-30 a 34 | Decisión del equipo (D-25) | Should |
| RF-08 | Muestra las reglas de cada variante ("Cómo jugar") en el idioma elegido | — | No exigido | Could |

### 1.2 Motor común

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-10 | Ejecuta las 4 variantes sobre un único motor genérico: tablero, piezas, movimientos, resolución y fin de partida compartidos | RN-COM-10 a 25 | §5.1 (3), §3.1 | Must |
| RF-11 | Ignora los movimientos inválidos sin cambiar el estado | RN-COM-21 | Diseño | Must |
| RF-12 | Notifica en orden cada efecto de la resolución para animarlo y sonorizarlo | RN-COM-25 | §3.3 (Observer) | Must |

### 1.3 Hexa Lines

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-20 | Permite jugar Hexa Lines en modo sin fin, con tablero de radio 4 y bandeja de 3 piezas generadas con semilla | RN-HL-10, 11, 20 a 25 | §1.1, §5.1 (4) | Must |
| RF-21 | Permite colocar una pieza arrastrándola, con vista previa de validez, si todas sus celdas están dentro y libres | RN-HL-30 a 32 | §1.1 | Must |
| RF-22 | Elimina las líneas completas de todos los ejes y puntúa con bono, combo y racha | RN-HL-40 a 44, 60 a 64 | §1.1 | Must |
| RF-23 | Termina la partida cuando ninguna pieza de la bandeja cabe | RN-HL-50 a 52 | §1.1 | Must |
| RF-24 | Muestra el puntaje y el récord, y guarda el récord | RN-HL-70, 71 | §5.1 (4) | Must |

### 1.4 Hexa Fit

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-30 | Ofrece al menos 15 niveles de Hexa Fit diseñados a mano, cargados desde archivos de configuración y con dificultad creciente | RN-COM-03, RN-HF-10 a 13 | §1.2, §5.1 (5) | Must |
| RF-31 | Permite colocar, mover y retirar piezas dentro de la figura, sin solapamientos ni celdas fuera | RN-HF-30, 32 a 34 | §1.2 | Must |
| RF-32 | Permite rotar las piezas de la bandeja con el giro básico de la topología (60° en hexágonos) | RN-COM-14, RN-HF-31 | §1.2 | Must |
| RF-33 | Permite deshacer y rehacer sin límite | RN-HF-80 a 82 | §1.2, §5.1 (8) | Must |
| RF-34 | Detecta la figura cubierta, calcula las estrellas (movimientos y tiempo) y guarda el mejor intento | RN-HF-50 a 52, 60 a 64, 70, 71 | §1.2 | Must |

### 1.5 Hexa Sort

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-40 | Ofrece al menos 10 niveles de Hexa Sort diseñados a mano, cargados desde archivos de configuración y con dificultad creciente | RN-COM-03, RN-HS-10 a 12 | §1.3, §5.1 (5) | Must |
| RF-41 | Permite colocar en una celda vacía la pila que ofrece la bandeja; genera la siguiente con semilla | RN-HS-20 a 22, 30, 31 | §1.3 | Must |
| RF-42 | Resuelve y anima la transferencia en cascada | RN-HS-40 a 45 | §1.3 | Must |
| RF-43 | Elimina los bloques de 10, cuenta las metas y determina victoria o derrota | RN-HS-50 a 54 | §1.3 | Must |
| RF-44 | Calcula el puntaje del nivel y guarda el mejor intento | RN-HS-60, 61, 70, 71 | §5.1 (6) | Must |

### 1.6 Hexa Merge

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-50 | Permite deslizar el tablero en las 6 direcciones con un gesto, que se interpreta como la dirección más cercana a su ángulo | RN-HM-30, 31 | §1.4 | Must |
| RF-51 | Fusiona las fichas iguales que chocan (una fusión por ficha) y suma el valor producido | RN-HM-40 a 43, 60, 61 | §1.4 | Must |
| RF-52 | Genera la ficha nueva (2 o 4) con un generador inyectable y con semilla | RN-HM-11, 20 a 22 | §1.4 | Must |
| RF-53 | Permite deshacer el último movimiento | RN-HM-80 a 83 | §1.4, §5.1 (8) | Must |
| RF-54 | Detecta la victoria (con opción de seguir jugando) y la derrota, y guarda el récord | RN-HM-50 a 53, 70 | §1.4, §5.1 (4) | Must |

### 1.7 Progreso local

| ID | El sistema… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-60 | Guarda en el dispositivo, por perfil, por variante y por figura, los niveles completados, el mejor intento por nivel y el récord | RN-COM-80 | §5.1 (9) | Must |
| RF-61 | Desbloquea los niveles en orden | RN-COM-73 | §5.1 (2) | Must |
| RF-62 | Permite jugar sin cuenta (modo invitado) con progreso local | RN-COM-81 | Profesor (P-08) | Must |
| RF-63 | Funciona sin conexión; guarda los cambios pendientes en una cola de sincronización | RN-COM-82, 85 | Profesor (P-08) | Must |
| RF-64 | Guarda la partida en curso después de cada turno y al pasar a segundo plano, y permite **continuarla** aunque la app se haya cerrado | RN-COM-32 a 35, 42 | HU NAV-04, D-37 | Must |

### 1.8 Cuenta, sincronización y ranking (parte de la app)

| ID | La app… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-70 | Permite registrarse (correo, contraseña y nombre visible único, RN-COM-109) contra la API y guarda el JWT en almacenamiento seguro | SEC-MOB-01 | §5.2 (1) | Must |
| RF-71 | Permite iniciar y cerrar sesión. Al cerrar sesión borra el token y vuelve al perfil invitado; ante un 401 pide iniciar sesión otra vez | RN-COM-87, 89, SEC-MOB-04 | §5.2 (1) | Must |
| RF-72 | Sincroniza el progreso por `gameId` y figura al terminar partidas y al recuperar la conexión, aplicando la **misma consolidación** que el servidor; mientras no hay conexión, guarda los cambios en la cola | RN-COM-83 a 87, 90 | §5.2 (2), P-08 | Must |
| RF-73 | Ofrece importar el progreso de invitado al iniciar sesión | RN-COM-88 | P-08 | Must |
| RF-74 | Muestra el ranking por `gameId` y figura y, en Fit y Sort, por nivel, con la posición propia; sin conexión muestra un aviso y el último ranking descargado | RN-COM-100 a 107 | §5.2 (3) | Must |
| RF-75 | Tiene pantallas de registro, inicio de sesión, estado de la cuenta y ranking | — | Necesario para RF-70 a 74 | Must |

### 1.9 Niveles remotos (parte de la app)

| ID | La app… | Reglas | Fuente | Prioridad |
|---|---|---|---|---|
| RF-80 | Consulta los niveles nuevos de una variante en la API y los combina con los incluidos | RN-COM-70, 72, 74, 75 | §5.2 (4) | Must |
| RF-82 | Valida cada nivel, incluido o descargado (esquema + todas las validaciones de su variante, también las geométricas), y descarta los inválidos | RN-COM-71, 76, RN-HF-12, RN-HS-12 | §5.2 (4) | Must |
| RF-83 | Ofrece un **validador de niveles** (prueba o script en CI) para los niveles incluidos y para revisar un nivel antes de publicarlo por la API | RN-COM-76 | D-19 | Must |

> RF-81 (publicar niveles) y RF-90 a 93 (Swagger, errores, salud y plausibilidad de resultados) solo tienen parte de servidor: ver `hexablock-api`.

---

## 2. Requisitos no funcionales

### 2.1 Diseño y arquitectura (lo que más pesa en la nota)

| ID | Atributo | Criterio medible | Verificación | Fuente | Prioridad |
|---|---|---|---|---|---|
| RNF-01 | **Genericidad** | El motor está construido con tipos genéricos parametrizados por contenido de celda, movimiento y estado. Las 4 variantes son **instanciaciones** del mismo tablero y del mismo motor | Diagrama de clases; revisión de código | §3.1 | Must |
| RNF-02 | **Motor sin variantes** | `GameEngine` y el paquete del motor no contienen **ningún** condicional por tipo de variante ni mencionan una variante concreta | Script de CI que falla si el paquete del motor nombra una variante; pruebas del motor con un **tipo de celda de prueba** | §2, §3.2 (LSP) | Must |
| RNF-03 | **Extensibilidad** | Agregar una 5ª variante requiere **solo clases nuevas + registro en configuración**; **0 archivos modificados** en el paquete del motor | `docs/EXTENSIBILITY.md`; ensayo en la defensa | §3.1 | Must |
| RNF-04 | **Topología intercambiable** | La forma de la celda la elige el jugador antes de cada partida: cambiarla no modifica `GameEngine` ni las reglas de las variantes. Alcance: hexágonos (Must), cuadrados y triángulos (Should, jugables), cubos en el dominio (Should) y su vista 3D (Could) | Pruebas de las reglas con cada topología implementada; diagrama de extensibilidad | Profesor (11-11), RN-COM-18, RN-TOP-01 a 04 | Must (diseño) |
| RNF-05 | **Restricciones de tipo** | Cada restricción sobre un parámetro genérico está justificada en el README | README, sección *Generic Engine* | §3.1 | Must |
| RNF-06 | **Clean Architecture** | El dominio **no depende** de Flutter, de la base de datos ni de la red. Todas las dependencias apuntan hacia el dominio | `pubspec` del paquete del motor sin Flutter; script de CI de imports; diagrama de capas | §3.4 | Must |
| RNF-07 | **Casos de uso genéricos** | No existe un caso de uso duplicado por variante | Revisión de código | §3.4 | Must |
| RNF-08 | **SOLID** | Cada principio tiene al menos 1 ejemplo real (clase y justificación) en el README | README, sección *SOLID* | §3.2 | Must |
| RNF-09 | **Patrones GoF** | Strategy y Abstract Factory implementados; además, al menos 2 patrones de cada categoría (creacional, estructural, de comportamiento), cada uno con justificación y enlace al código | README, sección *Design Patterns* | §3.3 | Must |
| RNF-10 | **AOP** | Al menos 1 aspecto (logging) implementado con decoradores o proxies sobre el caso de uso genérico. **Ningún** caso de uso llama directamente al logger | Prueba unitaria del decorador; búsqueda en CI de llamadas al logger en casos de uso | §3.5 | Must |
| RNF-11 | **Configurabilidad** | Tamaños de tablero, ficha objetivo, catálogo de piezas, pesos y fórmulas de puntaje se leen de configuración | Revisión de código | §3.1, RN-COM-04 | Must |

### 2.2 Calidad y pruebas

| ID | Atributo | Criterio medible | Verificación | Fuente | Prioridad |
|---|---|---|---|---|---|
| RNF-20 | **Determinismo** | Misma configuración + misma semilla + mismos movimientos = mismo estado final, siempre | Prueba de repetición por variante | §1.4, RN-COM-41 | Must |
| RNF-21 | **Suite de pruebas** | Hay pruebas unitarias, de integración (repositorios con BD en memoria), de widget y de navegación. Todas siguen **AAA** y el nombre `should_[resultado]_when_[condición]` | CI | §3.6 | Must |
| RNF-22 | **Ejemplos como pruebas** | Cada ejemplo `E-*` de las reglas de negocio tiene al menos una prueba con su ID en el nombre o en un comentario | Matriz de trazabilidad | Este documento | Must |
| RNF-23 | **Cobertura** | Dominio ≥ 90 % de líneas; aplicación ≥ 80 %; app total ≥ 70 % | Reporte de cobertura en CI con umbral | Equipo | Should |
| RNF-24 | **Integración continua** | Cada PR ejecuta formato, análisis estático, pruebas y la verificación de arquitectura; no se puede integrar a `main` con CI en rojo. Un tag de versión publica el APK firmado | Protección de `main` | §3.6 | Must |
| RNF-25 | **Contrato de la API** | Los mappers de la app se prueban con los ejemplos de `openapi.yaml` (el mismo contrato que valida el backend) | Pruebas de contrato del lado cliente en CI | §3.6 (recomendado), ADR-001 | Should |
| RNF-26 | **Mantenibilidad** | 0 advertencias del linter; formato automático; Conventional Commits en inglés validados | CI + commitlint | §6.2 | Must |

### 2.3 Rendimiento y robustez

| ID | Atributo | Criterio medible | Verificación | Fuente | Prioridad |
|---|---|---|---|---|---|
| RNF-30 | **Fluidez** | La partida se juega a ~60 fps en un Android de gama media | Prueba manual con el perfilador de Flutter | Equipo | Should |
| RNF-31 | **Resolución de turno** | Resolver el peor turno de cada variante (por ejemplo, cascada larga de Sort o búsqueda de "cabe alguna pieza" en Lines) tarda ≤ 16 ms en el dominio | Prueba de rendimiento del dominio (umbral holgado en CI) | Equipo | Should |
| RNF-34 | **Offline** | El 100 % de la jugabilidad funciona sin conexión | Pruebas con la red simulada como caída | Profesor (P-08) | Must |
| RNF-35 | **Integridad del progreso** | Un cierre inesperado de la app no corrompe ni pierde el progreso ya guardado (escrituras en transacción) | Prueba de integración del repositorio | Equipo | Must |

### 2.4 Seguridad

| ID | Atributo | Criterio medible | Verificación | Fuente | Prioridad |
|---|---|---|---|---|---|
| RNF-40 | **Seguridad** | Todos los controles **Must** de `docs/security/SECURITY-BASELINE.md` están implementados y verificados | Pruebas de SECURITY §8; checklist de `PENDIENTES.md` | SECURITY-BASELINE | Must |

### 2.5 Usabilidad, idioma y plataforma

| ID | Atributo | Criterio medible | Verificación | Fuente | Prioridad |
|---|---|---|---|---|---|
| RNF-50 | **Internacionalización** | Todos los textos visibles salen de los archivos ARB; español e inglés tienen **las mismas claves** | Chequeo de CI de paridad de claves | §5.1 (11) | Must |
| RNF-51 | **Accesibilidad básica** | Zonas táctiles ≥ 48 dp; los colores de Hexa Sort se distinguen también por un símbolo o patrón | Revisión manual | Equipo | Could |
| RNF-52 | **Plataforma** | Android 8.0 (API 26) o superior, orientación vertical, APK firmado en un GitHub Release | Workflow de release | §8 | Must |

### 2.6 Documentación y proceso

| ID | Atributo | Criterio medible | Verificación | Fuente | Prioridad |
|---|---|---|---|---|---|
| RNF-60 | **README** | README de la app en inglés con todas las secciones de §6.1 | Revisión antes de la entrega | §6.1 | Must |
| RNF-61 | **Diagramas** | Clases, capas y extensibilidad, como imagen y como archivo fuente en `/docs` | Revisión | §4 | Must |
| RNF-62 | **Uso de IA** | `AI_USAGE.md` de la app con todo lo de §7.2, actualizado en cada PR que use IA | Revisión de PR | §7 | Must |
| RNF-63 | **Participación** | Cada integrante tiene commits significativos en su cuenta | Historial de Git | §9 | Must |
