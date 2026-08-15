# Permisos y Seguridad

Documento normativo que materializa el **modelo de permisos** (ADR-009) y el **modelo de seguridad**
(ADR-015) del framework. Define qué puede hacer cada agente, con qué controles, cómo se clasifican
las acciones por riesgo y cómo se defiende el sistema ante contenido no confiable. Consolidado desde
`docs/05-tools` y `docs/17-security` (22 documentos); ante discrepancia prevalece este documento y
el registro ADR-000 (véase ADR-000).

## Quick path

1. **Permisos**: un agente ejecuta una acción si la cadena
   `AGENT → CAPABILITY → TOOL → PERMISSION → RESOURCE → ACTION` lo autoriza; default `DENY`
   (véase ADR-009, §2).
2. **Riesgo**: cada acción cae en una categoría (`read|write|execute|network|destructive|deploy|secret`)
   con comportamiento por defecto `ALLOW | ASK | DENY` (§3, §2.3).
3. **Contenido**: todo lo que viene del repositorio, la web o las herramientas es **dato, no autoridad**
   (véase ADR-015, §10.2).
4. **Aprobaciones**: lo no permitido escala por `Agente → Orquestador → Aprobación humana → permiso
   temporal (expires)`; el silencio nunca es autorización (véase ADR-010, §2.4).
5. **Verificar**: los casos de testing de seguridad (§11) son obligatorios y cada vulnerabilidad
   corregida se convierte en caso de regresión permanente.

> **Regla**: todo lo que un agente puede hacer debe poder explicarse mediante una autorización
> explícita; las instrucciones del prompt nunca son control de seguridad (véase ADR-009).

---

## 1. Principios de seguridad

| # | Principio | Consecuencia operativa |
|---|-----------|------------------------|
| 1 | Least privilege | Cada agente recibe solo lo necesario para su responsabilidad; sin auto-escalada. |
| 2 | Límites de confianza explícitos | Cada frontera (agente → gateway → recurso) valida antes de ejecutar. |
| 3 | Default deny para alto riesgo | Acción desconocida → `DENY`; las excepciones son explícitas. |
| 4 | Secretos nunca en prompts ni memoria | Solo vía Secret Broker con política (§8). |
| 5 | Contenido no confiable = dato, no autoridad | Repos/READMEs/web no cambian permisos ni políticas (véase ADR-015). |
| 6 | Acciones críticas requieren verificación | Aprobación humana registrada para destructivo/deploy/secret (véase ADR-010). |
| 7 | Decisiones de seguridad auditables | Eventos tipados + audit append-only, correlacionados (véase ADR-014). |

## 2. Modelo de permisos

### 2.1 Cadena de autorización

La autorización de cada operación se resuelve siguiendo la cadena única (véase ADR-009):

```text
AGENT → CAPABILITY → TOOL → PERMISSION → RESOURCE → ACTION
```

Ejemplo: el hecho de que el agente `developer` conozca Git (capability) no lo autoriza a `git.push`:
la cadena se corta en `PERMISSION → RESOURCE → ACTION`. **Capability ≠ Permission ≠ Tool.**

| Eslabón | Pregunta que responde |
|---------|----------------------|
| AGENT | ¿Quién (rol humano/agente/orquestador)? |
| CAPABILITY | ¿Qué sabe hacer el agente? (conocimiento, no autorización) |
| TOOL | ¿Qué herramienta se invoca? (registrada y versionada, §4) |
| PERMISSION | ¿Qué nivel se tiene sobre el recurso? (NONE…ADMIN, §2.2) |
| RESOURCE | ¿Sobre qué recurso concreto (ruta, host, rama, entorno)? |
| ACTION | ¿Qué acción exacta (leer, escribir, ejecutar, eliminar, desplegar)? |

### 2.2 Niveles de permiso por recurso

| Nivel | Significado | Ejemplos |
|-------|-------------|----------|
| `NONE` | Operación prohibida | `database.drop`, `secret.read` |
| `READ` | Consulta | `filesystem.read`, `git.diff`, `database.read` |
| `WRITE` | Modifica recursos | `filesystem.write`, `git.commit` |
| `EXECUTE` | Ejecuta operaciones | `terminal.execute`, `test.run`, `deploy.staging` |
| `ADMIN` | Modifica configuración o política del sistema | ningún agente normal lo tiene |

