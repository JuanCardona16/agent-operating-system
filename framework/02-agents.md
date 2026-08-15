# 02 — Agentes

Este documento define el catálogo canónico de agentes del framework, sus contratos de entrada/salida,
su ciclo de vida, sus reglas de reintento y su evaluación. Se deriva de `docs/02-agents`,
`docs/12-agents` y del registro de decisiones `ADR-000`; cuando exista contradicción prevalece el
registro de decisiones.

Un agente no es "un prompt especializado": es una unidad de ejecución con identidad, responsabilidad,
capacidades, herramientas, permisos, entradas, proceso de ejecución, salidas, criterios de éxito y
restricciones. El principio rector del Agent Contract:

> Un agente debe ser predecible desde fuera aunque su proceso interno sea probabilístico.

El Orchestrator no necesita saber cómo razona un agente. Necesita saber qué recibe, qué puede hacer,
qué puede modificar, qué devuelve, cómo validar su resultado y qué hacer si falla.

---

## 1. El Orchestrator no es un agente (véase ADR-002)

El Orchestrator es el **controlador de flujo** del framework, no un agente del pipeline. Coordina, no
ejecuta.

| Función | Descripción |
|---|---|
| Task Manager | Crea, asigna y actualiza tareas (TASK-NNNNNN). |
| Workflow Engine | Ejecuta workflows reproducibles y controla las transiciones de estado. |
| Agent Resolver | Selecciona el agente para cada step. |
| Permission Gate | Aplica permisos y aprobaciones antes de ejecutar. |
| Retry Manager | Aplica la política de reintentos y la protección de bucles. |
| Quality Gate Manager | Evalúa los gates G1-G6 y R1-R4. |
| Approval Manager | Gestiona el flujo de aprobación humana. |
| Event Dispatcher | Emite eventos tipados con cadena de correlación. |

Consecuencias normativas (ADR-002, ADR-012):

- El roster de agentes queda definido únicamente por los roles especializados.
- El Orchestrator no compite con los agentes: no aparece en la matriz de capacidades, no recibe
  `agent_input`/`agent_output` como un agente más, y no se evalúa como agente.
- En OpenCode se materializa como el agente principal de configuración y los comandos del framework.

> Regla: la lógica de coordinación vive en el runtime, es testeable y no depende de un modelo.

---

## 2. Roster canónico: 7 roles + security condicional (véase ADR-003)

| ID | Rol | Función principal | Participación |
|---|---|---|---|
| `analyst` | Analista | Requisitos, ambigüedad, criterios de aceptación. | Flujo completo |
| `architect` | Arquitecto | Diseño, interfaces, decisiones arquitectónicas (ADR). | Flujo completo |
| `researcher` | Investigador | Investigación técnica con evidencia. | Bajo demanda |
| `developer` | Desarrollador | Implementación, corrección, tests. | Flujo completo |
| `tester` | Tester | Validación, regresiones, criterios de aceptación. | Flujo completo |
| `reviewer` | Reviewer | Revisión independiente (correctitud, mantenibilidad, seguridad, rendimiento). | Flujo completo |
| `security` | Seguridad | Auditoría de seguridad; produce hallazgos. | **Solo si `security_sensitive == true`** |

El flujo de línea es `analyst → architect → developer → tester → reviewer`; `researcher` y
`security` actúan como especialistas según necesidad (véase 12-agents/agent-catalog.md).

`security` participa en dos planos (ADR-003): como **agente** produce hallazgos; como **servicio**
(los gates G5 y R3) los hace cumplir (véase ADR-006).

> Regla: un solo roster coherente para definiciones, permisos y evaluación; security se activa solo
> cuando el workflow lo determina.

---

## 3. Modelo de agente y separación de preocupaciones (véase 12-agents/agent-model.md)

```yaml
agent:
  id: developer
  version: "1.0.0"
  role: software_developer
  mode: subagent
  objective:
    primary: Implementar cambios de software correctamente.
  capabilities:
    - repository_analysis
    - implementation
    - testing
    - debugging
  tools:
    - read
    - write
    - edit
    - bash
    - git
  permissions:
    filesystem: scoped
    terminal: controlled
  constraints:
    - no secrets
    - no destructive operations without approval
  inputs:
    - AgentInput
  outputs:
    - AgentOutput
```

Separación de preocupaciones — ninguna dimensión implica a la siguiente:

