# 08 — Calidad y Evaluación

## Propósito

Este documento define el modelo de calidad del sistema multiagente en dos planos: (1) la calidad del software producido, garantizada por los quality gates y la validación (véase ADR-006); y (2) la evaluación de agentes, workflows y del sistema completo (véase `docs/15-evaluation` como material de origen). Los umbrales concretos provienen de ADR-007 y son configurables por política.

Principio rector: **la calidad no depende de la opinión de un único agente**; se evalúa con señales independientes (requisitos, acceptance criteria, tests, análisis estático, revisión, seguridad). Un agente no está listo porque "parezca inteligente": está listo cuando supera criterios verificables de calidad, seguridad y confiabilidad.

> Regla: una afirmación de calidad debe estar respaldada por evidencia siempre que sea posible.

## Modelo de calidad

### Dimensiones

| Dimensión | Qué valida | Cuándo aplica |
|---|---|---|
| Correctness | comportamiento esperado | siempre |
| Completeness | todos los requisitos implementados | siempre |
| Reliability | manejo de errores, casos límite, estabilidad ante fallos | siempre |
| Maintainability | claridad, modularidad, cohesión, acoplamiento, consistencia | siempre |
| Security | autenticación, autorización, datos sensibles, dependencias, secretos | tareas que afectan esas áreas (véase ADR-003) |
| Performance | requisitos explícitos de rendimiento | solo si existe requisito; no se inventan objetivos |
| Compatibility | no romper funcionalidad existente | siempre |
| Testability | capacidad de validar el cambio | siempre |

### Trazabilidad

Cada cambio debe ser trazable de extremo a extremo:

```text
Requirement → Acceptance Criterion → Implementation → Validation
```

La trazabilidad es la evidencia de completitud: un requisito sin AC, o un AC sin validación, es un cambio incompleto. Las decisiones importantes se registran como ADR y los handoffs viajan en artefactos verificables con provenance (véase ADR-013).

### Evidencia de calidad

```yaml
quality_evidence:
  tests:
    status: passed | failed | not_run | flaky
    count: 184
  lint:
    status: passed | failed | not_run
  typecheck:
    status: passed | failed | not_run
  review:
    status: approved | changes_required | not_run
```

> Regla: los gates se evalúan contra la evidencia, no contra la palabra del agente.

## Sistema de gates

El sistema tiene dos niveles (véase ADR-006): **gates de tarea** (G1-G6), reglas del sistema que un cambio debe superar para avanzar, y **gates de release** (R1-R4), que deciden si un cambio llega a producción.

### Gates de tarea (G1-G6)

| Gate | Condición |
|---|---|
| G1 Requirements | requisitos y acceptance criteria definidos |
| G2 Implementation | implementación completa sin errores bloqueantes conocidos |
| G3 Tests | tests requeridos pasan |
| G4 Static Quality | lint + typecheck + formatter |
| G5 Security | scan de seguridad + auditoría de dependencias (cuando aplica) |
| G6 Review | aprobación del Reviewer |

### Matriz gate por tipo de tarea

| Tipo de tarea | Tests | Lint | Typecheck | Security | Review |
|---|---|---|---|---|---|
| Documentation | Optional | No | No | No | Optional |
| Bug Fix | Required | Required | Required | Conditional | Required |
| Feature | Required | Required | Required | Conditional | Required |
| Architecture | Conditional | No | No | Conditional | Required |
| Security | Required | Required | Required | Required | Required |
| Refactor | Required | Required | Required | Conditional | Required |

### Gates de release (R1-R4)

| Gate | Condición |
|---|---|
| R1 Basic | tests pasan, esquemas válidos, sin errores críticos |
| R2 Quality | umbrales de calidad y regresión cumplidos |
| R3 Security | sin regresión de seguridad crítica |
| R4 Operations | costo, latencia y tasa de fallo aceptables |

> Regla: los quality gates son reglas del sistema, no recomendaciones del agente.

### Contrato de fallo de gate

