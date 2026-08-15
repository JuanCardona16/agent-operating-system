# Quality Model

## 1. Purpose

Este documento define el modelo general de calidad del sistema multiagente.

La calidad no debe depender de la opinión de un único agente.

Debe evaluarse mediante múltiples señales independientes:

- requisitos;
- acceptance criteria;
- tests;
- análisis estático;
- revisión;
- seguridad;
- mantenibilidad;
- comportamiento esperado.

## 2. Quality Model

```text
                    SOFTWARE
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
   Correctness      Quality       Security
        │              │              │
        └──────────────┼──────────────┘
                       │
                       ▼
                 VALIDATION
                       │
              ┌────────┴────────┐
              ▼                 ▼
            PASS              FAIL
              │                 │
              ▼                 ▼
          APPROVED          REMEDIATION
```

## 3. Quality Dimensions

El sistema evaluará como mínimo:

```text
Correctness
Completeness
Reliability
Maintainability
Security
Performance
Compatibility
Testability
```

No todas las dimensiones serán obligatorias para todas las tareas.

## 4. Correctness

Determina si la implementación produce el comportamiento esperado.

Se valida mediante:

- tests;
- acceptance criteria;
- revisión;
- comportamiento observable.

## 5. Completeness

Determina si todos los requisitos fueron implementados.

Debe existir trazabilidad:

```text
Requirement
    ↓
Acceptance Criterion
    ↓
Implementation
    ↓
Validation
```

## 6. Reliability

Evalúa:

- manejo de errores;
- casos límite;
- estabilidad;
- comportamiento ante fallos.

## 7. Maintainability

Evalúa:

- claridad;
- complejidad;
- modularidad;
- cohesión;
- acoplamiento;
- consistencia con el proyecto.

## 8. Security

Debe evaluarse cuando la tarea afecte:

- autenticación;
- autorización;
- datos sensibles;
- APIs;
- infraestructura;
- dependencias;
- secretos.

## 9. Performance

Debe evaluarse cuando existan requisitos explícitos de rendimiento.

Ejemplo:

```text
API latency < 300 ms
```

No deben inventarse objetivos de rendimiento cuando no existen requisitos.

## 10. Quality Evidence

Cada evaluación debe producir evidencia.

Ejemplo:

```yaml
quality_evidence:
  tests:
    status: passed
    count: 184

  lint:
    status: passed

  typecheck:
    status: passed

  review:
    status: approved
```

## 11. Quality Principle

> Una afirmación de calidad debe estar respaldada por evidencia siempre que sea posible.
