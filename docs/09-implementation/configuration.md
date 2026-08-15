# Configuration

## 1. Purpose

Define cómo se organiza la configuración del sistema.

## 2. Configuration Layers

```text
Defaults
   ↓
Environment
   ↓
Project
   ↓
Workflow
   ↓
Agent
   ↓
Execution Override
```

Las configuraciones más específicas pueden sobrescribir las generales cuando esté permitido.

## 3. Configuration Categories

```text
agents
models
tools
workflows
memory
quality
observability
security
runtime
```

## 4. Example

```yaml
runtime:
  max_concurrent_agents: 4
  default_timeout: 300

observability:
  enabled: true

quality:
  require_review: true

memory:
  enabled: true
```

## 5. Environment Variables

Los secretos deben utilizar variables de entorno.

```text
LLM_API_KEY
GENTLE_AI_API_KEY
DATABASE_URL
```

No deben almacenarse directamente en archivos versionados.

## 6. Environment Separation

```text
development
testing
staging
production
```

Cada entorno debe tener configuración independiente.

## 7. Configuration Validation

Antes de iniciar el runtime:

```text
Load Config
   ↓
Validate Schema
   ↓
Validate Permissions
   ↓
Validate Dependencies
   ↓
START
```

## 8. Invalid Configuration

Si la configuración es inválida:

```text
CONFIGURATION_ERROR
```

El sistema no debe iniciar parcialmente.

## 9. Configuration Versioning

Los cambios importantes deben quedar versionados junto al sistema.

## 10. Core Principle

> Una configuración inválida debe fallar temprano, antes de producir efectos secundarios.
