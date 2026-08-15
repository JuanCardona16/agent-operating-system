# System Principles

## 1. Specialization

Cada agente debe tener una responsabilidad específica.

Un agente no debe asumir responsabilidades de otro agente sin una razón explícita.

Ejemplo:

```text
Developer
    ↓
detecta problema arquitectónico
    ↓
Architect
    ↓
decisión
```

El Developer puede identificar y reportar el problema, pero no debería cambiar arbitrariamente la arquitectura.

## 2. Explicit Contracts

Los agentes deben comunicarse mediante contratos definidos.

Cada interacción debe especificar:

* quién produce la información;
* quién la consume;
* qué información se proporciona;
* qué resultado se espera;
* qué condiciones determinan éxito o fracaso.

## 3. Controlled Autonomy

La autonomía debe estar limitada por:

* herramientas;
* permisos;
* scope;
* estado de la tarea;
* reglas de seguridad.

## 4. Validation Before Completion

Un agente nunca puede determinar por sí mismo que una tarea está completamente terminada.

La finalización debe depender de criterios verificables.

```text
Implementation
      ↓
Testing
      ↓
Review
      ↓
Acceptance Criteria
      ↓
DONE
```

## 5. Artifact-Based Communication

Las decisiones importantes no deben depender exclusivamente del historial conversacional.

Deben persistir mediante artefactos:

```text
requirements.md
architecture.md
implementation.md
test-report.md
review.md
ADR-xxx.md
```

## 6. Persistent Memory

El sistema debe conservar conocimiento relevante entre ejecuciones.

La memoria debe incluir:

* arquitectura;
* decisiones;
* convenciones;
* conocimiento técnico;
* errores conocidos;
* lessons learned.

## 7. Least Privilege

Cada agente debe recibir únicamente los permisos necesarios para realizar su trabajo.

## 8. Fail Explicitly

Los agentes nunca deben ocultar errores.

Un fallo debe producir información suficiente para:

* identificar la causa;
* determinar el impacto;
* decidir el siguiente paso.

## 9. Human Escalation

Cuando una decisión supere el nivel de autonomía permitido, el agente debe detenerse y solicitar intervención humana.

## 10. Traceability

Toda tarea debe poder responder:

```text
¿Por qué existe?
¿Quién la creó?
¿Quién la ejecutó?
¿Qué archivos modificó?
¿Qué pruebas ejecutó?
¿Qué decisiones tomó?
¿Por qué terminó?
```

## 11. Reproducibility

Siempre que sea posible, las operaciones deben ser reproducibles.

La información relevante para reproducir un resultado debe quedar registrada.

## 12. Separation of Concerns

La arquitectura debe mantener separadas:

```text
Orchestration
Intelligence
Execution
Memory
Tools
Project
```

Esta separación permitirá evolucionar cada componente independientemente.
