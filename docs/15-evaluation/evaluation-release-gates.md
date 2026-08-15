# Evaluation Release Gates

## Gate Levels

### Gate 1 — Basic

```text
tests pass
schema valid
no critical error
```

### Gate 2 — Quality

```text
quality threshold
regression threshold
```

### Gate 3 — Security

```text
no critical security regression
```

### Gate 4 — Operations

```text
cost acceptable
latency acceptable
failure rate acceptable
```

## Release Decision

```text
All mandatory gates pass
        ↓
      RELEASE
```

Any critical gate failure:

```text
BLOCK
```

## Exception

Una excepción requiere:

```text
reason
owner
risk
expiration
approval
```
