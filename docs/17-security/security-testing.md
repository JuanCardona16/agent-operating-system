# Security Testing

## Test Categories

```text
unit
integration
policy
adversarial
penetration
regression
```

## Mandatory Cases

Probar:

```text
unauthorized tool call
path traversal
command injection
secret leakage
prompt injection
memory poisoning
cross-project access
```

## Security Regression

Cada vulnerabilidad corregida debe convertirse en un caso de regresión.

```text
Incident
 ↓
Test Case
 ↓
Golden Dataset
 ↓
Permanent Regression
```