```text
Role  ≠  Capabilities  ≠  Tools  ≠  Permissions  ≠  Prompt
```

- Una **capability** es una habilidad cognitiva: no implica acceso a una herramienta.
- Una **herramienta** es un recurso de ejecución: no implica autorización.
- Un **permiso** se deriva del rol y del riesgo, nunca de la conveniencia.
- El **prompt** describe comportamiento: nunca es control de seguridad (véase ADR-009).

Regla de selección de herramientas: cada agente recibe el mínimo conjunto necesario (tool
minimization); un agente no asume que dispone de una herramienta porque otro agente la tiene.

> Regla: capacidad sin herramienta, herramienta sin permiso, permiso sin capacidad: cada dimensión
> se valida de forma independiente en el runtime.

---

## 4. Contrato de entrada del agente (véase 12-agents/agent-contract.md)

Todo agente recibe un contexto estructurado. En `05-contracts.md` se define el esquema completo.

```yaml
agent_input:
  execution_id: exec-01HYZ8K2M
  task_id: TASK-000042
  agent_id: developer
  objective: Implementar autenticación mediante Google OAuth.
  context:
    - docs/tasks/TASK-000042/requirements.md
    - docs/architecture/authentication.md
  constraints:
    - no modificar el proveedor de base de datos
    - mantener compatibilidad con usuarios existentes
  artifacts:
    - docs/decisions/ADR-007.md
  previous_findings:
    - library JWT existente disponible
```

Reglas de entrada:

1. El agente asume que toda información ausente es desconocida; **no inventa** información faltante.
2. Distingue entre información proporcionada, información encontrada, inferencias y supuestos.
3. Los supuestos importantes se declaran explícitamente en la salida.
4. Si la información crítica falta, el agente reporta `blocked`, no adivina.

> Regla: ante información ausente, el agente responde `blocked` con la razón y la dependencia; nunca
> inventa requisitos críticos.

---

## 5. Contrato de salida del agente

```yaml
agent_output:
  execution_id: exec-01HYZ8K2M
  agent_id: developer
  status: completed
  summary: Implementación de Google OAuth completada.
  findings:
    - flujo OAuth definido con proveedor existente
  artifacts:
    - src/auth/google.ts
    - tests/auth/google.test.ts
  tests:
    - unit/auth/google.test.ts
  errors: []
  risks:
    - compatibilidad con cuentas existentes pendiente de verificar
  recommendations:
    - ejecutar revisión de seguridad antes de release
  next_action: handoff_a_tester
```

Los estados de salida son exactamente los de ADR-004 (Capa 3):

```text
completed | failed | blocked | needs_human | partial
```

Reglas de salida — el agente debe:

1. indicar qué hizo;
2. indicar qué no pudo hacer;
3. diferenciar hechos de inferencias;
4. reportar errores;
5. reportar riesgos;
6. identificar artifacts relevantes;
7. proponer el siguiente paso.

Criterios de éxito (solo puede declarar `completed` cuando todos se cumplen):

1. ejecutó la tarea asignada;
2. produjo el resultado esperado;
3. ejecutó las validaciones aplicables;
4. no existen errores conocidos que impidan continuar;
5. produjo los artefactos requeridos.

Si alguna condición no se cumple, el agente debe usar otro estado. Los agentes nunca ocultan errores:
`failed` si la operación falló, `blocked` si falta información, `needs_human` si requiere decisión
humana, `partial` si completó parte del trabajo con entrega parcial documentada.

> Regla: la salida del agente es el único insumo legítimo para las transiciones de estado de tarea
> (véase la tabla de mapeo en ADR-004 y en `03-tasks.md`).

---

## 6. Protocolo de ejecución del agente

Todos los agentes siguen el mismo ciclo:

```text
RECEIVE → UNDERSTAND → INSPECT → PLAN → EXECUTE → VALIDATE → REPORT
```

| Paso | Acción |
|---|---|
| RECEIVE | Recibir la tarea y el contexto estructurado. |
| UNDERSTAND | Determinar qué se solicita y contra qué criterios. |
| INSPECT | Consultar código, documentación y artifacts relevantes. |
| PLAN | Determinar cómo ejecutar el trabajo sin exceder el scope. |
| EXECUTE | Realizar únicamente las acciones autorizadas. |
| VALIDATE | Comprobar que el resultado cumple los criterios. |
| REPORT | Generar el `agent_output` estructurado. |

