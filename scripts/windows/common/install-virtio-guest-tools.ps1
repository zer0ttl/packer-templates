# Install Virtio Guest Tools
#

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting VirtIO guest-tools installation"

trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Write-Host
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
    $process = Start-Process -FilePath "F:\virtio-win-guest-tools.exe" -ArgumentList $argList -Wait -PassThru
} else {
    $process = Start-Process -FilePath "D:\virtio-win-guest-tools.exe" -ArgumentList $argList -Wait -PassThru
}

if ($process.ExitCode -notin @(0, 1641, 3010)) {
    throw "VirtIO guest-tools installer failed with exit code $($process.ExitCode)"
}

Write-Host "Starting service: QEMU-GA"
Set-Service -Name "qemu-ga" -StartupType Automatic
Start-Service -Name "qemu-ga"

Write-Host "Installation of Virtio Windows Guest Tools complete"

# Reset the autologon count.
# Reference: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Completed VirtIO guest-tools installation"
