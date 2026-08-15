# Metrics

## 1. Purpose

Las métricas permiten evaluar objetivamente el sistema.

No debemos optimizar únicamente la cantidad de tareas completadas.

También debemos medir:

- calidad;
- tiempo;
- coste;
- reintentos;
- errores;
- intervención humana.

## 2. Task Metrics

### Completion Rate

```text
completed_tasks / total_tasks
```

### Failure Rate

```text
failed_tasks / total_tasks
```

### Retry Rate

```text
retried_tasks / total_tasks
```

### Human Escalation Rate

```text
human_escalations / total_tasks
```

## 3. Performance Metrics

### Task Duration

Tiempo desde:

```text
task.created
```

hasta:

```text
task.completed
```

### Agent Duration

Tiempo de ejecución de cada agente.

### Tool Duration

Tiempo consumido por cada herramienta.

## 4. Quality Metrics

### Test Pass Rate

```text
passed_tests / executed_tests
```

### Review Approval Rate

```text
approved_reviews / total_reviews
```

### Defect Escape Rate

Defectos descubiertos después de completar una tarea.

## 5. Efficiency Metrics

### Agent Turns

Número de ciclos de ejecución de agentes.

### Tool Calls

Número de llamadas a herramientas.

### Rework

Cantidad de trabajo repetido.

## 6. Cost Metrics

Cuando el proveedor/modelo lo permita:

```text
input_tokens
output_tokens
total_tokens
model_cost
tool_cost
```

También:

```text
cost_per_task
cost_per_successful_task
```

## 7. Model Metrics

Cuando existan varios modelos:

```text
model
task_type
success_rate
latency
cost
retry_rate
```

Esto permitirá construir posteriormente un sistema de model routing.

## 8. Agent Performance

Por agente:

```text
completion_rate
failure_rate
average_duration
average_cost
review_rejection_rate
```

No debe interpretarse una métrica aislada como indicador absoluto de calidad.

## 9. Workflow Metrics

Medir:

```text
time_in_analysis
time_in_planning
time_in_implementation
time_in_testing
time_in_review
```

Esto permite detectar cuellos de botella.

## 10. Core Principle

> Una métrica debe utilizarse para aprender y mejorar el sistema, no simplemente para premiar al agente que produce más actividad.
