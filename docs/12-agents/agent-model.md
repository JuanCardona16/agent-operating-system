# Agent Model

## Agent Identity

Cada agente debe tener:

```text
agent_id
version
role
description
mode
```

## Agent Definition

```yaml
agent:
  id: developer
  version: "1.0.0"
  role: software_developer
  mode: subagent

  objective:
    primary: Implementar cambios de software correctamente.

  capabilities:
    - repository_analysis
    - implementation
    - testing
    - debugging

  tools:
    - read
    - write
    - edit
    - bash
    - git

  permissions:
    filesystem: scoped
    terminal: controlled

  constraints:
    - no secrets
    - no destructive operations without approval

  inputs:
    - AgentInput

  outputs:
    - AgentOutput

  handoffs:
    receives:
      - architect
      - analyst
    sends:
      - tester
      - reviewer
```

## Separation of Concerns

```text
Role
  ≠
Capabilities
  ≠
Tools
  ≠
Permissions
  ≠
Prompt
```

Un agente puede tener una capacidad conceptual sin tener autorización para utilizar todas las herramientas necesarias para ejecutarla.

## Agent Quality

Un agente debe evaluarse mediante:

```text
Correctness
Reliability
Tool Discipline
Output Quality
Safety
Cost
Latency
```
