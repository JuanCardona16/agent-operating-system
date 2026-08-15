# 03 — Tareas

Este documento define el modelo canónico de tarea, su máquina de estados, los criterios de
aceptación, la política de reintentos y las responsabilidades por estado. Se deriva de `docs/03-tasks`,
`docs/13-orchestration` y del registro de decisiones `ADR-000`; prevalece el registro.

**Principio rector**: una tarea representa un **resultado verificable**, no una conversación. El
historial conversacional puede ayudar a ejecutarla, pero no es el único lugar donde existe su
definición. Toda operación significativa del sistema se representa como una tarea.

---

## 1. Identidad de la tarea

```text
TASK-000001 ... TASK-NNNNNN
```

- Formato fijo `TASK-<6 dígitos>`.
- El ID **nunca se reutiliza**: ni tras cancelación, ni tras fallo.
- La tarea debe contener suficiente información para que un agente la ejecute sin depender del
  historial conversacional.

> Regla: un ID de tarea identifica un único resultado verificable en la historia del sistema; su
> registro es inmutable (append-only, véase ADR-014).

---

## 2. Modelo de tarea

| Componente | Definición | Regla |
|---|---|---|
| Identity | `id: TASK-NNNNNN` | Nunca se reutiliza. |
| Objective | El **resultado** que se debe conseguir, no una acción. | "Implementar autenticación Google OAuth", no "editar auth.ts". |
| Requirements | Condiciones funcionales y técnicas conocidas. | No se inventan; si faltan críticos → `NEEDS_HUMAN`. |
| Constraints | Límites de la solución (infraestructura, compatibilidad, alcance). | Tienen prioridad sobre las preferencias del agente. |
| Acceptance Criteria | Condiciones verificables de terminación. | Fuente de verdad; el agente no las redefine (sección 4). |
| Dependencies | IDs de tareas que deben estar disponibles. | Una tarea no comienza con una dependencia obligatoria sin satisfacer. |
| Assignment | `agent` + `assigned_by: orchestrator`. | El agente asignado ejecuta; no decide la terminación final. |
| Context refs | Referencias a requisitos, arquitectura, código, decisiones, documentación. | Ruta a artifacts, no texto volcado. |
| Artifacts | Entradas y salidas producidas/utilizadas (`inputs`, `outputs`). | Con provenance (véase ADR-013). |
| Allowed tools | Restricción opcional del conjunto de herramientas. | Nunca otorga más de lo que permite el rol del agente. |
| Validation log | Registro de validaciones realizadas (tests, lint, typecheck, review). | Cada gate con `status`. |
| Result | Estado final, resumen, archivos modificados, validación, `next_action`. | Solo se escribe al terminar. |
| History | Registro de transiciones con timestamp. | Permite reconstruir errores, tiempos, reintentos, agentes, cuellos de botella. |

### Ejemplo de la distinción objetivo vs. acción

Incorrecto: "Modificar auth.ts".

Correcto: "Implementar autenticación mediante Google OAuth."

---

## 3. Máquina de estados de la tarea (véase ADR-004)

### Capa 1 — Estados de tarea (canónico, dominio)

```text
BACKLOG → ANALYZING → PLANNING → READY → IMPLEMENTING → TESTING → REVIEWING → APPROVED → DONE
```

Estados excepcionales: `BLOCKED`, `FAILED`, `NEEDS_HUMAN`, `CANCELLED`.

### Transiciones válidas

Además de la cadena canónica:

```text
TESTING → IMPLEMENTING       # validación falló, vuelve a implementación
REVIEWING → IMPLEMENTING     # review rechazó con observaciones
CUALQUIER estado excepcional → estado del workflow que corresponda  # tras resolver el problema
```

Ejemplos prohibidos (no válidos):

```text
BACKLOG → IMPLEMENTING    # falta análisis y planificación
DONE → TESTING            # DONE es terminal
READY → REVIEWING         # se omite implementación
```

### Capa 2 — Estados de ejecución (runtime)

```text
created → queued → running → waiting → blocked → failed → completed → cancelled
```

Es el estado del runtime que materializa la tarea; es derivable de eventos y checkpoints
persistidos (véase ADR-014).

### Capa 3 — Status de salida del agente

```text
completed | failed | blocked | needs_human | partial
```

### Mapeo formal: salida del agente → estado de tarea

| Salida del agente | Estado de tarea resultante |
|---|---|
| `completed` | Avanza al siguiente estado del pipeline. |
| `failed` | `FAILED` (con reporte de fallo) o retry → estado anterior. |
| `blocked` | `BLOCKED` (con razón y dependencia). |
| `needs_human` | `NEEDS_HUMAN` / `WAITING_APPROVAL` (aprobación humana). |
| `partial` | Vuelve al estado anterior con entrega parcial documentada. |

