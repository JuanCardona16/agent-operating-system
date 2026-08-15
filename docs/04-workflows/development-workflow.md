# Development Workflow

## 1. Purpose

Este documento define el flujo estándar para transformar una solicitud de software en una implementación validada.

El workflow es coordinado por el Orchestrator y utiliza agentes especializados según las necesidades de cada tarea.

---

## 2. High-Level Workflow

```text
USER REQUEST
     │
     ▼
ORCHESTRATOR
     │
     ▼
ANALYSIS
     │
     ▼
PLANNING
     │
     ▼
ARCHITECTURE
     │
     ▼
IMPLEMENTATION
     │
     ▼
TESTING
     │
     ▼
REVIEW
     │
     ├──────── FAIL ────────┐
     │                     │
     │                     ▼
     │                IMPLEMENTATION
     │
     ▼
APPROVED
     │
     ▼
DONE
```

---

## 3. Phase 1 — Request Intake

El sistema recibe una solicitud del usuario.

Ejemplo:

```text
Implementar autenticación con Google.
```

El Orchestrator debe crear una tarea inicial.

Resultado:

```text
TASK-000001
status: BACKLOG
```

La solicitud original debe conservarse como parte del contexto de la tarea.

---

## 4. Phase 2 — Analysis

El Analyst analiza la solicitud.

Debe determinar:

* objetivo;
* requisitos;
* restricciones;
* ambigüedades;
* dependencias conocidas;
* acceptance criteria;
* preguntas abiertas.

Resultado:

```text
requirements.md
```

Si existe información crítica ausente:

```text
ANALYZING
    ↓
NEEDS_HUMAN
```

El sistema no debe inventar requisitos críticos.

---

## 5. Phase 3 — Planning

El Orchestrator transforma los requisitos en un plan de ejecución.

Debe determinar:

* subtareas;
* dependencias;
* agentes necesarios;
* orden de ejecución;
* posibles tareas paralelas;
* herramientas requeridas.

Ejemplo:

```text
TASK-001
│
├── TASK-002 Analyze authentication
├── TASK-003 Design architecture
├── TASK-004 Backend implementation
├── TASK-005 Frontend implementation
├── TASK-006 Tests
└── TASK-007 Review
```

---

## 6. Phase 4 — Architecture

Cuando la tarea requiere decisiones arquitectónicas, el Architect produce:

```text
architecture.md
```

y, cuando corresponda:

```text
ADR-XXX.md
```

No todas las tareas requieren una nueva decisión arquitectónica.

El Orchestrator debe evitar introducir complejidad innecesaria.

---

## 7. Phase 5 — Implementation

El Developer recibe:

* Task Contract;
* requirements;
* architecture;
* acceptance criteria;
* contexto relevante;
* restricciones.

Antes de modificar código debe:

1. inspeccionar el repositorio;
2. comprender la implementación existente;
3. identificar archivos relevantes;
4. elaborar un plan;
5. ejecutar los cambios;
6. ejecutar validaciones.

---

## 8. Phase 6 — Testing

El Tester valida la implementación.

Las pruebas pueden incluir:

* unit tests;
* integration tests;
* end-to-end tests;
* regression tests;
* static analysis;
* type checking.

El Tester debe producir:

```text
test-report.md
```

Resultado:

```text
PASS
```

o:

```text
FAIL
```

---

## 9. Phase 7 — Review

El Reviewer analiza el resultado independientemente del Developer.

Debe revisar:

* corrección;
* mantenibilidad;
* arquitectura;
* seguridad;
* consistencia;
* cobertura de tests;
* cumplimiento de requisitos.

Resultado:

```text
APPROVED
```

o:

```text
CHANGES_REQUIRED
```

---

## 10. Phase 8 — Completion

Una tarea puede finalizar solamente cuando:

```text
Requirements       ✓
Acceptance Criteria ✓
Tests              ✓
Quality Gates      ✓
Review             ✓
```

Entonces:

```text
APPROVED
   ↓
DONE
```

---

## 11. Dynamic Routing

El workflow no debe ser completamente rígido.

Ejemplo:

```text
Simple typo
    ↓
Developer
    ↓
Test
    ↓
Done
```

Mientras:

```text
New payment system
    ↓
Analyst
    ↓
Researcher
    ↓
Architect
    ↓
Backend
    ↓
Database
    ↓
Security
    ↓
Tester
    ↓
Reviewer
```

El Orchestrator decide la ruta apropiada.

---

## 12. Parallel Execution

Las tareas independientes pueden ejecutarse en paralelo.

Ejemplo:

```text
Architecture
     │
     ├──────────► Backend
     │
     ├──────────► Frontend
     │
     └──────────► Documentation
```

El Orchestrator debe respetar las dependencias antes de ejecutar tareas paralelas.

---

## 13. Workflow Principle

El workflow debe ser:

* determinista en sus reglas;
* flexible en la selección de agentes;
* observable;
* recuperable ante fallos;
* seguro ante operaciones críticas.

La inteligencia puede ser probabilística.

El proceso no debe serlo.
