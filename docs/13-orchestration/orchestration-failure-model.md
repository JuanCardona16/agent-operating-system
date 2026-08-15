# Orchestration Failure Model

## Failure Classes

```text
INPUT_FAILURE
AGENT_FAILURE
TOOL_FAILURE
POLICY_FAILURE
QUALITY_FAILURE
INFRASTRUCTURE_FAILURE
TIMEOUT
HUMAN_REJECTION
```

## Failure Handling

```text
Failure
  ↓
Classify
  ↓
Determine Recoverability
  ├── recover
  ├── retry
  ├── replan
  ├── escalate
  └── terminate
```

## Workflow Termination

Un workflow debe terminar explícitamente como:

```text
COMPLETED
FAILED
CANCELLED
BLOCKED
```

Nunca dejarlo simplemente "sin actividad".

## Failure Report

```yaml
failure:
  type:
  step_id:
  agent_id:
  message:
  cause:
  recovery_attempts:
  recommended_action:
```
