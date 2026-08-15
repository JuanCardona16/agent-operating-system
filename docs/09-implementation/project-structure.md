# Project Structure

## 1. Purpose

Define la estructura física recomendada para implementar el sistema multiagente.

## 2. Repository Structure

```text
agent-system/
├── .opencode/
│   ├── agents/
│   ├── commands/
│   └── configuration/
│
├── agents/
│   ├── orchestrator/
│   ├── analyst/
│   ├── architect/
│   ├── researcher/
│   ├── developer/
│   ├── tester/
│   └── reviewer/
│
├── workflows/
│   ├── feature/
│   ├── bugfix/
│   ├── refactor/
│   └── review/
│
├── tools/
│   ├── filesystem/
│   ├── git/
│   ├── terminal/
│   ├── testing/
│   └── search/
│
├── memory/
│   ├── schemas/
│   ├── stores/
│   └── policies/
│
├── quality/
│   ├── gates/
│   ├── policies/
│   └── reports/
│
├── observability/
│   ├── logs/
│   ├── metrics/
│   └── traces/
│
├── config/
│   ├── agents/
│   ├── models/
│   ├── tools/
│   └── workflows/
│
├── scripts/
│
├── tests/
│
├── docs/
│   ├── 01-architecture/
│   ├── 02-agents/
│   ├── 03-tools/
│   ├── 04-workflows/
│   ├── 05-tools/
│   ├── 06-memory/
│   ├── 07-quality/
│   ├── 08-operations/
│   └── 09-implementation/
│
├── .env.example
├── README.md
└── AGENTS.md
```

## 3. Separation

Debe diferenciarse claramente:

```text
agents/
    Agent behavior

tools/
    External capabilities

workflows/
    Coordination logic

memory/
    Persistent knowledge

quality/
    Validation

config/
    Runtime configuration
```

## 4. Agent Directory

Cada agente debería tener una definición clara.

Ejemplo:

```text
agents/developer/
├── agent.md
├── instructions.md
├── capabilities.md
└── policy.md
```

La estructura exacta puede simplificarse según las capacidades reales de OpenCode.

## 5. Workflow Directory

Ejemplo:

```text
workflows/feature/
├── workflow.md
├── stages.md
├── gates.md
└── handoffs.md
```

## 6. Configuration

La configuración no debe estar mezclada con las instrucciones del agente.

```text
config/
├── agents/
├── models/
├── tools/
└── workflows/
```

## 7. Generated Data

Los artefactos generados durante ejecución no deben mezclarse con las definiciones.

```text
runtime/
├── executions/
├── artifacts/
├── reports/
└── logs/
```

Si esta carpeta se utiliza, debe quedar separada del código fuente.

## 8. Core Principle

> La estructura del repositorio debe hacer evidente dónde vive cada responsabilidad.
