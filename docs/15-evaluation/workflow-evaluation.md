# Workflow Evaluation

## Purpose

Evaluar la calidad de la colaboración entre agentes.

## Metrics

```text
workflow_completion_rate
step_failure_rate
handoff_failure_rate
retry_rate
quality_gate_pass_rate
human_intervention_rate
total_cost
total_latency
```

## Workflow Case

```text
Task
 ↓
Analyst
 ↓
Architect
 ↓
Developer
 ↓
Tester
 ↓
Reviewer
```

Evaluar tanto cada step como el resultado final.

## Failure Analysis

Preguntar:

```text
Did the wrong agent run?
Was context lost?
Was a handoff incomplete?
Was a quality gate missing?
Was retry appropriate?
```

## Workflow Readiness

El workflow debe demostrar:

- reproducibilidad;
- trazabilidad;
- calidad estable;
- recuperación razonable;
- ausencia de fallos críticos conocidos.