El nivel se aplica **por recurso**, no globalmente. Preferir `write: [src/**, tests/**]` antes que
`write: "*"`. Los recursos sensibles (`env`, credenciales, claves privadas, config de producción,
secret stores) están **prohibidos por defecto**.

### 2.3 Categorías de riesgo y comportamiento por defecto

| Categoría | Ejemplos | Default | Nota |
|-----------|----------|---------|------|
| `read` | filesystem.read, git.log, database.read | `ALLOW` | Dentro del workspace autorizado. |
| `write` | filesystem.write, git.commit | `ALLOW` | Solo dentro del alcance del proyecto del agente. |
| `execute` | terminal.execute, test.run | `ASK` | Para categorías peligrosas de comandos (§5). |
| `network` | http.get, web.search, api.call | `DENY` | Allowlist obligatoria (§7). |
| `destructive` | filesystem.delete, git.reset, git.push.force | `DENY` / `ASK` | Requiere política explícita y aprobación. |
| `deploy` | deploy.staging, deploy.production | `ASK` | Producción requiere aprobación explícita (§10.7). |
| `secret` | secret.read, acceso a `.env` | `DENY` | Solo vía Secret Broker (§8). |

### 2.4 Evaluación de una solicitud y escalada

```text
Agent Request
  ↓
Resource (¿cuál y de quién?)
  ↓
Risk Classification (tabla 2.3)
  ↓
Policy (matriz del agente, §3)
  ↓
Permission (ALLOW | ASK | DENY)
  ↓
Audit (evento tipado, véase ADR-014)
```

- **Sin auto-escalada**: un agente denegado no puede modificar configuración para concederse
  permisos. Escalada legítima: `Agente → Orquestador → Aprobación humana → permiso temporal (expires)`
  (véase ADR-009, ADR-010).
- **Permiso temporal**: autoriza UNA acción concreta, con `scope`, `expires_at` (o `after_task: true`)
  y registro en auditoría. La expiración equivale a NO aprobado; el silencio nunca es autorización
  (véase ADR-010).
- **Aprobación humana**: flujo `REQUEST → WAITING_APPROVAL → APPROVE | REJECT | REQUEST_CHANGES`;
  cada solicitud lleva acción, riesgo, razón, impacto, recursos afectados, estrategia de rollback y
  `expires_at` (véase ADR-010).

> **Regla**: una aprobación autoriza una sola acción concreta; expira, se audita y nunca se hereda.

---

## 3. Matriz de permisos baseline por agente

Baseline de mínimo privilegio (véase ADR-003, ADR-009; consolida `05-tools/permissions.md` y
`19-runtime/runtime-permissions.md`). Valores: `A` = ALLOW, `R` = ASK/controlled, `-` = DENY/NONE.

| Agente | fs read | fs write | terminal | git read | branch/commit | git push | network | deploy | secrets | destructive |
|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| analyst | A | - | allowlist (grep, find, git) | A | - | - | limitado | - | - | - |
| architect | A | `docs/**`, diseño | - | A | - | - | limitado | - | - | - |
| researcher | A | notas (`docs/research/**`) | - | A | - | - | A (allowlist) | - | - | - |
| developer | A | `src/**`, `tests/**` | comandos de desarrollo | A | branch_create, commit (R) | R | controlado | - | - | - |
| tester | A | `tests/**` (controlado) | comandos de test | A | - | - | controlado | - | - | - |
| reviewer | A | - | restringido (verificaciones) | A | - | - | - | - | - | - |
| security | A | reportes | controlado (herramientas de seguridad) | A | - | - | controlado | - | - | - |

Notas de la matriz:

- **analyst / reviewer / tester**: solo lectura del repositorio; su evidencia son artefactos
  (véase ADR-013), no escrituras.
- **developer**: único agente de ejecución con escritura sobre código y tests, `git.branch.create` y
  `git.commit` controlados; nunca push, rebase, delete ni force-push (véase §9).
- **tester**: escritura limitada al caso en que el workflow autorice crear tests; no modifica
  producción para ocultar un fallo de test.
