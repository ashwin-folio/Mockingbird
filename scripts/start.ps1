# Mockingbird Quick Start for Windows
# ====================================
# Double-click this script or run from PowerShell

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectPath = Split-Path -Parent $scriptPath

# Change to project directory
Set-Location $projectPath

Write-Host ""
Write-Host "Starting Mockingbird..." -ForegroundColor Cyan
Write-Host "Project directory: $projectPath" -ForegroundColor Gray
Write-Host ""

# Check for .env
$envPath = Join-Path $projectPath ".env"
if (-not (Test-Path $envPath)) {
    Write-Host "[WARNING] .env file not found!" -ForegroundColor Yellow
    Write-Host "Run scripts/setup.ps1 first or copy .env.example to .env" -ForegroundColor Yellow
    Write-Host ""
}

# Start Claude Code
claude
