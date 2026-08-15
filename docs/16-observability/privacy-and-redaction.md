# Privacy and Redaction

## Sensitive Data

Detectar y ocultar:

```text
credentials
tokens
personal data
private keys
secrets
```

## Redaction Pipeline

```text
Raw Event
 ↓
Sensitive Data Detector
 ↓
Redaction
 ↓
Storage
```

## Levels

```text
none
partial
full
```

## Rule

La redacción debe ocurrir antes de enviar datos a sistemas de observabilidad externos.

## Debug Mode

Debug no debe significar "disable security".
