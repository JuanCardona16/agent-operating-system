# Framework Multiagente sobre OpenCode — Paquete de Distribución

Este directorio contiene las plantillas para instalar el framework multiagente en cualquier proyecto que use OpenCode. Las plantillas se copian al proyecto destino y los agentes, comandos y configuración quedan activos para el orquestador.

## Contenido

| Ruta | Descripción |
|---|---|
| `opencode.json` | Configuración del proyecto: modelo por defecto, permisos, `references.framework`, roster de agentes (7 subagentes) |
| `AGENTS.md` | Capa operativa del orquestador: roster, routing, delegación, contratos, estados, fallos, aprobación, gates, prohibiciones |
| `bootstrap.ps1` | Instalador: copia las plantillas al proyecto, sustituye `{{model}}`, `{{framework_root}}`, `{{project_name}}`, respalda archivos previos |
| `README.md` | Este índice |
| `agents\*.md` | Prompts de los 7 agentes (analyst, architect, researcher, developer, tester, reviewer, security) |
| `commands\*.md` | Comandos del framework (task, analyze, design, implement, test, review, security, ship) |
| `docs\*.md` | Plantillas de la estructura de documentación del proyecto (00-overview a 07-changelog) más las carpetas `decisions\`, `research\`, `tasks\` y `security\` (véase ADR-016) |

El instalador copia también la estructura de documentación del proyecto (ADR-016): crea `docs\` con las 8 plantillas y las 4 carpetas (decisions, research, tasks, security), lista para completar con el contenido real del proyecto.

Los componentes globales (para instalar manualmente en `~/.config/opencode/`) viven en:

| Ruta | Descripción |
|---|---|
| `skills\framework-orchestrator\SKILL.md` | Skill de orquestación: identidad del orquestador, roster, routing, delegación, estados, fallos, aprobación, gates, umbrales |
| `commands-global\framework-init.md` | Comando global `/framework-init`: ejecuta `bootstrap.ps1` desde cualquier directorio |

## Instalación

### 1. Instalar en un proyecto

Desde el directorio del proyecto, ejecutar el instalador:

```powershell
& "<ruta-al-repositorio>\templates\bootstrap.ps1" -ProjectPath (Get-Location).Path -Model "anthropic/claude-sonnet-4-5"
```

Sustituir `-Model` por el modelo instalado en OpenCode (p. ej. `anthropic/claude-opus-4`, `anthropic/claude-sonnet-4-5`, u otro). Si se omite, el placeholder `{{model}}` queda literal y debe reemplazarse a mano en `opencode.json`.

Opciones:

| Parámetro | Descripción |
|---|---|
| `-ProjectPath` | Proyecto destino. Por defecto: directorio actual |
| `-Model` | Modelo por defecto de los agentes |
| `-Force` | Sobrescribe archivos existentes sin respaldo |

El instalador respalda automáticamente los archivos existentes en `.opencode-backup-<timestamp>\` y escribe sin BOM (UTF-8).

### 2. Comando global (opcional)

Copiar a `~/.config/opencode/commands/`:

```powershell
Copy-Item "<ruta-al-repositorio>\templates\commands-global\framework-init.md" "$env:USERPROFILE\.config\opencode\commands\framework-init.md"
```

### 3. Skill de orquestación (opcional)

Copiar a `~/.config/opencode/skills/`:

```powershell
Copy-Item -Recurse "<ruta-al-repositorio>\templates\skills\framework-orchestrator" "$env:USERPROFILE\.config\opencode\skills\framework-orchestrator"
```

### 4. Reiniciar

Reiniciar OpenCode para que la configuración tome efecto.

## Verificación post-instalación

- `opencode.json` y `AGENTS.md` en la raíz del proyecto.
- `.opencode\agents\*.md`: 7 archivos.
- `.opencode\commands\*.md`: 8 archivos.
- `docs\*.md`: 8 plantillas (00-overview a 07-changelog) y las carpetas `decisions\`, `research\`, `tasks\`, `security\` (con `.gitkeep`).
- El orquestador usa la reference `framework` (en `opencode.json`, `references.framework.path` = `<framework_root>/framework`).

## Fuente normativa

El framework operativo de referencia es el repositorio en `{{framework_root}}` (`framework\01-architecture.md`, `02-agents.md`, `04-workflows.md`, `05-contracts.md`, `11-opencode-configuration.md`, `13-project-documentation.md`, `decisions\ADR-000-registro-decisiones.md`).
