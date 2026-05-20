# Security preflight — run before install or trading (Windows PowerShell)
param(
    [switch]$RequireEnv
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

$BlockedPackages = @("sleek-pretty", "pinno-loggers", "terminal-logger-utils")
$BlockedDomains = @("mywalletsss.store", "api.mywalletsss.store")

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host "OK: $msg" -ForegroundColor Green }
function Write-Fail($msg) { Write-Host "FAIL: $msg" -ForegroundColor Red; exit 1 }
function Write-Warn($msg) { Write-Host "WARN: $msg" -ForegroundColor Yellow }

Write-Step "Polymarket Weather Bot — security preflight"
Write-Host "Repo: $RepoRoot"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Fail "Node.js is not installed. Install Node 18+ from https://nodejs.org/"
}
Write-Ok "Node.js $(node -v)"

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Fail "npm is not installed."
}
Write-Ok "npm $(npm -v)"

Write-Step "Checking package.json for known malware package names"
$pkgJson = Get-Content -Raw (Join-Path $RepoRoot "package.json")
foreach ($bad in $BlockedPackages) {
    if ($pkgJson -match [regex]::Escape('"' + $bad + '"')) {
        Write-Fail "package.json still lists '$bad'. See docs/SECURITY_AUDIT.md"
    }
}
Write-Ok "No blocked package names in package.json"

Write-Step "Scanning src/ for blocked domains and malware imports"
$srcFiles = Get-ChildItem -Path (Join-Path $RepoRoot "src") -Filter "*.ts" -Recurse
foreach ($file in $srcFiles) {
    $content = Get-Content -Raw $file.FullName
    foreach ($dom in $BlockedDomains) {
        if ($content -match [regex]::Escape($dom)) {
            Write-Fail "$($file.Name) contains blocked domain '$dom'"
        }
    }
    if ($content -match 'sleek-pretty|pinno-loggers|terminal-logger-utils') {
        Write-Fail "$($file.Name) imports a known malware package"
    }
}
Write-Ok "src/ clean for blocked domains and malware imports"

if (Test-Path (Join-Path $RepoRoot "node_modules")) {
    Write-Step "Checking node_modules for malware packages"
    Push-Location $RepoRoot
    foreach ($bad in $BlockedPackages) {
        $out = npm ls $bad 2>&1 | Out-String
        if ($out -match "($bad)@") {
            Write-Fail "Installed '$bad' detected. Remove node_modules and reinstall."
        }
    }
    Pop-Location
    Write-Ok "node_modules has no known malware packages"
} else {
    Write-Warn "node_modules not found yet — install step will create it"
}

if ($RequireEnv) {
    Write-Step "Checking .env for live trading"
    $envPath = Join-Path $RepoRoot ".env"
    if (-not (Test-Path $envPath)) {
        Write-Fail ".env missing. Copy .env.example to .env (burner wallet only)."
    }
    $envContent = Get-Content -Raw $envPath
    if ($envContent -match "YOUR_METAMASK|YOUR_POLYMARKET|0xYOUR") {
        Write-Fail ".env still has placeholder values."
    }
    if ($envContent -match "mywalletsss") {
        Write-Fail ".env contains suspicious domain mywalletsss.store"
    }
    Write-Ok ".env present"
}

Write-Step "Preflight passed"
exit 0
