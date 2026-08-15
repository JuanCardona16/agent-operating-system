# Audit

## Purpose

Mantener evidencia de acciones relevantes, especialmente las de riesgo.

## Audit Events

```text
permission changes
destructive operations
deployments
secret access attempts
approvals
policy violations
security failures
```

## Audit Record

```yaml
audit:
  id:
  actor:
  action:
  resource:
  decision:
  timestamp:
  reason:
  execution_id:
```

## Requirements

Audit records deben ser:

```text
append-only
timestamped
correlated
protected
reviewable
```

## Rule

Audit y logs operacionales son conceptos relacionados pero no idénticos. El audit trail requiere controles de integridad más fuertes.
