# Logs

## Purpose

Registrar información operacional y diagnóstica.

## Levels

```text
DEBUG
INFO
WARN
ERROR
FATAL
```

## Recommended Events

```text
task.created
workflow.started
step.started
agent.started
tool.called
tool.completed
quality_gate.failed
handoff.created
approval.requested
agent.failed
workflow.completed
```

## Structured Logging

Preferir:

```json
{
  "event": "tool.completed",
  "execution_id": "...",
  "agent_id": "developer",
  "tool": "git",
  "duration_ms": 842
}
```

sobre texto no estructurado.

## Sensitive Data

Nunca registrar:

```text
passwords
API keys
tokens
private keys
secrets
```

Aplicar redaction antes de persistir logs.