> Regla: las transiciones de tarea se derivan exclusivamente del `agent_output` y de las decisiones
> del Orchestrator; no existe transición implícita ni estado sin dueño.

---

## 4. Criterios de aceptación (véase ADR-006, G1)

### 4.1 Propósito y propiedades

Los AC determinan de forma objetiva cuándo una tarea alcanzó el resultado esperado. Son la principal
barrera contra la falsa finalización. Un buen criterio es específico, verificable, observable,
independiente cuando es posible, relevante e inequívoco.

Requisito vs. AC: el requisito describe lo que el sistema debe hacer; el AC describe cómo se
determina que lo hace correctamente.

Anti-patrones prohibidos: "El código debe quedar bien", "Debe funcionar correctamente", "Debe ser
robusto", "Debe ser rápido". Toda afirmación debe convertirse en condición verificable, por ejemplo
"las peticiones deben responder en menos de 300 ms bajo las condiciones del benchmark".

### 4.2 Formato

```yaml
acceptance_criteria:
  - id: AC-001
    description: >
      Un usuario puede iniciar sesión mediante Google.
    validation:
      type: e2e_test
      status: pending

  - id: AC-002
    description: >
      Un usuario existente mantiene su cuenta.
    validation:
      type: integration_test
      status: pending
```

Campos obligatorios: `id`, `description`, `validation.type`, `validation.status`.

### 4.3 Tipos de validación

| Tipo | Valores | Uso |
|---|---|---|
| Automated Tests | `unit`, `integration`, `e2e` | Validación objetiva por ejecución. |
| Static Analysis | `lint`, `typecheck`, `static_analysis` | Reglas de calidad estática. |
| Manual Validation | `manual` | Cuando la automatización no es suficiente. |
| Agent Review | `agent_review` | Mantenibilidad, arquitectura, consistencia, calidad. |
| Human Approval | `human_approval` | Decisiones de alto impacto (véase ADR-010). |

### 4.4 Fuente de verdad

Los AC forman parte del Task Contract y son la fuente de verdad para determinar la correctitud del
resultado. **El agente implementador no puede redefinirlos unilateralmente.**

Si los criterios son incorrectos o incompletos, el flujo de actualización es:

```text
Agent → Orchestrator → Analyst / Architect → Update Task
```

### 4.5 Regla de completitud

- Una tarea **no pasa a `DONE`** mientras exista un AC obligatorio sin validar.
- Si un AC falla (`AC-003 FAIL`), la tarea vuelve a `IMPLEMENTING`, o a `NEEDS_HUMAN` según la
  naturaleza del fallo.
- Los AC se combinan con quality gates según el tipo de tarea (véase ADR-006).

> Regla: AC pendiente = tarea no terminada; AC fallido = la tarea retrocede, no se reinterpreta.

---

## 5. Retry policy y presupuesto (véase ADR-005, ADR-007)

```yaml
retry_policy:
  max_attempts: 3
  strategy: diagnose_before_retry
  backoff: exponential
```

| Regla | Valor |
|---|---|
| Reintentos máximos | `max_attempts: 3` |
| Estrategia | Diagnóstico antes de cada reintento; cada retry añade información nueva. |
| Protección de bucle | `max_same_transition: 3` |
| Duración máxima por tarea | `max_duration_minutes: 30` |
| Presupuesto de costo | `max_cost` por tipo de tarea, definido en configuración |
| Tras superar el límite | `NEEDS_HUMAN` o `FAILED` según el caso |

Clasificación antes de reintentar (ADR-005):

| Reintentables | NO reintentables |
|---|---|
| timeout | permiso denegado |
| fallo transitorio de red | requisitos inválidos |
| infraestructura temporal | violación de política |
| fallo transitorio de modelo/herramienta | acción destructiva rechazada |
| | fallo determinista de test |

El reporte de fallo acompaña el estado `FAILED`: `error`, `cause`, `attempt`, `logs`,
`recommendation` (esquema formal en `05-contracts.md`).

> Regla: sin diagnóstico no hay reintento; tras el límite de intentos o transiciones, la tarea se
> detiene y escala; nunca se ejecuta indefinidamente.

---

## 6. Responsabilidades por estado

