# Agent Resolution

## Purpose

Determinar qué agente debe ejecutar un step.

## MVP Strategy

```text
Workflow Step
    ↓
Explicit Agent ID
    ↓
Validate Agent
    ↓
Validate Capabilities
    ↓
Validate Permissions
    ↓
Execute
```

## Future Strategy

```text
Task
 ↓
Capability Requirements
 ↓
Candidate Agents
 ↓
Policy Filter
 ↓
Performance Score
 ↓
Cost / Latency
 ↓
Selected Agent
```

## Resolution Inputs

```text
task type
required capabilities
risk
tools
permissions
model availability
agent health
historical performance
```

## Rule

El routing dinámico debe introducirse solo después de disponer de métricas suficientes.
