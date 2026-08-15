# Tool Registry

## 1. Purpose

El Tool Registry define todas las herramientas disponibles para el sistema multiagente.

Una herramienta es una interfaz que permite a un agente interactuar con el entorno externo.

Ejemplos:

* filesystem;
* terminal;
* Git;
* test runners;
* linters;
* package managers;
* documentación;
* búsqueda;
* bases de datos;
* APIs;
* servicios externos.

Los agentes no deben asumir que una herramienta existe simplemente porque conceptualmente sería útil.

Toda herramienta disponible para el sistema debe estar registrada.

---

## 2. Tool Model

Una herramienta debe definirse mediante:

```text
Tool
├── Identity
├── Purpose
├── Inputs
├── Outputs
├── Capabilities
├── Permissions
├── Risk
├── Constraints
└── Audit
```

Ejemplo:

```yaml
tool:
  id: filesystem.read
  version: 1.0.0

  purpose: >
    Leer archivos del proyecto.

  risk_level: low

  inputs:
    - path

  outputs:
    - content

  permissions:
    - read

  constraints:
    - no modificar archivos;
    - respetar límites de workspace.
```

---

## 3. Tool Categories

Las herramientas se agrupan por dominio.

```text
filesystem
terminal
git
testing
quality
package-management
search
documentation
memory
network
database
deployment
observability
```

---

# 4. Filesystem

## 4.1 filesystem.read

Permite leer archivos.

```text
filesystem.read(path)
```

Uso:

* inspección de código;
* documentación;
* configuración;
* tests.

Riesgo:

```text
LOW
```

---

## 4.2 filesystem.write

Permite crear o modificar archivos.

```text
filesystem.write(path, content)
```

Riesgo:

```text
MEDIUM
```

Debe estar limitado mediante permisos de path.

---

## 4.3 filesystem.delete

Permite eliminar archivos.

```text
filesystem.delete(path)
```

Riesgo:

```text
HIGH
```

No debe estar disponible para todos los agentes.

En el MVP debe requerir controles adicionales.

---

# 5. Terminal

## 5.1 terminal.execute

Permite ejecutar comandos.

```text
terminal.execute(command)
```

Es una de las herramientas más poderosas del sistema.

Riesgo:

```text
HIGH
```

Debe existir:

* allowlist de comandos;
* control de working directory;
* timeout;
* límites de recursos;
* captura de stdout/stderr;
* logging.

---

## 5.2 Command Categories

Los comandos deben clasificarse.

### Safe

```text
ls
pwd
cat
grep
find
git status
git diff
```

### Development

```text
npm test
npm run lint
npm run build
pytest
cargo test
go test
```

### Potentially Dangerous

```text
rm
chmod
chown
sudo
curl
wget
docker
kubectl
terraform
```

Los comandos peligrosos requieren políticas específicas.

---

# 6. Git

Las operaciones Git se dividen en:

```text
read
write
destructive
remote
```

### Read

```text
git.status
git.diff
git.log
git.show
git.branch.list
```

### Write

```text
git.branch.create
git.add
git.commit
```

### Remote

```text
git.fetch
git.pull
git.push
```

### Destructive

```text
git.reset
git.rebase
git.branch.delete
git.push.force
```

Las operaciones destructivas deben estar restringidas.

---

# 7. Testing

El sistema debe poder ejecutar los mecanismos de validación disponibles en el proyecto.

Ejemplos:

```text
test.unit
test.integration
test.e2e
test.coverage
```

Los resultados deben registrarse como artefactos.

Ejemplo:

```yaml
result:
  status: passed
  tests: 184
  failures: 0
  duration: 32.4
```

---

# 8. Quality Tools

Ejemplos:

```text
lint
formatter
typecheck
static-analysis
security-scan
dependency-audit
```

Estas herramientas deben utilizarse como Quality Gates cuando corresponda.

---

# 9. Package Management

Ejemplos:

```text
npm
pnpm
yarn
pip
poetry
cargo
go
```

Añadir dependencias puede modificar significativamente el proyecto.

Por ello:

```text
READ → LOW
INSTALL → MEDIUM
REMOVE → HIGH
```

El agente debe justificar cambios de dependencias.

---

# 10. Search

Las herramientas de búsqueda permiten acceder a información externa.

Ejemplos:

```text
web.search
documentation.search
repository.search
```

El resultado de una investigación importante debe persistirse.

No debe depender únicamente del contexto temporal de una conversación.

---

# 11. Documentation

Herramientas para:

* leer documentación;
* generar documentación;
* actualizar referencias;
* generar reportes.

Ejemplo:

```text
documentation.read
documentation.write
documentation.validate
```

---

# 12. Memory

Las herramientas de memoria permiten:

```text
memory.search
memory.read
memory.write
memory.update
```

No todos los agentes deben poder escribir memoria global.

---

# 13. Network

El acceso a red debe considerarse una capacidad especial.

Ejemplos:

```text
http.get
http.post
web.search
api.call
```

Riesgo:

```text
MEDIUM / HIGH
```

Debe existir control sobre:

* dominios;
* métodos HTTP;
* autenticación;
* datos enviados;
* datos recibidos.

---

# 14. Database

Las operaciones de base de datos deben separarse.

```text
database.read
database.write
database.migrate
database.delete
```

El acceso de producción debe quedar fuera de la autonomía del MVP.

---

# 15. Deployment

Las herramientas de deployment son de alto riesgo.

Ejemplos:

```text
deploy.staging
deploy.production
rollback
```

Reglas iniciales:

```text
staging  → controlled autonomy
production → human approval
```

---

# 16. Tool Metadata

Cada herramienta debería poder describirse mediante:

```yaml
tool:
  id:
  version:
  category:
  description:

  risk_level:

  input_schema:
  output_schema:

  permissions:

  constraints:

  audit:
    enabled: true
```

---

# 17. Tool Versioning

Las herramientas deben tener versiones.

Ejemplo:

```text
filesystem.read@1.0
git.commit@1.2
test.runner@2.0
```

Esto permite reproducibilidad.

---

# 18. Tool Discovery

Un agente no debería recibir automáticamente todas las herramientas.

El Orchestrator debe seleccionar las herramientas necesarias según la tarea.

Ejemplo:

```text
Task: analizar arquitectura

→ filesystem.read
→ git.log
→ documentation.read
```

Mientras:

```text
Task: implementar backend

→ filesystem.read
→ filesystem.write
→ terminal.execute
→ git.diff
→ test.runner
```

---

# 19. Tool Audit

Las herramientas deben registrar:

```yaml
audit:
  timestamp:
  agent:
  task:
  tool:
  input:
  result:
  duration:
  status:
```

Los secretos y datos sensibles deben excluirse del logging.

---

# 20. Core Principle

Una herramienta es una capacidad de ejecución, no una autorización.

La autorización se determina mediante el sistema de permisos.
