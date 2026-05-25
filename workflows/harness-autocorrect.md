---
description: Auto-correct code based on validation failures using Windsurf MCP
---

# Harness Auto-Correction

Workflow que Cascade usa para autocorregirse basado en fallos de validación.

**Integración con Windsurf:**
- Usa MCP memory de Windsurf para leer reportes de validación
- Cascade usa sequential-thinking MCP para análisis de errores
- Usa MCP filesystem para leer archivos causantes
- Usa MCP Playwright para re-validación E2E si es necesario

## 1) Leer último reporte de validación
```powershell
$ErrorActionPreference = 'Stop';
$reportDir = ".cascade-harness\memory\validation-reports";
$latestReport = Get-ChildItem $reportDir | Sort-Object LastWriteTime -Descending | Select-Object -First 1;
if ($latestReport) {
    $report = Get-Content $latestReport.FullName | ConvertFrom-Json;
    Write-Host "Latest validation report: $($report.overall)";
} else {
    Write-Host "No validation report found. Run /harness-validate first.";
    exit 1;
}
```

## 2) Cascade: Buscar reporte en MCP memory de Windsurf
Cascade debe buscar en MCP memory el reporte de validación más reciente:
- Tags: `harness, validation, report`
- Recuperar el reporte más reciente por timestamp

## 3) Leer fallos de tests si existen
```powershell
$testFailureFile = ".cascade-harness\memory\test-failures\latest.json";
if (Test-Path $testFailureFile) {
    $testFailure = Get-Content $testFailureFile | ConvertFrom-Json;
    Write-Host "Test failures detected:";
    Write-Host $testFailure.errors;
} else {
    Write-Host "No test failures recorded.";
}
```

## 4) Determinar estrategia de corrección
```powershell
$correctionStrategy = @{
    linter = if ($report.linter.hasErrors -and (-not $report.linter.autoFixed)) { "MANUAL_FIX" } else { "OK" };
    unitTests = if ($report.unitTests.hasErrors) { "ANALYZE_AND_FIX" } else { "OK" };
    e2eTests = if ($report.e2eTests.hasErrors) { "ANALYZE_AND_FIX" } else { "OK" };
};

Write-Host "=== CORRECTION STRATEGY ===";
Write-Host "Linter: $($correctionStrategy.linter)";
Write-Host "Unit Tests: $($correctionStrategy.unitTests)";
Write-Host "E2E Tests: $($correctionStrategy.e2eTests)";
```

## 5) Cascade: Usar sequential-thinking para análisis de errores
Cascade debe usar MCP sequential-thinking para:
- Analizar los errores de linter/tests
- Identificar la causa raíz de cada error
- Determinar qué archivos necesitan corrección
- Priorizar correcciones por impacto y dificultad
- Proponer estrategias de corrección específicas

## 6) Cascade: Leer archivos causantes con MCP filesystem
Cascade debe usar MCP filesystem para:
- Leer los archivos que causan errores
- Analizar el código problemático
- Identificar patrones de error recurrentes

## 7) Cascade: Aplicar correcciones
Cascade debe:
1. Aplicar correcciones a los archivos identificados
2. Usar patrones aprendidos de MCP memory si aplican
3. Documentar las correcciones aplicadas

## 8) Loop de autocorrección
```powershell
$MaxRetries = 3;
$retryCount = 0;

while ($retryCount -lt $MaxRetries) {
    $retryCount++;
    Write-Host "=== AUTO-CORRECTION ATTEMPT $retryCount/$MaxRetries ===";
    
    # Cascade debe corregir aquí (intervención del modelo)
    # Este es un punto donde Cascade analiza y aplica cambios
    
    # Re-validar después de corrección
    # (Cascade debe ejecutar /harness-validate)
    
    # Si pasa, salir del loop
    # Si falla, continuar
}

if ($retryCount -eq $MaxRetries) {
    Write-Host "Max retries reached. Manual intervention required.";
}
```

## 9) Cascade: Guardar lecciones aprendidas en MCP memory
Si la autocorrección fue exitosa, Cascade debe crear una memoria con:

**Título:** `Auto-correction Lesson: [tipo-de-error] - $timestamp`

**Contenido:** Descripción del error, causa raíz, corrección aplicada y lecciones aprendidas

**Tags:** `harness, autocorrection, lesson, [tipo-de-error], successful`

## Resultado
- Cascade tiene un loop estructurado para autocorregirse
- Usa sequential-thinking para análisis profundo
- Usa MCP filesystem para acceder a archivos
- Guarda lecciones aprendidas en MCP memory para futura referencia
