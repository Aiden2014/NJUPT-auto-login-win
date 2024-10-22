@echo off
if "%1"=="hide" goto CmdBegin
start mshta vbscript:createobject("wscript.shell").run("""%~0"" hide",0)(window.close)&&exit
:CmdBegin
setlocal enabledelayedexpansion

REM Get the currently connected WiFi name
for /f "tokens=2 delims=:" %%A in ('netsh wlan show interfaces ^| findstr /r /c:" SSID"') do (
    set "wifi_name=%%A"
)

REM Remove leading spaces
for /f "tokens=* delims= " %%A in ("%wifi_name%") do (
    set "wifi_name=%%A"
)

if "%wifi_name%" neq "NJUPT" if "%wifi_name%" neq "NJUPT-CMCC" if "%wifi_name%" neq "NJUPT-CHINANET" exit

set "wifi_name=[%wifi_name%]"
set in_session=0
set "config_path=%~dp0config.ini"

for /f "tokens=1,* delims=" %%A in (%config_path%) do (
    set "line=%%A"
    if "!line!"=="!wifi_name!" (
        set in_session=1
    ) else if "!line:~0,1!"=="[" (
        set in_session=0
    )
    if !in_session!==1 if "!line:~0,7!"=="users[]" (
        for /f "tokens=3,4 delims= " %%B in ("%%A") do (
            set "username=%%B"
            if "!wifi_name!"=="[NJUPT-CMCC]" (
                set "username=!username!@cmcc"
            ) else if "!wifi_name!"=="[NJUPT-CHINANET]" (
                set "username=!username!@njxy"
            )
            set "password=%%C"
            set url="https://p.njupt.edu.cn:802/eportal/portal/login?user_account=!username!&user_password=!password!"
            for /f "tokens=2 delims=,} " %%i in ('curl -v !url! --ssl-no-revoke ^| findstr /c:"\"msg\""') do (
                set msg=%%i
                echo !msg!
                if "!msg:~7,5!" == "AC999" (exit) else if "!msg:~7,6!" == "Portal" (exit)
            )
        )
    )
)

echo login fail, please check your config format, username and password
pause

