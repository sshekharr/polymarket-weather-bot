@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0.."

echo.
echo ==^> Environment file setup (.env)

if not exist ".env.example" (
  echo FAIL: .env.example is missing from the project folder.
  exit /b 1
)

set "NEED_EDIT=0"

if not exist ".env" (
  echo .env not found - creating from .env.example...
  copy /y ".env.example" ".env" >nul
  if errorlevel 1 (
    echo FAIL: Could not create .env
    exit /b 1
  )
  echo OK: Created .env
  set "NEED_EDIT=1"
) else (
  echo OK: .env already exists
)

findstr /i /c:"YOUR_METAMASK" /c:"YOUR_POLYMARKET" /c:"0xYOUR" ".env" >nul 2>&1
if not errorlevel 1 set "NEED_EDIT=1"

if "%NEED_EDIT%"=="1" (
  echo.
  echo --------------------------------------------------------
  echo  EDIT .env BEFORE LIVE TRADING
  echo --------------------------------------------------------
  echo  1. Use a NEW burner MetaMask account - not your main wallet
  echo  2. POLYMARKET_PRIVATE_KEY = 64 hex chars ^(with or without 0x^)
  echo  3. POLYMARKET_PROXY_WALLET_ADDRESS = from polymarket.com/settings
  echo  4. Fund only small pUSD you can afford to lose
  echo  5. Save the file and close Notepad when done
  echo --------------------------------------------------------
  echo.
  echo Opening .env in Notepad...
  start /wait notepad ".env"
  echo.
)

findstr /i /c:"YOUR_METAMASK" /c:"YOUR_POLYMARKET" /c:"0xYOUR" ".env" >nul 2>&1
if not errorlevel 1 (
  echo FAIL: .env still contains placeholder text ^(YOUR_METAMASK / YOUR_POLYMARKET^).
  echo Edit .env with real burner-wallet values, then run this script again.
  exit /b 1
)

findstr /i "^POLYMARKET_PRIVATE_KEY=" ".env" >nul 2>&1
if errorlevel 1 (
  echo FAIL: POLYMARKET_PRIVATE_KEY is missing in .env
  exit /b 1
)

findstr /i "^POLYMARKET_PROXY_WALLET_ADDRESS=" ".env" >nul 2>&1
if errorlevel 1 (
  echo FAIL: POLYMARKET_PROXY_WALLET_ADDRESS is missing in .env
  exit /b 1
)

echo OK: .env is present and placeholders are replaced
exit /b 0