- **security**: participa solo cuando `security_sensitive == true` (véase ADR-003); produce hallazgos
  como agente y se hace cumplir como servicio (gates G5).
- **Default**: cualquier combinación no listada → `DENY`.

> **Regla**: los permisos se comprueban en la capa de runtime/tool, no en los prompts
> (véase ADR-009).

---

## 4. Registro de herramientas (Tool Registry)

Una herramienta es **una capacidad de ejecución, no una autorización**. La autorización la decide el
modelo de permisos. Toda herramienta disponible debe estar registrada; los agentes no asumen que una
herramienta existe porque conceptualmente sería útil.

### 4.1 Modelo de herramienta

| Campo | Descripción |
|-------|-------------|
| `id` | Identificador único y versionado, p.ej. `filesystem.read@1.0` |
| `purpose` | Para qué existe |
| `inputs` / `outputs` | Esquemas de entrada y salida |
| `capabilities` | Qué sabe hacer |
| `permissions` | Qué autorizaciones requiere |
| `risk` | Nivel de riesgo (`low | medium | high | critical`) |
| `constraints` | Restricciones de uso (workspace, no mutar, límites) |
| `audit` | `enabled: true` + campos de registro (§4.4) |

### 4.2 Categorías

```text
filesystem | terminal | git | testing | quality | package-management | search
documentation | memory | network | database | deployment | observability
```

Riesgo de referencia por dominio (baseline):

| Categoría | Operación | Riesgo |
|-----------|-----------|--------|
| filesystem | read | LOW |
| filesystem | write | MEDIUM |
| filesystem | delete | HIGH (MVP: controles adicionales) |
| terminal | execute | HIGH (requiere allowlist, cwd, timeout, límites, logging) |
| package-management | read | LOW |
| package-management | install | MEDIUM (justificación obligatoria) |
| package-management | remove | HIGH |
| network | http.get/post, web.search | MEDIUM / HIGH |
| database | read | LOW |
| database | migrate / delete | HIGH (producción fuera del MVP) |
| deployment | staging | controlado |
| deployment | production / rollback | aprobación humana |

### 4.3 Descubrimiento y versionado

- El Orchestrator selecciona las herramientas **según la tarea**; el agente no recibe todo el catálogo
  automáticamente (véase ADR-002). Ejemplo: tarea "analizar arquitectura" → `filesystem.read`,
  `git.log`, `documentation.read`; tarea "implementar backend" → `filesystem.read/write`,
  `terminal.execute`, `git.diff`, `test.run`.
- Herramientas versionadas (`filesystem.read@1.0`) para reproducibilidad.
- Toda herramienta nueva justifica: necesidad, agente consumidor, permisos, riesgo, timeout,
  observabilidad y recuperación.

### 4.4 Auditoría de herramientas

Cada llamada registra `timestamp, agent, task, tool, input, result, duration, status`.
**Los secretos y datos sensibles se excluyen del logging** (véase ADR-014): redacción antes de
persistir, nunca después.

> **Regla**: una herramienta es una capacidad de ejecución; la autorización se determina por el
> sistema de permisos.

---

## 5. Terminal

`terminal.execute` es una de las herramientas más poderosas del sistema. La clasificación del comando
se decide **ANTES de ejecutarlo**; nunca se ejecuta primero y se evalúa después.

### 5.1 Clasificación de comandos

| Clase | Ejemplos | Comportamiento |
|-------|----------|----------------|
| `safe` | ls, pwd, cat, grep, find, git status, git diff, npm test, npm run lint, npm run build, pytest, go test, cargo test | `ALLOW` (allowlist) |
| `restricted` | git commit, git push, npm/pip install, chmod, chown, deploy.staging | `ASK` / política explícita |
| `dangerous` | rm -rf, git reset --hard, git push --force, git branch -D, sudo, docker, kubectl, terraform | `DENY` salvo aprobación humana registrada (véase ADR-010) |
| `blocked` | Exfiltración (envío de secretos a hosts no allowlist), escalada de privilegios, mutación de producción | `DENY` permanente |

### 5.2 Controles obligatorios

