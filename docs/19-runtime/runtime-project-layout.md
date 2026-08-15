# Runtime Project Layout

## Target

```text
project/
├── AGENTS.md
├── .opencode/
│   ├── agents/
│   │   ├── developer.md
│   │   ├── tester.md
│   │   └── reviewer.md
│   ├── commands/
│   └── opencode.json
├── docs/
│   ├── 01-...
│   └── 19-runtime/
├── src/
├── tests/
└── ...
```

## Responsibilities

### `AGENTS.md`

Contexto y reglas generales del repositorio.

### `.opencode/agents/`

Definiciones de agentes.

### `.opencode/commands/`

Entradas de workflows repetibles.

### `docs/`

Arquitectura y especificaciones.

## Rule

No almacenar secretos dentro del repositorio.
