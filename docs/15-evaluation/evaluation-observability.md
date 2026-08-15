# Evaluation Observability

## Required Data

Cada evaluación debe registrar:

```text
evaluation_id
target
version
dataset_version
model
prompt_version
duration
cost
metrics
failures
artifacts
```

## Traceability

```text
Evaluation
 └── Case
      └── Execution
           ├── Agent
           ├── Tools
           ├── Memory
           └── Quality Gates
```

## Reproducibility

Siempre que sea posible guardar:

```text
configuration
dataset
versions
inputs
outputs
evaluation result
```
