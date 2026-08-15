# Registro de Decisiones del Framework (ADR-000)

**Estado**: Aceptado (base del framework)
**Fecha**: 2026-08-15
**Autor**: Orquestador del framework, a partir del análisis consolidado de `docs/01-19` (223 archivos, 19 dominios)

Este registro define las decisiones normativas que resuelven las contradicciones y lagunas
encontradas en la especificación original. **Todo documento del framework se deriva de estas
decisiones.** Cuando un documento de `docs/01-19` contradiga una decisión de este registro,
prevalece este registro.

Cada decisión sigue el formato ADR resumido: **Problema** (conflicto o laguna) → **Decisión** →
**Consecuencias**.

---

## ADR-001 — Idioma y estilo de los artefactos

- **Problema**: La spec mezcla encabezados en inglés con cuerpos en español; sin convención declarada.
- **Decisión**: Todo el framework (documentos, esquemas, comentarios, configuraciones) se escribe en
  **español neutral-profesional**. Los identificadores técnicos (IDs, tokens de estado, nombres de
  campos, comandos) permanecen en inglés. Las conversaciones directas con el humano siguen la
  lengua activa del usuario; los artefactos, no.
- **Consecuencias**: Documentación homogénea, parseable y derivable a configuración sin fricción.

## ADR-002 — El Orchestrator es mecanismo, no agente del pipeline

- **Problema**: README y `02-agents` lo definen como agente; `12-agents` lo omite; `13-orchestration`
  lo trata como maquinaria. No existe definición de agente orchestrator en ningún lado.
- **Decisión**: El Orchestrator es el **controlador de flujo** del framework (task manager, workflow
  engine, agent resolver, permission gate, retry manager, quality gate manager, approval manager,
  event dispatcher). No compite con los agentes especializados: coordina, no ejecuta. En OpenCode se
  materializa como el agente principal de configuración y los comandos del framework.
- **Consecuencias**: El roster de agentes queda definido por los roles especializados; la lógica de
  coordinación vive en el runtime, es testeable y no depende de un modelo.

## ADR-003 — Roster definitivo de agentes: 7 + security condicional

- **Problema**: El roster varía entre README (7, sin Security), `02-agents` (Security como futuro),
  `12-agents` (8 con Security en el equipo) y `10-roadmap` (Security en fase D).
- **Decisión**: Roster canónico de **7 roles de ejecución + Security condicional**:
  1. `analyst` — requisitos, ambigüedad, criterios de aceptación.
  2. `architect` — diseño, interfaces, decisiones arquitectónicas (ADR).
  3. `researcher` — investigación técnica con evidencia.
  4. `developer` — implementación, corrección, tests.
  5. `tester` — validación, regresiones, criterios de aceptación.
  6. `reviewer` — revisión independiente (correctitud, mantenibilidad, seguridad, rendimiento).
  7. `security` — auditoría de seguridad; **solo participa cuando `security_sensitive == true`**.
- **Consecuencias**: Un solo roster coherente para definiciones, permisos y evaluación. Security como
  servicio y como agente: el agente produce hallazgos; el servicio (gates, política) los hace cumplir.

## ADR-004 — Máquina de estados unificada en tres capas mapeadas

- **Problema**: Cuatro vocabularios de estado sin mapeo canónico (task, agent lifecycle, execution,
  output statuses).
