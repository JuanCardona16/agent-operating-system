# Code Review

## 1. Purpose

Define el proceso mediante el cual el Reviewer evalúa una implementación antes de aprobarla.

## 2. Review Independence

El Reviewer debe ser independiente del agente que implementó el cambio cuando sea posible.

```text
Developer
    ↓
Implementation
    ↓
Reviewer
```

Esto reduce el riesgo de auto-validación.

## 3. Review Areas

El Reviewer debe comprobar:

### Correctness

¿La implementación hace lo solicitado?

### Architecture

¿Respeta la arquitectura existente?

### Maintainability

¿El código puede mantenerse razonablemente?

### Security

¿Introduce vulnerabilidades?

### Testing

¿Existe cobertura adecuada?

### Compatibility

¿Puede romper funcionalidad existente?

### Scope

¿El cambio está limitado a la tarea?

## 4. Review Severity

Los hallazgos se clasifican:

```text
BLOCKER
CRITICAL
MAJOR
MINOR
INFO
```

## 5. Review Result

```yaml
review:
  status: approved

  findings:
    - severity: minor
      file: src/example.ts
      description: ...

  recommendations:
    - ...
```

## 6. Rejection

Si existe un `BLOCKER` o `CRITICAL`:

```text
REVIEW
  ↓
CHANGES_REQUIRED
  ↓
DEVELOPER
```

## 7. Review Principle

El Reviewer debe identificar problemas concretos y accionables.

Incorrecto:

```text
"El código podría mejorar."
```

Correcto:

```text
"El servicio crea una conexión nueva por request.
Debe reutilizar el pool existente para evitar agotamiento
de conexiones."
```
