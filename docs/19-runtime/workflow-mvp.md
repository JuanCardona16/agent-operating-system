# MVP Workflow

## Goal

Implementar el primer flujo end-to-end.

## Flow

```text
User Task
   ↓
Developer
   ↓
Tester
   ↓
Reviewer
   ↓
Quality Gate
   ↓
Result
```

## Developer Result

Debe entregar:

```text
changes
tests
evidence
```

## Tester Result

Debe entregar:

```text
test status
failures
evidence
```

## Reviewer Result

Debe entregar:

```text
approval
findings
risk
```

## Gate

```text
tests pass
AND
no critical findings
AND
scope acceptable
```

→ task complete.

Otherwise:

```text
return to developer
```
