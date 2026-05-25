# Architecture

## Overview

The Cascade Engineering Harness is a modular, stack-agnostic system that implements the 4 pillars of an Engineering Harness, integrated with Windsurf MCP servers:

```
.cascade-harness/
├── workflows/           # Flow Awareness & Orchestration
├── patterns/            # Learned patterns (local backup)
├── memory/              # Persistent state (local backup)
└── Documentation       # README, INSTALL, USAGE, etc.
```

**Windsurf MCP Integration:**
- `filesystem` MCP - File access and operations
- `memory` MCP - Cross-project pattern persistence
- `playwright` MCP - E2E testing
- `sequential-thinking` MCP - Complex reasoning

## Component Interaction

```
User Request
    ↓
Cascade (LLM)
    ↓
┌─────────────────────────────────────┐
│         Harness Orchestration        │
│  (workflows: task-start, validate)   │
└─────────────────────────────────────┘
    ↓                    ↓                    ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Flow       │  │   Tool       │  │   Context    │
│  Awareness   │  │  Invocation  │  │   Indexing   │
│ (context)    │  │ (Windsurf MCP)│  │ (filesystem) │
└──────────────┘  └──────────────┘  └──────────────┘
    ↓                    ↓                    ↓
┌─────────────────────────────────────┐
│         Memory & Patterns            │
│  (Windsurf MCP memory + local backup)│
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│      Validation & Auto-Correction   │
│  (linter, tests, Playwright E2E)    │
└─────────────────────────────────────┘
    ↓
Result (validated code)
```

## Pillar Implementation

### 1. Flow Awareness

**Components:**
- `workflows/harness-context.md` - Captures project state
- `workflows/harness-task-start.md` - Orchestrates context loading
- Windsurf `filesystem` MCP - File access
- Windsurf `sequential-thinking` MCP - Context analysis
- `memory/snapshots/` - Local backup of snapshots

**Data Flow:**
```
Git state + Recent files + Stack detection
    ↓
Snapshot JSON (local + MCP memory)
    ↓
Cascade uses sequential-thinking for analysis
    ↓
Context inference for task execution
```

### 2. Tool Invocation (Windsurf MCP)

**Components:**
- Windsurf `filesystem` MCP - File operations
- Windsurf `memory` MCP - Pattern persistence
- Windsurf `playwright` MCP - E2E testing
- Windsurf `sequential-thinking` MCP - Complex reasoning
- Direct shell commands - Stack-specific operations

**Data Flow:**
```
Cascade intention (e.g., "run tests")
    ↓
Direct command execution (npm test, pytest, etc.)
    ↓
Or MCP tool invocation (Playwright for E2E)
    ↓
Result returned to Cascade
```

### 3. Fast Context Indexing

**Components:**
- Windsurf `filesystem` MCP - File access
- Grep tool - Content search
- Language detection - File categorization
- Pattern matching - Semantic search

**Data Flow:**
```
Project files
    ↓
Filesystem MCP access
    ↓
Grep search for patterns
    ↓
Relevant files returned to Cascade
```

### 4. Linter & Test Loop

**Components:**
- `workflows/harness-validate.md` - Validation execution
- `workflows/harness-autocorrect.md` - Correction loop
- Direct commands - Linter and unit tests
- Windsurf `playwright` MCP - E2E tests
- Windsurf `sequential-thinking` MCP - Error analysis
- Windsurf `memory` MCP - Validation reports
- `memory/validation-reports/` - Local backup

**Data Flow:**
```
Code changes
    ↓
Linter (direct command) → Unit tests (direct command)
    ↓
E2E tests (Playwright MCP) if enabled
    ↓
Validation report (MCP memory + local)
    ↓
If FAIL → Auto-correct with sequential-thinking
    ↓
Re-validate until PASS or max retries
```

## Auto-Improvement System

### Pattern Learning

