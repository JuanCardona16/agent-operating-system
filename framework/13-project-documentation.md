# Documentación del proyecto

Documento normativo que materializa ADR-016 (véase `decisions/ADR-000-registro-decisiones.md`):
define la **estructura canónica de documentación** que todo proyecto que usa este framework debe
tener bajo `docs/`, qué contiene cada archivo, quién lo lee, quién lo mantiene y cómo se integra
con el ciclo de vida de los agentes. Prevalece sobre cualquier convención ad-hoc de documentación
de proyecto.

Principio rector: **la documentación viva es el contrato de contexto del proyecto**. Todo
orquestador y todo agente nuevo deben poder reconstruir funcionalidades, stack, alcance,
restricciones y decisiones del proyecto leyendo la estructura canónica, sin reinterpretar
conversaciones anteriores.

> Regla: la documentación de `docs/` es la fuente de contexto del proyecto; los agentes la leen
> antes de planificar y la actualizan como parte de su trabajo (véase ADR-016).

## Estructura canónica del proyecto (`docs/`)

La estructura es idéntica para todos los proyectos del framework; el contenido es específico de
cada proyecto. Los nombres de archivo y de carpeta no se renombran ni se reordenan.

```text
docs/
├── 00-overview.md       ← qué es, objetivo, funcionalidades, usuarios
├── 01-stack.md          ← stack tecnológico (lenguaje, framework, DB, deploy)
├── 02-scope.md          ← alcance, limitaciones, restricciones, non-goals, objetivos
├── 03-architecture.md   ← arquitectura + decisiones
├── 04-domain.md         ← dominio (entidades)
├── 05-conventions.md    ← convenciones de código
├── 06-status.md         ← estado actual + roadmap
├── 07-changelog.md      ← historial de cambios
├── decisions/           ← ADRs del proyecto (docs/decisions/ADR-XXX.md)
├── research/            ← notas de investigación del researcher
├── tasks/               ← TASK-NNNNNN/ (requisitos, plan, resultado)
└── security/            ← hallazgos del security
```

## Archivos y responsabilidades

| Archivo | Qué contiene | Quién lo lee | Quién lo mantiene |
|---|---|---|---|
| `00-overview.md` | qué es el proyecto, objetivo, funcionalidades, usuarios | orquestador (lectura obligatoria) y todos los agentes | `analyst` |
| `01-stack.md` | stack tecnológico (lenguaje, framework, DB, gestor de paquetes, deploy) | orquestador (lectura obligatoria), `developer`, `tester` | `architect` |
| `02-scope.md` | alcance, limitaciones, restricciones, non-goals, objetivos | orquestador (lectura obligatoria) y todos los agentes (límites) | `analyst` |
| `03-architecture.md` | arquitectura y decisiones | `architect`, `developer`, `reviewer`, `security` | `architect` |
| `04-domain.md` | dominio (entidades) | `analyst`, `architect`, `developer` | `architect` |
| `05-conventions.md` | convenciones de código | `developer`, `tester`, `architect` | `architect` (establece) y `developer` (aplica) |
| `06-status.md` | estado actual + roadmap | orquestador, humano | `architect` + orquestador |
| `07-changelog.md` | historial de cambios | todos | el agente que completa el cambio |
| `decisions/` | ADRs del proyecto (`docs/decisions/ADR-XXX.md`) | `architect`, `developer`, `reviewer`, `security` | `architect` |
| `research/` | notas de investigación del `researcher` | `analyst`, `architect` | `researcher` |
| `tasks/` | carpetas `TASK-NNNNNN/` (requisitos, plan, resultado) | orquestador, `analyst`, `developer`, `tester`, `reviewer` | `analyst` (requisitos), `developer` (plan/resultado), `tester` (validación) |
| `security/` | hallazgos del `security` | orquestador, `developer`, `reviewer` | `security` |

La trazabilidad de la documentación sigue el modelo de artefactos verificables (véase ADR-013):
cada actualización relevante registra autor (agente), tarea asociada y fecha, sin almacenar
secretos ni información sensible.

> Regla: un archivo, un tema. La documentación no se agrega a un archivo que trata otro tema.

## Regla 1 — Lectura obligatoria

> Regla: antes de planificar cualquier tarea, el orquestador lee `AGENTS.md`,
> `docs/00-overview.md`, `docs/01-stack.md` y `docs/02-scope.md`. Ninguna tarea se planifica sin
> este contexto.

Cada agente consulta además la documentación de su dominio. Las indicadas en ADR-016 son:

- `architect` → `docs/03-architecture.md` y `docs/decisions/`.
- `tester` → ACs en `docs/tasks/TASK-NNNNNN/`.
- `security` → `docs/security/`.

La correspondencia del resto del roster:

- `developer` → requisitos, ACs y plan de su tarea en `docs/tasks/TASK-NNNNNN/`.
- `researcher` → `docs/research/` (historial de notas previas).
- `analyst` → `docs/00-overview.md`, `docs/02-scope.md` y `docs/04-domain.md`.
- `reviewer` → `docs/03-architecture.md`, `docs/decisions/` y `docs/tasks/`.

