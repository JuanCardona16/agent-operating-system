# Agent Memory

## Purpose

Memoria específica de un agente.

## Appropriate Uses

- estrategias que funcionan;
- patrones de resolución;
- errores recurrentes;
- preferencias operativas no sensibles;
- estadísticas de rendimiento.

## Avoid

No utilizar agent memory para almacenar:

- secretos;
- autoridad;
- permisos;
- políticas de seguridad;
- hechos críticos sin provenance.

## Example

```yaml
agent_memory:
  agent_id: developer
  type: learning
  content: Prefer existing repository utilities before introducing dependencies.
  source: reviewed_executions
  confidence: high
```

## Isolation

La memoria de un agente no debe contaminar automáticamente a otros agentes.

Para compartir información:

```text
Agent Memory
   ↓
Validated Knowledge
   ↓
Project / Shared Memory
```
