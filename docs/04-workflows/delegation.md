# Agent Delegation

## 1. Purpose

Este documento define cómo el Orchestrator asigna trabajo a los agentes.

La delegación debe ser explícita, trazable y limitada por el scope de cada agente.

---

## 2. Delegation Model

```text
                    ORCHESTRATOR
                         │
                 ┌───────┼────────┐
                 ▼       ▼        ▼
              Analyst Architect Researcher
                 │       │        │
                 └───────┼────────┘
                         ▼
                     Developer
                         │
                    ┌────┴────┐
                    ▼         ▼
                  Tester   Reviewer
```

---

## 3. Delegation Responsibilities

El Orchestrator debe determinar:

* qué agente es adecuado;
* qué información necesita;
* qué herramientas puede utilizar;
* qué resultado debe producir;
* cuándo debe terminar;
* qué agente debe recibir el resultado.

---

## 4. Delegation Criteria

La selección del agente debe considerar:

### Role Fit

¿El agente tiene la responsabilidad adecuada?

### Capability Fit

¿Tiene las capacidades necesarias?

### Tool Fit

¿Dispone de las herramientas requeridas?

### Permission Fit

¿Puede realizar las operaciones necesarias?

### Context Fit

¿Tiene acceso al contexto necesario?

---

## 5. Delegation Contract

Una delegación debe contener:

```yaml
delegation:
  task_id:
  parent_task_id:
  agent:
  objective:
  requirements:
  constraints:
  acceptance_criteria:
  context:
  artifacts:
  dependencies:
  tools:
  expected_output:
```

---

## 6. Parent and Child Tasks

Las tareas complejas pueden dividirse.

Ejemplo:

```text
TASK-001
Implement authentication
│
├── TASK-002
│   Analyze requirements
│
├── TASK-003
│   Design architecture
│
├── TASK-004
│   Backend implementation
│
└── TASK-005
    Integration tests
```

Cada subtarea debe conservar una referencia a su tarea padre.

---

## 7. Delegation Rules

El Orchestrator debe:

1. evitar duplicar trabajo;
2. proporcionar suficiente contexto;
3. no sobrecargar al agente con contexto irrelevante;
4. respetar permisos;
5. especificar acceptance criteria;
6. registrar la delegación.

---

## 8. Re-Delegation

Una tarea puede reasignarse cuando:

* el agente falla;
* el agente no tiene capacidad suficiente;
* aparece un problema fuera de scope;
* se requiere otra especialización.

Ejemplo:

```text
Developer
   ↓
Blocked: architectural issue
   ↓
Architect
   ↓
Decision
   ↓
Developer
```

---

## 9. Delegation Anti-Patterns

Evitar:

```text
"Haz lo que consideres necesario."
```

También:

```text
"Implementa todo el sistema."
```

sin requisitos, criterios o límites.

La delegación debe ser específica.

---

## 10. Delegation Principle

El Orchestrator debe delegar **resultados**, no simplemente acciones.

Incorrecto:

```text
"Edita auth.ts."
```

Correcto:

```text
"Implementa autenticación Google OAuth cumpliendo
AC-001 a AC-005."
```
