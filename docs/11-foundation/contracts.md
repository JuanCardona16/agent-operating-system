# Contracts

## Propósito

Los contratos definen cómo se comunican los componentes.

> Los agentes no deben depender de texto libre como interfaz principal de integración.

## Contratos principales

```text
Task
AgentInput
AgentOutput
Handoff
ToolCall
ToolResult
Execution
Artifact
Event
QualityGate
Workflow
MemoryRecord
```

## Task

```yaml
task:
  id: TASK-001
  type: feature
  title: Add authentication
  description: Implement authentication support
  priority: normal
  status: pending
```

## AgentInput

```yaml
agent_input:
  execution_id:
  task_id:
  agent_id:
  objective:
  context:
  constraints:
  artifacts:
```

## AgentOutput

```yaml
agent_output:
  execution_id:
  agent_id:
  status:
  summary:
  artifacts:
  findings:
  errors:
  next_action:
```

## Handoff

```yaml
handoff:
  id:
  source_agent:
  target_agent:
  task_id:
  reason:
  context:
  artifacts:
  expected_output:
```

## ToolCall / ToolResult

```yaml
tool_call:
  id:
  execution_id:
  agent_id:
  tool_id:
  input:

tool_result:
  tool_call_id:
  status:
  output:
  error:
  duration_ms:
```

## Execution

```yaml
execution:
  id:
  task_id:
  workflow_id:
  started_at:
  completed_at:
  status:
```

## Reglas

1. Versionar contratos.
2. Validar inputs.
3. Normalizar outputs.
4. Mantener compatibilidad cuando sea posible.
5. Registrar provenance.
6. Evitar campos ambiguos.

Los cambios incompatibles requieren una nueva versión.
