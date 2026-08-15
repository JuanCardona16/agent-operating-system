# Agent Base

## Modelo

```yaml
agent:
  id: developer
  version: "1.0"
  role: software_developer

  capabilities:
    - code_analysis
    - implementation
    - testing

  tools:
    - filesystem.read
    - filesystem.write
    - terminal.execute

  input_contract: AgentInput
  output_contract: AgentOutput
```

## Lifecycle

```text
REGISTER → READY → START → PLAN → EXECUTE → VALIDATE → COMPLETE
```

En caso de error:

```text
EXECUTE → ERROR → RECOVER → retry / replan / escalate
```

## Responsabilidades

Un agente debe:

- conocer su rol;
- respetar herramientas y límites;
- producir outputs estructurados;
- emitir eventos relevantes;
- reportar incertidumbre;
- no asumir permisos.

## Identidad

Cada ejecución debe identificar:

```text
agent_id
agent_version
execution_id
task_id
```

## Registro

```text
Agent Definition
      ↓
Validation
      ↓
Capability Registry
      ↓
Agent Registry
      ↓
Ready
```
