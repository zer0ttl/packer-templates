# Some fixes
#

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting common fixes"

trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Write-Host
    Write-Host 'Sleeping for 60m to give you time to look around the virtual machine before self-destruction...'
    Start-Sleep -Seconds (60*60)
    Exit 1
}

Write-Host "Some fixes.."

# set global EULA acceptance for SysInternals tools
$regPath = "HKCU:\Software\Sysinternals"
if (Test-Path -Path $regPath -ErrorAction SilentlyContinue) {
    Set-ItemProperty -Path $regPath -Name "EulaAccepted" -Value 1 -Force -ErrorAction SilentlyContinue
} else {
    New-Item -Path $regPath -Name "EulaAccepted" -Value 1 -Force -ErrorAction SilentlyContinue
}

# Show file extensions in Explorer
# %SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 -Force

# Show Hidden Files in Explorer
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1 -Force

# Enable QuickEdit Mode
# %SystemRoot%\System32\reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f
Set-ItemProperty -Path "HKCU:\Console" -Name QuickEdit -Value 1 -Force

# Zero Hibernation File
# %SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\" -Name "HibernateFileSizePercent" -Value 0 -Force

# Disable Hibernation Mode
# %SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\" -Name "HibernateEnabled" -Value 0 -Force

# Disable UAC
# %SystemRoot%\System32\reg.exe ADD HKLM\Software\Microsoft\Windows\CurrentVersion\policies\system\ /v EnableLUA /t REG_DWORD /d 0 /f
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system\" -Name "EnableLUA" -Value 0 -Force

# Allow ICMP ping in firewall
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol=icmpv6:8,any dir=in action=allow

# Set Powershell as default line
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# New Network Window Off
# %SystemRoot%\System32\reg.exe add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f
# New-Item -Path "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force
reg.exe add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f

# Reset the autologon count.
# Reference: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

Write-Host "Finished fixes.."
Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Completed common fixes"
