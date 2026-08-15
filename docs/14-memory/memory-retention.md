# Memory Retention

## Retention Classes

```text
EPHEMERAL
SHORT_TERM
PROJECT
LONG_TERM
AUDIT
```

## Example Policy

| Memory | Retention |
|---|---|
| Working context | execution |
| Temporary tool output | short-term |
| Project architecture | long-term |
| Stale findings | expiration |
| Security audit | policy-defined |

## TTL

Records temporales deben tener:

```yaml
expires_at:
```

## Archival

Antes de eliminar memoria importante:

```text
active
 ↓
deprecated
 ↓
archived
 ↓
deleted
```

## Rule

La retención debe justificarse por utilidad, auditoría o requisito operativo.
