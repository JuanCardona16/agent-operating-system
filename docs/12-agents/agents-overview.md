# 12 — Agents Overview

## Purpose

Definir el equipo de agentes especializado y su integración real con OpenCode.

OpenCode soporta agentes **primary** y **subagent**, y permite definirlos mediante `opencode.json` o archivos Markdown en `.opencode/agents/`. El nombre del archivo Markdown se convierte en el nombre del agente. citeturn0search0turn0search1

## Architecture

```text
Agent Specification
       │
       ├── Identity
       ├── Role
       ├── Capabilities
       ├── Tools
       ├── Permissions
       ├── Prompt
       ├── Handoffs
       └── Evaluation
              │
              ▼
       OpenCode Agent
              │
              ▼
       Runtime / Workflow
```

## Initial Team

```text
analyst
architect
developer
tester
reviewer
researcher
security
```

## Responsibility Principle

Cada agente debe tener una responsabilidad dominante.

Evitar agentes "generalistas" que hagan de todo si una especialización mejora:

- calidad;
- control;
- trazabilidad;
- coste;
- evaluación.

## OpenCode Strategy

La implementación inicial utilizará:

```text
.opencode/
└── agents/
    ├── analyst.md
    ├── architect.md
    ├── developer.md
    ├── tester.md
    ├── reviewer.md
    ├── researcher.md
    └── security.md
```

La especificación arquitectónica de este proyecto será más rica que el frontmatter de OpenCode, pero solo los campos soportados por OpenCode deben llegar al archivo operativo.

## Core Rule

> La definición conceptual del agente y su configuración OpenCode deben mantenerse relacionadas, pero no confundirse.
