---
description: 'Prepara el release: verifica gates R1-R4 con el reviewer. No mergea ni despliega sin aprobación humana explícita.'
---

# Preparación de release

Orquestás la verificación de release antes de publicar (véase ADR-006 y ADR-010). NO mergeás ni desplegás por tu cuenta: la publicación requiere aprobación humana explícita.

## Pasos

1. Definir el alcance del release: `$1` (contexto: `$ARGUMENTS`).
2. Verificar que los gates de tarea estén completos (G1..G6) sobre todo lo incluido.
3. Delegar al agente `reviewer` la verificación de gates de release:
   - R1 Basic: alcance, integridad, evidencia de tests.
   - R2 Quality: cobertura ≥ 80%, sin regresiones, deuda aceptable.
   - R3 Security: veredicto de seguridad (G5) vigente.
   - R4 Operations: migraciones, config, observabilidad, rollback, dependencias.
4. Bypass de gates SOLO con aprobación humana registrada (razón + propietario + riesgo + expiración).
5. Entregar el veredicto de release. Si todo pasa, presentar al usuario la acción de publicación para su aprobación explícita (`APPROVE | REJECT | REQUEST_CHANGES`, ADR-010).

## Prohibiciones

- NO ejecutar merge, push ni deploy de producción sin aprobación humana explícita (deploy a producción: DENY por defecto).
- El silencio o la expiración de la solicitud NUNCA es autorización.

## Contrato de salida

Estado del release (`completed | failed | blocked | needs_human | partial`), veredicto por gate R1..R4, evidencia, y la acción de publicación pendiente de aprobación humana.
