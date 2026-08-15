# Task Intake

## Purpose

Normalizar cualquier solicitud antes de ejecutar agentes.

## Intake Pipeline

```text
Raw Request
   ↓
Parse
   ↓
Normalize
   ↓
Classify
   ↓
Extract Constraints
   ↓
Determine Risk
   ↓
Create Task
```

## Task Schema

```yaml
task:
  id:
  title:
  description:
  type:
  priority:
  constraints:
  risk:
  requested_by:
  acceptance_criteria:
  context:
```

## Task Types

```text
feature
bug
refactor
test
research
architecture
security
documentation
maintenance
```

## Risk

```text
low
medium
high
critical
```

## Intake Rule

Si faltan datos críticos, el orchestrator debe:

```text
ask
or infer safely
or block
```

No inventar requisitos importantes.