| Estado | Responsable | Resultado esperado |
|---|---|---|
| BACKLOG | Orchestrator | Tarea creada y registrada, pendiente de procesar. |
| ANALYZING | Analyst | `requirements.md`, ACs, preguntas abiertas, riesgos. |
| PLANNING | Orchestrator y/o Architect | Plan de ejecución: subtareas, dependencias, agentes, orden, paralelismo posible, herramientas. |
| READY | Orchestrator | Condiciones cumplidas: requisitos, ACs, dependencias disponibles, agente asignado, permisos establecidos. |
| IMPLEMENTING | Agente asignado | Implementación respetando Agent Contract, Task Contract, permisos y arquitectura. |
| TESTING | Tester | `test-report.md` con veredicto `PASS` o `FAIL`; evaluación de regresiones y ACs. |
| REVIEWING | Reviewer | `review-report.md` con veredicto `APPROVED` o `CHANGES_REQUIRED`. |
| APPROVED | Orchestrator / gates | Implementación validada y lista para finalizar. |
| DONE | Orchestrator | ACs cumplidos, tests requeridos pasan, revisión aprobada, sin bloqueadores conocidos. |
| BLOCKED | Orchestrator | Registra `reason`, `impact`, `required_action`. |
| FAILED | Orchestrator | Decide: reintentar, replanificar, asignar otro agente o escalar al humano. |
| NEEDS_HUMAN | Humano / Orchestrator | Decisión explícita registrada (véase ADR-010). |
| CANCELLED | Orchestrator | Terminación explícita con causa registrada. |

Causas típicas de `BLOCKED`: falta información, dependencia no completada, herramienta no
disponible, decisión pendiente.

Causas típicas de `NEEDS_HUMAN`: cambio arquitectónico crítico, operación destructiva, acceso
sensible, decisión ambigua, acción de producción.

> Regla: cada estado tiene un dueño; la transición solo ocurre cuando el dueño entrega su resultado
> y el gate correspondiente lo valida.

---

## 7. Historia y observabilidad

Toda transición importante se registra. Ejemplo:

```text
TASK-000042

08:10 BACKLOG
08:12 ANALYZING
08:15 PLANNING
08:19 READY
08:25 IMPLEMENTING
08:41 TESTING
08:47 FAILED
08:51 IMPLEMENTING
09:03 TESTING
09:10 REVIEWING
09:17 APPROVED
09:18 DONE
```

La historia permite analizar errores, tiempos, reintentos, agentes y cuellos de botella. Cada
transición se emite como evento con la cadena de correlación `request_id → task_id → execution_id →
step_id → agent_id → tool_call_id` (+ `trace_id`) (véase ADR-014). El estado debe poder
reconstruirse a partir de eventos y/o checkpoints persistidos; no se asume que un proceso anterior
terminó correctamente solo porque existe un registro de ejecución.

> Regla: la historia de la tarea es inmutable y correlacionable; la recuperación usa checkpoints
> validados, nunca suposiciones.

---

## 8. Ejemplo completo de contrato de tarea

```yaml
task:
  id: TASK-000042
  type: feature
  title: Autenticación con Google OAuth
  priority: high
  risk: medium

  objective: >
    Implementar autenticación mediante Google OAuth.

  requirements:
    - permitir login mediante Google
    - crear sesión después de la autenticación
    - soportar usuarios existentes
    - crear el usuario si no existe

  constraints:
    - utilizar la infraestructura de autenticación existente
    - no modificar el proveedor de base de datos
    - mantener compatibilidad con usuarios existentes

  acceptance_criteria:
    - id: AC-001
      description: Un usuario puede iniciar sesión mediante Google.
      validation: { type: e2e_test, status: pending }
    - id: AC-002
      description: Un usuario existente mantiene su cuenta.
      validation: { type: integration_test, status: pending }

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
    requirements:
      - docs/tasks/TASK-000042/requirements.md

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

> **Resuelto** (véase ADR-020): `max_cost` por tipo de tarea en USD por ejecución — `documentation`
> 0.10, `test` 0.25, `bug` 0.50, `research` 0.50, `security` 0.50, `maintenance` 0.50,
> `architecture` 0.75, `feature` 1.00, `refactor` 1.00; un sistema complejo se presupuesta como
> `feature` ampliado (2.00). Configurables en `opencode.json` / política de proyecto (ADR-007 fija la
> línea base de los demás umbrales).

---

## 9. Regla final

Una tarea es la unidad mínima de trabajo verificable del sistema: identidad inmutable, objetivo como
resultado, ACs como fuente de verdad, estados canónicos mapeados, retry con evidencia y un dueño por
estado.

> Regla del framework: resultado verificable, nunca conversación; AC pendiente, nunca DONE.
