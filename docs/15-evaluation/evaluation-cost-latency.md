# Cost and Latency Evaluation

## Metrics

```text
tokens
model_cost
tool_cost
execution_duration
queue_time
agent_duration
workflow_duration
```

## Budget

Cada workflow puede definir:

```yaml
budget:
  max_cost:
  max_duration:
  max_tool_calls:
  max_retries:
```

## Efficiency

Comparar:

```text
quality gained
vs
cost introduced
```

## Rule

La optimización no debe sacrificar una métrica crítica de calidad o seguridad.
