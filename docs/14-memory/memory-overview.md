# 14 — Memory Overview

## Propósito

Definir la arquitectura de memoria del sistema multiagente: qué información se conserva, dónde, durante cuánto tiempo y quién puede recuperarla.

## Principio central

La memoria no es simplemente un historial de conversación.

```text
Memory
├── Working Context
├── Execution Memory
├── Project Memory
├── Agent Memory
├── Knowledge
└── Audit / Provenance
```

## Objetivos

- reducir repetición de contexto;
- preservar decisiones importantes;
- permitir continuidad entre ejecuciones;
- compartir conocimiento útil entre agentes;
- controlar coste de contexto;
- mantener provenance;
- evitar contaminación entre proyectos o tareas.

## Regla

> Solo almacenar información que tenga valor futuro identificable.

## No almacenar por defecto

- secretos;
- credenciales;
- tokens;
- información sensible innecesaria;
- contexto efímero sin valor posterior.
