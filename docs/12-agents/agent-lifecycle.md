# Agent Lifecycle

## Lifecycle

```text
DISCOVERED
    ↓
REGISTERED
    ↓
READY
    ↓
ASSIGNED
    ↓
RUNNING
    ↓
VALIDATING
    ↓
COMPLETED
```

## Failure States

```text
RUNNING
   ↓
FAILED
   ├── RETRY
   ├── REPLAN
   └── ESCALATE
```

## State Data

Cada ejecución debe poder registrar:

```text
agent_id
agent_version
execution_id
task_id
started_at
completed_at
status
tool_calls
artifacts
errors
```

## Retry

No todos los errores deben reintentarse.

### Retry candidates

- transient infrastructure error;
- temporary network error;
- recoverable tool timeout.

### No automatic retry

- permission denial;
- invalid task;
- policy violation;
- destructive action rejection.

## Completion

Un agente solo debe finalizar cuando:

- produjo el output esperado;
- validó lo que podía validar;
- reportó limitaciones;
- emitió el estado final.
