---
description: 'Audita la seguridad con el agente security: gate G5 y R3. Solo para tareas security_sensitive. Solo escribe en docs/security/**.'
---

# Auditoría de seguridad

Orquestás la auditoría de seguridad delegando al agente `security` (véase 04-workflows §2 y 05-contracts). NO auditás vos mismo: el security emite el veredicto G5 (y R3 si corresponde).

## Precondición

Solo se ejecuta cuando la tarea es `security_sensitive == true` (implementación que toca autenticación, autorización, datos sensibles, entradas no confiables, manejo de secretos, dependencias críticas, o por indicación del usuario).

## Pasos

1. Definir el alcance de la auditoría: `$1` (contexto: `$ARGUMENTS`).
2. Delegar al agente `security` con: código/artifacts, `context`, `expected_output` (veredicto G5 + hallazgos).
3. Verificar gate G5 (Security): superficie de ataque, secretos (ADR-014), dependencias y controles auditados con evidencia.
4. Si corresponde release, verificar R3 (Security).
5. Con hallazgos críticos: `failed` → devolver al `developer` para mitigar; documentar en `docs/security/**`.

## Contrato de salida

Estado (`completed | failed | blocked | needs_human | partial`), veredicto G5 (y R3 si aplica), hallazgos con severidad, evidencia y mitigaciones recomendadas.
