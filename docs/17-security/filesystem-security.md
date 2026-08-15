# Filesystem Security

## Controls

```text
allowed roots
path normalization
symlink handling
write permissions
delete permissions
```

## Path Validation

Antes de escribir:

```text
normalize
 ↓
resolve
 ↓
check allowed root
 ↓
check permission
 ↓
execute
```

## Threat

Evitar:

```text
../../outside-workspace
symlink escape
hidden sensitive paths
```

## Rule

La ruta proporcionada por un agente es input no confiable.
