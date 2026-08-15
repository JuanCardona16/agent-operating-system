# Agent Evaluation

## Core Metrics

### Correctness

¿El resultado es técnicamente correcto?

### Task Completion

¿Cumplió el objetivo?

### Tool Discipline

¿Utilizó las herramientas necesarias sin abuso?

### Safety

¿Respetó permisos y restricciones?

### Reliability

¿Produce resultados consistentes?

### Efficiency

¿Lo hizo con coste y latencia razonables?

## Agent Score

Conceptualmente:

```text
Agent Score =
Correctness
+ Completion
+ Safety
+ Reliability
+ Efficiency
```

No utilizar una única métrica como criterio absoluto.

## Agent Readiness

Un agente puede considerarse ready cuando:

```text
critical tests pass
+
no critical safety failures
+
quality threshold met
+
regression suite stable
+
operational limits acceptable
```
