# Customization Guide

## Adapting to Your Stack

### Adding Support for New Languages

Edit `.cascade-harness/mcp-servers/project-tools/index.js`:

Add to `LANGUAGE_EXTENSIONS` in filesystem-index:
```javascript
const LANGUAGE_EXTENSIONS = {
  // ... existing
  yourlang: [".yl", ".yourlang"],
};
```

Add to `detect_stack` in project-tools:
```javascript
const checks = [
  // ... existing
  { file: "yourlang.config", stack: "YourLang", manager: "yourpkg" },
];
```

Add to `run_tests`:
```javascript
if (stacks.some(s => s.stack === "YourLang")) {
  command = pattern ? `yourlang test ${pattern}` : "yourlang test";
}
```

### Custom Workflows

Create custom workflows in `.windsurf/workflows/`:

```markdown
---
description: Your custom workflow
---

# Custom Workflow

## 1) Your step
```powershell
# Your PowerShell command
```

## 2) Another step
// turbo
```powershell
# Auto-runnable command
```
```

### Custom Validation Rules

Edit `.cascade-harness/workflows/harness-validate.md` to add:
- Custom linter commands
- Additional test frameworks
- Project-specific validation rules

### Pattern Categories

Add custom domains in `.cascade-harness/workflows/harness-learn.md`:

```powershell
if ($recentChanges -match "your-domain-keyword") {
    $domain = "your-custom-domain";
}
```

## Project-Specific Configuration

Create `.cascade-harness/config.json`:

```json
{
  "project": {
    "name": "your-project",
    "type": "web|api|cli|library",
    "stack": "nodejs|python|rust|go"
  },
  "validation": {
    "maxRetries": 5,
    "fixLinter": true,
    "runTests": true,
    "customCommands": {
      "beforeCommit": ["npm run type-check", "npm run audit"]
    }
  },
  "patterns": {
    "autoLearn": true,
    "domains": ["authentication", "api", "database"]
  },
  "mcp": {
    "projectTools": {
      "enabled": true,
      "customCommands": {
        "deploy": "npm run deploy"
      }
    },
    "filesystemIndex": {
      "enabled": true,
      "excludeDirs": ["custom-exclude-dir"]
    }
  }
}
```

## Integrating External Tools

### Add Jira Integration

Create `.cascade-harness/mcp-servers/jira/index.js`:

```javascript
// MCP server for Jira API
// Expose tools: create_ticket, update_ticket, search_tickets
```

### Add Slack Notifications

Create `.cascade-harness/mcp-servers/slack/index.js`:

```javascript
// MCP server for Slack API
// Expose tools: send_notification, update_status
```

### Add Custom Linters

Edit `harness-validate.md` to add your linter:

```powershell
if (Test-Path "custom-linter.config") {
    custom-linter run 2>&1 | Tee-Object -Variable customLinterOutput;
}
```

## Memory Management

### Clean Old Snapshots

```powershell
# Keep only last 30 days
Get-ChildItem .cascade-harness/memory/snapshots | 
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | 
    Remove-Item
```

### Export Patterns

```powershell
# Export patterns for sharing
Compress-Archive -Path .cascade-harness/patterns -DestinationPath patterns-backup.zip
```

### Import Patterns

```powershell
# Import patterns from another project
Expand-Archive -Path patterns-backup.zip -DestinationPath .cascade-harness/patterns
```

## Performance Tuning

### Limit Index Size

Edit `filesystem-index/index.js`:

```javascript
const MAX_INDEX_SIZE = 10000; // Max files to index
const MAX_CONTENT_SIZE = 3000; // Max content per file
```

### Adjust Validation Frequency

Edit `harness-validate.md` to skip certain validations:

```powershell
$RunTests = $false; # Skip tests for quick iterations
```

### Cache MCP Results

MCP servers can implement caching to avoid repeated operations.

## Team Collaboration

### Share Harness Config

Commit `.cascade-harness/` to your repository (except `memory/`):

```gitignore
# .gitignore
.cascade-harness/memory/
.cascade-harness/mcp-servers/*/node_modules/
```

### Sync Patterns Across Team

Use a shared patterns repository:

```json
{
  "patterns": {
    "remoteRepo": "https://github.com/your-org/cascade-patterns",
    "syncOnStart": true
  }
}
```

## Monitoring

### Track Harness Usage

Add logging to workflows:

```powershell
$logEntry = @{
    timestamp = Get-Date -Format "o";
    workflow = "harness-validate";
    result = "PASS";
};
Add-Content .cascade-harness/memory/usage.log ($logEntry | ConvertTo-Json);
```

### Quality Metrics

Analyze validation reports:

```powershell
$reports = Get-ChildItem .cascade-harness/memory/validation-reports;
$passRate = ($reports | Where-Object { 
    (Get-Content $_ | ConvertFrom-Json).overall -eq "PASS" 
}).Count / $reports.Count;
Write-Host "Pass rate: $passRate";
```
