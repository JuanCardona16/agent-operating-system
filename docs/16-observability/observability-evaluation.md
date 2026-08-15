# Observability Evaluation

## Goals

Evaluar si podemos explicar las ejecuciones.

## Tests

### Correlation

Verificar que:

```text
task → workflow → step → agent → tool
```

mantenga IDs consistentes.

### Failure Reconstruction

Provocar un fallo y comprobar que puede reconstruirse.

### Redaction

Enviar datos sintéticos sensibles y comprobar que no aparecen sin proteger.

### Completeness

Verificar que acciones críticas generan eventos.

## Metrics

```text
trace_completeness
event_loss_rate
redaction_success_rate
alert_precision
time_to_diagnose
```
