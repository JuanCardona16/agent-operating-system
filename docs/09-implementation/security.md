# Implementation Security

## 1. Purpose

Define los controles de seguridad específicos de la implementación.

## 2. Least Privilege

Cada agente y herramienta debe recibir únicamente los permisos necesarios.

```text
Agent
 ↓
Permissions
 ↓
Tools
 ↓
Resources
```

## 3. Workspace Boundary

Los agentes deben estar limitados al workspace cuando sea posible.

Acciones fuera de este límite requieren autorización adicional.

## 4. Command Execution

La ejecución de comandos es una de las capacidades de mayor riesgo.

Debe considerarse:

```text
command
arguments
working_directory
environment
timeout
risk
```

## 5. Dangerous Operations

Operaciones como:

```text
rm -rf
disk formatting
database DROP
production deployment
secret rotation
```

requieren controles adicionales y, en muchos casos, aprobación humana.

## 6. Secrets

Nunca deben aparecer en:

- prompts;
- logs;
- commits;
- artifacts;
- memory;
- error messages.

## 7. External Services

El acceso a servicios externos debe estar explícitamente autorizado.

```text
Agent
 ↓
External Access Policy
 ↓
Service
```

## 8. Network Restrictions

Cuando sea posible:

- limitar hosts;
- limitar métodos;
- limitar credenciales;
- aplicar timeouts;
- registrar llamadas.

## 9. Audit

Las acciones sensibles deben producir eventos auditables.

```yaml
audit:
  actor:
  action:
  resource:
  timestamp:
  task_id:
  result:
```

## 10. Human Approval

Debe requerirse aprobación humana para acciones críticas.

```text
Agent
 ↓
Risk Detection
 ↓
Approval Request
 ↓
Human
 ↓
Approve / Reject
```

## 11. Security Incident

Ante un incidente:

```text
DETECT
  ↓
CONTAIN
  ↓
ANALYZE
  ↓
REMEDIATE
  ↓
DOCUMENT
```

## 12. Core Principle

> La autonomía debe estar limitada por el nivel de riesgo de la operación.