- **Decisión**: Tres capas con tablas de mapeo formales:

  **Capa 1 — Estados de tarea (canónico, dominio)**
  `BACKLOG → ANALYZING → PLANNING → READY → IMPLEMENTING → TESTING → REVIEWING → APPROVED → DONE`
  Excepcionales: `BLOCKED, FAILED, NEEDS_HUMAN, CANCELLED`.
  Transiciones válidas: además de la cadena, `TESTING → IMPLEMENTING`, `REVIEWING → IMPLEMENTING`,
  y desde cualquier estado excepcional hacia el estado del workflow que corresponda.

  **Capa 2 — Estados de ejecución (runtime)**
  `created → queued → running → waiting → blocked → failed → completed → cancelled`
  (estado del runtime que materializa la tarea).

  **Capa 3 — Status de salida del agente**
  `completed | failed | blocked | needs_human | partial`

  **Mapeo formal**:
  | Salida del agente | Estado de tarea resultante |
  |---|---|
  | `completed` | avanza al siguiente estado del pipeline |
  | `failed` | `FAILED` (con reporte de fallo) o retry → estado anterior |
  | `blocked` | `BLOCKED` (con razón y dependencia) |
  | `needs_human` | `NEEDS_HUMAN` / `WAITING_APPROVAL` (aprobación humana) |
  | `partial` | vuelve al estado anterior con entrega parcial documentada |
- **Consecuencias**: Implementación determinista de checkpoints, eventos y recuperación.

## ADR-005 — Política de reintentos unificada

- **Problema**: `max_attempts: 2` (13-orchestration) vs `max_attempts: 3` (03-tasks); sin precedencia.
- **Decisión**: `max_attempts: 3`, backoff exponencial, y **cada reintento debe añadir información
  nueva** (diagnóstico antes de reintentar). Protección de bucle: `max_same_transition: 3`.
  Clasificación obligatoria antes de reintentar:
  - **Reintentables**: timeout, fallo transitorio de red, infraestructura temporal, fallo transitorio
    de modelo/herramienta.
  - **NO reintentables**: permiso denegado, requisitos inválidos, violación de política, acción
    destructiva rechazada, fallo determinista de test.
- **Consecuencias**: Sin loops infinitos; cada retry aporta evidencia; costos acotados.

## ADR-006 — Sistema de quality gates unificado en dos niveles

- **Problema**: Tres vocabularios de gate sin reconciliar (07-quality G1-G6, 13-orchestration tipos,
  15-evaluation release gates).
- **Decisión**:
  - **Gates de tarea (G1-G6)** — reglas del sistema, no recomendaciones del agente:
    - G1 Requirements: requisitos y criterios de aceptación definidos.
    - G2 Implementation: implementación completa sin errores bloqueantes conocidos.
    - G3 Tests: tests requeridos pasan.
    - G4 Static Quality: lint + typecheck + formatter.
    - G5 Security: scan de seguridad + auditoría de dependencias (cuando aplica).
    - G6 Review: aprobación del Reviewer.
  - **Gates de release (R1-R4)** — deciden si un cambio llega a producción:
    - R1 Basic: tests pasan, esquemas válidos, sin errores críticos.
    - R2 Quality: umbrales de calidad y regresión cumplidos.
    - R3 Security: sin regresión de seguridad crítica.
    - R4 Operations: costo/latencia/tasa de fallo aceptables.
  - Regla transversal: **bypass solo con aprobación humana registrada** (razón + propietario + riesgo
    + expiración). Los gates de tarea se aplican por tipo de tarea mediante matriz explícita.
- **Consecuencias**: Un único modelo de gate por capa; sin ambigüedad de semántica.

## ADR-007 — Umbrales por defecto (v0) con valores concretos

- **Problema**: La spec menciona "umbrales" y "aceptable" sin números en ningún lado.
- **Decisión**: Valores por defecto configurables, auditables y revisables (v0):
  - Reintentos: `max_attempts: 3`, timeout de herramienta default `30s` / máximo `300s`.
  - Presupuesto por tarea: `max_duration_minutes: 30`, `max_retries: 3`, `max_cost` definido por
    tipo de tarea en configuración.
  - Cobertura: objetivo `80%` para código crítico; `cuando exista` con criterio explícito para el resto.
  - Puerta R2: tasa de aprobación de review ≥ `80%` y sin regresión de métricas críticas.
  - Latencia: objetivo p95 < `120s` por paso de agente en flujo normal.
  - Todo umbral es **configurable** en `opencode.json` / política; los defaults aquí son la línea base.
