# Execution Memory

## Purpose

Conservar información necesaria para reanudar y auditar un workflow.

## Contents

```text
task
workflow
steps
agent outputs
tool results
artifacts
quality gates
approvals
failures
retries
```

## Example

```yaml
execution_memory:
  execution_id:
  status: running
  completed_steps:
    - analyze
    - design
  current_step: implement
  artifacts:
    - architecture.md
  retries:
    tester: 1
```

## Checkpoint

La memoria de ejecución debe ser compatible con los checkpoints definidos en `13-orchestration`.

## Resume

```text
checkpoint
   ↓
execution memory
   ↓
validate state
   ↓
resume workflow
```
