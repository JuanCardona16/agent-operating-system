# MVP

## Objective
Demostrar que el sistema puede actuar como agente de desarrollo útil sin intentar resolver toda la arquitectura multiagente.

## Included

```text
OpenCode
Developer Agent
Filesystem
Terminal
Git
Tests
Basic Configuration
Basic Logging
Structured Result
```

## Excluded

```text
Complex Orchestrator
Persistent Memory
Dynamic Routing
Large Agent Team
Advanced Autonomy
Distributed Execution
Complex Dashboards
```

## MVP Flow

```text
User → Task → Developer → Inspect → Plan → Implement → Test → Diff → Report
```

## Acceptance Criteria

### Functional
- recibir una tarea;
- inspeccionar proyecto;
- modificar archivos;
- ejecutar tests;
- devolver resultado.

### Safety
- workspace limitado;
- permisos explícitos;
- secretos protegidos;
- comandos controlados.

### Quality
- tests ejecutados;
- diff disponible;
- errores reportados.

### Observability
- execution ID;
- agent ID;
- tool calls;
- duración;
- estado final.

## Success Metric

```text
Task Completion Rate
+
Correctness
+
Safety
+
Reproducibility
+
Observability
```

> Si un solo agente no puede ejecutar de forma confiable una tarea pequeña, añadir más agentes no solucionará el problema.
