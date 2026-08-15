# Handoff Engine

## Purpose

Transferir trabajo entre agentes sin perder contexto.

## Handoff

```yaml
handoff:
  id:
  source_agent:
  target_agent:
  execution_id:
  task_id:
  objective:
  context:
  findings:
  artifacts:
  constraints:
  expected_output:
```

## Flow

```text
Agent A
  ↓
Generate Handoff
  ↓
Validate Contract
  ↓
Permission Check
  ↓
Agent B
```

## Handoff Conditions

Puede ocurrir por:

- completion;
- specialization;
- failure;
- escalation;
- quality gate;
- human decision.

## Context Rule

Pasar contexto relevante, no necesariamente todo el historial.

## Rejection

El receptor puede devolver:

```text
insufficient_context
out_of_scope
missing_permission
invalid_artifact
requires_approval
```
