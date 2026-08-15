# Memory Evaluation

## Metrics

```text
retrieval_precision
retrieval_recall
context_reduction
stale_memory_rate
duplicate_rate
memory_write_rate
memory_usefulness
cross-scope_leakage
```

## Questions

Evaluar:

- ¿recuperamos la memoria correcta?
- ¿introducimos ruido?
- ¿la memoria estaba actualizada?
- ¿redujo trabajo?
- ¿causó decisiones incorrectas?

## Experiment

Comparar:

```text
Agent without memory
vs
Agent with memory
```

Medir:

```text
accuracy
latency
cost
tool calls
failure rate
```

## Exit Criterion

La memoria debe demostrar valor medible antes de convertirse en una dependencia crítica.
