# Repository Bootstrap

## Estructura recomendada

```text
project/
├── .opencode/
│   ├── agents/
│   ├── commands/
│   └── tools/
├── agents/
│   ├── core/
│   └── implementations/
├── tools/
│   ├── core/
│   └── adapters/
├── runtime/
│   ├── execution/
│   ├── registry/
│   └── events/
├── contracts/
│   ├── tasks/
│   ├── agents/
│   ├── tools/
│   └── workflows/
├── config/
│   ├── environments/
│   └── policies/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
└── scripts/
```

## Reglas

- separar código, configuración, tests y documentación;
- no guardar secretos en Git;
- ignorar artefactos temporales;
- mantener cambios trazables mediante Git.

## Bootstrap Checklist

- [ ] repository;
- [ ] `.gitignore`;
- [ ] configuración;
- [ ] test runner;
- [ ] linting;
- [ ] formatting;
- [ ] documentación;
- [ ] variables de entorno documentadas.
