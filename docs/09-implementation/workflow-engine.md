# Workflow Engine

## 1. Purpose

Define cómo se ejecutan los workflows que coordinan múltiples agentes.

## 2. Workflow Model

```text
Workflow
   │
   ├── Trigger
   ├── Inputs
   ├── Stages
   ├── Dependencies
   ├── Handoffs
   ├── Quality Gates
   └── Completion
```

## 3. Example Feature Workflow

```text
User Request
     ↓
Analyst
     ↓
Architect
     ↓
Developer
     ↓
Tester
     ↓
Reviewer
     ↓
Quality Gates
     ↓
DONE
```

## 4. Stages

Cada stage debe definir:

```text
id
agent
input
output
dependencies
timeout
retry_policy
gate
```

## 5. Dependencies

```text
Analyst
   ↓
Architect
   ↓
Developer
   ↓
Tester
   ↓
Reviewer
```

El workflow debe impedir que una etapa dependiente se ejecute antes de tener los requisitos necesarios.

## 6. Parallel Execution

Cuando no exista dependencia:

```text
             ┌── Researcher
Architect ───┤
             └── Security Analyst
```

Las tareas independientes pueden ejecutarse en paralelo.

## 7. Handoff

Un handoff debe transferir información estructurada.

```yaml
handoff:
  from: analyst
  to: architect

  task_id:

  summary:
  findings:
  artifacts:
  unresolved_questions:
  recommendations:
```

## 8. Failure

```text
Stage
 ↓
FAIL
 ↓
Classify Failure
 ├── Retry
 ├── Reassign
 ├── Escalate
 └── Abort
```

## 9. Quality Gates

Los gates pueden ejecutarse:

```text
after stage
after group
before completion
```

## 10. Human Approval

Determinadas operaciones requieren aprobación humana.

Ejemplos:

- cambios destructivos;
- producción;
- seguridad crítica;
- cambios arquitectónicos importantes;
- acciones fuera del workspace.

## 11. Workflow State

```text
CREATED
PLANNED
RUNNING
BLOCKED
WAITING_APPROVAL
FAILED
COMPLETED
CANCELLED
```

## 12. Workflow Resumption

El workflow debe poder reanudarse desde un checkpoint.

```text
Workflow
 ↓
Checkpoint
 ↓
Failure
 ↓
Recovery
 ↓
Resume
```

## 13. Core Principle

> El workflow controla el proceso; los agentes ejecutan las responsabilidades.
