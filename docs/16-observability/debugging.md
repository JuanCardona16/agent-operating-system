# Debugging

## Debugging Workflow

```text
Incident
 ↓
Find execution_id
 ↓
Open trace
 ↓
Locate failed span
 ↓
Inspect logs
 ↓
Inspect tool calls
 ↓
Inspect artifacts
 ↓
Check memory
 ↓
Check evaluation
 ↓
Identify root cause
```

## Root Cause Categories

```text
bad prompt
bad model
bad routing
bad context
bad memory
tool failure
permission issue
workflow design
infrastructure
human decision
```

## Rule

No corregir únicamente el síntoma si el trace permite identificar una causa sistémica.
