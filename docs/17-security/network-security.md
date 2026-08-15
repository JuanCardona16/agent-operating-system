# Network Security

## Default

Network access should be restricted.

## Network Policy

```yaml
network:
  enabled: false
  allowed_hosts: []
  allowed_ports: []
```

## Use Cases

Puede requerirse network para:

```text
package installation
documentation lookup
API testing
repository operations
```

## Controls

```text
allowlist
DNS policy
timeouts
rate limits
proxy
logging
```

## Rule

No conceder acceso global a Internet cuando solo se necesita un host específico.
