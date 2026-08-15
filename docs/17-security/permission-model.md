# Permission Model

## Permission Levels

```text
DENY
ASK
ALLOW
```

## Risk Categories

```text
read
write
execute
network
destructive
deploy
secret
```

## Example

```text
filesystem.read      → ALLOW
filesystem.write     → ALLOW
git.push              → ASK
database.drop        → DENY
production.deploy    → ASK
secret.read          → DENY
```

## Permission Evaluation

```text
Agent Request
 ↓
Resource
 ↓
Risk Classification
 ↓
Policy
 ↓
Permission
 ↓
Audit
```

## Rule

No usar permisos globales cuando un permiso limitado por proyecto o recurso sea suficiente.
