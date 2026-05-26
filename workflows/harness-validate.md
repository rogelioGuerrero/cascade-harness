---
description: Execute validation loop with auto-correction using Windsurf MCP (Linter & Test Loop)
---

# Harness Validation Loop

Workflow que ejecuta el loop de validación y autocorrección automática según el pilar 4 del Engineering Harness.

**Integración con Windsurf:**
- Usa comandos directos para linter (stack-aware)
- Usa MCP Playwright para pruebas E2E
- Usa MCP memory de Windsurf para persistencia

## Variables
- MaxRetries: Número máximo de intentos de autocorrección (default: 3)
- FixLinter: Si debe auto-corregir errores de linting (default: true)
- RunUnitTests: Si debe ejecutar tests unitarios (default: true)
- RunE2ETests: Si debe ejecutar pruebas E2E con Playwright (default: false)

## 1) Ejecutar linter (comandos directos)
// turbo
```powershell
$ErrorActionPreference = 'Stop';
# Detectar stack y ejecutar linter correspondiente
if (Test-Path "package.json") {
    npm run lint 2>&1 | Tee-Object -Variable linterOutput;
} elseif (Test-Path "requirements.txt") {
    ruff check . 2>&1 | Tee-Object -Variable linterOutput;
} elseif (Test-Path "Cargo.toml") {
    cargo clippy 2>&1 | Tee-Object -Variable linterOutput;
} elseif (Test-Path "go.mod") {
    gofmt -l . 2>&1 | Tee-Object -Variable linterOutput;
} else {
    Write-Host "No linter detected for this stack";
    $linterOutput = "";
}
```

## 2) Analizar resultados del linter
```powershell
$linterErrors = if ($linterOutput -match "error|warning|fail") { $true } else { $false };
if ($linterErrors -and $FixLinter) {
    Write-Host "=== LINTER ERRORS DETECTED ===";
    Write-Host $linterOutput;
    Write-Host "Attempting auto-fix...";
    
    # Intentar auto-fix
    if (Test-Path "package.json") {
        npm run lint -- --fix 2>&1 | Tee-Object -Variable fixOutput;
    } elseif (Test-Path "requirements.txt") {
        ruff check --fix . 2>&1 | Tee-Object -Variable fixOutput;
    }
    
    # Re-validar después del fix
    if (Test-Path "package.json") {
        npm run lint 2>&1 | Tee-Object -Variable linterOutputAfter;
    } elseif (Test-Path "requirements.txt") {
        ruff check . 2>&1 | Tee-Object -Variable linterOutputAfter;
    }
    
    $linterErrorsAfter = if ($linterOutputAfter -match "error|warning|fail") { $true } else { $false };
    
    if (-not $linterErrorsAfter) {
        Write-Host "✓ Linter errors fixed successfully";
    } else {
        Write-Host "✗ Linter errors persist after auto-fix";
        Write-Host $linterOutputAfter;
    }
} else {
    Write-Host "✓ No linter errors detected";
}
```

## 3) Ejecutar tests unitarios (comandos directos)
// turbo
```powershell
if ($RunUnitTests) {
    if (Test-Path "package.json") {
        npm test 2>&1 | Tee-Object -Variable testOutput;
    } elseif (Test-Path "requirements.txt") {
        pytest 2>&1 | Tee-Object -Variable testOutput;
    } elseif (Test-Path "Cargo.toml") {
        cargo test 2>&1 | Tee-Object -Variable testOutput;
    } elseif (Test-Path "go.mod") {
        go test ./... 2>&1 | Tee-Object -Variable testOutput;
    } else {
        Write-Host "No test framework detected for this stack";
        $testOutput = "";
    }
}
```

## 4) Cascade: Ejecutar pruebas E2E con Playwright MCP
Si $RunE2ETests es true, Cascade debe:
1. Usar MCP Playwright para navegar a la aplicación
2. Ejecutar pruebas E2E según el contexto del proyecto
3. Capturar screenshots y console logs
4. Reportar resultados

Ejemplo de instrucción para Cascade:
"Usa MCP Playwright para navegar a http://localhost:3000 y verificar que la aplicación carga correctamente"

## 5) Analizar resultados de tests
```powershell
if ($RunUnitTests) {
    $testErrors = if ($testOutput -match "FAIL|failed|error") { $true } else { $false };
    $testPassed = if ($testOutput -match "PASS|passed|OK") { $true } else { $false };
    
    if ($testErrors) {
        Write-Host "=== UNIT TEST FAILURES DETECTED ===";
        Write-Host $testOutput;
        
        # Guardar información para autocorrección
        $testInfo = @{
            timestamp = Get-Date -Format "o";
            type = "unit";
            errors = $testOutput;
            needsFix = $true;
        };
        New-Item -ItemType Directory -Path ".cascade-harness\memory\test-failures" -Force | Out-Null;
        $testInfo | ConvertTo-Json | Out-File ".cascade-harness\memory\test-failures\latest.json" -Encoding utf8;
        
        Write-Host "Test failure saved to memory. Cascade will attempt to fix.";
    } elseif ($testPassed) {
        Write-Host "✓ All unit tests passed";
    } else {
        Write-Host "? Unable to determine test status";
    }
}
```

## 6) Generar reporte de validación
```powershell
$report = @{
    timestamp = Get-Date -Format "o";
    linter = @{
        hasErrors = $linterErrors;
        autoFixed = (-not $linterErrorsAfter) -and $linterErrors;
    };
    unitTests = @{
        ran = $RunUnitTests;
        passed = $testPassed;
        hasErrors = $testErrors;
    };
    e2eTests = @{
        ran = $RunE2ETests;
        # Cascade debe llenar esto después de usar Playwright
        passed = $null;
        hasErrors = $null;
    };
    overall = if ((-not $linterErrors) -and ($testPassed -or (-not $RunUnitTests))) { "PASS" } else { "FAIL" };
};

# Guardar localmente
New-Item -ItemType Directory -Path ".cascade-harness\memory\validation-reports" -Force | Out-Null;
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss";
$report | ConvertTo-Json -Depth 10 | Out-File ".cascade-harness\memory\validation-reports\report_$timestamp.json" -Encoding utf8;

Write-Host "=== VALIDATION REPORT ===" -ForegroundColor Cyan;
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         VALIDATION SUMMARY           │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Overall: $($report.overall)                      │";
Write-Host "│ Linter: $(if ($report.linter.hasErrors) { 'FAIL' } else { 'PASS' })                         │";
Write-Host "│ Unit Tests: $(if ($report.unitTests.ran) { if ($report.unitTests.passed) { 'PASS' } else { 'FAIL' } } else { 'SKIPPED' })                │";
Write-Host "│ E2E Tests: $(if ($report.e2eTests.ran) { if ($report.e2eTests.passed) { 'PASS' } else { 'FAIL' } } else { 'SKIPPED' })                 │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "Local report saved to: .cascade-harness\memory\validation-reports\report_$timestamp.json";

# Cascade debe guardar este reporte en MCP memory de Windsurf
Write-Host "Cascade: Use create_memory to store this validation report in Windsurf memory";
Write-Host "Tags: harness, validation, report, quality";
```

## Resultado
- Ejecuta linter y tests unitarios automáticamente
- Puede ejecutar pruebas E2E con Playwright MCP
- Intenta auto-corregir errores de linting
- Guarda reportes en memory local y MCP memory de Windsurf
