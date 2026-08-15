# Evaluation Methods

## 1. Deterministic Tests

Ideal para:

```text
schemas
commands
tests
file changes
tool results
```

## 2. Rule-Based Evaluation

Comprobar reglas explícitas:

```text
must contain
must not contain
file must exist
test must pass
```

## 3. LLM-as-Judge

Útil para aspectos difíciles de medir automáticamente.

Debe utilizar:

- rubric explícita;
- ejemplos;
- criterios de fallo;
- calibración;
- revisión de casos críticos.

## 4. Human Evaluation

Necesaria para:

- decisiones ambiguas;
- calidad arquitectónica;
- UX;
- casos de alto impacto.

## 5. Hybrid

Preferido:

```text
automated checks
+
artifact verification
+
LLM judge
+
human sampling
```
