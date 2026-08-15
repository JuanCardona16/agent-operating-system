# 09 — Observabilidad

## Propósito

Este documento define la observabilidad del sistema multiagente: saber qué ocurrió, por qué ocurrió, cuánto costó y dónde falló. Es el documento normativo del dominio (véase ADR-014); `docs/08-operations/observability.md` y `docs/16-observability` quedan como material de origen y contexto.

Los tres pilares (logs, métricas, trazas) se complementan con eventos, artefactos, auditoría, alertas y dashboards. Toda información importante viaja en artefactos con provenance (véase ADR-013): `execution_id`, `agent_id`, `created_at`, `checksum`.

> Regla: si una ejecución no puede explicarse después de ocurrir, el sistema no tiene observabilidad suficiente.

## Correlación

Cadena de correlación única (véase ADR-014):

```text
request_id → task_id → execution_id → step_id → agent_id → tool_call_id   (+ trace_id)
```

```yaml
correlation:
  trace_id: <id>
  request_id: <id>
  task_id: TASK-<id>
  execution_id: EXEC-<id>
  step_id: STEP-<id>
  agent_id: <role>
  tool_call_id: TOOL-<id>
```

Toda operación debe poder correlacionarse. Los IDs se conservan entre handoffs y tool calls; cualquier ejecución puede reconstruirse desde su `request_id`.

> Regla: los identificadores de correlación se conservan entre handoffs y tool calls; sin ellos, un evento no es trazable.

## Jerarquía de entidades

```text
System → Workflow → Execution → Step → Agent → Tool Call
```

Todo resultado importante se rastrea hasta la ejecución que lo produjo.

## Modelo de eventos

### Envelope

```yaml
event:
  id: evt-<id>
  type: agent.failed
  timestamp: <ISO-8601>
  severity: info | warning | error | critical
  source: developer
  correlation:
    request_id: REQ-<id>
    task_id: TASK-<id>
    execution_id: EXEC-<id>
    step_id: STEP-<id>
    agent_id: developer
    tool_call_id: TOOL-<id>
    trace_id: TRACE-<id>
  payload:
    error_type: timeout
```

Los eventos son **pequeños, versionados y semánticamente estables**: un consumidor no debe quebrar cuando cambia el payload, y el `type` no cambia su significado.

### Categorías

`lifecycle`, `execution`, `tool`, `quality`, `security`, `approval`, `memory`, `failure`.

### Eventos mínimos

| Evento | Significado |
|---|---|
| `task.created`, `task.started`, `task.completed`, `task.failed` | ciclo de tarea |
| `agent.started`, `agent.completed`, `agent.failed` | ciclo de agente |
| `tool.called`, `tool.completed`, `tool.failed` | ciclo de herramienta |
| `handoff.created` | transferencia de trabajo |
| `quality_gate.passed`, `quality_gate.failed` | resultado de gate |
| `human_approval.requested`, `human_approval.approved`, `human_approval.rejected` | ciclo de aprobación |

Los consumidores de eventos alimentan logs, métricas, alertas, auditoría, dashboards, evaluación y pipelines de memoria.

> Regla: los eventos son pequeños, versionados y semánticamente estables; un cambio de significado es un tipo nuevo, no una edición.

## Trazas

```text
Trace
 └── Workflow Span
      ├── Step Span
      │    ├── Agent Span
      │    └── Tool Span
      └── Quality Gate Span
```

### Campos de span

```yaml
span:
  trace_id: TRACE-<id>
  span_id: SPAN-<id>
  parent_span_id: SPAN-<parent>
  operation: workflow.feature | step.analyze | agent.developer | tool.test.run | gate.G3
  start_time: <ISO-8601>
  end_time: <ISO-8601>
  status: ok | error | cancelled
  attributes:
    model: <model-id>
    task_type: feature
```

Ejemplo:

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

> Regla: un trace debe permitir identificar el cuello de botella y el punto exacto de fallo.

## Métricas

### Familias

| Familia | Métricas |
|---|---|
| Reliability | `workflow_success_rate`, `agent_failure_rate`, `tool_failure_rate`, `retry_rate` |
| Performance | `workflow_duration`, `agent_duration`, `tool_duration`, `queue_time` |
| Quality | `quality_gate_pass_rate`, `evaluation_score`, `regression_rate`, `human_intervention_rate` |
| Cost | `tokens`, `model_cost`, `tool_cost`, `execution_cost` |

### Dimensiones

`agent_id`, `workflow_id`, `model`, `project`, `environment`, `version`.

La latencia objetivo por paso de agente en flujo normal es **p95 < 120 s** (véase ADR-007). Se evita la cardinalidad ilimitada en métricas: los datos altamente variables pertenecen a logs y trazas.

> Regla: evitar cardinalidad ilimitada en métricas; datos altamente variables permanecen en logs/traces.

## Logs

