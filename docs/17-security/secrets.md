# Secrets Management

## Principles

Secrets must never be:

```text
embedded in prompts
stored in memory
written to logs
committed to repositories
included in agent output
```

## Access

Cuando sea imprescindible:

```text
Agent
 ↓
Secret Broker
 ↓
Policy
 ↓
Secret
```

## Secret Exposure

Si un secret aparece en output:

```text
detect
redact
audit
rotate if necessary
```

## Rule

Un agente debe recibir el mínimo secreto necesario para ejecutar una operación.
