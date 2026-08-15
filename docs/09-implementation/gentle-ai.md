# Gentle-AI

## 1. Purpose

Este documento define el papel de Gentle-AI dentro del sistema.

## 2. Architectural Role

Gentle-AI debe considerarse un componente complementario al runtime de agentes.

```text
             SYSTEM
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
     OpenCode         Gentle-AI
        │                │
        │                │
        ▼                ▼
   Execution        Intelligence
        │                │
        └───────┬────────┘
                ▼
          Agent System
```

## 3. Separation of Responsibilities

### OpenCode

Principalmente:

- ejecución;
- workspace;
- herramientas;
- edición;
- terminal;
- Git;
- tests.

### Gentle-AI

Dependiendo de las capacidades utilizadas:

- razonamiento;
- coordinación;
- abstracción de agentes;
- routing;
- automatización;
- integración de inteligencia.

Las responsabilidades concretas deben validarse contra la versión y capacidades disponibles de Gentle-AI antes de implementar la integración definitiva.

## 4. Integration Boundary

```text
OpenCode
   │
   │ Agent Execution Contract
   ▼
Integration Layer
   │
   ▼
Gentle-AI
```

## 5. Avoid Tight Coupling

La arquitectura preferida es:

```text
Agent
 ↓
System Interface
 ↓
Adapter
 ↓
Gentle-AI
```

## 6. Adapter Pattern

```text
Agent Runtime
      │
      ▼
Intelligence Provider
      │
      ├── Gentle-AI
      ├── Provider B
      └── Provider C
```

## 7. Model Abstraction

Los agentes no deberían conocer directamente el proveedor del modelo.

Ejemplo conceptual:

```yaml
agent:
  model:
    provider: abstract
    capability: reasoning
```

El sistema resolverá posteriormente qué proveedor/modelo utilizar.

## 8. Failure Handling

Si Gentle-AI no está disponible:

```text
Gentle-AI
    ↓
FAIL
    ↓
Fallback
```

La ejecución no debe quedar bloqueada innecesariamente si existe un mecanismo alternativo válido.

## 9. Integration Testing

La integración debe probarse en diferentes niveles:

### Unit

Adapter aislado.

### Integration

Adapter + Gentle-AI.

### Workflow

Agente + OpenCode + Gentle-AI.

### End-to-End

Usuario → Orchestrator → Agents → Tools → Validation.

## 10. Configuration

Las credenciales y configuración sensible deben mantenerse fuera del código.

```text
Environment
    ↓
Configuration
    ↓
Adapter
    ↓
Gentle-AI
```

## 11. Observability

Las llamadas a Gentle-AI deben registrar:

```text
request_id
task_id
agent_id
model
duration
status
error
usage
```

Nunca deben registrarse secretos ni contenido sensible innecesario.

## 12. Versioning

La integración debe identificar la versión utilizada.

Ejemplo conceptual:

```yaml
provider:
  name: gentle-ai
  version: x.y.z
```

Esto facilita reproducibilidad y debugging.

## 13. Core Principle

> Gentle-AI debe ser un componente reemplazable del sistema, no una dependencia arquitectónica irreversible.
