# Runtime Troubleshooting

## Agent Does Not Load

Check:

```text
agent file
frontmatter
model configuration
runtime logs
```

## Tool Not Available

Check:

```text
permission
tool configuration
agent capabilities
environment
```

## Task Fails

Trace:

```text
task
 ↓
agent
 ↓
tool
 ↓
result
```

## Tests Fail

Determine:

```text
implementation defect
test defect
environment problem
dependency problem
```

No asumir automáticamente que el agente tiene la culpa.
