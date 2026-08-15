# Runtime Permissions

## MVP Matrix

| Capability | Developer | Tester | Reviewer |
|---|---:|---:|---:|
| Read files | Allow | Allow | Allow |
| Write source | Allow | Deny | Deny |
| Write tests | Allow | Controlled | Deny |
| Terminal | Allow | Allow | Restricted |
| Git status/diff | Allow | Allow | Allow |
| Git commit | Controlled | Deny | Deny |
| Git push | Ask | Deny | Deny |
| Deploy | Deny | Deny | Deny |
| Secrets | Deny | Deny | Deny |

## Principle

Los permisos reales deben comprobarse en OpenCode/runtime y no únicamente en los prompts.

## High Risk

```text
git push
deployment
destructive commands
secret access
```

requieren controles adicionales.
