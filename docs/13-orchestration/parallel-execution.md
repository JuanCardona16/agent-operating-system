# Parallel Execution

## Purpose

Ejecutar trabajo independiente en paralelo.

## Dependency Graph

```text
          ┌→ security
architect ┤
          └→ developer
```

Solo pueden paralelizarse tareas sin dependencias incompatibles.

## Requirements

Antes de paralelizar:

- verificar dependencias;
- detectar conflictos de archivos;
- validar permisos;
- comprobar límites de concurrencia;
- establecer merge strategy.

## Shared Workspace Risk

Dos agentes escribiendo simultáneamente en los mismos archivos puede producir:

```text
race condition
conflicting edits
lost changes
invalid intermediate state
```

## MVP

Preferir:

```text
parallel read-only analysis
```

antes que escritura concurrente.

## Future

Implementar worktrees, isolated branches o mecanismos equivalentes cuando el entorno lo permita.
