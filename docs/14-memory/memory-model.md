# Memory Model

## Memory Layers

```text
                    MEMORY
                       │
       ┌───────────────┼───────────────┐
       ▼               ▼               ▼
   Working         Persistent       Knowledge
   Context          Memory            Base
       │               │               │
       ▼               ▼               ▼
 current task    project/agent    reusable facts
```

## Memory Types

| Type | Scope | Lifetime |
|---|---|---|
| Working | step | execution |
| Execution | workflow | execution/history |
| Project | repository | long-term |
| Agent | agent | long-term |
| Knowledge | system/project | long-term |
| Audit | system | policy-defined |

## Scope

```text
global
project
workflow
task
execution
agent
```

Nunca asumir que una memoria global es apropiada para todos los proyectos.

## Memory Record

```yaml
memory:
  id:
  type:
  scope:
  project_id:
  task_id:
  execution_id:
  agent_id:
  content:
  source:
  confidence:
  importance:
  created_at:
  updated_at:
  expires_at:
  tags:
```
