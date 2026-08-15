# Tool Security

## Tool Gateway

Las herramientas deben pasar por una capa de control:

```text
Agent
 ↓
Tool Gateway
 ↓
Policy
 ↓
Validation
 ↓
Tool
```

## Tool Validation

Validar:

```text
arguments
path
command
environment
network target
permissions
risk
```

## High-Risk Tools

```text
terminal.execute
filesystem.delete
git.push
deployment
database mutation
network requests
secret access
```

## Rule

Las herramientas de alto riesgo no deben depender únicamente de instrucciones del agente para mantenerse seguras.
