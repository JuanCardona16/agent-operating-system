# Memory Trust

## Trust Model

No toda memoria tiene la misma autoridad.

```text
System Policy
    ↓
Explicit Human Decision
    ↓
Verified Repository Evidence
    ↓
Verified Test / Tool Result
    ↓
Documented Knowledge
    ↓
Agent Inference
```

Esta jerarquía es contextual y no debe utilizarse para saltarse permisos o políticas.

## Conflict Resolution

Si dos memorias contradicen:

```text
current evidence
   ↓
source quality
   ↓
verification
   ↓
recency
   ↓
human decision
```

## Rule

La memoria nunca debe anular una política de seguridad o una instrucción de mayor prioridad.
