---
description: 'Instala el framework multiagente de OpenCode en el proyecto actual. Uso: /framework-init [modelo] [ruta-del-framework].'
---

# Framework init

Instalás el framework multiagente en el proyecto actual ejecutando el instalador `bootstrap.ps1`.

## Parámetros

- `$1` (opcional): identificador del modelo por defecto de los agentes (p. ej. `anthropic/claude-sonnet-4-5`). Si se omite, se instala con el placeholder `{{model}}` sin sustituir.
- `$2` (opcional): ruta al repositorio del framework (carpeta que contiene `templates\bootstrap.ps1`). Si se omite, se usa `$env:FRAMEWORK_ROOT` si está definida.
- `$ARGUMENTS`: contexto adicional (se ignora para la instalación).

## Resolución de la ruta del framework (sin rutas locales hardcodeadas)

1. Si `$2` se indica, es la ruta del framework.
2. Si no, usar `$env:FRAMEWORK_ROOT` (definila en el perfil de PowerShell con la ruta de tu checkout clonado, p. ej. `$env:FRAMEWORK_ROOT = "C:\dev\agent-os"`).
3. Si ninguna existe, **detenete y pedí la ruta al usuario**: no hay ruta por defecto en el comando; el repositorio clonado puede vivir en cualquier lugar.

## Pasos

1. Verificar que el proyecto actual sea un directorio válido.
2. Determinar la ruta del framework según la resolución de arriba.
3. Verificar que `<framework>\templates\bootstrap.ps1` exista; si no, avisá y detenete.
4. Ejecutar:

```powershell
& "<framework>\templates\bootstrap.ps1" -ProjectPath (Get-Location).Path -Model "<model>"
```

5. Verificar los archivos instalados: `opencode.json`, `AGENTS.md` en la raíz, 7 agentes y 8 comandos en `.opencode\`.
6. Si un destino ya existía y no se usó `-Force`, avisar que el respaldo quedó en `.opencode-backup-<timestamp>\`.
7. Recordar al usuario que reinicie OpenCode para que la configuración tome efecto.

## Salida

Resumen de archivos instalados, ruta de la referencia `framework` registrada en `opencode.json`, y aviso de reinicio.
