@echo off
cd /d "%~dp0.."
echo.
echo ========================================
echo   VERCEL - Preview / health API only
echo   NO live trading on Vercel
echo ========================================
echo.
where npx >nul 2>&1
if errorlevel 1 (
  echo Install Node.js first: https://nodejs.org/
  pause
  exit /b 1
)
echo Deploying health endpoints (no wallet keys)...
call npx vercel@latest --yes
echo.
echo After deploy, open:
echo   /api/health
echo   /api/connectivity-check
echo.
echo Do NOT add POLYMARKET_PRIVATE_KEY to Vercel environment variables.
pause
