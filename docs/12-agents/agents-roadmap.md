# Agents Roadmap

## Phase A — First Agent

Implementar:

```text
developer
```

Objetivo: validar integración OpenCode + herramientas + ejecución real.

## Phase B — Validation

Añadir:

```text
tester
reviewer
```

Objetivo: separar implementación y validación.

## Phase C — Planning

Añadir:

```text
analyst
architect
```

Objetivo: introducir planificación y diseño.

## Phase D — Specialists

Añadir:

```text
researcher
security
```

Objetivo: especialización bajo demanda.

## Phase E — Orchestration

Introducir coordinación automática.

```text
Task
 ↓
Agent Selection
 ↓
Handoff
 ↓
Execution
 ↓
Quality Gate
```

## Phase F — Optimization

Introducir:

- model routing;
- dynamic routing;
- parallel execution;
- agent performance scoring.

## Rollout Rule

No desplegar todos los agentes desde el primer día.

Cada agente debe justificar:

```text
Need
+
Capability
+
Tooling
+
Evaluation
+
Operational Value
```

## Target Team

```text
                 ┌─────────────┐
                 │   Analyst   │
                 └──────┬──────┘
                        ↓
                 ┌─────────────┐
                 │  Architect  │
                 └──────┬──────┘
                        ↓
                 ┌─────────────┐
                 │  Developer  │
                 └──────┬──────┘
                        ↓
                 ┌─────────────┐
                 │   Tester    │
                 └──────┬──────┘
                        ↓
                 ┌─────────────┐
                 │  Reviewer   │
                 └─────────────┘

Researcher ───────► specialized support
Security   ───────► specialized gate
```
