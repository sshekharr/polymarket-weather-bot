# One-click PRODUCTION (Windows PowerShell). Burner wallet only.
param(
    [switch]$Loop30Min,
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "  PRODUCTION / LIVE TRADING" -ForegroundColor Red
Write-Host "  Real money - burner wallet ONLY" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""
Write-Host "Use a NEW burner wallet and small pUSD only." -ForegroundColor Yellow
Write-Host ""

$setupEnv = Join-Path $RepoRoot "scripts\setup-env.cmd"
cmd /c "`"$setupEnv`""
if ($LASTEXITCODE -ne 0) { exit 1 }

$confirm = Read-Host "Type YES to continue with LIVE trading"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Gray
    exit 0
}

$preflight = Join-Path $RepoRoot "scripts\security-preflight.cmd"
cmd /c "`"$preflight`" --require-env"
if ($LASTEXITCODE -ne 0) { exit 1 }

$dockerInit = Join-Path $RepoRoot "scripts\docker-init-data.ps1"
if (Test-Path $dockerInit) {
    powershell -NoProfile -ExecutionPolicy Bypass -File $dockerInit
}

if (-not $SkipInstall) {
    Write-Host ""
    Write-Host "==> Installing dependencies..." -ForegroundColor Cyan
    if (Test-Path (Join-Path $RepoRoot "package-lock.json")) {
        npm.cmd ci
    } else {
        npm.cmd install
    }
    if ($LASTEXITCODE -ne 0) { exit 1 }
    cmd /c "`"$preflight`" --require-env"
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

Write-Host ""
Write-Host "==> Building..." -ForegroundColor Cyan
npm.cmd run build
if ($LASTEXITCODE -ne 0) { exit 1 }

$dataSim = Join-Path $RepoRoot "data\simulation.json"
if (Test-Path $dataSim) {
    $env:SIMULATION_FILE = $dataSim
}

Write-Host ""
if ($Loop30Min) {
    Write-Host "==> LIVE loop every 30 min (Ctrl+C to stop)..." -ForegroundColor Red
    npm.cmd run trade
} else {
    Write-Host "==> LIVE single run..." -ForegroundColor Red
    npm.cmd run execute
}

Write-Host ""
Write-Host "Done." -ForegroundColor Gray
