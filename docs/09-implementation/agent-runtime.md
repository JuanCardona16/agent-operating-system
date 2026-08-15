# Agent Runtime

## 1. Purpose

Define el runtime conceptual responsable de ejecutar agentes.

## 2. Runtime Responsibilities

El runtime debe encargarse de:

- cargar configuración;
- seleccionar modelo;
- cargar instrucciones;
- asignar herramientas;
- preparar contexto;
- ejecutar el agente;
- registrar eventos;
- capturar resultados;
- manejar errores;
- producir artifacts.

## 3. Execution Lifecycle

```text
CREATED
   ↓
INITIALIZING
   ↓
CONTEXT_LOADING
   ↓
RUNNING
   ↓
TOOL_EXECUTION
   ↓
VALIDATING
   ↓
COMPLETED
```

En caso de error:

```text
RUNNING
   ↓
FAILED
   ↓
RECOVERY
```

## 4. Agent Execution

Cada ejecución debe tener un identificador único.

```yaml
execution:
  execution_id:
  task_id:
  agent_id:
  started_at:
  finished_at:
  status:
```

## 5. Agent Input

```yaml
input:
  task:
  requirements:
  constraints:
  project_context:
  previous_handoff:
  relevant_memory:
  allowed_tools:
```

No debe recibir automáticamente toda la información disponible.

## 6. Context Construction

```text
Task
 ↓
Requirements
 ↓
Relevant Project Context
 ↓
Relevant Memory
 ↓
Previous Agent Output
 ↓
Agent Instructions
```

## 7. Agent Output

```yaml
result:
  status: completed

  summary:
    - ...

  changes:
    - ...

  artifacts:
    - ...

  tests:
    - ...

  issues:
    - ...

  recommendations:
    - ...
```

## 8. Agent Status

```text
CREATED
READY
RUNNING
WAITING
BLOCKED
COMPLETED
FAILED
CANCELLED
```

## 9. Tool Execution

```text
Agent Execution
      │
      ├── Tool Call
      │      ├── input
      │      ├── output
      │      └── status
      │
      └── Next Step
```

## 10. Limits

Cada agente puede tener límites:

```yaml
limits:
  max_turns:
  max_tool_calls:
  max_execution_time:
  max_cost:
  max_retries:
```

## 11. Failure Handling

```text
TRANSIENT
PERMANENT
CONFIGURATION
TOOL
MODEL
SECURITY
UNKNOWN
```

La estrategia de recuperación dependerá de la categoría.

## 12. Cancellation

```text
RUNNING
   ↓
CANCEL_REQUESTED
   ↓
STOPPING
   ↓
CANCELLED
```

## 13. Checkpoint

```yaml
checkpoint:
  execution_id:
  current_phase:
  completed_steps:
  pending_steps:
  artifacts:
  context_reference:
```

## 14. Runtime Principle

> Un agente debe ser una unidad de ejecución controlada, observable y recuperable.
