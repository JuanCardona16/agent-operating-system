# Context Management

## 1. Purpose

El contexto es la información que un agente recibe durante una ejecución.

El objetivo es proporcionar suficiente información para ejecutar correctamente una tarea sin saturar el contexto con información irrelevante.

---

# 2. Context Hierarchy

```text
SYSTEM
  ↓
PROJECT
  ↓
TASK
  ↓
AGENT
  ↓
EXECUTION
```

---

# 3. System Context

Contiene:

* reglas globales;
* políticas de seguridad;
* Agent Contract;
* Tool Contract;
* principios del sistema.

---

# 4. Project Context

Contiene:

* arquitectura;
* stack;
* convenciones;
* decisiones;
* estructura del proyecto.

---

# 5. Task Context

Contiene:

* objective;
* requirements;
* constraints;
* acceptance criteria;
* dependencies.

---

# 6. Agent Context

Contiene información relevante para el role específico.

Ejemplo:

```text
Developer
→ código
→ arquitectura
→ tests

Reviewer
→ diff
→ requirements
→ acceptance criteria
→ architecture
```

---

# 7. Execution Context

Contiene:

* resultados recientes;
* comandos ejecutados;
* errores;
* archivos modificados;
* estado actual.

---

# 8. Context Assembly

El contexto debe construirse dinámicamente.

```text
Task
 │
 ├── Requirements
 ├── Architecture
 ├── Relevant Memory
 ├── Relevant Files
 ├── Previous Handoff
 └── Tool Results
       │
       ▼
   Context Builder
       │
       ▼
      Agent
```

---

# 9. Context Relevance

La información debe clasificarse:

```text
REQUIRED
RELEVANT
OPTIONAL
IRRELEVANT
```

Solo `REQUIRED` y `RELEVANT` deberían entrar normalmente en el contexto.

---

# 10. Context Budget

Cada ejecución debe tener un presupuesto de contexto.

Si existe demasiada información:

```text
Context
   ↓
Rank
   ↓
Filter
   ↓
Compress
   ↓
Agent
```

---

# 11. Context Compression

La compresión puede utilizar:

* resúmenes;
* referencias a artefactos;
* extracción de hechos;
* eliminación de duplicados.

Ejemplo:

En lugar de enviar:

```text
50 mensajes de conversación
```

enviar:

```text
requirements.md
architecture.md
decision ADR-007
test-report.md
current-task.yaml
```

---

# 12. Context Freshness

El sistema debe distinguir entre información:

```text
fresh
stale
unknown
```

La información que cambia frecuentemente debe validarse antes de utilizarse.

---

# 13. Context Provenance

Siempre que sea posible, el agente debe poder saber de dónde procede la información.

Ejemplo:

```yaml
fact:
  content: PostgreSQL is the primary database.

  source:
    type: project_document
    path: docs/architecture/database.md
```

---

# 14. Context Isolation

Una tarea no debe recibir automáticamente toda la memoria de otras tareas.

Debe recuperar únicamente información relevante.

---

# 15. Core Principle

> El mejor contexto no es el contexto más grande. Es el contexto mínimo suficiente para tomar una decisión correcta.
