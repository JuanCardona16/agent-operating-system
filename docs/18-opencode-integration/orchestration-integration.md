# Orchestration Integration

## Goal

Connect OpenCode agents to the orchestration architecture from `13-orchestration`.

## Flow

```text
Task
 ↓
Intake
 ↓
Agent Resolution
 ↓
OpenCode Agent
 ↓
Tool Execution
 ↓
Handoff
 ↓
Next Agent
 ↓
Quality Gate
```

## Agent Handoff

Handoff must contain:

```yaml
handoff:
  task_id:
  source_agent:
  target_agent:
  objective:
  context:
  artifacts:
  findings:
  risks:
  next_action:
```

## Rule

No handoff should rely exclusively on hidden conversational context.
