# Runtime Context

## Context Layers

```text
system policy
project context
task context
workflow context
agent context
tool results
memory
```

## Priority

Security and system constraints must not be overridden by lower-level content.

## Context Budget

Evitar incluir automáticamente:

```text
entire repository
entire history
all memory
all tool output
```

Preferir relevant context.

## Rule

Context should be constructed intentionally per agent.
