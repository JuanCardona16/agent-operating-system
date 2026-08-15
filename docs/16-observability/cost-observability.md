# Cost Observability

## Purpose

Medir el coste real de agentes y workflows.

## Cost Components

```text
input tokens
output tokens
model calls
tool calls
external APIs
compute
storage
```

## Cost Record

```yaml
cost:
  execution_id:
  agent_id:
  model:
  input_tokens:
  output_tokens:
  tool_cost:
  total_cost:
```

## Analysis

```text
cost per task
cost per workflow
cost per agent
cost per successful task
```

## Important Metric

```text
cost per successful outcome
```

Es más útil que medir únicamente tokens.
