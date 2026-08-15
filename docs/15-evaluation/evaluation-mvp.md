# Evaluation MVP

## Objective

Crear un sistema mínimo de evaluación que permita saber si los agentes están mejorando o empeorando.

## MVP

```text
golden dataset
agent tests
workflow tests
basic rubrics
regression comparison
security smoke tests
cost/latency tracking
release gates
```

## Initial Agents

Evaluar primero:

```text
developer
tester
reviewer
```

Después:

```text
analyst
architect
security
researcher
```

## MVP Exit Criteria

- dataset versionado;
- baseline disponible;
- resultados reproducibles;
- regresiones detectables;
- gates automáticos básicos;
- fallos críticos bloquean release.
