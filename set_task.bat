@echo off
REM Ensure script is running with admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

setlocal

REM Define variables
set "script_dir=%~dp0"
set "task_name=AutoConnectNjupt"

REM Generate task XML configuration
set "xml_file=%script_dir%task.xml"
(
echo ^<?xml version="1.0" encoding="UTF-16"?^>
echo ^<Task xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task" version="1.2"^>
echo   ^<RegistrationInfo^>
echo     ^<Author^>Aiden^</Author^>
echo   ^</RegistrationInfo^>
echo   ^<Triggers^>
echo     ^<EventTrigger^>
echo       ^<Enabled^>true^</Enabled^>
echo       ^<Subscription^>^&lt;QueryList^&gt;^&lt;Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"^&gt;^&lt;Select Path="Microsoft-Windows-NetworkProfile/Operational"^&gt;*^[System^[Provider[@Name='Microsoft-Windows-NetworkProfile'] and EventID=10000^]]^&lt;/Select^&gt;^&lt;/Query^&gt;^&lt;/QueryList^&gt;^</Subscription^>
echo     ^</EventTrigger^>
echo   ^</Triggers^>
echo   ^<Actions Context="Author"^>
echo     ^<Exec^>
echo       ^<Command^>%script_dir%auto_connect_njupt.bat^</Command^>
echo     ^</Exec^>
echo   ^</Actions^>
echo ^</Task^>
) > "%xml_file%"

REM Delete and create task
schtasks /delete /tn "%task_name%" /f
schtasks /create /tn "%task_name%" /xml "%xml_file%" /f

REM Clean up
del /f /q "%xml_file%"
endlocal
