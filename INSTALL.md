# Installation Guide

## Quick Start

### Option 1: Install from GitHub (Recommended)

1. **Run the installation script:**
```powershell
# In your project root
.\install-harness.ps1
```

Or download and run from GitHub:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rogelioGuerrero/cascade-harness/main/install-harness.ps1" -OutFile "install-harness.ps1"
.\install-harness.ps1
```

2. **Configure Global Rules (Critical Step)**

The Harness uses a two-tier strategy. Before using workflows, configure the global rules that govern Cascade's behavior:

- **Open Windsurf Settings:** Press `Ctrl` + `,` (or `Cmd` + `,` on Mac)
- **Search for:** "Global Rules" or "Custom Instructions"
- **Paste the content:** Copy the entire content of `GLOBAL_RULES.md` from this repository
- **Save:** Apply the settings

**Alternative if Ctrl+, doesn't work:**
- Go to `File` → `Preferences` → `Settings`
- Or press `Ctrl` + `Shift` + `P` and search for "Settings"

**Why this matters:** Global rules define the 4-step execution lifecycle that Cascade must follow for ALL tasks. They are the "governance" layer that ensures quality across all projects.

3. **Restart Windsurf** to load the workflows and global rules

4. **Run `/harness-check`** to verify installation

### Option 2: Manual Installation

1. **Copy the Harness to your project**
```bash
# From any location, copy the harness folder
cp -r d:\proyectoBolt\.cascade-harness <your-project-root>/
```

2. **Copy workflows to Windsurf**
```bash
# Copy workflows to .windsurf/workflows/
cp -r .cascade-harness/workflows/* .windsurf/workflows/
```

3. **Verify Windsurf MCP servers are configured**

The Harness uses the MCP servers already configured in Windsurf:
- `filesystem` - For file access
- `memory` - For pattern persistence
- `playwright` - For E2E testing
- `sequential-thinking` - For complex reasoning

Check your Windsurf MCP configuration (`~/.codeium/windsurf/mcp_config.json`) to ensure these servers are enabled.

4. **Restart Windsurf** to load the workflows

### Option 3: Install via Cascade Workflow

Ask Cascade to execute `/harness-install` to install the Harness from GitHub automatically.

## Verification

Test that the Harness is working:

1. Run `/harness-check` to verify configuration and MCP servers
2. Run `/harness-context` to capture project state
3. Run `/harness-validate` to test validation loop
4. Check that `.cascade-harness/memory/` contains snapshots

## Stack Support

The Harness automatically detects and works with:
- Node.js (npm/pnpm/yarn)
- Python (pip/poetry)
- Rust (cargo)
- Go (go mod)
- Java (Maven/Gradle)
- Ruby (bundler)
- PHP (composer)

## Troubleshooting

**Workflows not found:**
- Ensure `.windsurf/workflows/` exists in your project
- Copy workflows from `.cascade-harness/workflows/` to `.windsurf/workflows/`

**MCP servers not available:**
- Check your Windsurf MCP configuration
- Ensure filesystem, memory, playwright, and sequential-thinking are enabled
- Restart Windsurf after configuration changes

**PowerShell errors on Windows:**
- Ensure execution policy allows scripts: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**Pattern memory not persisting:**
- Check that MCP memory server is enabled in Windsurf
- Verify you have sufficient memory allocation configured
