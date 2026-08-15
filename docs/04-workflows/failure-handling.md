# Failure Handling

## 1. Purpose

Este documento define cómo debe reaccionar el sistema ante errores, bloqueos y resultados incompletos.

El objetivo es evitar:

* loops infinitos;
* errores silenciosos;
* pérdida de contexto;
* falsas finalizaciones;
* cambios destructivos.

---

## 2. Failure Categories

### Agent Failure

El agente no puede completar la tarea.

### Tool Failure

Una herramienta falla.

### Validation Failure

La implementación no cumple los criterios.

### Context Failure

Falta información necesaria.

### Dependency Failure

Una dependencia no está disponible.

### Architectural Conflict

La implementación revela un problema arquitectónico.

### Security Issue

Se detecta un problema de seguridad.

### Human Decision Required

El sistema necesita una decisión humana.

---

## 3. Failure Flow

```text
FAILURE
   │
   ▼
CLASSIFY
   │
   ├── recoverable
   │       ↓
   │    RETRY
   │
   ├── requires different agent
   │       ↓
   │    REASSIGN
   │
   ├── requires decision
   │       ↓
   │    NEEDS_HUMAN
   │
   └── unrecoverable
           ↓
         FAILED
```

---

## 4. Retry

Los reintentos deben ser limitados.

Configuración inicial recomendada:

```yaml
retry:
  max_attempts: 3
```

Un reintento debe incorporar información nueva.

Nunca debe repetirse ciegamente la misma estrategia.

---

## 5. Retry Strategy

Después de un fallo:

```text
Attempt 1
   ↓
Failure analysis
   ↓
Strategy adjustment
   ↓
Attempt 2
```

Si el segundo intento falla:

```text
Failure analysis
   ↓
Re-evaluate plan
   ↓
Attempt 3
```

Después del máximo:

```text
NEEDS_HUMAN
```

o:

```text
FAILED
```

---

## 6. Error Reporting

Todo fallo debe registrar:

```yaml
failure:
  task_id:
  agent:
  category:
  message:
  cause:
  impact:
  attempt:
  recoverable:
  recommendation:
```

---

## 7. Validation Failure

Si el Tester encuentra un error:

```text
TESTING
   ↓
FAIL
   ↓
IMPLEMENTING
```

El feedback debe llegar al agente que realizó la implementación.

---

## 8. Review Failure

Si el Reviewer rechaza una implementación:

```text
REVIEWING
   ↓
CHANGES_REQUIRED
   ↓
IMPLEMENTING
```

El Reviewer debe proporcionar observaciones concretas.

---

## 9. Infinite Loop Protection

El sistema debe detectar ciclos.

Ejemplo:

```text
Developer
 ↓
Tester
 ↓
Developer
 ↓
Tester
 ↓
Developer
 ↓
Tester
```

Si el mismo patrón se repite excesivamente, el Orchestrator debe detener la ejecución.

Ejemplo:

```yaml
loop_protection:
  max_same_transition: 3
```

---

## 10. Escalation

Una tarea debe escalar cuando:

* se supera el máximo de reintentos;
* existe una decisión arquitectónica crítica;
* existe riesgo de pérdida de datos;
* se requiere acceso privilegiado;
* existe ambigüedad crítica;
* se detecta un riesgo de seguridad importante.

---

## 11. Principle

Los errores son parte normal del workflow.

El objetivo no es conseguir agentes que nunca fallen.

El objetivo es construir un sistema capaz de:

```text
detect
→ understand
→ recover
→ validate
→ continue
```

de forma segura y trazable.
