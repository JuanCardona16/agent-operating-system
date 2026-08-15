# Security Observability

## Events

Registrar:

```text
permission.denied
approval.requested
dangerous.command
secret.detected
policy.violation
security.incident
```

## Metrics

```text
denied_actions
policy_violations
security_failures
secret_detection_events
approval_rate
```

## Audit

Las decisiones de seguridad críticas deben quedar correlacionadas con:

```text
execution_id
agent_id
tool_call_id
policy_version
```
