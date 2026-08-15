# OpenCode Commands

## Purpose

Expose repeatable workflows to humans without manually coordinating agents.

## Candidate Commands

```text
/task
/analyze
/design
/implement
/test
/review
/security
/ship
```

## Example

```text
/task "Implement OAuth callback"
```

could resolve to:

```text
analyst
→ architect
→ developer
→ tester
→ reviewer
```

## Rule

Commands should invoke defined workflows rather than contain duplicated business logic.
