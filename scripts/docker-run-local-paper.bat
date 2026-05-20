@echo off
cd /d "%~dp0.."
echo Docker PAPER mode - virtual money only
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0docker-init-data.ps1"
docker compose --profile paper up --build --abort-on-container-exit
if errorlevel 1 pause
