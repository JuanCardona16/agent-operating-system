# Agent Selection

## Initial Strategy

Al principio, la selección debe ser explícita y determinista.

```text
Task Type
   ↓
Workflow
   ↓
Agent
```

## Example

```text
bug fix
  → developer + tester + reviewer

architecture change
  → analyst + architect + developer + tester + reviewer

security issue
  → security + developer + tester + reviewer

research task
  → researcher + analyst
```

## Later Strategy

En fases posteriores:

```text
Task Classification
       ↓
Capability Requirements
       ↓
Agent Candidates
       ↓
Policy Filter
       ↓
Cost / Model Selection
       ↓
Agent
```

## Selection Criteria

- capability;
- tool requirements;
- risk;
- permissions;
- cost;
- latency;
- availability;
- historical performance.

## Rule

No utilizar routing dinámico antes de disponer de métricas suficientes para justificarlo.
