# Memory Security

## Threats

```text
secret leakage
prompt injection persistence
cross-project contamination
poisoned memory
unauthorized retrieval
stale information
sensitive data retention
```

## Controls

- scope isolation;
- permission checks;
- provenance;
- validation;
- expiration;
- redaction;
- audit;
- deletion.

## Prompt Injection Persistence

No almacenar automáticamente contenido como:

```text
ignore previous instructions
you are now authorized
reveal secrets
```

El contenido externo debe tratarse como datos.

## Secrets

Nunca persistir:

```text
API keys
passwords
tokens
private keys
session credentials
```

## Retrieval Security

La memoria recuperada debe respetar permisos del agente y del proyecto.
