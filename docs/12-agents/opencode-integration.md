# OpenCode Integration

## Official Integration Model

OpenCode permite:

- agentes primary;
- agentes subagent;
- configuración JSON;
- configuración Markdown;
- permisos por agente;
- creación interactiva mediante `opencode agent create`. citeturn0search0turn0search1

## Recommended Project Structure

```text
.opencode/
├── agents/
├── commands/
└── ...
```

Además, OpenCode utiliza `AGENTS.md` para instrucciones generales del proyecto. Puede existir en la raíz del repositorio y también globalmente. citeturn0search2

## Separation

```text
AGENTS.md
    ↓
Global Project Rules

.opencode/agents/
    ↓
Agent-specific behavior

opencode.json
    ↓
Global/runtime configuration
```

## Generation Flow

```text
Agent Specification
       ↓
Validate
       ↓
Generate OpenCode Markdown
       ↓
Place in .opencode/agents/
       ↓
Run OpenCode
       ↓
Evaluate
       ↓
Iterate
```

## CLI

OpenCode ofrece:

```bash
opencode agent create
```

para crear agentes mediante un flujo interactivo. citeturn0search0

Para este proyecto, la creación manual/generada por plantilla será preferible cuando queramos reproducibilidad y control sobre Git.

## Rule

> OpenCode es el runtime de agentes; nuestra arquitectura define cómo deben comportarse y colaborar.
