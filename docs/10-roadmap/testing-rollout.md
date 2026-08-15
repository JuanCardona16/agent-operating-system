# Testing Rollout

## Testing Pyramid

```text
          E2E
         /   \
    Workflow Tests
       /       \
 Integration Tests
     /           \
     Unit Tests
```

## Unit Tests
Validar contracts, adapters, parsers, policies y state transitions.

## Integration Tests
Validar OpenCode, tools, memory, model providers y Gentle-AI adapter.

## Workflow Tests
Validar handoffs, dependencies, retries, gates y failures.

## End-to-End Tests

```text
User → Task → Workflow → Agents → Tools → Tests → Review → Result
```

## Evaluation Dataset

Construir tareas representativas:

```text
bug fixes
features
refactors
tests
documentation
dependency updates
security fixes
```

## Regression Testing

Comparar cambios en prompts, modelos, herramientas y workflows contra un baseline.

> El comportamiento del sistema debe evaluarse como software, no solamente mediante impresiones subjetivas.
