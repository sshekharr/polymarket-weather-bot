@echo off
cd /d "%~dp0.."
echo.
echo ========================================
echo   DOCKER LOCAL - no real money
echo ========================================
echo.
where docker >nul 2>&1
if errorlevel 1 (
  echo Docker is not installed. Install Docker Desktop:
  echo https://www.docker.com/products/docker-desktop/
  pause
  exit /b 1
)
docker compose --profile local up --build --abort-on-container-exit
if errorlevel 1 pause
