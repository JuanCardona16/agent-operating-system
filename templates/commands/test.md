---
description: 'Valida la implementación con el agente tester: tests y regresiones contra los AC. Solo escribe en tests/**.'
---

# Validación (tests)

Orquestás la etapa de validación delegando al agente `tester` (véase 04-workflows §2 y 05-contracts). NO validás vos mismo: el tester produce el informe de validación (G3).

## Pasos

1. Definir qué validar: `$1` (contexto: `$ARGUMENTS`). Requiere código implementado.
2. Delegar al agente `tester` con: requisitos, AC, código/artifacts, `context`, `expected_output` (informe de validación).
3. Verificar gate G3 (Tests): cada AC verificado con evidencia, suite de tests y regresiones ejecutadas.
4. Si hay fallos: `failed` con reproducción exacta (comando, entrada, esperado vs obtenido) → devolver al `developer`.
5. Entregar el resultado con evidencia por AC.

## Contrato de salida

Estado (`completed | failed | blocked | needs_human | partial`), resultado por AC, comandos ejecutados, evidencias y tests añadidos en `tests/**` si aplica.
