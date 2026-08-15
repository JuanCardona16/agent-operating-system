# Agent Mapping

## Initial Team

| Agent | Primary Responsibility | Typical Tools |
|---|---|---|
| analyst | requirements and task decomposition | read/search |
| architect | architecture and technical design | read/search |
| researcher | technical research | search/read |
| developer | implementation | read/write/terminal |
| tester | tests and verification | read/write/terminal |
| reviewer | code review | read/search/git diff |
| security | security analysis | read/search/security tools |

## Flow

```text
analyst
   ↓
architect
   ↓
developer
   ↓
tester
   ↓
reviewer
   ↓
security
```

Researcher can be invoked when uncertainty requires external or repository research.

## Rule

Agent selection must be based on task requirements, not simply agent availability.
