# Evaluation Regression

## Purpose

Detectar degradaciones después de cambios.

## Regression Triggers

```text
prompt change
model change
tool change
permission change
workflow change
memory change
runtime change
```

## Pipeline

```text
Change
 ↓
Golden Dataset
 ↓
Baseline
 ↓
New Version
 ↓
Compare
 ↓
Regression Gate
```

## Regression Types

```text
quality regression
safety regression
cost regression
latency regression
reliability regression
```

## Rule

Un cambio que mejora una métrica y degrada una métrica crítica no debe aprobarse automáticamente.
