@echo off
cd /d "%~dp0.."
echo.
echo ========================================
echo   DOCKER PRODUCTION - REAL MONEY
echo   Burner wallet only. Requires .env
echo ========================================
echo.
if not exist ".env" (
  echo ERROR: Create .env from .env.example first.
  pause
  exit /b 1
)
set /p CONFIRM=Type YES to run LIVE trading in Docker: 
if /i not "%CONFIRM%"=="YES" (
  echo Cancelled.
  exit /b 0
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0docker-init-data.ps1"
docker compose --profile production up --build
if errorlevel 1 pause
