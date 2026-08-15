---
description: 'Ejecuta una tarea del framework multiagente: orquesta agentes por tipo (bug, arquitectura, seguridad, investigación, sistema complejo) con gates y handoff.'
---

# Tarea del framework multiagente

Ejecutás la tarea como ORCHESTRATOR usando el framework (véase `references.framework`). Delegás a los subagentes según el tipo de tarea; NO ejecutás el trabajo vos mismo.

## 1. Intake

- Objetivo: `$1`.
- Contexto adicional: `$ARGUMENTS`.

Validá que el objetivo sea accionable. Si es ambiguo, preguntá antes de continuar (una sola pregunta a la vez).

## 2. Clasificar tipo (04-workflows §2)

| Tipo de solicitud | Ruta |
|---|---|
| Typo / corrección trivial | developer → tester → done |
| Bug fix | developer → tester → reviewer |
| Cambio de arquitectura | analyst → architect → developer → tester → reviewer |
| Problema de seguridad | security → developer → tester → reviewer |
| Investigación | researcher → analyst |
| Sistema complejo | analyst → researcher → architect → developer → security → tester → reviewer |

## 3. Inicializar la tarea

- Crear `task_id` (formato `T-<n>` de la secuencia del proyecto).
- Registrar estado inicial: `BACKLOG` (ADR-004).
- Asignar los agentes que exija el routing del tipo.

## 4. Ejecutar el flujo con gates

Por cada etapa, delegá al agente correspondiente con: `task_id`, `objective`, `requirements`, `constraints`, `acceptance_criteria`, `context`, `expected_output` (05-contracts). Verificá el gate de cada etapa antes de continuar:

- G1 Requirements (analyst/architect) → `READY`.
- G2 Implementation (developer) → `IMPLEMENTING`.
- G3 Tests (tester) → `TESTING`.
- G4 Static Quality (reviewer) → `REVIEWING`.
- G5 Security (security, solo si `security_sensitive`) → `REVIEWING`.
- G6 Review (reviewer) → `APPROVED`.

## 5. Handoffs entre agentes

- El receptor verifica Task, Requirements, Context, Artifacts, ACs y Dependencies antes de aceptar (05-contracts).
- Contexto importante viaja en artifacts con provenance (`execution_id`, `agent_id`, `created_at`, `checksum`) (ADR-013).
- Si un agente devuelve `blocked` con información faltante, resolvé con el agente previo o escalá a humano; no seguís con información incompleta.

## 6. Fallos y retry (ADR-005)

- Máximo 3 intentos; cada retry añade diagnóstico nuevo.
- NO reintentables (escalan a humano): permiso denegado, requisitos inválidos, violación de política, acción destructiva rechazada, fallo determinista de test.
- Protección de bucle: `max_same_transition` 3 → si un agente devuelve el mismo estado 3 veces, escalás.

## 7. Aprobación humana (ADR-010)

- Solo para acciones que lo requieran (deploy, cambios de política, decisiones de arquitectura aprobadas por humano): `REQUEST → WAITING_APPROVAL → APPROVE | REJECT | REQUEST_CHANGES`.
- Una aprobación autoriza UNA acción. El silencio nunca es autorización.
- Presentá la petición al usuario; no la auto-autorices.

## 8. Verificación de gates de release (solo si corresponde)

R1 Basic, R2 Quality (cobertura ≥ 80%), R3 Security, R4 Operations. Bypass solo con aprobación humana registrada (razón + propietario + riesgo + expiración).

## 9. Cierre

- Estado final: `DONE` (o `BLOCKED`/`FAILED`/`NEEDS_HUMAN`/`CANCELLED`).
- Devolvé un resumen: ruta de agentes, gates verificados, artifacts creados, estado final y próximos pasos.

## 10. Referencia

Para dudas de proceso, delegación, permisos, gates o contratos, consultá la reference `framework` (01-architecture, 02-agents, 04-workflows, 05-contracts, 11-opencode-configuration, ADR-000-registro-decisiones). Si la referencia no está disponible, avisá y seguí las reglas de este comando.
