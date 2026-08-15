# OpenCode Tools

## Tool Classes

```text
filesystem
terminal
git
search
network
memory
evaluation
observability
```

## Agent Tool Matrix

| Agent | Read | Write | Terminal | Git | Network |
|---|---:|---:|---:|---:|---:|
| analyst | ✓ | - | - | read | limited |
| architect | ✓ | design artifacts | - | read | limited |
| researcher | ✓ | notes | - | read | ✓ |
| developer | ✓ | ✓ | ✓ | ✓ | controlled |
| tester | ✓ | tests | ✓ | read | controlled |
| reviewer | ✓ | - | limited | read | - |
| security | ✓ | reports | controlled | read | controlled |

## Rule

Grant the minimum tool set required for the agent's responsibility.