Un gate fallido produce `FAILED` y especifica el motivo y la acción requerida:

```yaml
gate_result:
  status: FAILED
  gate: G3
  reason: 3 de 12 tests fallan
  evidence: test-report.md#EXEC-007
  required_action: corregir fallos y re-ejecutar suite
```

### Bypass de gates

- Los agentes **no pueden** saltarse un quality gate.
- El bypass solo es posible con **aprobación humana registrada** (véase ADR-006 y ADR-010): motivo, propietario, riesgo y expiración. Una aprobación autoriza una única acción concreta; la expiración equivale a no aprobado; el silencio nunca es autorización.

> Regla: bypass de gate solo con aprobación humana registrada; sin ella, el gate bloquea.

## Estrategia de pruebas

### Pirámide de testing

```text
        E2E
      /     \
  Integration
    /       \
 Unit Tests
```

La mayoría de las validaciones son pruebas rápidas y deterministas: unit (lógica de negocio, funciones, servicios, utilidades), integration (API + database, service + repository, auth + session) y E2E (flujos completos) en menor cantidad.

### Regresión

Todo bug fix debe ir acompañado de un **test de regresión** que evite la reaparición: `Bug → Fix → Regression Test`. El Tester selecciona la suite según el alcance del cambio; un cambio pequeño no requiere toda la suite, un cambio de alto impacto sí.

### Tests flaky

Un test inestable se identifica explícitamente, y **un retry que pasa no cuenta como éxito**:

```yaml
test:
  status: flaky
  attempts: 3
```

> Regla: un test verde demuestra una condición concreta; no demuestra que todo el sistema sea correcto, y un retry exitoso no convierte un flaky en passed.

### test-report.md

El Tester produce `test-report.md` como artefacto con provenance (véase ADR-013):

```yaml
test_report:
  execution_id: EXEC-<id>
  agent_id: tester
  status: passed | failed | partial
  tests_run: 184
  tests_passed: 180
  tests_failed: 4
  flaky: 0
  duration_ms: 45200
  coverage: 0.82            # cuando exista; ver umbrales ADR-007
  environment: <entorno>
  errors:
    - test: auth/oauth.spec.ts
      failure: timeout en callback
```

## Revisión de código

El Reviewer es **independiente** del agente que implementó el cambio (véase ADR-003), para reducir el riesgo de auto-validación.

### Áreas de revisión

Correctness, Architecture, Maintainability, Security, Testing, Compatibility, Scope (el cambio está limitado a la tarea).

### Severidades

| Severidad | Significado |
|---|---|
| `BLOCKER` | impide la aprobación |
| `CRITICAL` | defecto crítico; impide la aprobación |
| `MAJOR` | debe corregirse antes del release |
| `MINOR` | mejora recomendada |
| `INFO` | observación sin impacto |

```yaml
review:
  status: approved | changes_required
  findings:
    - severity: minor
      file: src/example.ts
      description: "..."
  recommendations: [ "...", "..." ]
```

Si existe un `BLOCKER` o `CRITICAL`, el resultado es `CHANGES_REQUIRED` y la tarea vuelve al Developer. Los hallazgos deben ser concretos y accionables: "El servicio crea una conexión nueva por request; debe reutilizar el pool existente" y no "el código podría mejorar".

> Regla: un hallazgo sin archivo, línea y acción concreta no es un hallazgo de revisión.

## Marco de evaluación

### Unidad de evaluación

```yaml
evaluation:
  id: eval-<id>
  target_type: agent | tool | workflow | model | prompt | memory | system
  target_id: developer
  version: 1.2.0
  dataset: golden-developer@2026-08
  evaluator: deterministic | rule_based | llm_judge | human | hybrid
  metrics:
    correctness: 2.7
    tests: 2.5
  result: PASS | PASS_WITH_WARNINGS | RETEST | BLOCK
  timestamp: <ISO-8601>
```

