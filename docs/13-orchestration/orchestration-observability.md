# Orchestration Observability

## Required Metrics

```text
workflow_duration
step_duration
agent_duration
tool_calls
retry_count
failure_rate
quality_gate_failure_rate
approval_wait_time
cost
```

## Logs

Cada evento debe poder correlacionarse con:

```text
execution_id
workflow_id
task_id
agent_id
step_id
```

## Trace

```text
Task
 └── Workflow
      ├── Step
      │    └── Agent
      │         └── Tool Calls
      └── Quality Gates
```

## Operational Questions

El sistema debe poder responder:

- ¿qué agente falló?
- ¿en qué step?
- ¿qué herramienta utilizó?
- ¿qué permisos tenía?
- ¿cuánto costó?
- ¿qué quality gate falló?
- ¿cuántos retries hubo?
- ¿por qué terminó el workflow?
