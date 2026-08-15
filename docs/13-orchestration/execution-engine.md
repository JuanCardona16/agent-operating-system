# Execution Engine

## Purpose

Ejecutar un step respetando límites y políticas.

## Pipeline

```text
Resolve Agent
    ↓
Build Context
    ↓
Permission Check
    ↓
Start Execution
    ↓
Agent Run
    ↓
Collect Tool Calls
    ↓
Validate Output
    ↓
Quality Gate
    ↓
Persist State
    ↓
Next Step
```

## Execution Limits

```text
max duration
max retries
max tool calls
max parallel tasks
max token/cost budget
```

## Cancellation

Debe ser posible cancelar una ejecución:

```text
RUNNING
   ↓
CANCEL REQUESTED
   ↓
STOP NEW ACTIONS
   ↓
CLEANUP
   ↓
CANCELLED
```

## Rule

Los límites deben aplicarse desde el orchestrator y no depender únicamente del prompt.
