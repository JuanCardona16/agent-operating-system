# Runtime State

## Execution State

```text
created
queued
running
waiting
blocked
failed
completed
cancelled
```

## Agent State

```text
idle
running
waiting_tool
waiting_handoff
failed
completed
```

## State Rule

State transitions must be explicit and observable.

## Example

```text
created
 ↓
running
 ↓
waiting_tool
 ↓
running
 ↓
completed
```
