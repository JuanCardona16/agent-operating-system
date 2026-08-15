# Security

## 1. Purpose

Define los principios mínimos de seguridad para el sistema multiagente y el software que modifica.

## 2. Security by Default

La política predeterminada es:

```text
DENY
```

Los agentes no deben recibir acceso que no necesiten.

## 3. Secrets

Los agentes no deben:

- imprimir secretos;
- almacenar secretos en código;
- incluir secretos en commits;
- incluir secretos en logs;
- copiar credenciales innecesariamente.

Archivos sensibles:

```text
.env
credentials.*
*.pem
*.key
```

deben estar protegidos.

## 4. Dependency Security

Cuando se agregue una dependencia, el sistema debe considerar:

- origen;
- versión;
- mantenimiento;
- vulnerabilidades conocidas;
- licencia;
- necesidad real.

## 5. Input Validation

Los agentes deben considerar validación de entrada cuando modifiquen:

- APIs;
- formularios;
- parsers;
- comandos;
- queries.

## 6. Authentication and Authorization

Los cambios relacionados con autenticación o autorización requieren especial atención.

Debe evaluarse:

```text
identity
session
permissions
token handling
expiration
revocation
```

## 7. Database Security

Debe evitarse:

- SQL injection;
- exposición de datos;
- migraciones destructivas;
- acceso innecesario.

## 8. Network Security

Las conexiones externas deben limitarse.

Los agentes no deben enviar datos sensibles a servicios externos sin autorización.

## 9. Security Escalation

Un hallazgo de seguridad importante debe detener el workflow:

```text
Agent
 ↓
Security Issue
 ↓
Orchestrator
 ↓
Security Review
 ↓
Human Approval
```

## 10. Core Principle

> La autonomía del agente nunca debe superar los límites de seguridad del sistema.
