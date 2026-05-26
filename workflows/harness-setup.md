---
description: Configure Cascade MEMORY[user_global] for Harness workflow support
---

# Harness Setup

Workflow para configurar Cascade MEMORY[user_global] con las reglas necesarias para usar el Harness.

**Integración con Windsurf:**
- Usa create_memory para configurar reglas de comportamiento
- Configura filosofía del Harness en MEMORY[user_global]
- Configura reglas de sintaxis específicas

## Variables
- None (automático)

## 1) Verificar si .cascade-harness existe
```powershell
$ErrorActionPreference = 'Stop';

if (-not (Test-Path ".cascade-harness")) {
    Write-Host "✗ .cascade-harness does not exist. Please install the Harness first.";
    Write-Host "Run: /harness-install or install-harness.ps1";
    exit 1;
}

Write-Host "✓ .cascade-harness exists";
```

## 2) Cascade: Configurar filosofía del Harness
Cascade debe agregar la siguiente regla a MEMORY[user_global]:

**Título:** `Filosofía del Harness - Comportamiento con workflows`

**Contenido:**
```
Filosofía del Harness: Los workflows son herramientas para el usuario, no automatización para Cascade. Solo aplica esto si .cascade-harness/ existe en el proyecto. Cuando el usuario invoque un workflow (/harness-context, /harness-validate, etc.), usa el resultado generado para mejorar tu análisis. Si el usuario te pide leer archivos de .cascade-harness/memory/, hazlo para obtener contexto del proyecto. Los workflows generan esquemas ASCII para facilitar la comprensión visual del estado. Si .cascade-harness/ no existe, ignora cualquier referencia a Harness workflows.
```

**Tags:** `harness, philosophy, workflows, behavior`

**CorpusNames:** `[Nombre del proyecto actual]`

**Action:** `create`

**UserTriggered:** `true`

## 3) Cascade: Configurar regla de PowerShell
Cascade debe agregar la siguiente regla a MEMORY[user_global]:

**Título:** `PowerShell - Sintaxis de comandos`

**Contenido:**
```
En PowerShell, usa punto y coma (;) para encadenar comandos, NO uses &&. Ejemplo correcto: comando1; comando2; comando3. Ejemplo incorrecto: comando1 && comando2 && comando3.
```

**Tags:** `powershell, commands, syntax`

**CorpusNames:** `[Nombre del proyecto actual]`

**Action:** `create`

**UserTriggered:** `true`

## 4) Mostrar esquema ASCII de configuración
```powershell
Write-Host "";
Write-Host "=== HARNESS SETUP COMPLETE ===" -ForegroundColor Cyan;
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         MEMORY CONFIGURED           │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Harness Philosophy: ✓ Added        │";
Write-Host "│ PowerShell Syntax: ✓ Added          │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "Cascade will now:";
Write-Host "- Use Harness workflow results when invoked";
Write-Host "- Use ; instead of && in PowerShell commands";
Write-Host "- Ignore Harness references if .cascade-harness/ doesn't exist";
Write-Host "";
Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')";
```

## 5) Verificar configuración
Cascade debe verificar que las reglas se agregaron correctamente:
- Buscar "Filosofía del Harness" en MEMORY[user_global]
- Buscar "PowerShell - Sintaxis de comandos" en MEMORY[user_global]

## Resultado
- MEMORY[user_global] configurada con filosofía del Harness
- MEMORY[user_global] configurada con regla de PowerShell
- Cascade usa resultados de workflows cuando se invocan
- Cascade usa sintaxis correcta de PowerShell
- Configuración persistente entre sesiones
