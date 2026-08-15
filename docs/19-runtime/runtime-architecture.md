# Runtime Architecture

## Layers

```text
┌─────────────────────────────┐
│           User              │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│        OpenCode CLI         │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│       Agent Runtime         │
├─────────────────────────────┤
│ Agent Config                │
│ Model Config                │
│ Permissions                 │
│ Tools                       │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│     Project Workspace       │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ Evaluation / Observability  │
└─────────────────────────────┘
```

## Runtime Principle

La configuración runtime debe ser:

```text
versioned
reviewable
reproducible
environment-aware
```

## Boundary

OpenCode ejecuta agentes.

La arquitectura del sistema define:

```text
roles
policies
workflows
quality
security
```
