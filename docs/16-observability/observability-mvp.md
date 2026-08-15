# Observability MVP

## Objective

Obtener visibilidad suficiente para depurar el primer sistema multiagente.

## MVP Includes

```text
structured logs
correlation IDs
basic traces
execution metrics
agent metrics
tool metrics
cost tracking
failure events
audit events
basic dashboard data
redaction
```

## Minimum Trace

```text
task
 ↓
workflow
 ↓
step
 ↓
agent
 ↓
tool
 ↓
result
```

## Exit Criteria

- cualquier ejecución puede localizarse;
- los fallos pueden reconstruirse;
- coste básico es medible;
- acciones críticas quedan auditadas;
- secretos no aparecen en logs;
- métricas principales están disponibles.
