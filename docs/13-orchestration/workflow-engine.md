# Workflow Engine

## Purpose

Definir workflows reproducibles.

## Workflow Model

```yaml
workflow:
  id: feature-development
  version: "1.0"

  steps:
    - id: analyze
      agent: analyst

    - id: design
      agent: architect

    - id: implement
      agent: developer

    - id: test
      agent: tester

    - id: review
      agent: reviewer
```

## Step

```yaml
step:
  id:
  agent:
  input:
  depends_on:
  condition:
  retry_policy:
  timeout:
  quality_gates:
```

## Execution

```text
Step A
  ↓
Step B
  ↓
Step C
  ↓
Step D
```

## Dependencies

Un step no puede ejecutarse hasta que sus dependencias estén satisfechas.

## Conditional Steps

```text
if security_sensitive == true
    → security
```

## Parallelism

Cuando no existen dependencias:

```text
          ┌→ tester
developer ┤
          └→ security
```

El MVP debe mantener paralelización conservadora y explícita.
