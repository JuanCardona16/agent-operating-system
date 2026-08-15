# Reliability

## 1. Purpose

Define cómo mantener el sistema multiagente operativo ante fallos.

## 2. Failure Domains

Los fallos pueden producirse en:

```text
Model
Agent
Tool
Network
Memory
Repository
Orchestrator
External Service
```

## 3. Recovery

Cada componente debe tener una estrategia de recuperación.

```text
Transient failure
    ↓
Retry

Persistent failure
    ↓
Fallback

Critical failure
    ↓
Human escalation
```

## 4. Idempotency

Las operaciones que puedan repetirse deben ser idempotentes cuando sea posible.

Especialmente:

- task creation;
- memory writes;
- artifact creation;
- external API calls.

## 5. Checkpoints

Las tareas largas deben producir checkpoints.

Ejemplo:

```text
Analysis ✓
Architecture ✓
Implementation 60%
```

Si el proceso falla, puede continuar desde el último estado válido.

## 6. Recovery State

El sistema debe conservar:

```text
task state
agent state
artifacts
tool results
validation
```

## 7. Graceful Shutdown

Si el sistema debe detenerse:

```text
RUNNING
 ↓
CHECKPOINT
 ↓
PERSIST STATE
 ↓
STOP
```

No debe perderse el estado de las tareas.

## 8. Core Principle

> Un fallo del sistema no debería obligar a reiniciar el trabajo desde cero.
