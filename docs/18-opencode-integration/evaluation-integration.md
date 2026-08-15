# Evaluation Integration

## Goal

Every agent should be testable independently and as part of workflows.

## Agent Evaluation

```text
agent definition
+
model
+
tools
+
dataset
→
evaluation
```

## Regression

Any change to:

```text
agent prompt
model
tools
permissions
workflow
memory
```

should be eligible for regression evaluation.

## Release Gate

```text
critical tests
+
security
+
quality
+
cost
+
latency
```

must meet configured thresholds.
