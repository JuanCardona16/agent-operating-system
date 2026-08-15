# Retry and Recovery

## Retry Policy

```yaml
retry_policy:
  max_attempts: 2
  backoff: exponential
  retryable_errors:
    - timeout
    - transient_network
    - temporary_infrastructure
```

## Do Not Retry Automatically

```text
permission_denied
policy_violation
invalid_input
destructive_action_rejected
deterministic_bug
```

## Recovery Strategies

```text
retry
replan
switch_agent
request_human
rollback
fail
```

## Escalation

```text
Agent Failure
   ↓
Classify
   ├── retry
   ├── recover
   ├── handoff
   └── escalate
```

## Rule

Cada retry debe tener una razón explícita y quedar registrado.
