---
description: Learn and store patterns from successful implementations using Windsurf MCP memory
---

# Harness Learning

Workflow que Cascade usa para aprender patrones exitosos y guardarlos en MCP memory de Windsurf para reutilizar en proyectos futuros.

**Integración con Windsurf:**
- Usa MCP filesystem para leer archivos
- Usa MCP memory de Windsurf para persistencia de patrones
- Cascade usa sequential-thinking MCP para análisis de patrones
- Backup local en patterns/ por seguridad

## Variables
- PatternType: Tipo de patrón (architecture, code, config, test)
- Description: Descripción del patrón aprendido
- Files: Archivos relacionados con el patrón

## 1) Detectar patrón exitoso
```powershell
$ErrorActionPreference = 'Stop';
Write-Host "=== PATTERN LEARNING ===";
Write-Host "Analyzing recent successful changes...";

# Obtener archivos modificados recientemente
$recentChanges = git diff --name-only HEAD~5..HEAD 2>$null;
if (-not $recentChanges) {
    $recentChanges = Get-ChildItem -Recurse -File -Exclude node_modules,.git,.venv,dist,build | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First 10 | 
        Select-Object -ExpandProperty FullName;
}

Write-Host "Recent changes:";
$recentChanges;
```

## 2) Categorizar patrón por dominio
```powershell
# Detectar dominio basado en estructura de archivos
$domain = "general";
if ($recentChanges -match "auth|login|session|jwt") {
    $domain = "authentication";
} elseif ($recentChanges -match "api|route|controller|endpoint") {
    $domain = "api";
} elseif ($recentChanges -match "database|model|schema|migration") {
    $domain = "database";
} elseif ($recentChanges -match "test|spec") {
    $domain = "testing";
} elseif ($recentChanges -match "config|env|setting") {
    $domain = "configuration";
} elseif ($recentChanges -match "ui|component|view|page") {
    $domain = "frontend";
} elseif ($recentChanges -match "docker|deploy|ci|cd") {
    $domain = "infrastructure";
}

Write-Host "Detected domain: $domain";
```

## 3) Extraer código relevante
```powershell
$patternData = @{
    timestamp = Get-Date -Format "o";
    domain = $domain;
    files = @();
    codeSnippets = @();
};

foreach ($file in $recentChanges) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue;
        if ($content) {
            $patternData.files += $file;
            # Extraer snippets relevantes (funciones, clases, configuraciones)
            $patternData.codeSnippets += @{
                file = $file;
                content = $content.Substring(0, [Math]::Min(2000, $content.Length));
            };
        }
    }
}
```

## 4) Guardar backup local
```powershell
$patternDir = ".cascade-harness\patterns\$domain";
New-Item -ItemType Directory -Path $patternDir -Force | Out-Null;
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss";
$patternFile = "$patternDir\pattern_$timestamp.json";

$patternData | ConvertTo-Json -Depth 10 | Out-File $patternFile -Encoding utf8;

Write-Host "Local backup saved to: $patternFile";
Write-Host "Domain: $domain";
Write-Host "Files analyzed: $($patternData.files.Count)";
```

## 5) Cascade: Guardar patrón en MCP memory de Windsurf
Cascade debe usar create_memory para guardar el patrón con:

**Título:** `Pattern: $domain - $timestamp`

**Contenido:**
```json
{
  "domain": "$domain",
  "timestamp": "$timestamp",
  "files": [$($patternData.files -join ', ')],
  "codeSnippets": $($patternData.codeSnippets | ConvertTo-Json -Compress),
  "description": "Pattern learned from successful implementation"
}
```

**Tags:** `harness, pattern, $domain, learned, code`

**CorpusNames:** Nombre del corpus del proyecto actual

## 6) Cascade: Usar sequential-thinking para análisis
Cascade debe usar MCP sequential-thinking para:
- Analizar por qué este patrón fue exitoso
- Identificar principios subyacentes
- Determinar cuándo es aplicable este patrón
- Extraer lecciones generalizables

## 7) Actualizar índice local (backup)
```powershell
$indexFile = ".cascade-harness\memory\pattern-index.json";
$index = if (Test-Path $indexFile) { Get-Content $indexFile | ConvertFrom-Json } else { @{ patterns = @() } };

$index.patterns += @{
    id = "$domain-$timestamp";
    domain = $domain;
    timestamp = $timestamp;
    file = $patternFile;
    filesCount = $patternData.files.Count;
    storedInMemory = $true;
};

$index | ConvertTo-Json -Depth 10 | Out-File $indexFile -Encoding utf8;

Write-Host "Local pattern index updated";
```

## Resultado
- Patrón guardado en MCP memory de Windsurf (persistente entre proyectos)
- Backup local en `patterns/{domain}/`
- Cascade puede recuperar patrones de cualquier proyecto usando MCP memory
- Análisis profundo del patrón con sequential-thinking
