# Acceptance Criteria

## 1. Purpose

Los Acceptance Criteria determinan de forma objetiva cuándo una tarea ha alcanzado el resultado esperado.

Son una de las principales barreras contra la falsa finalización de tareas.

---

## 2. Requirements vs Acceptance Criteria

Los requisitos describen lo que el sistema debe hacer.

Los acceptance criteria describen cómo podemos determinar que lo hace correctamente.

Ejemplo:

### Requirement

```text
El sistema debe permitir autenticación mediante Google.
```

### Acceptance Criteria

```text
- El usuario puede iniciar el flujo OAuth.
- Google devuelve una identidad válida.
- El sistema crea o encuentra el usuario.
- Se crea una sesión válida.
- Un usuario autenticado puede acceder a recursos protegidos.
- Los tests correspondientes pasan.
```

---

## 3. Properties

Un buen acceptance criterion debe ser:

* específico;
* verificable;
* observable;
* independiente cuando sea posible;
* relevante;
* inequívoco.

---

## 4. Validation Types

Los criterios pueden validarse mediante:

### Automated Tests

```text
unit
integration
e2e
```

### Static Analysis

```text
lint
typecheck
static analysis
```

### Manual Validation

Cuando la automatización no sea suficiente.

### Agent Review

Para aspectos como:

* mantenibilidad;
* arquitectura;
* consistencia;
* calidad.

### Human Approval

Para decisiones de alto impacto.

---

## 5. Acceptance Criterion Format

Formato recomendado:

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

---

## 6. Completion Rule

Una tarea no puede pasar a `DONE` mientras exista un acceptance criterion obligatorio sin validar.

```text
AC-001 PASS
AC-002 PASS
AC-003 PASS
AC-004 PASS
       ↓
     DONE
```

Si:

```text
AC-003 FAIL
```

la tarea debe volver a:

```text
IMPLEMENTING
```

o:

```text
NEEDS_HUMAN
```

dependiendo de la naturaleza del fallo.

---

## 7. Quality Gates

Los acceptance criteria pueden combinarse con quality gates.

Ejemplo:

```text
Acceptance Criteria
        +
Tests
        +
Lint
        +
Typecheck
        +
Code Review
        ↓
     APPROVED
```

La definición exacta de los gates dependerá del tipo de tarea.

---

## 8. Anti-Patterns

No utilizar criterios ambiguos como:

```text
"El código debe quedar bien."
"Debe funcionar correctamente."
"Debe ser robusto."
"Debe ser rápido."
```

Deben convertirse en condiciones verificables.

Ejemplo:

```text
"Las peticiones deben responder en menos de 300 ms
bajo las condiciones definidas por el benchmark."
```

---

## 9. Source of Truth

Los acceptance criteria forman parte del Task Contract y representan la fuente de verdad para determinar si el resultado de una tarea es correcto.

El agente no puede redefinirlos unilateralmente durante la implementación.

Si los criterios son incorrectos o incompletos:

```text
Agent
  ↓
Orchestrator
  ↓
Analyst / Architect
  ↓
Update Task
```
