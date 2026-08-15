# Memory Provenance

## Purpose

Saber de dónde proviene cada dato persistido.

## Provenance

```yaml
provenance:
  source_type:
  source_id:
  execution_id:
  agent_id:
  timestamp:
  verification:
```

## Source Types

```text
human
repository
tool
documentation
test
agent
system
```

## Confidence

```text
unknown
low
medium
high
verified
```

## Example

```yaml
source_type: test
source_id: CI-123
verification: passed
confidence: verified
```

## Rule

Una memoria crítica sin provenance debe considerarse de baja confianza.
