# Agent Contract

## Input Contract

Todo agente recibe un contexto estructurado conceptualmente equivalente a:

```yaml
agent_input:
  execution_id:
  task_id:
  agent_id:
  objective:
  context:
  constraints:
  artifacts:
  previous_findings:
```

## Output Contract

```yaml
agent_output:
  execution_id:
  agent_id:
  status:
  summary:
  findings:
  artifacts:
  tests:
  errors:
  risks:
  recommendations:
  next_action:
```

## Status

```text
pending
running
completed
failed
blocked
needs_approval
```

## Output Rules

El agente debe:

1. indicar qué hizo;
2. indicar qué no pudo hacer;
3. diferenciar hechos de inferencias;
4. reportar errores;
5. reportar riesgos;
6. identificar artifacts relevantes;
7. proponer el siguiente paso.

## Handoff Contract

```yaml
handoff:
  source_agent:
  target_agent:
  task_id:
  objective:
  context:
  findings:
  artifacts:
  expected_output:
  constraints:
```

## Contract Rule

Los handoffs no deben depender únicamente del historial completo de conversación.
