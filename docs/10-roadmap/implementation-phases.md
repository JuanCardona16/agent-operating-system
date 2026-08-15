# Implementation Phases

## Phase 0 — Architecture & Documentation

### Objective
Completar la especificación necesaria para comenzar la implementación.

### Deliverables
- arquitectura;
- agentes;
- herramientas;
- workflows;
- memoria;
- calidad;
- operaciones;
- implementación;
- roadmap.

### Exit Criteria
- arquitectura documentada;
- responsabilidades definidas;
- agentes iniciales identificados;
- herramientas clasificadas;
- workflows principales definidos;
- riesgos conocidos;
- roadmap aprobado.

---

## Phase 1 — Foundation

### Objective
Construir la infraestructura mínima.

### Scope
- repository structure;
- configuration;
- contracts;
- runtime bootstrap;
- agent base;
- tool base;
- event model;
- logging básico.

### Exit Criteria
- runtime inicia correctamente;
- configuración validada;
- contratos definidos;
- eventos básicos generados;
- errores detectables;
- tests de foundation pasando.

---

## Phase 2 — Single-Agent MVP

### Objective
Conseguir que un único agente complete una tarea real.

### Agent
`developer`

### Tools
`filesystem.read`, `filesystem.write`, `terminal.execute`, `git.diff`, `test.run`

### Workflow
```text
Task → Developer → Modify → Test → Result
```

### Exit Criteria
- tarea real completada;
- cambios aislados;
- tests ejecutados;
- resultado estructurado;
- errores registrados;
- límites activos;
- secretos protegidos.

---

## Phase 3 — Tooling

### Objective
Construir un sistema de herramientas robusto.

### Scope
- tool registry;
- permissions;
- adapters;
- validation;
- timeout;
- retry;
- audit;
- risk classification.

### Exit Criteria
- herramientas registradas;
- permisos verificables;
- inputs validados;
- outputs normalizados;
- operaciones peligrosas identificadas;
- llamadas observables.

---

## Phase 4 — Multi-Agent Collaboration

### Objective
Permitir colaboración mediante contratos.

### Agents
`analyst`, `architect`, `developer`, `tester`, `reviewer`

### Flow
```text
Analyst → Architect → Developer → Tester → Reviewer
```

### Exit Criteria
- handoffs estructurados;
- agentes desacoplados;
- estados claros;
- fallos manejables;
- resultados transferibles.

---

## Phase 5 — Workflow Orchestration

### Objective
Introducir un orchestrator para workflows completos.

### Scope
- task manager;
- workflow engine;
- routing;
- dependencies;
- parallel execution;
- retries;
- escalation;
- human approval.

### Exit Criteria
- workflows reproducibles;
- tareas persistentes;
- dependencias respetadas;
- checkpoints;
- reanudación;
- escalación;
- aprobación humana.

---

## Phase 6 — Memory

### Objective
Reutilizar conocimiento relevante.

### Scope
```text
Task Memory
Project Memory
Architecture Memory
Agent Memory
Organizational Memory
```

### Exit Criteria
- memoria consultable;
- retrieval relevante;
- escritura controlada;
- provenance;
- invalidación;
- protección contra secretos;
- control de información obsoleta.

---

## Phase 7 — Quality & Review

### Objective
Convertir calidad en mecanismo automático.

### Scope
- tests;
- lint;
- static analysis;
- security checks;
- code review;
- quality gates;
- regression detection.

### Exit Criteria
- gates automáticos;
- resultados estructurados;
- criterios de aprobación;
- rework seguro;
- escalación.

---

## Phase 8 — Observability & Operations

### Objective
Conseguir visibilidad completa.

### Scope
- logs;
- metrics;
- traces;
- execution history;
- cost tracking;
- dashboards;
- alerts.

### Exit Criteria
Debe poder responderse:
```text
¿Qué ocurrió?
¿Quién lo hizo?
¿Qué herramientas utilizó?
¿Cuánto tardó?
¿Cuánto costó?
¿Por qué falló?
¿Qué cambió?
```

---

## Phase 9 — Security & Governance

### Objective
Controlar la autonomía mediante políticas.

### Scope
- least privilege;
- secret management;
- sandboxing;
- audit;
- approval policies;
- network controls;
- risk classification;
- policy enforcement.

### Exit Criteria
- permisos verificables;
- acciones críticas protegidas;
- auditoría;
- secretos fuera del contexto;
- políticas automáticas;
- rollback.

---

## Phase 10 — Advanced Autonomy

### Objective
Incrementar la autonomía después de estabilizar las fases anteriores.

### Scope
- dynamic routing;
- model routing;
- agent specialization;
- parallel execution;
- self-correction;
- proactive research;
- autonomous task decomposition;
- adaptive workflows.

### Exit Criteria
- autonomía limitada por políticas;
- coste controlado;
- calidad estable;
- fallos recuperables;
- decisiones auditables;
- aprobación configurable;
- métricas superiores al baseline.

> Ninguna fase está completa hasta cumplir sus criterios de salida.
