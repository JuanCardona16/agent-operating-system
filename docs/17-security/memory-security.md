# Memory Security

## Risks

```text
memory poisoning
cross-project leakage
persistent prompt injection
stale authorization
sensitive retention
```

## Controls

```text
scope isolation
provenance
confidence
validation
retention
access control
```

## Promotion

Nunca promover automáticamente:

```text
untrusted tool output
external instructions
unverified agent claims
```

a memoria global.

## Rule

La memoria es un recurso protegido y debe heredar controles de seguridad del proyecto y del agente.
