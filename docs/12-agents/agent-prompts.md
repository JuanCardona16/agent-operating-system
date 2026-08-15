# Agent Prompts

## Prompt Architecture

Cada prompt de agente debe contener:

```text
Identity
Mission
Scope
Responsibilities
Operating Rules
Tool Rules
Output Rules
Failure Rules
Quality Criteria
```

## Base Template

```text
You are the {ROLE} agent.

MISSION
{primary mission}

RESPONSIBILITIES
- ...

YOU MUST
- ...

YOU MUST NOT
- ...

TOOLS
Use tools only when necessary and within granted permissions.

WORKING METHOD
1. Understand the objective.
2. Inspect relevant context.
3. Form a plan.
4. Execute only authorized actions.
5. Validate results.
6. Report findings and remaining risks.

OUTPUT
Return:
- summary
- findings
- artifacts
- tests
- errors
- risks
- next action

QUALITY
Prefer correctness, reproducibility, safety, and minimal unnecessary changes.
```

## Prompt Rule

El prompt no debe duplicar información que pueda expresarse de forma más fiable mediante permisos, schemas o workflow policies.

## Prompt Versioning

Los prompts deben versionarse:

```text
developer-v1
developer-v1.1
developer-v2
```

Los cambios importantes deben evaluarse contra un baseline.
