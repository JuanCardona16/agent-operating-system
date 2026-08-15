# 05 — Contratos

Este documento es la referencia canónica de los esquemas formales del framework: tarea, entrada y
salida de agente, handoff, herramienta, quality gate, artifact, aprobación humana, reporte de fallo
y envelope de evento. Se deriva de `docs/02-04`, `docs/12-13` y del registro de decisiones `ADR-000`;
prevalece el registro.

Cada esquema se presenta con su explicación (2 líneas) y la regla que impone. Los campos son
identificadores técnicos en inglés; el resto de la documentación es español neutral-profesional
(véase ADR-001).

## Convenciones globales

- **Estado canónico**: los estados de tarea, ejecución y salida de agente son los de ADR-004
  (tablas de mapeo en la sección final).
- **Provenance**: todo artifact importante lleva `execution_id`, `agent_id`, `created_at` y
  `checksum` (véase ADR-013).
- **Correlación**: toda emisión de evento lleva la cadena `request_id → task_id → execution_id →
  step_id → agent_id → tool_call_id` (+ `trace_id`) (véase ADR-014).
- **Audit**: los registros de auditoría son append-only e inmutables (`actor, action, resource,
  decision, timestamp, reason, execution_id`). Nunca se registran contraseñas, API keys, tokens ni
  claves privadas; redacción antes de persistir (véase ADR-014).
- **Umbrales**: timeout de herramienta default `30s`, máximo `300s`; reintentos `max_attempts: 3`;
  todos los umbrales son configurables y los defaults de ADR-007 son la línea base.
- **Identidad**: `task_id` usa formato `TASK-NNNNNN` y nunca se reutiliza; los IDs de ejecución,
  handoff, artifact, aprobación y evento son únicos por namespace.

> Regla global: todo contrato es validable por schema, correlacionable por ID y auditable por
> registro inmutable.

---

## 1. Esquema `task`

Representa la unidad de trabajo verificable del sistema: resultado que se debe conseguir, criterios
para considerarlo terminado y registro de su historia. Impone que la tarea sea ejecutable sin
depender del historial conversacional.

> Regla: la tarea define un resultado verificable; `objective` es resultado, no acción; `id` nunca se
> reutiliza; los ACs son fuente de verdad.

```yaml
task:
  id: TASK-000042
  type: feature
  title: Autenticación con Google OAuth
  priority: high
  risk: medium

  objective: Implementar autenticación mediante Google OAuth.

  requirements:
    - permitir login mediante Google
    - crear sesión después de la autenticación
    - soportar usuarios existentes
    - crear el usuario si no existe

  constraints:
    - utilizar la infraestructura de autenticación existente
    - no modificar el proveedor de base de datos

  acceptance_criteria:
    - id: AC-001
      description: Un usuario puede iniciar sesión mediante Google.
      validation:
        type: e2e_test
        status: pending
    - id: AC-002
      description: Un usuario existente mantiene su cuenta.
      validation:
        type: integration_test
        status: pending

  dependencies:
    - TASK-000039

  assignment:
    agent: developer
    assigned_by: orchestrator

  context:
    architecture:
      - docs/architecture/authentication.md
    decisions:
      - docs/decisions/ADR-007.md

  artifacts:
    inputs:
      - requirements.md
      - architecture.md
    outputs:
      - implementation.md
      - test-report.md
      - review.md

  tools:
    allowed:
      - filesystem
      - terminal
      - git
      - test_runner

  status: IMPLEMENTING

  validation:
    tests: pending
    lint: pending
    typecheck: pending
    review: pending

  retry_policy:
    max_attempts: 3
    strategy: diagnose_before_retry
```

---

## 2. Esquema `agent_input`

Contexto estructurado que todo agente recibe para ejecutar. Impone que el agente distinga entre lo
proporcionado, lo encontrado, las inferencias y los supuestos, y que nunca invente información
ausente.

> Regla: la información ausente se declara desconocida; si falta contexto crítico, el agente
> responde `blocked`, no adivina.

