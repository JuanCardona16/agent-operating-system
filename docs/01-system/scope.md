# System Scope

## 1. In Scope

El sistema inicialmente cubrirá:

### Requirements

* interpretación de solicitudes;
* detección de ambigüedades;
* definición de requisitos;
* acceptance criteria.

### Planning

* descomposición de tareas;
* dependencias;
* asignación de agentes;
* orden de ejecución.

### Software Development

* lectura de código;
* modificación de código;
* creación de archivos;
* creación de tests;
* ejecución de herramientas de desarrollo.

### Quality

* testing;
* linting;
* type checking;
* code review;
* validación contra acceptance criteria.

### Knowledge

* documentación;
* decisiones arquitectónicas;
* memoria de proyecto;
* conocimiento técnico.

### Operations

* Git;
* logs;
* métricas;
* trazabilidad.

## 2. Out of Scope — MVP

Quedan fuera del MVP:

* producción completamente autónoma;
* operaciones destructivas sin aprobación;
* auto-modificación del sistema;
* auto-modificación de agentes;
* gestión autónoma de secretos;
* administración completa de infraestructura;
* entrenamiento de modelos.

## 3. Future Scope

Posteriormente podrán incorporarse:

* agentes especializados por lenguaje;
* agentes especializados por framework;
* DevOps;
* Security;
* Performance;
* Database;
* Frontend;
* Mobile;
* SRE;
* Release Management.

## 4. Criterio para añadir un agente

No se debe crear un nuevo agente únicamente porque una tarea sea diferente.

Debe existir una necesidad real de:

* conocimientos especializados;
* herramientas diferentes;
* permisos diferentes;
* ciclo de trabajo diferente;
* criterios de evaluación diferentes.

La especialización debe reducir complejidad, no aumentarla.
