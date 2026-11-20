# ARQ-00 — Vista del sistema

| Campo | Valor |
|---|---|
| Estado | Borrador para revisión del equipo (Paso 2) |
| Fecha | 2026-11-11 (revisión de coherencia: 12-11) |
| Repositorio | **Compartido:** `docs/architecture/` en `hexablock-app` y `hexablock-api`; las dos copias deben ser idénticas |
| Relacionados | `ADR-001-tech-stack.md`, `ARQ-01-APP-GENERAL.md` (app), `ARQ-01-API-GENERAL.md` (API), `02-RN-CUENTA-PROGRESO-RANKING.md` |

**Qué cubre:** las piezas del sistema completo, qué hace cada una, cómo se comunican y quién es dueño de cada dato. La arquitectura interna de cada repo está en su `ARQ-01`.

---

## 1. Contexto

```mermaid
flowchart LR
    J([Jugador]) -->|juega, con o sin cuenta| APP[App HexaBlock Suite<br/>Flutter · Android]
    A([Administrador de contenido]) -->|publica niveles por Swagger| API
    APP -->|HTTPS + JSON + JWT| API[API HexaBlock<br/>NestJS en AWS EC2]
    API --> DB[(PostgreSQL)]
    GH[GitHub<br/>repos · Actions · GHCR · Releases] -.->|despliega imagen| API
    GH -.->|publica APK| APP
```

| Actor / sistema | Rol |
|---|---|
| **Jugador** | Usa la app. Puede jugar como **invitado** (sin cuenta) o con cuenta |
| **Administrador de contenido** | Publica y actualiza niveles con la API, desde Swagger (`/docs`) |
| **App** (`hexablock-app`) | Ejecuta las partidas, guarda el progreso en el dispositivo y sincroniza cuando puede |
| **API** (`hexablock-api`) | Cuentas, consolidación del progreso en el servidor, ranking y niveles publicados |
| **PostgreSQL** | Persistencia del servidor |
| **GitHub** | Código, CI, imágenes Docker (GHCR) y el APK en Releases |

## 2. Contenedores y despliegue

```mermaid
flowchart TB
    subgraph Dispositivo[Teléfono Android]
        UI[App Flutter]
        LDB[(Drift / SQLite<br/>progreso, niveles, cola)]
        SS[(Almacenamiento seguro<br/>JWT)]
        UI --- LDB
        UI --- SS
    end
    subgraph EC2[AWS EC2 t3.small · Docker Compose]
        CADDY[Caddy<br/>HTTPS :443]
        NEST[API NestJS<br/>:3000 interno]
        PG[(PostgreSQL<br/>:5432 interno)]
        CADDY --> NEST --> PG
    end
    UI -->|HTTPS| CADDY
```

| Contenedor | Tecnología | Expuesto | Datos que guarda |
|---|---|---|---|
| App | Flutter + Dart 3 | — | Progreso por perfil, niveles descargados, cola de sincronización (Drift); ajustes (`shared_preferences`); JWT (almacenamiento seguro) |
| Proxy | Caddy | 80/443 | Certificados TLS |
| API | NestJS (Node LTS) | Solo a través de Caddy | — (sin estado: escala reiniciando el contenedor) |
| Base de datos | PostgreSQL | **No** | Usuarios, progreso consolidado, mejores intentos, niveles |

## 3. Quién es dueño de qué

| Dato o decisión | Dueño | Motivo |
|---|---|---|
| **Reglas de juego** (variantes, topologías, turnos) | **Solo la app** | El servidor no ejecuta partidas |
| **Progreso del jugador** | **El dispositivo primero** (offline-first); el servidor guarda la **versión consolidada** | El juego funciona sin conexión (RN-COM-82) |
| **Consolidación** del progreso | **Ambos**, con la misma regla y los mismos ejemplos de prueba | La app consolida al recibir la respuesta; el servidor, al recibir el progreso (RN-COM-83, 84) |
| **Ranking** | **Solo la API** | Necesita los datos de todos los jugadores |
| **Niveles publicados** | **La API** (fuente); la app guarda copias | La app trae niveles incluidos y descarga los nuevos (RN-COM-72) |
| **Validación de niveles** | API: estructural; app: estructural y **geométrica** | Validar que una pieza es una rotación de su forma requiere las topologías, que viven solo en la app (D-19, 19-11) |
| **Identidad y sesión** | **La API** emite el JWT; la app lo guarda en almacenamiento seguro | SEC-API-02, SEC-MOB-01 |
| **Contrato** entre app y API | **`openapi.yaml`** y JSON Schema, fuente única en `hexablock-api/docs/contracts/` | Paso 5 (D-23); la app guarda una copia idéntica |