- **Consecuencias**: Gates y budgets ejecutables desde el día uno; números revisables sin cambiar arquitectura.

## ADR-008 — Modelo de memoria unificado

- **Problema**: Dos generaciones (06 vs 14) con layers, tipos y escalas distintas.
- **Decisión**: Capas: `Working → Execution → Task → Project → Agent → Knowledge + Audit`.
  Tipos de contenido: `FACT, DECISION, CONVENTION, CONSTRAINT, LESSON, REFERENCE, ARTIFACT, EVENT`.
  Confianza: `unknown | low | medium | high | verified`. Importancia: `critical | high | medium | low | temporary`.
  Escala: `global | project | workflow | task | execution | agent`.
  Reglas: guardar solo información con valor futuro identificable; validación antes de persistir;
  la memoria recuperada se marca como **contexto recuperado**, nunca como instrucción privilegiada;
  no promover automáticamente outputs de agentes. Almacenamiento MVP: SQLite/archivos estructurados
  (como en la implementación `agent-system`); backend nunca tocado directamente por agentes.
- **Consecuencias**: Un solo esquema de memoria; retrocompatible con la implementación existente.

## ADR-009 — Modelo de permisos: DENY/ASK/ALLOW con default DENY

- **Problema**: Tres taxonomías paralelas (niveles de permiso, clases de comando, categorías de riesgo).
- **Decisión**: Cadena única: `AGENT → CAPABILITY → TOOL → PERMISSION → RESOURCE → ACTION`.
  Niveles: `NONE | READ | WRITE | EXECUTE | ADMIN` por recurso. Matriz de riesgo:
  `read | write | execute | network | destructive | deploy | secret`.
  Comportamiento por nivel de riesgo (default): read `ALLOW`, write `ALLOW` (alcance de proyecto),
  execute `ASK` para categorías peligrosas, network `DENY` por defecto (allowlist),
  destructive `DENY/ASK`, deploy `ASK`, secret `DENY`.
  Reglas: sin auto-escalada; escalada solo por `Agente → Orquestador → Aprobación humana → permiso
  temporal (expires)`; **las instrucciones del prompt nunca son control de seguridad** — la
  aplicación vive en la capa de runtime/tool.
- **Consecuencias**: Matriz de permisos implementable directamente en OpenCode; sin ambigüedad de vocabulario.

## ADR-010 — Contrato de aprobación humana

- **Problema**: El modelo ASK/DENY/ALLOW exige aprobación, pero no existe contrato de quién aprueba,
  con qué formato o qué pasa tras el rechazo.
- **Decisión**: Flujo `REQUEST → WAITING_APPROVAL → APPROVE | REJECT | REQUEST_CHANGES`.
  Cada solicitud lleva: acción propuesta, nivel de riesgo, razón, impacto, recursos afectados,
  estrategia de rollback y expiración (`expires_at`). La expiración equivale a NO aprobado.
  **Una aprobación autoriza UNA acción concreta.** El silencio nunca es autorización.
  Tras `REJECT`: la tarea vuelve a `NEEDS_HUMAN` con la razón registrada; tras `REQUEST_CHANGES`:
  vuelve al estado del workflow que corresponda con la solicitud de cambio explícita.
- **Consecuencias**: Comportamiento determinista ante ausencia del humano; trazabilidad total.

## ADR-011 — Gentle-AI como capa opcional vía adaptador

- **Problema**: Gentle-AI figura en el README como capa central pero su integración está diferida y
  sus responsabilidades son condicionales.
- **Decisión**: El framework es **independiente de Gentle-AI**. Gentle-AI se integra solo mediante un
  adaptador (`Internal Interface → Gentle AI Adapter → Gentle AI`) y solo por capacidades verificadas
  (routing de modelos, gestión de agentes, evaluación). La ausencia de Gentle-AI degrada sin romper:
  el orquestador nativo y OpenCode cubren el ciclo completo.
