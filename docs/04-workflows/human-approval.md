# Human Approval

## 1. Purpose

El sistema debe permitir autonomía controlada sin delegar decisiones críticas irreversibles a los agentes.

Human Approval proporciona una frontera explícita entre:

```text
AUTONOMOUS EXECUTION
```

y:

```text
HUMAN AUTHORIZATION
```

---

## 2. Risk Levels

Las acciones se clasifican en:

```text
LOW
MEDIUM
HIGH
CRITICAL
```

---

## 3. LOW Risk

Puede ejecutarse automáticamente.

Ejemplos:

* leer archivos;
* ejecutar tests;
* ejecutar linters;
* crear documentación;
* modificar código dentro del scope.

---

## 4. MEDIUM Risk

Puede requerir validación dependiendo del contexto.

Ejemplos:

* añadir dependencias;
* modificar configuraciones;
* cambios amplios de código;
* cambios de API.

---

## 5. HIGH Risk

Requiere aprobación humana.

Ejemplos:

* migraciones de base de datos;
* modificaciones de infraestructura;
* cambios de seguridad;
* acceso a recursos sensibles;
* operaciones potencialmente destructivas.

---

## 6. CRITICAL Risk

No debe ejecutarse automáticamente en el MVP.

Ejemplos:

* producción;
* eliminación masiva de datos;
* rotación de secretos;
* cambios irreversibles de infraestructura;
* modificación de políticas de seguridad.

---

## 7. Approval Request

Cuando se requiere aprobación:

```yaml
approval_request:
  task_id:
  action:
  risk_level:
  reason:
  impact:
  affected_resources:
  proposed_action:
  rollback_strategy:
  recommendation:
```

---

## 8. Example

```yaml
approval_request:
  task_id: TASK-000042

  action: database_migration

  risk_level: high

  reason: >
    La migración modifica una columna utilizada
    por versiones anteriores de la aplicación.

  impact:
    - posible incompatibilidad;
    - posible pérdida de datos.

  affected_resources:
    - users.email

  proposed_action:
    - crear migración;
    - ejecutar backup;
    - ejecutar en staging;
    - validar;
    - ejecutar producción.

  rollback_strategy:
    available: true

  recommendation:
    "Ejecutar primero en staging."
```

---

## 9. Approval Decision

El humano puede responder:

```text
APPROVE
REJECT
REQUEST_CHANGES
```

La decisión debe quedar registrada.

---

## 10. Principle

Un agente no debe interpretar silencio como autorización.

Si una acción requiere aprobación:

```text
WAITING_FOR_HUMAN
```

hasta recibir una decisión explícita.
