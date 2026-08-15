# 18 — OpenCode Integration Overview

## Propósito

Convertir la arquitectura definida en los bloques anteriores en una implementación operativa sobre OpenCode.

## Objetivo

La integración debe permitir:

```text
User
 ↓
OpenCode
 ↓
Orchestration
 ↓
Specialized Agents
 ↓
Tools
 ↓
Memory / Evaluation / Observability / Security
```

## Principio

OpenCode debe actuar como runtime de los agentes de codificación, mientras que las reglas de arquitectura, seguridad y operación permanecen desacopladas de un proveedor concreto.

## Capas

```text
Project Configuration
        ↓
Agent Definitions
        ↓
Permissions
        ↓
Tools
        ↓
Orchestration
        ↓
Memory
        ↓
Evaluation
        ↓
Observability
        ↓
Security
```

## Objetivos de integración

- definir agentes especializados;
- establecer modelos por agente;
- limitar herramientas;
- definir permisos;
- establecer prompts reproducibles;
- crear workflows;
- conectar evaluación;
- conectar observabilidad;
- preparar integración con Gentle AI;
- mantener portabilidad.
