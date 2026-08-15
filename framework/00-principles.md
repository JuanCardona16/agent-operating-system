# Principios del Framework

## 1. Alcance y origen

Estos son los principios que **sobreviven a la consolidación** de la especificación. Se sintetizan de `docs/01-system/principles.md`, de las convenciones de `docs/11-foundation` y de los ADR normativos (principalmente ADR-002, ADR-004, ADR-009, ADR-013 y ADR-015, además de los que cada principio cita). Son la base normativa de todo documento 02-12 y de toda configuración derivada de OpenCode.

Cada principio declara: **enunciado** (una frase) y **consecuencia para la implementación** (una o dos líneas operativas). Ninguna decisión de diseño puede contradecir un principio sin una ADR nueva (véase ADR-000).

> **Regla**: un principio se aplica por diseño, no por invocación: cada documento del framework y cada configuración generada debe demostrar dónde lo materializa.

## 2. Principios del sistema

### 1. Especialización

**Cada agente tiene una responsabilidad delimitada y no asume la de otro sin una razón explícita.** (véase ADR-002, ADR-003)

**Consecuencia**: el roster es fijo — 7 roles de ejecución + Security condicional — y la coordinación pertenece al Orchestrator como mecanismo, no a un agente del pipeline. El Developer que detecta un problema arquitectónico lo reporta al Architect; no decide por él.

### 2. Contratos explícitos

**Toda interacción se comunica mediante contratos versionados con entrada, salida y condiciones de éxito definidas.** (véase ADR-013)

**Consecuencia**: los agentes nunca dependen de texto libre como interfaz principal de integración; los inputs se validan, los outputs se normalizan y los cambios incompatibles requieren una nueva versión de contrato (véase `docs/11-foundation/contracts.md`).

### 3. Autonomía controlada

**Los agentes actúan solo dentro de las herramientas, permisos, alcance y estado de tarea que se les asignaron.** (véase ADR-009)

**Consecuencia**: toda acción pasa por la cadena AGENT→CAPABILITY→TOOL→PERMISSION→RESOURCE→ACTION; no existe auto-escalada de permisos, y la escalada requiere aprobación humana con permiso temporal que expira.

### 4. Validación antes de finalización

**Ninguna tarea se completa por la sola finalización de un agente; la finalización depende de criterios verificables.** (véase ADR-006)

**Consecuencia**: los quality gates G1-G6 se aplican por tipo de tarea antes de avanzar de estado; el agente no se autovalida como terminado. `DONE` solo existe tras pasar los gates correspondientes.

### 5. Comunicación mediante artefactos

**La información importante persiste en artefactos verificables con provenance; el contexto conversacional nunca es la fuente única.** (véase ADR-013)

**Consecuencia**: plan, patch, test-report, review-report, logs y ADR son artefactos con `execution_id, agent_id, created_at, checksum`; los handoffs transfieren contexto mínimo y las decisiones arquitectónicas viven en ADR, no en historial de chat.

### 6. Memoria persistente

**El conocimiento con valor futuro sobrevive a la ejecución; lo recuperado se trata como contexto recuperado, nunca como instrucción privilegiada.** (véase ADR-008)

**Consecuencia**: se persiste solo información con valor futuro identificable, con validación antes de escribir; los outputs de agentes nunca se promueven automáticamente a memoria.

### 7. Human-in-the-loop

**Las operaciones críticas requieren aprobación humana explícita; el silencio nunca es autorización.** (véase ADR-009, ADR-010)

**Consecuencia**: flujo REQUEST → WAITING_APPROVAL → APPROVE | REJECT | REQUEST_CHANGES; una aprobación autoriza una acción concreta y la expiración equivale a no aprobado.

### 8. Observabilidad

**El sistema registra qué agentes actuaron, qué hicieron y con qué resultado, correlacionable de punta a punta.** (véase ADR-014)

**Consecuencia**: cadena de correlación única `request_id → task_id → execution_id → step_id → agent_id → tool_call_id`; eventos tipados y versionados; audit append-only e inmutable sin secretos.

### 9. Mínimo privilegio

**Cada agente recibe únicamente los permisos necesarios para realizar su trabajo; nada se asume.** (véase ADR-009, ADR-015)

**Consecuencia**: default DENY para categorías de alto riesgo (network, destructive, secret); read/write permitidos solo dentro del alcance del proyecto; los permisos se otorgan por recurso y acción.

### 10. Falla explícita

**Los errores no se ocultan; un fallo produce información suficiente para identificar la causa, el impacto y el siguiente paso.** (véase ADR-005)

**Consecuencia**: errores tipados con contexto y `execution_id`; clasificación obligatoria antes de reintentar (reintentable vs no reintentable); un error no controlado nunca deja el sistema en un estado ambiguo (véase `docs/11-foundation/runtime-bootstrap.md`).

### 11. Trazabilidad

**Toda tarea responde quién la creó, quién la ejecutó, qué archivos cambió, qué decisiones tomó y por qué terminó.** (véase ADR-004, ADR-014)

**Consecuencia**: máquina de estados en tres capas con mapeo formal; checkpoints, eventos y auditoría por ejecución permiten reconstruir cualquier tarea.

### 12. Reproducibilidad

