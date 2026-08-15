# Runtime Bootstrap

## Startup

```text
START
  ↓
Load Configuration
  ↓
Validate Configuration
  ↓
Initialize Logging
  ↓
Initialize Event System
  ↓
Initialize Tool Registry
  ↓
Initialize Agent Registry
  ↓
Validate Policies
  ↓
READY
```

## Execution

```text
Task
 ↓
Create Execution
 ↓
Resolve Agent
 ↓
Validate Permissions
 ↓
Build AgentInput
 ↓
Run Agent
 ↓
Collect Tool Calls
 ↓
Validate Output
 ↓
Emit Events
 ↓
Complete Execution
```

## Shutdown

```text
STOP REQUEST
   ↓
Stop New Tasks
   ↓
Finish / Cancel Active Tasks
   ↓
Flush Events
   ↓
Persist State
   ↓
Shutdown
```

## Estados

```text
INITIALIZING
READY
RUNNING
DEGRADED
STOPPING
STOPPED
FAILED
```

## Errores

```text
ConfigurationError
ValidationError
PermissionError
ToolError
AgentError
WorkflowError
InfrastructureError
UnknownError
```

> Un error no controlado nunca debe dejar el sistema en un estado ambiguo.
