# Identity and Authorization

## Identity

Distinguir:

```text
human
agent
orchestrator
tool
service
```

## Authorization

La autorización debe responder:

```text
WHO
can do
WHAT
on WHICH RESOURCE
under WHICH CONDITIONS
```

## Agent Permissions

Ejemplo conceptual:

```yaml
agent:
  id: developer
  permissions:
    filesystem:
      read: true
      write: true
    terminal:
      execute: true
    deployment:
      execute: false
```

## Rule

El prompt nunca debe ser el mecanismo único de autorización.

La autorización debe imponerse en runtime.
