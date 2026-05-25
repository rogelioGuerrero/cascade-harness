---
description: Recall and apply learned patterns from Windsurf MCP memory
---

# Harness Pattern Recall

Workflow que Cascade usa para recuperar y aplicar patrones aprendidos de MCP memory de Windsurf (persistente entre proyectos).

**Integración con Windsurf:**
- Usa MCP memory de Windsurf para buscar patrones
- Cascade usa sequential-thinking MCP para análisis de patrones
- Backup local en patterns/ por seguridad
- Búsqueda por dominio y query

## Variables
- Domain: Dominio del patrón a buscar (authentication, api, database, etc.)
- Query: Query de búsqueda específica

## 1) Cascade: Buscar patrones en MCP memory de Windsurf
Cascade debe usar el sistema de memorias de Windsurf para buscar patrones:

**Tags a buscar:** `harness, pattern, $Domain, learned`

**Query:** Si se proporciona $Query, Cascade debe buscar también en el contenido de las memorias

Cascade debe usar las herramientas de memoria para:
1. Buscar memorias con tags relevantes
2. Filtrar por dominio si se especifica
3. Buscar por query en el contenido si se especifica

## 2) Cascade: Usar sequential-thinking para análisis
Cascade debe usar MCP sequential-thinking para:
- Analizar los patrones recuperados
- Determinar cuál es más aplicable al contexto actual
- Identificar adaptaciones necesarias
- Priorizar patrones por relevancia

## 3) Backup local (opcional)
```powershell
$ErrorActionPreference = 'Stop';
# Guardar sesión de recall localmente como backup
$recallResult = @{
    timestamp = Get-Date -Format "o";
    query = $Query;
    domain = $Domain;
    source = "windsurf-mcp-memory";
};

New-Item -ItemType Directory -Path ".cascade-harness\memory\recall-sessions" -Force | Out-Null;
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss";
$recallResult | ConvertTo-Json -Depth 10 | Out-File ".cascade-harness\memory\recall-sessions\recall_$timestamp.json" -Encoding utf8;

Write-Host "Recall session backup saved to local memory";
```

## 4) Cascade: Presentar y aplicar patrones
Cascade debe:
1. Presentar los patrones relevantes encontrados
2. Explicar por qué cada patrón es relevante
3. Sugerir cómo adaptar cada patrón al contexto actual
4. Proponer una implementación basada en los patrones

## 5) Cascade: Guardar nueva memoria de aplicación
Si Cascade aplica un patrón exitosamente, debe crear una nueva memoria con:

**Título:** `Pattern Applied: $domain - $timestamp`

**Contenido:** Descripción de cómo se aplicó el patrón y adaptaciones realizadas

**Tags:** `harness, pattern-applied, $domain, successful`

## Resultado
- Patrones recuperados de MCP memory de Windsurf (persistente entre proyectos)
- Análisis profundo con sequential-thinking
- Cascade puede aplicar patrones de cualquier proyecto previo
- Backup local de sesiones de recall
