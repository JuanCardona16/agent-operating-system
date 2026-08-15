# Memory Architecture

## 1. Purpose

La memoria permite que el sistema conserve información relevante entre ejecuciones.

El objetivo no es almacenar todo.

El objetivo es almacenar **información útil, estable y recuperable**.

---

# 2. Memory Layers

La arquitectura utilizará varias capas.

```text
┌──────────────────────────────┐
│       GLOBAL KNOWLEDGE       │
├──────────────────────────────┤
│       PROJECT MEMORY         │
├──────────────────────────────┤
│        TASK MEMORY           │
├──────────────────────────────┤
│       AGENT MEMORY           │
├──────────────────────────────┤
│       SESSION CONTEXT        │
└──────────────────────────────┘
```

---

# 3. Global Knowledge

Información general que puede utilizar múltiples proyectos.

Ejemplos:

```text
framework knowledge
language knowledge
engineering patterns
security patterns
tool documentation
```

Debe tratarse como conocimiento externo al proyecto.

---

# 4. Project Memory

Representa el conocimiento específico del proyecto.

Ejemplos:

```text
architecture
conventions
technology stack
coding standards
important decisions
known constraints
domain knowledge
```

Ejemplo:

```text
docs/
├── architecture/
├── decisions/
├── conventions/
└── knowledge/
```

---

# 5. Task Memory

Contiene información relacionada exclusivamente con una tarea.

Ejemplos:

```text
requirements
progress
attempts
errors
decisions
test results
handoffs
```

Una tarea debe poder reconstruirse sin depender de la memoria de otras tareas.

---

# 6. Agent Memory

Contiene conocimiento útil para un agente concreto.

Ejemplos:

```text
lessons learned
reusable patterns
known failure modes
preferred workflows
```

Debe evitar almacenar información específica del usuario que no sea relevante para el trabajo.

---

# 7. Session Context

Es la memoria temporal asociada a una ejecución.

Contiene:

```text
current task
recent observations
tool calls
intermediate reasoning
temporary state
```

No todo el contenido de Session Context debe persistirse.

---

# 8. Memory Lifecycle

```text
CAPTURE
   ↓
CLASSIFY
   ↓
VALIDATE
   ↓
STORE
   ↓
INDEX
   ↓
RETRIEVE
   ↓
USE
   ↓
UPDATE / EXPIRE
```

---

# 9. Memory Types

Se utilizarán inicialmente:

```text
FACT
DECISION
CONVENTION
CONSTRAINT
LESSON
REFERENCE
ARTIFACT
EVENT
```

---

# 10. Facts

Información estable sobre el proyecto.

Ejemplo:

```yaml
type: fact

content: >
  El backend utiliza PostgreSQL.

scope: project
confidence: high
```

---

# 11. Decisions

Decisiones tomadas conscientemente.

Ejemplo:

```yaml
type: decision

content: >
  Se utilizará PostgreSQL como base de datos principal.

source:
  ADR: ADR-003
```

Las decisiones importantes deben tener un ADR asociado.

---

# 12. Conventions

Reglas de implementación.

Ejemplo:

```yaml
type: convention

content: >
  Los servicios backend utilizan dependency injection.
```

---

# 13. Constraints

Limitaciones conocidas.

Ejemplo:

```yaml
type: constraint

content: >
  El sistema debe soportar Node.js 22.
```

---

# 14. Lessons

Conocimiento obtenido mediante experiencia.

Ejemplo:

```yaml
type: lesson

content: >
  El proveedor X requiere refresh tokens explícitos
  para sesiones superiores a una hora.

source:
  task: TASK-000042
```

---

# 15. Memory Metadata

Cada elemento persistente debe tener metadata.

```yaml
memory:
  id:
  type:
  content:

  scope:
    global
    project
    task
    agent

  source:
  created_at:
  updated_at:

  confidence:
  importance:
  status:

  references:
```

---

# 16. Confidence

La información puede tener diferentes niveles de confianza:

```text
high
medium
low
unknown
```

Los agentes deben evitar tratar una inferencia como un hecho.

---

# 17. Importance

La importancia determina cuánto tiempo debe conservarse la información.

```text
critical
high
medium
low
temporary
```

---

# 18. Memory Expiration

No toda memoria debe durar para siempre.

Ejemplo:

```text
temporary → session
task      → lifetime of task + archive
project   → persistent
global    → persistent
```

---

# 19. Memory Conflicts

Si dos memorias se contradicen:

```text
Memory A
"Framework version 5"

Memory B
"Framework version 6"
```

El sistema no debe elegir arbitrariamente.

Debe evaluar:

* timestamp;
* fuente;
* confianza;
* scope;
* autoridad.

Cuando sea necesario:

```text
CONFLICT
   ↓
RESEARCH
   ↓
VALIDATE
   ↓
UPDATE MEMORY
```

---

# 20. Core Principle

> La memoria debe conservar conocimiento, no ruido.

El sistema debe preferir información estructurada y verificable frente a historiales conversacionales completos.
