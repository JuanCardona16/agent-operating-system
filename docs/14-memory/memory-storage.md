# Memory Storage

## Architecture

El sistema debe abstraer el almacenamiento.

```text
Memory API
   ↓
Memory Repository
   ├── File
   ├── SQLite
   ├── PostgreSQL
   └── Vector Store
```

## MVP

Para el MVP:

```text
structured files / SQLite
+
metadata
+
simple retrieval
```

No introducir una infraestructura vectorial compleja antes de necesitarla.

## Interface

Conceptualmente:

```text
store(record)
get(id)
search(query, filters)
update(id, record)
delete(id)
archive(id)
```

## Storage Rule

El agente no debe acceder directamente al backend de memoria.

```text
Agent
 ↓
Memory Tool / API
 ↓
Policy
 ↓
Memory Store
```
