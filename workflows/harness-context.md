---
description: Capture project context (Flow Awareness) - files, git state, recent changes using Windsurf MCP
---

# Harness Context Capture

Captura el estado actual del proyecto para que Cascade entienda el contexto sin explicación explícita.

**Integración con Windsurf:**
- Usa MCP filesystem para acceso a archivos
- Usa MCP memory de Windsurf para persistencia

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

## 6) Mostrar esquema ASCII del contexto
```powershell
Write-Host "";
Write-Host "=== PROJECT CONTEXT SNAPSHOT ===" -ForegroundColor Cyan;
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         GIT STATE                   │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Branch: $gitBranch                   │";
Write-Host "│ Status: $gitStatus                  │";
Write-Host "│ Recent: $gitLog                     │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         PROJECT STACK                │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Detected: $($detectedStack -join ', ')  │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         RECENT FILES                 │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Total: $($recentFiles.Count) files modified      │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "Snapshot saved to: $snapshotFile";
Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')";
```

## Resultado
- Snapshot local en `memory/snapshots/`
- Contexto persistente en MCP memory de Windsurf
- Esquema ASCII visual del estado del proyecto
- Cascade tiene comprensión del estado del proyecto
