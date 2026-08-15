# Tool Integration

## 1. Purpose

Define cómo se integran las herramientas con los agentes.

## 2. Tool Model

```text
Agent
  │
  ▼
Tool Interface
  │
  ▼
Tool Adapter
  │
  ▼
External Capability
```

## 3. Tool Categories

```text
Filesystem
Git
Terminal
Testing
Search
Browser
Database
APIs
Observability
```

## 4. Tool Contract

Cada herramienta debe definir:

```text
id
name
description
input
output
permissions
side_effects
risk
timeout
retry_policy
```

## 5. Example

```yaml
tool:
  id: filesystem.read
  description: Read a file from the workspace

  input:
    path:
      type: string
      required: true

  output:
    content:
      type: string

  side_effects: none
  risk: low
```

## 6. Side Effects

Las herramientas deben clasificarse:

```text
READ_ONLY
WRITE
EXECUTION
EXTERNAL
DESTRUCTIVE
```

## 7. Risk Levels

```text
LOW
MEDIUM
HIGH
CRITICAL
```

Ejemplo:

```text
filesystem.read → LOW
filesystem.write → MEDIUM
terminal.execute → HIGH
database.drop → CRITICAL
```

## 8. Permissions

Un agente solo puede utilizar herramientas autorizadas.

```text
Agent
 ↓
Permission Check
 ↓
Tool
```

## 9. Tool Validation

Antes de ejecutar una herramienta:

```text
Validate Input
      ↓
Check Permission
      ↓
Check Risk
      ↓
Execute
      ↓
Validate Output
```

## 10. Timeouts

Toda herramienta externa debería tener un timeout razonable.

```yaml
timeout:
  default: 30s
  maximum: 300s
```

## 11. Retries

No todas las herramientas deben reintentarse.

```text
Read file
→ retry possible

External API
→ conditional

Database migration
→ dangerous
```

## 12. Tool Logging

Registrar:

```text
tool_call_id
agent_id
task_id
tool
timestamp
duration
status
```

Nunca registrar secretos.

## 13. Core Principle

> Una herramienta debe tener una interfaz pequeña, explícita y predecible.
