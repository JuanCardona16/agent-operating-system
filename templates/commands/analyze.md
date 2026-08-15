---
description: 'Analiza requisitos y desambigua una solicitud con el agente analyst. Producir alcance y acceptance criteria. Solo lectura.'
---

# Análisis de requisitos

Orquestás la etapa de análisis delegando al agente `analyst` (véase 04-workflows §2 y 05-contracts). NO analizás vos mismo: el analyst produce el artifact.

## Pasos

1. Formular la solicitud a analizar: `$1` (contexto: `$ARGUMENTS`).
2. Delegar al agente `analyst` con: `objective`, `requirements` (los que existan), `constraints`, `acceptance_criteria` (vacía hasta el análisis), `context`, `expected_output` (artifact de requisitos).
3. Verificar gate G1 (Requirements): requisitos claros, AC verificables, alcance definido.
4. Si el analyst devuelve `blocked`, completar la información o escalar al usuario con la lista exacta de faltantes.
5. Entregar el resultado: estado, artifact de requisitos, supuestos, riesgos.

## Contrato de salida

Estado (`completed | failed | blocked | needs_human | partial`), resumen de requisitos y AC, y la información faltante si aplica.
