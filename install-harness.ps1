# Cascade Engineering Harness Installation Script
# Run this script in any project to install the Harness from GitHub

param(
    [string]$GitHubRepo = "https://github.com/tu-usuario/cascade-harness.git",
    [switch]$Force = $false
)

$ErrorActionPreference = 'Stop'

Write-Host "=== CASCADE ENGINEERING HARNESS INSTALLATION ===" -ForegroundColor Cyan
Write-Host ""

# Check if .cascade-harness already exists
if (Test-Path ".cascade-harness") {
    if (-not $Force) {
        Write-Host ".cascade-harness already exists." -ForegroundColor Yellow
        $response = Read-Host "Overwrite? (y/N)"
        if ($response -ne "y") {
            Write-Host "Installation cancelled." -ForegroundColor Red
            exit 0
        }
    }
    Write-Host "Removing existing .cascade-harness..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force ".cascade-harness"
}

# Clone from GitHub
Write-Host "Cloning Harness from GitHub..." -ForegroundColor Green
git clone $GitHubRepo .cascade-harness

if (-not $?) {
    Write-Host "Failed to clone from GitHub." -ForegroundColor Red
    exit 1
}

# Create .windsurf/workflows if it doesn't exist
if (-not (Test-Path ".windsurf")) {
    New-Item -ItemType Directory -Path ".windsurf" -Force | Out-Null
}

if (-not (Test-Path ".windsurf\workflows")) {
    New-Item -ItemType Directory -Path ".windsurf\workflows" -Force | Out-Null
}

# Copy workflows
Write-Host "Copying workflows to .windsurf/workflows/..." -ForegroundColor Green
Copy-Item -Path ".cascade-harness\workflows\*" -Destination ".windsurf\workflows\" -Recurse -Force

# Create required directories
Write-Host "Creating required directories..." -ForegroundColor Green
$requiredDirs = @(
    ".cascade-harness\patterns",
    ".cascade-harness\memory\snapshots",
    ".cascade-harness\memory\validation-reports",
    ".cascade-harness\memory\test-failures",
    ".cascade-harness\memory\recall-sessions",
    ".cascade-harness\memory\check-reports",
    ".cascade-harness\memory\progress-backups"
)

foreach ($dir in $requiredDirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

Write-Host ""
Write-Host "=== INSTALLATION COMPLETE ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart Windsurf to load the workflows"
Write-Host "2. Run: /harness-check to verify installation"
Write-Host "3. Start using Cascade with the Harness enabled"
Write-Host ""
Write-Host "For manual installation from a local copy:" -ForegroundColor Yellow
Write-Host "Copy .cascade-harness/ folder to your project root"
Write-Host "Copy workflows to .windsurf/workflows/"
