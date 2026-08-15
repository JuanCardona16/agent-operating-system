# Roadmap de Construcción

Orden definitivo de construcción y despliegue del sistema multiagente. Resuelve el conflicto de
esquemas de fases (8 fases en `09-implementation` vs 11 fases en `10-roadmap`) adoptando **un único
orden canónico** derivado de `10-roadmap` y de los órdenes de implementación de `18-opencode-integration`
y `19-runtime` (véase ADR-000, ADR-002, ADR-012).

## Quick path

1. **Empezar por el MVP mono-agente** (Fase 2): un `developer` que complete una tarea real de punta a
   punta marca el hito **M1 — First End-to-End Coding Workflow**.
2. **Respetar el camino crítico**: Fundamentos → MVP → Herramientas → Equipo → Orquestación → Calidad
   → Seguridad → Autonomía (§5).
3. **Punto de partida existente**: el repositorio hermano `agent-system` ya implementa en TS/Node el
   runtime de Fases 0-7 (orquestador, memoria, gates G1-G6 con rework, motor de permisos) — usar como
   base, no reinventar (véase ADR-008).
4. **Autonomía al final**: L0-L4 se habilitan solo cuando los controles de seguridad lo soportan (§6).

> **Regla**: la autonomía es el resultado final del roadmap, no el punto de partida.

---

## 1. Resolución del conflicto de esquemas de fases

| Esquema | Fases | Característica |
|---------|-------|----------------|
| `09-implementation` | 8 | Minimal Agent Runtime → Developer+Tester → Orchestrator → Memory → Quality Gates → Observability → Advanced Routing → Autonomous Workflows |
| `10-roadmap` | 11 (0-10) | Architecture → Foundation → Single-Agent MVP → Tooling → Multi-Agent → Orchestration → Memory → Quality → Observability → Security → Advanced Autonomy |
| `18-opencode-integration` | 6 | Bootstrap → Team → Orchestration → Platform → Optimization → Gentle-AI |
| `19-runtime` | 5 | Bootstrap → Reliability → Full Team → Platform → Production |

**Decisión**: se adopta el orden canónico de la tabla §3 — alineado con `10-roadmap` (que integra
Seguridad como fase propia, ausente en 09) y con los órdenes de 18/19 (que coinciden en
Bootstrap → Equipo → Orquestación → Plataforma). Las 8 fases de 09 quedan absorbidas: su secuencia
`runtime → developer+tester → orchestrator → memory → gates → observability → routing → autonomy`
es un subconjunto del orden canónico. Los milestones M0-M12 de `10-roadmap` se mapean a las fases (§4).

## 2. Principios del roadmap

1. Construir incrementalmente; validar cada capa antes de añadir complejidad.
2. Priorizar un MVP pequeño pero funcional.
3. Introducir autonomía progresivamente.
4. Contratos explícitos; seguridad desde el inicio; medir antes de optimizar.
5. Evitar agentes innecesarios; mantener OpenCode y Gentle-AI desacoplados (véase ADR-011, ADR-012).
6. Cada fase tiene **criterios de salida objetivos** con umbrales de ADR-007.
7. Ninguna fase está completa hasta cumplir sus criterios de salida.

## 3. Orden canónico de fases

| Fase | Nombre | Milestone | Fuente principal |
|------|--------|-----------|------------------|
| 0 | Fundamentos | M0 — Architecture Ready | 10-roadmap P1, 18 P1, 19 P1 |
| 1 | MVP mono-agente | **M1 — First End-to-End Coding Workflow** | 10-roadmap P2, 19 |
| 2 | Herramientas y permisos | M4 — Tool System | 10-roadmap P3, 17-security |
| 3 | Equipo completo | M6 — Development Team | 10-roadmap P4, 18 P2, 19 P3 |
| 4 | Orquestación | M7 — Orchestrated Workflow | 10-roadmap P5, 18 P3 |
| 5 | Memoria | M8 — Persistent Memory | 10-roadmap P6 (véase ADR-008) |
| 6 | Calidad y revisión | M9 — Quality Automation | 10-roadmap P7 (véase ADR-006) |
| 7 | Observabilidad y operaciones | M10 — Operational Visibility | 10-roadmap P8 (véase ADR-014) |
| 8 | Seguridad y gobernanza | M11 — Secure Autonomy | 10-roadmap P9 (véase ADR-009, ADR-015) |
| 9 | Autonomía avanzada | M12 — Autonomous Development Loop | 10-roadmap P10, future-evolution |

