# Testing Strategy

## 1. Purpose

Define la estrategia de pruebas utilizada por los agentes para validar implementaciones.

## 2. Testing Pyramid

```text
              E2E
             /   \
        Integration
          /       \
       Unit Tests
```

La mayoría de las validaciones deben realizarse mediante pruebas rápidas y deterministas.

## 3. Unit Tests

Validan componentes individuales.

Deben utilizarse para:

- lógica de negocio;
- funciones;
- servicios;
- utilidades.

## 4. Integration Tests

Validan interacción entre componentes.

Ejemplos:

- API + database;
- service + repository;
- authentication + session.

## 5. End-to-End Tests

Validan flujos completos.

Ejemplo:

```text
Login
 ↓
Authentication
 ↓
Session
 ↓
Protected Resource
```

## 6. Regression Testing

Cuando se corrige un bug, debe existir una prueba que evite que el problema reaparezca.

```text
Bug
 ↓
Fix
 ↓
Regression Test
```

## 7. Test Selection

El Tester debe seleccionar pruebas según el alcance del cambio.

Un cambio pequeño no necesariamente requiere ejecutar toda la suite.

Pero los cambios de alto impacto pueden requerir validación completa.

## 8. Test Failure

Si una prueba falla:

```text
TESTING
   ↓
FAIL
   ↓
Developer
   ↓
Fix
   ↓
Testing
```

## 9. Flaky Tests

Los tests inestables deben identificarse.

Un test no debe considerarse exitoso simplemente porque pasó después de un retry.

Debe registrarse:

```yaml
test:
  status: flaky
  attempts: 3
```

## 10. Test Evidence

El Tester debe producir:

```text
test-report.md
```

Incluyendo:

- tests ejecutados;
- tests exitosos;
- tests fallidos;
- duración;
- cobertura cuando exista;
- errores;
- entorno.

## 11. Core Principle

> Un test verde demuestra una condición concreta; no demuestra que todo el sistema sea correcto.
