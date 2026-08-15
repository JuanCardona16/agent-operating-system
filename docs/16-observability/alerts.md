# Alerts

## Purpose

Detectar condiciones que requieren acción.

## Alert Categories

```text
availability
quality
security
cost
performance
capacity
```

## Examples

```text
workflow failure rate > threshold
critical security event
cost spike
tool timeout spike
agent regression
```

## Alert Severity

```text
INFO
WARNING
CRITICAL
```

## Alert Contract

```yaml
alert:
  id:
  condition:
  severity:
  owner:
  action:
  cooldown:
```

## Rule

Una alerta debe tener una acción asociada. Evitar alertas que solo generan ruido.
