---
description: Execute before starting any task - captures context and sets up harness using Windsurf MCP
---

# Harness Task Start

Workflow que Cascade debe ejecutar automáticamente antes de comenzar cualquier tarea significativa.

**Integración con Windsurf:**
- Usa MCP filesystem para acceso a archivos
- Usa MCP memory de Windsurf para patrones
- Usa MCP sequential-thinking para análisis
- MCP servers ya están configurados en Windsurf

## 1) Capturar contexto
// turbo
Ejecuta `/harness-context` para obtener snapshot actual del proyecto.

## 2) Cascade: Detectar tipo de tarea usando sequential-thinking
Cascade debe usar MCP sequential-thinking para analizar el contexto y determinar:
- ¿Es una nueva feature? → Busca patrones en MCP memory con tags relevantes
- ¿Es un bugfix? → Analiza git log reciente y archivos modificados
- ¿Es refactor? → Analiza estructura del proyecto con MCP filesystem

## 3) Cascade: Cargar patrones relevantes desde MCP memory
Cascade debe buscar en MCP memory de Windsurf:
- Tags: `harness, pattern, [dominio-detectado]`
- Filtrar por tipo de tarea
- Recuperar patrones de arquitectura, código y configuraciones

## 4) MCP servers ya activos
Los MCP servers de Windsurf ya están configurados y disponibles:
- `filesystem` - Acceso a archivos
- `memory` - Persistencia de patrones
- `playwright` - Pruebas E2E
- `sequential-thinking` - Razonamiento complejo

No se requiere configuración adicional.

## 5) Cascade: Establecer modo de trabajo
Determinar si se necesita:
- Modo de alta validación (para cambios críticos) → Ejecutar `/harness-validate` después de cambios
- Modo rápido (para prototipos) → Saltar validaciones E2E
- Modo de aprendizaje (para explorar nuevo código) → Usar sequential-thinking extensivamente

## Resultado
Cascade está configurado con:
- Contexto completo del proyecto
- Patrones relevantes de MCP memory de Windsurf
- MCP servers activos (filesystem, memory, playwright, sequential-thinking)
- Modo de trabajo apropiado para la tarea
