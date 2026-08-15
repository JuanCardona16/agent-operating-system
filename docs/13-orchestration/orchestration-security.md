# Orchestration Security

## Security Boundaries

```text
Task
 ↓
Orchestrator
 ↓
Policy
 ↓
Agent
 ↓
Tool
 ↓
External System
```

Cada salto debe conservar controles.

## Rules

- validar inputs;
- aplicar permisos antes de ejecutar;
- limitar herramientas;
- evitar secretos en contexto;
- auditar acciones críticas;
- requerir aprobación para operaciones de alto riesgo.

## Prompt Injection

El orchestrator no debe tratar contenido externo como instrucciones confiables.

Diferenciar:

```text
trusted system policy
trusted workflow
agent instructions
untrusted repository content
untrusted web content
untrusted tool output
```

## Rule

Los datos observados por un agente no adquieren automáticamente autoridad de instrucción.
