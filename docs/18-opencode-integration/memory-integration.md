# Memory Integration

## Flow

```text
OpenCode Agent
 ↓
Memory Read
 ↓
Context Construction
 ↓
Execution
 ↓
Finding Extraction
 ↓
Memory Validation
 ↓
Memory Write
```

## Initial Memory

Agents should access:

```text
project memory
current execution memory
relevant knowledge
```

## Restrictions

No unrestricted global memory.

## Rule

Memory retrieval must respect:

```text
project
scope
permissions
provenance
confidence
```