## 4. Fases detalladas

> En cada fase, "Relación con `agent-system`" se refiere al repositorio hermano
> `Documentaciones/agent-system`: runtime TS/Node donde las Fases 0-7 ya están implementadas con
> quality gates reales (memoria, orquestador, gates G1-G6 con rework). Es el **punto de partida** del
> runtime; la configuración de OpenCode de este framework define cómo materializarlo por repositorio.

### Fase 0 — Fundamentos

- **Objetivo**: infraestructura mínima y contratos definidos antes de escribir agentes.
- **Alcance**: estructura del repositorio; configuración; contratos (task, agent, handoff, artifact);
  bootstrap del runtime; modelo de eventos; logging básico.
- **Criterios de salida**: el runtime inicia; la configuración valida; los contratos están definidos;
  los eventos básicos se generan; los errores son detectables; tests de foundation pasan.
- **Dependencias**: arquitectura y ADR (véase ADR-000).
- **Relación con `agent-system`**: esqueleto del runtime ya presente (`src/config`, `src/tasks/types`,
  `src/agents/types`); completar lo que falte contra los contratos de este framework.

> **Regla**: sin contratos definidos y configuración validada no se escribe ningún agente.

### Fase 1 — MVP mono-agente — M1: First End-to-End Coding Workflow

- **Objetivo**: un único agente (`developer`) completa una tarea real end-to-end.
- **Alcance**: agente `developer`; herramientas `filesystem.read/write`, `terminal.execute`,
  `git.diff`, `test.run`; workflow `Task → Developer → Modify → Test → Result`; configuración básica;
  logging; resultado estructurado.
- **Criterios de salida**:
  - Tarea real completada (cambio de código + tests + git diff + resultado estructurado).
  - Cambios aislados al scope autorizado.
  - Tests ejecutados; límites activos (timeout tool `30s` default / `300s` máximo, `max_retries: 3`,
    `max_duration_minutes: 30` — véase ADR-007).
  - Secretos protegidos (nunca en contexto/logs); errores registrados y observables.
- **Dependencias**: Fase 0 + OpenCode + modelo (definido por el usuario) + herramientas básicas.
- **Relación con `agent-system`**: contratos y types de tarea/agente ya existen (`src/tasks`,
  `src/agents`); validar el flujo de `developer` contra el workflow de `19-runtime` y la escalera de
  validación de `11-opencode-configuration.md` §7.

> **Regla**: si un solo agente no ejecuta confiablemente una tarea pequeña, añadir más agentes no
> solucionará el problema.

### Fase 2 — Herramientas y permisos

- **Objetivo**: sistema de herramientas robusto con permisos verificables.
- **Alcance**: tool registry; modelo de permisos (véase ADR-009); adaptadores; validación de inputs;
  timeout; retry; audit; clasificación de riesgo; clasificación de comandos terminal
  (safe/restricted/dangerous/blocked, decidida ANTES de ejecutar).
- **Criterios de salida**: herramientas registradas y versionadas; permisos verificables en runtime
  (no solo en prompts); inputs validados; outputs normalizados; operaciones peligrosas identificadas;
  llamadas observables (véase ADR-014).
- **Dependencias**: Fase 1.
- **Relación con `agent-system`**: `src/tools/registry`, `src/permissions/engine` ya implementan el
  registro y el motor de permisos; completar riesgo/audit/timeout/retry y alinear con la matriz de
  `06-permissions-security.md` §3.

> **Regla**: cada herramienta nueva justifica necesidad, agente consumidor, permisos, riesgo, timeout,
> observabilidad y recuperación.

### Fase 3 — Equipo completo

- **Objetivo**: colaboración multiagente mediante contratos.
- **Alcance**: incorporar `analyst`, `architect`, `tester`, `reviewer`; `researcher` y `security` de
  forma condicional (investigación externa / `security_sensitive == true`); workflow
  `Analyst → Architect → Developer → Tester → Reviewer`; handoffs estructurados (véase ADR-013).
- **Criterios de salida**: handoffs con artefactos (provenance `execution_id, agent_id, created_at,
  checksum`); agentes desacoplados; estados claros (véase ADR-004); fallos manejables; resultados
  transferibles; una feature pequeña completada end-to-end por el equipo (M6).
- **Dependencias**: Fase 2 (herramientas y permisos por agente).
- **Relación con `agent-system`**: `src/agents/registry` y `src/workflows/*` definen el registro y los
  workflows; `src/observability/events` soporta la trazabilidad de handoffs.

