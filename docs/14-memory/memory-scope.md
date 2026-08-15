# Memory Scope

## Purpose

Controlar quién puede leer y escribir cada memoria.

## Scope Hierarchy

```text
GLOBAL
  ↓
PROJECT
  ↓
WORKFLOW
  ↓
TASK
  ↓
EXECUTION
  ↓
AGENT
```

## Access Rules

### Global

Información válida para múltiples proyectos.

### Project

Información específica del repositorio/proyecto.

### Workflow

Decisiones y estado de un workflow.

### Task

Contexto específico de una tarea.

### Execution

Estado temporal de una ejecución concreta.

### Agent

Aprendizajes o configuración específica del agente.

## Rule

El scope más pequeño compatible con el uso esperado es el preferido.

```text
project fact → project memory
task fact    → task memory
temporary    → execution memory
```
