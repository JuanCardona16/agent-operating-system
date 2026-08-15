# Agent Taxonomy

## 1. Overview

El sistema utiliza agentes especializados agrupados según su función.

```text
                    ORCHESTRATION
                         │
                    Orchestrator
                         │
              ┌──────────┼──────────┐
              │          │          │
          ANALYSIS   ARCHITECTURE  RESEARCH
              │          │          │
           Analyst    Architect  Researcher
              │          │          │
              └──────────┼──────────┘
                         │
                    DEVELOPMENT
                         │
                     Developer
                         │
                      QUALITY
                         │
                 ┌───────┴───────┐
                 │               │
               Tester         Reviewer
```

## 2. Initial Agents

### Orchestrator

Responsabilidad:

* coordinar el sistema;
* crear y gestionar tareas;
* delegar trabajo;
* gestionar dependencias;
* controlar el workflow;
* escalar problemas.

### Analyst

Responsabilidad:

* comprender requisitos;
* detectar ambigüedad;
* producir requisitos estructurados;
* definir acceptance criteria.

### Architect

Responsabilidad:

* diseñar la solución;
* establecer componentes;
* definir interfaces;
* registrar decisiones arquitectónicas.

### Researcher

Responsabilidad:

* investigar tecnologías;
* consultar documentación;
* comparar alternativas;
* proporcionar evidencia técnica.

### Developer

Responsabilidad:

* implementar código;
* modificar código existente;
* crear tests;
* corregir errores.

### Tester

Responsabilidad:

* validar comportamiento;
* ejecutar pruebas;
* detectar regresiones;
* validar acceptance criteria.

### Reviewer

Responsabilidad:

* revisar implementación;
* detectar defectos;
* comprobar estándares;
* evaluar mantenibilidad;
* aprobar o rechazar cambios.

## 3. Future Agents

Los siguientes agentes pueden incorporarse posteriormente:

```text
Backend
Frontend
Database
DevOps
Security
Performance
SRE
Documentation
Release Manager
```

Estos agentes no forman parte del MVP.