Niveles: `DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`. Logging estructurado (JSON), no texto libre:

```json
{
  "event": "tool.completed",
  "execution_id": "EXEC-042",
  "agent_id": "developer",
  "tool": "git",
  "duration_ms": 842
}
```

Eventos recomendados: `task.created`, `workflow.started`, `step.started`, `agent.started`, `tool.called`, `tool.completed`, `quality_gate.failed`, `handoff.created`, `approval.requested`, `agent.failed`, `workflow.completed`.

**Nunca** se registran passwords, API keys, tokens, claves privadas ni secretos. La redacción ocurre antes de persistir.

> Regla: los logs nunca contienen secretos; la redacción precede a la persistencia.

## Auditoría

El audit trail es **append-only e inmutable** (véase ADR-014). Registra acciones de riesgo:

```yaml
audit:
  id: aud-<id>
  actor: <humano | agente | orchestrator>
  action: permission.change | destructive.op | deploy | secret.access | approval | policy.violation
  resource: <recurso afectado>
  decision: approved | rejected | executed | blocked
  timestamp: <ISO-8601>
  reason: "..."
  execution_id: EXEC-<id>
```

Eventos de auditoría: permission changes, operaciones destructivas, deployments, intentos de acceso a secretos, approvals, violaciones de política, fallos de seguridad. Requisitos: append-only, timestamped, correlated, protected, reviewable.

> Regla: audit y logs operacionales son conceptos relacionados pero no idénticos; el audit trail requiere controles de integridad más fuertes.

## Alertas

```yaml
alert:
  id: alert-<id>
  condition: workflow_failure_rate > 0.10 en 1 h
  severity: INFO | WARNING | CRITICAL
  owner: <rol o humano>
  action: revisar trazas de workflows fallidos
  cooldown: 30m
```

Categorías: availability, quality, security, cost, performance, capacity. Ejemplos: tasa de fallo de workflow sobre umbral, evento crítico de seguridad, cost spike, pico de timeouts de herramienta, regresión de agente.

> Regla: una alerta debe tener una acción asociada; las alertas que solo generan ruido se eliminan.

## Redacción

Pipeline obligatorio antes de almacenar o emitir:

```text
Raw Event → Sensitive Data Detector → Redaction → Storage
```

Niveles de redacción: `none`, `partial`, `full`. La redacción detecta y oculta credenciales, tokens, datos personales, claves privadas y secretos.

> Regla: la redacción ocurre antes de enviar datos a sistemas de observabilidad externos; debug mode no significa deshabilitar seguridad.

## Latencia

Desglose de la latencia total:

```text
Total → queue → planning → model → tool → retry → approval → validation
```

Percentiles `p50`, `p95`, `p99` para las operaciones relevantes. Detección de cuellos de botella: agentes lentos, herramientas lentas, retries repetidos, approvals largos, contexto grande.

> Regla: optimizar primero el componente que domina la latencia total, no el que simplemente parece lento.

## Integración

```text
Orchestrator → Event Bus → Logging · Metrics · Tracing · Audit · Alerts
```

La observabilidad es una **capacidad transversal**, no código duplicado dentro de cada agente. Cada agente emite eventos de `start`, `tool call`, `tool result`, `handoff`, `completion`, `failure`. Cada herramienta registra invocación, input validado, status del resultado, duración y error. La evaluación consulta trazas, artefactos, métricas, coste y fallos para reproducir y analizar resultados.

> Regla: la observabilidad es transversal; los agentes emiten eventos, no implementan su propia telemetría.

## Evaluación de la observabilidad

| Métrica | Definición |
|---|---|
| `trace_completeness` | proporción de spans esperados presentes |
| `event_loss_rate` | eventos perdidos / eventos emitidos |
| `redaction_success_rate` | datos sensibles sintéticos que no aparecen sin proteger |
| `alert_precision` | alertas accionables / alertas emitidas |
| `time_to_diagnose` | tiempo hasta la causa raíz |

Tests: correlación consistente (`task → workflow → step → agent → tool`), reconstrucción de un fallo provocado, redacción con datos sintéticos y completitud de eventos para acciones críticas.

> Regla: la observabilidad no debe convertirse en un canal alternativo para acceder a información que el usuario o agente no debería ver.

---

**Resuelto** (véase ADR-019): backend MVP de logs/trazas/eventos en archivos estructurados JSONL bajo
`runtime/` (git-ignored), con adaptador externo opcional. Retención por defecto: `audit` inmutable +
365 días, `events` 90, `traces` 30, `logs` 7, métricas agregadas 365. Umbrales de alerta: failure rate
> 20%/1h `warning`, > 40%/1h `critical`; cost spike > 2×/5× promedio semanal; p95 > 120 s `warning`;
retry rate > 30% `warning`; timeout rate > 10% `warning`. Coste marcado `cost_source: reported|estimated`.