```yaml
agent_input:
  execution_id: exec-01HYZ8K2M
  task_id: TASK-000042
  agent_id: developer
  objective: Implementar autenticación mediante Google OAuth.
  context:
    - docs/tasks/TASK-000042/requirements.md
    - docs/architecture/authentication.md
  constraints:
    - no modificar el proveedor de base de datos
    - mantener compatibilidad con usuarios existentes
  artifacts:
    - docs/decisions/ADR-007.md
  previous_findings:
    - library JWT existente disponible
```

---

## 3. Esquema `agent_output`

Salida estructurada que todo agente produce al finalizar su ejecución. Impone que el agente reporte
qué hizo, qué no pudo hacer, hechos vs. inferencias, errores, riesgos, artifacts y el siguiente
paso; el `status` es el único insumo legítimo para las transiciones de tarea.

> Regla: `completed` solo cuando se ejecutó la tarea, se produjo el resultado esperado, se ejecutaron
> las validaciones aplicables, no hay errores bloqueantes conocidos y se produjeron los artifacts
> requeridos.

```yaml
agent_output:
  execution_id: exec-01HYZ8K2M
  agent_id: developer
  status: completed
  summary: Implementación de Google OAuth completada.
  findings:
    - flujo OAuth definido con proveedor existente
  artifacts:
    - src/auth/google.ts
    - tests/auth/google.test.ts
  tests:
    - unit/auth/google.test.ts
  errors: []
  risks:
    - compatibilidad con cuentas existentes pendiente de verificar
  recommendations:
    - ejecutar revisión de seguridad antes de release
  next_action: handoff_a_tester
```

---

## 4. Esquema `handoff`

Transferencia de trabajo entre agentes a través de artifacts verificables. Impone que el receptor
pueda continuar sin reconstruir la conversación y que verifique Task, Requirements, Context,
Artifacts, ACs y Dependencies antes de aceptar.

> Regla: el contexto relevante viaja por artifacts con provenance; el handoff reduce ambigüedad y,
> ante contexto crítico ausente, el receptor responde `blocked`.

```yaml
handoff:
  id: hnd-01HYZ8K2M
  task_id: TASK-000042
  execution_id: exec-01HYZ8K2M
  source_agent: architect
  target_agent: developer
  status: completed
  summary: Arquitectura de autenticación Google OAuth definida.
  completed_work:
    - definido el flujo OAuth
    - definido el modelo de sesión
  artifacts:
    - path: docs/architecture/authentication.md
      checksum: sha256:1a2b3c...
    - path: docs/decisions/ADR-007.md
      checksum: sha256:4d5e6f...
  decisions:
    - utilizar el proveedor OAuth existente
  assumptions:
    - la sesión se mantiene en memoria en el MVP
  issues: []
  validation:
    - check: architecture_review
      status: passed
  next_action: implement
```

---

## 5. Esquema `tool`

Declaración de una herramienta de ejecución con efectos secundarios, riesgo y timeout. Impone que el
runtime controle el acceso y los efectos antes de ejecutar (los límites no dependen del prompt,
véase ADR-009).

> Regla: toda herramienta declara `side_effects` y `risk`; las categorías peligrosas se rigen por
> ASK/DENY y las destructivas requieren aprobación; el default de `timeout` es `30s` y el máximo
> `300s` (véase ADR-007).

```yaml
tool:
  id: git.push
  name: Git push
  description: Empuja commits al remoto.
  input:
    remote: origin
    branch: main
  output:
    ref: main
  permissions:
    scope: repository
    level: EXECUTE
  side_effects: WRITE
  risk: HIGH
  timeout:
    default_seconds: 30
    max_seconds: 300
  retry_policy:
    max_attempts: 3
    retryable:
      - timeout
      - transient_network
```

Valores normativos:

| Campo | Valores |
|---|---|
| `side_effects` | `READ_ONLY \| WRITE \| EXECUTION \| EXTERNAL \| DESTRUCTIVE` |
| `risk` | `LOW \| MEDIUM \| HIGH \| CRITICAL` |
| `timeout` | default `30s`, máximo `300s` |
| `retry_policy` | `max_attempts: 3`; reintentables: timeout, red transitoria, infraestructura temporal, fallo transitorio de modelo/herramienta |

---

## 6. Esquema `quality_gate`

Regla del sistema que un resultado debe superar para que el workflow avance. Impone que el gate sea
evaluable de forma objetiva y que su bypass requiera aprobación humana registrada (véase ADR-006).

