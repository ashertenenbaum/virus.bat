@echo off

REM Check if the script is run as administrator
NET SESSION >nul 2>&1
if %errorLevel% neq 0 goto runAsAdministrator

REM Main script logic here

echo Configuring Remote Registry and WMI...

REM Enable Remote Registry
echo Enabling Remote Registry...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "Start" /t REG_DWORD /d 2 /f

REM Allow WMI through Windows Firewall
echo Allowing WMI through Windows Firewall...
netsh advfirewall firewall set rule group="Windows Management Instrumentation (WMI)" new enable=yes

echo Configuration complete. You may need to restart your computer for changes to take effect.

pause
goto :eof

:runAsAdministrator
echo Requesting administrative privileges...

REM Prompt the user for administrative privileges using PowerShell
powershell -Command "Start-Process '%0' -Verb RunAs"

goto :eof
