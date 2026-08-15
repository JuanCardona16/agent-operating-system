# Gentle AI Integration

## Purpose

Integrate Gentle AI without making the architecture dependent on it.

## Principle

Gentle AI should be treated as an optional platform/service layer.

```text
Agent Architecture
       │
       ├── OpenCode Runtime
       │
       └── Gentle AI Integration
```

## Possible Responsibilities

Depending on the actual Gentle AI capabilities available:

```text
model routing
agent management
context services
evaluation
automation
external orchestration
```

## Adapter Pattern

```text
Internal Interface
      ↓
Gentle AI Adapter
      ↓
Gentle AI
```

## Rule

No core agent should directly depend on provider-specific APIs when an internal abstraction is practical.
