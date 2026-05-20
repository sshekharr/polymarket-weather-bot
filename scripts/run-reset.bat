@echo off
cd /d "%~dp0.."
if exist "data\simulation.json" set "SIMULATION_FILE=%CD%\data\simulation.json"
call npm.cmd run reset
pause
