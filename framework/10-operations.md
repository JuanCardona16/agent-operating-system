# 10 — Operaciones

## Propósito

Este documento define la operación del sistema multiagente: cómo se mantiene operativo ante fallos, cómo se seleccionan modelos y cómo se controla el coste. Es normativo por ADR-005 (política de reintentos), ADR-007 (umbrales) y ADR-002 (el Orchestrator como controlador de flujo, incluyendo retry manager y checkpoints); `docs/08-operations` queda como material de origen y contexto.

Principio rector: **un fallo del sistema no debería obligar a reiniciar el trabajo desde cero**.

> Regla: la recuperación es por diseño, no por accidente; todo fallo se clasifica antes de actuar.

## Dominios de fallo

| Dominio | Ejemplos |
|---|---|
| Model | timeout, output inválido, fallo de razonamiento |
| Agent | loop, mal uso de herramientas, salida fuera de contrato |
| Tool | fallo, timeout, permiso denegado |
| Network | timeout, resolución DNS, conexión caída |
| Memory | backend no disponible, registro corrupto |
| Repository | conflicto de merge, rama ausente, checkout fallido |
| Orchestrator | error de scheduling, estado inconsistente, checkpoint inválido |
| External Service | API externa degradada o caída |

Cada componente tiene una estrategia de recuperación definida.

## Escalera de recuperación

```text
Transient failure → Retry
Persistent failure → Fallback
Critical failure   → Human escalation
```

### Política de reintentos (véase ADR-005)

- `max_attempts: 3`, backoff exponencial.
- **Cada reintento debe añadir información nueva** (diagnóstico antes de reintentar).
- Protección de bucle: `max_same_transition: 3`.

Clasificación obligatoria antes de reintentar:

| Reintentable | NO reintentable |
|---|---|
| timeout | permiso denegado |
| fallo transitorio de red | requisitos inválidos |
| infraestructura temporal | violación de política |
| fallo transitorio de modelo/herramienta | acción destructiva rechazada |
|  | fallo determinista de test |

Umbrales base (véase ADR-007): timeout de herramienta default `30s` / máximo `300s`; presupuesto por tarea `max_duration_minutes: 30`, `max_retries: 3`.

> Regla: un retry que no aporta información nueva no es un retry, es un loop disfrazado.

## Idempotencia

Las operaciones que pueden repetirse deben ser idempotentes cuando sea posible. Especialmente:

- task creation;
- memory writes;
- artifact creation;
- external API calls.

Los steps que pueden repetirse se diseñan para minimizar efectos duplicados (véase ADR-004 para las transiciones de estado válidas).

> Regla: toda operación repetible debe tolerar una ejecución duplicada sin efectos dobles.

## Checkpoints

### Creación

Se crea checkpoint después de: **step completado, quality gate, handoff, approval, recovery** (véase ADR-002 y `docs/13-orchestration/state-and-checkpoints.md`).

```yaml
checkpoint:
  execution_id: EXEC-<id>
  workflow_id: WF-<id>
  step_id: STEP-<id>
  state: <estado de la capa de ejecución según ADR-004>
  artifacts: [ "...", "..." ]
  findings: [ "...", "..." ]
  completed_steps: [ "...", "..." ]
  pending_steps: [ "...", "..." ]
  timestamp: <ISO-8601>
```

### Reanudación

```text
Load Checkpoint → Validate State → Determine Pending Step → Resume Workflow
```

El estado del sistema se conserva: task state, agent state, artifacts, tool results, validation.

> Regla: no asumir que el proceso anterior terminó correctamente solo porque existe un registro de ejecución; el estado se valida antes de reanudar.

## Routing de modelos

El modelo es un componente intercambiable del agente; el Router selecciona el modelo apropiado para cada ejecución.

### Factores de routing

`task complexity`, `reasoning requirement`, `coding requirement`, `context size`, `latency`, `cost`, `historical success`, `risk`.

### Complejidad y mapeo

Complejidad: `simple | moderate | complex | critical`.

| Complejidad | Ejemplo | Modelo sugerido |
|---|---|---|
| `simple` | formateo, renombrado trivial | low-cost |
| `moderate` | coding rutinario | coding model |
| `complex` | arquitectura, refactor amplio | high-reasoning |
| `critical` | security review, decisión crítica | high-reasoning / especializado + human approval |

