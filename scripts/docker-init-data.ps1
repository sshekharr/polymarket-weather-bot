# Ensures ./data/simulation.json exists as a FILE (Docker bind-mount fix)
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

$dataDir = Join-Path $RepoRoot "data"
$simFile = Join-Path $dataDir "simulation.json"
$legacySim = Join-Path $RepoRoot "simulation.json"

# Docker creates a directory if simulation.json did not exist when mounting a single file
if (Test-Path $legacySim) {
    if ((Get-Item $legacySim).PSIsContainer) {
        Write-Host "Removing mistaken simulation.json directory (Docker mount artifact)..." -ForegroundColor Yellow
        Remove-Item $legacySim -Recurse -Force
    }
}

New-Item -ItemType Directory -Force -Path $dataDir | Out-Null

if (-not (Test-Path $simFile)) {
    $default = @'
{
  "balance": 1000,
  "starting_balance": 1000,
  "positions": {},
  "trades": [],
  "total_trades": 0,
  "wins": 0,
  "losses": 0,
  "peak_balance": 1000
}
'@
    Set-Content -Path $simFile -Value $default -Encoding UTF8
    Write-Host "Created data/simulation.json" -ForegroundColor Green
}
