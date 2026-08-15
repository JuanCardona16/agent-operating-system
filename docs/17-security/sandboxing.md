# Sandboxing

## Purpose

Limitar el impacto de código y comandos ejecutados por agentes.

## Isolation Options

```text
process isolation
container
VM
restricted filesystem
network isolation
temporary workspace
```

## Recommended MVP

```text
project workspace
+
restricted command execution
+
explicit writable paths
+
network restrictions
```

## Workspace

```text
/workspace
├── repository
├── artifacts
└── temporary
```

## Rule

El agente debe trabajar en el workspace previsto y no asumir acceso al sistema completo.