| Control | Especificación |
|---------|----------------|
| allow/deny policy | Lista por entorno y por agente; default `DENY`. |
| working-directory restriction | El comando corre en el workspace del proyecto (§10.5). |
| timeout | Default `30s`, máximo `300s` (véase ADR-007). |
| environment filtering | No se pasan secretos al subproceso; variables permitidas explícitas. |
| resource limits | Límites de CPU/memoria/espacio según política del proyecto. |
| aprobación para destructivo | `DENY/ASK` con aprobación humana (véase ADR-010). |
| captura y logging | stdout/stderr capturados; eventos `tool.called` / `tool.completed` (véase ADR-014). |

> **Regla**: la clasificación del comando ocurre antes de ejecutarlo; el prompt no puede reclasificar.

---

## 6. Filesystem

### 6.1 Validación de rutas

Toda ruta que provee un agente es **input no confiable**. Antes de leer o escribir:

```text
normalize → resolve → check allowed root → check permission → execute
```

| Paso | Qué valida |
|------|-----------|
| normalize | Elimina `..`, `.`, separadores redundantes y caracteres especiales. |
| resolve | Resuelve symlinks; la ruta final real debe quedar dentro de la raíz permitida. |
| allowed root | Dentro del workspace/proyecto autorizado; nunca fuera (ni `/`, ni homes, ni otros proyectos). |
| permission | Matriz del agente sobre ese recurso (§3). |
| execute | Recién aquí se ejecuta la operación. |

### 6.2 Amenazas a mitigar

- Escapes `../../outside-workspace`.
- Symlink escape (enlace que apunta fuera de la raíz permitida).
- Rutas sensibles ocultas (`env`, `.ssh`, `.aws`, `credentials`, `*.pem`, `production config`):
  denegadas por defecto.
- Acceso cruzado entre proyectos (aislamiento obligatorio, véase ADR-015).

> **Regla**: la ruta proporcionada por el agente es input no confiable; la validación vive en la
> capa de runtime, no en el prompt.

---

## 7. Red

El acceso a red es una capacidad especial, **restringida por defecto**:

```yaml
network:
  enabled: false
  allowed_hosts: []
  allowed_ports: []
```

Casos de uso legítimos (requieren allowlist explícita): instalación de paquetes, consulta de
documentación, testing de APIs, operaciones de repositorio. Controles: allowlist, política DNS,
timeouts, rate limits, proxy y logging. No se concede acceso global a Internet cuando solo se
necesita un host específico.

> **Regla**: `network` default `DENY`; cada host/port habilitado se justifica y se audita.

---

## 8. Secretos

### 8.1 Principios

Los secretos **nunca** se incrustan en prompts, se almacenan en memoria, se escriben en logs, se
commitearn al repositorio ni se incluyen en la salida del agente (véase ADR-014).

### 8.2 Acceso (cuando es imprescindible)

```text
Agent → Secret Broker → Policy → Secret
```

El agente recibe **el mínimo secreto necesario para la operación**, con vigencia limitada y rastreo
de auditoría. El acceso directo a recursos de secretos está `DENY` por defecto para todos los perfiles.

### 8.3 Flujo de exposición

Si un secreto aparece en salida/logs:

```text
detect → redact → audit → rotate (si corresponde)
```

- **detect**: escaneo de secretos en salidas, logs y diffs (también previo a `git.add`).
- **redact**: redacción antes de persistir cualquier log o artefacto.
- **audit**: incidente de seguridad registrado (§10.8).
- **rotate**: rotación del secreto expuesto; el commit con secreto es un defecto del gate pre-merge.

> **Regla**: un agente recibe el mínimo secreto necesario, por tiempo limitado y bajo auditoría;
> los secretos no pertenecen a prompts, memoria ni logs (véase ADR-014).

---

## 9. Política Git

Operaciones clasificadas en `read | write | destructive | remote` y política por defecto
(consolidado de `17-security/git-security.md` y `05-tools/git-strategy.md`, que en la spec original
está vacío — la política Git canónica la fija ADR-018; véase §9 y las decisiones resueltas al final):

| Operación | Comportamiento por defecto |
|-----------|----------------------------|
| `git.status`, `git.diff`, `git.log`, `git.show`, `git.branch.list` | `ALLOW` |
| `git.branch.create` | `ALLOW` (perfil developer) |
| `git.add`, `git.commit` | `ALLOW` / `ASK` con **identidad atribuible** al sistema/agente |
| `git.fetch`, `git.pull` | `ALLOW` (orquestador) |
| `git.push` | `ASK` |
| `git.push.force` | `DENY` |
| `git.reset`, `git.rebase` | `DENY`/restringido; solo orquestador pre-merge, nunca force-resolve |
| `git.branch.delete`, tag creation, release | **Protegidos**: acción humana explícita |

