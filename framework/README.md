# Marco de Trabajo (Framework) del Sistema Multiagente — Índice

## Propósito

Este framework es el **marco único de trabajo (source of truth operativo)** del sistema multiagente de ingeniería de software. Consolida la especificación original `docs/01-19` (223 archivos, 19 dominios) en documentos normativos, un registro de decisiones y configuraciones derivadas que se materializan sobre OpenCode. Ayuda a implementadores y operadores a construir y operar el sistema sin reinterpretar dominios dispersos ni resolver contradicciones sobre la marcha; existe porque la especificación original contiene contradicciones y lagunas que solo pueden resolverse con decisiones explícitas, versionadas y trazables.

Cuando un documento de `docs/01-19` contradiga este framework, **prevalece este framework**; las discrepancias se resuelven por el registro de decisiones `decisions/ADR-000-registro-decisiones.md` (véase ADR-000).

## Quick path — cómo usar el framework

1. **Leer en orden** para formar el modelo mental completo:
   1. `00-principles.md` — los 14 principios normativos que sobreviven a la consolidación.
   2. `01-architecture.md` — capas, orchestrator, flujo maestro, workflow engine y estados.
   3. `decisions/ADR-000-registro-decisiones.md` — el registro normativo (ADR-001 a ADR-015).
   4. Según la tarea: `02-agents` (roster), `03-tasks` (estados y presupuestos), `04-workflows` (YAML), `05-contracts` (esquemas formales), `06-permissions-security` (permisos), `07-memory` (memoria), `08-quality-evaluation` (gates), `09-observability` (correlación), `10-operations` (costos), `11-opencode-configuration` (configuración concreta), `12-roadmap` (orden de construcción).
2. **Derivar la configuración de OpenCode**: la configuración versionada (`opencode.json` + `AGENTS.md` + agentes `.md` + comandos) se genera a partir de estos documentos sin reinterpretación (véase ADR-012, ADR-002). Cada documento 02-12 define la sección de configuración que le corresponde; los ADR son la base normativa de cada valor.
3. **Verificar**: todo umbral y valor concreto proviene de ADR-007. Si algo parece contradictorio, resolver por ADR-000 — nunca por comportamiento implícito.

> **Regla**: el framework es la única fuente de verdad operativa; la especificación original es material de origen y contexto. Ante discrepancia, decide ADR-000.

## Mapa de documentos

| Doc | Título | Propósito (una línea) | Estado |
|-----|--------|------------------------|--------|
| 00 | Principios | Los 14 principios normativos y citas que gobiernan todo documento y configuración. | Escrito |
| 01 | Arquitectura | Capas, orchestrator como mecanismo, flujo maestro, workflow engine y máquina de estados. | Escrito |
| 02 | Agentes | Roster definitivo (7 roles + Security condicional), contratos y definiciones de agente. | Escrito |
| 03 | Tareas | Modelo de tarea, estados canónicos (ADR-004), presupuestos (ADR-007) y acceptance criteria. | Escrito |
| 04 | Workflows | Workflow de 8 etapas, delegación, handoffs, fallos, aprobación humana y retry (ADR-005, ADR-010, ADR-013). | Escrito |
| 05 | Contratos | Referencia canónica de esquemas YAML: task, agent input/output, handoff, tool, gate, artifact, approval, failure, event. | Escrito |
| 06 | Permisos y Seguridad | Cadena AGENT→CAPABILITY→TOOL→PERMISSION→RESOURCE→ACTION, niveles y riesgo (ADR-009), tool registry, seguridad y jerarquía de confianza (ADR-015). | Escrito |
| 07 | Memoria | Capas, tipos de contenido, confianza, retención, retrieval y evaluación de memoria (ADR-008). | Escrito |
| 08 | Calidad y Evaluación | Quality gates G1-G6 + gates de release R1-R4, matriz por tipo de tarea, testing, review y evaluación (ADR-006, ADR-007). | Escrito |
| 09 | Observabilidad | Cadena de correlación, eventos tipados, métricas, audit y redacción de secretos (ADR-014). | Escrito |
| 10 | Operaciones | Fallos, reintentos, checkpoints, model routing, costos y presupuestos (ADR-005, ADR-007). | Escrito |
| 11 | Configuración OpenCode | Materialización concreta: `opencode.json`, agentes `.md`, comandos, permisos y bootstrap (ADR-012). | Escrito |
| 12 | Roadmap | Orden de construcción (fases y milestones), camino crítico, autonomía L0-L4 y Definition of Done. | Escrito |
| 13 | Documentación del Proyecto | Estructura canónica de `docs/` del proyecto, lectura obligatoria y mantenimiento por agentes (ADR-016). | Escrito |

> **Regla**: un documento del framework se escribe solo cuando materializa uno o más ADR; nunca añade decisiones nuevas.

## Cómo se relaciona con la especificación original

| Dominio original | Contenido | Se consolida en | Resuelto por |
|---|---|---|---|
| 01-system | Visión, principios, alcance | `00`, `01` | — |
| 02-agents / 12-agents | Definiciones de agentes (roster inconsistente) | `02` | ADR-003 |
| 03-tasks | Modelo y ciclo de vida de tareas | `03` | ADR-004 |
| 04-workflows | Flujos, handoffs, fallos, aprobación | `04`, `05` | ADR-005, ADR-010, ADR-013 |
| 05-tools | Herramientas y permisos (git-strategy vacío en origen) | `06` | ADR-009 |
| 06-memory / 14-memory | Dos generaciones de memoria | `07` | ADR-008 |
| 07-quality / 15-evaluation | Gates y evaluación | `08` | ADR-006 |
| 08-operations | Operación, métricas y costos | `09`, `10` | ADR-007, ADR-014 |
| 09-implementation | Runtime, entorno, OpenCode, Gentle-AI | `01`, `11` | ADR-011, ADR-012 |
| 10-roadmap | Evolución y fases | `12` | — |
| 11-foundation | Contracts, runtime, tools, eventos | `01`, `05`, `09` | — |
| 13-orchestration | Orchestrator y workflow engine | `01`, `04`, `05` | ADR-002 |
| 16-observability | Eventos, trazas, métricas, audit | `09` | ADR-014 |
| 17-security | Seguridad, permisos, confianza, incidentes | `06` | ADR-009, ADR-015 |
| 18-opencode-integration | Mapeo a OpenCode, comandos, modelos | `11` | ADR-012 |
| 19-runtime | Runtime MVP, agentes por rol, validación | `01`, `11` | ADR-012 |