> **Regla**: primero validar cada agente de forma independiente; después automatizar su coordinación.

### Fase 4 — Orquestación

- **Objetivo**: orquestar workflows completos con estados, reintentos y aprobación.
- **Alcance**: task manager; workflow engine; routing; dependencias; ejecución paralela; reintentos
  (clasificación obligatoria, `max_attempts: 3`, `max_same_transition: 3` — véase ADR-005); escalación;
  aprobación humana (véase ADR-010); checkpoints y reanudación.
- **Criterios de salida**: workflows reproducibles; tareas persistentes; dependencias respetadas;
  checkpoints; reanudación tras fallo; escalación a `NEEDS_HUMAN`; aprobación con expiración
  (`expires_at`; silencio ≠ autorización).
- **Dependencias**: Fase 3.
- **Relación con `agent-system`**: `src/orchestrator/orchestrator.ts` y `src/tasks/store` ya
  implementan el orquestador y el store de tareas; completar routing, dependencias, paralelismo y
  aprobación contra el contrato de ADR-010.

> **Regla**: cada reintento aporta diagnóstico nuevo; un bucle nunca oculta un fallo determinista
> (véase ADR-005).

### Fase 5 — Memoria (véase ADR-008)

- **Objetivo**: reutilizar conocimiento relevante entre tareas.
- **Alcance**: memoria de tarea, proyecto, agente y organizational (en ese orden); tipos de contenido
  `FACT, DECISION, CONVENTION, CONSTRAINT, LESSON, REFERENCE, ARTIFACT, EVENT`; confianza
  (`unknown…verified`); escala (`global…execution`); validación antes de persistir.
- **Criterios de salida**: memoria consultable con retrieval relevante; escritura controlada;
  provenance; invalidación; protección contra secretos; control de información obsoleta; no se
  promueve automáticamente output de agentes; la memoria recuperada es contexto, no instrucción.
- **Dependencias**: Fase 4 (identidad de tarea/agente).
- **Relación con `agent-system`**: `src/memory/store` ya implementa el store (task/project) y su
  integración con el orquestador — el almacenamiento MVP (SQLite/archivos estructurados) es el
  previsto por ADR-008.

> **Regla**: primero demostrar qué información vale la pena conservar; después automatizar su
> persistencia.

### Fase 6 — Calidad y revisión (véase ADR-006)

- **Objetivo**: calidad como mecanismo automático del sistema, no recomendación de agentes.
- **Alcance**: gates de tarea **G1-G6** (G1 Requirements, G2 Implementation, G3 Tests, G4 Static
  Quality, G5 Security, G6 Review) y gates de release **R1-R4** (Basic, Quality, Security, Operations);
  rework; detección de regresión; bypass solo con aprobación humana registrada (razón + propietario +
  riesgo + expiración).
- **Criterios de salida**: gates automáticos por tipo de tarea (matriz explícita); resultados
  estructurados; criterios de aprobación; rework seguro (`TESTING → IMPLEMENTING`,
  `REVIEWING → IMPLEMENTING`); escalación; umbrales de ADR-007: cobertura `80%` en código crítico,
  tasa de aprobación de review ≥ `80%` sin regresión de métricas críticas (R2).
- **Dependencias**: Fase 4 (workflows) + artefactos (véase ADR-013).
- **Relación con `agent-system`**: `src/quality/gates.ts` implementa **G1-G6 con rework y matriz por
  tipo de tarea**; `src/quality/service.ts` y `src/quality/runners.ts` ejecutan las verificaciones
  reales (tests, typecheck, lint, security). Completar R1-R4 y la integración con evaluación.

> **Regla**: un agente nunca es la única autoridad para validar su propio trabajo.

### Fase 7 — Observabilidad y operaciones (véase ADR-014)

- **Objetivo**: visibilidad completa y reconstrucción de cualquier ejecución.
- **Alcance**: logs; métricas; traces; historial de ejecuciones; tracking de costo; dashboards; alerts.
  Cadena de correlación `request_id → task_id → execution_id → step_id → agent_id → tool_call_id`
  (+ `trace_id`); audit append-only sin secretos.
- **Criterios de salida**: responder con evidencia: qué ocurrió, quién lo hizo, qué herramientas usó,
  cuánto tardó, cuánto costó, por qué falló, qué cambió. Latencia objetivo p95 < `120s` por paso de
  agente en flujo normal (véase ADR-007). **No declarar el runtime estable hasta poder reconstruir una
  ejecución fallida.**
