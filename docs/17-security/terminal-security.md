# Terminal Security

## Risks

```text
rm -rf
credential exfiltration
privilege escalation
arbitrary network access
malicious scripts
filesystem destruction
```

## Controls

- command allow/deny policy;
- working-directory restriction;
- timeout;
- environment filtering;
- resource limits;
- approval for destructive commands.

## Command Classification

```text
safe
restricted
dangerous
blocked
```

## Example

```text
npm test       → safe
git status     → safe
git push       → restricted
rm -rf         → dangerous
curl secret    → blocked
```

## Rule

La clasificación debe ocurrir antes de ejecutar el comando.
