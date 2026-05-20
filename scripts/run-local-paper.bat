@echo off
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-local.ps1" -Paper
if errorlevel 1 pause