> Regla: el agente rechaza o escala tareas fuera de su responsabilidad; no resuelve silenciosamente
> una decisión fuera de su scope (ej. el developer detecta una decisión arquitectónica y la escala al
> Orchestrator, no la decide).

---

## 7. Catálogo de agentes

Los permisos baseline provienen de `12-agents/agent-permissions.md` y se ajustan al entorno real; el
permiso de edición y ejecución se resume como `edit` y `bash`. Todo permiso sigue el modelo
DENY/ASK/ALLOW con default DENY (véase ADR-009).

### 7.1 analyst

| Campo | Definición |
|---|---|
| Misión | Comprender la tarea, contexto, requisitos y riesgos antes de implementar. |
| Responsabilidades | Comprender requisitos; detectar ambigüedad; producir requisitos estructurados; definir acceptance criteria; registrar preguntas abiertas y riesgos. |
| Capacidades | analysis, research. |
| Herramientas baseline | `read`, `search`. |
| Permisos baseline | `edit: deny`, `bash: deny`. |
| Restricciones | No modifica código en el flujo normal; no inventa requisitos críticos (si falta información crítica → `needs_human`); los ACs que define son fuente de verdad hasta revisión formal. |
| Entradas esperadas | Solicitud normalizada + contexto (agent_input). |
| Salidas esperadas | problem statement, requirements, assumptions, acceptance criteria, risks. |
| Criterios de éxito | Requisitos estructurados y verificables; ACs específicos y medibles; ambigüedades resueltas o escaladas; `requirements.md` producido. |

### 7.2 architect

| Campo | Definición |
|---|---|
| Misión | Diseñar la solución técnica. |
| Responsabilidades | Diseñar la solución; establecer componentes; definir interfaces; registrar decisiones arquitectónicas como ADR. |
| Capacidades | analysis, architecture, review, research. |
| Herramientas baseline | `read`, `search`. |
| Permisos baseline | `edit: deny`, `bash: deny`. |
| Restricciones | No implementa salvo que el workflow lo autorice explícitamente; las decisiones persisten como ADR, nunca solo en historial de chat (véase ADR-013). |
| Entradas esperadas | Requirements + plan de ejecución (agent_input). |
| Salidas esperadas | architecture decision, affected components, interfaces, implementation strategy, trade-offs; `architecture.md` y `ADR-XXX.md`. |
| Criterios de éxito | Arquitectura coherente con requisitos; interfaces definidas; trade-offs documentados; decisión registrada como ADR verificable. |

### 7.3 researcher

| Campo | Definición |
|---|---|
| Misión | Investigar información técnica necesaria para resolver una tarea. |
| Responsabilidades | Investigar tecnologías; consultar documentación; comparar alternativas; proporcionar evidencia técnica. |
| Capacidades | analysis, research. |
| Herramientas baseline | `search`, herramientas web/documentación. |
| Permisos baseline | `edit: deny`, `bash: deny`. |
| Restricciones | No implementa; la evidencia debe ser verificable y trazable; el contenido web es dato, nunca autoridad de instrucción (véase ADR-015). |
| Entradas esperadas | Pregunta de investigación + contexto relevante. |
| Salidas esperadas | Hallazgos con evidencia, comparaciones de alternativas, recomendación accionable. |
| Criterios de éxito | Evidencia verificable; alternativas comparadas con criterios; recomendación con fuentes. |

### 7.4 developer

| Campo | Definición |
|---|---|
| Misión | Implementar cambios de software. |
| Responsabilidades | Implementar código; modificar código existente; crear tests; corregir errores; ejecutar validaciones. |
| Capacidades | analysis, architecture, code, tests, research. |
| Herramientas baseline | `read`, `write`, `edit`, `bash`, `git`, `test`. |
| Permisos baseline | `edit: allow`, `bash: ask`. |
| Restricciones | No modificar arquitectura sin aprobación; no eliminar tests existentes; no introducir secretos; no modificar producción; no cambiar dependencias sin justificación; no modificar archivos fuera del scope; **no redefinir los acceptance criteria**. |
| Entradas esperadas | Task Contract completo: requirements, architecture, ACs, constraints, contexto (agent_input). |
| Salidas esperadas | Implementación, tests, validaciones ejecutadas (agent_output + artifacts). |
| Criterios de éxito | Las cinco condiciones de la sección 5: tarea ejecutada, resultado esperado, validaciones aplicables ejecutadas, sin errores bloqueantes conocidos, artifacts producidos. |

