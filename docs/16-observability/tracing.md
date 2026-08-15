# Distributed Tracing

## Purpose

Reconstruir una ejecución completa.

## Trace

```text
Trace
 └── Workflow Span
      ├── Step Span
      │    ├── Agent Span
      │    └── Tool Span
      └── Quality Gate Span
```

## Span Fields

```yaml
span:
  trace_id:
  span_id:
  parent_span_id:
  operation:
  start_time:
  end_time:
  status:
  attributes:
```

## Example

```text
workflow.feature
 ├── analyst
 │    └── filesystem.read
 ├── architect
 ├── developer
 │    ├── filesystem.write
 │    └── terminal.test
 └── reviewer
```

## Rule

Un trace debe permitir identificar el cuello de botella y el punto exacto de fallo.
