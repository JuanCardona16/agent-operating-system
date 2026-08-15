# Configuration Strategy

## Configuration Layers

```text
defaults
 ↓
project
 ↓
agent
 ↓
workflow
 ↓
execution
```

## Keep Configurable

```text
models
permissions
tool availability
timeouts
budgets
evaluation thresholds
observability
```

## Avoid Hardcoding

No hardcodear:

```text
API keys
model assumptions
absolute paths
production credentials
provider-specific business logic
```

## Environment

Separate:

```text
development
testing
staging
production
```
