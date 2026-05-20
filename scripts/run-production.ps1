# One-click PRODUCTION mode: real Polymarket CLOB orders — BURNER WALLET ONLY
param(
    [switch]$Loop30Min,
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

Write-Host "`n========================================" -ForegroundColor Red
Write-Host "  PRODUCTION / LIVE TRADING" -ForegroundColor Red
Write-Host "  Real money — burner wallet ONLY" -ForegroundColor Red
Write-Host "========================================`n" -ForegroundColor Red

Write-Host "You must:" -ForegroundColor Yellow
Write-Host "  1. Use a NEW burner wallet — never your main MetaMask" -ForegroundColor Yellow
Write-Host "  2. Fund only small pUSD you can afford to lose" -ForegroundColor Yellow
Write-Host "  3. Have run LOCAL signal mode first (scripts\run-local.bat)" -ForegroundColor Yellow
Write-Host "  4. Never have run an OLD copy with sleek-pretty (rotate keys if unsure)`n" -ForegroundColor Yellow

$confirm = Read-Host "Type YES to continue with LIVE trading"
if ($confirm -ne "YES") {
    Write-Host "Cancelled." -ForegroundColor Gray
    exit 0
}

& (Join-Path $RepoRoot "scripts\security-preflight.ps1") -RequireEnv

if (-not $SkipInstall) {
    Write-Host "`n==> Installing dependencies..." -ForegroundColor Cyan
    if (Test-Path (Join-Path $RepoRoot "package-lock.json")) {
        npm ci
    } else {
        npm install
    }
    if ($LASTEXITCODE -ne 0) { exit 1 }
    & (Join-Path $RepoRoot "scripts\security-preflight.ps1") -RequireEnv
}

Write-Host "`n==> Building..." -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) { exit 1 }

if ($Loop30Min) {
    Write-Host "`n==> LIVE loop every 30 minutes (Ctrl+C to stop)..." -ForegroundColor Red
    npm run trade
} else {
    Write-Host "`n==> LIVE single run (one pass of orders)..." -ForegroundColor Red
    npm run execute
}

Write-Host "`nDone. Press any key to close..." -ForegroundColor Gray
if ($Host.Name -eq "ConsoleHost") { $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
