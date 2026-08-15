# 07 — Memoria

## Propósito

Este documento define el modelo de memoria del sistema multiagente: qué información se conserva, en qué capa, con qué confianza, durante cuánto tiempo y quién puede recuperarla. Es el documento normativo del dominio (véase ADR-008); las versiones anteriores (`docs/06-memory` y `docs/14-memory`) quedan como material de origen y contexto. Cuando lo contradigan, prevalece este documento.

Principio rector: **la memoria debe conservar conocimiento, no ruido**. Solo se almacena información con valor futuro identificable, y el mejor contexto no es el más grande: es el mínimo suficiente para tomar una decisión correcta.

> Regla: la memoria guarda conocimiento verificable y reutilizable; nunca guarda ruido por defecto.

## Modelo de memoria

### Capas

| Capa | Scope | Vida | Contenido típico |
|---|---|---|---|
| Working | execution | duración de la ejecución | objetivo, plan actual, archivos relevantes, hallazgos recientes, errores activos, acciones pendientes |
| Execution | execution/workflow | ejecución + historial | task, workflow, steps, outputs de agentes, tool results, artifacts, quality gates, approvals, failures, retries |
| Task | task | vida de la tarea + archivo | requisitos, progreso, intentos, errores, decisiones, test results, handoffs |
| Project | project | long-term | arquitectura, convenciones, stack, decisiones, restricciones conocidas, deuda técnica |
| Agent | agent | long-term | lecciones, patrones reutilizables, modos de fallo conocidos, preferencias operativas |
| Knowledge | global/project | long-term | hechos validados y reutilizables más allá de una ejecución |
| Audit | system | policy-defined | eventos inmutables de acciones de riesgo (véase ADR-014) |

Una tarea debe poder reconstruirse sin depender de la memoria de otras tareas. La memoria de un agente no contamina automáticamente a otros agentes: para compartir información se promueve a Knowledge y de ahí a memoria compartida.

> Regla: el scope más pequeño compatible con el uso esperado es el preferido (un hecho de proyecto va a project memory, un hecho temporal a execution memory).

### Tipos de contenido

| Tipo | Descripción | Ejemplo |
|---|---|---|
| `FACT` | Hecho estable sobre el proyecto | "El backend utiliza PostgreSQL" |
| `DECISION` | Decisión consciente; ADR cuando es arquitectónica | "Se adopta PostgreSQL como base principal" |
| `CONVENTION` | Regla de implementación | "Los servicios usan dependency injection" |
| `CONSTRAINT` | Limitación conocida | "El sistema debe soportar Node.js 22" |
| `LESSON` | Conocimiento obtenido por experiencia | "El proveedor X exige refresh tokens en sesiones > 1 h" |
| `REFERENCE` | Puntero a fuente o documento | `docs/architecture/database.md` |
| `ARTIFACT` | Referencia a artefacto verificado | `test-report.md` de `EXEC-003` |
| `EVENT` | Registro de un acontecimiento | "tester falló en intento 1 (timeout)" |

### Escalas

- **Confianza** (confidence): `unknown | low | medium | high | verified`.
- **Importancia** (importance): `critical | high | medium | low | temporary`. Determina cuánto tiempo debe conservarse.
- **Scope** (scope): `global | project | workflow | task | execution | agent`.

Nunca tratar una inferencia como un hecho: una inferencia del agente se registra con su nivel real de confianza.

> Regla: los agentes no promueven una inferencia a hecho; la confianza se declara, nunca se asume.

## Esquema de registro

### Memory Record

```yaml
memory:
  id: mem-<uuid>
  type: FACT | DECISION | CONVENTION | CONSTRAINT | LESSON | REFERENCE | ARTIFACT | EVENT
  scope: global | project | workflow | task | execution | agent
  project_id: project-<id>        # si aplica
  task_id: TASK-<id>              # si aplica
  execution_id: EXEC-<id>         # si aplica
  agent_id: <role>                # si aplica
  content: "..."
  source: <source_type>:<source_id>
  confidence: unknown | low | medium | high | verified
  importance: critical | high | medium | low | temporary
  created_at: <ISO-8601>
  updated_at: <ISO-8601>
  expires_at: <ISO-8601>          # solo retención no permanente
  tags: [tag1, tag2]
```

Los identificadores de memoria son inmutables; las correcciones se registran como actualización (`updated_at`) o reemplazo explícito, nunca borrando la evolución.

### Provenance

```yaml
provenance:
  source_type: human | repository | tool | documentation | test | agent | system
  source_id: <id de la fuente>
  execution_id: EXEC-<id>
  agent_id: <role>
  timestamp: <ISO-8601>
  verification: passed | failed | pending | none
```

