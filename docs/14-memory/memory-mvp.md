# Memory MVP

## Objective

Construir una primera memoria útil sin introducir complejidad innecesaria.

## MVP Includes

```text
Working memory
Execution memory
Project memory
Structured storage
Metadata
Provenance
Basic search
Scope filtering
Retention
```

## Initial Flow

```text
Task
 ↓
Load Project Memory
 ↓
Build Working Context
 ↓
Agent Execution
 ↓
Extract Findings
 ↓
Validate
 ↓
Persist Selected Memory
```

## MVP Storage

Recomendación:

```text
SQLite / structured files
```

con una interfaz que permita sustituir el backend posteriormente.

## Excluded

- autonomous memory learning;
- unrestricted global memory;
- automatic promotion of every finding;
- complex graph memory;
- uncontrolled vector retrieval.

## Exit Criteria

- memoria aislada por proyecto;
- provenance funcional;
- búsqueda útil;
- expiración funcional;
- permisos aplicados;
- tests de contaminación entre proyectos.
