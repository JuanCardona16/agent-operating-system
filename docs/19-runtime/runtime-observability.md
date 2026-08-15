# Runtime Observability

## Required Events

```text
runtime.started
agent.started
tool.called
tool.completed
agent.completed
agent.failed
workflow.started
workflow.completed
quality_gate.failed
```

## Correlation

```text
trace_id
execution_id
workflow_id
agent_id
tool_call_id
```

## Minimum Metrics

```text
duration
agent_calls
tool_calls
failures
retries
tokens
cost
```

## Rule

No declarar el runtime estable hasta poder reconstruir una ejecución fallida.
