# Task Lifecycle

## 1. Overview

Toda tarea atraviesa un ciclo de vida controlado.

```text
BACKLOG
   ↓
ANALYZING
   ↓
PLANNING
   ↓
READY
   ↓
IMPLEMENTING
   ↓
TESTING
   ↓
REVIEWING
   ↓
APPROVED
   ↓
DONE
```

---

## 2. BACKLOG

La tarea existe pero todavía no ha sido procesada.

Responsable:

```text
Orchestrator
```

---

## 3. ANALYZING

El Analyst determina:

* qué se solicita;
* qué requisitos existen;
* qué información falta;
* cuáles son los acceptance criteria.

Resultado:

```text
requirements
acceptance criteria
open questions
```

---

## 4. PLANNING

El Orchestrator y/o Architect determinan:

* estrategia;
* subtareas;
* dependencias;
* agentes necesarios;
* orden de ejecución.

Resultado:

```text
execution plan
```

---

## 5. READY

La tarea tiene suficiente información para comenzar.

Condiciones:

* requisitos definidos;
* acceptance criteria definidos;
* dependencias disponibles;
* agente asignado;
* permisos establecidos.

---

## 6. IMPLEMENTING

El agente ejecuta la implementación.

Puede:

* modificar código;
* crear archivos;
* crear tests;
* ejecutar herramientas.

Debe respetar:

* Agent Contract;
* Task Contract;
* permisos;
* arquitectura.

---

## 7. TESTING

El Tester valida:

* comportamiento;
* tests;
* regresiones;
* acceptance criteria.

Resultado:

```text
PASS
```

o:

```text
FAIL
```

---

## 8. REVIEWING

El Reviewer analiza:

* calidad;
* mantenibilidad;
* arquitectura;
* seguridad;
* consistencia;
* tests.

Resultado:

```text
APPROVED
```

o:

```text
CHANGES_REQUIRED
```

---

## 9. APPROVED

La implementación ha pasado las validaciones requeridas.

La tarea está preparada para finalizar.

---

## 10. DONE

Una tarea puede pasar a `DONE` solamente si:

* acceptance criteria cumplidos;
* tests requeridos pasan;
* revisión aprobada;
* no existen bloqueadores conocidos.

---

## 11. BLOCKED

La tarea está bloqueada cuando no puede continuar.

Ejemplos:

* falta información;
* dependencia no completada;
* herramienta no disponible;
* decisión pendiente.

Debe registrar:

```text
reason
impact
required_action
```

---

## 12. FAILED

La ejecución falló.

Debe registrarse:

```text
error
cause
attempt
logs
recommendation
```

El Orchestrator decide si:

* reintentar;
* modificar el plan;
* asignar otro agente;
* escalar al humano.

---

## 13. NEEDS_HUMAN

Debe utilizarse cuando se necesita una decisión humana.

Ejemplos:

* cambio arquitectónico crítico;
* operación destructiva;
* acceso sensible;
* decisión ambigua;
* acción de producción.

---

## 14. State Transition Rules

No todas las transiciones están permitidas.

Ejemplo:

```text
BACKLOG → ANALYZING
ANALYZING → PLANNING
PLANNING → READY
READY → IMPLEMENTING
IMPLEMENTING → TESTING
TESTING → REVIEWING
TESTING → IMPLEMENTING
REVIEWING → APPROVED
REVIEWING → IMPLEMENTING
APPROVED → DONE
```

Estados excepcionales pueden devolver la tarea al workflow correspondiente después de resolver el problema.

---

## 15. Retry Policy

Los reintentos deben ser controlados.

Una tarea no debe ejecutarse indefinidamente.

Ejemplo:

```yaml
retry_policy:
  max_attempts: 3
  strategy: diagnose_before_retry
```

Después de superar el límite:

```text
NEEDS_HUMAN
```

o:

```text
FAILED
```

según el caso.
