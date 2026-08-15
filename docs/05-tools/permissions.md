# Tool Permissions

## 1. Purpose

Este documento define cómo se controla el acceso de los agentes a las herramientas.

La arquitectura utiliza el principio:

> **Capability ≠ Permission ≠ Tool**

Un agente puede saber hacer algo sin tener autorización para ejecutarlo.

---

# 2. Permission Model

```text
AGENT
  │
  ▼
CAPABILITY
  │
  ▼
TOOL
  │
  ▼
PERMISSION
  │
  ▼
RESOURCE
  │
  ▼
ACTION
```

Ejemplo:

```text
Developer
  ↓
Git capability
  ↓
git.push
  ↓
permission denied
```

El hecho de que el agente conozca Git no significa que pueda hacer push.

---

# 3. Permission Levels

Se utilizarán inicialmente:

```text
NONE
READ
WRITE
EXECUTE
ADMIN
```

---

## 3.1 NONE

La operación está prohibida.

---

## 3.2 READ

Permite consultar información.

Ejemplo:

```text
filesystem.read
git.diff
database.read
```

---

## 3.3 WRITE

Permite modificar recursos.

Ejemplo:

```text
filesystem.write
git.commit
```

---

## 3.4 EXECUTE

Permite ejecutar operaciones.

Ejemplo:

```text
terminal.execute
test.runner
deploy.staging
```

---

## 3.5 ADMIN

Permite modificar configuración o políticas del sistema.

Debe estar extremadamente restringido.

Los agentes normales no deben tener este permiso.

---

# 4. Resource Scope

Los permisos deben limitarse también por recurso.

Ejemplo:

```yaml
filesystem:
  read:
    - src/**
    - tests/**
    - docs/**

  write:
    - src/**
    - tests/**
```

Esto es preferible a:

```yaml
filesystem:
  write: "*"
```

---

# 5. Agent Permission Profiles

Los agentes pueden utilizar perfiles.

### Analyst

```yaml
permissions:
  filesystem:
    read: true

  git:
    read: true

  terminal:
    execute:
      allowlist:
        - grep
        - find
        - git
```

### Developer

```yaml
permissions:
  filesystem:
    read: true
    write:
      - src/**
      - tests/**

  terminal:
    execute:
      development_commands: true

  git:
    read: true
    branch_create: true
    commit: true
```

### Tester

```yaml
permissions:
  filesystem:
    read: true

  terminal:
    execute:
      test_commands: true
```

### Reviewer

```yaml
permissions:
  filesystem:
    read: true

  git:
    read: true
```

---

# 6. Sensitive Resources

Los siguientes recursos deben considerarse sensibles:

```text
.env
credentials
private keys
SSH keys
API keys
cloud credentials
production configuration
secret stores
```

El acceso debe estar prohibido por defecto.

---

# 7. Network Permissions

El acceso externo debe limitarse.

Ejemplo:

```yaml
network:
  allowed_domains:
    - docs.example.com
    - github.com

  denied_domains:
    - internal-production.example
```

La política exacta dependerá del entorno.

---

# 8. Production Permissions

En el MVP:

```text
production:
  read: restricted
  write: denied
  execute: denied
```

Las operaciones de producción deben pasar por Human Approval.

---

# 9. Destructive Operations

Ejemplos:

```text
filesystem.delete
git.reset
git.push.force
database.delete
database.migrate
production.deploy
```

deben clasificarse como:

```text
HIGH / CRITICAL
```

y tener una política explícita.

---

# 10. Permission Escalation

Un agente no puede elevar sus propios permisos.

Incorrecto:

```text
Agent
 ↓
permission denied
 ↓
modify config
 ↓
grant permission
```

Correcto:

```text
Agent
 ↓
permission denied
 ↓
Orchestrator
 ↓
Human Approval
 ↓
temporary permission
```

---

# 11. Temporary Permissions

Cuando sea necesario, se puede conceder un permiso temporal.

Ejemplo:

```yaml
permission_grant:
  agent: developer
  permission: database.migrate
  scope: staging
  expires:
    after_task: true
```

Debe registrarse en auditoría.

---

# 12. Default Deny

La política por defecto será:

```text
DENY
```

Los permisos deben concederse explícitamente.

---

# 13. Core Principle

> **Todo lo que un agente puede hacer debe poder explicarse mediante una autorización explícita.**
