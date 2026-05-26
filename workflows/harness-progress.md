---
description: Document project progress and lessons learned in PROGRESS.md
---

# Harness Progress

Workflow para documentar avances exitosos y lecciones aprendidas en PROGRESS.md.

**Integración con Windsurf:**
- Usa MCP filesystem para leer/escribir PROGRESS.md
- Complementa MCP memory con documentación narrativa project-specific

## Variables
- TaskType: Tipo de tarea completada (feature, bugfix, refactor, etc.)
- Description: Descripción de lo que se implementó
- Files: Archivos modificados/creados
- Lessons: Lecciones aprendidas (opcional)

## 1) Verificar si PROGRESS.md existe
```powershell
$ErrorActionPreference = 'Stop';
$progressFile = "PROGRESS.md";

if (-not (Test-Path $progressFile)) {
    Write-Host "PROGRESS.md does not exist. Creating initial structure...";
    
    $initialContent = @"
# Project Progress

## Completed Features
*No features completed yet*

## Lessons Learned
*No lessons learned yet*

## Working Components
*No components tested yet*

## Issues Resolved
*No issues resolved yet*

"@;
    
    $initialContent | Out-File $progressFile -Encoding utf8;
    Write-Host "✓ Created PROGRESS.md with initial structure";
} else {
    Write-Host "✓ PROGRESS.md exists";
}
```

## 2) Cascade: Analizar la tarea completada
Cascade debe analizar:
- Qué se implementó
- Lecciones aprendidas
- Qué componentes ahora funcionan
- Insights valiosos para futuras tareas

## 3) Leer PROGRESS.md actual
```powershell
$currentProgress = Get-Content $progressFile -Raw;
Write-Host "Current PROGRESS.md loaded";
```

## 4) Cascade: Actualizar PROGRESS.md
Cascade debe actualizar las secciones correspondientes:

**Completed Features:**
```markdown
## Completed Features
- [YYYY-MM-DD] $TaskType: $Description - Status: Tested ✓
```

**Lessons Learned:**
```markdown
## Lessons Learned
### Problem: [problema resuelto]
- Solution: [solución aplicada]
- Why it worked: [razón del éxito]
- Files involved: [archivos]
```

**Working Components:**
```markdown
## Working Components
- $ComponentName - Last tested: [YYYY-MM-DD] - Status: ✓ Working
```

**Issues Resolved:**
```markdown
## Issues Resolved
- [YYYY-MM-DD] $IssueDescription - Solution: $Solution
```

## 5) Cascade: Usar MCP filesystem para actualizar
Cascade debe usar MCP filesystem para:
- Leer el contenido actual de PROGRESS.md
- Actualizar las secciones correspondientes
- Mantener formato markdown consistente
- Guardar el archivo actualizado

## 6) Guardar backup en memory/
```powershell
$backupDir = ".cascade-harness\memory\progress-backups";
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null;
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss";
Copy-Item $progressFile "$backupDir\progress_$timestamp.md";
Write-Host "Backup saved to: $backupDir\progress_$timestamp.md";
```

## 7) Cascade: Guardar lecciones en MCP memory
Además de PROGRESS.md, Cascade debe guardar lecciones clave en MCP memory de Windsurf:

**Título:** `Lesson Learned: [tipo-de-lección] - $timestamp`

**Contenido:**
```json
{
  "taskType": "$TaskType",
  "description": "$Description",
  "lesson": "Lección aprendida específica",
  "whyItWorked": "Razón del éxito",
  "files": ["$Files"],
  "timestamp": "$timestamp"
}
```

**Tags:** `harness, lesson, learned, $TaskType, project-specific`

## 8) Mostrar esquema ASCII del progreso
```powershell
Write-Host "";
Write-Host "=== PROGRESS UPDATE ===" -ForegroundColor Cyan;
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         TASK COMPLETED              │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Type: $TaskType                        │";
Write-Host "│ Description: $Description               │";
Write-Host "│ Files: $Files                          │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "┌─────────────────────────────────────┐";
Write-Host "│         PROGRESS FILE                │";
Write-Host "├─────────────────────────────────────┤";
Write-Host "│ Updated: PROGRESS.md                 │";
Write-Host "│ Backup: $backupDir\progress_$timestamp.md │";
Write-Host "└─────────────────────────────────────┘";
Write-Host "";
Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')";
```

## 9) Cascade: Consultar PROGRESS.md para futuras tareas
Cuando Cascade inicie una nueva tarea, debe:
- Leer PROGRESS.md usando MCP filesystem
- Identificar qué componentes ya funcionan
- Revisar lecciones aprendidas relevantes
- Evitar repetir errores pasados
- Construir sobre lo que ya está probado

## Resultado
- PROGRESS.md actualizado con avances y lecciones
- Backup local en memory/progress-backups/
- Lecciones clave guardadas en MCP memory
- Esquema ASCII visual del progreso
- Cascade puede consultar PROGRESS.md para eficiencia futura
- Historial narrativo del proyecto para desarrolladores
