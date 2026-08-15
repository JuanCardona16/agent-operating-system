# OpenCode Permissions

## Principle

Permissions are part of the runtime security boundary.

## Permission Layers

```text
Agent
 ↓
OpenCode permission configuration
 ↓
Tool
 ↓
Runtime / OS
```

## Initial Policy

```text
read repository       → allow
write project         → allow for developer/tester
run tests             → allow
git diff/status       → allow
git commit            → controlled
git push              → ask
production deploy     → ask
destructive command   → deny/ask
secret access         → deny by default
```

## Important

Prompt instructions are not sufficient security controls.

Permissions must be enforced by the runtime/tool layer.