- **Consecuencias**: Configuración funcional desde el día uno sobre OpenCode; Gentle-AI queda como
  mejora opcional de última fase, sin deuda técnica.

## ADR-012 — OpenCode como runtime de ejecución

- **Problema**: La spec no resuelve si el motor propio corre dentro o al lado de OpenCode.
- **Decisión**: OpenCode es el **runtime de ejecución** (agentes, herramientas, permisos, comandos).
  El framework define cómo se comportan y colaboran los agentes; la arquitectura, los contratos y las
  políticas de calidad/seguridad/observabilidad son del framework. Configuración versionada y
  reproducible: `opencode.json` + `AGENTS.md` + agentes `.md` + comandos.
- **Consecuencias**: El framework se materializa como configuración de OpenCode + contrato de agentes;
  nada ejecutable queda fuera de la herramienta.

## ADR-013 — Comunicación por artefactos verificables

- **Problema**: Handoffs y decisiones viven en contexto conversacional; sin persistencia verificable.
- **Decisión**: Toda información importante viaja en **artefactos** con provenance
  (`execution_id, agent_id, created_at, checksum`): plan, patch, test-report, review-report, logs,
  evaluación. Ningún handoff depende exclusivamente de contexto conversacional oculto. Las decisiones
  arquitectónicas persisten como ADR; nunca solo en historial de chat.
- **Consecuencias**: Reproducibilidad de ejecuciones fallidas; auditoría completa; contexto transferido mínimo.

## ADR-014 — Observabilidad con IDs de correlación y eventos tipados

- **Problema**: Eventos y métricas definidos, pero sin backend, retención ni correlación concreta.
- **Decisión**: Cadena de correlación única:
  `request_id → task_id → execution_id → step_id → agent_id → tool_call_id` (+ `trace_id`).
  Eventos tipados y versionados alimentan logs, métricas, auditoría y evaluación. Audit append-only
  e inmutable (`actor, action, resource, decision, timestamp, reason, execution_id`).
  **Nunca** se registran contraseñas, API keys, tokens o claves privadas; redacción antes de persistir.
- **Consecuencias**: Cualquier ejecución puede reconstruirse; incidentes auditable sin exponer secretos.

## ADR-015 — Seguridad: contenido no confiable = datos, no autoridad

- **Problema**: Riesgo de prompt injection y contaminación entre proyectos.
- **Decisión**: Jerarquía de confianza: `política del sistema > decisión humana explícita > evidencia
  verificada del repositorio > resultado verificado de test/herramienta > conocimiento documentado >
  inferencia del agente`. Contenido de repositorio/web/herramientas nunca otorga permisos ni cambia
  política. Validación de rutas (normalizar → resolver → root permitido → permiso → ejecutar);
  red restringida por defecto (allowlist); secrets nunca en prompts/memoria/logs/output de agente;
  aislamiento entre proyectos obligatorio (tests de contaminación).
- **Consecuencias**: Defensa por diseño contra prompt injection; política inmune a contenido hostil.

## ADR-016 — Documentación canónica del proyecto

- **Problema**: El framework define el sistema multiagente y su materialización en OpenCode, pero no
  define cómo se documenta el proyecto que los agentes construyen. `new-project-scaffold` genera
  documentación agnóstica al framework; las convenciones de `docs/` que el framework ya usa
  (`architecture`, `decisions`, `tasks`, `research`, `security`) no tienen una estructura canónica
  garantizada. Sin esto, el orquestador no tiene forma determinista de conocer funcionalidades, stack,
  alcance, limitaciones, restricciones y objetivos de un proyecto nuevo.
