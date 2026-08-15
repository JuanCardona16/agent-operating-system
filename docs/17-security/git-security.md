# Git Security

## Protected Actions

```text
commit
push
force push
branch deletion
tag creation
release
```

## Recommended Policy

```text
git.status       → ALLOW
git.diff         → ALLOW
git.commit       → ALLOW / ASK
git.push         → ASK
git.force-push   → DENY
```

## Identity

Los commits automáticos deben utilizar una identidad claramente atribuible al sistema/agente cuando la política del proyecto lo permita.

## Rule

Nunca permitir force-push automático como comportamiento general del sistema.
