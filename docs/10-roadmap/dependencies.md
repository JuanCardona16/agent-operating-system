# Dependencies

## Dependency Graph

```text
Architecture
    ↓
Foundation
    ↓
Single-Agent MVP
    ↓
Tooling
    ↓
Multi-Agent
    ↓
Orchestration
    ├──────────────┐
    ↓              ↓
  Memory        Quality
    └──────┬───────┘
           ↓
    Observability
           ↓
      Security
           ↓
 Advanced Autonomy
```

## Hard Dependencies

| Capability | Requires |
|---|---|
| Foundation | Architecture |
| Single-Agent MVP | Foundation + OpenCode + model + basic tools |
| Multi-Agent | Contracts + handoffs + tools |
| Orchestration | Task model + runtime + workflows |
| Memory | Task/agent identity + storage + retrieval |
| Quality | Workflows + artifacts + test execution |
| Operations | Events + execution IDs + logs |
| Security | Tools + permissions + resources + audit |

## Soft Dependencies

Pueden introducirse gradualmente:

```text
Advanced Routing
Advanced Memory
Dashboards
Distributed Runtime
Multiple Model Providers
```

## Critical Path

```text
Foundation → MVP → Tools → Multi-Agent → Orchestration → Quality → Security → Autonomy
```

> No introducir capacidades avanzadas antes de estabilizar sus dependencias fundamentales.
