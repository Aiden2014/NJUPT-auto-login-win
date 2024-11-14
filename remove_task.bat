@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)
setlocal

set task_name=AutoConnectNjupt

REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet /v EnableActiveProbing /d 1 /f /t REG_DWORD
schtasks /delete /tn %task_name%