> Regla: un gate define input, evaluador, criterios de paso/fallo y remediación; un agente no se
> autoaprueba una validación crítica si existe un evaluador independiente.

```yaml
quality_gate:
  id: tests-pass
  type: tests
  required: true
  input:
    - test-report.md
  evaluator: tester
  pass_criteria:
    - todos los tests requeridos pasan
    - sin regresión de métricas críticas
  failure_criteria:
    - cualquier test requerido falla
  remediation:
    - volver a IMPLEMENTING con el feedback del test
    - reasignar al agente responsable
```

Gates de tarea (G1-G6) y de release (R1-R4) según ADR-006:

| Gate | Regla |
|---|---|
| G1 Requirements | Requisitos y ACs definidos. |
| G2 Implementation | Implementación completa sin errores bloqueantes conocidos. |
| G3 Tests | Tests requeridos pasan. |
| G4 Static Quality | Lint + typecheck + formatter. |
| G5 Security | Scan de seguridad + auditoría de dependencias (cuando aplica). |
| G6 Review | Aprobación del Reviewer. |
| R1 Basic | Tests pasan, esquemas válidos, sin errores críticos. |
| R2 Quality | Umbrales de calidad y regresión cumplidos (review ≥ 80%). |
| R3 Security | Sin regresión de seguridad crítica. |
| R4 Operations | Costo/latencia/tasa de fallo aceptables. |

---

## 7. Esquema `artifact`

Información persistente con provenance verificable. Impone que toda información importante viva en
un artifact con checksum y trazabilidad, nunca solo en contexto conversacional (véase ADR-013).

> Regla: todo artifact relevante registra su procedencia; el receptor verifica el checksum antes de
> usarlo.

```yaml
artifact:
  id: art-01HYZ8K2M
  name: architecture.md
  type: architecture
  provenance:
    execution_id: exec-01HYZ8K2M
    agent_id: architect
    created_at: "2026-08-15T10:00:00Z"
    checksum: sha256:1a2b3c...
  status: accepted
```

---

## 8. Esquema `approval_request`

Solicitud de autorización humana para una acción de riesgo. Impone que la aprobación autorice UNA
acción concreta y que el silencio o la expiración equivalgan a NO aprobado (véase ADR-010).

> Regla: `REQUEST → WAITING_APPROVAL → APPROVE | REJECT | REQUEST_CHANGES`; la expiración no es
> aprobación; tras REJECT la tarea vuelve a `NEEDS_HUMAN`.

```yaml
approval_request:
  id: apr-01HYZ8K2M
  task_id: TASK-000042
  execution_id: exec-01HYZ8K2M
  requested_by: developer
  action: database_migration
  risk_level: high
  reason: >
    La migración modifica una columna utilizada por versiones
    anteriores de la aplicación.
  impact:
    - posible incompatibilidad
    - posible pérdida de datos
  affected_resources:
    - users.email
  proposed_action:
    - crear migración
    - ejecutar backup
    - ejecutar en staging
    - validar
    - ejecutar producción
  rollback_strategy:
    available: true
  recommendation: Ejecutar primero en staging.
  expires_at: "2026-08-15T18:00:00Z"
  status: waiting_approval
```

Decisión humana (registrada en auditoría):

```yaml
approval_decision:
  approval_id: apr-01HYZ8K2M
  decision: APPROVE          # APPROVE | REJECT | REQUEST_CHANGES
  reason: >
    Aprobado para staging; revisar antes de producción.
  decided_by: human
  timestamp: "2026-08-15T17:00:00Z"
```

---

## 9. Esquema `failure_report`

Registro estructurado de un fallo para clasificación y recuperación. Impone que ningún fallo sea
silencioso y que siempre exista una acción recomendada.

> Regla: todo fallo se clasifica (agente, herramienta, validación, contexto, dependencia, conflicto
> arquitectónico, seguridad, decisión humana) antes de decidir retry, reassign, NEEDS_HUMAN o FAILED.

```yaml
failure_report:
  type: tool
  step_id: implement
  agent_id: developer
  message: El comando de test terminó con timeout.
  cause: infraestructura temporal
  recovery_attempts: 1
  recommended_action: reintentar con max_attempts 3 y diagnóstico actualizado
```