- **Decisión**: Todo proyecto que usa este framework tiene una **estructura canónica de documentación**
  bajo `docs/`, creada por `/framework-init` (bootstrap) y mantenida por los agentes como parte del
  trabajo:
  - `00-overview.md` — qué es el proyecto, objetivo, funcionalidades, usuarios.
  - `01-stack.md` — stack tecnológico (lenguaje, framework, DB, gestor de paquetes, deploy).
  - `02-scope.md` — alcance, limitaciones, restricciones, non-goals, objetivos.
  - `03-architecture.md` — arquitectura y decisiones.
  - `04-domain.md` — dominio (entidades).
  - `05-conventions.md` — convenciones de código.
  - `06-status.md` — estado actual + roadmap.
  - `07-changelog.md` — historial de cambios.
  - `decisions/` — ADRs del proyecto (`docs/decisions/ADR-XXX.md`).
  - `research/` — notas de investigación del agente `researcher`.
  - `tasks/` — carpetas `TASK-NNNNNN/` (requisitos, plan, resultado).
  - `security/` — hallazgos del agente `security`.
  Reglas normativas:
  1. **Lectura obligatoria**: el orquestador lee `AGENTS.md` + `00-overview`, `01-stack` y `02-scope`
     antes de planificar cualquier tarea; cada agente consulta además la documentación de su dominio
     (architect → `03-architecture` y `decisions/`, tester → ACs en `tasks/`, security → `security/`).
  2. **Escritura como parte del trabajo**: los agentes actualizan la documentación dentro de la tarea
     (changelog al completar, ADRs del proyecto en `decisions/`, status al cerrar milestones); la
     documentación viva es parte del Definition of Done.
  3. **Ciclo de vida**: `/framework-init` crea la estructura; los agentes la mantienen; la doc viva es
     el contrato de contexto del proyecto para todo agente nuevo.
- **Consecuencias**: Contexto de proyecto garantizado y verificable para todos los agentes; sin
  reinterpretación del proyecto en cada sesión; documentación viva y auditable; el scaffold genérico
  queda como generador de arranque opcional, la estructura canónica la define este ADR.

## ADR-017 — Matriz de permisos de documentación (Regla 2) y versión objetivo de OpenCode

- **Problema**: ADR-016 (Regla 2) exige que los agentes actualicen la documentación como parte del
  trabajo, pero la matriz de permisos baseline solo habilita escritura documental a `architect`
  (`docs/**`) y `security` (`docs/security/**`). `analyst`, `developer`, `tester` y `researcher`
  no pueden persistir documentación, por lo que la Regla 2 es inejecutable. Además, la validación de
  la sintaxis de `opencode.json` quedó condicionada a fijar la versión objetivo de OpenCode.
- **Decisión**:
  - **Versión objetivo de OpenCode**: `1.18.x` (instalada y verificada: `1.18.18`). La plantilla
    canónica se valida contra esa versión; el `$schema` del archivo apunta al schema oficial
    (`https://opencode.ai/config.json`) y se valida contra él al versionar la plantilla canónica.
  - **Matriz de escritura documental por agente** (default deny; solo el dominio que mantiene cada
    agente según ADR-016 + changelog cuando el agente completa el cambio):
    - `architect` → `docs/**` (ya vigente).
    - `analyst` → `docs/00-overview.md`, `docs/02-scope.md`, `docs/tasks/**`, `docs/07-changelog.md`.
    - `developer` → `docs/tasks/**`, `docs/07-changelog.md`.
    - `tester` → `docs/tasks/**`, `docs/07-changelog.md`.
    - `researcher` → `docs/research/**`, `docs/07-changelog.md`.
    - `security` → `docs/security/**` (ya vigente).
    - `reviewer` → read-only (no mantiene documentación).
  - Principio: un agente escribe solo su dominio documental y el changelog cuando completa el cambio;
    ningún agente escribe documentación fuera de la matriz, ni siquiera por delegación conversacional
    (véase ADR-009: la aplicación vive en la capa de runtime/tool, no en el prompt).