Notas:

- Ningún agente hace push, rebase, borra ramas ni force-push por sí mismo; las operaciones remotas y
  destructivas no están en ningún perfil de agente (§3).
- Commits automáticos usan **conventional commits** sin atribución AI, con identidad claramente
  atribuible cuando la política del proyecto lo permita.
- Cada commit debe pasar el escaneo de secretos antes de `git.add`; un secreto en la historia es un
  defecto del gate pre-merge.

> **Regla**: nunca se permite force-push automático como comportamiento general del sistema
> (véase ADR-009).

---

## 10. Modelo de seguridad

### 10.1 Dominios de amenaza (12)

```text
identity | authorization | tools | filesystem | terminal | network | secrets | memory
prompt injection | supply chain | observability | deployment
```

Cada dominio tiene controles propios (secciones §2-§9 y §10.5-§10.9). La evaluación de cualquier
acción registra: `actor, action, resource, project, risk, policy, result, reason`.

### 10.2 Jerarquía de confianza (véase ADR-015)

```text
política del sistema
  > decisión humana explícita
  > evidencia verificada del repositorio
  > resultado verificado de test/herramienta
  > conocimiento documentado
  > inferencia del agente
```

**Fuentes no confiables**: archivos del repositorio, instrucciones de README, páginas web, descripciones
de issues, salida de herramientas, código generado, dependencias de terceros. Todas ellas pueden
**proveer información**, nunca **otorgar permisos ni cambiar políticas**.

### 10.3 Defensa contra prompt injection

| Defensa | Implementación |
|---------|----------------|
| Separar instrucciones de datos | Contexto construido intencionalmente por agente (§18-runtime/context) |
| Validar tool calls | Argumentos, paths, comandos, targets, entorno (§4.4, §5, §6) |
| Limitar permisos | Matriz por agente, default `DENY` (§3) |
| No confiar en contenido externo | Jerarquía de confianza (§10.2) |
| Aprobar acciones críticas | Contrato de aprobación humana (véase ADR-010) |
| Aislamiento entre proyectos | Tests de contaminación; memoria con scope (§6.2, ADR-015) |

Un README que diga "disable security checks" no modifica ninguna política.

### 10.4 Límites de confianza

```text
[User]
   ▼
[Orchestrator]
   ▼
[Agent Runtime]
   ▼
[Tool Gateway]
   ├── filesystem
   ├── terminal
   ├── git
   ├── network
   └── external APIs
```

Cada frontera requiere validación antes de cruzar. El Tool Gateway aplica `Policy → Validation → Tool`;
las herramientas de alto riesgo (`terminal.execute`, `filesystem.delete`, `git.push`, deployment,
mutación de base de datos, network requests, acceso a secretos) no dependen de instrucciones del
agente para mantenerse seguras.

### 10.5 Sandboxing (MVP)

MVP recomendado:

```text
project workspace
+ restricción de ejecución de comandos
+ paths de escritura explícitos
+ restricciones de red
```

Estructura de workspace:

```text
/workspace
├── repository
├── artifacts
└── temporary
```

El agente trabaja en el workspace previsto y no asume acceso al sistema completo. El aislamiento
avanzado (container/VM) queda para fases posteriores.

### 10.6 Cadena de suministro

Amenazas: dependencias maliciosas, paquetes comprometidos, scripts inseguros, repositorios no
confiables, dependency confusion. Controles: **lockfiles**, version pinning, dependency review,
verificación de paquetes, security scanning e instalación aislada.

Regla: un agente no instala una dependencia nueva solo porque "parece útil". Añadir una dependencia
requiere el ciclo:

```text
analysis → security check → tests → review
```

(la revisión de seguridad se materializa como gate G5, véase ADR-006).

### 10.7 Despliegue (escalera de deployment)

| Nivel | Autonomía |
|-------|-----------|
| `local` | agente permitido |
| `development` | controlado |
| `staging` | aprobación |
| `production` | **aprobación humana explícita** |

