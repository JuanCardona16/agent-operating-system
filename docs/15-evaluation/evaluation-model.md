# Evaluation Model

## Evaluation Unit

```yaml
evaluation:
  id:
  target_type:
  target_id:
  version:
  dataset:
  evaluator:
  metrics:
  result:
  timestamp:
```

## Target Types

```text
agent
tool
workflow
model
prompt
memory
system
```

## Evaluation Dimensions

```text
correctness
completeness
reliability
safety
tool_discipline
maintainability
latency
cost
```

## Evidence

Toda métrica importante debe tener evidencia:

```text
test result
artifact
execution trace
human judgment
automated evaluator
```

## Versioning

Evaluar siempre contra versiones identificables:

```text
agent_version
prompt_version
model_version
workflow_version
dataset_version
```
