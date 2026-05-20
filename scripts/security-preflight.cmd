@echo off
setlocal EnableExtensions
cd /d "%~dp0.."
set "REQUIRE_ENV=0"
if /i "%~1"=="--require-env" set "REQUIRE_ENV=1"

echo.
echo ==^> Polymarket Weather Bot - security preflight
echo Repo: %CD%

where node >nul 2>&1
if errorlevel 1 (
  echo FAIL: Node.js not installed. https://nodejs.org/
  exit /b 1
)
for /f "delims=" %%v in ('node -v') do echo OK: Node.js %%v

where npm.cmd >nul 2>&1
if errorlevel 1 (
  echo FAIL: npm not installed.
  exit /b 1
)
for /f "delims=" %%v in ('npm.cmd -v') do echo OK: npm %%v

echo.
echo ==^> Checking package.json for malware package names
findstr /i /c:"\"sleek-pretty\"" package.json >nul && goto :badpkg
findstr /i /c:"\"pinno-loggers\"" package.json >nul && goto :badpkg
findstr /i /c:"\"terminal-logger-utils\"" package.json >nul && goto :badpkg
echo OK: package.json clean
goto :afterpkg
:badpkg
echo FAIL: package.json lists a blocked malware package.
exit /b 1
:afterpkg

echo.
echo ==^> Checking src for blocked domains
findstr /s /i /m "mywalletsss sleek-pretty pinno-loggers terminal-logger-utils" src\*.ts >nul 2>&1
if not errorlevel 1 (
  echo FAIL: src contains blocked string. See docs/SECURITY_AUDIT.md
  exit /b 1
)
echo OK: src/ clean

if "%REQUIRE_ENV%"=="1" (
  echo.
  echo ==^> Checking .env for live trading
  if not exist ".env" (
    echo FAIL: .env missing. Copy .env.example to .env
    exit /b 1
  )
  findstr /i "YOUR_METAMASK YOUR_POLYMARKET 0xYOUR" .env >nul 2>&1
  if not errorlevel 1 (
    echo FAIL: .env still has placeholder values
    exit /b 1
  )
  findstr /i "mywalletsss" .env >nul 2>&1
  if not errorlevel 1 (
    echo FAIL: .env contains suspicious domain
    exit /b 1
  )
  echo OK: .env present
)

echo.
echo ==^> Preflight passed
exit /b 0