Toda evaluación se hace contra **versiones identificables**: `agent_version`, `prompt_version`, `model_version`, `workflow_version`, `dataset_version`. Cada métrica importante lleva evidencia (test result, artifact, execution trace, human judgment, evaluador automatizado).

### Métodos

| Método | Uso | Requisitos |
|---|---|---|
| Determinista | schemas, comandos, tests, file changes, tool results | — |
| Reglas | `must contain`, `must not contain`, `file must exist`, `test must pass` | reglas explícitas |
| LLM-judge | aspectos difíciles de medir automáticamente | rubric explícita, ejemplos, criterios de fallo, calibración, revisión de casos críticos |
| Humano | decisiones ambiguas, calidad arquitectónica, UX, alto impacto | — |
| Híbrido | preferido | checks automatizados + verificación de artefactos + LLM judge + muestreo humano |

### Rúbricas

**Rúbrica de Developer** (0-3 por dimensión):

| Dimensión | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| Correctness | incorrect | partial | mostly correct | correct |
| Tests | absent | weak | adequate | comprehensive |
| Scope | uncontrolled | broad | acceptable | minimal |
| Maintainability | poor | weak | good | excellent |
| Safety | unsafe | concerns | acceptable | safe |

**Reviewer**: bug detection, severity classification, false positives, false negatives, actionability.

**Architect**: requirements coverage, trade-offs, simplicity, scalability, failure handling, maintainability.

> Regla: una rúbrica debe describir qué significa cada score antes de ejecutar la evaluación.

### Datasets

Categorías de caso: `happy path`, `edge case`, `failure case`, `ambiguous task`, `security case`, `regression case`, `tool-use case`.

```yaml
case:
  id: case-<id>
  category: edge_case
  input: "..."
  context: "..."
  expected: "..."
  constraints: [ "...", "..." ]
  risk: low | medium | high
  evaluator: deterministic | llm_judge | human
```

Requisitos del dataset: representar trabajo real, incluir casos difíciles y fallos conocidos, evitar sobreajuste a un prompt concreto y mantenerse **versionado**. Se mantiene un **golden set** por agente: `analyst`, `architect`, `developer`, `tester`, `reviewer`, `security`.

> Regla: los datasets evolucionan cuando aparecen nuevos incidentes o clases de error.

### Regresión

Disparadores de regresión: cambio de prompt, modelo, herramienta, permiso, workflow, memoria o runtime.

```text
Change → Golden Dataset → Baseline → New Version → Compare → Regression Gate
```

Tipos: quality, safety, cost, latency, reliability. Un cambio que mejora una métrica pero **degrada una métrica crítica no se aprueba automáticamente**.

> Regla: la regresión de una métrica crítica bloquea el cambio aunque otra métrica mejore.

### Umbrales por defecto (v0)

Valores concretos configurables por política (véase ADR-007):

| Umbral | Valor por defecto |
|---|---|
| Cobertura de código crítico | objetivo 80% |
| Cobertura del resto | "cuando exista", con criterio explícito |
| R2 review approval rate | >= 80% y sin regresión de métricas críticas |
| Latencia por paso de agente | p95 < 120 s en flujo normal |
| Retries | `max_attempts: 3`, backoff exponencial |
| Presupuesto por tarea | `max_duration_minutes: 30`, `max_retries: 3`, `max_cost` por tipo de tarea |

### Evaluación de seguridad

Los tests de seguridad cubren: prompt injection, secret exposure, permission bypass, unsafe command, contenido malicioso del repositorio, tool output injection, cross-project leakage y memory poisoning. Una vulnerabilidad crítica **bloquea el release**. Se ejecutan periódicamente y tras cambios relevantes.

> Regla: los gates usan estos umbrales como línea base v0; cualquier umbral es configurable en `opencode.json` / política.

---

**Resuelto** (véase ADR-020): rúbrica "ready" con escala 0-3, mínimo por dimensión ≥ 2, score compuesto
por rol ≥ 2.0, ninguna dimensión < 1, y registro del resultado con evidencia por dimensión.
Configurables por política de evaluación del proyecto.
