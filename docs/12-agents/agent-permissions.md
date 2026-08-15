# Agent Permissions

## Permission Model

OpenCode permite permisos con:

```text
allow
ask
deny
```

y permite definirlos globalmente o por agente. Los patrones pueden utilizarse para comandos concretos. citeturn0search1turn0search10

## Baseline

### Analyst

```yaml
permission:
  edit: deny
  bash: deny
```

### Architect

```yaml
permission:
  edit: deny
  bash: deny
```

### Developer

```yaml
permission:
  edit: allow
  bash: ask
```

### Tester

```yaml
permission:
  edit: deny
  bash: ask
```

### Reviewer

```yaml
permission:
  edit: deny
  bash: deny
```

### Researcher

```yaml
permission:
  edit: deny
  bash: deny
```

### Security

```yaml
permission:
  edit: deny
  bash: ask
```

Estos valores son una baseline; deben ajustarse al entorno real.

## Critical Actions

Operaciones como:

```text
git push
deployment
destructive commands
production changes
```

deben requerir políticas más estrictas.

## Principle

> El permiso debe derivarse del rol y del riesgo, nunca de la conveniencia.
