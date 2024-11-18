@echo off
REM Check if script is running in "hide" mode
if "%1"=="hide" goto CmdBegin
start mshta vbscript:createobject("wscript.shell").run("""%~0"" hide",0)(window.close)&&exit

:CmdBegin
setlocal enabledelayedexpansion

REM Get the currently connected WiFi name
for /f "tokens=2 delims=:" %%A in ('netsh wlan show interfaces ^| findstr /r /c:" SSID"') do (
    set "wifi_name=%%A"
)

REM Remove leading spaces from WiFi name
for /f "tokens=* delims= " %%A in ("%wifi_name%") do (
    set "wifi_name=%%A"
)

REM Validate the WiFi name and enable/disable probing for unsupported networks
if "%wifi_name%" neq "NJUPT" if "%wifi_name%" neq "NJUPT-CMCC" if "%wifi_name%" neq "NJUPT-CHINANET" (
    set "key=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
    REG ADD %key% /v EnableActiveProbing /d 1 /f /t REG_DWORD
    timeout /t 10
    REG ADD %key% /v EnableActiveProbing /d 0 /f /t REG_DWORD
    exit
)

REM Format WiFi name for config matching
set "wifi_name=[%wifi_name%]"
set "in_session=0"
set "config_path=%~dp0config.ini"

REM Parse the config file to find users for the current WiFi network
for /f "usebackq tokens=1,* delims=" %%A in ("%config_path%") do (
    set "line=%%A"

    REM Check if the current line matches the WiFi name
    if "!line!"=="!wifi_name!" (
        set "in_session=1"
    ) else if "!line:~0,1!"=="[" (
        set "in_session=0"
    )

    REM Process user entries if in the correct session
    if !in_session!==1 if "!line:~0,7!"=="users[]" (
        for /f "tokens=3,4 delims= " %%B in ("%%A") do (
            set "username=%%B"
            if "!wifi_name!"=="[NJUPT-CMCC]" (
                set "username=!username!@cmcc"
            ) else if "!wifi_name!"=="[NJUPT-CHINANET]" (
                set "username=!username!@njxy"
            )
            set "password=%%C"
            set "url=https://p.njupt.edu.cn:802/eportal/portal/login?user_account=!username!&user_password=!password!"
            
            REM Send login request and check response
            for /f "tokens=2 delims=,} " %%i in ('curl -v "!url!" --ssl-no-revoke ^| findstr /c:"\"msg\""') do (
                set "msg=%%i"
                echo !msg!

                REM Exit if login succeeds
                if "!msg:~7,5!"=="AC999" (exit)
                if "!msg:~7,6!"=="Portal" (exit)
            )
        )
    )
)

REM Output error message if login fails
echo Login failed. Please check your config format, username, and password.
pause