La lectura obligatoria es independiente de la memoria del sistema (véase ADR-008): la doc viva
es contexto verificable del repositorio; la memoria recuperada se etiqueta como contexto
recuperado, nunca como autoridad.

## Regla 2 — Escritura como parte del trabajo

> Regla: una tarea no se considera completa hasta que el cambio de documentación asociado quedó
> registrado; la documentación viva es parte del Definition of Done (véase ADR-016).

Los agentes actualizan la documentación dentro de la propia tarea, no en una tarea separada:

- `docs/07-changelog.md` al completar cualquier cambio (fecha, versión, descripción, autor, tarea).
- `docs/decisions/ADR-XXX.md` cuando el cambio introduce una decisión arquitectónica nueva.
- `docs/06-status.md` al cerrar cada milestone.
- Los archivos de dominio afectados por el cambio (`01-stack.md`, `02-scope.md`,
  `03-architecture.md`, `04-domain.md`, `05-conventions.md`) se actualizan en la misma tarea.

Una tarea sin el cambio documental correspondiente es una tarea incompleta, con independencia del
resultado de los gates de calidad.

## Regla 3 — Ciclo de vida

```text
/framework-init (bootstrap) → estructura + placeholders → agentes mantienen → doc viva
```

- **Creación**: `/framework-init` ejecuta `bootstrap.ps1` y crea `docs/` con las 8 plantillas
  (`00-overview.md` a `07-changelog.md`) y las 4 carpetas (`decisions/`, `research/`, `tasks/`,
  `security/`). Los placeholders (`{{project_name}}`) se sustituyen en la instalación; el contenido
  de arranque indica qué debe completar cada agente, no inventa texto definitivo.
- **Mantenimiento**: los agentes la mantienen como parte del trabajo (Regla 2).
- **Contrato**: la doc viva es el contrato de contexto del proyecto para todo agente nuevo; el
  agente la lee antes de actuar (Regla 1).

> Regla: la estructura se crea una sola vez por `/framework-init`; a partir de ahí es
> responsabilidad de los agentes mantenerla viva.

## Relación con `new-project-scaffold`

`new-project-scaffold` es un generador de arranque opcional: produce boilerplate de documentación
genérico para un proyecto nuevo, en cualquier lenguaje y stack, y es agnóstico al framework.
Esta skill se instala globalmente en OpenCode y no forma parte del paquete de distribución.

Relación con la estructura canónica:

- Ambos generan documentación de arranque; no son excluyentes.
- El scaffold es un **generador de arranque opcional**: puede usarse para proyectos que no usan el
  framework o como punto de partida antes de `/framework-init`.
- La estructura canónica la define este documento (ADR-016), no el scaffold: en un proyecto que
  usa este framework, `docs/00..07` + `decisions/` + `research/` + `tasks/` + `security/` es la
  norma, independientemente de lo que genere el scaffold.
- Si se usan ambos, el resultado del scaffold se alinea a la estructura canónica; el framework no
  adopta nombres de archivo ni secciones del scaffold.

> Regla: en un proyecto del framework, la estructura canónica de ADR-016 prevalece sobre el
> output de `new-project-scaffold`.

## Materialización en OpenCode

Checklist de materialización, consistente con la sección 8 de `11-opencode-configuration.md`:

1. **`bootstrap.ps1`**: incluye las 8 plantillas `docs/*.md` y los 4 `.gitkeep` en
   `$TemplateFiles`; sustituye `{{project_name}}` y crea los directorios destino automáticamente.
2. **Permisos (`opencode.json`)**: cada agente puede escribir su dominio de documentación —
   `architect` → `docs/**`; `researcher` → `docs/research/**`; `security` → `docs/security/**`; y,
   para la Regla 2, `analyst`/`developer`/`tester` → `docs/tasks/**` y `docs/07-changelog.md`.
3. **`AGENTS.md` del proyecto**: incluye la sección de documentación del proyecto (véase la
   plantilla) que remite a ADR-016 e impone la lectura obligatoria de la Regla 1.
4. **Validación post-instalación**: tras `/framework-init`, el proyecto tiene `docs/00..07`,
   `decisions/`, `research/`, `tasks/` y `security/`, y los `{{project_name}}` fueron sustituidos.
5. **Versionado**: la estructura `docs/` se versiona junto con `AGENTS.md`; la doc viva es
   contrato y no queda fuera del repositorio.

> Regla: la materialización se valida con la escalera de validación del runtime; una instalación
> sin estructura `docs/` completa es una instalación incompleta.

---

**Resuelto**: la extensión de la matriz de permisos para la Regla 2 — escritura de `analyst`,
`developer`, `tester` y `researcher` sobre sus dominios documentales y `docs/07-changelog.md` — se
fija en **ADR-017**, junto con la versión objetivo de OpenCode (`1.18.x`). Aplicar en
`opencode.json` la matriz de escritura documental del ADR-017 y validar contra el schema oficial al
versionar la plantilla canónica.
