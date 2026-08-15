# Agent Rollout

## Rollout Order

```text
1. Developer
2. Tester
3. Reviewer
4. Analyst
5. Architect
6. Researcher
7. Security
8. Orchestrator
```

## Developer
Valida runtime, tools, filesystem, terminal, Git y tests.

## Tester
Separa implementación de validación.

```text
Developer → Tester
```

## Reviewer
Añade evaluación independiente.

```text
Developer → Tester → Reviewer
```

## Analyst
Introduce análisis previo.

```text
Analyst → Developer
```

## Architect
Introduce diseño explícito.

```text
Analyst → Architect → Developer
```

## Researcher
Se incorpora cuando las tareas requieren investigación externa.

## Security
Se incorpora cuando los workflows soportan análisis sistemático de seguridad.

## Orchestrator
Se incorpora después de validar manualmente los workflows especializados.

> Primero validar cada agente; después automatizar su coordinación.
