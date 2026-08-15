#requires -Version 5.1
<#
.SYNOPSIS
    Instala el framework multiagente sobre OpenCode en un proyecto.

.DESCRIPTION
    Copia la plantilla de configuración, los agentes/comandos de este
    framework y la estructura de documentación del proyecto (docs\,
    véase ADR-016) al proyecto destino, sustituyendo los placeholders:
      {{model}}          -> modelo por defecto de los agentes
      {{framework_root}} -> raíz absoluta de la referencia "framework"
      {{project_name}}   -> nombre del directorio del proyecto

    Los archivos que ya existen en el proyecto destino se respaldan en
    .opencode-backup-<timestamp>\ (a menos que se use -Force).

.PARAMETER ProjectPath
    Ruta del proyecto donde instalar. Por defecto: directorio actual.

.PARAMETER Model
    Identificador del modelo a usar por defecto en los agentes.
    Ejemplo: "anthropic/claude-sonnet-4-5" o el modelo instalado en OpenCode.

.PARAMETER Force
    Sobrescribe los archivos existentes sin crear respaldo.

.EXAMPLE
    .\bootstrap.ps1 -ProjectPath C:\proyectos\mi-app -Model "anthropic/claude-sonnet-4-5"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [string]$Model = "<model>",

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$TemplatesRoot = $PSScriptRoot
$FrameworkRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path -LiteralPath $TemplatesRoot)) {
    throw "No se encuentra la carpeta de plantillas: $TemplatesRoot"
}

$FullProjectPath = [System.IO.Path]::GetFullPath($ProjectPath)
if (-not (Test-Path -LiteralPath $FullProjectPath)) {
    throw "El directorio del proyecto no existe: $FullProjectPath"
}

$ProjectName = Split-Path -Leaf $FullProjectPath

$TemplateFiles = @(
    @{ Source = 'opencode.json';        Destination = 'opencode.json' }
    @{ Source = 'AGENTS.md';            Destination = 'AGENTS.md' }
    @{ Source = 'agents\analyst.md';    Destination = '.opencode\agents\analyst.md' }
    @{ Source = 'agents\architect.md';  Destination = '.opencode\agents\architect.md' }
    @{ Source = 'agents\researcher.md'; Destination = '.opencode\agents\researcher.md' }
    @{ Source = 'agents\developer.md';  Destination = '.opencode\agents\developer.md' }
    @{ Source = 'agents\tester.md';     Destination = '.opencode\agents\tester.md' }
    @{ Source = 'agents\reviewer.md';   Destination = '.opencode\agents\reviewer.md' }
    @{ Source = 'agents\security.md';   Destination = '.opencode\agents\security.md' }
    @{ Source = 'commands\task.md';         Destination = '.opencode\commands\task.md' }
    @{ Source = 'commands\analyze.md';      Destination = '.opencode\commands\analyze.md' }
    @{ Source = 'commands\design.md';       Destination = '.opencode\commands\design.md' }
    @{ Source = 'commands\implement.md';    Destination = '.opencode\commands\implement.md' }
    @{ Source = 'commands\test.md';         Destination = '.opencode\commands\test.md' }
    @{ Source = 'commands\review.md';       Destination = '.opencode\commands\review.md' }
    @{ Source = 'commands\security.md';     Destination = '.opencode\commands\security.md' }
    @{ Source = 'commands\ship.md';         Destination = '.opencode\commands\ship.md' }
    @{ Source = 'docs\00-overview.md';         Destination = 'docs\00-overview.md' }
    @{ Source = 'docs\01-stack.md';            Destination = 'docs\01-stack.md' }
    @{ Source = 'docs\02-scope.md';            Destination = 'docs\02-scope.md' }
    @{ Source = 'docs\03-architecture.md';     Destination = 'docs\03-architecture.md' }
    @{ Source = 'docs\04-domain.md';           Destination = 'docs\04-domain.md' }
    @{ Source = 'docs\05-conventions.md';      Destination = 'docs\05-conventions.md' }
    @{ Source = 'docs\06-status.md';           Destination = 'docs\06-status.md' }
    @{ Source = 'docs\07-changelog.md';        Destination = 'docs\07-changelog.md' }
    @{ Source = 'docs\decisions\.gitkeep';     Destination = 'docs\decisions\.gitkeep' }
    @{ Source = 'docs\research\.gitkeep';      Destination = 'docs\research\.gitkeep' }
    @{ Source = 'docs\tasks\.gitkeep';         Destination = 'docs\tasks\.gitkeep' }
    @{ Source = 'docs\security\.gitkeep';      Destination = 'docs\security\.gitkeep' }
)

$Fails = 0
$BackupCreated = $false

foreach ($entry in $TemplateFiles) {
    $sourcePath = Join-Path $TemplatesRoot $entry.Source
    $destPath = Join-Path $FullProjectPath $entry.Destination

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Write-Warning "Plantilla faltante, se omite: $($entry.Source)"
        $Fails++
        continue
    }

    $destDir = Split-Path -Parent $destPath
    if (-not (Test-Path -LiteralPath $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    if ((Test-Path -LiteralPath $destPath) -and (-not $Force)) {
        if (-not $BackupCreated) {
            $backupDir = Join-Path $FullProjectPath ('.opencode-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            $BackupCreated = $true
            Write-Host "Backup creado en: $backupDir"
        }
        $backupFile = Join-Path $backupDir ($entry.Destination -replace '[\\/]', '__')
        Copy-Item -LiteralPath $destPath -Destination $backupFile -Force
    }

    $content = [System.IO.File]::ReadAllText($sourcePath)
    $content = $content.Replace('{{model}}', $Model)
    $content = $content.Replace('{{framework_root}}', $FrameworkRoot.Replace('\', '/'))
    $content = $content.Replace('{{project_name}}', $ProjectName)

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($destPath, $content, $utf8NoBom)
    Write-Host "Instalado: $($entry.Destination)"
}

Write-Host ""
if ($Fails -gt 0) {
    Write-Warning "Completado con $Fails plantillas omitidas por faltantes."
}

Write-Host "Framework instalado en: $FullProjectPath"
Write-Host "Referencia framework apunta a: $($FrameworkRoot.Replace('\', '/'))"
Write-Host ""
Write-Host "NOTA: Reiniciá OpenCode para que la configuración tome efecto."
if ($BackupCreated) {
    Write-Host "Archivos previos respaldados en: $backupDir"
}
