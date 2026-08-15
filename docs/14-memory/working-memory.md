# Working Memory

## Purpose

Mantener el contexto mínimo necesario durante una ejecución.

## Contents

```text
objective
constraints
current_plan
relevant_files
recent_findings
active_errors
pending_actions
```

## Example

```yaml
working_memory:
  objective: Implement OAuth callback
  current_step: developer
  relevant_files:
    - src/auth/callback.ts
  findings:
    - existing session middleware detected
  pending:
    - add callback validation
```

## Context Budget

La working memory debe mantenerse compacta.

Evitar:

```text
entire repository
entire conversation
all historical tool outputs
```

## Compression

Cuando el contexto crece:

```text
Raw Context
   ↓
Summarize
   ↓
Extract Decisions
   ↓
Extract Facts
   ↓
Discard Noise
```
