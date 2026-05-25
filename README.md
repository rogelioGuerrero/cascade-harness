# Cascade Engineering Harness

Harness agnóstico y reutilizable para mejorar la calidad de productos generados por Cascade en cualquier proyecto.

**Integrado con Windsurf MCP:**
- Usa MCP servers ya configurados en Windsurf (filesystem, memory, playwright, sequential-thinking)
- No requiere instalación de MCP servers adicionales
- Aprovecha el sistema de memorias de Windsurf para persistencia entre proyectos

## Filosofía

Este Harness implementa los 4 pilares de un Engineering Harness para transformar Cascade en un agente de software confiable:

1. **Flow Awareness**: Captura contexto implícito del proyecto (archivos abiertos, comandos recientes, estado actual)
2. **Tool Invocation**: Usa MCP servers de Windsurf para ejecutar acciones del proyecto
3. **Fast Context Indexing**: Usa MCP filesystem de Windsurf para acceso rápido a archivos
4. **Linter & Test Loop**: Autocorrección automática basada en validación con Playwright MCP

## Estructura

```
.cascade-harness/
├── workflows/          # Workflows para Flow Awareness y autocorrección
├── patterns/           # Patrones aprendidos por dominio (backup local)
├── memory/             # Memoria local de decisiones y configuraciones (backup)
├── README.md           # Este archivo
├── INSTALL.md          # Guía de instalación
├── USAGE.md            # Guía de uso
├── CUSTOMIZATION.md    # Personalización
└── ARCHITECTURE.md     # Arquitectura técnica
```

## Instalación en un nuevo proyecto

### Opción 1: Instalación desde GitHub (recomendada)

1. **Ejecuta el script de instalación:**
```powershell
# En la raíz de tu proyecto
.\install-harness.ps1
```

O descarga el script desde GitHub y ejecútalo:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tu-usuario/cascade-harness/main/install-harness.ps1" -OutFile "install-harness.ps1"
.\install-harness.ps1
```

2. **Reinicia Windsurf** para cargar los workflows

3. **Ejecuta `/harness-check`** para verificar la instalación

### Opción 2: Instalación manual

1. Copia la carpeta `.cascade-harness/` a la raíz de tu proyecto
2. Copia los workflows de `.cascade-harness/workflows/` a `.windsurf/workflows/`
3. Asegúrate de tener los MCP servers de Windsurf configurados (filesystem, memory, playwright, sequential-thinking)
4. Cascade usará automáticamente estos workflows y MCP servers

**No requiere instalación de dependencias adicionales** - usa los MCP servers ya configurados en Windsurf.

### Opción 3: Instalación vía Cascade workflow

Puedes pedirle a Cascade que ejecute `/harness-install` para instalar el Harness desde GitHub automáticamente.

## Auto-mejora

El Harness aprende patrones con el tiempo usando MCP memory de Windsurf:
- **MCP memory**: Almacena patrones de código exitosos por dominio (persistente entre proyectos)
- **patterns/**: Backup local de patrones por seguridad
- **memory/**: Backup local de decisiones y configuraciones
- Cascade puede consultar estos patrones en cualquier proyecto usando MCP memory

## Uso

Cascade detectará automáticamente la presencia de `.cascade-harness/` y usará sus workflows.

Ejemplos de comandos que Cascade usará:
- `/harness-install` - Instala el Harness desde GitHub en el proyecto actual
- `/harness-check` - Verifica que el Harness está configurado correctamente y MCP servers activos
- `/harness-context` - Captura estado actual del proyecto usando MCP filesystem
- `/harness-validate` - Ejecuta loop de validación con linter, tests y Playwright E2E
- `/harness-learn` - Guarda patrones aprendidos en MCP memory de Windsurf
- `/harness-recall` - Recupera patrones de MCP memory de Windsurf
- `/harness-progress` - Documenta avances y lecciones aprendidas en PROGRESS.md
