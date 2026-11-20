---
paths:
  - ".github/**"
---

# CI y configuración de GitHub

- Cada workflow declara `permissions:` mínimos (`contents: read` por defecto). **Prohibido `pull_request_target`** con checkout del código del PR (SEC-WEB-03).
- Las acciones de terceros se fijan por versión mayor o SHA.
- El release del APK corre solo con tags `v*` y usa el environment `release` con el keystore (SEC-MOB-07). Nadie más tiene el keystore.
- Un cambio aquí avisa al equipo (casilla de la plantilla de PR, SEC-AGT-05).