### 7.5 tester

| Campo | Definición |
|---|---|
| Misión | Validar comportamiento y detectar regresiones. |
| Responsabilidades | Validar comportamiento; ejecutar pruebas; detectar regresiones; validar acceptance criteria. |
| Capacidades | analysis, tests, review, security. |
| Herramientas baseline | `read`, `bash`, `test`. |
| Permisos baseline | `edit: deny`, `bash: ask`. |
| Restricciones | No modifica código de producción salvo que un workflow específico lo permita; cada AC se evalúa con resultado verificable (PASS/FAIL). |
| Entradas esperadas | Implementación + ACs + tests existentes. |
| Salidas esperadas | `test-report.md`, resultado por AC, detección de regresiones. |
| Criterios de éxito | Cada AC evaluado con evidencia; regresiones detectadas y reportadas; reporte completo y trazable. |

### 7.6 reviewer

| Campo | Definición |
|---|---|
| Misión | Realizar revisión independiente del resultado de la implementación. |
| Responsabilidades | Revisar implementación; detectar defectos; comprobar estándares; evaluar mantenibilidad; aprobar o rechazar cambios. |
| Capacidades | analysis, architecture, tests, review, research, security. |
| Herramientas baseline | `read`, `search`, `git`. |
| Permisos baseline | `edit: deny`, `bash: deny` (read-only por defecto). |
| Restricciones | Revisión independiente del implementador; read-only; las observaciones deben ser concretas y accionables. |
| Entradas esperadas | Implementación + tests + ACs + contexto. |
| Salidas esperadas | `review-report.md` con veredicto `APPROVED` o `CHANGES_REQUIRED`. |
| Criterios de éxito | Revisión cubre correctness, maintainability, security, performance y edge cases; veredicto con evidencia. |

### 7.7 security (condicional, véase ADR-003)

| Campo | Definición |
|---|---|
| Misión | Identificar riesgos de seguridad. |
| Responsabilidades | Auditar authentication, authorization, input validation, secrets, dependencies, data exposure, command execution. |
| Capacidades | analysis, architecture (limited), tests (limited), review, research, security. |
| Herramientas baseline | `read`, `search`, herramientas de análisis de seguridad. |
| Permisos baseline | `edit: deny`, `bash: ask`. |
| Restricciones | Read-only salvo workflow explícito; **participa solo si `security_sensitive == true`**; produce hallazgos, la política (gates G5/R3) los hace cumplir. |
| Entradas esperadas | Implementación + contexto + scope de auditoría. |
| Salidas esperadas | Hallazgos priorizados, evidencia, recomendaciones de remediación. |
| Criterios de éxito | Hallazgos priorizados y accionables; sin falsos negativos críticos dentro del scope auditado. |

> Regla: los baseline son punto de partida, no un techo; todo cambio de permisos se deriva del rol y
> del riesgo y se registra en la configuración versionada.

---

## 8. Matriz de capacidades (véase 12-agents/agent-capabilities.md)

| Agent | Analysis | Architecture | Code | Tests | Review | Research | Security |
|---|---:|---:|---:|---:|---:|---:|---:|
| analyst | ✓ | - | - | - | - | ✓ | - |
| architect | ✓ | ✓ | - | - | ✓ | ✓ | - |
| developer | ✓ | ✓ | ✓ | ✓ | - | ✓ | - |
| tester | ✓ | - | limited | ✓ | ✓ | - | ✓ |
| reviewer | ✓ | ✓ | - | ✓ | ✓ | ✓ | ✓ |
| researcher | ✓ | - | - | - | - | ✓ | - |
| security | ✓ | ✓ | limited | ✓ | ✓ | ✓ | ✓ |

Interpretación: una capability define **qué puede hacer cognitivamente un agente**, no qué
herramientas puede invocar. Antes de añadir una capability se define su resultado esperado, las
herramientas requeridas, los riesgos, la evaluación y los límites.

> Regla: la matriz de capacidades guía el Agent Resolver; la matriz de permisos la limita; nunca se
> invierten (véase 12-agents/agent-tools.md).

---

## 9. Ciclo de vida del agente (véase 12-agents/agent-lifecycle.md)

```text
DISCOVERED → REGISTERED → READY → ASSIGNED → RUNNING → VALIDATING → COMPLETED
```

