---
description: 'Diseña la solución técnica con el agente architect: componentes, interfaces y ADR. Solo escribe en docs/** y architecture/**.'
---

# Diseño de arquitectura

Orquestás la etapa de diseño delegando al agente `architect` (véase 04-workflows §2 y 05-contracts). NO diseñás vos mismo: el architect produce el artifact `design` y los ADR.

## Pasos

1. Definir el objetivo de diseño: `$1` (contexto: `$ARGUMENTS`). Requiere requisitos y AC previos (del analyst).
2. Si no hay requisitos analizados, delegar primero al `analyst` (o pedir confirmación si la tarea no pasó por G1).
3. Delegar al agente `architect` con: requisitos, AC, `constraints`, `context`, `expected_output` (artifact `design` + ADRs).
4. Verificar que el diseño satisface cada AC y respeta la arquitectura del proyecto.
5. Registrar las decisiones de arquitectura como ADR (estado `proposed` hasta revisión).

## Contrato de salida

Estado (`completed | failed | blocked | needs_human | partial`), resumen del diseño, ADRs redactados, riesgos y supuestos, y la información faltante si aplica.
