# Metrics

## Core Metrics

### Reliability

```text
workflow_success_rate
agent_failure_rate
tool_failure_rate
retry_rate
```

### Performance

```text
workflow_duration
agent_duration
tool_duration
queue_time
```

### Quality

```text
quality_gate_pass_rate
evaluation_score
regression_rate
human_intervention_rate
```

### Cost

```text
tokens
model_cost
tool_cost
execution_cost
```

## Metric Dimensions

Útiles:

```text
agent_id
workflow_id
model
project
environment
version
```

## Rule

Evitar cardinalidad ilimitada en métricas. Datos altamente variables deben permanecer en logs/traces.