### Escalado dinámico

El Router puede cambiar de modelo cuando: calidad insuficiente, tool failures, fallo de razonamiento, complejidad de contexto.

```text
Model A → resultado rechazado → Model B → review
```

El escalado de modelo debe estar **justificado** y nunca exceder el presupuesto de la tarea (ver costes). No se usa el modelo más caro por defecto.

### Independencia de modelo

Los contratos de agentes **no dependen de un modelo concreto**: debe ser posible cambiar `Model A → Model B` sin rediseñar el agente. Los modelos se evalúan por success rate, calidad, coste, latencia, retries y review outcome contra tareas reales del sistema, no por benchmark general.

> Regla: el modelo se selecciona por la naturaleza del trabajo, no por preferencia arbitraria; ningún contrato depende de un modelo concreto.

## Gestión de coste

### Fuentes y atribución

Fuentes: LLM inference, tool execution, external APIs, search, infraestructura, storage. Cada coste se atribuye a: `project`, `task`, `agent`, `model`, `execution`, `tool`.

### Métricas primarias

```text
total_task_cost     # coste total por tarea
cost_per_success    # coste por resultado exitoso
```

`cost_per_success` es más útil que medir solo tokens (véase `docs/16-observability/cost-observability.md`).

### Presupuesto por tarea

```yaml
budget:
  max_cost: <monto>
  max_tokens: <n>
  max_execution_time: <segundos>
  max_retries: <n>
```

Al alcanzar un límite: **`LIMIT_REACHED`**.

**Handler definido**: la tarea falla explícitamente con un budget report; nunca se escala de modelo silenciosamente excediendo el presupuesto. El escalado solo ocurre cuando está justificado y dentro de presupuesto:

```text
Model A → failure → Model B → failure → Human / Architect
```

### Palancas de optimización

`context compression`, `caching`, `model routing`, `task decomposition`, evitar llamadas duplicadas, `result reuse`, memoria.

> Regla: el objetivo no es minimizar el coste absoluto, sino maximizar el valor obtenido por unidad de coste; un límite de presupuesto nunca se elude en silencio.

## Métricas

### Fórmulas

| Métrica | Fórmula |
|---|---|
| `completion_rate` | `completed_tasks / total_tasks` |
| `failure_rate` | `failed_tasks / total_tasks` |
| `retry_rate` | `retried_tasks / total_tasks` |
| `human_escalation_rate` | `human_escalations / total_tasks` |
| `test_pass_rate` | `passed_tests / executed_tests` |
| `review_approval_rate` | `approved_reviews / total_reviews` |
| `defect_escape_rate` | defectos descubiertos después de completar la tarea |
| `cost_per_task` | coste total / tareas |
| `cost_per_successful_task` | coste total / tareas exitosas |

### Dimensiones de observación

- **Rendimiento**: task duration (de `task.created` a `task.completed`), agent duration, tool duration.
- **Eficiencia**: agent turns, tool calls, rework.
- **Por modelo**: `model`, `task_type`, `success_rate`, `latency`, `cost`, `retry_rate` (alimenta el routing).
- **Por agente**: `completion_rate`, `failure_rate`, `average_duration`, `average_cost`, `review_rejection_rate`.
- **Por workflow**: `time_in_analysis`, `time_in_planning`, `time_in_implementation`, `time_in_testing`, `time_in_review` (detecta cuellos de botella).

> Regla: nunca se interpreta una métrica aislada como indicador absoluto de calidad; una métrica se usa para aprender y mejorar el sistema, no para premiar la actividad.

---

**Resuelto** (véase ADR-019): umbrales de alerta por defecto — workflow failure rate > 20%/1h `warning`
y > 40%/1h `critical`; cost spike > 2×/5× promedio semanal; p95 de paso de agente > 120 s `warning`
(véase ADR-007); retry rate > 30% `warning`; timeout rate > 10% `warning`. Asignación de coste a
modelo: cuando el proveedor no expone el dato se estima por tokens con tabla de precios por modelo en
configuración, marcado `cost_source: reported|estimated`; el dato real reportado nunca se duplica.
