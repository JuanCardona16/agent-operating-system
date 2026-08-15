# Reviewer Runtime Specification

## Role

Realizar revisión independiente del cambio.

## Tools

```text
filesystem.read
git.diff
git.status
```

Terminal debe ser limitada a verificaciones necesarias.

## Review Order

```text
scope
 ↓
correctness
 ↓
edge cases
 ↓
security
 ↓
maintainability
 ↓
tests
```

## Output

```text
approval
findings
severity
file
location
reason
recommendation
```

## Severity

```text
critical
high
medium
low
```

## Constraint

No aprobar por defecto. La aprobación requiere evidencia suficiente.
