# Mockingbird Setup Script for Windows
# =====================================
# Run this script to set up Mockingbird

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Mockingbird Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Claude Code is installed
Write-Host "Checking Claude Code installation..." -ForegroundColor Yellow
try {
    $claudeVersion = claude --version 2>&1
    Write-Host "[OK] Claude Code is installed: $claudeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Claude Code is not installed." -ForegroundColor Red
    Write-Host "Please install from: https://claude.ai/download" -ForegroundColor Yellow
    exit 1
}

# Check for .env file
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectPath = Split-Path -Parent $scriptPath
$envPath = Join-Path $projectPath ".env"
$envExamplePath = Join-Path $projectPath ".env.example"

Write-Host ""
Write-Host "Checking environment configuration..." -ForegroundColor Yellow

if (Test-Path $envPath) {
    Write-Host "[OK] .env file exists" -ForegroundColor Green

    # Check if API key is set
    $envContent = Get-Content $envPath -Raw
    if ($envContent -match "OPENROUTER_API_KEY=sk-or-") {
        Write-Host "[OK] OpenRouter API key appears to be configured" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] OpenRouter API key may not be set correctly" -ForegroundColor Yellow
        Write-Host "Please edit .env and add your API key from https://openrouter.ai/keys" -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] .env file not found. Creating from template..." -ForegroundColor Yellow

    if (Test-Path $envExamplePath) {
        Copy-Item $envExamplePath $envPath
        Write-Host "[OK] Created .env file from template" -ForegroundColor Green
        Write-Host ""
        Write-Host "IMPORTANT: Edit .env and add your OpenRouter API key" -ForegroundColor Red
        Write-Host "Get your key from: https://openrouter.ai/keys" -ForegroundColor Yellow
    } else {
        Write-Host "[ERROR] .env.example not found" -ForegroundColor Red
        exit 1
    }
}

# Check outputs directory
$outputsPath = Join-Path $projectPath "outputs"
if (-not (Test-Path $outputsPath)) {
    New-Item -ItemType Directory -Path $outputsPath -Force | Out-Null
    Write-Host "[OK] Created outputs directory" -ForegroundColor Green
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Make sure your OpenRouter API key is in .env" -ForegroundColor White
Write-Host "2. Run 'claude' in this directory to start Mockingbird" -ForegroundColor White
Write-Host "3. Claude will guide you through Figma authentication" -ForegroundColor White
Write-Host ""
Write-Host "For help, see docs/SETUP_GUIDE.md" -ForegroundColor Gray