- **Consecuencias**: La Regla 2 de ADR-016 es ejecutable en OpenCode 1.18.x con default deny intacto;
  la matriz queda explícita y verificable; se resuelve la decisión pendiente de
  `11-opencode-configuration.md` y la de `13-project-documentation.md`.

## ADR-018 — Política Git canónica del framework

- **Problema**: `docs/05-tools/git-strategy.md` de la spec original está **vacío**; la §9 de
  `06-permissions-security.md` deriva de él. El repositorio hermano `agent-system/docs/git-strategy.md`
  ya la subsana (modelo de ramas `task/<task-id>`, squash-merge, sync antes de merge, política de
  conflictos, seguridad de secretos). Tampoco existe convención canónica de identidad del agente en commits.
- **Decisión**:
  - Adoptar `agent-system/docs/git-strategy.md` como **política Git canónica del framework**, citada
    formalmente en `06-permissions-security.md` §9. Sus reglas: `main` siempre verde (G1-G6 + review);
    rama por tarea `task/<task-id>`; worktrees para paralelismo; nadie commitea a `main` directo;
    conventional commits, atómicos (código+tests+docs), subject ≤ 72 chars, body con WHY; **sin
    atribución AI (sin `Co-Authored-By`)**; scan de secretos antes de cada `git.add`; pre-merge gates;
    sync antes de merge (`git pull --rebase`, conflictos → devuelve al Developer, nunca auto-resolver,
    nunca force como estrategia); squash-merge con referencia a la tarea; destructivas solo con grant
    temporal humano; `runtime/` git-ignored.
  - **Identidad del agente en commits**: la identidad de committer es **humana del repositorio**
    (`git config user.name/email` del proyecto, configurada por el humano); el agente NUNCA setea su
    propia identidad. La trazabilidad de quién produjo el cambio se registra en el mensaje del squash
    (referencia a la tarea) y en la documentación (ADR-013/ADR-016), no en la autoría del commit.
  - Operaciones remotas (push/rebase/merge/delete/force-push) solo por el Orquestador o con
    autorización humana explícita; ningún agente de ejecución las ejecuta.
- **Consecuencias**: política Git verificable y sin ambigüedad; commits con identidad humana auditable
  vía task; se cierra la pendiente de `06-permissions-security.md` §9.

## ADR-019 — Política de observabilidad v0

- **Problema**: ADR-014 fija el modelo de eventos y correlación, pero no el vocabulario de `severity`
  (la spec usa tres: logs DEBUG/INFO/WARN/ERROR/FATAL, alertas INFO/WARNING/CRITICAL, evento sin
  vocabulario), ni el backend, retención, umbrales de alerta ni la asignación de coste a modelo cuando
  el proveedor no expone el dato.
- **Decisión** (v0, configurable por política de proyecto):
  - **Vocabulario `severity` canónico de eventos**: `info | warning | error | critical`. Mapeo desde
    logs (`DEBUG/INFO`→`info`, `WARN`→`warning`, `ERROR`→`error`, `FATAL`→`critical`) y alertas
    (`INFO`→`info`, `WARNING`→`warning`, `CRITICAL`→`critical`). Los logs del runtime conservan su
    vocabulario nativo; los eventos tipados del framework usan el canónico.
  - **Backend MVP**: archivos estructurados JSONL bajo `runtime/` (git-ignored), consistente con
    ADR-008; backend externo opcional vía adaptador (mismo patrón que ADR-011), sin dependencia en v0.
  - **Retención por defecto**: `audit` inmutable + 365 días; `events` 90 días; `traces` 30 días;
    `logs` debug 7 días; métricas agregadas 365 días. Configurable.
  - **Umbrales de alerta por defecto**: workflow failure rate > 20%/1h `warning`, > 40%/1h `critical`;
    cost spike > 2× promedio semanal `warning`, > 5× `critical`; p95 paso de agente > 120 s `warning`
    (véase ADR-007); retry rate > 30% `warning`; timeout rate > 10% `warning`.
  - **Asignación de coste**: cuando el proveedor no expone el dato, se estima por tokens con tabla de
    precios por modelo en configuración; todo costo estimado se marca `cost_source: reported|estimated`
    y `estimated: true`; nunca se duplica el dato real si el proveedor lo expone.
