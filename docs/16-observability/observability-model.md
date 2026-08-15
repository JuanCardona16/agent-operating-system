# Observability Model

## Core Entities

```text
System
 └── Workflow
      └── Execution
           └── Step
                └── Agent
                     └── Tool Call
```

## Correlation IDs

Toda operación debe poder correlacionarse mediante:

```yaml
correlation:
  trace_id:
  execution_id:
  workflow_id:
  task_id:
  step_id:
  agent_id:
  tool_call_id:
```

## Event Model

```yaml
event:
  id:
  type:
  timestamp:
  severity:
  source:
  correlation:
  payload:
```

## Rule

Los identificadores de correlación deben conservarse entre handoffs y tool calls.
