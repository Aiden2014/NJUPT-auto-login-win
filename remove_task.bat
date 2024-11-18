@echo off
REM Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

setlocal

REM Define task name
set "task_name=AutoConnectNjupt"

REM Enable active probing in the registry
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet /v EnableActiveProbing /t REG_DWORD /d 1 /f

REM Delete the task if it exists
schtasks /delete /tn "%task_name%" /f
endlocal