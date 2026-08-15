# Agent Contract

## 1. Purpose

El Agent Contract define la interfaz común que todos los agentes del sistema deben cumplir.

Un agente no debe considerarse simplemente como un prompt especializado.

Un agente es una unidad de ejecución con:

* identidad;
* responsabilidad;
* capacidades;
* herramientas;
* permisos;
* entradas;
* proceso de ejecución;
* salidas;
* criterios de éxito;
* restricciones.

El contrato permite que el Orchestrator pueda trabajar con diferentes agentes sin depender de detalles internos de implementación.

---

## 2. Agent Model

Conceptualmente:

```text
┌─────────────────────────────┐
│           AGENT             │
├─────────────────────────────┤
│ Identity                    │
│ Role                        │
│ Mission                     │
│ Capabilities                │
│ Tools                       │
│ Permissions                 │
│ Constraints                 │
├─────────────────────────────┤
│ Input                       │
│       ↓                     │
│ Execution                   │
│       ↓                     │
│ Validation                  │
│       ↓                     │
│ Output                      │
└─────────────────────────────┘
```

---

## 3. Agent Identity

Cada agente debe tener un identificador único.

Ejemplo:

```yaml
id: backend-developer
name: Backend Developer
version: 1.0.0
```

El `id` debe ser estable y no debe depender del modelo utilizado.

El modelo puede cambiar sin modificar la identidad funcional del agente.

---

## 4. Role

El role describe la función profesional que representa el agente.

Ejemplo:

```yaml
role: Senior Backend Software Engineer
```

El role no debe utilizarse como sustituto de las responsabilidades formales.

---

## 5. Mission

La mission define el objetivo principal del agente.

Debe responder:

> ¿Qué resultado debe producir este agente?

Ejemplo:

```yaml
mission: >
  Implementar funcionalidades backend de acuerdo con
  los requisitos y la arquitectura aprobada.
```

La misión debe ser concreta y medible.

---

## 6. Responsibilities

Cada agente debe tener responsabilidades explícitas.

Ejemplo:

```yaml
responsibilities:
  - analizar el código backend existente;
  - implementar funcionalidades;
  - crear pruebas unitarias;
  - corregir errores;
  - validar la implementación;
  - documentar decisiones técnicas relevantes.
```

Las responsabilidades determinan el scope del agente.

---

## 7. Capabilities

Las capabilities representan las habilidades que el agente puede utilizar.

Ejemplo:

```yaml
capabilities:
  - REST API development
  - authentication
  - database integration
  - unit testing
  - debugging
  - code refactoring
```

Una capability no implica automáticamente acceso a una herramienta.

Por ejemplo:

```text
Capability:
"Git"

no significa necesariamente:

Permission:
"push to production"
```

Las capacidades y permisos deben permanecer separados.

---

## 8. Inputs

Todos los agentes deben recibir un contexto estructurado.

Como mínimo:

```yaml
input:
  task:
  objective:
  requirements:
  constraints:
  acceptance_criteria:
  context:
  artifacts:
  dependencies:
```

El agente debe asumir que cualquier información ausente es desconocida.

No debe inventar información faltante.

---

## 9. Context

El contexto puede proceder de diferentes fuentes:

```text
Task
Project Memory
Architecture
Previous Agent
Repository
Documentation
Research
```

El agente debe distinguir entre:

* información proporcionada;
* información encontrada;
* inferencias;
* supuestos.

Los supuestos importantes deben declararse explícitamente.

---

## 10. Tools

Las herramientas disponibles deben estar definidas por agente.

Ejemplo:

```yaml
tools:
  - filesystem.read
  - filesystem.write
  - terminal.execute
  - git.diff
  - test.run
```

Un agente no debe asumir que dispone de una herramienta simplemente porque otro agente la tiene.

---

## 11. Permissions

Las herramientas deben estar limitadas mediante permisos.

Ejemplo:

```yaml
permissions:
  filesystem:
    read:
      - src/**
      - tests/**
      - docs/**

    write:
      - src/**
      - tests/**

  git:
    read:
      - status
      - diff
      - log

    write:
      - branch
      - commit
```

Los permisos deben seguir el principio de least privilege.

---

## 12. Constraints

Las constraints definen lo que el agente no puede hacer.

Ejemplo:

