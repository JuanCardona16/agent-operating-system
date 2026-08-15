# OpenCode

## 1. Purpose

Este documento define el papel de OpenCode dentro de la arquitectura del sistema multiagente.

## 2. Role of OpenCode

OpenCode será uno de los principales componentes de ejecución del sistema.

Su responsabilidad principal será proporcionar el entorno necesario para que los agentes puedan:

- analizar código;
- modificar archivos;
- ejecutar comandos;
- ejecutar tests;
- interactuar con Git;
- utilizar herramientas;
- trabajar dentro del workspace.

## 3. OpenCode Boundary

La arquitectura conceptual debe separar:

```text
Agent Intelligence
        │
        ▼
     OpenCode
        │
        ▼
     Workspace
```

OpenCode no debe convertirse automáticamente en el propietario de toda la lógica del sistema.

## 4. Agent Mapping

```text
Conceptual Agent
       │
       ▼
OpenCode Agent Definition
       │
       ├── Model
       ├── Prompt
       ├── Tools
       ├── Permissions
       └── Configuration
```

## 5. Agent Categories

La primera implementación puede contemplar:

```text
orchestrator
analyst
architect
researcher
developer
tester
reviewer
```

No todos tienen que implementarse simultáneamente.

## 6. Developer Agent

El Developer tendrá acceso principalmente a herramientas de modificación.

```text
Developer
 ├── filesystem.read
 ├── filesystem.write
 ├── terminal
 ├── git
 └── test
```

Sus permisos deben estar limitados al workspace correspondiente.

## 7. Analyst Agent

El Analyst debe tener un perfil predominantemente de lectura.

```text
Analyst
 ├── filesystem.read
 ├── search
 └── repository inspection
```

No debería modificar código salvo que exista una razón explícita.

## 8. Reviewer Agent

```text
Reviewer
 ├── filesystem.read
 ├── git.diff
 ├── test
 └── static-analysis
```

Debe minimizarse su capacidad de modificar el código que está revisando.

## 9. Tester Agent

El Tester debe poder:

- ejecutar tests;
- inspeccionar resultados;
- crear o modificar tests cuando corresponda;
- producir informes.

## 10. Tool Permissions

Las herramientas deben asignarse según el principio:

```text
Least Privilege
```

Ejemplo conceptual:

```yaml
agent:
  name: analyst

  permissions:
    filesystem:
      read: true
      write: false

    terminal:
      execute: false

    git:
      read: true
      write: false
```

La estructura anterior es conceptual y deberá adaptarse a la configuración real utilizada por OpenCode.

## 11. Workspace

Los agentes deben trabajar dentro de un workspace definido.

```text
Workspace
   │
   ├── source
   ├── tests
   ├── docs
   └── configuration
```

El acceso fuera del workspace debe considerarse privilegiado.

## 12. Agent Instructions

Las instrucciones de los agentes deben mantenerse separadas de:

- código fuente;
- configuración del sistema;
- memoria;
- workflows.

Esto permite modificar el comportamiento de un agente sin alterar el resto de la arquitectura.

## 13. OpenCode as Execution Layer

```text
                    ORCHESTRATOR
                         │
                         ▼
                  AGENT DEFINITION
                         │
                         ▼
                      OPENCODE
                         │
              ┌──────────┼──────────┐
              ▼          ▼          ▼
           FILESYSTEM  TERMINAL    GIT
              │          │          │
              └──────────┼──────────┘
                         ▼
                     WORKSPACE
```

## 14. Implementation Rule

No se debe diseñar el sistema suponiendo que OpenCode resolverá automáticamente:

- memoria;
- workflow orchestration;
- observabilidad;
- governance;
- quality management.

Esas capacidades deben diseñarse explícitamente.

## 15. Core Principle

> OpenCode proporciona el entorno de ejecución; la arquitectura del equipo de agentes define cómo se utiliza ese entorno.
