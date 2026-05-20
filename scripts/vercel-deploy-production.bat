@echo off
cd /d "%~dp0.."
echo.
echo ========================================
echo   VERCEL PRODUCTION deploy
echo   WARNING: Health API only — NOT live trading
echo ========================================
echo.
echo This script deploys monitoring endpoints only.
echo For REAL trading use: scripts\docker-run-production.bat
echo   or scripts\run-production.bat
echo.
set /p CONFIRM=Type YES to deploy health API to Vercel production: 
if /i not "%CONFIRM%"=="YES" exit /b 0
call npx vercel@latest --prod --yes
echo.
echo Verify: https://YOUR-PROJECT.vercel.app/api/health
echo Never store private keys in Vercel project settings.
pause
