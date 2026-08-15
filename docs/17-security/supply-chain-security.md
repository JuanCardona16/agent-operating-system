# Supply Chain Security

## Threats

```text
malicious dependencies
compromised packages
unsafe scripts
untrusted repositories
dependency confusion
```

## Controls

```text
lockfiles
dependency review
version pinning
package verification
security scanning
isolated installation
```

## Agent Rule

Un agente no debe instalar una dependencia nueva solo porque "parece útil" sin respetar las políticas del proyecto.

## High-Risk Action

Adding a dependency can require:

```text
analysis
security check
tests
review
```
