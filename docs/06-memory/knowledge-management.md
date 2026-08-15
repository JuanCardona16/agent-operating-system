# Knowledge Management

## 1. Purpose

Este documento define cómo el sistema captura, organiza y reutiliza conocimiento técnico.

---

# 2. Knowledge Sources

El conocimiento puede proceder de:

```text
Repository
Documentation
Official APIs
Research
Agent execution
Tests
Reviews
Human decisions
External references
```

---

# 3. Knowledge Classification

El conocimiento debe clasificarse como:

```text
PROJECT
DOMAIN
TECHNICAL
OPERATIONAL
TEMPORARY
```

---

# 4. Project Knowledge

Ejemplos:

```text
architecture
coding conventions
domain model
deployment model
repository structure
```

---

# 5. Technical Knowledge

Ejemplos:

```text
framework behavior
library APIs
database patterns
security patterns
```

---

# 6. Operational Knowledge

Ejemplos:

```text
build process
test commands
deployment process
CI configuration
environment requirements
```

---

# 7. Knowledge Capture

No todo resultado debe convertirse automáticamente en memoria.

El agente debe evaluar:

```text
¿Es reutilizable?
¿Es estable?
¿Es verificable?
¿Tiene valor futuro?
```

Si la respuesta es negativa, probablemente debe permanecer como contexto temporal.

---

# 8. Knowledge Promotion

Un conocimiento puede evolucionar:

```text
Observation
   ↓
Repeated evidence
   ↓
Lesson
   ↓
Validated knowledge
   ↓
Project convention
```

---

# 9. Knowledge Validation

Antes de promover información a memoria persistente:

```text
Source
  ↓
Validate
  ↓
Classify
  ↓
Store
```

---

# 10. Knowledge Retrieval

La recuperación debe considerar:

```text
semantic relevance
keyword relevance
scope
freshness
confidence
importance
```

---

# 11. Knowledge Deduplication

El sistema debe evitar almacenar múltiples versiones idénticas del mismo conocimiento.

Ejemplo:

```text
"Use PostgreSQL"

"PostgreSQL is the primary DB"

"We use PostgreSQL"
```

Podrían representar el mismo hecho.

Deben consolidarse cuando corresponda.

---

# 12. Knowledge Conflict

Cuando existe conflicto:

```text
Knowledge A
       +
Knowledge B
       ↓
Conflict Detection
       ↓
Research / Human
       ↓
Resolution
```

Nunca debe ocultarse un conflicto.

---

# 13. Knowledge Governance

La memoria persistente debe tener:

* propietario lógico;
* fuente;
* timestamp;
* confianza;
* estado;
* referencias.

---

# 14. Core Principle

> La memoria del sistema debe evolucionar mediante evidencia, no mediante acumulación indiscriminada.
