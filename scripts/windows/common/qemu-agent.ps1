# Install Virtio Guest Tools
#

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

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

# Virtio Windows Guest Tools
Write-Host "Installing Virtio Windows Guest Tools"
$argList = @(
    "/install",
    "/passive",
    "/norestart"
)
if (Test-Path -Path "F:\virtio-win-guest-tools.exe") {
    Start-Process -FilePath "F:\virtio-win-guest-tools.exe" -ArgumentList $argList
} else {
    Start-Process -FilePath "D:\virtio-win-guest-tools.exe" -ArgumentList $argList
}

# Because "-Wait" does not seem to work
# Do {
#     start-sleep -Milliseconds 500
# } Until ($proc.HasExited)

Write-Host "Starting service: QEMU-GA"
# Start-Service -Name "QEMU-GA"
Start-Service -Name "*qemu*"

Write-Host "Installation of Virtio Windows Guest Tools complete"

# Reset the autologon count.
# Reference: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0