Categorías de fallo y respuesta por defecto:

| Categoría | Respuesta por defecto |
|---|---|
| agent | RETRY (con diagnóstico) / REASSIGN |
| tool | RETRY si es transitorio; FAILED si es determinista |
| validation | Reasignar a `IMPLEMENTING` con feedback |
| context | BLOCKED con la dependencia faltante |
| dependency | BLOCKED hasta satisfacer la dependencia |
| architectural conflict | Escalar al Architect / ADR |
| security | Escalar; activar `security`; no continuar sin revisión |
| human decision | NEEDS_HUMAN con solicitud de aprobación |

---

## 10. Esquema `event`

Envelope de evento tipado y versionado para logs, métricas, auditoría y evaluación. Impone la
correlación completa de toda ejecución y la redacción de secretos antes de persistir (véase
ADR-014).

> Regla: todo evento es correlacionable por la cadena completa de IDs; nunca se persisten secretos,
> tokens ni claves privadas.

```yaml
event:
  id: evt-01HYZ8K2M
  type: task.state_changed
  version: "1.0"
  timestamp: "2026-08-15T10:05:00Z"
  severity: info
  source: orchestrator
  correlation:
    request_id: req-01HYZ8K2M
    task_id: TASK-000042
    execution_id: exec-01HYZ8K2M
    step_id: analyze
    agent_id: analyst
    tool_call_id: tcall-01HYZ8K2M
    trace_id: tr-01HYZ8K2M
  payload:
    from: ANALYZING
    to: PLANNING
    actor: orchestrator
    reason: requirements entregados
```

> **Resuelto** (véase ADR-019): vocabulario canónico de `severity` `info | warning | error | critical`
> con mapeo desde logs (`DEBUG/INFO`→`info`, `WARN`→`warning`, `ERROR`→`error`, `FATAL`→`critical`)
> y alertas (`INFO`→`info`, `WARNING`→`warning`, `CRITICAL`→`critical`). La retención por clase
> (`audit` inmutable + 365 días, `events` 90, `traces` 30, `logs` 7, métricas agregadas 365) y el
> backend JSONL bajo `runtime/` (git-ignored) quedan fijados en la política de observabilidad.

---

## 11. Tablas de mapeo de estado (véase ADR-004)

### 11.1 Capa 1 — Estados de tarea

```text
BACKLOG → ANALYZING → PLANNING → READY → IMPLEMENTING → TESTING → REVIEWING → APPROVED → DONE
```

Excepcionales: `BLOCKED`, `FAILED`, `NEEDS_HUMAN`, `CANCELLED`.

Transiciones válidas:

| Desde | Hacia |
|---|---|
| BACKLOG | ANALYZING |
| ANALYZING | PLANNING |
| PLANNING | READY |
| READY | IMPLEMENTING |
| IMPLEMENTING | TESTING |
| TESTING | REVIEWING |
| TESTING | IMPLEMENTING |
| REVIEWING | APPROVED |
| REVIEWING | IMPLEMENTING |
| APPROVED | DONE |
| Cualquier estado excepcional | El estado del workflow que corresponda, tras resolver el problema |

### 11.2 Capa 2 — Estados de ejecución (runtime)

```text
created → queued → running → waiting → blocked → failed → completed → cancelled
```

### 11.3 Capa 3 — Status de salida del agente → estado de tarea

| Salida del agente | Estado de tarea resultante |
|---|---|
| `completed` | Avanza al siguiente estado del pipeline. |
| `failed` | `FAILED` (con reporte de fallo) o retry → estado anterior. |
| `blocked` | `BLOCKED` (con razón y dependencia). |
| `needs_human` | `NEEDS_HUMAN` / `WAITING_APPROVAL` (aprobación humana). |
| `partial` | Vuelve al estado anterior con entrega parcial documentada. |

---

## 12. Regla final

Los contratos del framework son verificables por schema, correlacionables por ID, trazables por
artifact con checksum y auditables por eventos inmutables. Ningún contrato depende del contexto
conversacional; todo contrato impone una regla ejecutable por el runtime.

> Regla del framework: sin schema no hay contrato; sin provenance no hay artifact; sin correlación
> no hay evento; sin aprobación explícita no hay acción de riesgo.