- **Consecuencias**: eventos con severidad sin ambigüedad; alertas accionables desde el día uno;
  costos auditables aunque el proveedor no reporte; se cierran las pendientes de `05-contracts.md`,
  `09-observability.md` y `10-operations.md`.

## ADR-020 — Parámetros de evaluación y memoria v0

- **Problema**: `max_cost` por tipo de tarea, TTLs de retención y pesos de ranking de memoria, y
  puntajes mínimos de rúbrica "ready" no tienen valores; la spec original no aporta números.
- **Decisión** (v0, configurables en política de proyecto; ADR-007 fija la línea base de los demás):
  - **`max_cost` por tipo de tarea** (USD por ejecución de tarea): `documentation` 0.10, `test` 0.25,
    `bug` 0.50, `research` 0.50, `security` 0.50, `maintenance` 0.50, `architecture` 0.75,
    `feature` 1.00, `refactor` 1.00; sistema complejo se presupuesta como `feature` ampliado (2.00).
  - **TTL por clase de retención** (memoria, ADR-008): `EPHEMERAL` → fin de ejecución (ya vigente);
    `WORKING` 1 día; `EXECUTION` 7 días; `TASK` 30 días; `PROJECT` 90 días; `AGENT` 180 días;
    `KNOWLEDGE` 365 días; `AUDIT` inmutable + 365 días.
  - **Pesos de ranking**: `relevance` 0.30, `confidence` 0.20, `importance` 0.20, `recency` 0.15,
    `source_quality` 0.10, `scope_match` 0.05 (suman 1.00).
  - **Rúbrica "ready"** (escala 0-3): mínimo por dimensión ≥ 2; score compuesto por rol ≥ 2.0; ninguna
    dimensión < 1; el resultado se registra con evidencia por dimensión.
- **Consecuencias**: presupuestos y ranking ejecutables; evaluación de agentes determinista; se cierran
  las pendientes de `03-tasks.md`, `07-memory.md` y `08-quality-evaluation.md`.

## ADR-021 — Semántica de ejecución del workflow v0

- **Problema**: tres taxonomías de tipo de tarea sin reconciliar (routing `04-workflows`, matriz de
  gates `08-quality-evaluation` con 6 tipos, intake de `docs/13-orchestration` con 9); la paralelización
  no tiene límite numérico; los checkpoints no tienen backend de persistencia (el runtime hermano los
  mantiene en memoria).
- **Decisión**:
  - **Taxonomía canónica de tipos de tarea** (9): `documentation | bug | feature | refactor | test |
    research | architecture | security | maintenance`. La matriz de gates G1-G6 y los presupuestos
    (ADR-020) se expresan sobre esta taxonomía; los tipos de la matriz existente son un subconjunto
    (`Documentation, Bug Fix, Feature, Architecture, Security, Refactor` → mapeo 1:1).
  - **Paralelización**: `max_concurrent_agents: 4` por defecto (configurable); paralelismo solo para
    tareas independientes; en el MVP, análisis read-only en paralelo y **nunca** escritura concurrente
    en el mismo workspace (véase ADR-008 aislamiento); el límite se enforced en el runtime.
  - **Persistencia de checkpoints**: backend MVP archivos JSON por tarea en `runtime/checkpoints/`
    (git-ignored), consistente con ADR-008; el checkpoint incluye estado de tarea, etapa, rework counts
    y artifact refs; resume entre ejecuciones; SQLite opcional posterior.
