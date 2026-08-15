# Memory Retrieval

## Pipeline

```text
Query
 ↓
Scope Filter
 ↓
Permission Filter
 ↓
Candidate Retrieval
 ↓
Ranking
 ↓
Deduplication
 ↓
Context Budget
 ↓
Agent
```

## Ranking Signals

```text
relevance
recency
confidence
importance
source quality
scope match
```

## Example

```yaml
memory_query:
  query: authentication architecture
  project_id: project-001
  scope:
    - project
    - knowledge
  max_results: 10
```

## Retrieval Rule

No recuperar memoria únicamente porque sea semánticamente similar.

Debe pasar también por:

```text
scope
permission
freshness
trust
```

## Context Injection

La memoria recuperada debe estar claramente marcada como contexto recuperado, no como una instrucción privilegiada.
