@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)
setlocal

set script_dir=%~dp0
set task_name=AutoConnectNjupt

echo ^<?xml version="1.0" encoding="UTF-16"?^> > "%~dp0task.xml"
echo ^<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^> >> "%~dp0task.xml"
echo   ^<RegistrationInfo^> >> "%~dp0task.xml"
echo     ^<Author^>Aiden^</Author^> >> "%~dp0task.xml"
echo     ^<URI^>\AutoConnectNjupt^</URI^> >> "%~dp0task.xml"
echo   ^</RegistrationInfo^> >> "%~dp0task.xml"
echo   ^<Principals^> >> "%~dp0task.xml"
echo     ^<Principal id="Author"^> >> "%~dp0task.xml"
echo       ^<LogonType^>InteractiveToken^</LogonType^> >> "%~dp0task.xml"
echo       ^<RunLevel^>HighestAvailable^</RunLevel^> >> "%~dp0task.xml"
echo     ^</Principal^> >> "%~dp0task.xml"
echo   ^</Principals^> >> "%~dp0task.xml"
echo   ^<Triggers^> >> "%~dp0task.xml"
echo     ^<EventTrigger^> >> "%~dp0task.xml"
echo       ^<Enabled^>true^</Enabled^> >> "%~dp0task.xml"
echo       ^<Subscription^>^&lt;QueryList^&gt;^&lt;Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"^&gt;^&lt;Select Path="Microsoft-Windows-NetworkProfile/Operational"^&gt;*^[System^[Provider[@Name='Microsoft-Windows-NetworkProfile'] and EventID=10000^]]^&lt;/Select^&gt;^&lt;/Query^&gt;^&lt;/QueryList^&gt;^</Subscription^> >> "%~dp0task.xml"
echo     ^</EventTrigger^> >> "%~dp0task.xml"
echo   ^</Triggers^> >> "%~dp0task.xml"
echo   ^<Settings^> >> "%~dp0task.xml"
echo     ^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^> >> "%~dp0task.xml"
echo     ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^> >> "%~dp0task.xml"
echo     ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^> >> "%~dp0task.xml"
echo     ^<AllowHardTerminate^>true^</AllowHardTerminate^> >> "%~dp0task.xml"
echo     ^<StartWhenAvailable^>false^</StartWhenAvailable^> >> "%~dp0task.xml"
echo     ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^> >> "%~dp0task.xml"
echo     ^<IdleSettings^> >> "%~dp0task.xml"
echo       ^<StopOnIdleEnd^>true^</StopOnIdleEnd^> >> "%~dp0task.xml"
echo       ^<RestartOnIdle^>false^</RestartOnIdle^> >> "%~dp0task.xml"
echo     ^</IdleSettings^> >> "%~dp0task.xml"
echo     ^<AllowStartOnDemand^>true^</AllowStartOnDemand^> >> "%~dp0task.xml"
echo     ^<Enabled^>true^</Enabled^> >> "%~dp0task.xml"
echo     ^<Hidden^>false^</Hidden^> >> "%~dp0task.xml"
echo     ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^> >> "%~dp0task.xml"
echo     ^<WakeToRun^>false^</WakeToRun^> >> "%~dp0task.xml"
echo     ^<ExecutionTimeLimit^>PT72H^</ExecutionTimeLimit^> >> "%~dp0task.xml"
echo     ^<Priority^>7^</Priority^> >> "%~dp0task.xml"
echo     ^<RestartOnFailure^> >> "%~dp0task.xml"
echo       ^<Interval^>PT1M^</Interval^> >> "%~dp0task.xml"
echo       ^<Count^>3^</Count^> >> "%~dp0task.xml"
echo     ^</RestartOnFailure^> >> "%~dp0task.xml"
echo   ^</Settings^> >> "%~dp0task.xml"
echo   ^<Actions Context="Author"^> >> "%~dp0task.xml"
echo     ^<Exec^> >> "%~dp0task.xml"
echo       ^<Command^>%script_dir%auto_connect_njupt.bat^</Command^> >> "%~dp0task.xml"
echo     ^</Exec^> >> "%~dp0task.xml"
echo   ^</Actions^> >> "%~dp0task.xml"
echo ^</Task^> >> "%~dp0task.xml"

schtasks /delete /tn %task_name%
schtasks /create /f /tn %task_name% /xml "%~dp0task.xml"

del /f /q "%~dp0task.xml"

endlocal
