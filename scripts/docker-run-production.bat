@echo off
cd /d "%~dp0.."
echo.
echo ========================================
echo   DOCKER PRODUCTION - REAL MONEY
echo   Burner wallet only
echo ========================================
echo.

call "%~dp0setup-env.cmd"
if errorlevel 1 (
  echo Fix .env and run again.
  pause
  exit /b 1
)

set /p CONFIRM=Type YES to run LIVE trading in Docker: 
if /i not "%CONFIRM%"=="YES" (
  echo Cancelled.
  exit /b 0
)

call "%~dp0security-preflight.cmd" --require-env
if errorlevel 1 pause & exit /b 1

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0docker-init-data.ps1"
docker compose --profile production up --build
if errorlevel 1 pause
