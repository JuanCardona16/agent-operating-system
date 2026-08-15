# Artifacts and Evidence

## Purpose

Relacionar archivos y resultados con la ejecución que los produjo.

## Artifact

```yaml
artifact:
  id:
  type:
  path:
  checksum:
  created_by:
  execution_id:
  step_id:
  timestamp:
```

## Artifact Types

```text
source_code
test_report
architecture
log
patch
diff
evaluation_report
build
deployment_record
```

## Provenance

Cada artifact importante debe poder responder:

```text
who created it?
which task?
which execution?
which agent?
which version?
```

## Rule

No confiar únicamente en nombres de archivos para provenance.
