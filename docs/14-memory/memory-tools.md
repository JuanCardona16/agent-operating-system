# Memory Tools

## Recommended Tools

```text
memory.read
memory.search
memory.write
memory.update
memory.archive
```

## Permissions

### Read

Permitido según scope.

### Write

Debe requerir validación.

### Delete

Más restrictivo.

### Archive

Preferible a delete para información importante.

## Tool Contract

```yaml
memory.search:
  input:
    query:
    scope:
    project_id:
    limit:

  output:
    records:
      - id
        content
        provenance
        confidence
```

## Rule

No dar acceso directo al almacenamiento a todos los agentes.