**Components:**
- `workflows/harness-learn.md` - Pattern extraction
- `workflows/harness-recall.md` - Pattern retrieval
- Windsurf `memory` MCP - Cross-project pattern storage
- Windsurf `sequential-thinking` MCP - Pattern analysis
- `patterns/{domain}/` - Local backup
- `memory/pattern-index.json` - Local index

**Data Flow:**
```
Successful code changes
    ↓
Domain detection (auth, api, database, etc.)
    ↓
Extract code snippets + context
    ↓
Store in Windsurf MCP memory (cross-project)
    ↓
Local backup in patterns/{domain}/
    ↓
Future tasks can recall from any project
```

## Memory Structure

### Local Backup (project-specific)
```
.cascade-harness/memory/
├── snapshots/           # Context snapshots
│   └── context_YYYYMMDD_HHMMSS.json
├── validation-reports/  # Validation results
│   └── report_YYYYMMDD_HHMMSS.json
├── test-failures/       # Test failure logs
│   └── latest.json
├── recall-sessions/     # Pattern recall sessions
│   └── recall_YYYYMMDD_HHMMSS.json
└── pattern-index.json   # Local pattern index
```

### Windsurf MCP Memory (cross-project)
- Patterns with tags: `harness, pattern, [domain], learned`
- Validation reports with tags: `harness, validation, report, quality`
- Lessons learned with tags: `harness, autocorrection, lesson, [type]`
- Context snapshots with tags: `harness, context, snapshot, project-state`
- Persistent across all projects using the Harness

## Windsurf MCP Integration

### Filesystem MCP
- Used for reading project files
- Used for searching file contents
- Used for accessing project structure
- No custom implementation needed - uses Windsurf's built-in

### Memory MCP
- Used for storing patterns (persistent between projects)
- Used for storing validation reports
- Used for storing lessons learned
- Used for recalling patterns from any project
- No custom implementation needed - uses Windsurf's built-in

### Playwright MCP
- Used for E2E testing in validation loop
- Used for visual verification of web applications
- Used for browser automation
- No custom implementation needed - uses Windsurf's built-in

### Sequential-Thinking MCP
- Used for complex reasoning and analysis
- Used for pattern analysis in learn/recall
- Used for error analysis in auto-correction
- Used for task type detection
- No custom implementation needed - uses Windsurf's built-in

## Workflow Execution Model

### Standard Workflow

```powershell
1) Variables definition
2) Sequential command execution
3) // turbo marks auto-runnable commands
4) JSON output for Cascade consumption
5) Error handling with $ErrorActionPreference
6) Cascade uses MCP tools as needed
```

### Cascade Integration

```
User request
    ↓
Cascade detects .cascade-harness/
    ↓
Loads workflows from .windsurf/workflows/
    ↓
Executes workflow steps
    ↓
Invokes Windsurf MCP tools as needed
    ↓
Returns result to user
```

## Extensibility Points

1. **New Stacks**: Add stack detection in workflows
2. **New Workflows**: Create in .windsurf/workflows/
3. **New Pattern Domains**: Add categorization logic in harness-learn.md
4. **Custom Validation**: Modify harness-validate.md
5. **External Integrations**: Use additional Windsurf MCP servers

## Security Considerations

- Windsurf MCP servers run with configured permissions
- Shell commands execute in project context
- No external network calls by default
- MCP memory respects Windsurf's security model
- Git operations respect user permissions

## Performance Characteristics

- **File Access**: O(1) via filesystem MCP
- **Pattern Search**: O(p) where p = patterns in MCP memory
- **Validation**: O(1) for linter, O(t) for tests, O(e) for E2E
- **Pattern Recall**: O(p) where p = patterns in domain
- **Memory**: Local snapshots ~10KB, MCP memory managed by Windsurf

## Limitations

- Requires Windsurf with MCP servers configured
- PowerShell required for workflows (Windows)
- Pattern learning is heuristic-based
- Auto-correction limited to common errors
- Dependent on Windsurf MCP server availability
- Cross-project pattern sharing requires same Windsurf instance