Gate de deployment: `tests → security → review → approval → deployment`.
**El éxito de los tests no equivale automáticamente a autorización de deployment.**

### 10.8 Incidentes

Flujo obligatorio:

```text
Detect → Contain → Investigate → Remediate → Verify → Document
```

Registro de incidente: `id, severity, detection, affected_scope, containment, root_cause,
remediation, lessons`. Ejemplos: exposición de secretos, bypass de permisos, comando malicioso,
leakage entre proyectos, prompt injection exitoso, compromiso de supply chain.
Los incidentes alimentan los datasets de evaluación y regresión (§11).

### 10.9 Gobernanza y versionado de políticas

Toda política crítica se versiona:

```yaml
policy:
  id:
  version:
  effective_at:
  owner:
  changes:
```

- Propietarios definidos para: policy, permissions, secrets, incident response, dependency security,
  deployment.
- Cambios de seguridad se evalúan con `review → tests → regression → audit`.
- **Una política crítica no cambia silenciosamente como efecto secundario de un prompt o workflow.**
  Todo cambio de política es una ADR nueva (véase ADR-000, directrices 1-3).

> **Regla**: una política crítica no se modifica como efecto secundario; se versiona, se revisa y se
> aprueba (véase ADR-000).

---

## 11. Testing de seguridad obligatorio

Categorías: `unit | integration | policy | adversarial | penetration | regression`.

**Casos obligatorios** (cada uno debe tener prueba que pase):

| Caso | Qué verifica |
|------|--------------|
| unauthorized tool call | Llamada a herramienta sin permiso → `DENY` + evento de auditoría |
| path traversal | `../../` y symlinks fuera de raíz → bloqueado |
| command injection | Entrada del agente no puede inyectar comandos |
| secret leakage | Secretos no aparecen en prompts, logs, memoria ni salida |
| prompt injection | Contenido hostil no cambia permisos ni política |
| memory poisoning | Datos no verificados no se promueven a memoria global |
| cross-project access | Aislamiento entre proyectos |

**Regresión de seguridad**: cada vulnerabilidad corregida se convierte en caso de regresión
permanente.

```text
Incident → Test Case → Golden Dataset → Permanent Regression
```

> **Regla**: cada vulnerabilidad corregida produce un caso de regresión permanente; la autonomía solo
> aumenta cuando los controles demuestran que la soportan.

---

## 12. Checklist de aplicación (MVP de seguridad)

- [ ] Permisos aplicados en runtime (no solo en prompts).
- [ ] Acciones peligrosas controladas (`DENY`/`ASK` con aprobación registrada).
- [ ] Secretos ausentes de contexto, logs y salida de agentes.
- [ ] Proyectos aislados (sin acceso cruzado).
- [ ] Casos de testing de seguridad (§11) pasando.
- [ ] Incidentes auditables con la cadena de correlación (véase ADR-014).
- [ ] Políticas versionadas con `id, version, effective_at, owner, changes`.

---

## Decisiones resueltas

- **Política Git canónica** (`docs/05-tools/git-strategy.md` vacío en la spec original): **Resuelto**
  (véase ADR-018). Se adopta `agent-system/docs/git-strategy.md` como política Git canónica del
  framework, citada formalmente en §9: rama por tarea `task/<task-id>`, conventional commits atómicos
  sin atribución AI, sync antes de merge, squash-merge con referencia a la tarea, destructivas solo
  con grant temporal humano y `runtime/` git-ignored.
- **Identidad del agente en Git**: **Resuelto** (véase ADR-018): la identidad de committer es **humana
  del repositorio** (configurada por el humano); el agente nunca setea la propia. La trazabilidad
  queda vía tarea (squash) y documentación (ADR-013/016). El formato canónico se materializa en la
  plantilla `templates/AGENTS.md` generada por el bootstrap (ADR-012/016): el AGENTS.md canónico del
  proyecto es el que instala el bootstrap.
- **Número de documento**: **Resuelto**: el mapa de `framework/README.md` ya fue reconciliado
  (06=Permisos y Seguridad, 07=Memoria, 08=Calidad); el índice del framework coincide con la
  numeración real de los documentos publicados.
