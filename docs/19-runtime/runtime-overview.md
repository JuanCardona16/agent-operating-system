# 19 — Runtime Overview

## Propósito

Definir el runtime inicial del sistema multiagente y convertir la arquitectura documentada en una implementación reproducible.

## Objetivo

```text
OpenCode
  ↓
Runtime Configuration
  ↓
Agent Definitions
  ↓
Tools + Permissions
  ↓
Workflow
  ↓
Execution
  ↓
Evaluation + Observability
```

## Scope

Este bloque cubre:

- estructura ejecutable;
- bootstrap;
- agentes MVP;
- configuración;
- workflow inicial;
- validación;
- troubleshooting;
- criterios de salida.

No intenta resolver todavía todos los servicios de producción.

## MVP Runtime

```text
developer
tester
reviewer
```

con un workflow:

```text
task → developer → tester → reviewer → result
```