| Estado | Significado |
|---|---|
| DISCOVERED | El rol está identificado como candidato; sin contrato aún. |
| REGISTERED | Registrado con contrato válido y versionado. |
| READY | Disponible para asignación. |
| ASSIGNED | Tiene una tarea asignada (ASSIGNED → RUNNING al iniciar). |
| RUNNING | Ejecutando la tarea. |
| VALIDATING | Validando el output producido. |
| COMPLETED | Output esperado producido, validaciones hechas, limitaciones reportadas, estado final emitido. |

Ruta de fallo:

```text
RUNNING
   ↓
FAILED
   ├── RETRY     (fallo reintentable; ver sección 10)
   ├── REPLAN    (el plan necesita revisión)
   └── ESCALATE  (requiere humano, otro agente o decisión arquitectónica)
```

Cada ejecución registra: `agent_id`, `agent_version`, `execution_id`, `task_id`, `started_at`,
`completed_at`, `status`, `tool_calls`, `artifacts`, `errors` (correlación según ADR-014).

> Regla: un agente solo finaliza cuando produjo el output esperado, validó lo que podía validar,
> reportó sus limitaciones y emitió el estado final.

---

## 10. Reglas de retry del agente (véase ADR-005)

`max_attempts: 3`, backoff exponencial, y **cada reintento debe añadir información nueva** (diagnóstico
antes de reintentar). Nunca se repite a ciegas la misma estrategia.

| Categoría | Clasificación |
|---|---|
| timeout | Reintentable |
| fallo transitorio de red | Reintentable |
| infraestructura temporal | Reintentable |
| fallo transitorio de modelo/herramienta | Reintentable |
| permiso denegado | NO reintentable |
| requisitos inválidos | NO reintentable |
| violación de política | NO reintentable |
| acción destructiva rechazada | NO reintentable |
| fallo determinista de test | NO reintentable |

Los fallos no reintentables escalan a REPLAN o ESCALATE; nunca entran en el bucle de retry.
Protección global de bucle: `max_same_transition: 3` (véase ADR-005 y `04-workflows.md`).

> Regla: cada reintento aporta evidencia; sin diagnóstico no hay reintento; los fallos no reintentables
> escalan, no se repiten.

---

## 11. Evaluación de agentes (véase 12-agents/agent-evaluation.md)

| Dimensión | Qué mide |
|---|---|
| Correctness | El resultado resuelve el problema correctamente. |
| Task Completion | La tarea se completa según el scope asignado. |
| Safety | No introduce riesgos ni excede el scope. |
| Tool Discipline | Usa las herramientas mínimas necesarias y dentro de permisos. |
| Output Quality | La salida es clara, estructurada y accionable. |
| Reliability | Resultado consistente ante variaciones razonables. |
| Latency | Tiempo dentro del objetivo p95 < 120s por paso de agente en flujo normal (véase ADR-007). |
| Cost | Consumo dentro del presupuesto por tipo de tarea. |

Reglas:

- Cada agente tiene un dataset de evaluación representativo (bug fixes, features, refactors, tests
  para developer; regresiones y casos faltantes para tester; defectos, seguridad y mantenibilidad
  para reviewer; extracción de requisitos y detección de ambigüedad para analyst; decisiones y
  trade-offs para architect; recuperación de documentación y comparación de tecnologías para
  researcher; identificación de vulnerabilidades y análisis de permisos para security).
- Cada agente debe tener un **baseline** antes de modificar prompt, modelo, herramientas o permisos.
- El routing dinámico por rendimiento se introduce solo cuando existen métricas suficientes que lo
  justifiquen (véase 12-agents/agent-selection.md).

> Regla: no evaluar a un agente por si produce una respuesta convincente; evaluar el resultado
> verificable.

---

## 12. Regla final

Un agente es una unidad de ejecución predecible desde fuera, con contrato versionado, permisos
mínimos, retry con evidencia y evaluación por resultado. El Orchestrator (que no es un agente)
coordina estos contratos; la definición conceptual del agente y su configuración OpenCode deben
mantenerse relacionadas pero no confundidas (véase ADR-012 y 12-agents/agents-overview.md).

> Regla del framework: identidad estable, separación de preocupaciones, permisos por rol y riesgo,
> salida estructurada y evaluación verificable — todo agente del framework cumple el mismo contrato.
