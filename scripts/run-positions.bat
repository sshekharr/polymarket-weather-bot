@echo off
cd /d "%~dp0.."
if exist "data\simulation.json" (
  set "SIMULATION_FILE=%CD%\data\simulation.json"
  echo Using paper state: data\simulation.json
) else if exist "simulation.json" (
  echo Using paper state: simulation.json
) else (
  echo No simulation file yet. Run paper mode first.
)
call npm.cmd run build
if errorlevel 1 goto :err
call npm.cmd run positions
goto :done
:err
echo Build or positions failed.
pause
exit /b 1
:done
pause
