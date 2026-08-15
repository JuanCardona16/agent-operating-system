# Agent Capabilities

## Capability Categories

```text
analysis
architecture
implementation
testing
review
research
security
documentation
debugging
```

## Capability Matrix

| Agent | Analysis | Architecture | Code | Tests | Review | Research | Security |
|---|---:|---:|---:|---:|---:|---:|---:|
| analyst | ✓ | - | - | - | - | ✓ | - |
| architect | ✓ | ✓ | - | - | ✓ | ✓ | - |
| developer | ✓ | ✓ | ✓ | ✓ | - | ✓ | - |
| tester | ✓ | - | limited | ✓ | ✓ | - | ✓ |
| reviewer | ✓ | ✓ | - | ✓ | ✓ | ✓ | ✓ |
| researcher | ✓ | - | - | - | - | ✓ | - |
| security | ✓ | ✓ | limited | ✓ | ✓ | ✓ | ✓ |

## Capability Principle

Una capability define **qué puede hacer cognitivamente un agente**, no necesariamente qué herramientas puede invocar.

## Capability Validation

Antes de añadir una capability:

- definir resultado esperado;
- definir herramientas requeridas;
- definir riesgos;
- definir evaluación;
- definir límites.
