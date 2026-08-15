# Decision Memory

## 1. Purpose

Las decisiones representan conocimiento especialmente importante para el sistema.

Una decisión explica por qué el proyecto adoptó determinado enfoque.

---

# 2. Architecture Decision Records

Las decisiones arquitectónicas importantes deben registrarse mediante ADR.

Ejemplo:

```text
docs/decisions/
├── ADR-001.md
├── ADR-002.md
└── ADR-003.md
```

---

# 3. ADR Structure

```markdown
# ADR-001: Use PostgreSQL

## Status

Accepted

## Context

...

## Decision

...

## Alternatives

...

## Consequences

...

## References

...
```

---

# 4. Decision Lifecycle

```text
PROPOSED
   ↓
DISCUSSION
   ↓
ACCEPTED
   │
   ├── SUPERSEDED
   │
   └── REJECTED
```

---

# 5. Decision Sources

Una decisión puede originarse en:

```text
Human
Architect
Researcher
Orchestrator
Project requirement
External constraint
```

Las decisiones de alto impacto deben identificar su fuente.

---

# 6. Decision Authority

Los agentes pueden proponer decisiones.

No todas las decisiones pueden ser aprobadas autónomamente.

Ejemplo:

```text
Minor implementation detail
→ Developer

Architecture change
→ Architect

Critical architecture change
→ Human approval
```

---

# 7. Decision Retrieval

Antes de tomar una decisión importante, el agente debe buscar decisiones existentes relacionadas.

```text
New decision
   ↓
Search existing ADRs
   ↓
Conflict?
 ┌─┴─┐
No  Yes
│    │
▼    ▼
Proceed
      ↓
Review existing decision
```

---

# 8. Decision Supersession

Una decisión nueva no debe simplemente borrar la anterior.

Debe indicar:

```text
ADR-010 supersedes ADR-004
```

Esto conserva la evolución histórica del proyecto.

---

# 9. Core Principle

> Una decisión importante debe ser explicable incluso meses después de haber sido tomada.
