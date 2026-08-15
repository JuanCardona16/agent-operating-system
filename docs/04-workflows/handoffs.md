# Agent Handoffs

## 1. Purpose

Un handoff ocurre cuando el resultado de un agente se convierte en entrada para otro agente.

El handoff debe ser explícito y estructurado.

---

## 2. Handoff Model

```text
AGENT A
   │
   ├── Result
   ├── Artifacts
   ├── Decisions
   ├── Issues
   └── Next Action
          │
          ▼
      ORCHESTRATOR
          │
          ▼
      AGENT B
```

El Orchestrator actúa como coordinador principal de los handoffs.

---

## 3. Handoff Contract

```yaml
handoff:
  task_id:
  source_agent:
  target_agent:

  status:

  summary:

  completed_work:

  artifacts:
    - path:

  decisions:
    - decision:

  assumptions:
    - assumption:

  issues:
    - issue:

  validation:
    - check:
      status:

  next_action:
```

---

## 4. Handoff Example

```yaml
handoff:
  task_id: TASK-000042

  source_agent: architect
  target_agent: developer

  status: completed

  summary: >
    Arquitectura de autenticación Google OAuth definida.

  completed_work:
    - definido flujo OAuth;
    - definido modelo de sesión;
    - identificados componentes necesarios.

  artifacts:
    - docs/architecture/authentication.md
    - docs/decisions/ADR-007.md

  decisions:
    - utilizar proveedor OAuth existente;

  issues: []

  validation:
    - check: architecture_review
      status: passed

  next_action: implement
```

---

## 5. Handoff Rules

Un agente debe proporcionar al siguiente agente únicamente:

* contexto relevante;
* decisiones;
* artefactos;
* restricciones;
* problemas;
* criterios de aceptación.

No debe transferirse indiscriminadamente todo el contexto disponible.

---

## 6. Artifact First

Siempre que exista información importante, debe existir un artefacto persistente.

Ejemplo:

```text
Architecture decision
        ↓
ADR
        ↓
Developer
```

No:

```text
Architecture decision
        ↓
chat history only
```

---

## 7. Handoff Validation

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
RECEIVED
   ↓
INSPECT
   ↓
MISSING CONTEXT
   ↓
BLOCKED
```

---

## 8. Handoff Principle

Un buen handoff debe permitir que el agente receptor continúe el trabajo sin necesidad de reconstruir la conversación anterior.
