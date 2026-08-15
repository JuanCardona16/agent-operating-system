# Memory Lifecycle

## Lifecycle

```text
CREATE
  ↓
VALIDATE
  ↓
STORE
  ↓
INDEX
  ↓
RETRIEVE
  ↓
USE
  ↓
UPDATE
  ↓
EXPIRE / ARCHIVE / DELETE
```

## Creation

Una memoria puede originarse en:

- decisión arquitectónica;
- resultado verificado;
- preferencia explícita;
- documentación;
- test;
- incidente;
- aprendizaje operativo.

## Validation

Antes de persistir:

```text
Is it factual?
Is the source known?
Is it useful later?
Is the scope correct?
Does it contain sensitive data?
```

## Expiration

No toda memoria debe ser permanente.

```text
temporary → execution
short-term → task/project
long-term → project/knowledge
```

## Update

Preferir versionar o reemplazar explícitamente registros contradictorios.

## Deletion

Debe existir una política para eliminar información:

- obsoleta;
- incorrecta;
- duplicada;
- sensible;
- fuera de scope.
