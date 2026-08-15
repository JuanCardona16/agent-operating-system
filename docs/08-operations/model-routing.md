# Model Routing

## 1. Purpose

Define cómo seleccionar el modelo más apropiado para cada ejecución.

El modelo es un componente intercambiable del agente.

```text
Agent
  │
  ▼
Model Router
  │
  ├── Model A
  ├── Model B
  └── Model C
```

## 2. Routing Factors

El Router puede considerar:

```text
task complexity
reasoning requirement
coding requirement
context size
latency
cost
historical success
risk
```

## 3. Task Complexity

Clasificación inicial:

```text
simple
moderate
complex
critical
```

## 4. Example Routing

```text
Simple formatting
→ low-cost model

Routine coding
→ coding model

Architecture
→ high-reasoning model

Security review
→ high-reasoning / specialized model

Critical decision
→ human approval
```

## 5. Dynamic Escalation

El Router puede cambiar de modelo cuando:

```text
quality insufficient
tool failures
reasoning failure
context complexity
```

Ejemplo:

```text
Model A
  ↓
Result rejected
  ↓
Model B
  ↓
Review
```

## 6. Model Independence

Los contratos de agentes no deben depender de un modelo concreto.

Debe ser posible cambiar:

```text
Model A → Model B
```

sin rediseñar el agente.

## 7. Model Evaluation

Los modelos deben evaluarse utilizando:

```text
success rate
quality
cost
latency
retries
review outcome
```

## 8. Core Principle

> El modelo debe ser seleccionado por la naturaleza del trabajo, no por preferencia arbitraria.
