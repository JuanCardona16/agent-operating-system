---
description: 'Revisa la implementación con el agente reviewer: gates G4/G6 y R1-R4. Nivel de acceso: solo lectura.'
---

# Revisión independiente

Orquestás la etapa de revisión delegando al agente `reviewer` (véase 04-workflows §2 y 05-contracts). NO revisás vos mismo: el reviewer emite el veredicto por gate (G4/G6, y R1..R4 si corresponde).

## Pasos

1. Definir qué revisar: `$1` (contexto: `$ARGUMENTS`). Requiere implementación validada.
2. Delegar al agente `reviewer` con: requisitos, AC, código, informe del tester, `context`, `expected_output` (informe de revisión).
3. Verificar gate G4 (Static Quality) y G6 (Review): veredicto por gate con evidencia.
4. Si aplica release: verificar R1 Basic, R2 Quality (cobertura ≥ 80%), R3 Security, R4 Operations.
5. Con hallazgos `needs_changes`, devolver al `developer`; con `aprobado`, continuar.

## Contrato de salida

Estado (`completed | failed | blocked | needs_human | partial`), veredicto por gate (G4/G5/G6 y R1..R4 si aplica), hallazgos con severidad y referencia, y evidencia usada.