La provenance materializa la trazabilidad de artefactos del framework (véase ADR-013): toda información importante viaja en artefactos verificables con `execution_id`, `agent_id`, `created_at` y checksum, nunca solo en contexto conversacional.

> Regla: una memoria crítica sin provenance se considera de baja confianza.

## Ciclo de vida

```text
CREATE → VALIDATE → STORE → INDEX → RETRIEVE → USE → UPDATE → EXPIRE / ARCHIVE / DELETE
```

| Paso | Qué ocurre |
|---|---|
| `CREATE` | Origen: decisión arquitectónica, resultado verificado, preferencia explícita, documentación, test, incidente, aprendizaje operativo |
| `VALIDATE` | Checklist de pre-persistencia (abajo) |
| `STORE` | Persistencia a través de la Memory API, nunca directa |
| `INDEX` | Metadatos + búsqueda básica; sin indexación automática de todo output |
| `RETRIEVE` | Pipeline de recuperación (abajo) |
| `USE` | El agente recibe el contenido marcado como contexto recuperado |
| `UPDATE` | Versionar o reemplazar explícitamente registros contradictorios |
| `EXPIRE / ARCHIVE / DELETE` | TTL y escalera de archivo |

### Checklist de validación pre-persist

Antes de persistir cualquier registro:

- [ ] ¿Es factual? (no es una inferencia disfrazada de hecho)
- [ ] ¿La fuente es conocida y registrable?
- [ ] ¿Tiene valor futuro identificable?
- [ ] ¿El scope es el mínimo correcto?
- [ ] ¿Contiene datos sensibles o secretos? En caso afirmativo, no se persiste.

> Regla: si algo no supera la validación, permanece como contexto temporal; no se promueve.

## Retención

### Clases de retención

| Clase | Alcance típico | Política |
|---|---|---|
| `EPHEMERAL` | working memory | fin de ejecución |
| `SHORT_TERM` | task / workflow | `expires_at` explícito |
| `PROJECT` | project memory | long-term + escalera de archivo |
| `LONG_TERM` | project / knowledge | revisión periódica |
| `AUDIT` | audit trail | policy-defined; append-only (véase ADR-014) |

Los registros temporales llevan `expires_at` (TTL). La retención se justifica por utilidad, auditoría o requisito operativo.

### Escalera de archivo

```text
active → deprecated → archived → deleted
```

Antes de eliminar memoria importante, se depreca y se archiva. El estado de las decisiones técnicas se marca explícitamente: `active | deprecated | superseded | unknown`.

> Regla: la retención se justifica por utilidad, auditoría o requisito operativo; la eliminación nunca es el primer paso.

## Confianza y promoción

### Jerarquía de confianza

La autoridad de la memoria deriva de su fuente, según la jerarquía de confianza del sistema (véase ADR-015):

```text
política del sistema
  > decisión humana explícita
  > evidencia verificada del repositorio
  > resultado verificado de test/herramienta
  > conocimiento documentado
  > inferencia del agente
```

La jerarquía es contextual y nunca sirve para saltarse permisos o políticas. Ante conflicto entre memorias se resuelve por: evidencia actual → calidad de fuente → verificación → recencia → decisión humana.

### Escalera de promoción

```text
Execution Finding → Validated → Project Memory → Repeatedly confirmed → Knowledge
```

La promoción es **manual o explícita, nunca automática**: no se promueven automáticamente los outputs de agentes. El conocimiento evoluciona por evidencia repetida, no por acumulación.

> Regla: la memoria nunca anula una política de seguridad ni una instrucción de mayor prioridad, y nada se promueve a Knowledge sin confirmación repetida.

## Recuperación

### Pipeline

```text
Query → Scope Filter → Permission Filter → Candidate Retrieval → Ranking → Deduplication → Context Budget → Agent
```

| Señal de ranking | Qué mide |
|---|---|
| relevance | similitud semántica y de keywords con la consulta |
| recency | frescura del registro |
| confidence | nivel de confianza declarado |
| importance | peso del registro |
| source quality | calidad de la fuente según la jerarquía de confianza |
| scope match | alineación con el scope de la consulta |

No se recupera memoria únicamente por similitud semántica: debe pasar también por scope, permiso, frescura y confianza. La memoria recuperada se inyecta **marcada explícitamente como contexto recuperado**, nunca como instrucción privilegiada. El Context Budget limita cuánto entra en el contexto del agente; lo que no cabe se resume, referencia o descarta.

