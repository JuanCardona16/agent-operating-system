# Orchestrator Model

## Responsabilidad

El orchestrator coordina; no sustituye a los agentes especializados.

## Core Components

```text
Orchestrator
├── Task Manager
├── Workflow Engine
├── Agent Resolver
├── Permission Gate
├── Execution Manager
├── Retry Manager
├── Quality Gate Manager
├── Approval Manager
└── Event Dispatcher
```

## Execution Context

```yaml
execution:
  execution_id:
  task_id:
  workflow_id:
  current_step:
  current_agent:
  state:
  artifacts:
  findings:
  approvals:
  retry_count:
```

## State

```text
CREATED
PLANNING
READY
RUNNING
WAITING
VALIDATING
BLOCKED
FAILED
COMPLETED
CANCELLED
```

## Rule

El estado debe poder reconstruirse a partir de eventos y/o checkpoints persistidos.