## 4. Comunicación

| Aspecto | Decisión |
|---|---|
| Protocolo | REST sobre **HTTPS**, JSON |
| Versión | Prefijo `/api/v1` (SEC-API-09) |
| Autenticación | `Authorization: Bearer <JWT>` en los endpoints protegidos |
| Identidad | El usuario **siempre** sale del JWT, nunca de la URL ni del cuerpo (SEC-API-01) |
| Errores | Problem Details (RFC 9457) con los campos propios `code` y `errors` (RF-91, D-51) |
| Variante y figura | `gameId` obligatorio en todo lo que es por variante; la **topología** (figura de celda) también, en progreso y ranking (D-25). En el servidor, una entrada de progreso por usuario y `gameId`, con una sección por figura (D-27) |
| Reintentos | Solo desde la app, en la sincronización (la operación es repetible sin efectos: RN-COM-84) |
| Sin conexión | La app sigue funcionando; la cola se envía al recuperar la red |

## 5. Flujos que cruzan ambos repos

### 5.1 Sincronizar progreso (con cuenta)

```mermaid
sequenceDiagram
    autonumber
    participant UI as App (UI)
    participant UC as Caso de uso (app)
    participant L as Drift (app)
    participant API as API
    participant DB as PostgreSQL
    UI->>UC: partida terminada (gameId, figura, resultado)
    UC->>L: guardar progreso local (consolidado)
    UC->>L: marcar el resultado como pendiente de enviar
    alt hay conexión y sesión válida
        UC->>API: PUT resultados pendientes de gameId, por figura (JWT)
        API->>DB: leer progreso guardado
        API->>API: consolidar (RN-COM-83)
        API->>DB: guardar resultado + mejores intentos
        API-->>UC: resultados consolidados
        UC->>L: guardar y quitar la marca de pendiente
    else sin conexión o sesión vencida
        UC-->>UI: sigue jugando y lo pendiente espera (RN-COM-85, 87)
    end
```

### 5.2 Iniciar sesión con progreso de invitado

```mermaid
sequenceDiagram
    autonumber
    participant UI as App (UI)
    participant UC as Caso de uso (app)
    participant L as Drift (app)
    participant API as API
    UI->>UC: iniciar sesión (correo, contraseña)
    UC->>API: POST login
    API-->>UC: JWT
    UC->>L: ¿hay progreso de invitado?
    alt hay y el jugador acepta importarlo (RN-COM-88)
        UC->>L: consolidar invitado + cuenta en el perfil de la cuenta
    end
    loop por cada variante y figura con progreso local
        UC->>API: PUT progreso local de gameId y figura
        API-->>UC: progreso consolidado
        UC->>L: guardar
    end
    UC-->>UI: sesión iniciada
```

### 5.3 Publicar y recibir un nivel

```mermaid
sequenceDiagram
    autonumber
    participant ADM as Administrador
    participant VAL as Validador de niveles (app, CI)
    participant API as API
    participant APP as App
    ADM->>VAL: validar nivel (estructural + geométrica)
    VAL-->>ADM: válido
    ADM->>API: POST/PUT nivel (JWT con rol admin)
    API->>API: validar esquema + reglas estructurales
    API-->>ADM: 201 / 200 (o 400 con detalle)
    APP->>API: GET niveles de gameId y figura cambiados desde el cursor (páginas de 100)
    API-->>APP: niveles con versión y topología + cursor siguiente
    APP->>APP: validar todo (incluida la geométrica) y guardar los válidos
```

## 6. Decisiones de esta vista

Las decisiones están en `docs/DECISIONES.md` de cada repo (D-67). Los IDs propios de esta vista se conservan:

| ID | Dónde está ahora |
|---|---|
| ARQ-S-01 | P-08 (offline-first: el dispositivo es la fuente primaria del progreso) |
| ARQ-S-02 | Por confirmar en `hexablock-app/docs/PENDIENTES.md` §1 (el servidor no ejecuta reglas de juego) |
| ARQ-S-03 | Por confirmar en `hexablock-app/docs/PENDIENTES.md` §1 (consolidación en Dart y TypeScript con ejemplos compartidos) |
| ARQ-S-04 | D-48 y D-49 (sincronización incremental y descarga de niveles por cursor) |
| ARQ-S-05 | D-23 (contrato con fuente única en `hexablock-api`) |
