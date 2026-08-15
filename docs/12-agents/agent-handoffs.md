# Agent Handoffs

## Purpose

Definir cómo se transfiere trabajo entre agentes.

## Standard Flow

```text
Analyst
   ↓
Architect
   ↓
Developer
   ↓
Tester
   ↓
Reviewer
```

## Handoff Rules

El agente emisor debe entregar:

- objetivo;
- contexto relevante;
- decisiones;
- findings;
- artifacts;
- restricciones;
- expected output.

## Example

```yaml
source_agent: architect
target_agent: developer

objective: Implement authentication middleware

context:
  affected_modules:
    - api
    - auth

findings:
  - existing JWT library is available

constraints:
  - preserve public API

expected_output:
  - implementation
  - tests
```

## Rejection

Un agente receptor puede devolver el trabajo cuando:

- falta información;
- existe una contradicción;
- no tiene permisos;
- la tarea está fuera de su scope;
- existe un riesgo que requiere aprobación.

## Handoff Rule

> Un handoff debe reducir ambigüedad, no simplemente mover el contexto de una conversación a otra.
