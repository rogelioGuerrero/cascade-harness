# Usage Guide

## Core Workflows

### 1. Task Start - Begin any task with context
```
/harness-task-start
```
**What it does:**
- Captures current project state using MCP filesystem
- Detects technology stack
- Loads relevant patterns from MCP memory of Windsurf
- Uses sequential-thinking MCP for task analysis

**When to use:** Before starting any significant task (feature, bugfix, refactor)

### 2. Context Capture - Understand project state
```
/harness-context
```
**What it does:**
- Captures Git state (branch, status, recent commits)
- Lists recently modified files using MCP filesystem
- Detects project stack
- Saves snapshot to local memory and MCP memory of Windsurf
- Uses sequential-thinking MCP for context analysis

**When to use:** When you need Cascade to understand the current project state

### 3. Validation Loop - Ensure code quality
```
/harness-validate
```
**What it does:**
- Runs linter for detected stack (direct commands)
- Attempts auto-fix for linting errors
- Runs unit tests if available (direct commands)
- Can run E2E tests with Playwright MCP
- Generates validation report
- Saves report to MCP memory of Windsurf

**When to use:** After making code changes, before committing

### 4. Auto-Correction - Fix validation failures
```
/harness-autocorrect
```
**What it does:**
- Reads latest validation report from MCP memory
- Uses sequential-thinking MCP for error analysis
- Uses MCP filesystem to read problematic files
- Guides Cascade through correction loop
- Re-validates until success or max retries
- Saves lessons learned to MCP memory

**When to use:** When validation fails and you want automatic fixing

### 5. Learn Patterns - Store successful implementations
```
/harness-learn
```
**What it does:**
- Analyzes recent successful changes
- Categorizes by domain (auth, api, database, etc.)
- Extracts code snippets
- Stores pattern in MCP memory of Windsurf (persistent between projects)
- Uses sequential-thinking MCP for pattern analysis
- Creates backup in local patterns/

**When to use:** After completing a successful feature or fix

### 6. Recall Patterns - Apply learned patterns
```
/harness-recall -Domain <domain> -Query <query>
```
**What it does:**
- Searches patterns in MCP memory of Windsurf by domain
- Uses sequential-thinking MCP for pattern analysis
- Loads relevant patterns from any previous project
- Presents patterns to Cascade for application
- Saves applied patterns as new memories

**When to use:** When starting a task similar to previous work

## Windsurf MCP Integration

The Harness uses these MCP servers already configured in Windsurf:

### Filesystem MCP
- Used for reading project files
- Used for searching file contents
- Used for accessing project structure

### Memory MCP
- Used for storing patterns (persistent between projects)
- Used for storing validation reports
- Used for storing lessons learned
- Used for recalling patterns from any project

### Playwright MCP
- Used for E2E testing in validation loop
- Used for visual verification of web applications
- Used for browser automation

### Sequential-Thinking MCP
- Used for complex reasoning and analysis
- Used for pattern analysis in learn/recall
- Used for error analysis in auto-correction
- Used for task type detection

## Example Workflows

### Starting a new feature
1. User: "Add authentication to the API"
2. Cascade: Runs `/harness-task-start`
3. Cascade: Detects stack (Node.js/Express) using MCP filesystem
4. Cascade: Runs `/harness-recall -Domain authentication` searching MCP memory
5. Cascade: Uses sequential-thinking to analyze patterns
6. Cascade: Applies learned auth patterns from previous projects
7. Cascade: Implements feature
8. Cascade: Runs `/harness-validate` with Playwright E2E tests
9. Cascade: Auto-corrects if needed using sequential-thinking
10. Cascade: Runs `/harness-learn` to store new patterns in MCP memory

### Fixing a bug
1. User: "Fix the database connection error"
2. Cascade: Runs `/harness-context` using MCP filesystem
3. Cascade: Searches for database-related files using MCP filesystem
4. Cascade: Uses sequential-thinking to analyze error patterns
5. Cascade: Applies fix
6. Cascade: Runs `/harness-validate`
7. Cascade: Runs tests to verify

### Refactoring
1. User: "Refactor the user service"
2. Cascade: Runs `/harness-task-start`
3. Cascade: Uses MCP filesystem to index project structure
4. Cascade: Uses sequential-thinking to identify refactoring opportunities
5. Cascade: Applies changes
6. Cascade: Runs `/harness-validate`
7. Cascade: Ensures tests still pass

## Memory Structure

### Local Backup (project-specific)
```
.cascade-harness/memory/
├── snapshots/           # Context snapshots
├── validation-reports/  # Validation results
├── test-failures/       # Test failure logs
├── recall-sessions/     # Pattern recall sessions
└── pattern-index.json   # Index of local patterns
```

### MCP Memory of Windsurf (cross-project)
- Patterns stored with tags: `harness, pattern, [domain], learned`
- Validation reports with tags: `harness, validation, report, quality`
- Lessons learned with tags: `harness, autocorrection, lesson, [type]`
- Persistent across all projects using the Harness

## Pattern Domains

Patterns are categorized by domain:
- `authentication` - Auth, login, sessions, JWT
- `api` - Routes, controllers, endpoints
- `database` - Models, schemas, migrations
- `testing` - Tests, specs, fixtures
- `configuration` - Config, env, settings
- `frontend` - UI components, views, pages
- `infrastructure` - Docker, deployment, CI/CD
- `general` - Other patterns

## Best Practices

1. **Always start with `/harness-task-start`** for significant tasks
2. **Run `/harness-validate` before committing** any changes
3. **Use `/harness-learn` after successful work** to build pattern library in MCP memory
4. **Use `/harness-recall`** to leverage patterns from previous projects
5. **Review MCP memory** to understand what Cascade has learned across projects
6. **Review validation reports** to track quality over time
7. **Let Cascade use sequential-thinking** for complex analysis tasks
