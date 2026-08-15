# Orchestration MVP

## Objective

Construir el mínimo orchestrator útil para coordinar el primer equipo.

## Supported

```text
Task intake
↓
Explicit workflow
↓
Sequential agent execution
↓
Handoffs
↓
Tool execution
↓
Quality gates
↓
Retry
↓
Failure escalation
↓
Human approval
```

## MVP Workflow

```text
analyst
   ↓
architect
   ↓
developer
   ↓
tester
   ↓
reviewer
```

## Optional Specialist

```text
security
```

se activa cuando el workflow lo determine.

## Excluded From MVP

- autonomous planning;
- reinforcement-based routing;
- complex agent negotiation;
- uncontrolled parallel writes;
- automatic production deployment.

## Exit Criteria

- workflow reproducible;
- estado persistido;
- handoffs validados;
- retries controlados;
- quality gates funcionando;
- errores trazables;
- aprobación humana funcional.
