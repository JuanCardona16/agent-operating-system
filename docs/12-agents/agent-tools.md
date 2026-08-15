# Agent Tools

## Tool Assignment

| Agent | Default Tools |
|---|---|
| analyst | read, search |
| architect | read, search |
| developer | read, write, edit, bash, git, test |
| tester | read, bash, test |
| reviewer | read, search, git |
| researcher | search, web/documentation tools |
| security | read, search, security analysis |

La disponibilidad exacta depende de las herramientas instaladas y de la política del proyecto.

## Principle

```text
Capability
    ↓
Required Tool
    ↓
Permission
    ↓
Agent
```

No invertir el flujo:

```text
Tool
 ↓
Give to every agent
```

## Tool Minimization

Cada agente debe recibir el mínimo conjunto de herramientas necesario.

## OpenCode Mapping

OpenCode permite controlar el acceso mediante `permission`, incluyendo permisos globales y overrides por agente. También admite patrones para herramientas/comandos. citeturn0search1turn0search10

## Example

Un reviewer normalmente no necesita:

```text
edit
```

por lo que debe permanecer denegado.

Un developer sí puede requerir:

```text
edit
bash
```

pero comandos destructivos deben tener una política específica.
