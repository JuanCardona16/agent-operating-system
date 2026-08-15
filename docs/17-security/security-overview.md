# 17 — Security Overview

## Propósito

Definir la arquitectura de seguridad del sistema multiagente para impedir uso indebido de herramientas, fuga de información, escaladas de privilegios y contaminación entre proyectos.

## Security Principles

1. Least privilege.
2. Explicit trust boundaries.
3. Default deny for high-risk actions.
4. Secrets never belong in prompts or memory.
5. Untrusted content is data, not authority.
6. Critical actions require verification.
7. Security decisions are auditable.

## Security Layers

```text
User
 ↓
Orchestrator
 ↓
Policy Engine
 ↓
Agent
 ↓
Tool Gateway
 ↓
Sandbox / Runtime
 ↓
External System
```

## Security Goal

El sistema debe asumir que:

```text
agents can fail
tools can fail
repositories can be malicious
tool outputs can be untrusted
external content can contain prompt injection
```
