# Development Conventions

## Naming

Preferir nombres explícitos:

```text
execution_id
agent_id
tool_id
workflow_id
task_id
```

Evitar nombres ambiguos como `id`, `data` o `context` cuando puedan generar confusión.

## Organización

Separar:

```text
Domain
Contracts
Runtime
Adapters
Infrastructure
Tests
```

## Error Handling

Preferir:

```text
typed error
+
context
+
execution_id
+
recovery strategy
```

No ocultar errores.

## Logging

No registrar:

- API keys;
- passwords;
- tokens;
- secretos;
- información privada innecesaria.

## Testing

Todo componente nuevo debe tener tests apropiados.

## Documentation

Toda capacidad nueva debe documentar:

- propósito;
- interfaz;
- configuración;
- permisos;
- riesgos;
- ejemplos;
- tests.

## Git

Cada cambio debe ser pequeño, trazable, revisable y reproducible.

## Agent Development

Los prompts e instrucciones de agentes son artefactos versionados.

## Tool Development

Toda herramienta debe incluir:

```text
definition
schema
permissions
risk
tests
error handling
```

> Una foundation consistente reduce drásticamente la complejidad de agentes y workflows posteriores.
