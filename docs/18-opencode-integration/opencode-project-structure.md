# OpenCode Project Structure

## Target Structure

```text
project/
├── AGENTS.md
├── .opencode/
│   ├── agents/
│   ├── commands/
│   └── ...
├── docs/
│   ├── 01-...
│   ├── 12-agents/
│   ├── 13-orchestration/
│   ├── 14-memory/
│   ├── 15-evaluation/
│   ├── 16-observability/
│   ├── 17-security/
│   └── 18-opencode-integration/
└── ...
```

## Separation

```text
.opencode/
    runtime configuration

docs/
    architecture and policies

repository/
    product source code
```

## Rule

No mezclar documentación arquitectónica con configuración ejecutable si puede evitarse.

## Source of Truth

La documentación define:

```text
why
what
constraints
```

La configuración define:

```text
how
runtime behavior
```