Los dominios restantes de `docs/01-19` se consolidan bajo el mismo criterio: un documento de framework, con ADR explícita cuando exista contradicción.

> **Regla**: la spec original no desaparece — queda como origen y contexto; su autoridad se delega a este framework y a ADR-000.

## Decisiones

Registro normativo: [`decisions/ADR-000-registro-decisiones.md`](decisions/ADR-000-registro-decisiones.md).

| ADR | Decisión (esencia) |
|-----|---------------------|
| ADR-001 | Idioma de artefactos: español neutral-profesional; identificadores técnicos en inglés. |
| ADR-002 | Orchestrator es mecanismo de control (task manager, workflow engine, resolver, gates), no agente del pipeline. |
| ADR-003 | Roster definitivo: 7 roles (`analyst`, `architect`, `researcher`, `developer`, `tester`, `reviewer`, `security`) con Security condicional. |
| ADR-004 | Máquina de estados unificada en tres capas mapeadas (tarea / ejecución / salida de agente). |
| ADR-005 | Reintentos: `max_attempts: 3`, backoff exponencial, clasificación obligatoria antes de reintentar, `max_same_transition: 3`. |
| ADR-006 | Quality gates: G1-G6 de tarea + R1-R4 de release; bypass solo con aprobación humana registrada. |
| ADR-007 | Umbrales por defecto (v0) con valores concretos: timeouts, cobertura 80%, latencia p95 < 120s, etc. |
| ADR-008 | Modelo de memoria unificado: 7 capas, 8 tipos de contenido, confianza e importancia, 6 escalas. |
| ADR-009 | Permisos: cadena AGENT→CAPABILITY→TOOL→PERMISSION→RESOURCE→ACTION; niveles NONE/READ/WRITE/EXECUTE/ADMIN; default DENY por riesgo. |
| ADR-010 | Contrato de aprobación humana: REQUEST → WAITING_APPROVAL → APPROVE \| REJECT \| REQUEST_CHANGES; silencio ≠ autorización. |
| ADR-011 | Gentle-AI como capa opcional vía adaptador; su ausencia degrada sin romper. |
| ADR-012 | OpenCode es el runtime de ejecución; el framework es configuración versionada + contrato de agentes. |
| ADR-013 | Comunicación por artefactos verificables con provenance (`execution_id, agent_id, created_at, checksum`). |
| ADR-014 | Observabilidad: cadena de correlación única, eventos tipados, audit append-only sin secretos. |
| ADR-015 | Seguridad: jerarquía de confianza; contenido no confiable = datos, no autoridad. |

> **Regla**: ningún documento ni configuración reinterpreta un ADR; si se necesita cambiar la decisión, se registra una ADR nueva.

## Distribución en proyectos reales

Este framework se instala en cualquier proyecto nuevo de OpenCode con el paquete de distribución `../templates/` (véase `templates/README.md`):

1. **Skill global `framework-orchestrator`** (instalada en `~/.agents/skills/`): conocimiento del orquestador disponible en todos los proyectos; se carga bajo demanda cuando se delegan tareas.
2. **Comando global `/framework-init`** (instalado en `~/.config/opencode/commands/`): materializa la plantilla en el proyecto actual.
3. **`bootstrap.ps1`**: copia `opencode.json`, `AGENTS.md`, `.opencode/agents/*.md` (los 7 roles del roster) y `.opencode/commands/*.md` (los 8 comandos del framework), sustituyendo placeholders y con backup automático de archivos existentes.
4. **`references.framework`**: cada proyecto referencia este directorio como fuente normativa de consulta (sin duplicar documentación).

El framework permanece como fuente de verdad única; los proyectos contienen solo la configuración ejecutable y una referencia.

## Convenciones

- **Idioma y estilo**: español neutral-profesional en todo artefacto; identificadores técnicos, IDs, tokens de estado y comandos en inglés (véase ADR-001). Identificadores explícitos (`execution_id`, `agent_id`, `task_id`); se evitan nombres ambiguos como `id`, `data` o `context` (véase `docs/11-foundation/development-conventions.md`).
- **Formato**: Markdown jerárquico; tablas para contratos y matrices; bloques YAML/JSON para esquemas; cada sección clave cierra con su "Regla" en blockquote.
- **Citas**: cada documento cita los ADR que materializa como `(véase ADR-00X)`. Las configuraciones generadas derivan de los ADR sin reinterpretación.
- **Ciclo de vida de ADR**: una decisión nueva o modificada es una ADR nueva; nunca una edición silenciosa. Una ADR se marca `SUPERSEDED` solo por otra ADR explícita (véase ADR-000, directrices 1-3).
- **Pendientes**: lo genuinamente abierto se marca `DECISIÓN PENDIENTE` explícitamente; nunca se resuelve en silencio.
- **Sin emojis** en ningún documento o artefacto.

> **Regla**: la consistencia del marco no se negocia por comodidad puntual; una excepción requiere ADR, no silencio.
