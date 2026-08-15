# OpenCode Agent Model

## Agent Definition

Cada agente debe tener:

```text
identity
role
objective
responsibilities
constraints
tools
permissions
model
workflow position
output contract
```

## Agent Categories

```text
analyst
architect
researcher
developer
tester
reviewer
security
```

## Principle

Un agente debe tener una responsabilidad clara.

Evitar:

```text
developer + architect + reviewer + security
```

como un único agente generalista.

## Agent Contract

```yaml
agent:
  id:
  role:
  objective:
  tools:
  permissions:
  model:
  inputs:
  outputs:
  success_criteria:
```
