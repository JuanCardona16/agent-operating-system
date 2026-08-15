# Evaluation Datasets

## Purpose

Crear tareas representativas para medir agentes de forma reproducible.

## Dataset Categories

```text
happy path
edge case
failure case
ambiguous task
security case
regression case
tool-use case
```

## Dataset Record

```yaml
case:
  id:
  category:
  input:
  context:
  expected:
  constraints:
  risk:
  evaluator:
```

## Dataset Requirements

Un dataset útil debe:

- representar trabajo real;
- incluir casos difíciles;
- incluir fallos conocidos;
- evitar sobreajuste a un prompt concreto;
- mantenerse versionado.

## Golden Set

Mantener un conjunto pequeño de casos críticos:

```text
golden/
├── analyst/
├── architect/
├── developer/
├── tester/
├── reviewer/
└── security/
```

## Rule

Los datasets deben evolucionar cuando aparezcan nuevos incidentes o clases de error.
