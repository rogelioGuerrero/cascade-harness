---
description: Capture project context (Flow Awareness) - files, git state, recent changes using Windsurf MCP
---

# Harness Context Capture

Captura el estado actual del proyecto para que Cascade entienda el contexto sin explicación explícita.

**Integración con Windsurf:**
- Usa MCP filesystem para acceso a archivos
- Usa MCP memory de Windsurf para persistencia
- Cascade puede usar sequential-thinking MCP para análisis complejo

## Variables
- None (automático)

## 1) Capturar estado de Git
```powershell
$ErrorActionPreference = 'Stop';
$gitBranch = git branch --show-current 2>$null;
$gitStatus = git status --short 2>$null;
$gitLog = git log -5 --oneline 2>$null;
Write-Host "=== GIT STATE ===";
Write-Host "Branch: $gitBranch";
Write-Host "Status: $gitStatus";
Write-Host "Recent commits: $gitLog";
```

## 2) Detectar archivos recientes usando filesystem MCP
```powershell
# Cascade puede usar MCP filesystem para listar archivos
# Aquí usamos comando directo como fallback
$recentFiles = Get-ChildItem -Recurse -File -Exclude node_modules,.git,.venv,dist,build | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -First 10 | 
    Select-Object FullName, LastWriteTime, Length;
Write-Host "=== RECENT FILES ===";
$recentFiles | Format-Table -AutoSize;
```

## 3) Detectar stack del proyecto
```powershell
Write-Host "=== PROJECT STACK ===";
$stackFiles = @("package.json", "requirements.txt", "pom.xml", "build.gradle", "Cargo.toml", "go.mod");
$detectedStack = @();
foreach ($file in $stackFiles) {
    if (Test-Path $file) {
        Write-Host "Found: $file";
        Get-Content $file -Head 5;
        $detectedStack += $file;
    }
}
```

## 4) Guardar snapshot en MCP memory de Windsurf
```powershell
# Guardar snapshot localmente también como backup
$snapshotDir = ".cascade-harness\memory\snapshots";
New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null;
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss";
$snapshotFile = "$snapshotDir\context_$timestamp.json";
$context = @{
    timestamp = Get-Date -Format "o";
    gitBranch = $gitBranch;
    gitStatus = $gitStatus;
    gitLog = $gitLog;
    recentFiles = $recentFiles.FullName;
    stack = $detectedStack;
};
$context | ConvertTo-Json -Depth 10 | Out-File $snapshotFile -Encoding utf8;
Write-Host "Local snapshot saved to: $snapshotFile";

# Cascade debe guardar este contexto en MCP memory de Windsurf
# usando create_memory con tags: harness, context, snapshot
Write-Host "Cascade: Use create_memory to store this context in Windsurf memory";
Write-Host "Tags: harness, context, snapshot, project-state";
```

## 5) Cascade: Usar sequential-thinking para análisis
Cascade debe usar MCP sequential-thinking para:
- Analizar el contexto capturado
- Identificar patrones en los archivos recientes
- Inferir el propósito actual del proyecto
- Detectar posibles problemas o áreas de mejora

## Resultado
- Snapshot local en `memory/snapshots/`
- Contexto persistente en MCP memory de Windsurf
- Cascade tiene comprensión profunda del estado del proyecto
