# Event System

## Propósito

Crear un mecanismo común para desacoplar componentes y habilitar observabilidad.

## Eventos base

```text
TaskCreated
TaskStarted
TaskCompleted
TaskFailed
ExecutionStarted
ExecutionCompleted
ExecutionFailed
AgentStarted
AgentCompleted
AgentFailed
ToolRequested
ToolCompleted
ToolFailed
WorkflowStarted
WorkflowCompleted
WorkflowFailed
QualityGatePassed
QualityGateFailed
HumanApprovalRequested
HumanApprovalGranted
HumanApprovalRejected
```

## Modelo

```yaml
event:
  id: EVT-001
  type: AgentCompleted
  timestamp:
  execution_id:
  task_id:
  agent_id:
  payload:
    status: completed
```

## Correlación

```text
task_id
workflow_id
execution_id
agent_id
tool_call_id
event_id
```

## Flujo

```text
Component
   ↓
Event
   ↓
Dispatcher
   ├── Logger
   ├── Metrics
   ├── Audit
   ├── Memory
   └── Observability
```

No incluir secretos ni información sensible innecesaria en eventos.
