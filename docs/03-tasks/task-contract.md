# Task Contract

## 1. Purpose

El Task Contract define la unidad fundamental de trabajo del sistema multiagente.

Toda operación significativa debe representarse como una tarea.

Una tarea debe contener suficiente información para que un agente pueda ejecutarla sin depender exclusivamente del historial conversacional.

---

## 2. Task Model

```text
┌──────────────────────────────────┐
│              TASK                │
├──────────────────────────────────┤
│ Identity                         │
│ Objective                        │
│ Requirements                     │
│ Constraints                      │
│ Acceptance Criteria              │
│ Dependencies                     │
├──────────────────────────────────┤
│ Assignment                       │
│ Context                          │
│ Artifacts                        │
│ Tools                            │
│ Permissions                      │
├──────────────────────────────────┤
│ Execution                        │
│ Validation                       │
│ Result                           │
│ History                          │
└──────────────────────────────────┘
```

---

## 3. Task Identity

Cada tarea debe tener un identificador único.

Formato recomendado:

```text
TASK-000001
```

Ejemplo:

```yaml
id: TASK-000042
```

El ID nunca debe reutilizarse.

---

## 4. Objective

Describe qué debe conseguir la tarea.

Debe representar el resultado y no simplemente una acción.

Incorrecto:

```text
"Modificar auth.ts"
```

Correcto:

```text
"Implementar autenticación mediante Google OAuth."
```

---

## 5. Requirements

Los requirements especifican las condiciones funcionales y técnicas conocidas.

Ejemplo:

```yaml
requirements:
  - permitir login mediante Google;
  - crear una sesión después de autenticación;
  - asociar el usuario existente;
  - crear el usuario si no existe.
```

---

## 6. Constraints

Las constraints limitan las posibles soluciones.

Ejemplo:

```yaml
constraints:
  - utilizar la infraestructura de autenticación existente;
  - no modificar el proveedor de base de datos;
  - mantener compatibilidad con usuarios existentes.
```

---

## 7. Acceptance Criteria

Los acceptance criteria determinan cuándo una tarea puede considerarse terminada.

Deben ser verificables.

Ejemplo:

```yaml
acceptance_criteria:
  - Google permite iniciar sesión correctamente;
  - un usuario existente puede autenticarse;
  - un usuario nuevo puede registrarse;
  - una sesión válida es creada;
  - los tests de autenticación pasan.
```

---

## 8. Dependencies

Las tareas pueden depender de otras tareas.

Ejemplo:

```yaml
dependencies:
  - TASK-000039
  - TASK-000040
```

Una tarea no debe comenzar si una dependencia obligatoria no está disponible.

---

## 9. Assignment

El Orchestrator asigna la tarea a un agente.

Ejemplo:

```yaml
assignment:
  agent: developer
  assigned_by: orchestrator
```

El agente asignado es responsable de la ejecución, pero no necesariamente de la decisión final sobre la tarea.

---

## 10. Context

La tarea puede incluir referencias a:

* requisitos;
* arquitectura;
* código;
* decisiones;
* documentación;
* investigación.

Ejemplo:

```yaml
context:
  architecture:
    - docs/architecture/authentication.md

  decisions:
    - docs/decisions/ADR-007.md

  requirements:
    - docs/tasks/TASK-000042/requirements.md
```

---

## 11. Artifacts

Los artefactos representan información producida o utilizada por la tarea.

Ejemplo:

```yaml
artifacts:
  inputs:
    - requirements.md
    - architecture.md

  outputs:
    - implementation.md
    - test-report.md
    - review.md
```

---

## 12. Tools

La tarea puede restringir las herramientas disponibles.

Ejemplo:

```yaml
tools:
  allowed:
    - filesystem
    - terminal
    - git
    - test_runner
```

---

## 13. Status

Estados principales:

```text
BACKLOG
ANALYZING
PLANNING
READY
IMPLEMENTING
TESTING
REVIEWING
APPROVED
DONE
```

Estados excepcionales:

```text
BLOCKED
FAILED
PARTIAL
CANCELLED
NEEDS_HUMAN
```

---

## 14. Validation

La tarea debe registrar las validaciones realizadas.

Ejemplo:

```yaml
validation:
  tests:
    status: passed

  lint:
    status: passed

  typecheck:
    status: passed

  review:
    status: approved
```

---

## 15. Result

Una tarea terminada debe registrar:

```yaml
result:
  status: completed
  summary: >
    Implementación de Google OAuth completada.

  files_changed:
    - src/auth/google.ts
    - tests/auth/google.test.ts

  validation:
    tests: passed
    lint: passed
    typecheck: passed

  next_action: merge
```

---

## 16. Task History

Las transiciones importantes deben registrarse.

Ejemplo:

```text
TASK-000042

08:10 CREATED
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

La historia permite analizar posteriormente:

* errores;
* tiempos;
* reintentos;
* agentes;
* cuellos de botella.

---

## 17. Task Example

```yaml
task:
  id: TASK-000042

  objective: >
    Implementar autenticación mediante Google OAuth.

  requirements:
    - permitir login mediante Google;
    - crear sesión;
    - soportar usuarios existentes;
    - soportar usuarios nuevos.

  constraints:
    - utilizar infraestructura existente;
    - mantener compatibilidad.

  acceptance_criteria:
    - login funciona;
    - usuarios existentes pueden autenticarse;
    - usuarios nuevos pueden registrarse;
    - sesión creada correctamente;
    - tests pasan.

  dependencies:
    - TASK-000039

  assignment:
    agent: developer

  status: IMPLEMENTING
```

---

## 18. Core Rule

Una tarea representa un **resultado verificable**, no una conversación.

El historial conversacional puede ayudar a ejecutar la tarea, pero no debe ser el único lugar donde exista su definición.
