# Security Model

## Threat Domains

```text
identity
authorization
tools
filesystem
terminal
network
secrets
memory
prompt injection
supply chain
observability
deployment
```

## Security Decision

```yaml
decision:
  actor:
  action:
  resource:
  project:
  risk:
  policy:
  result:
  reason:
```

## Default

```text
unknown action
    ↓
DENY
```

Las excepciones deben estar explícitamente definidas.

## Security Context

Cada ejecución debe conocer:

```text
project
environment
agent
permissions
risk
approval state
```