- **Dependencias**: Fase 4 (eventos) + Fase 5 (memoria de ejecución).
- **Relación con `agent-system`**: `src/observability/events.ts` define los eventos; completar
  métricas, correlación completa, dashboards y alerts.

> **Regla**: si una ejecución no puede reconstruirse, el sistema no está suficientemente operativo.

### Fase 8 — Seguridad y gobernanza (véase ADR-009, ADR-015)

- **Objetivo**: controlar la autonomía mediante políticas, no mediante prompts.
- **Alcance**: least privilege; gestión de secretos; sandboxing (workspace + comandos restringidos +
  paths de escritura explícitos + red allowlist); auditoría; políticas de aprobación; controles de red;
  clasificación de riesgo; enforcement de políticas; testing de seguridad obligatorio y regresión de
  cada vulnerabilidad corregida.
- **Criterios de salida**: permisos verificables en runtime; acciones críticas protegidas; auditoría
  completa; secretos fuera de contexto/logs; políticas automáticas y versionadas (`id, version,
  effective_at, owner, changes`); rollback; casos de `11-opencode-configuration.md`/`06` §11 pasando.
- **Dependencias**: Fases 2-4 (herramientas, permisos, orquestación).
- **Relación con `agent-system`**: `src/permissions/engine` y los tests de enforcement ya cubren el
  núcleo; completar sandboxing, red, secretos y gobernanza contra `06-permissions-security.md`.

> **Regla**: la capacidad de ejecutar una acción nunca implica autorización para ejecutarla.

### Fase 9 — Autonomía avanzada (L0-L4)

- **Objetivo**: incrementar la autonomía solo después de estabilizar las fases anteriores.
- **Alcance**: routing dinámico de agentes y modelos; ejecución paralela controlada; self-correction;
  research proactivo; descomposición de tareas; workflows adaptativos.
- **Criterios de salida**: autonomía limitada por políticas; costo controlado; calidad estable;
  fallos recuperables; decisiones auditables; aprobación configurable; métricas superiores al baseline
  evaluado contra el dataset de regresión.
- **Dependencias**: todas las anteriores (en especial Seguridad Fase 8).
- **Relación con `agent-system`**: no implementado aún; es la única fase sin punto de partida en el
  repo hermano.

> **Regla**: la autonomía se gana con evidencia operacional, no por disponibilidad técnica.

---

## 5. Camino crítico

```text
Fundamentos → MVP → Herramientas → Equipo → Orquestación → Calidad → Seguridad → Autonomía
```

| Capacidad | Requiere |
|-----------|----------|
| Foundation | Architecture (ADR-000) |
| MVP mono-agente | Foundation + OpenCode + modelo + tools básicas |
| Multi-agente | Contratos + handoffs + tools |
| Orquestación | Task model + runtime + workflows |
| Memoria | Identidad de task/agente + storage + retrieval |
| Calidad | Workflows + artefactos + ejecución de tests |
| Operaciones | Eventos + execution IDs + logs |
| Seguridad | Tools + permissions + resources + audit |

Dependencias suaves (introducibles gradualmente): advanced routing, advanced memory, dashboards,
distributed runtime, múltiples proveedores de modelo. **No introducir capacidades avanzadas antes de
estabilizar sus dependencias fundamentales.**

## 6. Niveles de autonomía L0-L4

| Nivel | Nombre | Descripción | Gate previo |
|-------|--------|-------------|-------------|
| L0 | Human Driven | El humano ejecuta; el sistema asiste pasivamente | — |
| L1 | Assisted | El sistema sugiere; el humano decide | Fase 1 (M1) |
| L2 | Delegated | El sistema ejecuta tareas delimitadas bajo supervisión | Fase 4 (orquestación + aprobación) |
| L3 | Supervised Autonomous | El sistema ejecuta workflows completos; lo crítico exige aprobación | Fase 8 (seguridad/gobernanza) |
| L4 | Highly Autonomous | Ciclo completo con mínima intervención; políticas y evaluación continuas | Fase 9 con métricas superiores al baseline |

## 7. Alcance del MVP

**Incluido**: OpenCode; agente `developer`; filesystem; terminal; Git (read + branch_create + commit);
tests; configuración básica; logging básico; resultado estructurado. Workflow
`User → Task → Developer → Inspect → Plan → Implement → Test → Diff → Report`.

**Excluido explícitamente**:

