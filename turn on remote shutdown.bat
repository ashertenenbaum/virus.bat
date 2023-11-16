@echo off
setlocal enabledelayedexpansion

echo This batch file will attempt to enable remote shutdown.

rem Enable Remote Shutdown in Windows Firewall
echo Enabling Remote Shutdown in Windows Firewall...
netsh advfirewall firewall set rule group="Remote Shutdown" new enable=yes

rem Enable Remote Shutdown in Group Policy
echo Enabling Remote Shutdown in Group Policy...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v "ForceGuest" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f

echo Remote shutdown is now enabled. You may need to restart your computer for changes to take effect.

pause
