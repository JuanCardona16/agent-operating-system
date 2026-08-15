# Tool Base

## Modelo

```yaml
tool:
  id: filesystem.read
  version: "1.0"

  input:
    path:
      type: string

  output:
    content:
      type: string

  permissions:
    - filesystem.read

  risk: low
  timeout_seconds: 30
```

## Lifecycle

```text
REQUEST
  ↓
VALIDATE
  ↓
AUTHORIZE
  ↓
EXECUTE
  ↓
NORMALIZE
  ↓
AUDIT
  ↓
RESULT
```

## Categorías

```text
filesystem
terminal
git
testing
search
browser
database
deployment
memory
```

## Riesgo

```text
LOW
MEDIUM
HIGH
CRITICAL
```

## Requisitos

Toda herramienta debe definir:

- ID y versión;
- input/output schema;
- permisos;
- timeout;
- errores;
- auditoría;
- riesgo.

> Tener una herramienta registrada no significa que todos los agentes puedan utilizarla.
