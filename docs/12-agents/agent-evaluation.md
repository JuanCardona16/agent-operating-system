# Agent Evaluation

## Evaluation Dimensions

```text
Correctness
Task Completion
Safety
Tool Discipline
Output Quality
Reliability
Latency
Cost
```

## Evaluation Dataset

Crear tareas representativas por agente.

### Developer
- bug fixes;
- features;
- refactors;
- tests.

### Tester
- failing tests;
- regression detection;
- missing test cases.

### Reviewer
- bugs;
- security issues;
- maintainability issues.

### Analyst
- requirement extraction;
- ambiguity detection.

### Architect
- architecture decisions;
- trade-off analysis.

### Researcher
- documentation retrieval;
- technology comparison.

### Security
- vulnerability identification;
- permission analysis.

## Baseline

Cada agente debe tener un baseline antes de modificar:

- prompt;
- model;
- tools;
- permissions.

## Evaluation Rule

> No evaluar un agente únicamente por si produce una respuesta convincente. Evaluar el resultado verificable.
