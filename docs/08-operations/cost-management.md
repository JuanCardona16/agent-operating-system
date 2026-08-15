# Cost Management

## 1. Purpose

Controlar el coste de ejecutar agentes, modelos y herramientas.

## 2. Cost Sources

Los principales costes pueden proceder de:

```text
LLM inference
Tool execution
External APIs
Search
Infrastructure
Storage
```

## 3. Cost Attribution

Cada coste debe asociarse cuando sea posible con:

```text
project
task
agent
model
execution
tool
```

## 4. Cost Per Task

Métrica principal:

```text
total_task_cost
```

También:

```text
cost_per_success
```

## 5. Model Routing

No todas las tareas requieren el modelo más costoso.

Ejemplo conceptual:

```text
Simple task
    ↓
Fast / low-cost model

Complex architecture
    ↓
High-reasoning model

Code review
    ↓
Specialized model

Research
    ↓
Research-capable model
```

## 6. Budget Limits

Una tarea puede tener:

```yaml
budget:
  max_cost:
  max_tokens:
  max_execution_time:
  max_retries:
```

Si se alcanza un límite:

```text
LIMIT_REACHED
```

## 7. Cost Escalation

El sistema puede escalar el modelo solamente cuando esté justificado.

Ejemplo:

```text
Model A
 ↓
failure
 ↓
Model B
 ↓
failure
 ↓
Human / Architect
```

No debe utilizarse el modelo más caro por defecto.

## 8. Cost Optimization

El sistema debe optimizar mediante:

- context compression;
- caching;
- model routing;
- task decomposition;
- evitar llamadas duplicadas;
- reutilización de resultados;
- memoria.

## 9. Core Principle

> El objetivo no es minimizar el coste absoluto, sino maximizar el valor obtenido por unidad de coste.
