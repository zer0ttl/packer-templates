<#
    .DESCRIPTION
    Enables Windows Remote Management on Windows builds.
#>

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting WinRM setup"

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

# Set network connections profile to Private mode.
Write-Output 'Setting the network connection profiles to Private...'
$connectionProfiles = Get-NetConnectionProfile
ForEach ($cf in $connectionProfiles)
{
   if ($cf.InterfaceAlias -ne 'Private') {
        Start-Sleep -Seconds 10
        Set-NetConnectionProfile -InterfaceAlias $cf.InterfaceAlias -NetworkCategory 'Private'
   }
}

# Set the Windows Remote Management configuration.
Write-Output 'Setting the Windows Remote Management configuration...'
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Allow Windows Remote Management in the Windows Firewall.
Write-Output 'Allowing Windows Remote Management in the Windows Firewall...'
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow

# Reset the autologon count.
# Reference: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Completed WinRM setup"
