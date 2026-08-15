# Quality Gates

## 1. Purpose

Los Quality Gates son condiciones que deben cumplirse antes de permitir que una tarea avance.

## 2. Gate Model

```text
Implementation
      ↓
     Gate 1
      ↓
     Gate 2
      ↓
     Gate 3
      ↓
    Approval
```

## 3. Gate Types

### G1 — Requirements

```text
Requirements defined
Acceptance criteria defined
```

### G2 — Implementation

```text
Implementation completed
No known blocking errors
```

### G3 — Tests

```text
Required tests pass
```

### G4 — Static Quality

```text
Lint pass
Typecheck pass
Formatter pass
```

### G5 — Security

Cuando corresponda:

```text
Security scan pass
Dependency audit pass
```

### G6 — Review

```text
Reviewer approval
```

## 4. Gate Matrix

| Task Type | Tests | Lint | Typecheck | Security | Review |
|---|---:|---:|---:|---:|---:|
| Documentation | Optional | No | No | No | Optional |
| Bug Fix | Required | Required | Required | Conditional | Required |
| Feature | Required | Required | Required | Conditional | Required |
| Architecture | Conditional | No | No | Conditional | Required |
| Security | Required | Required | Required | Required | Required |
| Refactor | Required | Required | Required | Conditional | Required |

## 5. Gate Failure

Un gate fallido debe producir:

```text
FAILED
```

y especificar:

```text
gate
reason
evidence
required_action
```

## 6. Gate Bypass

Un agente no puede saltarse un Quality Gate.

Un bypass requiere:

```text
Human Approval
```

y debe quedar registrado.

## 7. Core Principle

> Los Quality Gates son reglas del sistema, no recomendaciones del agente.
