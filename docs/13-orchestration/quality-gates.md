# Quality Gates

## Purpose

Evitar que un workflow avance con resultados inválidos.

## Gate Types

```text
schema
tests
lint
typecheck
security
review
acceptance
```

## Example

```yaml
quality_gate:
  id: tests-pass
  type: tests
  required: true
  command: test
```

## Flow

```text
Agent Output
     ↓
Quality Gate
   ├── PASS → continue
   ├── FAIL → retry/rework
   └── BLOCK → escalate
```

## Gate Policy

Cada gate debe definir:

- input;
- evaluator;
- pass criteria;
- failure criteria;
- remediation.

## Rule

Un agente no debe autoaprobar una validación crítica si existe un evaluador independiente disponible.