**Las operaciones son reproducibles: configuración versionada, entorno reconstruible y umbrales concretos y configurables.** (véase ADR-007, ADR-012)

**Consecuencia**: defaults numéricos (timeouts, intentos, cobertura) definidos en ADR-007 y configurables en `opencode.json`; `opencode.json` + `AGENTS.md` + agentes + comandos versionados; workspaces aislados por tarea.

### 13. Separación de preocupaciones

**Orquestación, inteligencia, ejecución, memoria, herramientas y proyecto permanecen separados y evolucionan independientemente.** (véase ADR-002, ADR-011, ADR-012)

**Consecuencia**: el Orchestrator coordina, no ejecuta; la lógica de coordinación vive en el runtime (testeable, sin depender de un modelo); Gentle-AI es una capa opcional vía adaptador y nada ejecutable queda fuera de OpenCode.

### 14. Contenido no confiable = datos, no autoridad

**El contenido de repositorio, web o herramientas nunca otorga permisos ni cambia la política del sistema.** (véase ADR-015)

**Consecuencia**: jerarquía de confianza explícita (política del sistema > decisión humana > evidencia verificada > resultado verificado > conocimiento documentado > inferencia); los prompts nunca son control de seguridad; validación de rutas y red en allowlist por defecto.

### 3. Tabla de trazabilidad

| Principio | Fuente en la spec | ADR |
|-----------|-------------------|-----|
| 1. Especialización | 01-system/principles, scope | ADR-002, ADR-003 |
| 2. Contratos explícitos | 01-system/principles, 11-foundation/contracts | ADR-013 |
| 3. Autonomía controlada | 01-system/principles | ADR-009 |
| 4. Validación antes de finalización | 01-system/principles | ADR-006 |
| 5. Comunicación mediante artefactos | 01-system/principles | ADR-013 |
| 6. Memoria persistente | 01-system/principles | ADR-008 |
| 7. Human-in-the-loop | 01-system/principles | ADR-009, ADR-010 |
| 8. Observabilidad | 01-system/principles | ADR-014 |
| 9. Mínimo privilegio | 01-system/principles | ADR-009, ADR-015 |
| 10. Falla explícita | 01-system/principles, 11-foundation | ADR-005 |
| 11. Trazabilidad | 01-system/principles | ADR-004, ADR-014 |
| 12. Reproducibilidad | 01-system/principles, 09-implementation/environment | ADR-007, ADR-012 |
| 13. Separación de preocupaciones | 01-system/principles, 09-implementation | ADR-002, ADR-011, ADR-012 |
| 14. Contenido no confiable = datos | — (deriva de ADR-015) | ADR-015 |

## 4. Principios de la fundación

Provenientes de `docs/11-foundation/foundation-overview.md`; rigen la capa técnica sobre la que se ejecuta todo el sistema.

| Principio | Qué implica para la implementación |
|-----------|-------------------------------------|
| Bajo acoplamiento | Los componentes se comunican por contratos y eventos, no por llamadas directas entre agentes. |
| Contratos explícitos | Todo componente declara entrada, salida y condiciones de éxito versionadas (véase ADR-013). |
| Componentes sustituibles | LLM, agente, herramienta, proveedor de memoria, workflow engine y backend de observabilidad pueden reemplazarse sin rediseñar el sistema. |
| Configuración externa al código | Defaults → environment → proyecto → agente → runtime overrides; secretos por variables de entorno o secret manager, nunca hardcodeados (véase ADR-007). |
| Seguridad por defecto | Defaults seguros, validación de configuración al iniciar, auditoría de cambios importantes (véase ADR-009, ADR-015). |
| Observabilidad desde el inicio | Eventos y correlación presentes desde el bootstrap, no añadidos después (véase ADR-014). |
| Testabilidad | Todo componente nuevo lleva tests; la lógica de coordinación vive en el runtime, no en prompts (véase ADR-002). |

> **Regla**: una foundation consistente reduce drásticamente la complejidad de agentes y workflows posteriores.

## 5. Citas normativas

Tres citas de la especificación que el framework adopta como normas de primer nivel:

> "Primero construiremos un sistema pequeño que funcione correctamente; después aumentaremos su autonomía." — `docs/09-implementation/implementation-overview.md`, §11 Core Principle.

> "Un agente debe ser una unidad de ejecución controlada, observable y recuperable." — `docs/09-implementation/agent-runtime.md`, §14 Runtime Principle.

> "Un error no controlado nunca debe dejar el sistema en un estado ambiguo." — `docs/11-foundation/runtime-bootstrap.md`.

Estas citas orientan prioridades: alcance acotado antes que autonomía; agentes controlados antes que rápidos; estados deterministas antes que cualquier optimización.

## 6. Reglas de aplicación

1. Los principios son normativos para todo documento 02-12 y toda configuración derivada de OpenCode.
2. Un conflicto entre principio y ADR se resuelve por el ADR (ADR-000).
3. Cambiar un principio requiere una ADR nueva; nunca una edición silenciosa del documento.
4. Todo documento del framework debe poder señalar qué principio materializa y en qué sección.

> **Regla**: si una decisión no puede justificarse con un principio o un ADR, no se decide — se abre una `DECISIÓN PENDIENTE`.