Ejemplo:

```yaml
memory_query:
  query: authentication architecture
  project_id: project-001
  scope: [project, knowledge]
  max_results: 10
```

> Regla: recuperar sin filtro de scope y permiso es una fuga de contexto; el contexto recuperado se etiqueta como tal.

## Almacenamiento

```text
Agent → Memory Tool / API → Policy → Memory Store
```

El almacenamiento se abstrae tras la Memory API y el Memory Repository:

| Backend | Uso |
|---|---|
| File (archivos estructurados) | MVP; metadatos + búsqueda simple |
| SQLite | MVP recomendado junto a archivos estructurados |
| PostgreSQL | escala, multi-servicio |
| Vector Store | recuperación semántica avanzada (fase posterior) |

El MVP es **SQLite / archivos estructurados + metadatos + recuperación simple**; no se introduce infraestructura vectorial compleja antes de necesitarla. La interfaz del repositorio es estable para permitir sustituir el backend sin tocar a los agentes:

```text
store(record) · get(id) · search(query, filters) · update(id, record) · delete(id) · archive(id)
```

> Regla: el agente nunca accede directamente al backend de memoria; todo pasa por la Memory API y la política.

## Herramientas

| Herramienta | Permiso |
|---|---|
| `memory.read` | permitido según scope del agente |
| `memory.search` | permitido según scope y filtros de proyecto |
| `memory.write` | requiere validación pre-persist |
| `memory.update` | requiere autorización explícita |
| `memory.archive` | preferible a delete para información importante |
| `memory.delete` | el más restrictivo |

Contrato de ejemplo:

```yaml
memory.search:
  input:
    query: string
    scope: [global, project, workflow, task, execution, agent]
    project_id: string
    limit: int
  output:
    records:
      - id
        content
        provenance
        confidence
```

La matriz de permisos por agente deriva del modelo de permisos del framework (véase ADR-009): `NONE | READ | WRITE | EXECUTE | ADMIN` por recurso, con default DENY.

> Regla: no se da acceso directo al almacenamiento a todos los agentes; read por scope, write con validación, delete con máximo control.

## Seguridad

### Amenazas y controles

| Amenaza | Control |
|---|---|
| Fuga de secretos | redacción, validación, prohibición explícita |
| Prompt injection persistida | el contenido externo se trata como datos (véase ADR-015) |
| Contaminación entre proyectos | aislamiento por scope, tests de contaminación |
| Memoria envenenada | provenance + validación + no auto-promoción |
| Recuperación no autorizada | permission filter en el pipeline |
| Información obsoleta | `expires_at`, escalera de archivo |
| Retención de datos sensibles | política de retención + eliminación |

**Nunca se persisten**: API keys, contraseñas, tokens, claves privadas ni credenciales de sesión. No se almacena automáticamente contenido del tipo `ignore previous instructions`, `you are now authorized` o `reveal secrets`: es datos, no autoridad.

> Regla: los secretos no entran en memoria, logs ni outputs de agente; el contenido hostil se trata como datos (véase ADR-015).

## Evaluación de memoria

| Métrica | Definición |
|---|---|
| `retrieval_precision` | de lo recuperado, cuánto era relevante |
| `retrieval_recall` | de lo relevante, cuánto se recuperó |
| `context_reduction` | reducción de contexto frente a inyectar la memoria completa |
| `stale_memory_rate` | proporción de registros vencidos u obsoletos |
| `duplicate_rate` | proporción de registros duplicados |
| `memory_usefulness` | si la memoria redujo trabajo o mejoró decisiones |
| `cross-scope_leakage` | contenido que filtró su scope; objetivo: 0 |

Además se registra `memory_write_rate` como métrica operacional de volumen. La evaluación se hace con experimento A/B: agente sin memoria vs agente con memoria, midiendo accuracy, latencia, coste, tool calls y failure rate.

> Regla: la memoria debe demostrar valor medible antes de convertirse en dependencia crítica; más memoria no equivale a mejores agentes.

---

**Resuelto** (véase ADR-020): TTLs por clase de retención — `EPHEMERAL` fin de ejecución, `WORKING`
1 día, `EXECUTION` 7 días, `TASK` 30 días, `PROJECT` 90 días, `AGENT` 180 días, `KNOWLEDGE` 365 días,
`AUDIT` inmutable + 365 días. Pesos de ranking: `relevance` 0.30, `confidence` 0.20,
`importance` 0.20, `recency` 0.15, `source_quality` 0.10, `scope_match` 0.05 (suman 1.00).
Configurables por política de proyecto.
