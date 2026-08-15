# Evaluation Reporting

## Report Structure

```yaml
evaluation_report:
  target:
  version:
  dataset:
  summary:
  metrics:
  failures:
  regressions:
  security:
  cost:
  recommendation:
```

## Recommendations

```text
PASS
PASS_WITH_WARNINGS
RETEST
BLOCK
```

## Failure Report

Cada fallo debe contener:

```text
case
expected
actual
severity
root_cause
recommendation
```

## Rule

Un reporte debe permitir que otra persona entienda la decisión sin repetir toda la evaluación.
