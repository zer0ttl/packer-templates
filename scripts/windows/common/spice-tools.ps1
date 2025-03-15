# Install Spice Tools
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

# Spice Tools
Write-Host "Downloading spice-guest-tools-latest.exe..."
$SpiceAgentURL = "https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe"
Invoke-WebRequest -Uri $SpiceAgentURL -OutFile "$env:temp\spice-guest-tools-latest.exe"

Write-Host "Importing Red Hat Certificate..."
if (Test-Path -Path "F:\Balloon\2k22\amd64\blnsvr.exe") {
    $cert = (Get-AuthenticodeSignature "F:\Balloon\2k22\amd64\blnsvr.exe").SignerCertificate
} else {
    $cert = (Get-AuthenticodeSignature "D:\Balloon\2k22\amd64\blnsvr.exe").SignerCertificate
}

# $cert = (Get-AuthenticodeSignature "F:\Balloon\2k22\amd64\blnsvr.exe").SignerCertificate
Write-Host "Adding redhat.cer to certificate store..."
[System.IO.File]::WriteAllBytes("${env:TEMP}\redhat.cer", $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
certutil.exe -f -addstore "TrustedPublisher" "${env:TEMP}\redhat.cer"

Write-Host "Installing spice-guest-tools-latest.exe..."
Start-Process -FilePath "$env:temp\spice-guest-tools-latest.exe" -ArgumentList "/S" -Wait

# Because "-Wait" does not seem to work
# Do {
#     start-sleep -Milliseconds 500
# } Until ($proc.HasExited)

Write-Host "Starting service: Spice Guest Tools"
Start-Service -Name "*vd*"
Start-Service -Name "*spice*"

Write-Host "Installation of Spice Tools complete"

# Reset the autologon count.
# Reference: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0