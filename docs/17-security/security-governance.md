# Security Governance

## Security Policy Ownership

Definir responsables para:

```text
policy
permissions
secrets
incident response
dependency security
deployment
```

## Policy Versioning

```yaml
policy:
  id:
  version:
  effective_at:
  owner:
  changes:
```

## Change Management

Cambios de seguridad deben evaluarse mediante:

```text
review
tests
regression
audit
```

## Rule

Una política crítica no debe cambiar silenciosamente como efecto secundario de un prompt o workflow.
