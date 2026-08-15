# Observability Integration

## Required Correlation

```text
task_id
execution_id
workflow_id
step_id
agent_id
tool_call_id
trace_id
```

## Events

Agents should produce events for:

```text
started
tool.called
tool.completed
handoff
completed
failed
```

## Metrics

At minimum:

```text
duration
tool_calls
tokens
cost
failures
retries
```

## Rule

OpenCode execution must remain reconstructable through the observability layer.
