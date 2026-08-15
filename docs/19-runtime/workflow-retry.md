# Runtime Retry Policy

## Retryable

```text
transient tool failure
network timeout
temporary model/runtime failure
```

## Non-Retryable

```text
permission denied
invalid requirements
security violation
deterministic test failure
```

## Retry Limit

MVP:

```text
max_retries = 2
```

## Rule

No retry loop should hide a deterministic failure.

## Escalation

```text
retry exhausted
 ↓
failure report
 ↓
human / orchestrator decision
```