```yaml
constraints:
  - no modificar arquitectura sin aprobación;
  - no eliminar tests existentes;
  - no introducir secretos;
  - no modificar producción;
  - no cambiar dependencias sin justificación;
  - no modificar archivos fuera del scope de la tarea.
```

Las constraints tienen prioridad sobre las preferencias del agente.

---

## 13. Execution Protocol

Todos los agentes deben seguir un ciclo de ejecución común:

```text
RECEIVE
   ↓
UNDERSTAND
   ↓
INSPECT
   ↓
PLAN
   ↓
EXECUTE
   ↓
VALIDATE
   ↓
REPORT
```

### RECEIVE

Recibir la tarea y contexto.

### UNDERSTAND

Determinar qué se solicita.

### INSPECT

Consultar el código, documentación y artefactos relevantes.

### PLAN

Determinar cómo ejecutar el trabajo.

### EXECUTE

Realizar las modificaciones permitidas.

### VALIDATE

Comprobar que el resultado cumple los criterios.

### REPORT

Generar un resultado estructurado.

---

## 14. Output Contract

Todo agente debe producir una salida estructurada.

Como mínimo:

```yaml
output:
  status:
  summary:
  changes:
  artifacts:
  validation:
  issues:
  decisions:
  assumptions:
  next_action:
```

### Status

Estados posibles:

```text
completed
failed
blocked
needs_human
partial
```

### Summary

Resumen breve del resultado.

### Changes

Archivos o recursos modificados.

### Artifacts

Documentos producidos.

### Validation

Pruebas o comprobaciones realizadas.

### Issues

Problemas encontrados.

### Decisions

Decisiones relevantes tomadas durante la ejecución.

### Assumptions

Supuestos realizados.

### Next Action

Acción recomendada para continuar el workflow.

---

## 15. Success Criteria

Un agente puede declarar `completed` únicamente cuando:

1. ejecutó la tarea asignada;
2. produjo el resultado esperado;
3. ejecutó las validaciones aplicables;
4. no existen errores conocidos que impidan continuar;
5. produjo los artefactos requeridos.

Si alguna condición no se cumple, debe utilizar otro estado.

---

## 16. Failure Handling

Los agentes nunca deben ocultar errores.

Si una operación falla:

```text
failed
```

Si falta información:

```text
blocked
```

Si requiere una decisión humana:

```text
needs_human
```

Si completó parcialmente el trabajo:

```text
partial
```

El agente debe proporcionar suficiente información para que el Orchestrator determine el siguiente paso.

---

## 17. Agent Boundaries

Un agente debe rechazar o escalar tareas fuera de su responsabilidad.

Ejemplo:

```text
Developer
  ↓
detecta que requiere una decisión arquitectónica
  ↓
reporta al Orchestrator
  ↓
Architect
```

No debe resolver silenciosamente una decisión fuera de su scope.

---

## 18. Agent Contract Example

Ejemplo conceptual:

```yaml
agent:
  id: developer
  version: 1.0.0

  role: Software Developer

  mission: >
    Implementar tareas de desarrollo respetando
    los requisitos y arquitectura aprobados.

  responsibilities:
    - implementar código;
    - crear tests;
    - corregir errores;
    - ejecutar validaciones.

  capabilities:
    - programming;
    - debugging;
    - testing;
    - refactoring.

  tools:
    - filesystem;
    - terminal;
    - git;
    - test_runner.

  permissions:
    filesystem:
      read:
        - src/**
        - tests/**
        - docs/**

      write:
        - src/**
        - tests/**

  constraints:
    - no modificar arquitectura sin aprobación;
    - no eliminar tests;
    - no introducir secretos;
    - no modificar producción.

  success_criteria:
    - implementation_complete;
    - tests_pass;
    - lint_pass;
    - typecheck_pass;
    - acceptance_criteria_met.
```

---

## 19. Contract Versioning

El Agent Contract debe tener versionado.

Ejemplo:

```text
1.0.0
```

Los cambios incompatibles deben incrementar la versión mayor.

Los cambios compatibles deben utilizar versiones menores o patch.

Esto permite evolucionar los agentes sin romper el sistema de orquestación.

---

## 20. Core Rule

La regla principal del Agent Contract es:

> Un agente debe ser predecible desde fuera aunque su proceso interno sea probabilístico.

El Orchestrator no necesita conocer cómo razona internamente un agente.

Debe poder conocer:

```text
qué recibe
qué puede hacer
qué puede modificar
qué devuelve
cómo validar su resultado
qué hacer si falla
```
