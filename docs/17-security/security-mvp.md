# Security MVP

## Objective

Proteger el primer equipo de agentes antes de ampliar su autonomía.

## MVP Includes

```text
least-privilege permissions
tool gateway
filesystem restrictions
terminal restrictions
secret protection
prompt injection defenses
project isolation
security logging
approval for high-risk actions
security regression tests
```

## Initial Policy

```text
read repository       → allow
write project         → allow
run tests             → allow
install dependency    → ask/review
git push              → ask
production deploy     → ask
secret access         → deny by default
destructive commands  → deny/ask
```

## Exit Criteria

- permisos aplicados en runtime;
- acciones peligrosas controladas;
- secretos no aparecen en contexto/logs;
- proyectos aislados;
- security tests pasan;
- incidentes pueden auditarse.
