# Memory Integration

## 1. Purpose

Define cómo los agentes interactúan con el sistema de memoria.

## 2. Memory Layers

```text
Short-Term Context
        │
        ▼
Task Memory
        │
        ▼
Project Memory
        │
        ▼
Long-Term Knowledge
```

## 3. Memory Types

### Task Memory

Información exclusiva de una tarea.

### Project Memory

Información persistente del proyecto.

### Agent Memory

Conocimiento específico del rol.

### Organizational Memory

Patrones, decisiones y reglas compartidas.

## 4. Memory Operations

Los agentes deben poder realizar operaciones controladas:

```text
READ
WRITE
UPDATE
INVALIDATE
SEARCH
```

## 5. Memory Retrieval

No debe cargarse toda la memoria en cada ejecución.

```text
Task
 ↓
Memory Query
 ↓
Relevant Memories
 ↓
Context
```

## 6. Memory Write

Un agente no debe guardar automáticamente todo lo que observa.

Debe decidir si la información tiene valor futuro.

Ejemplo:

```yaml
memory:
  type: architectural_decision
  importance: high
  scope: project
  content:
    ...
```

## 7. Memory Quality

La memoria debe evitar:

- duplicados;
- información obsoleta;
- datos sin contexto;
- secretos;
- ruido.

## 8. Memory Lifecycle

```text
Created
   ↓
Validated
   ↓
Active
   ↓
Updated
   ↓
Deprecated
   ↓
Archived
```

## 9. Memory Permissions

Ejemplo:

```text
Analyst
  READ project memory

Architect
  READ + WRITE architecture memory

Developer
  READ relevant project memory

Reviewer
  READ decisions and constraints
```

## 10. Memory Provenance

Cada memoria importante debería registrar:

```yaml
provenance:
  source:
  created_by:
  created_at:
  task_id:
  confidence:
```

## 11. Core Principle

> La memoria debe aumentar la capacidad del equipo sin convertirse en una fuente de ruido o información incorrecta.
