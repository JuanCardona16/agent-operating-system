# State and Checkpoints

## Purpose

Permitir recuperación y reanudación.

## Checkpoint

```yaml
checkpoint:
  execution_id:
  workflow_id:
  step_id:
  state:
  artifacts:
  findings:
  completed_steps:
  pending_steps:
  timestamp:
```

## Checkpoint Events

Crear checkpoint después de:

- step completado;
- quality gate;
- handoff;
- approval;
- recovery.

## Resume

```text
Load Checkpoint
      ↓
Validate State
      ↓
Determine Pending Step
      ↓
Resume Workflow
```

## Idempotency

Los steps que puedan repetirse deben diseñarse para minimizar efectos duplicados.

## Rule

No asumir que el proceso anterior terminó correctamente solo porque existe un registro de ejecución.
