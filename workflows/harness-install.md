---
description: Install Cascade Engineering Harness from GitHub in current project
---

# Harness Install

Workflow para instalar el Cascade Engineering Harness desde GitHub en el proyecto actual.

**Integración con Windsurf:**
- Usa comandos git para clonar desde GitHub
- Usa MCP filesystem para copiar archivos
- Ejecuta /harness-check para verificar instalación

## Variables
- GitHubRepo: URL del repositorio de GitHub (default: https://github.com/rogelioGuerrero/cascade-harness.git)
- Force: Sobrescribir si ya existe (default: false)

## 1) Verificar si .cascade-harness ya existe
```powershell
$ErrorActionPreference = 'Stop';
$GitHubRepo = "https://github.com/rogelioGuerrero/cascade-harness.git";

if (Test-Path ".cascade-harness") {
    Write-Host ".cascade-harness already exists.";
    Write-Host "ACTION: Remove .cascade-harness manually or use Force parameter";
    Write-Host "Command: Remove-Item -Recurse -Force .cascade-harness";
    exit 1;
}
```

## 2) Clonar desde GitHub
```powershell
Write-Host "Cloning Harness from GitHub...";
git clone $GitHubRepo .cascade-harness;

if (-not $?) {
    Write-Host "Failed to clone from GitHub.";
    Write-Host "ACTION: Check GitHub URL and git installation";
    exit 1;
}

Write-Host "✓ Cloned successfully";
```

## 3) Crear estructura .windsurf/workflows/
```powershell
if (-not (Test-Path ".windsurf")) {
    New-Item -ItemType Directory -Path ".windsurf" -Force | Out-Null;
}

if (-not (Test-Path ".windsurf\workflows")) {
    New-Item -ItemType Directory -Path ".windsurf\workflows" -Force | Out-Null;
}

Write-Host "✓ .windsurf/workflows/ created";
```

## 4) Copiar workflows
```powershell
Write-Host "Copying workflows to .windsurf/workflows/...";
Copy-Item -Path ".cascade-harness\workflows\*" -Destination ".windsurf\workflows\" -Recurse -Force;
Write-Host "✓ Workflows copied";
```

## 5) Crear directorios requeridos
```powershell
Write-Host "Creating required directories...";
$requiredDirs = @(
    ".cascade-harness\patterns",
    ".cascade-harness\memory\snapshots",
    ".cascade-harness\memory\validation-reports",
    ".cascade-harness\memory\test-failures",
    ".cascade-harness\memory\recall-sessions",
    ".cascade-harness\memory\check-reports",
    ".cascade-harness\memory\progress-backups"
);

foreach ($dir in $requiredDirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null;
}

Write-Host "✓ Required directories created";
```

## 6) Resultado
```powershell
Write-Host "=== INSTALLATION COMPLETE ===";
Write-Host "";
Write-Host "Next steps:";
Write-Host "1. Restart Windsurf to load the workflows";
Write-Host "2. Run: /harness-check to verify installation";
Write-Host "3. Start using Cascade with the Harness enabled";
```

## Resultado
- Harness clonado desde GitHub
- Workflows copiados a .windsurf/workflows/
- Estructura de directorios creada
- Cascade puede ejecutar /harness-check para verificación
- Harness listo para usar en el proyecto actual

## Nota
Para usar este workflow, primero debes subir .cascade-harness/ a GitHub y actualizar la variable $GitHubRepo con tu URL real.
