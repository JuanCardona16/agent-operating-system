# AI Software Engineering Team

Documentación oficial del sistema multiagente de ingeniería de software.

## 1. Propósito

Este proyecto define una arquitectura para construir un equipo de agentes de inteligencia artificial capaces de colaborar en tareas de desarrollo de software.

El sistema busca transformar una solicitud de alto nivel en software funcional mediante:

* análisis de requisitos;
* investigación técnica;
* diseño arquitectónico;
* planificación;
* implementación;
* pruebas;
* revisión;
* validación;
* documentación;
* aprendizaje mediante memoria persistente.

El sistema está diseñado alrededor de agentes especializados, herramientas controladas y un orquestador central.

## 2. Stack conceptual

El sistema está compuesto por tres capas principales:

### Execution Layer

Responsable de ejecutar acciones sobre el proyecto.

Principalmente:

* OpenCode;
* filesystem;
* terminal;
* Git;
* test runners;
* linters;
* type checkers;
* herramientas del proyecto.

### Intelligence & Context Layer

Responsable de proporcionar capacidades de inteligencia, contexto, memoria y coordinación.

Principalmente:

* Gentle-AI;
* memoria del proyecto;
* conocimiento técnico;
* contexto de tareas;
* decisiones arquitectónicas.

### Agent Layer

Contiene los agentes especializados:

* Orchestrator;
* Analyst;
* Architect;
* Researcher;
* Developer;
* Tester;
* Reviewer.

## 3. Principios fundamentales

El sistema se basa en los siguientes principios:

1. **Especialización**
   Cada agente tiene una responsabilidad claramente delimitada.

2. **Contratos explícitos**
   Los agentes reciben entradas y producen salidas definidas.

3. **Autonomía controlada**
   Los agentes pueden actuar dentro de los permisos asignados.

4. **Validación antes de finalización**
   Ninguna tarea se considera completada únicamente porque un agente terminó su ejecución.

5. **Comunicación mediante artefactos**
   La información importante debe persistir en archivos y estructuras verificables.

6. **Memoria persistente**
   Las decisiones y conocimiento importante deben sobrevivir a una ejecución concreta.

7. **Human-in-the-loop**
   Las operaciones críticas requieren aprobación humana.

8. **Observabilidad**
   El sistema debe registrar qué agentes actuaron, qué hicieron y cuáles fueron los resultados.

## 4. Estado del proyecto

La especificación original vive en `docs/` y está **consolidada en el framework operativo** (`framework/`, 13 documentos + registro de ADR-001..023), que es la fuente de verdad normativa de la que se derivan las plantillas de OpenCode (`templates/`). Véase `framework/README.md` para el índice y el estado de cada documento.

La implementación en runtime (TS/Node) avanza en el repositorio hermano `agent-system`; la alineación formal con el framework se rastrea en el roadmap (`framework/12-roadmap.md`, ADR-023).

## 5. Instalación del framework en un proyecto nuevo

El repositorio contiene **todo lo necesario para configurar un proyecto OpenCode nuevo** en una sola ejecución. El paquete no es autocontenido: `bootstrap.ps1` asume que `templates/` está dentro de un checkout que también contiene `framework/` (la referencia normativa que consume el `opencode.json` instalado), por eso **se clona el repositorio completo**, no solo las plantillas.

### En una máquina nueva

```powershell
# 1. Clonar el repositorio (incluye framework/ y templates/)
git clone <url-del-repositorio> <ruta-del-checkout>

# 2. Instalar en el proyecto destino
& "<ruta-del-checkout>\templates\bootstrap.ps1" `
    -ProjectPath C:\proyectos\mi-app `
    -Model "anthropic/claude-sonnet-4-5"
```

Si se omite `-Model`, el placeholder `{{model}}` queda literal en `opencode.json` y debe reemplazarse a mano.

### Componentes globales opcionales (para cualquier directorio)

- **Skill de orquestación** → `~/.config/opencode/skills/framework-orchestrator` (roster, routing, delegación, gates).
- **Comando `/framework-init`** → `~/.config/opencode/commands/framework-init.md`. Resuelve la ruta del framework vía argumento o `$env:FRAMEWORK_ROOT`; sin eso, pide la ruta al usuario (no hay rutas locales hardcodeadas).

Detalles completos en `templates/README.md`.

## 6. Documentación

La documentación está organizada por dominios:

```text
01-system       Arquitectura y objetivos
02-agents       Definición de agentes
03-tasks        Modelo de tareas
04-workflows    Flujos de trabajo
05-tools        Herramientas y permisos
06-memory       Memoria y contexto
07-quality      Calidad y validación
08-operations   Operación y métricas
09-implementation Implementación técnica
10-roadmap      Evolución del sistema
```

## 7. Source of Truth

Los documentos de `docs/` representan la especificación conceptual original del sistema.

La fuente normativa operativa es `framework/` (véase `framework/README.md`); las plantillas instalables viven en `templates/` y se derivan de los ADR sin reinterpretación (ADR-012).

Cuando exista una contradicción entre una implementación y esta documentación, la discrepancia debe resolverse explícitamente y no mediante comportamiento implícito.

## 8. Evolución

La documentación utiliza versionado mediante Git.

Los cambios importantes de arquitectura deberán documentarse mediante Architecture Decision Records (ADR).


# Estructura del repositorio

```text
.
├── README.md            Este índice
├── docs/                Especificación conceptual original (fuente)
├── framework/           Framework operativo consolidado (fuente normativa, ADR-001..023)
│   ├── README.md        Índice del framework
│   ├── 00-principles.md .. 13-project-documentation.md
│   └── decisions/       ADR-000-registro-decisiones.md
├── templates/           Paquete de distribución (instala en proyectos OpenCode)
│   ├── bootstrap.ps1    Instalador
│   ├── opencode.json    Configuración canónica del proyecto
│   ├── AGENTS.md        Capa operativa del orquestador
│   ├── agents/          Prompts de los 7 agentes
│   ├── commands/        Comandos del framework (task, analyze, …, ship)
│   ├── commands-global/ Comando /framework-init (global, opcional)
│   ├── skills/          Skill framework-orchestrator (global, opcional)
│   └── docs/            Plantillas de documentación del proyecto (ADR-016)
└── .gitignore
```