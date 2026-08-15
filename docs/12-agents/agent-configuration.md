# Agent Configuration

## OpenCode Native Configuration

OpenCode admite agentes en `opencode.json` y en archivos Markdown bajo `.opencode/agents/`. Para este proyecto se recomienda Markdown por agente, porque facilita versionado, revisión y separación de prompts. citeturn0search0turn0search1

## Project Layout

```text
.opencode/
└── agents/
    ├── analyst.md
    ├── architect.md
    ├── developer.md
    ├── tester.md
    ├── reviewer.md
    ├── researcher.md
    └── security.md
```

## Native Frontmatter

Baseline:

```yaml
---
description: Short agent description
mode: subagent
model: provider/model
temperature: 0.1
permission:
  edit: deny
  bash: deny
---
```

OpenCode reconoce campos como `description`, `mode`, `model`, `temperature` y `permission` en agentes Markdown; el contenido posterior al frontmatter se utiliza como prompt. citeturn0search1

## Important

No añadir campos arbitrarios al frontmatter esperando que OpenCode los interprete como capacidades internas.

Nuestra metadata extendida debe vivir en la documentación del proyecto o en un sistema propio de registry.

## Example

```markdown
---
description: Reviews code for correctness, maintainability and security
mode: subagent
temperature: 0.1
permission:
  edit: deny
  bash: deny
---

You are the Reviewer agent.

Your mission is to independently review implementation changes.

Focus on:
- correctness
- regressions
- maintainability
- security
- performance

Do not modify files.
```

## Model Selection

El modelo debe configurarse por entorno cuando sea necesario.

No fijar un modelo concreto en la arquitectura conceptual si la infraestructura puede cambiarlo.
