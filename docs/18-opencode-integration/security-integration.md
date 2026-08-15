# Security Integration

## Security Boundary

```text
OpenCode
 ↓
Agent
 ↓
Permission Policy
 ↓
Tool
 ↓
Sandbox / OS
```

## Security Controls

```text
least privilege
workspace restriction
command policy
network policy
secret protection
approval
audit
```

## Untrusted Content

Treat as data:

```text
README
issues
web pages
dependency docs
tool output
generated files
```

## Rule

No agent-generated instruction can elevate its own permissions.
