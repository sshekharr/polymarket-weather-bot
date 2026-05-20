# One-click LOCAL mode: security checks, install, build, dry-run (no real orders)
# Optional: -Paper  for virtual paper trading (still no on-chain orders)
param(
    [switch]$Paper,
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  LOCAL / SAFE MODE (no real money)" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

$preflight = Join-Path $RepoRoot "scripts\security-preflight.cmd"
cmd /c "`"$preflight`""
if ($LASTEXITCODE -ne 0) { exit 1 }

if (-not $SkipInstall) {
    Write-Host "`n==> Installing dependencies..." -ForegroundColor Cyan
    if (Test-Path (Join-Path $RepoRoot "package-lock.json")) {
        npm.cmd ci
    } else {
        npm.cmd install
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm install failed. If you see certificate errors, fix TLS/proxy or see docs/GETTING_STARTED.md" -ForegroundColor Red
        exit 1
    }
    $preflight = Join-Path $RepoRoot "scripts\security-preflight.cmd"
cmd /c "`"$preflight`""
if ($LASTEXITCODE -ne 0) { exit 1 }
}

Write-Host "`n==> Building TypeScript..." -ForegroundColor Cyan
npm.cmd run build
if ($LASTEXITCODE -ne 0) { exit 1 }

if ($Paper) {
    Write-Host "`n==> Starting PAPER mode (virtual money only)..." -ForegroundColor Yellow
    npm.cmd run paper
} else {
    Write-Host "`n==> Starting SIGNAL mode (read-only scan, no orders)..." -ForegroundColor Yellow
    Write-Host "    No .env private key required for signal-only.`n" -ForegroundColor Gray
    npm.cmd run signal
}

Write-Host "`nDone. Press any key to close..." -ForegroundColor Gray
if ($Host.Name -eq "ConsoleHost") { $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
