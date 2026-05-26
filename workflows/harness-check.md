---
description: Verify Harness is ready and MCP servers are available
---

# Harness Check

Workflow para verificar que el Harness está completamente configurado y listo para usar por Cascade.

**Integración con Windsurf:**
- Verifica MCP servers necesarios están activos
- Verifica estructura de carpetas
- Verifica workflows en .windsurf/workflows/
- Cascade puede solicitar activación de MCP desactivados

## Variables
- None (automático)

## 1) Verificar estructura de carpetas
```powershell
$ErrorActionPreference = 'Stop';
Write-Host "=== HARNESS STRUCTURE CHECK ===";

$requiredDirs = @(
    ".cascade-harness\workflows",
    ".cascade-harness\patterns",
    ".cascade-harness\memory"
);

$allDirsExist = $true;
foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Host "✓ $dir exists";
    } else {
        Write-Host "✗ $dir missing";
        $allDirsExist = $false;
    }
}

if (-not $allDirsExist) {
    Write-Host "ERROR: Required directories missing. Please copy .cascade-harness/ to your project.";
} else {
    Write-Host "✓ All required directories exist";
}
```

## 2) Verificar workflows en .windsurf/workflows/
```powershell
Write-Host "=== WORKFLOWS CHECK ===";

$windsurfWorkflowsDir = ".windsurf\workflows";
$harnessWorkflowsDir = ".cascade-harness\workflows";

if (-not (Test-Path $windsurfWorkflowsDir)) {
    Write-Host "✗ .windsurf/workflows/ does not exist";
    Write-Host "ACTION: Copy workflows from .cascade-harness/workflows/ to .windsurf/workflows/";
    Write-Host "Command: Copy-Item -Path .cascade-harness\workflows\* -Destination .windsurf\workflows\ -Recurse";
} else {
    $requiredWorkflows = @(
        "harness-context.md",
        "harness-task-start.md",
        "harness-validate.md",
        "harness-autocorrect.md",
        "harness-learn.md",
        "harness-recall.md"
    );
    
    $missingWorkflows = @();
    foreach ($wf in $requiredWorkflows) {
        $wfPath = Join-Path $windsurfWorkflowsDir $wf;
        if (Test-Path $wfPath) {
            Write-Host "✓ $wf exists in .windsurf/workflows/";
        } else {
            Write-Host "✗ $wf missing from .windsurf/workflows/";
            $missingWorkflows += $wf;
        }
    }
    
    if ($missingWorkflows.Count -gt 0) {
        Write-Host "ACTION: Copy missing workflows from .cascade-harness/workflows/ to .windsurf/workflows/";
        Write-Host "Command: Copy-Item -Path .cascade-harness\workflows\* -Destination .windsurf\workflows\ -Recurse";
    } else {
        Write-Host "✓ All required workflows exist in .windsurf/workflows/";
    }
}
```

## 3) Verificar MCP servers (nota para usuario)
Los MCP servers de Windsurf deben estar configurados manualmente en `~/.codeium/windsurf/mcp_config.json`.

**MCP servers críticos (requeridos):**
- `filesystem` - Acceso a archivos
- `memory` - Persistencia de patrones

**MCP servers opcionales:**
- `playwright` - Pruebas E2E (solo si se necesitan)
- `sequential-thinking` - Razonamiento complejo (opcional, puede causar bloqueos)

**Acción requerida:**
Verifica que filesystem y memory estén activos en tu configuración de Windsurf. Si están inactivos, actívalos y reinicia Windsurf.

## 4) Verificar configuración de PowerShell (Windows)
```powershell
Write-Host "=== POWERSHELL CHECK ===";
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser;
if ($executionPolicy -eq "Restricted") {
    Write-Host "✗ PowerShell execution policy is Restricted";
    Write-Host "ACTION: Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser";
} else {
    Write-Host "✓ PowerShell execution policy: $executionPolicy";
}
```

## 5) Generar reporte de estado
```powershell
$checkReport = @{
    timestamp = Get-Date -Format "o";
    structure = $allDirsExist;
    workflows = ($missingWorkflows.Count -eq 0);
    powerShell = ($executionPolicy -ne "Restricted");
    overall = $allDirsExist -and ($missingWorkflows.Count -eq 0) -and ($executionPolicy -ne "Restricted");
};

New-Item -ItemType Directory -Path ".cascade-harness\memory\check-reports" -Force | Out-Null;
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss";
$checkReport | ConvertTo-Json -Depth 10 | Out-File ".cascade-harness\memory\check-reports\check_$timestamp.json" -Encoding utf8;

Write-Host "";
Write-Host "=== HARNESS CHECK REPORT ===" -ForegroundColor Cyan;
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         STRUCTURE                   │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Status: $(if ($allDirsExist) { '✓ OK' } else { '✗ FAIL' })                        │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         WORKFLOWS                   │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Status: $(if ($missingWorkflows.Count -eq 0) { '✓ OK' } else { '✗ FAIL' })                        │";
Write-Host "│ Missing: $($missingWorkflows.Count) workflows                │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         POWERSHELL                  │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Policy: $executionPolicy                   │";
Write-Host "│ Status: $(if ($executionPolicy -ne 'Restricted') { '✓ OK' } else { '✗ FAIL' })                        │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         OVERALL                     │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Status: $(if ($checkReport.overall) { '✓ READY' } else { '✗ ISSUES' })                      │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "Check report saved to: .cascade-harness\memory\check-reports\check_$timestamp.json";
```

## 6) Acciones recomendadas
Si hay problemas, Cascade debe recomendar acciones específicas:

**Si faltan workflows:**
- Copiar workflows de .cascade-harness/workflows/ a .windsurf/workflows/

**Si MCP crítico inactivo:**
- Activar en ~/.codeium/windsurf/mcp_config.json
- Reiniciar Windsurf

**Si Playwright inactivo y se necesitan E2E:**
- Activar Playwright MCP
- Cascade puede solicitar: "Necesito ejecutar pruebas E2E. Por favor activa el MCP Playwright."

**Si PowerShell restringido:**
- Ejecutar: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

## Resultado
- Verificación completa de la estructura del Harness
- Verificación de workflows en .windsurf/workflows/
- Verificación de MCP servers activos
- Acciones recomendadas si hay problemas
- Cascade puede solicitar activación de MCP según necesidad
