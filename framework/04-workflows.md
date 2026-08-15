# 04 — Workflows

Este documento define el workflow canónico de desarrollo, las reglas de routing dinámico, el
contrato de delegación, el contrato de handoffs, la gestión de fallos y el contrato de aprobación
humana. Se deriva de `docs/04-workflows`, `docs/13-orchestration` y del registro de decisiones
`ADR-000`; prevalece el registro.

**Principios del workflow**:

- determinista en sus reglas;
- flexible en la selección de agentes;
- observable;
- recuperable ante fallos;
- seguro ante operaciones críticas.

La inteligencia puede ser probabilística. **El proceso no lo es.**

---

## 1. Workflow canónico de desarrollo (8 etapas)

```text
USER REQUEST
   ↓
1. REQUEST INTAKE
   ↓
2. ANALYSIS
   ↓
3. PLANNING
   ↓
4. ARCHITECTURE        ← obligatoria
   ↓
5. IMPLEMENTATION
   ↓
6. TESTING
   ↓
7. REVIEW
   ↓
8. COMPLETION → DONE
```

| # | Etapa | Responsable | Entrada | Salida principal | Gate (véase ADR-006) |
|---|---|---|---|---|---|
| 1 | Request Intake | Orchestrator | Solicitud del usuario | `TASK-NNNNNN` en `BACKLOG`; solicitud original conservada en el contexto | — |
| 2 | Analysis | Analyst | Solicitud normalizada | `requirements.md`: objetivo, requisitos, restricciones, ambigüedades, dependencias, ACs, preguntas abiertas | G1 Requirements |
| 3 | Planning | Orchestrator | Requisitos | Plan de ejecución: subtareas, dependencias, agentes, orden, paralelismo posible, herramientas | — |
| 4 | Architecture | Architect | Requisitos + plan | `architecture.md`; cuando corresponda `ADR-XXX.md` | — |
| 5 | Implementation | Developer | Task Contract completo | Implementación + tests | G2 Implementation, G4 Static Quality |
| 6 | Testing | Tester | Implementación + ACs | `test-report.md` (PASS / FAIL) | G3 Tests |
| 7 | Review | Reviewer | Implementación + tests | `review-report.md` (APPROVED / CHANGES_REQUIRED) | G6 Review |
| 8 | Completion | Orchestrator | Validaciones y gates | `APPROVED → DONE` | Todos los gates requeridos |

### 1.1 La etapa de Architecture es obligatoria (véase ADR-002, ADR-013)

La etapa 4 no es opcional. Toda tarea que modifique estructura del sistema pasa por el Architect y
produce una decisión de diseño:

- Si la tarea requiere una decisión arquitectónica nueva, se produce `architecture.md` y se registra
  como `ADR-XXX.md` (las decisiones persisten como ADR, nunca solo en historial de chat).
- Si la tarea **no** requiere una decisión nueva, la etapa produce un registro mínimo y explícito
  "sin cambio arquitectónico" que documenta por qué, para que la omisión sea una decisión trazable y
  no un vacío.

