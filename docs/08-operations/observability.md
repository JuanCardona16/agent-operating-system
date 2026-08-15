# Observability

## 1. Purpose

La observabilidad permite comprender el comportamiento del sistema multiagente.

Debemos poder reconstruir:

```text
Request
 ↓
Task
 ↓
Agent
 ↓
Tool
 ↓
Artifact
 ↓
Validation
 ↓
Result
```

## 2. Observability Signals

El sistema utilizará:

```text
Logs
Metrics
Traces
Artifacts
Events
```

## 3. Logs

Los logs deben registrar eventos importantes.

Ejemplo:

```yaml
event:
  timestamp:
  type: agent.execution.started
  task_id:
  agent_id:
  execution_id:
```

## 4. Important Events

Eventos mínimos:

```text
task.created
task.started
task.completed
task.failed

agent.started
agent.completed
agent.failed

tool.called
tool.completed
tool.failed

handoff.created

quality_gate.passed
quality_gate.failed

human_approval.requested
human_approval.approved
human_approval.rejected
```

## 5. Tracing

Cada ejecución debe tener un identificador.

```text
request_id
task_id
execution_id
agent_execution_id
tool_call_id
```

Esto permite relacionar eventos.

## 6. Example Trace

```text
REQUEST-001
    │
    └── TASK-042
          │
          ├── EXEC-001 Analyst
          │
          ├── EXEC-002 Architect
          │
          ├── EXEC-003 Developer
          │      ├── TOOL-001 filesystem.read
          │      ├── TOOL-002 filesystem.write
          │      └── TOOL-003 test.run
          │
          └── EXEC-004 Reviewer
```

## 7. Sensitive Data

Los logs nunca deben almacenar:

- passwords;
- API keys;
- tokens;
- private keys;
- secretos.

## 8. Observability Principle

> Todo resultado importante debe poder rastrearse hasta la ejecución que lo produjo.
