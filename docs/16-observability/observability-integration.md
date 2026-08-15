# Observability Integration

## Integration Points

```text
Orchestrator
   ↓
Event Bus
   ├── Logging
   ├── Metrics
   ├── Tracing
   ├── Audit
   └── Alerts
```

## Agent Integration

Cada agente debe emitir eventos de:

```text
start
tool call
tool result
handoff
completion
failure
```

## Tool Integration

Cada herramienta debe registrar:

```text
invocation
validated input
result status
duration
error
```

## Evaluation Integration

Evaluation debe poder consultar:

```text
traces
artifacts
metrics
cost
failures
```

para reproducir y analizar resultados.

## Rule

Observability debe ser una capacidad transversal, no código duplicado dentro de cada agente.
