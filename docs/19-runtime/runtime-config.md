# Runtime Configuration

## Configuration Categories

```text
agents
models
permissions
tools
commands
environment
limits
```

## Example Conceptual Configuration

```yaml
runtime:
  environment: development

models:
  developer: <model>
  tester: <model>
  reviewer: <model>

limits:
  max_retries: 2
  max_duration_minutes: 30

security:
  default_permission: deny
```

## Environment Separation

```text
development
testing
staging
production
```

No reutilizar automáticamente configuraciones de producción durante desarrollo.
