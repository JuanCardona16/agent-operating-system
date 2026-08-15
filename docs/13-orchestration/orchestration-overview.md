# 13 — Orchestration Overview

## Propósito

Orchestration define cómo el sistema transforma una tarea en una secuencia coordinada de agentes, herramientas, validaciones y decisiones.

```text
Task
  ↓
Intake
  ↓
Classification
  ↓
Planning
  ↓
Agent Selection
  ↓
Execution
  ↓
Validation
  ↓
Handoff / Retry / Escalation
  ↓
Completion
```

## Objetivos

- reducir coordinación manual;
- mantener trazabilidad;
- evitar llamadas innecesarias;
- controlar permisos;
- soportar recuperación ante fallos;
- introducir quality gates;
- permitir human-in-the-loop.

## Principios

1. Determinismo primero.
2. Estado explícito.
3. Handoffs estructurados.
4. Fallos recuperables cuando sea seguro.
5. Operaciones críticas requieren aprobación.
6. Toda ejecución debe ser observable.

## MVP

El primer orquestador debe soportar:

```text
sequential workflow
agent selection explícita
handoff
retry limitado
quality gate
failure escalation
human approval básico
```

No introducir routing autónomo complejo en el MVP.