- **Consecuencias**: una sola taxonomía para routing, gates y presupuestos; concurrencia acotada y
  enforced; recuperación real entre ejecuciones; se cierra la pendiente de `01-architecture.md` y la
  matriz stale de esa tabla.

## ADR-022 — Materialización OpenCode del roster

- **Problema**: las temperatures de la plantilla canónica quedaron elegidas sin base normativa; la
  activación del agente `security` depende de `security_sensitive` pero nadie define quién lo setea; el
  adaptador Gentle-AI lista capacidades sin verificación.
- **Decisión**:
  - **Temperatures canónicas** (determinismo sobre creatividad): `analyst` 0.2, `architect` 0.2,
    `researcher` 0.3 (única mayor: investigación divergente), `developer` 0.2, `tester` 0.2,
    `reviewer` 0.1, `security` 0.1. Configurables por proyecto; el default de la plantilla es este.
  - **Activación de `security`**: `security_sensitive` se determina en el **intake** (clasificación
    de la tarea por el orquestador): es `true` si el tipo de tarea es `security`, o si el análisis
    identifica exposición de secretos, superficie de ataque, dependencias o datos sensibles; default
    `false`; el humano puede forzarlo. Materialización operativa: el orquestador decide la inclusión
    del agente en la ruta según el flag (no depende de una clave nativa del runtime).
  - **Gentle-AI**: capacidades verificadas adoptadas por ADR-011: **routing de modelos, gestión de
    agentes, evaluación**. Integración exclusivamente vía adaptador; ausencia degrada sin romper; la
    integración real queda fuera de v0 (mejora de última fase).
- **Consecuencias**: comportamiento determinista de los agentes en la plantilla; activación de security
  decidida por clasificación, no por disponibilidad; Gentle-AI sin deuda técnica.

## ADR-023 — Roadmap: ejecución de fases y alineación del runtime

- **Problema**: el roadmap define el orden canónico de fases sin decidir si se ejecutan en serie o con
  solapamiento; la alineación formal del runtime TS/Node (`agent-system`) con los contratos no está
  confirmada.
- **Decisión**:
  - **Fases en serie por defecto**: cada fase desbloquea la siguiente (criterio de corte: dependencias
    del roadmap). Solapamiento controlado permitido solo para trabajo read-only/independiente, con
    aprobación explícita del orquestador y sin compartir workspace de escritura.
  - **Alineación del runtime**: se confirma **parcial** con evidencia. La matriz de permisos ADR-009
    (Default Deny, niveles, grants temporales) está implementada y enforced en la capa de runtime/tool;
    la matriz de gates es idéntica. Desviaciones a cerrar como backlog del roadmap: `max_duration`
    ausente (config lo tiene en 0 = ilimitado), cobertura 80% y p95 < 120 s ausentes, timeout de paso
    default 300 s (debe ser 30 s, ADR-007), `max_attempts` mezclado 2/3 por stage (debe ser default 3
    central), `max_concurrent_agents` configurado pero no enforced, workflows faltantes (architecture/
    security/documentation), ASK/DENY por categoría de riesgo no modelado, checkpoints en memoria (deben
    persistirse según ADR-021).
- **Consecuencias**: ejecución predecible del roadmap; la alineación formal queda como requisito de
  fase con desviaciones explícitas, no como bloqueante del framework.

---

## Directrices de aplicación

1. **Los documentos del framework usan estos ADR como base normativa.** Citar el ADR en cada sección
   que materialice una decisión (`véase ADR-00X`).
2. **Configuraciones generadas** (OpenCode, permisos, gates) derivan de estos ADR sin reinterpretación.
3. **Cambios de decisión**: nueva ADR, nunca edición silenciosa. Una ADR solo se marca `SUPERSEDED`
   por otra ADR explícita.
4. **Vigencia**: este registro es la fuente de verdad del framework. La especificación `docs/01-19`
   queda como material de origen y contexto; las discrepancias se resuelven por este registro.
