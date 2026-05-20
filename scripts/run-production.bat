@echo off
setlocal EnableExtensions
cd /d "%~dp0.."

echo.
echo ========================================
echo   PRODUCTION / LIVE TRADING
echo   Real money - burner wallet ONLY
echo ========================================
echo.
echo You must use a NEW burner wallet and small pUSD only.
echo.

call "%~dp0setup-env.cmd"
if errorlevel 1 (
  echo.
  echo Fix .env and run this script again.
  pause
  exit /b 1
)

echo.
set /p CONFIRM=Type YES to continue with LIVE trading: 
if /i not "%CONFIRM%"=="YES" (
  echo Cancelled.
  pause
  exit /b 0
)

call "%~dp0security-preflight.cmd" --require-env
if errorlevel 1 pause & exit /b 1

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0docker-init-data.ps1" 2>nul
if exist data\simulation.json set "SIMULATION_FILE=%CD%\data\simulation.json"

echo.
echo ==^> Installing dependencies...
if exist package-lock.json (
  call npm.cmd ci
) else (
  call npm.cmd install
)
if errorlevel 1 (
  echo npm install failed.
  pause
  exit /b 1
)

call "%~dp0security-preflight.cmd" --require-env
if errorlevel 1 pause & exit /b 1

echo.
echo ==^> Building TypeScript...
call npm.cmd run build
if errorlevel 1 pause & exit /b 1

echo.
echo Starting LIVE trading - real Polymarket orders...
call npm.cmd run execute
echo.
pause
