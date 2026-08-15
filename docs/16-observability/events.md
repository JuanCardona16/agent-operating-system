# Event System

## Purpose

Usar eventos como mecanismo común para observabilidad y automatización.

## Event Categories

```text
lifecycle
execution
tool
quality
security
approval
memory
failure
```

## Example

```yaml
type: agent.failed
timestamp:
source: developer
correlation:
  execution_id:
  step_id:
payload:
  error_type: timeout
```

## Consumers

Los eventos pueden alimentar:

```text
logs
metrics
alerts
audit
dashboards
evaluation
memory pipelines
```

## Rule

Los eventos deben ser pequeños, versionados y semánticamente estables.
