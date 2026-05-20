# Security preflight - run before install or trading (Windows PowerShell)
param(
    [switch]$RequireEnv
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

$BlockedPackages = @(
    "sleek-pretty",
    "pinno-loggers",
    "terminal-logger-utils"
)
$BlockedDomains = @(
    "mywalletsss.store",
    "api.mywalletsss.store"
)

function Write-Step([string]$msg) {
    Write-Host ""
    Write-Host "==> $msg" -ForegroundColor Cyan
}
function Write-Ok([string]$msg) {
    Write-Host "OK: $msg" -ForegroundColor Green
}
function Write-Fail([string]$msg) {
    Write-Host "FAIL: $msg" -ForegroundColor Red
    exit 1
}
function Write-Warn([string]$msg) {
    Write-Host "WARN: $msg" -ForegroundColor Yellow
}

Write-Step "Polymarket Weather Bot - security preflight"
Write-Host "Repo: $RepoRoot"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Fail "Node.js is not installed. Install Node 18+ from https://nodejs.org/"
}
Write-Ok ("Node.js " + (node -v))

if (-not (Get-Command npm.cmd -ErrorAction SilentlyContinue)) {
    Write-Fail "npm is not installed."
}
Write-Ok ("npm " + (npm.cmd -v))

Write-Step "Checking package.json for known malware package names"
$pkgJson = Get-Content -Raw (Join-Path $RepoRoot "package.json")
foreach ($bad in $BlockedPackages) {
    $pattern = '"' + $bad + '"'
    if ($pkgJson.Contains($pattern)) {
        Write-Fail ("package.json still lists " + $bad + ". See docs/SECURITY_AUDIT.md")
    }
}
Write-Ok "No blocked package names in package.json"

Write-Step "Scanning src/ for blocked domains and malware imports"
$srcDir = Join-Path $RepoRoot "src"
$srcFiles = Get-ChildItem -Path $srcDir -Filter "*.ts" -Recurse
foreach ($file in $srcFiles) {
    $content = Get-Content -Raw $file.FullName
    foreach ($dom in $BlockedDomains) {
        if ($content.Contains($dom)) {
            Write-Fail ($file.Name + " contains blocked domain " + $dom)
        }
    }
    if ($content -match "sleek-pretty|pinno-loggers|terminal-logger-utils") {
        Write-Fail ($file.Name + " imports a known malware package")
    }
}
Write-Ok "src/ clean for blocked domains and malware imports"

$nodeModules = Join-Path $RepoRoot "node_modules"
if (Test-Path $nodeModules) {
    Write-Step "Checking node_modules for malware packages"
    Push-Location $RepoRoot
    foreach ($bad in $BlockedPackages) {
        $out = & npm.cmd ls $bad 2>&1 | Out-String
        $needle = $bad + "@"
        if ($out.Contains($needle)) {
            Write-Fail ("Installed " + $bad + " detected. Delete node_modules and reinstall.")
        }
    }
    Pop-Location
    Write-Ok "node_modules has no known malware packages"
}
else {
    Write-Warn "node_modules not found yet - install step will create it"
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
    if ($envContent.Contains("mywalletsss")) {
        Write-Fail ".env contains suspicious domain mywalletsss.store"
    }
    Write-Ok ".env present"
}

Write-Step "Preflight passed"
exit 0
