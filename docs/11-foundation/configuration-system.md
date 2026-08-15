# Configuration System

## Propósito

Separar comportamiento configurable del código.

## Capas

```text
Defaults
   ↓
Environment
   ↓
Project Configuration
   ↓
Agent Configuration
   ↓
Runtime Overrides
```

## Categorías

```text
runtime
models
agents
tools
workflows
memory
security
observability
limits
```

## Ejemplo

```yaml
runtime:
  environment: development
  max_concurrency: 2
  timeout_seconds: 900

limits:
  max_tool_calls: 50
  max_retries: 3

security:
  require_approval_for:
    - deployment
    - destructive_command
```

## Reglas

- defaults seguros;
- validar configuración al iniciar;
- secretos mediante variables de entorno o secret manager;
- no hardcodear credenciales;
- auditar cambios importantes.

## Entornos

```text
development
testing
staging
production
```
