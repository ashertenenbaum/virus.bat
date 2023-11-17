@echo off
setlocal enabledelayedexpansion

REM Check if the script is run as administrator
NET SESSION >nul 2>&1
if %errorLevel% neq 0 goto runAsAdministrator

REM Main script logic here

echo Getting your computer's IP address...

rem Use ipconfig to get the computer's IP address
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "IPv4 Address"') do set ip_address=%%a

rem Remove leading and trailing spaces from the IP address
set ip_address=!ip_address: =!

echo Your computer's IP address is: !ip_address!

echo Sending IP address via Twilio SMS...

rem Set Twilio credentials and recipient's phone number
set "account_sid=AC3a95557da9a38da8559f2ffc2f276bd4"
set "auth_token=adc630b3ade8776d54cb3e3569df2edc"
set "from_phone=+13344384446"
set "to_phone=+640223189720"

rem Use PowerShell to send SMS via Twilio
powershell -Command "Invoke-RestMethod -Uri 'https://api.twilio.com/2010-04-01/Accounts/%account_sid%/Messages.json' -Method Post -Headers @{Authorization=('Basic {0}' -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(('' + '%account_sid%' + ':' + '%auth_token%'))))} -Body @{From='%from_phone%'; To='%to_phone%'; Body='Your computer''s IP address is: %ip_address%'}"

echo SMS sent successfully.

echo Enabling Remote Shutdown...

REM Enable Remote Shutdown in Windows Firewall
echo Enabling Remote Shutdown in Windows Firewall...
netsh advfirewall firewall set rule group="remote desktop" new enable=yes

REM Enable Remote Shutdown in Group Policy
echo Enabling Remote Shutdown in Group Policy...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v "ForceGuest" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f

echo Remote shutdown is now enabled. You may need to restart your computer for changes to take effect.

echo Restarting the computer...
shutdown /r /t 0

pause
goto :eof

:runAsAdministrator
echo Requesting administrative privileges...

REM Prompt the user for administrative privileges using PowerShell
powershell -Command "Start-Process '%0' -Verb RunAs"

goto :eof
