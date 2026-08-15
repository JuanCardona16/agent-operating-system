# Agent Model Selection

## Principle

No todos los agentes necesitan el mismo modelo.

## Selection Factors

```text
reasoning complexity
coding capability
tool use
context size
latency
cost
reliability
```

## Example Strategy

```text
analyst     → reasoning-focused
architect   → strongest reasoning
developer   → coding-focused
tester      → coding + verification
reviewer    → reasoning + code
security    → reasoning + security
researcher  → retrieval/reasoning
```

## Configuration

Model identifiers deben mantenerse configurables.

```yaml
models:
  analyst:
  architect:
  developer:
  tester:
  reviewer:
  security:
  researcher:
```

## Rule

No acoplar la arquitectura a un único proveedor de modelos.
