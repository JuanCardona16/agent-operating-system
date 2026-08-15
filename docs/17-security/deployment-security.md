# Deployment Security

## Deployment Levels

```text
local
development
staging
production
```

## Policy

```text
local       → agent allowed
development → controlled
staging     → approval
production  → explicit approval
```

## Deployment Gate

```text
tests
 ↓
security
 ↓
review
 ↓
approval
 ↓
deployment
```

## Rule

El éxito de los tests no equivale automáticamente a autorización de deployment.
