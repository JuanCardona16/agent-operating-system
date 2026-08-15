# Tool Evaluation

## Purpose

Las herramientas también deben evaluarse.

## Metrics

```text
success_rate
error_rate
timeout_rate
input_validation
permission_accuracy
output_correctness
latency
```

## Tool Test

```yaml
tool_test:
  tool_id:
  input:
  expected:
  permissions:
  failure_mode:
```

## Critical Tools

Mayor cobertura para:

```text
filesystem.write
terminal.execute
git
deployment
database
secrets
```

## Rule

Una herramienta peligrosa debe tener pruebas de:

```text
valid use
invalid use
unauthorized use
malicious input
failure
timeout
```