Esto corrige la laguna de la especificación original (la secuencia "Analysis → Planning →
Implementation" sin etapa de arquitectura) y garantiza que ningún cambio estructural entre en
implementación sin diseño registrado.

> Regla: no existe implementación sin entrada de arquitectura; si no hay decisión de diseño nueva,
> la decisión "no hay cambio estructural" queda registrada y verificable.

### 1.2 Detalle por etapa

**1 Request Intake**: el Orchestrator normaliza la solicitud (parse → normalize → classify → extract
constraints → determine risk → create task). Si faltan datos críticos, el Orquestador pregunta,
infiere de forma segura o bloquea; nunca inventa requisitos importantes.

**2 Analysis**: si existe información crítica ausente, `ANALYZING → NEEDS_HUMAN`. El sistema no
inventa requisitos críticos.

**3 Planning**: define subtareas con referencia al padre (`parent_task_id`), dependencias y posible
paralelismo conservador y explícito.

**4 Architecture**: como se describe en 1.1.

**5 Implementation**: el Developer inspecciona el repositorio, comprende la implementación existente,
identifica archivos relevantes, planifica, ejecuta los cambios y ejecuta validaciones.

**6 Testing**: unit, integration, e2e, regression, static analysis y type checking; produce
`test-report.md` con veredicto `PASS` o `FAIL`.

**7 Review**: el Reviewer analiza independientemente del Developer: corrección, mantenibilidad,
arquitectura, seguridad, consistencia, cobertura de tests y cumplimiento de requisitos; veredicto
`APPROVED` o `CHANGES_REQUIRED`.

**8 Completion**: una tarea finaliza solo cuando Requirements, ACs, Tests, Quality Gates y Review
están cumplidos; entonces `APPROVED → DONE`.

---

## 2. Routing dinámico

El workflow no es rígido: el Orchestrator decide la ruta por tipo de tarea, de forma determinista en
el MVP (véase 12-agents/agent-selection.md y 13-orchestration/agent-resolution.md).

| Tipo de solicitud | Ruta |
|---|---|
| Typo / corrección trivial | `developer → test → done` |
| Bug fix | `developer → tester → reviewer` |
| Cambio de arquitectura | `analyst → architect → developer → tester → reviewer` |
| Problema de seguridad | `security → developer → tester → reviewer` |
| Tarea de investigación | `researcher → analyst` |
| Sistema complejo (ej. nuevo sistema de pagos) | Pipeline completo: `analyst → researcher → architect → developer → (database) → security → tester → reviewer` |

Reglas:

- La selección inicial es **explícita y determinista**: `Task Type → Workflow → Agent`.
- El routing dinámico por capacidad/rendimiento se introduce solo cuando existen métricas
  suficientes que lo justifiquen; no antes.
- El paralelismo se limita a tareas independientes; en el MVP se prefiere análisis read-only en
  paralelo antes que escritura concurrente en el mismo workspace (riesgo de race conditions, edits
  conflictivos y estados intermedios inválidos).

> Regla: el proceso es determinista en sus reglas y flexible en la selección de agentes; la ruta se
> decide por tipo de tarea y evidencia, nunca por conveniencia.

---

## 3. Delegación

La delegación es explícita, trazable y limitada por el scope de cada agente.

### 3.1 Contrato de delegación

```yaml
delegation:
  task_id: TASK-000042
  parent_task_id: TASK-000001
  agent: developer
  objective: Implementar autenticación mediante Google OAuth.
  requirements:
    - permitir login mediante Google
    - crear sesión después de la autenticación
  constraints:
    - no modificar el proveedor de base de datos
  acceptance_criteria:
    - AC-001
    - AC-002
  context:
    - docs/architecture/authentication.md
    - docs/decisions/ADR-007.md
  artifacts:
    inputs:
      - requirements.md
    outputs:
      - implementation.md
      - test-report.md
  tools:
    - read
    - write
    - edit
    - bash
    - git
    - test
  expected_output:
    - implementación
    - tests
```

### 3.2 Criterios de selección del agente

| Criterio | Pregunta |
|---|---|
| Role Fit | ¿El agente tiene la responsabilidad adecuada? |
| Capability Fit | ¿Tiene las capacidades necesarias? |
| Tool Fit | ¿Dispone de las herramientas requeridas? |
| Permission Fit | ¿Puede realizar las operaciones necesarias? |
| Context Fit | ¿Tiene acceso al contexto necesario? |

### 3.3 Reglas de delegación

El Orchestrator debe:

1. evitar duplicar trabajo;
2. proporcionar suficiente contexto;
3. no sobrecargar al agente con contexto irrelevante;
4. respetar permisos;
5. especificar acceptance criteria;
6. registrar la delegación.

**Principio de delegación**: delegar **resultados**, no acciones.

- Incorrecto: "Edita auth.ts."
- Correcto: "Implementa autenticación Google OAuth cumpliendo AC-001 a AC-005."

Anti-patrones: "Haz lo que consideres necesario", "Implementa todo el sistema" sin requisitos,
criterios o límites.

### 3.4 Re-delegación

Una tarea puede reasignarse cuando el agente falla, no tiene capacidad suficiente, aparece un
problema fuera de scope o se requiere otra especialización.

```text
Developer → Blocked: problema arquitectónico → Architect → Decisión → Developer
```

> Regla: se delega un resultado verificable con criterios y límites; el agente asignado ejecuta, no
> redecide el objetivo.

---

## 4. Handoffs (véase ADR-013)

Un handoff ocurre cuando el resultado de un agente se convierte en entrada para otro. Es explícito,
estructurado y **viaja por artifacts verificables, nunca por contexto conversacional oculto**.

### 4.1 Contrato de handoff

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
    - identificados los componentes necesarios

  artifacts:
    - path: docs/architecture/authentication.md
    - path: docs/decisions/ADR-007.md

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

### 4.2 Reglas del handoff

- El agente emisor entrega únicamente contexto relevante, decisiones, artifacts, restricciones,
  problemas y criterios de aceptación.
- No se transfiere indiscriminadamente todo el contexto disponible.
- Artifact first: siempre que exista información importante existe un artifact persistente. Una
  decisión arquitectónica vive en un ADR, nunca en historial de chat.
- Los handoffs no dependen únicamente del historial completo de conversación.

### 4.3 Validación del receptor

El agente receptor debe verificar que dispone de:

```text
Task
Requirements
Context
Artifacts
Acceptance Criteria
Dependencies
```

Si falta información crítica:

```text
RECEIVED → INSPECT → MISSING CONTEXT → BLOCKED
```

El receptor puede rechazar el trabajo cuando falta información, existe contradicción, no tiene
permisos, la tarea está fuera de su scope o existe un riesgo que requiere aprobación.

> Regla: un handoff debe reducir ambigüedad, no mover contexto de una conversación a otra; sin
> contexto crítico verificado, el receptor responde `blocked`.

---

## 5. Gestión de fallos

Objetivo: evitar loops infinitos, errores silenciosos, pérdida de contexto, falsas finalizaciones y
cambios destructivos.

### 5.1 Categorías de fallo

| Categoría | Descripción |
|---|---|
| Agent | El agente no puede completar la tarea. |
| Tool | Una herramienta falla. |
| Validation | La implementación no cumple los criterios. |
| Context | Falta información necesaria. |
| Dependency | Una dependencia no está disponible. |
| Architectural conflict | La implementación revela un problema arquitectónico. |
| Security | Se detecta un problema de seguridad. |
| Human decision required | El sistema necesita una decisión humana. |

### 5.2 Flujo de fallo

```text
FAILURE → CLASSIFY
   ├── recoverable              → RETRY (max_attempts: 3, cada retry añade información nueva)
   ├── requiere otro agente      → REASSIGN
   ├── requiere decisión humana  → NEEDS_HUMAN
   └── no recuperable            → FAILED
```

### 5.3 Fallos específicos

- **Validation failure**: `TESTING → FAIL → IMPLEMENTING`. El feedback llega al agente que
  implementó.
- **Review failure**: `REVIEWING → CHANGES_REQUIRED → IMPLEMENTING`. El Reviewer debe proporcionar
  observaciones concretas.

### 5.4 Protección de bucles

```text
Developer → Tester → Developer → Tester → Developer → Tester → STOP
```

Si el mismo patrón de transición se repite excesivamente, el Orchestrator detiene la ejecución:

```yaml
loop_protection:
  max_same_transition: 3
```

### 5.5 Escalación

Una tarea debe escalar cuando:

- se supera el máximo de reintentos;
- existe una decisión arquitectónica crítica;
- existe riesgo de pérdida de datos;
- se requiere acceso privilegiado;
- existe ambigüedad crítica;
- se detecta un riesgo de seguridad importante.

Todo fallo se registra con el reporte de fallo: `type`, `step_id`, `agent_id`, `message`, `cause`,
`recovery_attempts`, `recommended_action` (esquema formal en `05-contracts.md`).

> Regla: detectar → clasificar → recuperar → validar → continuar; los errores son parte normal del
> workflow, los loops infinitos no.

---

## 6. Aprobación humana (véase ADR-010)

La aprobación humana es la frontera explícita entre ejecución autónoma y autorización humana.

### 6.1 Niveles de riesgo

| Nivel | Comportamiento | Ejemplos |
|---|---|---|
| LOW | Se ejecuta automáticamente. | Leer archivos; ejecutar tests; ejecutar linters; crear documentación; modificar código dentro del scope. |
| MEDIUM | Puede requerir validación según el contexto. | Añadir dependencias; modificar configuraciones; cambios amplios de código; cambios de API. |
| HIGH | Requiere aprobación humana. | Migraciones de base de datos; modificaciones de infraestructura; cambios de seguridad; acceso a recursos sensibles; operaciones potencialmente destructivas. |
| CRITICAL | No se ejecuta automáticamente en el MVP. | Producción; eliminación masiva de datos; rotación de secretos; cambios irreversibles de infraestructura; modificación de políticas de seguridad. |

### 6.2 Flujo de aprobación

```text
REQUEST → WAITING_APPROVAL → APPROVE | REJECT | REQUEST_CHANGES
```

### 6.3 Solicitud de aprobación

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
```

### 6.4 Reglas normativas

- **Una aprobación autoriza UNA acción concreta**; no es una autorización indefinida.
- **El silencio nunca es autorización**: la expiración (`expires_at`) equivale a NO aprobado.
- Tras `REJECT`: la tarea vuelve a `NEEDS_HUMAN` con la razón registrada.
- Tras `REQUEST_CHANGES`: vuelve al estado del workflow que corresponda con la solicitud de cambio
  explícita.
- La decisión humana queda registrada para auditoría (append-only, véase ADR-014).

> Regla: WAITING_APPROVAL permanece hasta una decisión explícita; una solicitud expirada se trata
> como no aprobada.

---

## 7. Regla final

El workflow transforma una solicitud en un resultado validado mediante una cadena determinista de
etapas con dueño, gates y artefactos. La arquitectura es obligatoria, la delegación entrega
resultados, los handoffs viajan por artifacts, los fallos se clasifican y recuperan con evidencia, y
las operaciones de riesgo requieren aprobación humana explícita.

> Regla del framework: el proceso es determinista, observable, recuperable y seguro; la inteligencia
> solo decide dentro de las reglas.
