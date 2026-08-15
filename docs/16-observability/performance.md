# Performance Observability

## Latency Breakdown

```text
Total
├── queue
├── planning
├── model
├── tool
├── retry
├── approval
└── validation
```

## Metrics

```text
p50
p95
p99
```

para operaciones relevantes.

## Bottleneck Detection

Buscar:

```text
slow agents
slow tools
repeated retries
long approvals
large context
```

## Rule

Optimizar primero el componente que domina la latencia total, no el que simplemente parece lento.