- orquestador complejo;
- memoria persistente;
- routing dinámico;
- equipo grande de agentes;
- autonomía avanzada (L3/L4);
- ejecución distribuida;
- dashboards complejos;
- **planificación autónoma de tareas**;
- **routing basado en RL**;
- **negociación entre agentes**;
- **escrituras paralelas no controladas**;
- **deployment automático a producción** (requiere aprobación humana explícita);
- **núcleo de Gentle-AI** (opcional, vía adaptador — véase ADR-011).

Criterios de aceptación del MVP: funcional (recibir tarea, inspeccionar, modificar, ejecutar tests,
devolver resultado); safety (workspace limitado, permisos explícitos, secretos protegidos, comandos
controlados); quality (tests ejecutados, diff disponible, errores reportados); observability
(execution_id, agent_id, tool calls, duración, estado final).

## 8. Despliegue de workflows

| Workflow | Secuencia | Fase |
|----------|-----------|------|
| 1 Direct Implementation | `Task → Developer → Test → Result` | 1 |
| 2 Implementation + Review | `Task → Developer → Tester → Reviewer → Result` | 3 |
| 3 Planned Feature | `Task → Analyst → Architect → Developer → Tester → Reviewer` | 3 |
| 4 Research-Driven | `Task → Analyst → Researcher → Architect → Developer → Tester → Reviewer` | 3 (researcher condicional) |
| 5 Governed Development | Analyst → Architect → Security → Developer → Tester → Reviewer → Quality Gate → Approval → Done | 8 |

Cada workflow nuevo debe demostrar valor frente al anterior.

## 9. Milestones (consolidado M0-M12)

| Milestone | Nombre | Fase | Criterios clave |
|-----------|--------|------|-----------------|
| M0 | Architecture Ready | 0 | Arquitectura aprobada; contratos; riesgos documentados |
| M1 | **First End-to-End Coding Workflow** | 1 | Developer completa tarea real end-to-end |
| M2 | First Agent | 1 | Developer recibe tarea, lee repo, modifica, devuelve resultado |
| M3 | First Real Task | 1 | Cambio + tests + git diff + resultado estructurado |
| M4 | Tool System | 2 | Registry; permission checks; validación; audit; timeouts |
| M5 | Multi-Agent Handoff | 3 | Handoff estructurado; contexto preservado; sin acoplamiento directo |
| M6 | Development Team | 3 | Feature pequeña completada por el equipo end-to-end |
| M7 | Orchestrated Workflow | 4 | Task creada; workflow seleccionado; gates ejecutados; resultado |
| M8 | Persistent Memory | 5 | Retrieval relevante; decisiones persistidas; provenance |
| M9 | Quality Automation | 6 | Tests + lint + review + security + gate |
| M10 | Operational Visibility | 7 | Logs, métricas, traces, costo, historial, alerts |
| M11 | Secure Autonomy | 8 | Least privilege; políticas de riesgo; gates de aprobación; audit; rollback |
| M12 | Autonomous Development Loop | 9 | Understand → Plan → Research → Implement → Test → Review → Correct → Report |

## 10. Definition of Done del sistema maduro

Recibir tareas reales; coordinar agentes; modificar repositorios de forma controlada; ejecutar tests;
revisar cambios; conservar conocimiento útil; explicar sus acciones; recuperarse de fallos; aplicar
quality gates; requerir aprobación humana para acciones críticas; y hacer todo ello bajo políticas
versionadas y observabilidad completa.

> **Regla**: la autonomía debe ganarse mediante evidencia operacional, no habilitarse simplemente por
> disponibilidad técnica.

---

## Decisiones resueltas

- **Cronograma y secuenciación de fases 3-8**: **Resuelto** (véase ADR-023): fases **en serie por
  defecto**, con criterio de corte por dependencias del roadmap (cada fase desbloquea la siguiente).
  Solapamiento controlado permitido solo para trabajo read-only/independiente, con aprobación explícita
  del orquestador y sin compartir workspace de escritura.
- **Estado de `agent-system`**: **Resuelto** (véase ADR-023): alineación formal **parcial** confirmada
  con evidencia — la matriz de permisos ADR-009 está implementada y enforced en la capa de
  runtime/tool, y la matriz de gates es idéntica. Las desviaciones (`max_duration` ausente, cobertura
  80% y p95 ausentes, timeout default 300 s vs 30 s, `max_attempts` 2/3 por stage vs 3 central,
  `max_concurrent_agents` no enforced, workflows faltantes architecture/security/documentation,
  ASK/DENY por categoría no modelado, checkpoints en memoria) quedan como backlog del roadmap, no
  como bloqueante del framework.
