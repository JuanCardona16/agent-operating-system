# Human Approval

## Purpose

Introducir intervención humana en acciones de riesgo.

## Approval Required For

Baseline:

```text
production deployment
destructive operations
credential changes
high-impact infrastructure changes
irreversible migrations
```

## Approval Flow

```text
Agent
  ↓
Approval Request
  ↓
Human
  ├── approve
  ├── reject
  └── request changes
```

## Approval Schema

```yaml
approval:
  id:
  execution_id:
  requested_by:
  action:
  risk:
  reason:
  expires_at:
  status:
```

## Rule

La aprobación debe autorizar una acción concreta, no una autorización indefinida.

## Timeout

Una aprobación expirada debe tratarse como no aprobada.
