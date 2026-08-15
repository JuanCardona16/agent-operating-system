---
description: 'Implementa la tarea con el agente developer: código + tests según requisitos y design. Escribe código por extensión y ejecuta build/lint/test.'
---

# Implementación

Orquestás la etapa de implementación delegando al agente `developer` (véase 04-workflows §2 y 05-contracts). NO implementás vos mismo: el developer produce el código y los tests.

## Pasos

1. Definir la tarea a implementar: `$1` (contexto: `$ARGUMENTS`).
2. Requiere design y requisitos (G1). Si no existen, orquestar primero analyst/architect o pedir confirmación.
3. Delegar al agente `developer` con: `task_id`, requisitos, AC, design, `constraints`, `context`, `expected_output` (código + tests).
4. Verificar gate G2 (Implementation): el código cumple los AC, respeta convenciones y no introduce secretos (ADR-014).
5. Ejecutar o hacer ejecutar build/lint/test y confirmar que pasan antes de continuar.

## Contrato de salida

Estado (`completed | failed | blocked | needs_human | partial`), resumen de cambios por archivo, tests añadidos, verificación de build/lint/test y desviaciones del design con justificación.
