# Agent Configuration

## 1. Purpose

Define el contrato de configuración de un agente.

## 2. Agent Definition

Un agente debe describirse mediante:

```text
Identity
Role
Goal
Instructions
Capabilities
Tools
Permissions
Model
Inputs
Outputs
Constraints
Quality Requirements
```

## 3. Conceptual Schema

```yaml
agent:
  id:
  name:
  version:

  role:
  goal:

  model:
    provider:
    name:
    temperature:

  capabilities:
    - ...

  tools:
    - ...

  permissions:
    - ...

  input_schema:
    ...

  output_schema:
    ...

  constraints:
    - ...

  quality_requirements:
    - ...
```

## 4. Identity

`id` debe ser estable.

Ejemplo:

```text
developer
tester
reviewer
architect
```

El nombre visible puede cambiar sin modificar el identificador interno.

## 5. Versioning

Los cambios significativos de comportamiento deben poder versionarse.

```text
developer@1
developer@2
```

## 6. Role

El role define la responsabilidad principal.

Ejemplo:

```text
Developer:
Implementar cambios de código siguiendo el plan aprobado.
```

## 7. Goal

El goal debe expresar el resultado esperado.

Debe evitar instrucciones ambiguas.

## 8. Capabilities

Las capabilities describen qué sabe hacer el agente.

Ejemplo:

```yaml
capabilities:
  - code_analysis
  - implementation
  - testing
```

## 9. Tools

Las herramientas deben declararse explícitamente.

```yaml
tools:
  - filesystem.read
  - filesystem.write
  - terminal.execute
  - git.diff
  - test.run
```

## 10. Permissions

Las capabilities no implican automáticamente permisos.

```text
Capability
     ↓
Permission
     ↓
Tool
```

Esto permite aplicar Least Privilege.

## 11. Input Contract

Cada agente debe conocer qué información recibe.

```yaml
input:
  task:
    required: true

  requirements:
    required: true

  previous_handoff:
    required: false
```

## 12. Output Contract

Los resultados deben ser estructurados y consumibles por otros agentes.

```yaml
output:
  status:
  summary:
  artifacts:
  changes:
  tests:
  issues:
```

## 13. Constraints

Ejemplo:

```yaml
constraints:
  - no_modify_unrelated_files
  - do_not_commit_without_permission
  - do_not_expose_secrets
  - follow_project_conventions
```

## 14. Quality Requirements

Ejemplo:

```yaml
quality_requirements:
  - tests_must_pass
  - lint_must_pass
  - changes_must_be_reviewable
```

## 15. Core Principle

> Un agente debe tener un contrato explícito antes de recibir autonomía.
